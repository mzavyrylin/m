require "spec_helper"

shared_examples "a monad" do
  let(:m){ described_class }

  specify "Left identity: return a >>= f  ≡  f a" do
    f = ->(v){ m.unit(v + 1) }
    result = m.unit(1).bind{ |v| f.call(v) }

    expect(result).to eq( f.call(1) )
  end

  specify "Right identity: m >>= return  ≡  m" do
    result = m.unit(1).bind{ |v| m.unit(v) }

    expect(result).to eq( m.unit(1) )
  end

  specify "Associativity: (m >>= f) >>= g  ≡  m >>= (\\x -> f x >>= g)" do
    f = ->(v){ m.unit(v + 1) }
    g = ->(v){ m.unit(v + 10) }

    first  = m.unit(1).bind{ |x| f.call(x) }.bind{ |y| g.call(y) }
    second = m.unit(1).bind{ |x| f.call(x).bind{ |y| g.call(y) } }

    expect(first).to eq( second )
  end
end
