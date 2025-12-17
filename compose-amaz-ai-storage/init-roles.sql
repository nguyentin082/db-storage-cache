-- Set passwords for Supabase users
-- This script is needed because supabase/postgres image creates users without passwords by default

-- Set password for supabase_auth_admin (used by auth service)
ALTER USER supabase_auth_admin WITH PASSWORD 'postgres';

-- Set password for authenticator (used by PostgREST)
ALTER USER authenticator WITH PASSWORD 'postgres';

-- Set password for supabase_storage_admin (used by storage service)
ALTER USER supabase_storage_admin WITH PASSWORD 'postgres';

-- Set password for supabase_admin (used by meta service)
ALTER USER supabase_admin WITH PASSWORD 'postgres';
