# ActiveAdmin Docker Deployment Guide

This guide will help you deploy your ActiveAdmin application using Docker.

## 🐳 Quick Start

### Option 1: Using the deployment script (Recommended)
```bash
./deploy.sh
```

### Option 2: Manual deployment
```bash
# Build the image
docker build -t activeadmin-app .

# Start the application
docker-compose up -d

# Check logs
docker-compose logs -f
```

## 📁 Files Created

- `Dockerfile` - Main Docker configuration
- `Dockerfile.production` - Production-optimized multi-stage build
- `docker-compose.yml` - Docker Compose configuration
- `.dockerignore` - Files to exclude from Docker build
- `deploy.sh` - Automated deployment script

## 🔧 Configuration

### Environment Variables

You can customize the deployment by setting these environment variables:

```bash
# Database
DATABASE_URL=postgresql://user:password@db:5432/activeadmin_production

# Rails
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

# Security (for production)
SECRET_KEY_BASE=your_secret_key_here
```

### Database Configuration

The default setup uses PostgreSQL. To use SQLite (for development/testing):

1. Modify `docker-compose.yml` to remove the `db` service
2. Update the `DATABASE_URL` to use SQLite
3. Ensure SQLite is installed in the container

## 🚀 Deployment Options

### 1. Local Development
```bash
docker-compose up
```

### 2. Production with PostgreSQL
```bash
docker-compose -f docker-compose.yml up -d
```

### 3. Cloud Deployment

#### Heroku
```bash
# Install Heroku CLI
heroku create your-app-name
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
```

#### DigitalOcean App Platform
1. Connect your GitHub repository
2. Use the provided `Dockerfile`
3. Set environment variables in the dashboard

#### AWS ECS/Fargate
1. Push image to ECR
2. Create ECS task definition
3. Deploy using ECS service

#### Google Cloud Run
```bash
# Build and push to Google Container Registry
gcloud builds submit --tag gcr.io/PROJECT-ID/activeadmin-app
gcloud run deploy --image gcr.io/PROJECT-ID/activeadmin-app --platform managed
```

## 🔐 Security Considerations

### Production Checklist
- [ ] Change default admin credentials
- [ ] Set strong `SECRET_KEY_BASE`
- [ ] Use HTTPS in production
- [ ] Configure proper database credentials
- [ ] Set up proper logging and monitoring
- [ ] Configure backup strategy
- [ ] Use environment-specific configurations

### Updating Admin Credentials
```bash
# Access the container
docker-compose exec web bash

# Open Rails console
bundle exec rails console

# Update admin user
admin = AdminUser.first
admin.update!(email: 'your-email@example.com', password: 'new-password')
```

## 📊 Monitoring and Logs

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f web

# Last 100 lines
docker-compose logs --tail=100 web
```

### Health Checks
The container includes health checks that verify the application is responding:
```bash
# Check container health
docker ps
```

## 🔄 Updates and Maintenance

### Updating the Application
```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Database Migrations
```bash
# Run migrations
docker-compose exec web bundle exec rails db:migrate

# Seed database
docker-compose exec web bundle exec rails db:seed
```

### Backup Database
```bash
# PostgreSQL backup
docker-compose exec db pg_dump -U postgres activeadmin_production > backup.sql

# Restore from backup
docker-compose exec -T db psql -U postgres activeadmin_production < backup.sql
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using port 3000
   lsof -i :3000
   
   # Use different port
   docker-compose up -p 3001:3000
   ```

2. **Database connection issues**
   ```bash
   # Check database logs
   docker-compose logs db
   
   # Restart database
   docker-compose restart db
   ```

3. **Asset compilation errors**
   ```bash
   # Rebuild without cache
   docker-compose build --no-cache web
   ```

4. **Permission issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

### Getting Help
- Check container logs: `docker-compose logs`
- Access container shell: `docker-compose exec web bash`
- View container status: `docker-compose ps`

## 📈 Performance Optimization

### Production Optimizations
- Use `Dockerfile.production` for smaller image size
- Configure proper resource limits in `docker-compose.yml`
- Use a reverse proxy (nginx) for static file serving
- Enable Redis for caching
- Use CDN for asset delivery

### Resource Limits
Add to `docker-compose.yml`:
```yaml
services:
  web:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
```

## 🎯 Next Steps

1. **Customize the application** - Modify the admin resources and pages
2. **Set up CI/CD** - Automate deployments with GitHub Actions
3. **Add monitoring** - Set up application performance monitoring
4. **Configure backups** - Implement automated database backups
5. **Scale horizontally** - Use load balancers for multiple instances

---

For more information, visit the [ActiveAdmin documentation](https://activeadmin.info/).
