-- LangConnect database initialization
-- This script runs when the LangConnect postgres container starts
-- Note: pgvector/pgvector:pg16 image includes vector and postgis extensions pre-installed

-- Enable required extensions (gracefully handle if already installed)
DO $$
BEGIN
    -- Enable pgvector extension for vector operations
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'vector') THEN
        CREATE EXTENSION vector;
        RAISE NOTICE 'pgvector extension created';
    ELSE
        RAISE NOTICE 'pgvector extension already exists';
    END IF;

    -- Enable PostGIS extension for geospatial data
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'postgis') THEN
        CREATE EXTENSION postgis;
        RAISE NOTICE 'PostGIS extension created';
    ELSE
        RAISE NOTICE 'PostGIS extension already exists';
    END IF;

    -- Enable pg_stat_statements for query monitoring
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements') THEN
        CREATE EXTENSION pg_stat_statements;
        RAISE NOTICE 'pg_stat_statements extension created';
    ELSE
        RAISE NOTICE 'pg_stat_statements extension already exists';
    END IF;
END
$$;

-- Create schemas for LangConnect operations
CREATE SCHEMA IF NOT EXISTS vector_store;
CREATE SCHEMA IF NOT EXISTS embeddings;

-- Grant permissions to the configured database user
DO $$
BEGIN
    -- Grant schema usage and creation permissions
    EXECUTE format('GRANT USAGE ON SCHEMA vector_store TO %I', current_user);
    EXECUTE format('GRANT USAGE ON SCHEMA embeddings TO %I', current_user);
    EXECUTE format('GRANT CREATE ON SCHEMA vector_store TO %I', current_user);
    EXECUTE format('GRANT CREATE ON SCHEMA embeddings TO %I', current_user);
    
    RAISE NOTICE 'Schema permissions granted to user: %', current_user;
END
$$;