require 'spec_helper'

require 'rails'
require 'npmdc/railtie'

describe Npmdc::Railtie do
  using StringStripHeredoc

  def within_new_app(root = File.expand_path('../dummy', __FILE__))
    old_app = Rails.application

    old_path =  Npmdc.config.path
    Npmdc.config.remove_instance_variable :@path

    FileUtils.mkdir_p(root)
    Dir.chdir(root) do
      Rails.application = nil

      Class.new(Rails::Application) do |a|
        a.config.npmdc.format = :doc
        a.config.npmdc.color = false
      end


      yield Rails.application
    end
  ensure
    Npmdc.config.path = old_path
    Rails.application = old_app
  end

  it "adds npmdc config" do
    within_new_app do |app|
      expect { app.config.npmdc }.not_to raise_error
    end
  end

  it "handles options in config" do
    within_new_app do |app|
      expect(app.config.npmdc.format).to eq :doc
    end
  end

  describe "initializers" do
    context "initialize" do
      let(:name) { "npmdc.initialize"}

      it "set project root by default" do
        within_new_app do |app|
          initializer = app.initializers.find { |i| i.name == name }
          initializer.run(app)

          expect(app.config.npmdc.path).to eq Rails.root
        end
      end
    end

    context "development_only" do
      let(:name) { "npmdc.development_only"}

      before { allow(Rails.env).to receive(:development?).and_return(false) }

      it "aborts initialization" do
        within_new_app do |app|
          initializer = app.initializers.find { |i| i.name == name }

          expect_any_instance_of(described_class).to receive(:abort)

          app.config.npmdc.development_only = true

          initializer.run(app)
        end
      end

      it "allows initialization" do
        within_new_app do |app|
          initializer = app.initializers.find { |i| i.name == name }

          expect_any_instance_of(described_class).not_to receive(:abort)

          app.config.npmdc.development_only = false

          initializer.run(app)
        end
      end
    end

    context "call" do
      let(:name) { 'npmdc.call'}

      it "shows input" do
        within_new_app do |app|
          initializer = app.initializers.find { |i| i.name == name }

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
end
