-- Run this in: Supabase Dashboard → SQL Editor → New Query

-- Platform OAuth tokens (one row per platform)
CREATE TABLE IF NOT EXISTS tokens (
  platform       TEXT PRIMARY KEY,
  access_token   TEXT NOT NULL,
  refresh_token  TEXT,
  scope          TEXT,
  expires_at     BIGINT,
  extra          JSONB DEFAULT '{}',
  updated_at     BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT * 1000
);

-- Published posts
CREATE TABLE IF NOT EXISTS posts (
  id           BIGSERIAL PRIMARY KEY,
  title        TEXT NOT NULL,
  description  TEXT DEFAULT '',
  hashtags     TEXT DEFAULT '',
  file_name    TEXT NOT NULL,
  file_key     TEXT NOT NULL,       -- Cloudflare R2 object key
  file_size    BIGINT DEFAULT 0,
  platforms    TEXT NOT NULL,       -- JSON array string e.g. '["youtube","twitter"]'
  status       TEXT NOT NULL DEFAULT 'pending',
  created_at   BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT * 1000
);

-- Per-platform publish results
CREATE TABLE IF NOT EXISTS post_results (
  id                BIGSERIAL PRIMARY KEY,
  post_id           BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  platform          TEXT NOT NULL,
  status            TEXT NOT NULL DEFAULT 'pending',
  platform_post_id  TEXT,
  platform_url      TEXT,
  error_message     TEXT,
  progress          INTEGER DEFAULT 0,
  created_at        BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT * 1000
);

CREATE INDEX IF NOT EXISTS idx_post_results_post_id ON post_results(post_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);

-- Row Level Security: disable public access (server uses service role key which bypasses RLS)
ALTER TABLE tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_results ENABLE ROW LEVEL SECURITY;
