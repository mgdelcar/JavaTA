require 'rubygems'
require 'mechanize'
require 'nokogiri'

class Crawler

  # Given a username and password, returns list of problems solved
  # If an error occurs, an exception is raised
  def self.read_student_grades(username, password)
    a = Mechanize.new
    a.get('http://practiceit.cs.washington.edu/practiceit/login.jsp') do |login_page|
      begin
        home_page = login_page.form_with(:id => 'loginform') do |f|
          f.username  = username
          f.password = password
        end.click_button

        solved_page = a.click(home_page.link_with(:href => /problemssolved.jsp/))
      rescue
        raise "Could not log in as user '#{username}', please verify her/his credentials"
      end

      begin
        result = extract_grades(solved_page.body)
      rescue
        raise "Tried to parse 'Problems Solved' table but couldn't. Please verify that the format did not change."
      end

      a.click(solved_page.link_with(:href => /logout.jsp/))

      return result
    end
  end

  # Parses the HTML page that contains the list of problems solved
  # Returns a hash where the key is the problem in the format 'BJP3 Self-Check 1.4'
  #         the value is a Hash with keys: :problem, :category and :date
  def self.extract_grades(html_page)
    page = Nokogiri::HTML.parse(html_page)

    table = page.search('table')

    grades = {}
    table.search('tr').drop(1).each do |tr|
      tds = tr.search('td')

      category = tds[1].text.strip
      problem  = tds[2].text.strip
      date     = DateTime.parse(tds[3].text.strip.gsub(/\s+/, " "))
      key      = extract_problem_key(problem)

      grades[ key ] = { :key => key, :problem => problem, :category => category, :date => date }
    end

    return grades
  end

  # 'BJP3 Self-Check 1.04: cookieRecipe' => 'BJP3 Self-Check 1.4'
  def self.extract_problem_key(problem_name)
    key = problem_name.split(/:\s*/)[0]         # Takes the text before the ':'
    key.gsub(/(.*)(\d*)\.(0*)(\d*)/, '\1\2.\4') # Removes the zeroes before the second number
  end

end
