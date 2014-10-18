class PracticeitController < ApplicationController

  def index
    @log_messages = Array.new
    @error_messages = Array.new

    begin
      raise "You need to provide the doc_id of the google spreadsheet" if params[:doc_id].nil?
      grades_spreadsheet = GradesSpreadsheet.new(ENV['BB_EMAIL'], ENV['BB_CRED'], params[:doc_id])

      students = grades_spreadsheet.students_list
      successful_saves = 0

      students.each do |name, info|
        begin
          @log_messages << "Reading grades of #{name}"
          student_grades = Crawler.read_student_grades(info[:username], info[:credential])
          info[:grades] = student_grades
          successful_saves += 1
        rescue Exception => msg
          @error_messages << msg
        end
      end

      grades_spreadsheet.save_grades

      @log_messages << "#{successful_saves} student grades saved successfully of #{students.count}"

    rescue Exception => msg
      @error_messages << msg
    end

  end

end
