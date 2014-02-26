require 'spec_helper'
require 'shared_examples_for_files'
require 'sequential_file/base'

class BumpFileB < SequentialFile::Base
  include SequentialFile
end

class BumpFile < BumpFileB
  def initialize(options = {})
    options[:file_extension] = '.json'
    super options
  end
end

describe BumpFile do
  NAMER_TEST_PATH = File.join(GEM_ROOT, 'spec/tmp')
  describe "as a file" do
    let(:file){ BumpFile.new({ directory_path: NAMER_TEST_PATH, process_date: Date.new(2014,2,14) }) }
    subject { file }
    after(:each) do
      subject.delete
    end
    it_behaves_like "a SequentialFile::Base"
  end
  describe "#initialize" do
    context "basic options" do
      before(:each) do
        @bump_file = BumpFile.new({ directory_path: NAMER_TEST_PATH, process_date: Date.new(2014,2,14) })
      end
      it('- class') { @bump_file.class.should == BumpFile }
      it('- name') { @bump_file.name.should == '.20140214..1.json' }
      it('- complete_path') { @bump_file.complete_path.should == File.join(@bump_file.directory_path, '.20140214..1.json') }
    end
    context "realistic options" do
      before(:each) do
        @bump_file = BumpFile.new({
                                     directory_path: NAMER_TEST_PATH,
                                     filename_first_part: 'asdf',
                                     filename_third_part: 'qwer',
                                     process_date: Date.new(2014,2,14)
                                   })
      end
      it('- filename_counter') { @bump_file.last_filename_counter.should == 1 }
      it('- name') { @bump_file.name.should == 'asdf.20140214.qwer.1.json' }
      it('- complete_path') { @bump_file.complete_path.should == File.join(@bump_file.directory_path, 'asdf.20140214.qwer.1.json') }
    end
    context "name option" do
      before(:each) do
        @bump_file = BumpFile.new({
                                     directory_path: NAMER_TEST_PATH,
                                     name: 'abra.cadabra.log',
                                     process_date: Date.new(2014,3,14)
                                   })
      end
      it('- filename_counter') { @bump_file.last_filename_counter.should == 1 }
      it('- name') { @bump_file.name.should == 'abra.20140314.cadabra.1.log' }
      it('- complete_path') { @bump_file.complete_path.should == File.join(@bump_file.directory_path, 'abra.20140314.cadabra.1.log') }
    end
    context "append" do
      before(:each) do
        @bump_file = BumpFile.new({
                                       directory_path: NAMER_TEST_PATH,
                                       name: 'abra.cadabra.log',
                                       process_date: Date.new(2014,3,14),
                                       append: true
                                     })
      end
      it('- filename_counter') { @bump_file.last_filename_counter.should == 0 }
      it('- name') { @bump_file.name.should == 'abra.20140314.cadabra.0.log' }
      it('- complete_path') { @bump_file.complete_path.should == File.join(@bump_file.directory_path, 'abra.20140314.cadabra.0.log') }
    end
    context "pre-existing file on counter #42" do
      before(:each) do
        @bump_file = BumpFile.new({
                                     directory_path: File.join(GEM_ROOT,'spec/test_data'),
                                     filename_first_part: 'asdf',
                                     filename_third_part: 'qwer',
                                     process_date: Date.new(2014,2,14)
                                   })
      end
      it('- last_filename_counter') { @bump_file.last_filename_counter.should == 43 }
      it('- name') { @bump_file.name.should == 'asdf.20140214.qwer.43.json' }
      it('- complete_path') { @bump_file.complete_path.should == File.join(GEM_ROOT,'spec/test_data', 'asdf.20140214.qwer.43.json') }
    end
  end
  describe "#write" do
    context "data to a file" do
      before(:each) do
        @bump_file = BumpFile.new({
                                     directory_path: File.join(GEM_ROOT,'spec/scratch'),
                                     filename_first_part: 'asdf',
                                     filename_third_part: 'qwer',
                                     process_date: Date.new(2014,2,14)
                                   })
      end
      after(:each) do
        @bump_file.delete
      end
      it('- no exception') { lambda { @bump_file.write('This is bogus') }.should_not raise_exception }
      it('- can read what was written') {
        @bump_file.write('This is bogus')
        # Because of the random seeding of test order this spec may run before the one above
        # So "This is bogus" may be printed once or twice.
        @bump_file.read.should =~ /This is bogus/
      }
    end
  end
end
