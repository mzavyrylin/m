class Monad
  def self.unit(value)
    fail NotImplementedError
  end

  def initialize(value)
    @value = value
  end

  def fetch
    @value
  end

  def bind(fn=nil, &block)
    fail NotImplementedError
  end
  alias :>= :bind
  alias :>> :bind

  def call(value)
    self.class.unit(value)
  end

  def ==(other)
    return false unless other.is_a?(self.class)
    @value == other.fetch
  end

  def to_s
    klass_name = self.class.name.split("::").last
    "#{klass_name}(#{self.fetch.inspect})"
  end
end
