require 'rspec/expectations'

RSpec::Matchers.define :write_output do |output|
  match do |actual|
    raise ArgumentError('Supports only block') unless actual.is_a? Proc

    captured_stream = StringIO.new
    original_stream = Npmdc.output
    result = false

    begin
      Npmdc.output = captured_stream

      actual.call

      @captured_string = captured_stream.string

      result = @captured_string.include?(output)
    ensure
      $stdout = original_stream
    end
    result
  end

  failure_message do |_actual|
    "Expected Npmdc to output:\n\n#{output}\n"\
    "But got:\n\n#{@captured_string}\n"
  end

  supports_block_expectations
end
