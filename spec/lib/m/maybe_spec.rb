require "spec_helper"

describe M::Maybe do
  it_behaves_like "a monad"

  describe "shortcut methods" do
    it "Just() is a shortcut to Just.return" do
      expect(Just(1)).to   eq Just.return(1)
      expect(Just("1")).to eq Just.return("1")
      expect(Just(nil)).to eq Just.return(nil)
    end
  end

  describe ".return" do
    it "wraps any value into Just" do
      expect(Maybe.return(1)).to   eq Just(1)
      expect(Maybe.return("1")).to eq Just("1")
      expect(Maybe.return(nil)).to eq Just(nil)
    end
  end

  describe "#fmap" do
    context "Nothing" do
      it "returns self" do
        f = ->(v){ v + 1 }
        expect(Nothing.fmap(f)).to eq Nothing
      end

      it "doesn't cause side effects" do
        @var = false
        f = ->(v){ @var = true }
        expect{ Nothing.fmap(f) }.to_not change{ @var }
      end
    end

    context "Just" do
      it "performs calculation" do
        @var = false
        f = ->(v){ @var = true; v + 1 }
        expect{ Just(1).fmap(f) }.to change{ @var }
        expect(Just(1).fmap(f)).to eq Just(2)
      end
    end
  end

  describe "#bind" do
    context "Nothing" do
      it "returns self" do
        f = ->(v){ Just(v + 1) }
        expect(Nothing.bind(f)).to eq Nothing
      end

      it "doesn't cause side effects" do
        @var = false
        f = ->(v){ Just(@var = true) }
        expect{ Nothing.bind(f) }.to_not change{ @var }
      end
    end

    context "Just" do
      it "performs calculation" do
        @var = false
        f = ->(v){ @var = true; Just(v + 1) }
        expect{ Just(1).bind(f) }.to change{ @var }
        expect(Just(1).bind(f)).to eq Just(2)
      end
    end
  end
end
