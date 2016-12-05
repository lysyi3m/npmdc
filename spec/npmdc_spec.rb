require 'spec_helper'

describe Npmdc do
  let(:path) { nil }
  let(:options) { { color: false, path: path } }

  subject { described_class.call(options) }

  context 'no /node_modules folder' do
    let(:path) { './spec/files/case_1/' }

    it { is_expected.to be false }

    it 'displays correct message' do
      output_msg = <<~output
        Failed! Can't find `node_modules` folder inside './spec/files/case_1/' directory!

        Run `npm install` to install missing packages.
      output

      expect { subject }.to write_output(output_msg)
    end

    it 'displays correct colors', :color do
      options[:color] = true
      output_msg = <<~output
        Failed! Can't find `node_modules` folder inside './spec/files/case_1/' directory!\n\e[0;33;49m
        Run `npm install` to install missing packages.\e[0m
      output

      expect { subject }.to write_output(output_msg)
    end
  end

  context 'no package.json file' do
    let(:path) { './spec/' }

    it { is_expected.to be false }

    it 'displays correct message' do
      output_msg = <<~output
        There is no `package.json` file inside './spec/' directory.
      output

      expect { subject }.to write_output(output_msg)
    end

    it 'displays correct colors' do
      options[:color] = true
 
      output_msg = <<~output
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

  context 'success check' do
    let(:path) { './spec/files/case_2/' }

    it { is_expected.to be true }

    context 'with progress formatter' do
      before { options[:format] = 'progress' }

      it 'returns correct message' do
        output_msg = <<~output
          Checking dependencies:
          ..

          Checking devDependencies:
          .

          Checked 3 packages. Everything is ok.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct colors' do
        options[:color] = true

        output_msg = <<~output
          Checking dependencies:
          \e[0;32;49m.\e[0m\e[0;32;49m.\e[0m

          Checking devDependencies:
          \e[0;32;49m.\e[0m

          \e[0;32;49mChecked 3 packages. Everything is ok.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end

    context 'with doc formatter' do
      before { options[:format] = 'doc' }

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
        options[:color] = true
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
  end

  context 'failure check' do
    let(:path) { './spec/files/case_3/' }

    it { is_expected.to be false }

    context 'with progress formatter' do
      before { options[:format] = 'progress' }

      it 'returns correct message' do
        output_msg = <<~output
          Checking dependencies:
          .F

          Checking devDependencies:
          FF

          Following dependencies required by your package.json file are missing or not installed properly:
            * bar@1.0.0
            * foobar@1.0.0
            * foobarfoo@1.0.0

          Run `npm install` to install 3 missing packages.
        output

        expect { subject }.to write_output(output_msg)
      end

      it 'returns correct colors' do
        options[:color] = true
        output_msg = <<~output
          Checking dependencies:
          \e[0;32;49m.\e[0m\e[0;31;49mF\e[0m

          Checking devDependencies:
          \e[0;31;49mF\e[0m\e[0;31;49mF\e[0m

          Following dependencies required by your package.json file are missing or not installed properly:
            * bar@1.0.0
            * foobar@1.0.0
            * foobarfoo@1.0.0
          \e[0;33;49m
          Run `npm install` to install 3 missing packages.\e[0m
        output

        expect { subject }.to write_output(output_msg)
      end
    end
  end
end
