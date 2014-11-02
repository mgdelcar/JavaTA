require 'rubygems'
require 'google_drive'

class GradesSpreadsheet


  GRADES_SPREADSHEET_ID     = 0
  GRADES_ASSIGNMENT_COL     = 1
  GRADES_POINTS_COL         = 2
  GRADES_DUE_DATE_COL       = 3
  GRADES_FIRST_STUDENT_COL  = 4
  GRADES_FIRST_ASSIGN_ROW   = 2

  STUDENTS_SPREADSHEET_ID   = 1
  STUDENTS_FIRST_ROW        = 2
  STUDENTS_NAME_COL         = 1
  STUDENTS_USERNAME_COL     = 2
  STUDENTS_CREDENTIAL_COL   = 3

  TITLE_ROW                 = 1

  ASSIGNMENT_TITLE = 'Assignment'
  MAX_POINTS_TITLE = 'Max Points'
  DUE_DATE_TITLE   = 'Due Date'

  # Google credentials and spreadsheet id (e.g. https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg)
  def initialize(email, credentials, spreadsheet_id)
    begin
      @session = GoogleDrive.login(email, credentials)
    rescue Exception => msg
      raise "Could not connect to the spreadsheet with id #{spreadsheet_id} using the credentials of #{email}.\nError: #{msg}"
    end

    begin
      @grades_sheet = @session.spreadsheet_by_key(spreadsheet_id).worksheets[GRADES_SPREADSHEET_ID]
    rescue Exception => msg
      raise "Cannot read grades spreadsheet.\nError: #{msg}"
    end

    begin
      @credentials_sheet = @session.spreadsheet_by_key(spreadsheet_id).worksheets[STUDENTS_SPREADSHEET_ID]
    rescue Exception => msg
      raise "Cannot read students credentials spreadsheet.\nError: #{msg}"
    end

    verify_columns
  end

  # Verifies that the first three columns have the right titles
  def verify_columns
    raise "First column name of the Grades spreadsheet should be #{ASSIGNMENT_TITLE}" unless @grades_sheet[TITLE_ROW, GRADES_ASSIGNMENT_COL].gsub(/\s+/, " ") == ASSIGNMENT_TITLE
    raise "Second column name of the Grades spreadsheet should be #{MAX_POINTS_TITLE}" unless @grades_sheet[TITLE_ROW, GRADES_POINTS_COL].gsub(/\s+/, " ") == MAX_POINTS_TITLE
    raise "Third column name of the Grades spreadsheet should be #{DUE_DATE_TITLE}" unless @grades_sheet[TITLE_ROW, GRADES_DUE_DATE_COL].gsub(/\s+/, " ") == DUE_DATE_TITLE
  end

  # Saves all students grades to the spreadsheet
  def save_grades
    @students_list.map do |name, student_info|
      puts "Writting the grades of #{name}"
      practice_it_assignments.each do |assignment|
        if assign_points?(assignment, student_info)
          @grades_sheet[assignment[:row_num], student_info[:col_num]] = assignment[:points]
        end
      end
    end

    begin
      @grades_sheet.save
      puts "The grades have been saved successfully to Google Spreadsheet"
    rescue Exception => msg
      raise "Cannot save the grades to the spreadsheet.\nError: #{msg}"
    end
  end

  # Can still assign points to this student for this assignment?
  def assign_points?(assignment, student_info)
    return (
      !student_info[:grades][assignment[:assignment_name]].nil? and
      @grades_sheet[assignment[:row_num], student_info[:col_num]].empty? and
      student_info[:grades][assignment[:assignment_name]][:date] < assignment[:due_date])
  end

  def students_list
    @students_list ||= read_students_list
  end

  # Reads the students credentials
  def read_students_list
    @students_list = Hash.new
    for row in STUDENTS_FIRST_ROW..@credentials_sheet.num_rows
      name = @credentials_sheet[row, STUDENTS_NAME_COL]
      username = @credentials_sheet[row, STUDENTS_USERNAME_COL]
      credential = @credentials_sheet[row, STUDENTS_CREDENTIAL_COL]

      @students_list[name] = { :name => name, :username => username, :credential => credential, :grades => Hash.new }
    end

    map_student_names_and_column_numbers
    @students_list
  end

  # Associates a student name with the students list
  def map_student_names_and_column_numbers
    for col in GRADES_FIRST_STUDENT_COL..@grades_sheet.num_cols
      student_name = @grades_sheet[TITLE_ROW, col].gsub(/\s+/, " ")
      raise "Cannot find student #{student_name} in the Practice-It credentials spreadsheet" unless students_list.has_key?(student_name)

      @students_list[student_name][:col_num] = col
    end
  end

  def student_assignments_done?(student_name)
    col = @students_list[student_name][:col_num]

    practice_it_assignments.each do |assignment|
      row = assignment[:row_num]
      return false unless @grades_sheet[row, col].to_i > 0
    end

    return true
  end

  def practice_it_assignments
    @practice_it_assignments ||= read_practice_it_assignments
  end

  def read_practice_it_assignments
    practice_it_assignments = Array.new
    for row in GRADES_FIRST_ASSIGN_ROW..@grades_sheet.num_rows
      assignment_name = @grades_sheet[row, GRADES_ASSIGNMENT_COL].gsub(/\s+/, " ")
      if assignment_name =~ /^\w+ \w+(-\w+)? \d+\.\d+$/
        points = @grades_sheet[row, GRADES_POINTS_COL].empty? ? 1 : @grades_sheet[row, GRADES_POINTS_COL]
        due_date = @grades_sheet[row, GRADES_DUE_DATE_COL].empty? ? Date.today : Date.strptime(@grades_sheet[row, GRADES_DUE_DATE_COL], "%m/%d/%Y")
        due_date += 1 # Add 24 hours
        practice_it_assignments << { :row_num => row, :assignment_name => assignment_name, :points => points, :due_date => due_date }
      end
    end

    practice_it_assignments
  end

end
