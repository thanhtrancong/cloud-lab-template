#!/bin/bash
# Deploy script for Lab 07 - Cloudflare Worker

set -e

# Load environment variables
if [ -f ~/.lab07.env ]; then
    source ~/.lab07.env
else
    echo "⚠️  ~/.lab07.env not found, using defaults"
    DOMAIN="vlsc07-nguyenvana.site"
    FQDN="api.${DOMAIN}"
    STUDENT_ID="2021001"
    ORIGIN_HOST="https://vlsc-cloud-app-2001100123.onrender.com"
fi

echo "🚀 Deploying Cloudflare Worker"
echo "=================================="
echo "FQDN: $FQDN"
echo "Origin: $ORIGIN_HOST"
echo ""

# Check if already logged in
if ! wrangler whoami &> /dev/null; then
    echo "Please authenticate with Cloudflare:"
    wrangler login
fi

# Deploy
echo "Deploying worker..."
wrangler deploy

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your worker is live at:"
echo "→ https://cloud-lab-worker.workers.dev"
echo ""
echo "To access via your domain:"
echo "→ $FQDN"
echo ""
