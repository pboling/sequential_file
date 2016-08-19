shared_examples "a SequentialFile::Base" do

  describe "ancestry" do
    it('- class') { expect(subject.is_a?( SequentialFile::Base )).to eq(true) }
  end

  describe "#write" do
    context "data to a file" do
      it('- should succeed') {
        expect { subject.write('this is text') }.not_to raise_exception
      }
      it('- should be readable') {
        subject.write('this is text')
        expect(subject.read).to match(/this is text/)
      }
    end
    context "after close" do
      it('- should write') {
        subject.write('this is text')
        subject.close
        expect { subject.write('this is text') }.not_to raise_exception
      }
      it('- should be readable') {
        subject.write('this is new text')
        subject.close
        subject.write('this is after close text')
        expect(subject.read).to match(/this is after close text/)
      }
    end
  end

  describe "#read" do
    context "data from a file" do
      it('- without block') { expect { subject.read {} }.not_to raise_exception }
      it('- with block') { expect { subject.read { |line| puts line } }.not_to raise_exception }
      it('- advances position') {
        subject.write('this is text')
        subject.read
        expect(subject.read_position).to eq(12)
      }
    end
  end

end
