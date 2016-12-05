require 'spec_helper'

describe Npmdc::Engine do
  let(:app) { Rails.application }

  it "adds npmdc config" do
    expect { app.config.npmdc }.not_to raise_error
  end

  it "set project root by default" do
    expect(app.config.npmdc.path).to eq Rails.root
  end

  it "handles options in config" do
    expect(app.config.npmdc.format).to eq :doc
  end

  context "intialization" do
    let(:initializer) { app.initializers.find { |ini| ini.name == 'npmdc.load_hook' } }

    it "works" do
      expect(initializer).not_to be_nil
      expect(Npmdc).to receive(:call).with(a_hash_including('path' => Rails.root, 'format' => :doc))
      initializer.run(app)
    end
  end
end
