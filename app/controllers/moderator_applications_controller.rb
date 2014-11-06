class ModeratorApplicationsController < ApplicationController
  before_action :set_moderator_application, only: [:show, :edit, :update, :destroy]

  # GET /moderator_applications
  # GET /moderator_applications.json
  def index
    @moderator_applications = ModeratorApplication.all
  end

  # GET /moderator_applications/1
  # GET /moderator_applications/1.json
  def show
  end

  # GET /moderator_applications/new
  def new
    @moderator_application = ModeratorApplication.new
  end

  # GET /moderator_applications/1/edit
  def edit
  end

  # POST /moderator_applications
  # POST /moderator_applications.json
  def create
    @moderator_application = ModeratorApplication.new(moderator_application_params)

    respond_to do |format|
      if @moderator_application.save
        format.html { redirect_to @moderator_application, notice: 'Moderator application was successfully created.' }
        format.json { render :show, status: :created, location: @moderator_application }
      else
        format.html { render :new }
        format.json { render json: @moderator_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moderator_applications/1
  # PATCH/PUT /moderator_applications/1.json
  def update
    respond_to do |format|
      if @moderator_application.update(moderator_application_params)
        format.html { redirect_to @moderator_application, notice: 'Moderator application was successfully updated.' }
        format.json { render :show, status: :ok, location: @moderator_application }
      else
        format.html { render :edit }
        format.json { render json: @moderator_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moderator_applications/1
  # DELETE /moderator_applications/1.json
  def destroy
    @moderator_application.destroy
    respond_to do |format|
      format.html { redirect_to moderator_applications_url, notice: 'Moderator application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moderator_application
      @moderator_application = ModeratorApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moderator_application_params
      params[:moderator_application]
    end
end
