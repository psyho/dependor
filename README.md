# Dependor

## What is Dependor

Dependor is a set of helpers that make writing Ruby apps that use the dependency injection pattern easier.
It comes as a set of modules, which you can selectively add to your project.
It is designed do play nice with Rails and similar frameworks.

## Manual Dependency Injection

```ruby
class Foo
  def do_foo
    "foo"
  end
end

class Bar
  def initialize(foo)
    @foo = foo
  end

  def do_bar
    @foo.do_foo + "bar"
  end
end

class Injector
  def foo
    Foo.new
  end

  def bar
    Bar.new(foo)
  end
end

class EntryPoint
  def inject
    @injector ||= Injector.new
  end

  def bar
    inject.bar
  end

  def run
    bar.do_bar
  end
end

EntryPoint.new.run
```

## The same thing with Dependor

```ruby
require 'dependor'
require 'dependor/shorty'

class Foo
  def do_foo
    "foo"
  end
end

class Bar
  takes :foo

  def do_bar
    @foo.do_foo + "bar"
  end
end

class Injector
  include Dependor::AutomagicallyInjectsDependencies
end

class EntryPoint
  include Dependor::Injectable(Injector)
  
  inject :bar

  def run
    bar.do_bar
  end
end

EntryPoint.new.run
```

## Dependor::AutomagicallyInjectsDependencies

This is the core part of the library.
It looks at the constructor of a class to find out it's dependencies and instantiates it's instances with proper objects injected.

## Dependor::Shorty

This makes the constructor definition less verbose.

## Dependor::Injectable

You can include this to make usage of the injector more convenient.

## License

MIT. See the LICENSE file.

## Author

Adam Pohorecki

