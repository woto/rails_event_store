# frozen_string_literal: true

require 'active_job'

module RailsEventStore
  class ActiveJobScheduler
    def call(klass, serialized_event)
      klass.perform_later(serialized_event.to_h)
    end

    def verify(subscriber)
      Class === subscriber && !!(subscriber < ActiveJob::Base)
    end

    def inspect
      "#<#{self.class}:0x#{__id__.to_s(16)}>"
    end
  end
end
