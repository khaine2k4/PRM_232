# Start the mock REST API (JSON Server) on port 3001
# Run: powershell -ExecutionPolicy Bypass -File mock_api/start-api.ps1
npx json-server --watch db.json --port 3001 --host 0.0.0.0
