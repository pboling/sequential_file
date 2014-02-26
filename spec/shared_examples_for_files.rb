shared_examples "a SequentialFile::Base" do

  describe "ancestry" do
    it('- class') { subject.is_a?( SequentialFile::Base ).should == true }
  end

  describe "#write" do
    context "data to a file" do
      it('- should succeed') {
        lambda { subject.write('this is text') }.should_not raise_exception
      }
      it('- should be readable') {
        subject.write('this is text')
        subject.read.should =~ /this is text/
      }
    end
    context "after close" do
      it('- should write') {
        subject.write('this is text')
        subject.close
        lambda { subject.write('this is text') }.should_not raise_exception
      }
      it('- should be readable') {
        subject.write('this is new text')
        subject.close
        subject.write('this is after close text')
        subject.read.should =~ /this is after close text/
      }
    end
  end

  describe "#read" do
    context "data from a file" do
      it('- without block') { lambda { subject.read {} }.should_not raise_exception }
      it('- with block') { lambda { subject.read { |line| puts line } }.should_not raise_exception }
      it('- advances position') {
        subject.write('this is text')
        subject.read
        subject.read_position.should be == 12
      }
    end
  end

end
