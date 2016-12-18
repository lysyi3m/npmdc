require 'spec_helper'

describe Npmdc::Formatters::Progress do
  using StringStripHeredoc

  let(:path) { './spec/files/case_2/' }
  let(:options) { { 'color' => false, 'format' => 'progress', 'path' => path } }

  subject { Npmdc.call(options) }

  it 'returns correct message' do
    output_msg = <<-output.strip_heredoc
      Checking dependencies:
      ..

      Checking devDependencies:
      .

      Checked 3 packages. Everything is ok.
    output

    expect { subject }.to write_output(output_msg)
  end

  it 'returns correct colors' do
    options['color'] = true

    output_msg = <<-output.strip_heredoc
      Checking dependencies:
      \e[0;32;49m.\e[0m\e[0;32;49m.\e[0m

      Checking devDependencies:
      \e[0;32;49m.\e[0m

      \e[0;32;49mChecked 3 packages. Everything is ok.\e[0m
    output

    expect { subject }.to write_output(output_msg)
  end

  context 'failure check' do
    let(:path) { './spec/files/case_3/' }

    it { is_expected.to be false }

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Checking dependencies:
        .F

        Checking devDependencies:
        FF

        Following dependencies required by your package.json file are missing or not installed properly:
          * bar@2.0.0
          * foobar@3.0.0
          * foobarfoo@4.0.0

        Run `npm install` to install 3 missing packages.
      output

      expect { subject }.to write_output(output_msg)
    end

    it 'returns correct colors' do
      options['color'] = true
      output_msg = <<-output.strip_heredoc
        Checking dependencies:
        \e[0;32;49m.\e[0m\e[0;31;49mF\e[0m

        Checking devDependencies:
        \e[0;31;49mF\e[0m\e[0;31;49mF\e[0m

        Following dependencies required by your package.json file are missing or not installed properly:
          * bar@2.0.0
          * foobar@3.0.0
          * foobarfoo@4.0.0
        \e[0;33;49m
        Run `npm install` to install 3 missing packages.\e[0m
      output

      expect { subject }.to write_output(output_msg)
    end
  end
end
