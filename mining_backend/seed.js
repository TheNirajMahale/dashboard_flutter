const mongoose = require('mongoose');
const fs = require('fs');
require('dotenv').config();

// --- 1. Database Connection ---
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("📡 Connected to MongoDB for seeding..."))
  .catch(err => {
    console.error("❌ Connection error:", err);
    process.exit(1);
  });

// --- 2. Schema Definition ---
// This acts as the blueprint for how data is stored in MongoDB
const MiningDataSchema = new mongoose.Schema({
    category: String, // 'monthly' or 'routes'
    data: Object      // Stores the entire JSON object
});

const MiningData = mongoose.model('MiningData', MiningDataSchema);

// --- 3. Upload Function ---
async function uploadData() {
    try {
        console.log("🧹 Clearing old database records...");
        await MiningData.deleteMany({}); // Prevents duplicate data

        console.log("📖 Reading local JSON files...");
        const monthly = JSON.parse(fs.readFileSync('./monthly.json', 'utf-8'));
        const routes = JSON.parse(fs.readFileSync('./Route_and_Fuel.json', 'utf-8'));

        console.log("☁️  Uploading to MongoDB Atlas...");
        await MiningData.create([
            { category: 'monthly', data: monthly },
            { category: 'routes', data: routes }
        ]);

        console.log("✅ SUCCESS: Data successfully pushed to MongoDB Cloud!");
        process.exit(0);
    } catch (err) {
        console.error("❌ ERROR during upload:", err);
        process.exit(1);
    }
}

// Run the script
uploadData();