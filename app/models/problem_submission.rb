require 'open3'
require 'timeout'

class ProblemSubmission < ActiveRecord::Base
  belongs_to :problem
  has_many :submission_test_results
  has_many :source_files
  has_attached_file :code
  
  validates :code, :attachment_presence => true
  validates_attachment_content_type :code, :content_type => [/text.*\Z/, "application/octet-stream", "application/zip"]
  validates_attachment_file_name :code, :matches => [/java\Z/, /zip\Z/]

  enum compilation_result: [ :compilation_error, :compilation_successful, :incorrec_format, :disallowed_instructions, :virus_found, :plagiarism_detected, :timeout ]

  def create_submission_test_results
    logger.info "Create submission test results".green

    problem.test_cases.each do |test_case|
      logger.info "Processing test case #{test_case.title}".green
      
      test_result = SubmissionTestResult.create(:test_case => test_case, :problem_submission => self, :execution_result => :created)
      test_result.execute_test
    end
  end

  def create_source_files
    begin
      source_code = File.read(code.path)
      source_file = SourceFile.create(:source_code => source_code, :relative_path => code_file_name, :problem_submission => self)
    rescue
      logger.error "Could not read file #{code.path}".red
    end
  end

  def compile
    logger.info "Starting to compile #{code.path}".green
    cmd = "javac #{code.path}"

    begin
      # TODO: Use a smarter value than 10 seconds as a timeout
      status = Timeout::timeout(10) do
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          self.compiler_stdout = remove_system_internals(stdout.read)
          self.compiler_stderr = remove_system_internals(stderr.read)
          self.compiler_return_value = wait_thr.value
          self.compilation_result = (self.compiler_return_value == 0) ? :compilation_successful : :compilation_error

          logger.info "Compilation finished (#{code.path})".green
        end
      end
      
    rescue Timeout::Error
      self.compiler_stderr = "Compilation of #{self.code_file_name} timed out after 10 seconds. Wait a couple of minutes. If the problem persist, please contact your administrator."
      self.compilation_result = :timeout
      
      logger.error "#{self.compiler_stderr}".red
    end
    
    self.save
    
    create_submission_test_results if self.compilation_successful?
  end

  # Remove system internal information
  def remove_system_internals(text_to_process)
    code_location = File.dirname(self.code.path).gsub("\\", '/') + '/'
    text_to_process.gsub!("\\", '/')
    text_to_process.gsub(code_location, '')
  end

end
