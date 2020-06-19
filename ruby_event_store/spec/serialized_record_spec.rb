require 'spec_helper'

module RubyEventStore

  RSpec.describe SerializedRecord do
    let(:event_id)            { "event_id" }
    let(:data)                { { foo: :bar } }
    let(:metadata)            { { baz: :bax } }
    let(:event_type)          { "event_type" }
    let(:serialized_data)     { "data" }
    let(:serialized_metadata) { "metadata" }

    specify 'constructor accept all arguments and returns frozen instance' do
      record = SerializedRecord.new(
        event_id:            event_id,
        data:                data,
        metadata:            metadata,
        event_type:          event_type,
        serialized_data:     serialized_data,
        serialized_metadata: serialized_metadata
      )

      expect(record.event_id).to            be(event_id)
      expect(record.metadata).to            be(metadata)
      expect(record.data).to                be(data)
      expect(record.event_type).to          be(event_type)
      expect(record.serialized_data).to     be(serialized_data)
      expect(record.serialized_metadata).to be(serialized_metadata)
      expect(record.frozen?).to             be(true)
    end

    specify 'constructor raised SerializedRecord::StringsRequired when argument is not a String' do
      [
        [1, 1, 1, 1, 1, 1],
        [1, "string", "string", "string", "string", "string"],
        ["string", "string", "string", 1, 1, 1],
        ["string", "string", "string", "string", 1, 1],
        ["string", "string", "string", "string", "string", 1],
        ["string", "string", "string", 1, "string", "string"],
        ["string", "string", "string", "string", 1, "string"],
      ].each do |sample|
        event_id, data, metadata, event_type, serialized_data, serialized_metadata = sample
        expect do
          SerializedRecord.new(
            event_id:            event_id,
            data:                data,
            metadata:            metadata,
            event_type:          event_type,
            serialized_data:     serialized_data,
            serialized_metadata: serialized_metadata
          )
        end.to raise_error SerializedRecord::StringsRequired
      end
    end

    specify "in-equality" do
      [
        ["a", "a", "a", "a", "a", "a"],
        ["b", "a", "a", "a", "a", "a"],
        ["a", "b", "a", "a", "a", "a"],
        ["a", "a", "b", "a", "a", "a"],
        ["a", "a", "a", "b", "a", "a"],
        ["a", "a", "a", "a", "b", "a"],
        ["a", "a", "a", "a", "a", "b"],
      ].permutation(2).each do |one, two|
        a = SerializedRecord.new(event_id: one[0], data: one[1], metadata: one[2], event_type: one[3], serialized_data: one[4], serialized_metadata: one[5])
        b = SerializedRecord.new(event_id: two[0], data: two[1], metadata: two[2], event_type: two[3], serialized_data: two[4], serialized_metadata: two[5])
        c = Class.new(SerializedRecord).new(event_id: one[0], data: one[1], metadata: one[2], event_type: one[3], serialized_data: one[4], serialized_metadata: one[5])
        expect(a).not_to eq(b)
        expect(a).not_to eql(b)
        expect(a.hash).not_to eq(b.hash)
        h = {a => :val}
        expect(h[b]).to be_nil

        expect(a).not_to eq(c)
        expect(a).not_to eql(c)
        expect(a.hash).not_to eq(c.hash)
        h = {a => :val}
        expect(h[c]).to be_nil
      end
    end

    specify "equality" do
      a = SerializedRecord.new(event_id: "a", data: "b", metadata: "c", event_type: "d", serialized_data: "e", serialized_metadata: "f")
      b = SerializedRecord.new(event_id: "a", data: "b", metadata: "c", event_type: "d", serialized_data: "e", serialized_metadata: "f")
      expect(a).to eq(b)
      expect(a).to eql(b)
      expect(a.hash).to eql(b.hash)
      h = {a => :val}
      expect(h[b]).to eq(:val)
    end

    specify "hash" do
      a = SerializedRecord.new(event_id: "a", data: "b", metadata: "c", event_type: "d", serialized_data: "e", serialized_metadata: "f")
      expect(a.hash).not_to eq([SerializedRecord, "a", "b", "c", "d", "e", "f"].hash)
    end

    specify "to_h" do
      a = SerializedRecord.new(event_id: "a", data: "b", metadata: "c", event_type: "d", serialized_data: "e", serialized_metadata: "f")
      expect(a.to_h).to eq({
        event_id: "a",
        data: "b",
        metadata: "c",
        event_type: "d",
        serialized_data: "e",
        serialized_metadata: "f"
      })
    end

    specify 'constructor raised when required args are missing' do
      expect do
        described_class.new
      end.to raise_error ArgumentError
    end

    specify 'default serialized_* values' do
      record = SerializedRecord.new(
        event_id:            event_id,
        data:                data,
        metadata:            metadata,
        event_type:          event_type,
        )

      expect(record.event_id).to            be(event_id)
      expect(record.metadata).to            be(metadata)
      expect(record.data).to                be(data)
      expect(record.event_type).to          be(event_type)
      expect(record.serialized_data).to     eq('')
      expect(record.serialized_metadata).to eq('')
      expect(record.frozen?).to             be(true)
    end
  end
end

