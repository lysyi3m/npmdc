require 'spec_helper'

describe Npmdc::Formatters::Short do
  using StringStripHeredoc

  let(:options) { { 'color' => false, 'format' => 'short', 'path' => path } }

  subject { Npmdc.call(options) }

  shared_examples 'a success check' do |package_manager|
    include_context package_manager
    include_context 'case_2_success_3_packages_0_warnings'

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
      output

      expect { subject }.to write_output(output_msg)
    end

    it 'returns correct colors' do
      options['color'] = true

      output_msg = <<-output.strip_heredoc
        \e[0;32;49mChecked 3 packages. Warnings: 0. Errors: 0. Everything is ok.\e[0m
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  describe 'npm' do
    include_context 'npm'

    it_should_behave_like 'a success check', 'npm'

    describe 'failure check' do
      include_context 'case_3_3_missing_packages'

      it { is_expected.to be false }

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
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

  describe 'yarn' do
    include_context 'yarn'

    it_should_behave_like 'a success check', 'yarn'

    describe 'failure check' do
      include_context 'case_3_3_missing_packages'

      it { is_expected.to be false }

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Following dependencies required by your package.json file are missing or not installed properly:
            * "watch" not installed
            * "watch#exec-sh" not installed
            * "optimist#wordwrap" not installed
            * Found 3 errors.

          Run `yarn` to install missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct colors' do
        options['color'] = true
        output_msg = <<-output.strip_heredoc
          Following dependencies required by your package.json file are missing or not installed properly:
            * "watch" not installed
            * "watch#exec-sh" not installed
            * "optimist#wordwrap" not installed
            * Found 3 errors.
          \e[0;33;49m
          Run `yarn` to install missing packages.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end
  end
end
