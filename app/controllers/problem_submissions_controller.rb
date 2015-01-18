class ProblemSubmissionsController < ApplicationController

  # GET /problem_submissions
  # GET /problem_submissions.json
  def index
    # TODO: Filter problems for the right class that are actionable
    @problems = Problem.all
    @problem_submissions = ProblemSubmission.all #.where(:problem_id => @problem.id, )
  end

  # GET /problem_submissions/code_review/1
  def code_review
    # TODO: Verify that this problem id is to be resolved by this student
    #       consider the class, due date, student id, etc
    
    @problem = Problem.find(params[:problem_id])
    @problem_submissions = ProblemSubmission.all.where(:problem_id => @problem.id)
  end

  # GET /problem_submissions/new
  def new
    # TODO: Verify that this problem id is to be resolved by this student
    #       consider the class, due date, student id, etc
    
    # TODO: Calculate the right iteration number for this student
    @problem_submission = ProblemSubmission.new(problem_id: params[:problem_id])
    #@problem_submission.iteration = 
  end

  # POST /problem_submissions
  # POST /problem_submissions.json
  def create
    parameters = problem_submission_params
    parameters[:when] = DateTime.now
    @problem_submission = ProblemSubmission.new(parameters)

    respond_to do |format|
      if @problem_submission.save
        format.html { redirect_to '/problem_submissions', notice: 'Problem submission was successfully created.' }
        format.json { render :index, status: :created, location: @problem_submission }
      else
        format.html { render :new }
        format.json { render json: @problem_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_submission
      @problem_submission = ProblemSubmission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_submission_params
      params.require(:problem_submission).permit(:code, :problem_id)
    end

    def problem_params
      params.require(:problem_id)
    end
end
