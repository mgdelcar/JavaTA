class ProblemSubmissionsController < ApplicationController
  before_action :set_problem_submission, only: [:show, :edit, :update, :destroy]

  # GET /problem_submissions
  # GET /problem_submissions.json
  def index
    @problem_submissions = ProblemSubmission.all
  end

  # GET /problem_submissions/1
  # GET /problem_submissions/1.json
  def show
  end

  # GET /problem_submissions/new
  def new
    @problem_submission = ProblemSubmission.new
  end

  # GET /problem_submissions/1/edit
  def edit
  end

  # POST /problem_submissions
  # POST /problem_submissions.json
  def create
    @problem_submission = ProblemSubmission.new(problem_submission_params)

    respond_to do |format|
      if @problem_submission.save
        format.html { redirect_to @problem_submission, notice: 'Problem submission was successfully created.' }
        format.json { render :show, status: :created, location: @problem_submission }
      else
        format.html { render :new }
        format.json { render json: @problem_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problem_submissions/1
  # PATCH/PUT /problem_submissions/1.json
  def update
    respond_to do |format|
      if @problem_submission.update(problem_submission_params)
        format.html { redirect_to @problem_submission, notice: 'Problem submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem_submission }
      else
        format.html { render :edit }
        format.json { render json: @problem_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_submissions/1
  # DELETE /problem_submissions/1.json
  def destroy
    @problem_submission.destroy
    respond_to do |format|
      format.html { redirect_to problem_submissions_url, notice: 'Problem submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_submission
      @problem_submission = ProblemSubmission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_submission_params
      params.require(:problem_submission).permit(:file_relative_path, :iteration, :when, :problem_id)
    end
end
