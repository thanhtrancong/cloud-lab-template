const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000; 
const ENV = process.env.NODE_ENV || 'development';

app.use(express.json());

app.get('/', (req, res) => {
    res.status(200).json({
        status: 'Success - Automated CI/CD Triggered',
        environment: ENV,
        timestamp: new Date().toISOString()
    });
});

// Strict Environment Validation
const SECURE_KEY = process.env.API_KEY;

if (!SECURE_KEY) {
    console.error('[FATAL ERROR] API_KEY environment variable is missing.');
    console.error('[SYSTEM] Halting initialization to prevent insecure execution.');
    process.exit(1); 
}


const server = app.listen(PORT, () => {
    console.log(`[SYSTEM] Server initializing on port ${PORT} in ${ENV} mode.`);
});

process.on('SIGTERM', () => {
    console.log('[KERNEL SIGNAL] SIGTERM received. Initiating graceful shutdown.');
    server.close(() => {
        process.exit(0);
    });
});