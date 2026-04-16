# Mining Analytics Dashboard 🚜💎

A full-stack monitoring solution for mining operations. This project features a **Node.js/Express** backend connected to **MongoDB Atlas** and a **Flutter** mobile application for real-time data visualization.

### 📱 Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/952f2be3-0024-4e22-a45c-b8c4d1ddeefb" width="22%" />
  <img src="https://github.com/user-attachments/assets/bc71a466-f266-4577-a6d0-7abe60f06c4c" width="22%" />
  <img src="https://github.com/user-attachments/assets/abeb3a3c-a0a5-4246-95c4-fb5aa25ee562" width="22%" />
  <img src="https://github.com/user-attachments/assets/321a9e82-3af1-40a0-9f17-01d62e4cc900" width="22%" />
</p>

## 📂 Project Structure
```text
Mining Project/
├── dashboard_app/      # Flutter Frontend (Charts & UI)
└── mining_backend/     # Node.js Backend (REST API & Seeding)
```

---

## 🚀 Getting Started

### 1. Prerequisites
* Flutter SDK installed.
* Node.js and npm installed.
* A MongoDB Atlas Cluster (Cloud Database).

### 2. Backend Setup (Node.js)
1. Navigate to the backend directory:
   ```bash
   cd mining_backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure your environment:
   Create a `.env` file in the `mining_backend` folder and add your connection string:
   ```env
   MONGO_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/mining_db
   PORT=5000
   ```
4. Seed the database (Upload JSON data to Cloud):
   ```bash
   node seed.js
   ```
5. Start the server:
   ```bash
   node server.js
   ```

### 3. Frontend Setup (Flutter)
1. Navigate to the frontend directory:
   ```bash
   cd dashboard_app
   ```
2. Get packages:
   ```bash
   flutter pub get
   ```
3. **Connectivity Setup (Crucial for Real Devices):**
   * Connect your phone via USB.
   * Run the ADB tunnel to allow the phone to see your local PC server:
       ```bash
       adb reverse tcp:5000 tcp:5000
       ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🛠️ Features
- **Cloud Integration:** Uses MongoDB Atlas for persistent storage of mining logs.
- **RESTful API:** Node.js endpoints for fetching monthly stats and route-specific data.
- **Dynamic Charts:** Flutter `fl_chart` implementation for Fuel consumption and Production metrics.
- **Clean Architecture:** Separated services and providers for scalable state management.

## 🔒 Security & Best Practices
- **Environment Variables:** Sensitive DB credentials are kept out of source control via `.gitignore`.
- **Cleartext Traffic:** Configured `network_security_config.xml` to allow secure local development testing.
- **Monorepo Design:** Unified version control for the entire stack.

## 👨‍💻 Developer
**Niraj Mahale**
