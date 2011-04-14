class Foo
  def name
    "world"
  end
end

class Fake::Foo
  def name
    "fake"
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
