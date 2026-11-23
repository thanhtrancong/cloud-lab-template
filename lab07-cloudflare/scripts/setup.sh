#!/bin/bash
# Setup script for Lab 07 - Cloudflare Worker

set -e

echo "🚀 Lab 07: Cloudflare Worker Setup"
echo "=================================="

# Load environment variables
if [ -f ~/.lab07.env ]; then
    source ~/.lab07.env
    echo "✓ Loaded environment variables from ~/.lab07.env"
else
    echo "⚠️  ~/.lab07.env not found, using defaults"
    DOMAIN="vlsc07-nguyenvana.site"
    FQDN="api.${DOMAIN}"
    STUDENT_ID="2021001"
    ORIGIN_HOST="https://vlsc-cloud-app-2001100123.onrender.com"
fi

echo ""
echo "Current Configuration:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Domain: $DOMAIN"
echo "FQDN: $FQDN"
echo "Student ID: $STUDENT_ID"
echo "Origin Host: $ORIGIN_HOST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js >= 16"
    exit 1
fi

echo "✓ Node.js $(node --version) found"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm"
    exit 1
fi

echo "✓ npm $(npm --version) found"

# Install dependencies
echo ""
echo "Installing dependencies..."
npm install

# Check if Wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "Installing Wrangler CLI..."
    npm install -g wrangler
fi

echo "✓ Wrangler $(wrangler --version) found"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update wrangler.toml with your domain"
echo "2. Run 'wrangler login' to authenticate with Cloudflare"
echo "3. Run 'wrangler deploy' to deploy the worker"
echo ""
