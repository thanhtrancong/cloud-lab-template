# 🚀 Lab 07: Cloudflare Worker - Hướng Dẫn Chi Tiết

## 📋 Tổng Quan

Lab 07 yêu cầu bạn tạo một **Cloudflare Worker** để:
- Proxy requests từ domain của bạn đến origin host (Render)
- Thêm custom headers cho debugging
- Handle CORS requests
- Provide error handling

## 🎯 Mục Tiêu

Deploy một Cloudflare Worker tại: `https://cloud-lab-worker.workers.dev`

## 📁 Cấu Trúc Dự Án

```
lab07-cloudflare/
├── src/
│   └── worker.js              # Cloudflare Worker code
├── wrangler.toml              # Configuration file
├── package.json               # Dependencies
├── .lab07.env                 # Environment variables
├── README.md                  # Documentation
├── scripts/
│   ├── setup.sh              # Setup script
│   ├── deploy.sh             # Deploy script
│   └── test.sh               # Test script
└── evidence/
    ├── 00-env.txt            # Environment variables
    └── 01-setup.txt          # Setup evidence
```

## ✅ Setup Steps

### Step 1: Cập nhật Environment Variables

```bash
# Tạo hoặc sửa ~/.lab07.env
cat > ~/.lab07.env <<'EOF'
export DOMAIN="vlsc07-nguyenvana.site"
export FQDN="api.vlsc07-nguyenvana.site"
export STUDENT_ID="2021001"
export ORIGIN_HOST="https://vlsc-cloud-app-2001100123.onrender.com"
EOF

# Load variables
source ~/.lab07.env

# Verify
echo "FQDN=$FQDN ORIGIN_HOST=$ORIGIN_HOST"
```

### Step 2: Setup Project

```bash
cd /workspaces/cloud-lab-template/lab07-cloudflare

# Run setup script
bash scripts/setup.sh

# Or manually:
npm install
npm install -g wrangler
```

### Step 3: Authenticate with Cloudflare

```bash
wrangler login
# This will open browser for authentication
```

### Step 4: Deploy Worker

```bash
# Option A: Deploy with default settings
wrangler deploy

# Option B: Deploy to production
wrangler deploy --env production
```

### Step 5: Verify Deployment

```bash
# Option A: Test via script
bash scripts/test.sh

# Option B: Manual test
curl -i https://cloud-lab-worker.workers.dev/

# Check headers
curl -v https://cloud-lab-worker.workers.dev/ 2>&1 | grep "X-"
```

## 🔧 Configuration Files

### wrangler.toml
```toml
name = "cloud-lab-worker"
main = "src/worker.js"
compatibility_date = "2024-11-01"
```

**Cần sửa để connect domain thực tế:**
```toml
[[env.production.routes]]
pattern = "api.your-domain.com/*"
zone_name = "your-domain.com"
```

### src/worker.js
Worker này sẽ:
1. ✓ Proxy requests đến origin host
2. ✓ Add custom headers:
   - `X-Forwarded-For`: Client IP
   - `X-Forwarded-Proto`: https
   - `X-Forwarded-Host`: Original hostname
   - `X-Powered-By`: Cloudflare Workers
3. ✓ Set CORS headers
4. ✓ Handle errors (502 on failure)

## 🧪 Testing

### Test 1: Check Worker URL
```bash
curl -i https://cloud-lab-worker.workers.dev/
# Expected: 200 OK + custom headers
```

### Test 2: Check Domain
```bash
curl -i https://api.vlsc07-nguyenvana.site/
# Expected: 200 OK after DNS propagation
```

### Test 3: Check Headers
```bash
curl -v https://cloud-lab-worker.workers.dev/ 2>&1 | grep "X-"
# Expected: 
# X-Powered-By: Cloudflare Workers
# X-Cache: HIT
# Access-Control-Allow-Origin: *
```

### Test 4: Check Origin Proxy
```bash
curl https://cloud-lab-worker.workers.dev/api/health
# Should return response from your origin host
```

## 🐛 Troubleshooting

### Worker không respond

**Cách fix:**
1. Check deployment status:
   ```bash
   wrangler deployments list
   ```

2. Check logs:
   ```bash
   wrangler tail
   ```

3. Re-deploy:
   ```bash
   wrangler deploy
   ```

### 502 Bad Gateway

**Cách fix:**
1. Verify origin host URL:
   ```bash
   curl https://vlsc-cloud-app-2001100123.onrender.com/
   ```

2. Check ORIGIN_HOST value trong worker.js

3. Thêm debugging:
   ```javascript
   console.log('Origin URL:', originUrl);
   ```

### DNS không resolve domain

**Cách fix:**
1. Chờ DNS propagation (thường 15-30 phút)
2. Verify DNS settings tại Cloudflare dashboard
3. Test:
   ```bash
   nslookup api.vlsc07-nguyenvana.site
   ```

## 📊 Monitoring

### View Real-time Logs
```bash
wrangler tail
```

### Check Usage
```bash
wrangler analytics engine
```

## 🚀 Advanced Features

### Add Caching
```javascript
response.headers.set('Cache-Control', 'max-age=3600');
```

### Add Authentication
```javascript
const authHeader = request.headers.get('Authorization');
if (!authHeader) {
  return new Response('Unauthorized', { status: 401 });
}
```

### Add Rate Limiting
```javascript
const ip = request.headers.get('CF-Connecting-IP');
// Implement rate limiting logic
```

## 📚 Resources

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
- [Worker Examples](https://github.com/cloudflare/workers-sdk/tree/main/templates)

## ✨ Summary

**Completed:**
- ✅ Created Cloudflare Worker script
- ✅ Setup Wrangler configuration
- ✅ Created setup/deploy/test scripts
- ✅ Added documentation

**Next:**
- 1️⃣ Update ~/.lab07.env
- 2️⃣ Run setup.sh
- 3️⃣ Authenticate with Cloudflare
- 4️⃣ Deploy worker
- 5️⃣ Test deployment

---

**Lab Status:** Ready for deployment 🎉
