require 'ruby_event_store/index_violation_detector'
require 'ruby_event_store/rom/unit_of_work'

module RubyEventStore
  module ROM
    class EventRepository
      SERIALIZED_GLOBAL_STREAM_NAME = 'all'.freeze

      def initialize(rom: ROM.env)
        @rom = rom
        @events = Repositories::Events.new(rom)
        @stream_entries = Repositories::StreamEntries.new(rom)
      end

      def append_to_stream(events, stream, expected_version)
        events = normalize_to_array(events)
        event_ids = events.map(&:event_id)

        UnitOfWork.perform(rom: @rom) do |session|
          session << @events.create_changeset(events)
          session << @stream_entries.create_changeset(event_ids, stream, expected_version, global_stream: true)
        end

        self
      rescue => ex
        handle_unique_violation_errors(ex)
      end

      def link_to_stream(event_ids, stream, expected_version)
        event_ids = normalize_to_array(event_ids)
        nonexistent_ids = @events.find_nonexistent_pks(event_ids)

        raise EventNotFound.new(nonexistent_ids.first) if nonexistent_ids.any?

        @stream_entries.create(event_ids, stream, expected_version)

        self
      rescue => ex
        handle_unique_violation_errors(ex)
      end

      def delete_stream(stream)
        @stream_entries.delete(stream)
      end

      def has_event?(event_id)
        @events.exist?(event_id)
      rescue => ex
        handle_not_found_errors(ex, event_id) rescue EventNotFound; false
      end

      def last_stream_event(stream)
        RubyEventStore::Specification.new(self)
          .stream(stream.name)
          .limit(1)
          .backward
          .each
          .to_a
          .first
      end

      def read_event(event_id)
        @events.by_id(event_id)
      rescue => ex
        handle_not_found_errors(ex, event_id)
      end

      def read(specification)
        raise RubyEventStore::ReservedInternalName if specification.stream_name.eql?(EventRepository::SERIALIZED_GLOBAL_STREAM_NAME)

        @events.read(
          specification.direction,
          specification.stream,
          from: specification.start,
          limit: (specification.count if specification.limit?)
        )
      rescue => ex
        handle_not_found_errors(ex, specification.start)
      end

      private

      def handle_unique_violation_errors(ex)
        case ex
        when ::ROM::SQL::UniqueConstraintError, Sequel::UniqueConstraintViolation
          raise EventDuplicatedInStream if IndexViolationDetector.new.detect(ex.message)
          raise WrongExpectedEventVersion
        else
          raise ex
        end
      end

      def handle_not_found_errors(ex, event_id)
        case ex
        when ::ROM::TupleCountMismatchError
          raise EventNotFound.new(event_id)
        when Sequel::DatabaseError
          raise ex unless ex.message =~ /PG::InvalidTextRepresentation.*uuid/
          raise EventNotFound.new(event_id)
        else
          raise ex
        end
      end

      def normalize_to_array(events)
        return events if events.is_a?(Enumerable)
        [events]
      end
    end
  end
end
