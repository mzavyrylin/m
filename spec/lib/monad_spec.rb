require "spec_helper"

describe Monad do
  it_behaves_like "a monad"

  context "default implementation" do
    it ".return wraps a given value" do
      expect(Monad.return(1)).to eq Monad.new(1)
    end

    it ".join unwraps a given value" do
      wrapped = Monad.return(Monad.return(1))
      expect(Monad.join(wrapped)).to eq Monad.return(1)
    end

    it ".join raises error if a given value is not a wrapped Monad" do
      expect{ Monad.join(Monad.return(1)) }.to raise_error
    end

    it ".fail raises error" do
      expect{ Monad.fail(1) }.to raise_error(RuntimeError)
    end
  end

  describe "#fmap" do
    it "accepts function" do
      f = ->(v){ v + 1 }
      expect(Monad.return(1).fmap(f)).to eq Monad.return(2)
    end

    it "accepts block" do
      expect(Monad.return(1).fmap{|v| v + 1}).to eq Monad.return(2)
    end
  end

  describe "#bind" do
    it "accepts function" do
      f = ->(v){ Monad.return(v + 1) }
      expect(Monad.return(1).bind(f)).to eq Monad.return(2)
    end

    it "accepts block" do
      expect(Monad.return(1).bind{|v| Monad.return(v + 1)}).to eq Monad.return(2)
    end
  end
end
