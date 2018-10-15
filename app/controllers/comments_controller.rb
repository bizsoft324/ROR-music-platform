class CommentsController < ApplicationController
  def create
    @comment = track.comment_threads.build(comment_params)

    if @comment.save
      SlackNotifierJob.perform_later(message: t('.comment_left',
                     name: current_user.username,
                     track_title: track.title,
                     track_user: track.user.username,
                     body: @comment.body))

      if @comment.body.include?('@')
        comment = @comment.body.split('@')
        comment.shift
        users = []
        comment.each do |user|
          user = user.split(' ').first
          users << user
        end
        users.each do |user|
          user[0] = ''
          user = User.find_by_username(user)
        end
      end

      Tracker.track(current_user.name,
                    'Create Critique',
                    critiques_on_track: track.critiques_count)

      respond_to do |format|
        format.js
        format.json { render json: { comment: @comment } }
      end
    else
      respond_to do |format|
        format.js
        format.json { render json: { errors: @comment.errors.as_json }, status: 420 }
      end
    end
  end

  def destroy
    owner_comment.destroy!
  end

  private

  def track
    @track ||= Track.find(params[:track_id])
  end

  def owner_comment
    @owner_comment ||= current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
