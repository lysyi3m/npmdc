require 'spec_helper'

describe Npmdc do
  using StringStripHeredoc

  let(:path) { nil }
  let(:format) { 'doc' }
  let(:options) { { 'color' => false, 'path' => path, 'format' => format } }

  subject { described_class.call(options) }

  context 'no /node_modules folder' do
    let(:path) { './spec/files/case_1/' }

    it { is_expected.to be false }

    it 'displays correct message' do
      output_msg = <<-output.strip_heredoc
        Can't find `node_modules` folder inside './spec/files/case_1/' directory!

        Run `npm install` to install missing packages.
      output

      expect { subject }.to write_output(output_msg)
    end

    it 'displays correct colors' do
      options['color'] = true
      output_msg = <<-output.strip_heredoc
        Can't find `node_modules` folder inside './spec/files/case_1/' directory!
        \e[0;33;49m
        Run `npm install` to install missing packages.\e[0m
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  context 'no package.json file' do
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
  end

  context 'unexisted path' do
    let(:path) { './unexisted/' }
    let(:output_msg) { "There is no './unexisted/' directory.\n" }

    it { is_expected.to be false }

    it 'displays correct message' do
      expect { subject }.to write_output(output_msg)
    end
  end

  context 'incorrect json' do
    let(:path) { './spec/files/case_4' }
    let(:output_msg) { "Can't parse JSON file ./spec/files/case_4/package.json\n" }

    it { is_expected.to be false }

    it 'displays correct message' do
      expect { subject }.to write_output(output_msg)
    end
  end

  context 'unknown formatter' do
    let(:path) { './spec/files/case_2/' }
    let(:format) { 'whatever' }
    let(:output_msg) { "Unknown 'whatever' formatter" }

    it 'displays correct message' do
      expect(described_class).to receive(:abort).with(output_msg)

      subject
    end
  end

  context 'success check' do
    let(:path) { './spec/files/case_2/' }

    it { is_expected.to be true }

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Checked 3 packages. Everything is ok.
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  context 'failures check' do
    let(:path) { './spec/files/case_3/' }

    it { is_expected.to be false }

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Run `npm install` to install 3 missing packages.
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  context 'success version check' do
    let(:path) { './spec/files/case_5' }

    it { is_expected.to be true }

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Checked 6 packages. Everything is ok.
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  context 'failure version check' do
    let(:path) { './spec/files/case_6' }

    it { is_expected.to be false }

    it 'returns correct message' do
      output_msg = <<-output.strip_heredoc
        Run `npm install` to install 5 missing packages.
      output

      expect { subject }.to write_output(output_msg)
    end
  end
end
