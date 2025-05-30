# n8n Docker Setup with Persistent Storage

This setup provides a complete n8n infrastructure with persistent storage that survives Docker Desktop and system reboots.

## Architecture

- **n8n Primary**: Main n8n instance with web UI
- **n8n Workers**: 2 worker instances for horizontal scaling
- **PostgreSQL**: Database with persistent storage
- **Redis**: Queue management and caching with persistent storage

## ✨ Features

- **🔄 Persistent Storage**: All data survives reboots and restarts
- **⚡ Horizontal Scaling**: Multiple workers for better performance
- **📦 External Packages**: Axios, lodash, moment, and other npm packages available
- **🔧 Built-in Modules**: All Node.js built-in modules (fs, crypto, https, etc.)
- **🚀 One-Click Startup**: Simple batch file to start everything

## 🚀 Quick Start (Recommended)

**Simply double-click `start-n8n.bat`** - that's it! 

The script will:
1. ✅ Check if Docker Desktop is running
2. ✅ Set up configuration (first time only)
3. ✅ Start all services with persistent storage
4. ✅ Open n8n in your browser

**To stop:** Double-click `stop-n8n.bat`

## First Time Setup

1. **Make sure Docker Desktop is installed and running**
2. **Double-click `start-n8n.bat`**
3. **On first run:** Edit the `.env` file when prompted:
   - Set a secure `PGPASSWORD` 
   - Set a long `ENCRYPTION_KEY` (at least 32 characters)
   - Save and close the file
4. **Access n8n at http://localhost:5678**
5. **Create your first user account**

## 📦 Using External Packages in Code Nodes

Your setup now supports external npm packages and all built-in Node.js modules! Here's how to use them:

### Example: Using Axios for HTTP Requests

```javascript
// In any Code node, you can now use:
const axios = require('axios');

// Make HTTP requests
const response = await axios.get('https://api.example.com/data');
return { data: response.data };
```

### Example: Using Built-in Node.js Modules

```javascript
// File system operations
const fs = require('fs');

// Crypto operations
const crypto = require('crypto');
const hash = crypto.createHash('sha256').update('hello').digest('hex');

// HTTPS requests
const https = require('https');

// Path manipulation
const path = require('path');

return { hash, timestamp: new Date().toISOString() };
```

### Available Packages

- **External NPM packages**: axios, lodash, moment, uuid, and thousands more
- **Built-in Node modules**: fs, crypto, https, path, url, querystring, etc.
- **Security**: Configured safely for self-hosted environments

## Persistent Storage

All your data is automatically saved and will persist across:
- Docker Desktop restarts
- System reboots
- Container updates

Stored data includes:
- `postgres_data`: Database with all workflows and executions
- `redis_data`: Queue and cache data
- `n8n_data`: User settings, credentials, and configuration
- `n8n_files`: File uploads and downloads

## Manual Management (Advanced)

If you prefer command line control:

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f n8n-primary
docker-compose logs -f n8n-worker-1

# Check service status
docker-compose ps

# Update to latest n8n version
docker-compose pull
docker-compose up -d
```

## Scaling Workers

To add more workers:
1. Edit `docker-compose.yml`
2. Copy the `n8n-worker-2` section
3. Rename to `n8n-worker-3`, etc.
4. Run `start-n8n.bat` or `docker-compose up -d`

## Backup Your Data

```bash
# Backup database
docker-compose exec postgres pg_dump -U n8n n8n > backup.sql

# Backup volumes (full backup)
docker run --rm -v railway-n8n_postgres_data:/data -v %cd%:/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
docker run --rm -v railway-n8n_n8n_data:/data -v %cd%:/backup alpine tar czf /backup/n8n_backup.tar.gz -C /data .
```

## Troubleshooting

- **"Docker Desktop is not running"**: Start Docker Desktop first
- **Services won't start**: Check `docker-compose logs` for errors
- **Can't access n8n**: Wait a few moments, services need time to start
- **Lost data**: Check that volumes are properly mounted with `docker volume ls`
- **Package not available**: Restart services after changing package settings

## Security Notes

⚠️ **External package access is enabled for flexibility**. This is safe for:
- Personal development environments
- Trusted team environments
- Self-hosted instances you control

For production environments, consider limiting packages by editing the environment variables:
```bash
# Limit to specific packages only
NODE_FUNCTION_ALLOW_EXTERNAL=axios,lodash,moment
NODE_FUNCTION_ALLOW_BUILTIN=crypto,https,path
```

## Files Overview

- `start-n8n.bat` - **Main startup script** (double-click to start)
- `stop-n8n.bat` - **Stop script** (double-click to stop cleanly)
- `docker-compose.yml` - Service orchestration
- `env.example` - Configuration template
- `.env` - Your actual configuration (created automatically)

**Your data is safe and persistent! 🔒**
