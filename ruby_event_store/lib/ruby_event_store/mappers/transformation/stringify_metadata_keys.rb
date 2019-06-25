# frozen_string_literal: true

module RubyEventStore
  module Mappers
    module Transformation
      class StringifyMetadataKeys
        def dump(item)
          stringify(item)
        end

        def load(item)
          stringify(item)
        end

        def inspect
          "#<#{self.class}:0x#{__id__.to_s(16)}>"
        end

        private
        def stringify(item)
          item.merge(
            metadata: TransformKeys.stringify(item.metadata),
          )
        end
      end
    end
  end
end
