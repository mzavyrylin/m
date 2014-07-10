module M
  class Either < Monad
    def self.return(value)
      return Left(value) if value.is_a?(Exception)
      return Left(value) if self == Left
      Right(value)
    end

    def self.fail(value)
      Left(value)
    end

    def self.join(value)
      return value if value.left?
      super
    end

    def fmap(fn=nil, &block)
      return self if left?
      super
    end

    def left?;  is_a? Left; end
    def right?; is_a? Right; end
  end

  def Either(value); Either.return(value); end
  def Right(value); Right.new(value); end
  def Left(value); Left.new(value); end

  class Right < Either; end
  class Left < Either; end
end
