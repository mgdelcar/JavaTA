class PracticeitController < ApplicationController

  def index
    @log_messages = Array.new
    @error_messages = Array.new

    begin
      grades_spreadsheet = GradesSpreadsheet.new(ENV['BB_EMAIL'], ENV['BB_CRED'], ENV['BB_DOC_ID'])

      students = grades_spreadsheet.students_list

      students.each do |name, info|
        begin
          @log_messages << "Reading grades of #{name}"
          student_grades = Crawler.read_student_grades(info[:username], info[:credential])
          info[:grades] = student_grades
        rescue Exception => msg
          $stderr.puts msg
        end
      end

      grades_spreadsheet.save_grades

      @log_messages << "Student grades saved successfully"

    rescue Exception => msg
      @error_messages << msg
    end

  end

end
