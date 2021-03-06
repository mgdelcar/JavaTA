class ProblemSubmissionsController < ApplicationController

  # GET /problem_submissions
  # GET /problem_submissions.json
  def index
    # TODO: Filter problems for the right class that are actionable
    @problems = Problem.all
    @problem_submissions = ProblemSubmission.where(:user_id => current_user.id)
  end

  def class_submissions
    unless current_user.instructor?
      redirect_to start_page
      return
    end

    # TODO: Filter problems for the right class that are actionable
    @problems = Problem.all
    @problem_submissions = ProblemSubmission.all
  end

  # GET /problem_submissions/code_review/1
  def code_review
    # TODO: Verify that this problem id is to be resolved by this student
    #       consider the class, due date, student id, etc
    # TODO: Handle properly when params are wrong. i.e. show a nice page
    verify_code_review_params

    if current_user.student? || params[:user_id].nil?
      author = current_user
    elsif current_user.instructor?
      author = User.find(params[:user_id])
      if author.nil?
        redirect_to start_page, :notice => "Cannot find user"
        return
      end
    else
      redirect_to start_page
      return
    end

    @problem = Problem.find(params[:problem_id])
    @problem_submissions = ProblemSubmission.where(:problem => @problem, :user => author).order(:when)

    if (@problem_submissions.count == 0)
      redirect_to "/problem_submissions/new?problem_id=#{params[:problem_id]}"
      return
    end

    @show_one_iteration = (@problem_submissions.count == 1) || params.key?(:show_one_iteration)

    @iterations = @problem_submissions.collect.with_index { |submission, i| OpenStruct.new(:label => "Iteration #{i + 1} (#{I18n.l submission.when, format: :long })", :value => (i + 1)) }
    @left_iteration = (!params[:left_iteration].nil? && params[:left_iteration].to_i.between?(1, @iterations.count)) ? params[:left_iteration] : [1, @iterations.count - 1].max
    @left_submission = @problem_submissions[@left_iteration.to_i - 1]
    @left_source_code = @left_submission.source_files.empty? ? '' : @left_submission.source_files.first.source_code
    @left_files = @left_submission.source_files

    if @show_one_iteration
      @right_iteration = @left_iteration
      @right_submission = @left_submission
      @right_source_code = @left_source_code
      @right_files = @left_files
    else
      @right_iteration = (!params[:right_iteration].nil? && params[:right_iteration].to_i.between?(1, @iterations.count)) ? params[:right_iteration] : @iterations.count
      @right_submission = @problem_submissions[@right_iteration.to_i - 1]
      @right_source_code = @right_submission.source_files.empty? ? '' : @right_submission.source_files.first.source_code
      @right_files = @right_submission.source_files
    end
    
  end

  # GET /problem_submissions/new
  def new
    # TODO: Verify that this problem id is to be resolved by this student
    #       consider the class, due date, student id, etc

    if params[:problem_id].nil?
      logger.error "Problem id not available".red
      redirect_to start_page, :notice => "Cannot find problem"
      return
    end

    logger.info "Submitting problem id #{params[:problem_id]}".green

    @problem = Problem.find_by_id(params[:problem_id])

    if @problem.nil?
      logger.error "Problem not available".red
      redirect_to start_page, :notice => "Cannot find problem"
      return
    end

    @problem_submission = ProblemSubmission.new(problem: @problem)
  end

  # POST /problem_submissions
  # POST /problem_submissions.json
  def create
    parameters = problem_submission_params
    parameters[:when] = DateTime.now
    parameters[:user_id] = current_user.id
    @problem_submission = ProblemSubmission.new(parameters)

    respond_to do |format|
      if @problem_submission.save
        @problem_submission.create_source_files
        @problem_submission.compile

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
      params.require(:problem_submission).permit(:code, :problem_id, :user_id)
    end

    def problem_params
      params.require(:problem_id)
    end
    
    def verify_code_review_params
      params.require(:problem_id)
    end

    def controller_allowed?
      redirect_to start_page unless current_user.instructor? || current_user.student?
    end
end
