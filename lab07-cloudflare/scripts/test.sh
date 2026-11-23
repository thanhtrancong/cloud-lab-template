#!/bin/bash
# Test script for Lab 07 - Cloudflare Worker

# Load environment variables
if [ -f ~/.lab07.env ]; then
    source ~/.lab07.env
else
    echo "⚠️  ~/.lab07.env not found, using defaults"
    FQDN="api.vlsc07-nguyenvana.site"
    ORIGIN_HOST="https://vlsc-cloud-app-2001100123.onrender.com"
fi

echo "🧪 Testing Cloudflare Worker"
echo "==============================="
echo ""

WORKER_URL="https://cloud-lab-worker.workers.dev"
DOMAIN_URL="https://$FQDN"

echo "Test 1: Check Worker Availability"
echo "URL: $WORKER_URL"
echo ""

if curl -s -o /dev/null -w "%{http_code}" "$WORKER_URL" > /dev/null 2>&1; then
    echo "✓ Worker responding"
    curl -i "$WORKER_URL" | head -20
else
    echo "⚠️  Worker not responding"
fi

echo ""
echo "Test 2: Check Domain URL"
echo "URL: $DOMAIN_URL"
echo ""

if curl -s -o /dev/null -w "%{http_code}" "$DOMAIN_URL" > /dev/null 2>&1; then
    echo "✓ Domain responding"
    curl -i "$DOMAIN_URL" | head -20
else
    echo "⚠️  Domain not responding yet (may need DNS propagation)"
fi

echo ""
echo "Test 3: Check Custom Headers"
curl -v "$WORKER_URL" 2>&1 | grep -E "X-Powered-By|X-Cache|Access-Control"

echo ""
echo "✅ Tests complete!"
