-- // add_proletarian_tables
-- Migration SQL that makes the change goes here.
CREATE SCHEMA IF NOT EXISTS proletarian;

CREATE TABLE IF NOT EXISTS proletarian.job(
    job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- job id, generated and returned by proletarian.job/enqueue!
    queue TEXT NOT NULL DEFAULT ':proletarian/default', -- queue name
    job_type TEXT NOT NULL, -- job type
    payload TEXT NOT NULL, -- Transit-encoded job data
    attempts INTEGER NOT NULL DEFAULT 0, -- Number of attempts. Starts at 0. Increments when the job is processed.
    enqueued_at TIMESTAMP NOT NULL DEFAULT now(), -- When the job was enqueued (never changes)
    process_at TIMESTAMP NOT NULL DEFAULT now() -- When the job should be run (updates every retry)
);

CREATE TABLE IF NOT EXISTS proletarian.archived_job(
    job_id UUID PRIMARY KEY, 
    queue TEXT NOT NULL, 
    job_type TEXT NOT NULL,
    payload TEXT NOT NULL,
    attempts INTEGER NOT NULL,
    enqueued_at TIMESTAMP NOT NULL,
    process_at TIMESTAMP NOT NULL,
    status TEXT NOT NULL,
    finished_at TIMESTAMP NOT NULL
);

CREATE INDEX job_queue_process_at ON proletarian.job(queue, process_at);


-- //@UNDO
-- SQL to undo the change goes here.
DROP TABLE proletarian.archived_job;
DROP TABLE proletarian.job;
DROP SCHEMA proletarian;
