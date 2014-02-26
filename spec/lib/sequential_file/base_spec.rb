require 'spec_helper'
require 'shared_examples_for_files'
require 'sequential_file/base'

describe SequentialFile::Base do
  FILE_BASE_TEST_PATH = File.join(GEM_ROOT, 'spec/tmp')
  describe "#initialize" do
    context "process date as empty string" do
      let(:file){ SequentialFile::Base.new({
                                       directory_path: FILE_BASE_TEST_PATH,
                                       name: 'access_log.FileBase.tsv',
                                       process_date: ''
                                     }) }
      subject { file }
      after(:each) do
        subject.delete!
      end
      it_behaves_like "a SequentialFile::Base"

      it('- class') { subject.class.should == SequentialFile::Base }
      it('- complete_filename') { subject.name.should == 'access_log.FileBase.1.tsv' }
      it('- complete_path') { subject.complete_path.should == File.join(subject.directory_path, 'access_log.FileBase.1.tsv') }
    end

    context "process date as nil" do
      let(:file){ SequentialFile::Base.new({
                                             directory_path: FILE_BASE_TEST_PATH,
                                             name: 'access_log.FileBase.tsv',
                                             process_date: nil
                                           }) }
      subject { file }
      after(:each) do
        subject.delete!
      end
      it_behaves_like "a SequentialFile::Base"

      it('- class') { subject.class.should == SequentialFile::Base }
      it('- complete_filename') { subject.name.should == "access_log.#{Date.today.strftime("%Y%m%d")}.FileBase.1.tsv" }
      it('- complete_path') { subject.complete_path.should == File.join(subject.directory_path, "access_log.#{Date.today.strftime("%Y%m%d")}.FileBase.1.tsv") }
    end

    context "process date as word" do
      let(:file){ SequentialFile::Base.new({
                                             directory_path: FILE_BASE_TEST_PATH,
                                             name: 'access_log.FileBase.tsv',
                                             process_date: 'today'
                                           }) }
      subject { file }
      after(:each) do
        subject.delete!
      end
      it_behaves_like "a SequentialFile::Base"

      it('- class') { subject.class.should == SequentialFile::Base }
      it('- complete_filename') { subject.name.should == 'access_log.today.FileBase.1.tsv' }
      it('- complete_path') { subject.complete_path.should == File.join(subject.directory_path, 'access_log.today.FileBase.1.tsv') }
    end
  end

end
