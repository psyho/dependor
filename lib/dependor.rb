require 'dependor/constructor'

module Dependor
  autoload :AutoInject,           'dependor/auto_inject'
  autoload :AutoInjector,         'dependor/auto_injector'
  autoload :ClassNameResolver,    'dependor/class_name_resolver'
  autoload :CustomizedInjector,   'dependor/customized_injector'
  autoload :DependencyNamesCache, 'dependor/dependency_names_cache'
  autoload :EvaluatingInjector,   'dependor/evaluating_injector'
  autoload :Injectable,           'dependor/injectable'
  autoload :Instantiator,         'dependor/instantiator'
  autoload :Isolate,              'dependor/isolate'
  autoload :Singleton,            'dependor/singleton'
  autoload :Let,                  'dependor/let'
  autoload :SendingInjector,      'dependor/sending_injector'
  autoload :Shorty,               'dependor/shorty'
  autoload :UnknownObject,        'dependor/exceptions'
  autoload :VERSION,              'dependor/version'
end
