# frozen_string_literal: true

require 'yaml'

module RubyEventStore
  module Mappers
    module Transformation
      class Serialization
        def initialize(serializer: YAML)
          @serializer = serializer
        end

        attr_reader :serializer

        def dump(item)
          Item.new(
            event_id:            item.event_id,
            metadata:            item.metadata,
            data:                item.data,
            serialized_metadata: serializer.dump(item.metadata),
            serialized_data:     serializer.dump(item.data),
            event_type:          item.event_type
          )
        end

        def load(item)
          Item.new(
            event_id:            item.event_id,
            metadata:            serializer.load(item.serialized_metadata),
            data:                serializer.load(item.serialized_data),
            serialized_metadata: item.serialized_metadata,
            serialized_data:     item.serialized_data,
            event_type:          item.event_type
          )
        end
      end
    end
  end
end
