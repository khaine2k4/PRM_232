# Mock REST API (JSON Server)

## Run
```
cd mock_api
npx json-server --watch db.json --port 3001 --host 0.0.0.0
```
Server runs at http://localhost:3001

## Endpoints
- `GET/POST/PUT/PATCH/DELETE /users`
- `GET/POST/PUT/PATCH/DELETE /products`
- `GET/POST /orders`

## Demo account
- Email: `admin@shop.com`
- Password: `123456`

## Base URL used by the app (lib/data/api_config.dart)
- Android emulator: `http://10.0.2.2:3001`
- Windows / iOS sim / web: `http://localhost:3001`

