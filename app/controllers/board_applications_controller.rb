class BoardApplicationsController < ApplicationController
  before_action :set_board_application, only: [:show, :edit, :update, :approve, :reject, :destroy]

  # GET /board_applications
  # GET /board_applications.json
  def index
    @board_applications = BoardApplication.all
  end

  # GET /board_applications/1
  # GET /board_applications/1.json
  def show
  end

  # GET /board_applications/new
  def new
    @board_application = BoardApplication.new
  end

  # GET /board_applications/1/edit
  def edit
  end

  # POST /board_applications
  # POST /board_applications.json
  def create
    @board_application = BoardApplication.new(board_application_params)
    @board_application.applier = current_user

    respond_to do |format|
      if @board_application.save
        format.html { redirect_to @board_application, notice: 'Board application was successfully created.' }
        format.json { render :show, status: :created, location: @board_application }
      else
        format.html { render :new }
        format.json { render json: @board_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /board_applications/1
  # PATCH/PUT /board_applications/1.json
  def update
    respond_to do |format|
      if @board_application.update(board_application_params)
        format.html { redirect_to @board_application, notice: 'Board application was successfully updated.' }
        format.json { render :show, status: :ok, location: @board_application }
      else
        format.html { render :edit }
        format.json { render json: @board_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    respond_to do |format|
      if @board_application.approve
        format.html { redirect_to board_applications_path }
        format.json { render :show, status: :ok, location: @board_application }
      else
        format.html { redirect_to board_applications_path }
        format.json { render json: @board_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    respond_to do |format|
      if @board_application.reject
        format.html { redirect_to board_applications_path }
        format.json { render :show, status: :ok, location: @board_application }
      else
        format.html { redirect_to board_applications_path }
        format.json { render json: @board_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /board_applications/1
  # DELETE /board_applications/1.json
  def destroy
    @board_application.destroy
    respond_to do |format|
      format.html { redirect_to board_applications_url, notice: 'Board application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board_application
      @board_application = BoardApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_application_params
      params[:board_application].permit(:name, :path, :reason, :strategy, :rule)
    end
end
