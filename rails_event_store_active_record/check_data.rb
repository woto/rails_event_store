require 'rails_event_store'
require_relative '../support/helpers/schema_helper'

include SchemaHelper
establish_database_connection

event_names   = 200.times.map { |idx| "DummyEventKind%03d" % idx }
event_classes = event_names.map { |name| Object.const_set(name, Class.new(RailsEventStore::Event)) }
event_store   = RailsEventStore::Client.new

require 'irb'
binding.irb
