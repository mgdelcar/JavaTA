# TODO: Make sure that only users with the right privileges can interact with this class

class TestCasesController < ApplicationController
  before_action :set_test_case, only: [:edit, :update, :destroy]

  # GET /test_cases/new
  def new
    @test_case = TestCase.new(problem_id: params[:problem_id])
  end

  # GET /test_cases/1/edit
  def edit
  end

  # POST /test_cases
  # POST /test_cases.json
  def create
    @test_case = TestCase.new(test_case_params)

    respond_to do |format|
      if @test_case.save
        format.html { redirect_to "/problems/#{@test_case.problem_id}/edit", :notice => 'Test case was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_cases/1
  # PATCH/PUT /test_cases/1.json
  def update
    respond_to do |format|
      if @test_case.update(test_case_params)
        format.html { redirect_to "/problems/#{@test_case.problem_id}/edit", :notice => 'Test case was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_cases/1
  # DELETE /test_cases/1.json
  def destroy
    @test_case.destroy
    respond_to do |format|
      format.html { redirect_to test_cases_url, notice: 'Test case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_case
      @test_case = TestCase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_case_params
      params.require(:test_case).permit(:title, :input, :output, :points, :max_time_execution_sec, :problem_id)
    end

    def controller_allowed?
      redirect_to start_page unless current_user.instructor?
    end
end
