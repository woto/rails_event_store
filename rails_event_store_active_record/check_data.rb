require 'rails_event_store'
require_relative '../support/helpers/schema_helper'

include SchemaHelper
establish_database_connection

event_names   = 20.times.map { |idx| "DummyEventKind%03d" % idx }
event_classes = event_names.map { |name| Object.const_set(name, Class.new(RailsEventStore::Event)) }
event_store   = RailsEventStore::Client.new

ActiveRecord::Base.logger = Logger.new(STDOUT)
puts "event_store.read.of_type([DummyEventKind000]).count"

require 'irb'
binding.irb

