class Foo
  def name
    "world"
  end

  def do_stuff(*args)
  end

  def self.fake
    Fake::Foo.new
  end
end

class Fake::Foo
  def name
    "fake"
  end

  def do_stuff(*args)
    "fake doing stuff: #{args.inspect}"
  end
end

class Bar
  include Dependor::Injectable

  depends_on :foo

  def hello
    return "Hello #{foo.name}!"
  end

end

class Fake::Bar
  def hello
    "Hello?"
  end
end

class Baz
  include Dependor::Injectable

  depends_on :bar
end
