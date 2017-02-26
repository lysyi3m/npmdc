require 'spec_helper'

describe Npmdc::Formatters::Documentation do
  using StringStripHeredoc
  let(:options) { { 'color' => false, 'format' => 'doc', 'path' => path } }

  subject { Npmdc.call(options) }

  describe 'npm' do
    include_context 'npm'

    describe 'success check' do
      include_context 'case_2_success_3_packages_0_warnings'

      it 'returns correct success message' do
        output_msg = <<-output.strip_heredoc
          Checking dependencies:
            ✓ foo
            ✓ bar

          Checking devDependencies:
            ✓ foobar

          Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct success colors' do
        options['color'] = true
        output_msg = <<-output.strip_heredoc
          Checking dependencies:
          \e[0;32;49m  ✓ foo\e[0m
          \e[0;32;49m  ✓ bar\e[0m

          Checking devDependencies:
          \e[0;32;49m  ✓ foobar\e[0m

          \e[0;32;49mChecked 3 packages. Warnings: 0. Errors: 0. Everything is ok.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'success version check' do
      include_context 'case_5_success_6_packages_0_warnings'

      it { is_expected.to be true }

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Checked 6 packages. Warnings: 0. Errors: 0. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'no /node_modules folder' do
      include_context 'case_1_no_node_modules'

      it 'displays correct no no_modules message' do
        output_msg = <<-output.strip_heredoc
          Can't find `node_modules` folder inside '#{path}' directory!

          Run `npm install` to install missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'displays correct no node_modules colors' do
        options['color'] = true
        output_msg = <<-output.strip_heredoc
          Can't find `node_modules` folder inside '#{path}' directory!
          \e[0;33;49m
          Run `npm install` to install missing packages.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failures check' do
      include_context 'case_3_3_missing_packages'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Run `npm install` to install 3 missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failure version check' do
      include_context 'case_6_5_missing_packages'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Run `npm install` to install 5 missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end
    end
  end

  describe 'yarn' do
    include_context 'yarn'

    describe 'success check' do
      include_context 'case_2_success_3_packages_0_warnings'

      it 'returns correct success message' do
        output_msg = <<-output.strip_heredoc
          Checking all dependencies via yarn check:
            ✓ foo@1.0.0
            ✓ bar@2.0.0
            ✓ node-foo@~0.2.3
            ✓ optimist@~ 0.2.4
            ✓ watch@~ 0.3.2
            ✓ wordwrap@>=0.0.1 <0.1.0
            ✓ Folder in sync.

          Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
          output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct success colors' do
        options['color'] = true
        output_msg = <<-output.strip_heredoc
          Checking all dependencies via yarn check:
          \e[0;32;49m  ✓ foo@1.0.0\e[0m
          \e[0;32;49m  ✓ bar@2.0.0\e[0m
          \e[0;32;49m  ✓ node-foo@~0.2.3\e[0m
          \e[0;32;49m  ✓ optimist@~ 0.2.4\e[0m
          \e[0;32;49m  ✓ watch@~ 0.3.2\e[0m
          \e[0;32;49m  ✓ wordwrap@>=0.0.1 <0.1.0\e[0m
          \e[0;32;49m  ✓ Folder in sync.\e[0m

          \e[0;32;49mChecked 3 packages. Warnings: 0. Errors: 0. Everything is ok.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'no /node_modules folder' do
      include_context 'case_1_no_node_modules'

      it 'displays correct no no_modules message' do
        output_msg = <<-output.strip_heredoc
          Can't find `node_modules` folder inside '#{path}' directory!

          Run `yarn` to install missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'displays correct no node_modules colors' do
        options['color'] = true
        output_msg = <<-output.strip_heredoc
          Can't find `node_modules` folder inside '#{path}' directory!
          \e[0;33;49m
          Run `yarn` to install missing packages.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failures check' do
      include_context 'case_3_3_missing_packages'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Run `yarn` to install missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'failure version check' do
      include_context 'case_6_5_missing_packages'

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Run `yarn` to install missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end
    end
  end
end
