#!/bin/bash
# Quick Start Guide for Lab 07

echo "════════════════════════════════════════════════════════════════"
echo "  🚀 LAB 07: CLOUDFLARE WORKER - QUICK START"
echo "════════════════════════════════════════════════════════════════"
echo ""

cd /workspaces/cloud-lab-template/lab07-cloudflare

echo "📋 Current Structure:"
echo "───────────────────────────────────────────────────────────────"
tree -L 2 || find . -type f -not -path '*/.*' | head -20
echo ""

echo "⚡ Quick Commands:"
echo "───────────────────────────────────────────────────────────────"
echo "1. Setup environment:"
echo "   source ~/.lab07.env"
echo "   bash scripts/setup.sh"
echo ""

echo "2. Login to Cloudflare:"
echo "   wrangler login"
echo ""

echo "3. Deploy worker:"
echo "   wrangler deploy"
echo ""

echo "4. Test worker:"
echo "   bash scripts/test.sh"
echo ""

echo "5. View logs:"
echo "   wrangler tail"
echo ""

echo "📚 Documentation:"
echo "───────────────────────────────────────────────────────────────"
echo "• Full Guide: GUIDE.md"
echo "• README: README.md"
echo "• Environment: .lab07.env"
echo ""

echo "🔧 Key Files:"
echo "───────────────────────────────────────────────────────────────"
echo "• Worker Code: src/worker.js"
echo "• Configuration: wrangler.toml"
echo "• Dependencies: package.json"
echo ""

echo "✅ What's Included:"
echo "───────────────────────────────────────────────────────────────"
echo "✓ Cloudflare Worker proxy script"
echo "✓ Custom headers (X-Forwarded-*, X-Powered-By)"
echo "✓ CORS support"
echo "✓ Error handling (502 on origin failure)"
echo "✓ Setup/Deploy/Test scripts"
echo "✓ Comprehensive documentation"
echo ""

echo "🎯 Worker URL:"
echo "───────────────────────────────────────────────────────────────"
echo "https://cloud-lab-worker.workers.dev"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo "Ready to deploy! Start with: bash scripts/setup.sh"
echo "════════════════════════════════════════════════════════════════"
