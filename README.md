# Dependor 

[![build status](https://secure.travis-ci.org/psyho/dependor.png)](http://travis-ci.org/psyho/dependor)
[![Code Climate](https://codeclimate.com/github/psyho/dependor.png)](https://codeclimate.com/github/psyho/dependor)
[![Coverage Status](https://coveralls.io/repos/psyho/dependor/badge.png)](https://coveralls.io/r/psyho/dependor)
[![Gem Version](https://badge.fury.io/rb/dependor.png)](http://badge.fury.io/rb/dependor)
[![Dependency Status](https://gemnasium.com/psyho/dependor.png)](https://gemnasium.com/psyho/dependor)

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
  include Dependor::AutoInject
end

class EntryPoint
  extend Dependor::Injectable
  inject_from Injector
  
  inject :bar

  def run
    bar.do_bar
  end
end

EntryPoint.new.run
```

## Dependor::AutoInject

This is the core part of the library.
It looks at the constructor of a class to find out it's dependencies and instantiates it's instances with proper objects injected.
It looks up classes by name.

AutoInject can also use the methods declared on injector as injection sources, which is quite useful for things like configuration.

```ruby
class Injector
  include Dependor::AutoInject

  attr_reader :session

  def initialize(session)
    @session = session
  end

  let(:current_user) { current_user_service.get }
  let(:users_repository) { User }
  let(:comments_repository) { Comment }
end

class CurrentUserService
  takes :session, :users_repository

  def get
    @current_user ||= users_repository.find(session[:current_user_id])
  end
end

class CreatesComments
  takes :current_user, :comments_repository

  def create
    # ...
  end
end

class User < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end
```

## Dependor::Shorty

This makes the constructor definition less verbose and includes Dependor::Let for shorter method definition syntax.

```ruby
class Foo
  takes :foo, :bar, :baz
  let(:hello) { "world" }
end
```

is equivalent to:

```ruby
class Foo
  attr_reader :foo, :bar, :baz

  def initialize(foo, bar, baz)
    @foo = foo
    @bar = bar
    @baz = baz
  end

  def hello
    "world"
  end
end
```

## Dependor::Constructor

Sometimes you don't want to pollute every class with a `takes` method.
You can then shorten the class declaration with Dependor::Constructor.

```ruby
class Foo
  include Dependor::Constructor(:foo, :bar, :baz)
end
```

is equivalent to:

```ruby
class Foo
  def initialize(foo, bar, baz)
    @foo = foo
    @bar = bar
    @baz = baz
  end
end
```

## Dependor::Let

It allows a simpler syntax to define getter methods.

```ruby
class Foo
  def foo
    do_something_or_other
  end
end
```

becomes:

```ruby
class Foo
  extend Dependor::Let
  let(:foo) { do_something_or_other }
end
```

## Dependor::Injectable

You can include this to make usage of the injector more convenient.
This is used in the entry point of your application, typically a Rails controller.

```ruby
class MyInjector
  def foo
    "foo"
  end
end

class ApplicationController
  extend Dependor::Injectable
  inject_from MyInjector
end

class PostsController < ApplicationController
  inject :foo

  def get
    render text: foo
  end
end
```

Sometimes you might want to pass request, params or session to your injector.
Here is an example, how to do it:

```ruby
require 'dependor/shorty'

class MyInjector
  include Dependor::AutoInject

  takes :params, :session, :request

  def foo
    session[:foo]
  end
end

class ApplicationController
  extend Dependor::Injectable

  def injector
    @injector ||= MyInjector.new(params, session, request)
  end
end

class PostsController < ApplicationController
  inject :foo

  def get
    render text: foo
  end
end
```

## Dependor::Singleton

You can include this to make your service class as a singleton.

```ruby
class FooService
  include Dependor::Singleton
end

class MyInjector
  include Dependor::AutoInject

  takes :params, :session, :request
end

class ApplicationController
  extend Dependor::Injectable

  def injector
    @injector ||= MyInjector.new(params, session, request)
  end
end

class PostsController < ApplicationController
  inject :foo_service

  def get
    render text: foo_service.object_id == foo_service.object_id # true
  end
end
```

## Testing

Dependor doesn't add any dependencies to your classes so you can test them any way you like.

Following class:

```ruby
class PostCreator
  takes :post_repository

  def publish(post)
     post_repository.store(post)
  end
end
```

can be tested:

```ruby
let(:post_repository) { stub }
let(:creator) { PostCreator.new(post_repository }

it "stores posts" do
  post = Post.new
  post_repository.expects(:store).with(post)
  creator.publish(post)
end
```

## Dependor::Isolate

Dependor::Isolate provides `isolate` function that creates an instance of given class with dependencies taken from a local context. It can be easily integrated with rspec by requiring 'dependor/rspec'.

Previous example can be rewritten as:

```ruby
require 'dependor/rspec'

let(:post_repository) { stub }
let(:creator) { isolate(PostCreator) }

it "stores posts" do
  post = Post.new
  post_repository.expects(store).with(post)
  creator.publish(post)
end
```

Dependencies are taken from methods available in local context, but they can be specified in paramaters as well:

```ruby
post_repository = stub
creator = isolate(PostCreator, post_repository: post_repository)
```

Or they can be captured from local variables when syntax with block is used:

```ruby
post_repository = stub
creator = isolate{PostCreator}
```

## License

MIT. See the MIT-LICENSE file.

## Author

Adam Pohorecki

## Acknowledgements

Dependor::Shorty is inspired (or rather blatantly copied) from Gary Bernhardt's [Destroy All Software Screencast][das] ["Shorter Class Syntax"][shorter-syntax].

[das]: http://www.destroyallsoftware.com
[shorter-syntax]: https://www.destroyallsoftware.com/screencasts/catalog/shorter-class-syntax
