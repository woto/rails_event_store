# frozen_string_literal: true

module RubyEventStore
  module Mappers
    module Transformation
      class SerializedRecord
        def dump(item)
          RubyEventStore::SerializedRecord.new(
            event_id:            item.event_id,
            metadata:            item.metadata,
            data:                item.data,
            serialized_metadata: item.serialized_metadata,
            serialized_data:     item.serialized_data,
            event_type:          item.event_type
          )
        end

        def load(serialized_record)
          Item.new(
            event_id:            serialized_record.event_id,
            metadata:            serialized_record.metadata,
            data:                serialized_record.data,
            serialized_metadata: serialized_record.serialized_metadata,
            serialized_data:     serialized_record.serialized_data,
            event_type:          serialized_record.event_type
          )
        end
      end
    end
  end
end
