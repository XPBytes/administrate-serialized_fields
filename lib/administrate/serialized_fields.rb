require 'administrate/serialized_fields/version'

require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'

module Admin
  module SerializedFields
    extend ActiveSupport::Concern

    mattr_accessor :load_json
    self.load_json = defined?(Oj) ? -> (data) { Oj.load(data) } : -> (data) { JSON.parse(data) }

    class_methods do
      def deserialize_fields(*fields, load:)
        fields = Array(fields).map(&:to_s).freeze

        define_method(:read_param) do |key, data|
          return load.call(data) if fields.include?(String(key))
          # noinspection RubySuperCallWithoutSuperclassInspection
          super(key, data)
        end
      end

      def deserialize_json_fields(*fields)
        deserialize_fields(*fields, load: SerializedFields.load_json)
      end
    end
  end
end
