require 'spec_helper'

describe Npmdc do
  using StringStripHeredoc

  let(:format) { 'doc' }
  let(:options) { { 'color' => false, 'format' => format, 'path' => path } }
  subject { described_class.call(options) }

  shared_examples 'critical error' do
    before { options['abort_on_failure'] = true }

    it 'aborts current process' do
      expect_any_instance_of(described_class::Checkers::Checker).to receive(:exit).with(1)

      subject
    end
  end

  shared_examples 'non critical error' do
    before { options['abort_on_failure'] = true }

    it 'does not abort current process' do
      expect_any_instance_of(described_class::Checkers::Checker).not_to receive(:exit)

      subject
    end
  end

  shared_examples 'a checker' do |package_manager|
    include_context package_manager

    describe 'no /node_modules folder' do
      include_context 'case_1_no_node_modules'

      it 'catches NoNodeModulesError' do
        expect_any_instance_of(Npmdc::Formatters::Documentation).to(
          receive(:error_output)
          .with(instance_of(Npmdc::Errors::NoNodeModulesError))
        )

        is_expected.to be false
      end

      it_behaves_like 'critical error'
    end

    describe 'no package.json file' do
      let(:path) { './spec/' }

      it { is_expected.to be false }

      it 'displays correct message' do
        output_msg = <<-output.strip_heredoc
          There is no `package.json` file inside './spec/' directory.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'displays correct colors' do
        options['color'] = true

        output_msg = <<-output.strip_heredoc
          There is no `package.json` file inside './spec/' directory.
        output

        expect { subject }.to write_output(output_msg)
      end

      it_behaves_like 'non critical error'
    end

    describe 'unexisted path' do
      let(:path) { './unexisted/' }
      let(:output_msg) { "There is no './unexisted/' directory.\n" }

      it { is_expected.to be false }

      it 'displays correct message' do
        expect { subject }.to write_output(output_msg)
      end

      it_behaves_like 'critical error'
    end

    describe 'incorrect json' do
      include_context 'case_4_broken_package_json'
      let(:output_msg) { "Can't parse JSON file #{path}/package.json\n" }

      it { is_expected.to be false }

      it 'displays correct message' do
        expect { subject }.to write_output(output_msg)
      end

      it_behaves_like 'critical error'
    end

    describe 'unknown formatter' do
      include_context 'case_2_success_3_packages_0_warnings'
      let(:format) { 'whatever' }
      let(:output_msg) { "Unknown 'whatever' formatter" }

      it 'displays correct message' do
        expect(described_class).to receive(:abort).with(output_msg)

        subject
      end
    end

    describe 'failures check' do
      include_context 'case_3_3_missing_packages'

      it 'catches MissedPackageError' do
        expect_any_instance_of(Npmdc::Formatters::Documentation).to(
          receive(:error_output)
          .with(instance_of(Npmdc::Errors::MissedDependencyError))
        )

        is_expected.to be false
      end

      it_behaves_like 'critical error'
    end

    describe 'failure version check' do
      include_context 'case_6_5_missing_packages'

      it 'catches MissedPackageError' do
        expect_any_instance_of(Npmdc::Formatters::Documentation).to(
          receive(:error_output)
          .with(instance_of(Npmdc::Errors::MissedDependencyError))
        )

        is_expected.to be false
      end

      it_behaves_like 'critical error'
    end

    describe 'success check' do
      include_context 'case_2_success_3_packages_0_warnings'

      it { is_expected.to be true }

      it 'returns correct message' do
        output_msg = <<-output.strip_heredoc
          Checked 3 packages. Warnings: 0. Errors: 0. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    describe 'success version check with warnings' do
      include_context 'case_7_sucess_4_packages_3_warnings'

      it { is_expected.to be true }

      it 'return correct message' do
        output_msg = <<-output.strip_heredoc
          Checked 4 packages. Warnings: 3. Errors: 0. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end
    end
  end

  describe 'npm_checker' do
    it_should_behave_like 'a checker', 'npm'
  end

  describe 'yarn_checker' do
    include_context 'yarn'

    it_should_behave_like 'a checker', 'yarn'

    context 'yarn is not installed globally' do
      include_context 'case_2_success_3_packages_0_warnings'

      it 'outputs correct message' do
        expect_any_instance_of(Npmdc::Checkers::YarnChecker).to(
          receive(:check_yarn_is_installed)
          .and_raise(Npmdc::Errors::YarnNotInstalledError, yarn_command: 'yarn')
        )

        output_msg = <<-output.strip_heredoc
          Failed to find `yarn`. Check that `yarn` is installed, please.
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    context 'yarn is not installed on specified path' do
      include_context 'case_2_success_3_packages_0_warnings'

      before { options['path_to_yarn'] = '/no_yarn_here/' }

      it 'outputs correct message' do
        output_msg = <<-output.strip_heredoc
          Failed to find `/no_yarn_here/yarn`. Check that `yarn` is installed, please.
        output

        expect { subject }.to write_output(output_msg)
      end

      it_behaves_like 'critical error'
    end

    context 'no yarn.lock file' do
      include_context 'case_8_no_yarn_lock'

      it 'catches NoYarnLockError' do
        expect_any_instance_of(Npmdc::Formatters::Documentation).to(
          receive(:error_output)
          .with(instance_of(Npmdc::Errors::NoYarnLockFileError))
        )

        is_expected.to be false
      end

      it_behaves_like 'critical error'
    end
  end

  describe 'unknown package manager' do
    let(:path) { nil }
    before { options['package_manager'] = 'killer-or-yarn' }
    let(:output_msg) { "Unknown 'killer-or-yarn' package manager" }

    it 'displays correct message' do
      expect(described_class).to receive(:abort).with(output_msg)

      subject
    end
  end
end
