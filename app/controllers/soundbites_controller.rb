class SoundbitesController < ApplicationController
  before_action :set_soundbite, only: %i[edit update destroy]

  # GET /soundbites
  # GET /soundbites.json
  def index
    @soundbites = Soundbite.all
  end

  # GET /soundbites/new
  def new
    @soundbite = Soundbite.new
  end

  # GET /soundbites/1/edit
  def edit; end

  # POST /soundbites
  # POST /soundbites.json
  def create
    @soundbite = Soundbite.new(soundbite_params)

    respond_to do |format|
      if @soundbite.save
        format.html { redirect_to soundbites_path, notice: t('.success') }
        format.json { render :show, status: :created, location: @soundbite }
      else
        format.html { render :new }
        format.json { render json: @soundbite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soundbites/1
  # PATCH/PUT /soundbites/1.json
  def update
    respond_to do |format|
      if @soundbite.update(soundbite_params)
        format.html { redirect_to soundbites_path, notice: t('.success') }
        format.json { render :show, status: :ok, location: @soundbite }
      else
        format.html { render :edit }
        format.json { render json: @soundbite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soundbites/1
  # DELETE /soundbites/1.json
  def destroy
    @soundbite.destroy
    respond_to do |format|
      format.html { redirect_to soundbites_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_soundbite
    @soundbite = Soundbite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def soundbite_params
    params.require(:soundbite).permit(:data_start, :data_end, :comment_id, :data_url, :data_id, :data_plays, :title)
  end
end
