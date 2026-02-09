-- Migration: Add avatar_url column to users table
-- Date: 2026-02-02
-- Purpose: Match User entity with avatarUrl field

-- Add avatar_url column if not exists
-- Only works in SQLite 3.35.0+ (March 2021)
ALTER TABLE users ADD COLUMN avatar_url TEXT DEFAULT '';

-- Update existing records with empty avatar_url
UPDATE users SET avatar_url = '' WHERE avatar_url IS NULL;
