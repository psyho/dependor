class ExampleBuilder
  include Aruba::Api

  def initialize(scenario)
    @scenario = scenario
  end

  def add_require(string)
    requires << string
  end

  def add_class(string)
    classes << string
  end

  def add_run_block(string)
    run_blocks << string
  end

  def output
    @output ||= run_example
  end

  private

  attr_reader :scenario

  def example_name
    scenario.gsub(/[^a-zA-Z0-9]/, '_').downcase + ".rb"
  end

  def run_example
    write_file(example_name, example_contents)
    cmd = "ruby #{example_name}"
    run_simple(unescape(cmd))
    all_output.strip
  end

  def example_contents
    <<-EOF
#{requires.join("\n")}

#{classes.join("\n")}

#{run_blocks.join("\n")}
    EOF
  end

  def requires
    @requires ||= []
  end

  def classes
    @classes ||= []
  end

  def run_blocks
    @run_blocks ||= []
  end
end

def example_builder
  @example_builder ||= ExampleBuilder.new(@scenario.title)
end
