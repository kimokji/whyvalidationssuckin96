require 'teststrap'
require 'whyvalidationssuckin96/attribute_based_validation'

context "attribute based validation mixin" do
  context "when mixed into a class" do
    
    setup do
      Class.new(WhyValidationsSuckIn96::Validation) do
        include WhyValidationsSuckIn96::SkippableValidation
        include WhyValidationsSuckIn96::AttributeBasedValidation
        
        def validate
          super
          pass
        end
        
      end # Class.new
    end   # setup
    
    should "fail if no attribute is specified during construction" do
      topic.new(Object.new)
    end.raises(ArgumentError, "The attribute to validate must be specified as :attribute")
    
    should "add an attribute accessor" do
      topic.new(Object.new, :attribute => :foo).attribute
    end.equals(:foo)
    
    context "when using :allow_nil" do
      
      should "skip validation if the validatable object is #nil?" do
        inst = topic.new(OpenStruct.new(:test => nil), :allow_nil => true, :attribute => :test)
        inst.validates?
        inst.has_run?
      end.equals(false)
      
      should "not skip validation of the validatable object is non-#nil?" do
        inst = topic.new(OpenStruct.new(:test => Object.new), :allow_nil => true, :attribute => :test)
        inst.validates?
        inst.has_run?
      end
    end # when using :allow_nil
    
    context "when using :allow_blank" do
      should "skip validation if the validatable object is #blank?" do
        inst = topic.new(OpenStruct.new(:test => ""), :allow_blank => true, :attribute => :test)
        inst.validates?
        inst.has_run?
      end.equals(false)
      
      should "not skip validation if the validatable object is non-#blank?" do
        inst = topic.new(OpenStruct.new(:test => "bzzt"), :allow_blank => true, :attribute => :test)
        inst.validates?
        inst.has_run?
      end
    end # when using :allow_blank
    
  end     # when mixed into a class
end       # skippable validation mixin