# frozen_string_literal: true

module RubyEventStore
  module Mappers
    module Transformation
      class SymbolizeMetadataKeys
        def dump(item)
          symbolize(item)
        end

        def load(item)
          symbolize(item)
        end

        def inspect
          "#<#{self.class}:0x#{__id__.to_s(16)}>"
        end

        private
        def symbolize(item)
          item.merge(
            metadata: TransformKeys.symbolize(item.metadata),
          )
        end
      end
    end
  end
end
