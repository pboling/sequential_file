require 'spec_helper'

describe SequentialFile::CounterFinder::NUMBER_REGEX do
  it('- should be a Regexp') { expect(SequentialFile::CounterFinder::NUMBER_REGEX).to be_a(Regexp)}
  it('- should match numbers') { expect('asdf5'.match(SequentialFile::CounterFinder::NUMBER_REGEX)).to eq(4) }
end

describe SequentialFile::CounterFinder do

  describe "#initialize" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.1.tsv', '.tsv') }
    subject { counter_finder }
    it('- class') { expect(subject.class).to eq(SequentialFile::CounterFinder) }
  end

  context "with counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.1.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { expect(subject.has_extension_separator?).to eq(true) }
    it('- counter') { expect(subject.counter).to eq(1) }
  end

  context "without counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { expect(subject.has_extension_separator?).to eq(true) }
    it('- counter') { expect(subject.counter).to eq(0) }
  end

  context "with large counter" do
    let(:counter_finder){ SequentialFile::CounterFinder.new('access_log.FileBase.10234856.tsv', '.tsv') }
    subject { counter_finder }
    it('- has_extension_separator?') { expect(subject.has_extension_separator?).to eq(true) }
    it('- counter') { expect(subject.counter).to eq(10234856) }
  end

end
