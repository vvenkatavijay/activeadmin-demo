# 🚀 Deploy ActiveAdmin to Render

This guide will help you deploy your ActiveAdmin application to Render using Docker.

## 📋 Prerequisites

1. **Render Account**: Sign up at [render.com](https://render.com)
2. **GitHub Repository**: Push your code to GitHub
3. **Docker Images**: Your local Docker images are ready

## 🐳 Method 1: Using Docker Images (Recommended)

### Step 1: Push Docker Image to Registry

First, tag and push your Docker image to a container registry:

```bash
# Tag your image for Docker Hub
docker tag activeadmin-app:latest yourusername/activeadmin-app:latest

# Login to Docker Hub
docker login

# Push to Docker Hub
docker push yourusername/activeadmin-app:latest
```

**Alternative: Use GitHub Container Registry**
```bash
# Tag for GitHub Container Registry
docker tag activeadmin-app:latest ghcr.io/yourusername/activeadmin-app:latest

# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u yourusername --password-stdin

# Push to GitHub Container Registry
docker push ghcr.io/yourusername/activeadmin-app:latest
```

### Step 2: Deploy on Render

1. **Go to Render Dashboard**: https://dashboard.render.com
2. **Click "New +"** → **"Web Service"**
3. **Connect your GitHub repository**
4. **Configure the service**:
   - **Name**: `activeadmin-app`
   - **Environment**: `Docker`
   - **Dockerfile Path**: `Dockerfile.render`
   - **Docker Context**: `tmp/development_apps/rails_80`
   - **Plan**: `Starter` (Free tier)

### Step 3: Set Environment Variables

In Render dashboard, go to **Environment** tab and add:

```bash
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
SECRET_KEY_BASE=your-secret-key-here
DATABASE_URL=postgresql://user:password@host:port/database
```

### Step 4: Add PostgreSQL Database

1. **Click "New +"** → **"PostgreSQL"**
2. **Configure**:
   - **Name**: `activeadmin-db`
   - **Plan**: `Starter` (Free tier)
   - **Database**: `activeadmin_production`
   - **User**: `activeadmin_user`
3. **Copy the DATABASE_URL** from the database service
4. **Paste it** into your web service environment variables

## 🔧 Method 2: Using render.yaml (Infrastructure as Code)

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

### Step 2: Deploy with render.yaml

1. **Go to Render Dashboard**
2. **Click "New +"** → **"Blueprint"**
3. **Connect your GitHub repository**
4. **Select the repository** with your `render.yaml`
5. **Click "Apply"**

## 🛠️ Method 3: Manual Docker Deployment

### Step 1: Create Web Service

1. **Go to Render Dashboard**
2. **Click "New +"** → **"Web Service"**
3. **Connect GitHub repository**
4. **Configure**:
   - **Build Command**: `docker build -f Dockerfile.render -t activeadmin-app .`
   - **Start Command**: `docker run -p $PORT:3000 activeadmin-app`
   - **Environment**: `Docker`

## 🔍 Troubleshooting

### Common Issues

1. **Build Fails**: Check Dockerfile path and context
2. **Database Connection**: Verify DATABASE_URL is correct
3. **Asset Precompilation**: Ensure RAILS_SERVE_STATIC_FILES=true
4. **Port Issues**: Make sure your app listens on $PORT

### Debug Commands

```bash
# Check logs in Render dashboard
# Or use Render CLI
render logs --service activeadmin-app

# Check service status
render services list
```

## 📊 Monitoring

- **Logs**: Available in Render dashboard
- **Metrics**: CPU, Memory, Response time
- **Health Checks**: Automatic health monitoring
- **Scaling**: Auto-scaling available on paid plans

## 💰 Pricing

- **Free Tier**: 750 hours/month, sleeps after 15 minutes of inactivity
- **Starter Plan**: $7/month, always-on, custom domains
- **Database**: Free tier includes 1GB PostgreSQL

## 🚀 Quick Deploy Commands

```bash
# 1. Build and test locally
./deploy.sh

# 2. Tag for registry
docker tag activeadmin-app:latest yourusername/activeadmin-app:latest

# 3. Push to registry
docker push yourusername/activeadmin-app:latest

# 4. Deploy on Render (via dashboard)
```

## 📝 Environment Variables Reference

| Variable | Value | Description |
|----------|-------|-------------|
| `RAILS_ENV` | `production` | Rails environment |
| `RAILS_SERVE_STATIC_FILES` | `true` | Serve static assets |
| `RAILS_LOG_TO_STDOUT` | `true` | Log to stdout |
| `SECRET_KEY_BASE` | `generated` | Rails secret key |
| `DATABASE_URL` | `postgresql://...` | Database connection string |

## 🎯 Next Steps

1. **Deploy**: Follow one of the methods above
2. **Test**: Verify your app works at the Render URL
3. **Custom Domain**: Add your own domain (paid plans)
4. **SSL**: Automatic HTTPS with Render
5. **Monitoring**: Set up alerts and monitoring

## 📞 Support

- **Render Docs**: https://render.com/docs
- **Community**: https://community.render.com
- **Status**: https://status.render.com
