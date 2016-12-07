require 'spec_helper'

describe Npmdc::Formatter do

  describe '.call' do
    subject { described_class.call(options) }

    let(:known_formatter) do
      Class.new do
        def initialize(*)
        end
      end
    end

    before do
      stub_const('Npmdc::Formatter::FORMATTERS', { known: known_formatter })
    end

    context 'with known formatter' do
      let(:options) { { 'format' => 'known' } }

      it 'returns proper formatter class' do
        is_expected.to be_a(known_formatter)
      end
    end

    context 'with unknown formatter' do
      let(:options) { { 'format' => 'unknown' } }

      it 'raises proper exception' do

        expect { subject }.to raise_error(Npmdc::Errors::UnknownFormatter)
      end
    end
  end
end
