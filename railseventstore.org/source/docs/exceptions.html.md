## Client Errors

When using Rails Event Store you have to be prepared for following errors:

### RubyEventStore::WrongExpectedEventVersion

Occurs when other writer has written to the same stream as we intended to and last stream version has changed:

```ruby
client.publish_event(OrderPlaced.new, stream_name: 'Order$1', expected_version: 0)

expect do
  client.publish_event(OrderCompleted.new, stream_name: 'Order$1', expected_version: 0)
end.to raise_error(WrongExpectedEventVersion)
```

Second write to the stream should have happened with `expected_version: 1` above.

### RubyEventStore::EventDuplicatedInStream   

Occurs when you're writing same event more than once.

```ruby
order_placed = OrderPlaced.new
client.publish_event(order_placed, stream_name: 'Order$1', expected_version: 0)

expect do
  client.publish_event(order_placed, stream_name: 'Order$1', expected_version: 1)
end.to raise_error(WrongExpectedEventVersion)
```

If you want to have an event present in multiple streams, you have to link it with `link_to_stream`.


### RubyEventStore::InvalidExpectedVersion    

Occurs when invalid `exception_version` is passed in `append_to_stream`, `link_to_stream`, `publish_event` or `publish_events`.
Valid values are `Integer` or one of `:any`, `:none`, `:auto`.


```ruby
expect do
  client.append_to_stream(OrderPlaced.new, stream_name: 'Order$1', expected_version: nil)
end.to raise_error(InvalidExpectedVersion)
```


### RubyEventStore::IncorrectStreamData     

Occurs when invalid `stream_name` is passed in any client method expecting it. Name must not be `nil` or empty string.

```ruby
expect do
  client.append_to_stream(OrderPlaced.new, stream_name: nil)
end.to raise_error(IncorrectStreamData)
```

### RubyEventStore::EventNotFound

Occurs when event of given id cannot be found. This can happen either when looking for particular event details via `read_event` or when reading stream, starting from given event.

```ruby
none_such_id = SecureRandom.uuid
expect do
  client.read_events_forward('Order$1', start: none_such_id) }
end.to raise_error(EventNotFound)
```

### RubyEventStore::InvalidPageStart

Occurs when reading a stream with invalid `start` parameter passed. Must not be `nil` or empty string. Special case of `:head` is accepted as a beginning of a stream in given direction.

```ruby
expect do
  client.read_events_forward('Order$1', start: nil)
end.to raise_error(InvalidPageStart)
```

### RubyEventStore::InvalidPageSize

Occurs when expecting to read less than one event from a stream:

```ruby
expect do
  client.read_events_forward('Order$1', count: -1)
end.to raise_error(InvalidPageSize)
```

### RubyEventStore::SubscriberNotExist

Occurs when given subscriber is `nil`.

```ruby
expect do
  client.subscribe(nil, to: [OrderPlaced])
end.to raise_error(SubscriberNotExist)
```

### RubyEventStore::InvalidHandler

Occurs when given subscriber does not respond to `call` method.

```ruby
subscriber = Object.new
expect do
  client.subscribe(subscriber, to: [OrderPlaced])
end.to raise_error(InvalidHandler)
```

### RubyEventStore::NotSupported

Raised when using `RailsEventStoreActiveRecord::Legacy` repository on unsupported `link_to_stream` operation.


### RubyEventStore::ReservedInternalName

Occurs when passing stream name of `all` when using `RailsEventStoreActiveRecord` of `RubyEventStore::ROM` repository. This stream name is used internally to implement global stream. Use dedicated global stream readers in order to read events from it.