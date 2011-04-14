module Dependor
  class DependencyToClassNameConverter

    def convert(dependency_name)
      class_name = dashes_to_colons(dependency_name.to_s)
      return camelize(class_name)
    end

    private

    def camelize(string)
      string.gsub(/^[a-z]/){|s| s.upcase}.gsub(/_+/, '_').gsub(/_[a-z]/){|s| s[1].upcase}
    end

    def dashes_to_colons(string)
      string.gsub('-', '::_')
    end

  end
end
