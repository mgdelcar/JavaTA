class SubmissionTestResultsController < ApplicationController
  before_action :set_submission_test_result, only: [:show, :edit, :update, :destroy]

  # GET /submission_test_results
  # GET /submission_test_results.json
  def index
    @submission_test_results = SubmissionTestResult.all
  end

  # GET /submission_test_results/1
  # GET /submission_test_results/1.json
  def show
  end

  # GET /submission_test_results/new
  def new
    @submission_test_result = SubmissionTestResult.new
  end

  # GET /submission_test_results/1/edit
  def edit
  end

  # POST /submission_test_results
  # POST /submission_test_results.json
  def create
    @submission_test_result = SubmissionTestResult.new(submission_test_result_params)

    respond_to do |format|
      if @submission_test_result.save
        format.html { redirect_to @submission_test_result, notice: 'Submission test result was successfully created.' }
        format.json { render :show, status: :created, location: @submission_test_result }
      else
        format.html { render :new }
        format.json { render json: @submission_test_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submission_test_results/1
  # PATCH/PUT /submission_test_results/1.json
  def update
    respond_to do |format|
      if @submission_test_result.update(submission_test_result_params)
        format.html { redirect_to @submission_test_result, notice: 'Submission test result was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission_test_result }
      else
        format.html { render :edit }
        format.json { render json: @submission_test_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submission_test_results/1
  # DELETE /submission_test_results/1.json
  def destroy
    @submission_test_result.destroy
    respond_to do |format|
      format.html { redirect_to submission_test_results_url, notice: 'Submission test result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission_test_result
      @submission_test_result = SubmissionTestResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_test_result_params
      params.require(:submission_test_result).permit(:execution_time_in_ms, :output, :errors_output, :feedback, :terminates?, :return_state, :execution_result, :test_case_id, :problem_submission_id)
    end
end
