require 'dependor/constructor'

module Dependor
  autoload :AutoInject,        'dependor/auto_inject'
  autoload :AutoInjector,      'dependor/auto_injector'
  autoload :ClassNameResolver, 'dependor/class_name_resolver'
  autoload :Injectable,        'dependor/injectable'
  autoload :Instantiator,      'dependor/instantiator'
  autoload :Let,               'dependor/let'
  autoload :Shorty,            'dependor/shorty'
  autoload :UnknownObject,     'dependor/exceptions'
  autoload :VERSION,           'dependor/version'
end
