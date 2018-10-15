require 'rails_helper'

RSpec.describe BeatsController, type: :controller do
  before(:all) do
    @user = create(:mock_user)
    @user2 = create(:mock_user)
    @user3 = create(:mock_user)
    @user2 = create(:mock_user)
    @user3 = create(:mock_user)
    @track1 = create(:track, user_id: @user.id, title: 'track_1')
    @track2 = create(:track, user_id: @user.id, title: 'track_2')
    @track3 = create(:track, user_id: @user.id, title: 'track_3')
    @track4 = create(:track, user_id: @user.id, title: 'track_4')
    @track5 = create(:track, user_id: @user.id, title: 'track_5')
    @no_ratings_track = create(:track, user_id: @user.id, title: 'no_ratings')

    @genre1 = create(:genre, name: 'hip-hop')
    @genre2 = create(:genre, name: 'east-coast')
    @genre3 = create(:genre, name: 'experimental')

    @subgenre1 = create(:subgenre, name: 'Alternative', genre_id: @genre1.id)
    @subgenre2 = create(:subgenre, name: 'Boom Bap', genre_id: @genre1.id)
    @subgenre3 = create(:subgenre, name: 'East Coast', genre_id: @genre2.id)

    create(:rating, user_id: @user.id, track_id: @track1.id, status: 0)
    create(:rating, user_id: @user.id, track_id: @track2.id, status: 0)
    create(:rating, user_id: @user.id, track_id: @track3.id, status: 0)
    create(:rating, user_id: @user.id, track_id: @track4.id, status: 0)
    create(:rating, user_id: @user.id, track_id: @track5.id, status: 0)
    create(:rating, user_id: @user2.id, track_id: @track1.id, status: 1)
    create(:rating, user_id: @user2.id, track_id: @track2.id, status: 1)
    create(:rating, user_id: @user2.id, track_id: @track3.id, status: 1)
    create(:rating, user_id: @user2.id, track_id: @track4.id, status: 1)
    create(:rating, user_id: @user2.id, track_id: @track5.id, status: 1)
    create(:rating, user_id: @user3.id, track_id: @track1.id, status: 2)
    create(:rating, user_id: @user3.id, track_id: @track2.id, status: 2)
    create(:rating, user_id: @user3.id, track_id: @track3.id, status: 2)
    create(:rating, user_id: @user3.id, track_id: @track4.id, status: 2)
    create(:rating, user_id: @user3.id, track_id: @track5.id, status: 2)

    @track1.genres << @genre1
    @track2.genres << @genre1
    @track3.genres << @genre2
    @track4.genres << @genre3
    @track5.genres << @genre3

    @track1.subgenres << @subgenre1
    @track2.subgenres << @subgenre1
    @track3.subgenres << @subgenre3
    @track4.subgenres << @subgenre3
    @track5.subgenres << @subgenre3

    create(:track_charted, track_id: @track1.id)
    create(:track_charted, track_id: @track1.id, week: 5)
    create(:track_charted, track_id: @track2.id, year: 2)
    create(:track_charted, track_id: @track3.id, month: 5)
  end

  def likes_filter_data
    @track1.update!(like_count: 10, dislike_count: 3)
    @track2.update!(like_count: 15, dislike_count: 2)
    @track3.update!(like_count: 11, indifferent_count: 15)
    @track4.update!(like_count: 9, indifferent_count: 9)
  end

  def indifference_filter_data
    @track1.update!(indifferent_count: 10, dislike_count: 3)
    @track2.update!(indifferent_count: 15, dislike_count: 2)
    @track3.update!(indifferent_count: 11, like_count: 15)
    @track4.update!(indifferent_count: 5, like_count: 5)
  end

  def dislikes_filter_data
    @track1.update!(dislike_count: 10, indifferent_count: 3)
    @track2.update!(dislike_count: 15, indifferent_count: 2)
    @track3.update!(dislike_count: 11, like_count: 15)
    @track4.update!(dislike_count: 4, like_count: 4)
  end

  def dislikes_with_likes_filter_data
    @track1.update!(dislike_count: 15, like_count: 8, indifferent_count: 4)
    @track2.update!(dislike_count: 14, like_count: 10, indifferent_count: 4)
    @track3.update!(dislike_count: 15, like_count: 10, indifferent_count: 100)
    @track4.update!(dislike_count: 13, like_count: 9, indifferent_count: 2)
  end

  def likes_with_indifference_filter_data
    @track1.update!(like_count: 15, indifferent_count: 8, dislike_count: 4)
    @track2.update!(like_count: 14, indifferent_count: 10, dislike_count: 4)
    @track3.update!(like_count: 15, indifferent_count: 10, dislike_count: 100)
    @track4.update!(like_count: 13, indifferent_count: 9, dislike_count: 2)
  end

  def likes_with_indifference_with_dislikes_filter_data
    @track1.update!(like_count: 20, indifferent_count: 15, dislike_count: 4)
    @track2.update!(like_count: 20, indifferent_count: 18, dislike_count: 5)
    @track3.update!(like_count: 15, indifferent_count: 30, dislike_count: 4)
    @track4.update!(like_count: 15, indifferent_count: 30, dislike_count: 6)
    @track5.update!(like_count: 30, indifferent_count: 30, dislike_count: 30)
  end

  def indifference_with_dislikes_filter_data
    @track1.update!(indifferent_count: 15, dislike_count: 8, like_count: 4)
    @track2.update!(indifferent_count: 14, dislike_count: 10, like_count: 4)
    @track3.update!(indifferent_count: 15, dislike_count: 10, like_count: 100)
    @track4.update!(indifferent_count: 13, dislike_count: 9, like_count: 2)
  end

  describe '#index' do
    context 'no filter' do
      it 'responds correctly' do
        get :index
        expect(response).to be_success
      end
    end
    context 'likes ratings filter' do
      it 'assigns proper instance variables' do
        likes_filter_data
        get :index, params: { filters: { ratings: ['like'] } }
        expect(assigns(:filtered_tracks)).to eq([@track2, @track3, @track1, @track4, @track5])
        expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
      end
      context 'with indifference' do
        it 'assigns proper instance variables' do
          likes_with_indifference_filter_data
          get :index, params: { filters: { ratings: %w[like indifferent] } }
          expect(assigns(:filtered_tracks)).to eq([@track3, @track1, @track2, @track4, @track5])
          expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
        end
        context 'with dislikes' do
          it 'assigns proper instance variables' do
            likes_with_indifference_with_dislikes_filter_data
            get :index, params: { filters: { ratings: %w[like indifferent dislike] } }
            expect(assigns(:filtered_tracks)).to eq([@track5, @track2, @track1, @track4, @track3])
            expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
          end
        end
      end
    end
    context 'indifference ratings filter' do
      it 'assigns proper instance variables' do
        indifference_filter_data
        get :index, params: { filters: { ratings: ['indifferent'] } }
        expect(assigns(:filtered_tracks)).to eq([@track2, @track3, @track1, @track4, @track5])
        expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
      end
      context 'with dislikes' do
        it 'assigns proper instance variables' do
          indifference_with_dislikes_filter_data
          get :index, params: { filters: { ratings: %w[indifferent dislike] } }
          expect(assigns(:filtered_tracks)).to eq([@track3, @track1, @track2, @track4, @track5])
          expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
        end
      end
    end
    context 'dislikes ratings filter' do
      it 'assigns proper instance variables' do
        dislikes_filter_data
        get :index, params: { filters: { ratings: ['dislike'] } }
        expect(assigns(:filtered_tracks)).to eq([@track2, @track3, @track1, @track4, @track5])
        expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
      end
      context 'with likes' do
        it 'assigns proper instance variables' do
          dislikes_with_likes_filter_data
          get :index, params: { filters: { ratings: %w[like dislike] } }
          expect(assigns(:filtered_tracks)).to eq([@track3, @track2, @track4, @track1, @track5])
          expect(assigns(:filtered_tracks)).to_not include(@no_ratings_track)
        end
      end
    end
    context 'charted' do
      it 'assigns proper instance variables' do
        @track2.update!(is_charted: true)
        @track3.update!(is_charted: true)
        @track1.update!(is_charted: true)
        get :index, params: { filters: { types: { is_charted: true } } }
        expect(assigns(:filtered_tracks)).to include(@track2, @track3, @track1)
        expect(assigns(:filtered_tracks)).to_not include(@track4, @track5)
      end
    end
    context 'samples' do
      it 'assigns proper instance variables' do
        @track2.update!(has_samples: true)
        @track3.update!(has_samples: true)
        @track1.update!(has_samples: true)
        get :index, params: { filters: { types: { has_samples: true } } }
        expect(assigns(:filtered_tracks)).to include(@track2, @track3, @track1)
        expect(assigns(:filtered_tracks)).to_not include(@track4, @track5)
      end
    end
    context 'vocals' do
      it 'assigns proper instance variables' do
        @track2.update!(has_vocals: true)
        @track3.update!(has_vocals: true)
        @track1.update!(has_vocals: true)
        get :index, params: { filters: { types: { has_vocals: true } } }
        expect(assigns(:filtered_tracks)).to include(@track2, @track3, @track1)
        expect(assigns(:filtered_tracks)).to_not include(@track4, @track5)
      end
    end
    context 'dowloadable' do
      it 'assigns proper instance variables' do
        @track2.update!(downloadable: true)
        @track3.update!(downloadable: true)
        @track1.update!(downloadable: true)
        get :index, params: { filters: { types: { downloadable: true } } }
        expect(assigns(:filtered_tracks)).to include(@track2, @track3, @track1)
        expect(assigns(:filtered_tracks)).to_not include(@track4, @track5)
      end
    end
    context 'contactable' do
      it 'assigns proper instance variables' do
        @track2.update!(contactable: true)
        @track3.update!(contactable: true)
        @track1.update!(contactable: true)
        get :index, params: { filters: { types: { contactable: true } } }
        expect(assigns(:filtered_tracks)).to include(@track2, @track3, @track1)
        expect(assigns(:filtered_tracks)).to_not include(@track4, @track5)
      end
    end
    context 'subgenres' do
      it 'assigns proper instance variables' do
        get :index, params: { filters: { subgenres: [@subgenre1.id] } }
        expect(assigns(:filtered_tracks)).to include(@track1, @track2)
        expect(assigns(:filtered_tracks)).to_not include(@track3, @track4, @track5)
      end
    end
  end
end
