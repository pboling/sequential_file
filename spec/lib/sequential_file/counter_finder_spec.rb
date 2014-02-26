require 'spec_helper'

describe SequentialFile::CounterFinder::NUMBER_REGEX do
  it('- should be a Regexp') { SequentialFile::CounterFinder::NUMBER_REGEX.should be_a(Regexp)}
  it('- should match numbers') { ('asdf5' =~ SequentialFile::CounterFinder::NUMBER_REGEX.should) == 4}
end

describe SequentialFile::CounterFinder do

  describe "#initialize" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.1.tsv', '.tsv') }
    subject { counter_finder }
    it('- class') { subject.class.should == SequentialFile::CounterFinder }
  end

  context "with counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.1.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { subject.has_extension_separator?.should == true }
    it('- counter') { subject.counter.should == 1 }
  end

  context "without counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { subject.has_extension_separator?.should == true }
    it('- counter') { subject.counter.should == 0 }
  end

  context "with large counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.10234856.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { subject.has_extension_separator?.should == true }
    it('- counter') { subject.counter.should == 10234856 }
  end

end
