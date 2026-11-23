# Lab 07: Cloudflare Worker Setup

Hướng dẫn setup Cloudflare Worker để proxy requests đến origin host.

## Yêu cầu

- Cloudflare account
- Wrangler CLI (`npm install -g wrangler`)
- Node.js >= 16

## Cấu hình

### 1. Cập nhật biến môi trường

Sửa file `.lab07.env` với thông tin của bạn:

```bash
export DOMAIN="your-domain.com"
export FQDN="api.${DOMAIN}"
export STUDENT_ID="your-student-id"
export ORIGIN_HOST="https://your-api.onrender.com"
```

### 2. Cập nhật wrangler.toml

Thay thế `example.com` bằng domain thực tế của bạn:

```toml
[[env.production.routes]]
pattern = "api.your-domain.com/*"
zone_name = "your-domain.com"
```

### 3. Deploy Worker

```bash
# Login to Cloudflare
wrangler login

# Deploy the worker
wrangler deploy --env production
```

## Cấu trúc Project

```
lab07-cloudflare/
├── src/
│   └── worker.js          # Main Cloudflare Worker script
├── wrangler.toml          # Wrangler configuration
├── package.json           # Node.js dependencies
├── .lab07.env             # Environment variables template
├── scripts/               # Helper scripts
├── assets/                # Static assets
└── evidence/              # Lab evidence/proof files
```

## Worker Functionality

Worker này sẽ:

1. **Proxy requests** từ Cloudflare đến origin host
2. **Add headers** cho debugging:
   - `X-Forwarded-For`: IP của client
   - `X-Forwarded-Proto`: Protocol (https)
   - `X-Forwarded-Host`: Original hostname
   - `X-Powered-By`: Cloudflare Workers

3. **Handle CORS**: Thêm CORS headers cho cross-origin requests
4. **Error handling**: Return JSON error nếu origin không available

## Testing

```bash
# Test local development
wrangler dev

# Test production
curl https://api.your-domain.com/

# Check headers
curl -i https://api.your-domain.com/
```

## Troubleshooting

### Worker không forward requests
- Kiểm tra `ORIGIN_HOST` environment variable
- Verify origin server đang chạy
- Kiểm tra Cloudflare DNS settings

### CORS errors
- Worker đã add `Access-Control-Allow-Origin: *`
- Nếu cần specific origins, modify `worker.js`

### 502 Bad Gateway
- Verify origin host URL
- Check network connectivity
- Review Cloudflare logs

## Documentation

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
