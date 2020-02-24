require 'rails_event_store'
require 'ruby-progressbar'
require_relative '../support/helpers/schema_helper'

include SchemaHelper
establish_database_connection
drop_database
load_database_schema

progress      = ProgressBar.create(total: 1000)
event_store   = RailsEventStore::Client.new
event_names   = 200.times.map { |idx| "DummyEventKind%03d" % idx }
event_classes = event_names.map { |name| Object.const_set(name, Class.new(RailsEventStore::Event)) }


1000.times do |idx|
  stream_name = "DummyStream%04d" % idx
  events      = event_classes.map { |klass| klass.new }
  event_store.append(events, stream_name: stream_name)

  progress.increment
end
