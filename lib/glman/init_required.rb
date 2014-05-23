module Glman
  module InitRequired
    class InitializationError < StandardError; end

    module ClassMethods
      def attr_required(*attrs)
        attrs.each do |attr|
          self.send(:attr_accessor, attr)
        end
        @__required_attributes = (@__required_attributes || []) + attrs
      end
    end

    module InstanceMethods
      def initialize(params={})
        params.each do |attr, value|
          self.send("#{attr}=", value)
        end if params
        required_attrs_valid?(params)
      end

      private

      def required_attrs_valid?(params)
        required_attrs = self.class.instance_variable_get(:@__required_attributes) || []
        return if required_attrs.empty?

        required_attrs.each do |key|
          sym_key = key.to_sym
          raise Glman::InitRequired::InitializationError.new("Missing #{sym_key} param during initiaization #{self.class}") unless params.has_key?(sym_key)
        end
      end
    end

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end
  end
end