require "spec_helper"

describe Either do
  it_behaves_like "a monad"

  describe "shortcut methods" do
    it "Right() is a shortcut to Right.return" do
      expect(Right(1)).to   eq Right.return(1)
      expect(Right("1")).to eq Right.return("1")
      expect(Right(nil)).to eq Right.return(nil)
    end

    it "Left() is a shortcut to Left.return" do
      expect(Left(1)).to   eq Left.return(1)
      expect(Left("1")).to eq Left.return("1")
      expect(Left(nil)).to eq Left.return(nil)
    end
  end

  describe ".return" do
    it "wraps any Exception into Left" do
      expect(Either.return(Exception.new)).to    eq Left(Exception.new)
      expect(Either.return(RuntimeError.new)).to eq Left(RuntimeError.new)
    end

    it "wraps any other into Right" do
      expect(Either.return(1)).to   eq Right(1)
      expect(Either.return("1")).to eq Right("1")
      expect(Either.return(nil)).to eq Right(nil)
    end
  end

  describe ".fail" do
    it "wraps given value into Left" do
      expect(Either.fail(1)).to   eq Left(1)
      expect(Either.fail(nil)).to eq Left(nil)
      expect(Either.fail(Exception.new)).to eq Left(Exception.new)
    end
  end

  describe "#fmap" do
    context "Left" do
      it "returns self" do
        f = ->(v){ v + 1 }
        expect(Left(1).fmap(f)).to eq Left(1)
      end

      it "doesn't cause side effects" do
        @var = false
        f = ->(v){ @var = true }
        expect{ Left(1).fmap(f) }.to_not change{ @var }
      end
    end

    context "Right" do
      it "performs calculation" do
        @var = false
        f = ->(v){ @var = true; v + 1 }
        expect{ Right(1).fmap(f) }.to change{ @var }
        expect(Right(1).fmap(f)).to eq Right(2)
      end
    end

    it "wraps any occuring error with Left" do
      f = ->(v){ fail StandardError.new("error") }
      result = Right(1).fmap(f)

      expect(result).to be_a Left
      expect(result.fetch).to be_a StandardError
      expect(result.fetch.message).to eq "error"
    end
  end

  describe "#bind" do
    context "Left" do
      it "returns self" do
        f = ->(v){ Right(v + 1) }
        expect(Left(1).bind(f)).to eq Left(1)
      end

      it "doesn't cause side effects" do
        @var = false
        f = ->(v){ Right(@var = true) }
        expect{ Left(1).bind(f) }.to_not change{ @var }
      end
    end

    context "Right" do
      it "performs calculation" do
        @var = false
        f = ->(v){ @var = true; Right(v + 1) }
        expect{ Right(1).bind(f) }.to change{ @var }
        expect(Right(1).bind(f)).to eq Right(2)
      end
    end

    it "wraps any occuring error into Left" do
      f = ->(v){ fail StandardError.new("error") }
      result = Right(1).bind(f)

      expect(result).to be_a Left
      expect(result.fetch).to be_a StandardError
      expect(result.fetch.message).to eq "error"
    end
  end
end
