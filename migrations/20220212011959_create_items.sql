-- Add migration script here
CREATE TABLE item (
	id TEXT PRIMARY KEY NOT NULL,
	title TEXT NOT NULL,
    complete BOOLEAN NOT NULL DEFAULT FALSE
);
