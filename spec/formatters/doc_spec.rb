require 'spec_helper'

describe Npmdc::Formatters::Documentation do
  let(:path) { './spec/files/case_2/' }
  let(:options) { { 'color' => false, 'format' => 'doc', 'path' => path } }

  subject { Npmdc.call(options) }

  it 'returns correct message' do
    output_msg = <<~output
      Checking dependencies:
        ✓ foo
        ✓ bar

      Checking devDependencies:
        ✓ foobar

      Checked 3 packages. Everything is ok.
    output

    expect { subject }.to write_output(output_msg)
  end

  it 'returns correct colors' do
    options['color'] = true
    output_msg = <<~output
      Checking dependencies:
      \e[0;32;49m  ✓ foo\e[0m
      \e[0;32;49m  ✓ bar\e[0m

      Checking devDependencies:
      \e[0;32;49m  ✓ foobar\e[0m

      \e[0;32;49mChecked 3 packages. Everything is ok.\e[0m
    output

    expect { subject }.to write_output(output_msg)
  end
end
