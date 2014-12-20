require 'open3'

class EvaluatorController < ApplicationController
  def compile
    location = './test_code'
    cmd = "javac #{location}/Sample1.java"

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @compile_output = stdout.read
      @compile_output_error = stderr.read
    end

    cmd = "java -cp #{location} Sample1"

    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @output = stdout.read
      @output_error = stderr.read
    end

  end
end
