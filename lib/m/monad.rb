class Monad
  # return :: a -> m a
  def self.return(value)
    new(value)
  end

  # join :: Monad m => m (m a) -> m a
  def self.join(value)
    result = value.fetch
    return result if result.is_a?(self)
    fail "Given value must wrap a Monad"
  end

  def self.fail(value)
    raise RuntimeError.new(value)
  end

  def initialize(value)
    @value = value
  end

  def fetch
    @value
  end

  # fmap :: (a -> b) -> r a -> r b
  def fmap(fn=nil, &block)
    self.class.return( call(fn || block) )
  rescue => e
    self.class.fail(e)
  end

  # (>>=) :: (Monad m) => m a -> (a -> m b) -> m b
  def bind(fn=nil, &block)
    self.class.join( fmap(fn, &block) )
  end
  alias :>= :bind

  def ==(other)
    return false unless other.is_a?(self.class)
    @value == other.fetch
  end

  def to_s
    "#{self.class.name}(#{self.fetch.inspect})"
  end
  alias :inspect :to_s

  private

  def call(callee)
    callee.call(@value)
  end
end
