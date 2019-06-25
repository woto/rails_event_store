require 'spec_helper'
require 'json'

module RubyEventStore
  module Mappers
    module Transformation
      RSpec.describe StringifyMetadataKeys do
        let(:uuid)  { SecureRandom.uuid }
        let(:item)  {
          Item.new(
            event_id:   uuid,
            metadata:   JSON.parse(JSON.dump({some: 'meta'})),
            data:       JSON.parse(JSON.dump({some: 'value'})),
            event_type: 'TestEvent',
          )
        }
        let(:changed_item)  {
          Item.new(
            event_id:   uuid,
            metadata:   {some: 'meta'},
            data:       JSON.parse(JSON.dump({some: 'value'})),
            event_type: 'TestEvent',
          )
        }

        specify "#dump" do
          result = StringifyMetadataKeys.new.dump(changed_item)
          expect(result).to eq(item)
          expect(result[:metadata].keys.map(&:class).uniq).to eq([String])
        end

        specify "#load" do
          result = StringifyMetadataKeys.new.load(changed_item)
          expect(result).to eq(item)
          expect(result[:metadata].keys.map(&:class).uniq).to eq([String])
        end

        specify "#inspect" do
          transformation = StringifyMetadataKeys.new
          object_id = transformation.object_id.to_s(16)
          expect(transformation.inspect).to eq("#<RubyEventStore::Mappers::Transformation::StringifyMetadataKeys:0x#{object_id}>")
        end
      end
    end
  end
end
