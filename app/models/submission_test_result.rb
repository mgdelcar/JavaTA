class SubmissionTestResult < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :problem_submission

  enum execution_result: [ :created, :cancelled, :in_progress, :test_pass, :test_failed, :runtime_error, :timeout ]
  
  def execute_test
    if (problem_submission.binary_name.nil?)
      logger.error "A binary name has not been defined for #{problem_submission.code.path}".red
      return
    end
    
    location = problem_submission.absolute_path
    cmd = "java -classpath #{location} #{problem_submission.binary_to_run}"
    logger.info "Running: [#{cmd}]".green

    self.execution_result = :in_progress
    self.save

    start = Time.now

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

          logger.info "Test execution finished (#{File.join(location, problem_submission.binary_to_run)}) with return state #{self.execution_result}".green
        end
      end
    rescue Timeout::Error
      self.errors_output = "Test timed out as it took longer than 10 seconds to execute"
      self.execution_result = :timeout

      logger.error "#{self.errors_output}".red
    end
    
    finish = Time.now
    self.execution_time_in_ms = (finish - start) * 1000
    
    self.save
  end

end
