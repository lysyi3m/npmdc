require 'spec_helper'

describe Npmdc::ModulesDirectory do
  let(:path) { './spec/files/case_1/' }
  let(:modules_directory) { described_class.new(path) }

  describe '#basename' do
    subject { modules_directory.basename }

    it { is_expected.to eq 'case_1' }
  end

  describe '#scoped?' do
    subject { modules_directory.scoped? }

    context 'when directory is not scoped' do
      it { is_expected.to eq false }
    end

    context 'when directory is scoped' do
      let(:path) { './spec/files/@case_1/' }

      it { is_expected.to eq true }
    end
  end

  describe '#valid_directories' do
    subject { modules_directory.valid_directories.map(&:path) }

    context 'when there are no directories' do
      it { is_expected.to eq [] }
    end

    context 'when there are directories with package.json' do
      let(:path) { './spec/files/case_2/node_modules' }
      it do
        is_expected.to eq [
          './spec/files/case_2/node_modules/bar',
          './spec/files/case_2/node_modules/foo',
          './spec/files/case_2/node_modules/foobar'
        ]
      end
    end

    context 'when there are scoped directories' do
      let(:path) { './spec/files/case_8/node_modules' }
      it do
        is_expected.to eq [
          './spec/files/case_8/node_modules/@bar',
          './spec/files/case_8/node_modules/@foo'
        ]
      end
    end

    context 'when there are directories without package.json' do
      let(:path) { './spec/files/case_9/node_modules/@bar' }
      it { is_expected.to eq ['./spec/files/case_9/node_modules/@bar/foo'] }
    end
  end

  describe '#package_json' do
    subject { modules_directory.package_json }
    let(:package_json_hash) do
      {
        'name' => 'case_1',
        'main' => 'index.js',
        'dependencies' => {
          'foo' => '1.0.0',
          'bar' => '2.0.0'
        },
        'license' => 'ISC'
      }
    end

    it { is_expected.to eq package_json_hash }
  end
end
