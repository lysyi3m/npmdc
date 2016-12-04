require 'spec_helper'

describe Npmdc do
  def no_color_options(arg = options)
    arg.merge('no_color' => true)
  end

  def doc_formatter(arg = options)
    arg.merge('format' => 'doc')
  end

  def progress_formatter(arg = options)
    arg.merge('format' => 'progress')
  end

  context 'no /node_modules folder' do
    let(:options) { {'path' => './spec/files/case_1/'} }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    it 'displays correct message' do
        output_msg = <<output
Failed! Can't find `node_modules` folder inside './spec/files/case_1/' directory!

Run `npm install` to install missing packages.
output

        expect{
          described_class.call(no_color_options)
        }.to output(output_msg).to_stdout
    end

    it 'displays correct colors' do
        output_msg = "Failed! Can't find `node_modules` folder inside './spec/files/case_1/' directory!\n\e[0;33;49m\nRun `npm install` to install missing packages.\e[0m\n"

        expect{
          described_class.call(options)
        }.to output(output_msg).to_stdout
    end
  end

  context 'no package.json file' do
    let(:options) { {'path' => './spec/'} }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    it 'displays correct message' do
      output_msg = <<output
There is no `package.json` file inside './spec/' directory.
output

      expect{
        described_class.call(no_color_options)
      }.to output(output_msg).to_stdout
    end

    it 'displays correct colors' do
        output_msg = "There is no `package.json` file inside './spec/' directory.\n"

        expect{
          described_class.call(options)
        }.to output(output_msg).to_stdout
    end
  end

  context 'unexisted path' do
    let(:options) { {'path' => './unexisted/'} }
    let(:output_msg) { "There is no './unexisted/' directory.\n" }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    it 'displays correct message' do
      expect{
        described_class.call(no_color_options)
      }.to output(output_msg).to_stdout
    end
  end

  context 'unexisted path' do
    let(:options) { {'path' => './unexisted/'} }
    let(:output_msg) { "There is no './unexisted/' directory.\n" }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    it 'displays correct message' do
      expect{
        described_class.call(no_color_options)
      }.to output(output_msg).to_stdout
    end
  end

  context 'incorrect json' do
    let(:options) { {'path' => './spec/files/case_4'}}
    let(:output_msg) { "Can't parse JSON file ./spec/files/case_4/package.json\n" }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    it 'displays correct message' do
      expect{
        described_class.call(no_color_options)
      }.to output(output_msg).to_stdout
    end

  end

  context 'success check' do
    let(:options) { {'path' => './spec/files/case_2/'} }

    it 'returns true' do
      expect(described_class.call(options)).to be true
    end

    context 'with progress formatter' do
      it 'returns correct message' do
        output_msg = <<output
Checking dependencies:
..

Checking devDependencies:
.

3 packages checked. Everything is ok.
output
        expect{
          described_class.call(progress_formatter no_color_options)
        }.to output(output_msg).to_stdout
      end

      it 'returns correct colors' do
        output_msg = "Checking dependencies:\n\e[0;32;49m.\e[0m\e[0;32;49m.\e[0m\n\nChecking devDependencies:\n\e[0;32;49m.\e[0m\n\n\e[0;32;49m3 packages checked. Everything is ok.\e[0m\n"
        expect{
          described_class.call(progress_formatter options)
        }.to output(output_msg).to_stdout
      end
    end

    context 'with doc formatter' do
      it 'returns correct message' do
        output_msg = <<output
Checking dependencies:
  ✓ foo
  ✓ bar

Checking devDependencies:
  ✓ foobar

3 packages checked. Everything is ok.
output
        expect{
          described_class.call(doc_formatter no_color_options)
        }.to output(output_msg).to_stdout
      end

      it 'returns correct colors' do
        output_msg = "Checking dependencies:\n\e[0;32;49m  ✓ foo\e[0m\n\e[0;32;49m  ✓ bar\e[0m\n\nChecking devDependencies:\n\e[0;32;49m  ✓ foobar\e[0m\n\n\e[0;32;49m3 packages checked. Everything is ok.\e[0m\n"
        expect{
          described_class.call(doc_formatter options)
        }.to output(output_msg).to_stdout
      end
    end
  end

  context 'failure check' do
    let(:options) { {'path' => './spec/files/case_3/'} }

    it 'returns false' do
      expect(described_class.call(options)).to be false
    end

    context 'with progress formatter' do
      it 'returns correct message' do
        output_msg = <<output
Checking dependencies:
.F

Checking devDependencies:
FF

Following dependencies required by your package.json file are missing or not installed properly:
  * bar@1.0.0
  * foobar@1.0.0
  * foobarfoo@1.0.0

Run `npm install` to install 3 missed packages.
output
        expect{
          described_class.call(progress_formatter no_color_options)
        }.to output(output_msg).to_stdout
      end

      it 'returns correct colors' do
        output_msg = "Checking dependencies:\n\e[0;32;49m.\e[0m\e[0;31;49mF\e[0m\n\nChecking devDependencies:\n\e[0;31;49mF\e[0m\e[0;31;49mF\e[0m\n\nFollowing dependencies required by your package.json file are missing or not installed properly:\n  * bar@1.0.0\n  * foobar@1.0.0\n  * foobarfoo@1.0.0\n\e[0;33;49m\nRun `npm install` to install 3 missed packages.\e[0m\n"
        expect{
          described_class.call(progress_formatter options)
        }.to output(output_msg).to_stdout
      end
    end
  end
end
