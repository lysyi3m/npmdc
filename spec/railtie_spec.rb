require 'spec_helper'

describe Npmdc::Railtie do
  using StringStripHeredoc

  let(:app) { Rails.application }

  it "adds npmdc config" do
    expect { app.config.npmdc }.not_to raise_error
  end

  it "handles options in config" do
    expect(app.config.npmdc.format).to eq :doc
  end

  describe "initializers" do
    let(:initializer) do
      app.initializers.find { |ini| ini.name == name }
    end

    context "initialize" do
      let(:name) { 'npmdc.initialize'}

      it "set project root by default" do
        expect(app.config.npmdc.path).to eq Rails.root
      end
    end

    context "call" do
      let(:name) { 'npmdc.call'}

      it "shows input" do
        expect(initializer).not_to be_nil
        output_msg = <<-output.strip_heredoc
          Checking dependencies:
            ✗ foo
            ✗ bar
        output

        expect { initializer.run(app) }.to write_output(output_msg)
      end
    end
  end
end
