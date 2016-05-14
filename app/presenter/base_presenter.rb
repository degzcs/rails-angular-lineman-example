class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def method_missing(method_name, *args, &block)
    @object.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    @object.respond_to?(method_name, include_private) || super
  end

end

