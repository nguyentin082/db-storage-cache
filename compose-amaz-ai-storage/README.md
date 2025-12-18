# Supabase Local Setup

Complete Supabase stack with PostgreSQL, Auth, Storage API, PostgREST, Kong, and Studio.

**Features:**
- ✅ All configs in `.env` file - no hard-coded values
- ✅ Easy port customization
- ✅ Auto JWT token generation
- ✅ S3-compatible storage with MinIO
- ✅ Production-ready

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Generate JWT tokens (requires PyJWT: pip install PyJWT)
./generate-jwt.sh
# Copy ANON_KEY and SERVICE_KEY output to .env

# 3. Start services
docker compose up -d

# 4. Access Studio at http://localhost:23000
```

## Configuration

All settings are in `.env` file organized by category:

**Ports** - Customize any service port
**Database** - PostgreSQL credentials and URLs
**JWT** - Secrets and tokens (most important!)
**Storage** - S3/MinIO backend (recommended) or file-based
**Auth/Storage/REST** - Service-specific configs

### Change Ports

Edit port numbers in `.env`, then restart:
```bash
docker compose down && docker compose up -d
```

### Change JWT Secret (Production)

```bash
# 1. Edit JWT_SECRET in .env
# 2. Regenerate tokens
./generate-jwt.sh
# 3. Copy new ANON_KEY and SERVICE_KEY to .env
# 4. Restart
docker compose down && docker compose up -d
```

## Commands

```bash
# Start
docker compose up -d

# Status
docker compose ps

# Logs (all services)
docker compose logs -f

# Logs (specific service)
docker compose logs -f storage

# Stop
docker compose down

# Stop + remove data
docker compose down -v

# Restart service
docker compose restart storage

# Force rebuild
docker compose up -d --build --force-recreate
```

## Service Access

| Service | URL |
|---------|-----|
| Studio | http://localhost:23000 |
| Kong API Gateway | http://localhost:28000 |
| PostgreSQL | localhost:25432 |
| Storage API | http://localhost:25000 |
| MinIO Console | http://localhost:29001 |

*Ports configurable via `.env`*

**Note:** MinIO provides S3-compatible object storage. Storage uses S3 backend by default (recommended due to known bugs in file backend delete operations).

## JWT Tokens

**ANON_KEY** - Frontend/public use, limited permissions via RLS
**SERVICE_KEY** - Backend only, full admin access, **NEVER expose to frontend**

## File Structure

```
.
├── docker-compose.yml    # Services config
├── .env                  # All configurations (git-ignored)
├── .env.example         # Template (version controlled)
├── generate-jwt.sh      # JWT generation script
├── kong.yml            # API gateway config
└── data/               # Persisted data (git-ignored)
```

## Troubleshooting

### "Invalid JWT" or "signature verification failed"
```bash
./generate-jwt.sh
# Update ANON_KEY and SERVICE_KEY in .env
docker compose up -d --force-recreate
```

### Storage API 500 Error
```bash
docker compose logs storage
# Usually JWT issue - regenerate and restart
```

### Services won't start
```bash
docker compose logs  # Check errors
# Port conflict? Change ports in .env
# Then: docker compose down && docker compose up -d
```

### Port conflict
```bash
# Check what's using the port
sudo lsof -i :25432

# Change port in .env
POSTGRES_PORT=25433
```

## Testing

```bash
# Test Storage (use your SERVICE_KEY from .env)
curl "http://localhost:28000/storage/v1/bucket" \
  -H "Authorization: Bearer YOUR_SERVICE_KEY"

# Test PostgREST (use your ANON_KEY)
curl "http://localhost:28000/rest/v1/" \
  -H "apikey: YOUR_ANON_KEY"

# Test Auth
curl "http://localhost:28000/auth/v1/health"
```

## Security Checklist

⚠️ **Before Production:**
- [ ] Change `JWT_SECRET` to secure random value (32+ chars)
- [ ] Regenerate JWT tokens
- [ ] Change all default passwords
- [ ] Restrict exposed ports
- [ ] Enable SSL/TLS on Kong
- [ ] Configure PostgreSQL RLS policies
- [ ] Set up automated backups
- [ ] Never commit `.env` file (already in `.gitignore`)
- [ ] **Never expose SERVICE_KEY** to frontend

## Key Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| JWT_SECRET | Token signing secret | `super-secret-jwt...` |
| ANON_KEY | Public access token | Generated |
| SERVICE_KEY | Admin access token | Generated |
| POSTGRES_PASSWORD | DB password | `postgres` |
| STORAGE_BACKEND | Storage type (`s3` or `file`) | `s3` |
| S3_BUCKET | S3/MinIO bucket name | `supabase-storage` |
| MINIO_ROOT_USER | MinIO admin username | `minioadmin` |
| MINIO_ROOT_PASSWORD | MinIO admin password | `minioadmin123` |
| *_PORT | Service ports | Various |

Full list in `.env.example`

## Resources

- [Supabase Docs](https://supabase.com/docs)
- [Docker Compose](https://docs.docker.com/compose/)
- [Kong Gateway](https://docs.konghq.com/)
