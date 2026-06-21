# Chạy bằng Docker

## Build image

```bash
docker build -t network-manager-web .
```

Dockerfile dùng Maven để tạo WAR trong build stage, sau đó triển khai WAR thành ứng dụng gốc trên Tomcat 9.

## Chạy container

SQL Server đang chạy trên máy Windows ở cổng `1433`:

```bash
docker run --rm -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=1433 \
  -e DB_NAME=network_simulation_db3 \
  -e DB_USER=sa \
  -e DB_PASSWORD=12345 \
  network-manager-web
```

Mở `http://localhost:8080/`.

Có thể truyền thêm `VNPAY_TMN_CODE`, `VNPAY_HASH_SECRET`, `VNPAY_RETURN_URL` và `VNPAY_PREMIUM_AMOUNT`. Trên Linux, thêm `--add-host=host.docker.internal:host-gateway` nếu SQL Server chạy trên máy host.
