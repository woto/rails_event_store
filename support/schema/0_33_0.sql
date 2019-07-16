PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "event_store_events_in_streams" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "stream" varchar NOT NULL, "position" integer, "event_id" varchar NOT NULL, "created_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "event_store_events" ("id" varchar(36) NOT NULL PRIMARY KEY, "event_type" varchar NOT NULL, "metadata" text, "data" text NOT NULL, "created_at" datetime NOT NULL);
CREATE INDEX "index_event_store_events_on_created_at" ON "event_store_events" ("created_at");
CREATE INDEX "index_event_store_events_in_streams_on_created_at" ON "event_store_events_in_streams" ("created_at");
CREATE UNIQUE INDEX "index_event_store_events_in_streams_on_stream_and_position" ON "event_store_events_in_streams" ("stream", "position");
CREATE UNIQUE INDEX "index_event_store_events_in_streams_on_stream_and_event_id" ON "event_store_events_in_streams" ("stream", "event_id");
COMMIT;
