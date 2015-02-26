class SourceFile < ActiveRecord::Base
  belongs_to :problem_submission
  has_many :comments

  def absolute_path
    root_path = File.dirname(problem_submission.code.path)
    File.join(root_path, relative_path)
  end

  def package_name
    package = /package (.*);/.match(source_code)
    package.nil? ? '' : package[1]
  end

  def relative_dir
    dir = File.dirname(relative_path)
    dir.gsub!(/#{package_name}$/, '')
  end
end
