require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Database Connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log("✅ SUCCESS: Connected to MongoDB Atlas Cloud"))
    .catch(err => {
        console.error("❌ CONNECTION ERROR:");
        console.error(err);
    });

// Schema & Model
const MiningData = mongoose.model('MiningData', new mongoose.Schema({
    category: String,
    data: Object
}));

// API Routes
app.get('/', (req, res) => res.send("Mining API is running..."));

app.get('/api/monthly', async (req, res) => {
    try {
        const record = await MiningData.findOne({ category: 'monthly' });
        record ? res.json(record.data) : res.status(404).send("Monthly data not found");
    } catch (err) { res.status(500).send(err); }
});

app.get('/api/routes', async (req, res) => {
    try {
        const record = await MiningData.findOne({ category: 'routes' });
        record ? res.json(record.data) : res.status(404).send("Route data not found");
    } catch (err) { res.status(500).send(err); }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server live on port ${PORT}`);
    console.log(`📡 Test locally: http://localhost:${PORT}/api/monthly`);
});
