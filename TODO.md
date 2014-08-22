# TODO

* make class name resolution work inside blocks (no instance_eval)
* separate the notion of autoinject and "source module"
* allow defining objects without a block
* detect dependencies on classes that don't extend Takes
* detect dependencies in 1.9.3 (positional args) and 2.0 (keyword args) formats
* allow defining providers
* cycle detection + better error message in object not found
* combining injectors
* overwriting dependencies for a single call
* wrapping returned objects
* make it possible to use other things than symbols as object identifiers (at least classes)
* benchmark, ensure at least 10x faster than previous version
* 1.0 compatibility shim
* docs
