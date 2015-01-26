class SubmissionTestResult < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :problem_submission

  enum execution_result: [ :created, :cancelled, :in_progress, :test_pass, :test_failed, :runtime_error, :timeout ]
  
  def execute_test
    # TODO: Find a better way to identify the binary name. The current approach will fail with multiple source files
    location = File.dirname(problem_submission.code.path)
    binary = File.basename(problem_submission.code.path, '.java')
    logger.info "Starting to execute test #{test_case.title} for [#{File.join(location, binary)}]".green
    cmd = "java -cp #{location} #{binary}"

    self.execution_result = :in_progress
    self.save

    begin
      # TODO: Use db value instead of 10 seconds as a timeout
      status = Timeout::timeout(10) do
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.puts(test_case.input)
          stdin.close
          
          self.output = stdout.read
          self.errors_output = stderr.read
          self.return_state = wait_thr.value
          
          # TODO: Perform further transformations regarding whitespace if the test allows them
          expected_string = test_case.output.chomp
          actual_string = self.output.chomp
          
          if self.return_state != 0
            self.execution_result = :runtime_error
          elsif expected_string.eql?(actual_string)
            self.execution_result = :test_pass
          else
            self.execution_result = :test_failed
          end

          logger.info "Test execution finished (#{File.join(location, binary)}) with return state #{self.execution_result}".green
        end
      end
    rescue Timeout::Error
      self.errors_output = "Test timed out as it took longer than 10 seconds to execute"
      self.execution_result = :timeout
      
      logger.error "#{self.errors_output}".red
    end
    
    self.save
  end

end
