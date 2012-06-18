class Dependor::CustomizedInjector
  def initialize(injector, customizations)
    @injector = injector
    @customizations = customizations
  end

  def get(name)
    return @customizations[name] if @customizations.key?(name)
    return @injector.get(name)
  end
end
