require 'spec_helper'

describe Npmdc::Formatters::Progress do
  using StringStripHeredoc

  let(:options) { { 'color' => false, 'format' => 'progress', 'path' => path } }
  subject { Npmdc.call(options) }

  describe 'npm' do
    include_context 'npm'

    describe 'success' do
      include_context 'case_2_success_3_packages_0_warnings'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Checking dependencies:
          ..

          Checking devDependencies:
          .

          Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
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

          \e[0;32;49mChecked 3 packages. Warnings: 0. Errors: 0. Everything is ok.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failure check' do
      include_context 'case_3_3_missing_packages'

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

  describe 'yarn' do
    include_context 'yarn'

    describe 'success' do
      include_context 'case_2_success_3_packages_0_warnings'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Checking all dependencies via yarn check:
          .......

          Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct colors' do
        options['color'] = true

        output_msg = <<-output.strip_heredoc
          Checking all dependencies via yarn check:
          \e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m

          \e[0;32;49mChecked 3 packages. Warnings: 0. Errors: 0. Everything is ok.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failure check' do
      include_context 'case_3_3_missing_packages'

      it { is_expected.to be false }

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Checking all dependencies via yarn check:
          ........FFFF

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
          Checking all dependencies via yarn check:
          \e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\e[0;31;49mF\e[0m\e[0;31;49mF\e[0m\e[0;31;49mF\e[0m\e[0;31;49mF\e[0m

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

