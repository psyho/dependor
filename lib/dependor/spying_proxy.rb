class SpyingProxy

  instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$|^should$|^should_not$)/ }

  def initialize(fake_object)
    @fake_object = fake_object
    @method_calls = []
  end

  def __method_calls__
    @method_calls
  end

  protected

  def method_missing(name, *args, &block)
    result = @fake_object.send(name, *args, &block)

    @method_calls << [name, args]

    return result
  end

end
