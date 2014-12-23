require 'open3'

class EvaluatorController < ApplicationController
  def compile
    
    class_name = 'Sample2'
    location = './test_code'
    cmd = "javac #{location}/#{class_name}.java"

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @compile_output = stdout.read
      @compile_output_error = stderr.read
    end

    cmd = "java -cp #{location} #{class_name}"

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @output = stdout.read
      @output_error = stderr.read
    end

  end
end
