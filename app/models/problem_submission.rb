require 'fileutils'
require 'open3'
require 'timeout'
require 'zip'

class ProblemSubmission < ActiveRecord::Base
  belongs_to :problem
  belongs_to :user
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

  def try_set_binary_name(class_name, source_code)
    logger.info "Trying to identify binary name for class #{class_name}".blue

    package = /package (.*);/.match(source_code)

    return unless self.binary_name.nil?
    if source_code.include?('void main')
      self.binary_name = package.nil? ? class_name : "#{package[1]}/#{class_name}"
      self.save
    else
      logger.error "Source code of #{class_name} does not contain a main method".yellow
    end
  end

  def create_source_files_from_zip
    root_path = File.dirname(code.path)

    logger.info "Unzipping file #{code.path}".green
    begin
      Zip::File.open(code.path) do |zip_file|
        # TODO: Support languages other than Java
        zip_file.select{ |e| e.name.end_with?('.java') && !e.name.start_with?('__') }.each do |entry|
          begin
            logger.info "Extracting #{entry.name}".green

            dest_file = File.join(root_path, entry.name)
            dest_folder = File.dirname(dest_file)
            FileUtils::mkdir_p dest_folder unless dest_folder.equal? root_path

            logger.info "Uncompressing to #{dest_file}".green
            entry.extract dest_file

            source_code = entry.get_input_stream.read
            source_file = SourceFile.create(:source_code => source_code, :relative_path => entry.name, :problem_submission => self)

            try_set_binary_name(File.basename(entry.name, '.java'), source_code)
          rescue Exception => exc
            logger.error "Error processing file '#{entry.name}'. #{exc.message}".red
          end
        end
      end
    rescue Exception => exc
      logger.error "Could not unzip file '#{code.path}'. #{exc.message}".red
    end
  end

  def create_source_files
    begin
      if code.path.end_with? 'zip'
        create_source_files_from_zip
      else
        source_code = File.read(code.path)
        source_file = SourceFile.create(:source_code => source_code, :relative_path => code_file_name, :problem_submission => self)
      end
    rescue Exception => exc
      logger.error "Could not read file #{code.path}. #{exc.message}".red
    end
  end

  def source_file_paths
    paths = ''
    source_files.each do |file|
      paths = "#{paths} #{file.absolute_path}"
    end
    paths
  end

  def compile
    cmd = "javac #{source_file_paths}"
    logger.info "Starting to compile: #{cmd}".blue

    begin
      # TODO: Use a smarter value than 10 seconds as a timeout
      status = Timeout::timeout(10) do
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          self.compiler_stdout = remove_system_internals(stdout.read)
          self.compiler_stderr = remove_system_internals(stderr.read)
          self.compiler_return_value = wait_thr.value
          self.compilation_result = (self.compiler_return_value == 0) ? :compilation_successful : :compilation_error

          logger.info "Compilation finished (#{cmd})".green
        end
      end

    rescue Timeout::Error => exc
      self.compiler_stderr = "Compilation of #{self.code_file_name} timed out after 10 seconds. Wait a couple of minutes. If the problem persist, please contact your administrator."
      self.compilation_result = :timeout

      logger.error "#{self.compiler_stderr}".red
      logger.error "#{exc.message}".red
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
