require 'spec_helper'

describe Npmdc::Engine do
  let(:app) { Rails.application }

  it "adds npmdc config" do
    expect { app.config.npmdc }.not_to raise_error
  end

  it "set project root by default" do
    expect(app.config.npmdc.path).to eq Rails.root
  end

  context "intialization" do
    let(:initializer) { app.initializers.find { |ini| ini.name == 'npmdc.load_hook' } }

    it "works" do
      expect(initializer).not_to be_nil
      expect { initializer.run(app) }.to write_output("There is no `package.json`")
    end
  end
end
