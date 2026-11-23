# Cloud Lab Template

Repository này tổng hợp các bài thực hành Cloud Computing: kết nối DBaaS, đóng gói ứng dụng bằng Docker, xây dựng CI/CD lên PaaS và proxy qua Cloudflare Workers.

## Các bài thực hành

| Thư mục | Nội dung | Điểm bắt đầu |
| --- | --- | --- |
| `lab04-dbaas/` | Node.js HTTP service kết nối PostgreSQL/DBaaS; có endpoint kiểm tra database và liệt kê deployment | `server.js` |
| `lab05-docker/` | API viết bằng TypeScript, Docker multi-stage build và health check | `src/server.ts`, `Dockerfile` |
| `lab06-cicd/` | Express API, lint/test, build và scan container, push image lên GHCR, trigger deploy trên Render | `src/`, `.github/workflows/deploy.yml` |
| `lab07-cloudflare/` | Cloudflare Worker proxy request đến origin, kèm hướng dẫn và script triển khai/kiểm tra | `README.md`, `GUIDE.md`, `src/worker.js` |
| `paas-deployment/` | Express service mẫu cho triển khai PaaS; yêu cầu cấu hình `API_KEY` | `server.js` |

`index.html` là trang chào mừng GitHub Pages. Mỗi lab là một project riêng; hãy chạy lệnh trong đúng thư mục tương ứng.

## Yêu cầu chung

- Git
- Node.js và npm (chọn phiên bản phù hợp với từng lab; `lab06-cicd` yêu cầu Node.js >= 20)
- Docker cho `lab05-docker` và `lab06-cicd`
- Tài khoản/dịch vụ tương ứng nếu triển khai: PostgreSQL/DBaaS, GitHub Container Registry, Render hoặc Cloudflare

## Chạy từng project

### Lab 04 — DBaaS

Cần đặt `DATABASE_URL` thành connection string PostgreSQL có `sslmode=require`. Server mặc định chạy ở cổng `3000` (có thể đổi bằng `PORT`).

```bash
cd lab04-dbaas
npm ci
DATABASE_URL='postgresql://USER:PASSWORD@HOST:5432/DB?sslmode=require' node server.js
```

- `GET /healthz`: kiểm tra kết nối và trả về thông tin/độ trễ database.
- `GET /deployments`: đọc tối đa 20 bản ghi mới nhất từ bảng `cloud_deployments`.

### Lab 05 — Docker

```bash
cd lab05-docker
npm ci
npm run build
```

Build và chạy image multi-stage:

```bash
docker build -t cloud-lab-lab05 .
docker run --rm -p 3000:3000 -e STUDENT_ID=your-id cloud-lab-lab05
```

API có `GET /health` và `GET /info`. `Dockerfile.single` là ví dụ build một stage để đối chiếu với Dockerfile chính.

### Lab 06 — CI/CD

Chạy kiểm tra ở local:

```bash
cd lab06-cicd
npm ci
npm run lint
npm test
```

Workflow `.github/workflows/deploy.yml` chạy khi có thay đổi trong `lab06-cicd/` hoặc workflow trên nhánh `main` (cũng có thể chạy thủ công). Pipeline lint, test trên Node.js 20/22 và audit dependency trước khi build/scan image, push lên GHCR và trigger Render.

Để bật bước triển khai, cấu hình GitHub Actions secret `GHCR_PAT`, secret `RENDER_DEPLOY_HOOK_URL` và Actions variable `PUBLIC_APP_URL` trong repository. Ứng dụng cung cấp `GET /healthz` và `GET /api/status` để workflow kiểm tra trạng thái/commit đã triển khai.

### Lab 07 — Cloudflare Worker

Xem hướng dẫn chi tiết tại [`lab07-cloudflare/README.md`](lab07-cloudflare/README.md) và [`lab07-cloudflare/GUIDE.md`](lab07-cloudflare/GUIDE.md). Cấu hình route mẫu trong `wrangler.toml` cần được thay bằng domain/zone của bạn trước khi deploy.

### PaaS deployment

`paas-deployment/server.js` lắng nghe trên `PORT` do nền tảng cấp (mặc định `3000`) và yêu cầu biến môi trường `API_KEY`; ứng dụng sẽ dừng nếu biến này chưa được đặt.

## Cấu trúc repository

```text
.
├── .github/workflows/deploy.yml
├── index.html
├── lab04-dbaas/
├── lab05-docker/
├── lab06-cicd/
├── lab07-cloudflare/
└── paas-deployment/
```

## Ghi chú cấu hình

Không đưa thông tin xác thực, API key, connection string thật hoặc token vào Git. Dùng biến môi trường/Secrets của nền tảng khi chạy và triển khai. Thay các giá trị mẫu trong cấu hình từng lab bằng thông tin thuộc môi trường của bạn.
