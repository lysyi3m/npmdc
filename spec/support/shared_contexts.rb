RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'npm', :shared_context => :metadata do
  let(:package_manager) { 'npm' }
  before { options['package_manager'] = 'npm' }

  def path_to_test_case(case_name)
    File.join("./spec/files/#{package_manager}", case_name)
  end
end

RSpec.shared_context 'yarn', :shared_context => :metadata do
  let(:package_manager) { 'yarn' }
  before { options['package_manager'] = 'yarn' }

  def path_to_test_case(case_name)
    File.join("./spec/files/#{package_manager}", case_name)
  end
end

RSpec.shared_context 'case_1_no_node_modules', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_1_no_node_modules') }
end

RSpec.shared_context 'case_2_success_3_packages_0_warnings', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_2_success_3_packages_0_warnings') }
end

RSpec.shared_context 'case_3_3_missing_packages', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_3_3_missing_packages') }
end

RSpec.shared_context 'case_4_broken_package_json', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_4_broken_package_json') }
end

RSpec.shared_context 'case_5_success_6_packages_0_warnings', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_5_success_6_packages_0_warnings') }
end

RSpec.shared_context 'case_6_5_missing_packages', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_6_5_missing_packages') }
end

RSpec.shared_context 'case_7_sucess_4_packages_3_warnings', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_7_sucess_4_packages_3_warnings') }
end

RSpec.shared_context 'case_8_no_yarn_lock', :shared_context => :metadata do
  let(:path) { path_to_test_case('case_8_no_yarn_lock') }
end

RSpec.configure do |rspec|
  rspec.include_context 'npm', :include_shared => true
  rspec.include_context 'yarn', :include_shared => true
  rspec.include_context 'case_1_no_node_modules', :include_shared => true
  rspec.include_context 'case_2_success_3_packages_0_warnings', :include_shared => true
  rspec.include_context 'case_3_3_missing_packages', :include_shared => true
  rspec.include_context 'case_4_broken_package_json', :include_shared => true
  rspec.include_context 'case_5_success_6_packages_0_warnings', :include_shared => true
  rspec.include_context 'case_6_5_missing_packages', :include_shared => true
  rspec.include_context 'case_7_sucess_4_packages_3_warnings', :include_shared => true
  rspec.include_context 'case_8_no_yarn_lock', :include_shared => true
end
