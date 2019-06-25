require 'spec_helper'

module RubyEventStore
  module Mappers
    module Transformation
      RSpec.describe Transformation::SerializedRecord do
        let(:uuid)   { SecureRandom.uuid }
        let(:record) { RubyEventStore::SerializedRecord.new(
          event_id: uuid,
          data: "---\n:some: value\n",
          metadata: "---\n:some: meta\n",
          event_type: 'TestEvent',
        ) }
        let(:item)   {
          Item.new(
            event_id:   uuid,
            data: "---\n:some: value\n",
            metadata: "---\n:some: meta\n",
            event_type: 'TestEvent',
          )
        }

        specify "#dump" do
          expect(SerializedRecord.new.dump(item)).to eq(record)
        end

        specify "#load" do
          expect(SerializedRecord.new.load(record)).to eq(item)
        end

        specify "#inspect" do
          transformation = SerializedRecord.new
          object_id = transformation.object_id.to_s(16)
          expect(transformation.inspect).to eq("#<RubyEventStore::Mappers::Transformation::SerializedRecord:0x#{object_id}>")
        end
      end
    end
  end
end
