require "spec_helper"

shared_examples "a monad" do
  let(:m){ described_class }

  specify "Left identity: return a >>= f  ≡  f a" do
    f = ->(v){ m.return(v + 1) }
    result = m.return(1).bind(f)

    expect(result).to eq( f.call(1) )
  end

  specify "Right identity: m >>= return  ≡  m" do
    f = ->(v){ m.return(v) }
    result = m.return(1).bind(f)

    expect(result).to eq( m.return(1) )
  end

  specify "Associativity: (m >>= f) >>= g  ≡  m >>= (\\x -> f x >>= g)" do
    f = ->(v){ m.return(v + 1) }
    g = ->(v){ m.return(v + 10) }

    first  = m.return(1).bind(f).bind(g)
    second = m.return(1).bind{|v| f.call(v).bind(g)}

    expect(first).to eq(second)
  end
end
