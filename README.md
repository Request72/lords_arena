# 🏰 Lords Arena - Multiplayer Combat Game

A real-time multiplayer 2D combat game built with Flutter and Node.js, featuring character selection, weapon systems, and competitive gameplay.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Setup Instructions](#setup-instructions)
- [API Documentation](#api-documentation)
- [Game Flow](#game-flow)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🎮 Overview

Lords Arena is a multiplayer combat game where players select characters, choose weapons, and engage in real-time battles. The game features a complete authentication system, character progression, and competitive leaderboards.

### Tech Stack

**Frontend (Android App):**
- **Framework**: Flutter 3.7.2
- **Game Engine**: Flame 1.30.1
- **State Management**: Flutter BLoC + Cubit
- **Dependency Injection**: GetIt
- **Local Storage**: Hive
- **HTTP Client**: http package
- **Audio**: flame_audio

**Backend (Server):**
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Real-time**: Socket.IO
- **Authentication**: JWT + bcryptjs
- **CORS**: Enabled for cross-origin requests

## ⚡ Features

### 🔐 Authentication System
- **User Registration**: Username, email, password
- **User Login**: Email/password authentication
- **JWT Tokens**: Secure session management
- **Local Storage**: Offline user data persistence
- **Auto-login**: Remember user sessions

### 🎯 Game Features
- **Character Selection**: 3 unique characters (KP, Sher, Prachanda)
- **Weapon System**: Multiple weapon types (Fire, Poison, Regular bullets)
- **Multiplayer Combat**: Real-time 2-player battles
- **Power-ups**: Health packs and armor
- **Scoring System**: Kill tracking and leaderboards
- **Audio**: Background music and sound effects

### 📊 Dashboard & Stats
- **User Dashboard**: Game menu and navigation
- **Player Statistics**: XP, level, coins tracking
- **Leaderboard**: Global player rankings
- **Settings**: Game configuration options

### 🌐 Real-time Features
- **Socket.IO**: Real-time multiplayer synchronization
- **Player Movement**: Live position updates
- **Matchmaking**: Quick play system
- **Game Sessions**: Persistent game state

## 🏗️ Architecture

### Frontend Architecture (Clean Architecture)

```
lib/
├── app/                    # App configuration
│   ├── app.dart           # Main app widget
│   └── app_router.dart    # Route definitions
├── core/                   # Core utilities
│   ├── service_locator/   # Dependency injection
│   ├── storage/           # Local storage
│   ├── theme/             # App theming
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── auth/             # Authentication
│   │   ├── data/         # Data layer
│   │   ├── domain/       # Business logic
│   │   └── presentation/ # UI layer
│   ├── dashboard/        # Dashboard feature
│   ├── ingame/          # Game logic
│   └── user/            # User management
└── main.dart             # App entry point
```

### Backend Architecture

```
lords_arena_backend/
├── config/               # Configuration files
├── controllers/          # Request handlers
├── middleware/           # Custom middleware
├── models/              # Database schemas
├── routes/              # API route definitions
├── server.js            # Main server file
└── package.json         # Dependencies
```

## 🚀 Setup Instructions

### Prerequisites

- **Flutter SDK**: 3.7.2 or higher
- **Node.js**: 16.x or higher
- **MongoDB**: 5.0 or higher
- **Android Studio**: For Android development
- **Git**: Version control

### 1. Clone the Repository

```bash
git clone <repository-url>
cd IdeaProjects
```

### 2. Backend Setup

```bash
# Navigate to backend directory
cd lords_arena_backend

# Install dependencies
npm install

# Create environment file
echo "JWT_SECRET=your_jwt_secret_key_here" > .env
echo "MONGO_URI=mongodb://localhost:27017/lords_arena" >> .env
echo "PORT=5000" >> .env

# Start MongoDB (Windows)
# Option 1: Using MongoDB installer
# Option 2: Using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest

# Start the server
npm start
```

### 3. Android App Setup

```bash
# Navigate to Android app directory
cd lords_arena_android

# Install Flutter dependencies
flutter pub get

# Generate Hive adapters
flutter packages pub run build_runner build

# Run the app
flutter run
```

### 4. Network Configuration

Update the IP address in the following files to match your local network:

**Android App:**
- `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- `lib/features/ingame/data/game_api_service.dart`
- `lib/features/ingame/data/player_api_service.dart`

**Backend:**
- `server.js` (update console log IP)

## 📚 API Documentation

### Authentication Endpoints

#### POST `/api/auth/signup`
Register a new user.

**Request Body:**
```json
{
  "username": "gamer123",
  "email": "gamer123@gmail.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "userId": "user_id",
  "username": "gamer123",
  "email": "gamer123@gmail.com"
}
```

#### POST `/api/auth/login`
Authenticate existing user.

**Request Body:**
```json
{
  "email": "gamer123@gmail.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "userId": "user_id",
  "username": "gamer123",
  "email": "gamer123@gmail.com"
}
```

### Game Endpoints

#### POST `/api/game/session/create`
Create a new game session.

#### GET `/api/game/leaderboard`
Get global leaderboard.

#### POST `/api/game/results`
Save game results.

### Socket.IO Events

#### Client to Server
- `init-character`: Initialize player character
- `quick-play`: Join matchmaking
- `move-player`: Update player position
- `game-over`: End game session

#### Server to Client
- `joined-room`: Room assignment
- `init-player`: Player initialization
- `player-moved`: Position updates
- `player-disconnected`: Player left

## 🎮 Game Flow

### 1. Authentication Flow
```
Splash Screen → Login → Dashboard
```

### 2. Game Session Flow
```
Dashboard → Character Selection → Weapon Selection → Multiplayer Combat
```

### 3. Multiplayer Flow
```
Quick Play → Matchmaking → Room Assignment → Combat → Results
```

## 🧪 Testing

### Test Credentials

**Default Test User:**
- **Username**: `gamer123`
- **Email**: `gamer123@gmail.com`
- **Password**: `password123`

### Manual Testing Checklist

#### Authentication
- [ ] User registration with valid data
- [ ] User login with correct credentials
- [ ] Error handling for invalid credentials
- [ ] Token persistence across app restarts

#### Game Features
- [ ] Character selection (KP, Sher, Prachanda)
- [ ] Weapon selection (Fire, Poison, Regular bullets)
- [ ] Multiplayer connection
- [ ] Real-time player movement
- [ ] Score tracking and leaderboards

#### UI/UX
- [ ] Responsive design on different screen sizes
- [ ] Smooth navigation between screens
- [ ] Loading states and error messages
- [ ] Audio playback (background music, sound effects)

## 🔧 Troubleshooting

### Common Issues

#### 1. Backend Connection Issues
**Problem**: App can't connect to backend
**Solution**: 
- Verify backend is running on port 5000
- Check IP address in API service files
- Ensure firewall allows connections

#### 2. MongoDB Connection Issues
**Problem**: Database connection errors
**Solution**:
- Verify MongoDB is running
- Check connection string in `.env`
- Restart backend server

#### 3. Flutter Build Issues
**Problem**: App won't build or run
**Solution**:
- Run `flutter clean`
- Run `flutter pub get`
- Check Flutter version compatibility

#### 4. Device Connection Issues
**Problem**: App won't install on device
**Solution**:
- Enable USB debugging on device
- Check device is authorized
- Try `flutter devices` to verify connection

### Debug Commands

```bash
# Check Flutter installation
flutter doctor

# List connected devices
flutter devices

# Clean and rebuild
flutter clean && flutter pub get

# Check backend status
curl http://192.168.0.125:5000/api/auth

# Check MongoDB connection
mongo --eval "db.runCommand('ping')"
```

## 📱 Device Requirements

### Android
- **Minimum SDK**: API 21 (Android 5.0)
- **Target SDK**: API 33 (Android 13)
- **Architecture**: arm64
- **RAM**: 2GB minimum
- **Storage**: 100MB free space

### Network
- **Connection**: WiFi or mobile data
- **Latency**: <100ms for optimal multiplayer
- **Bandwidth**: 1Mbps minimum

## 🎯 Game Controls

### Touch Controls
- **Joystick**: Player movement
- **Fire Button**: Shoot weapon
- **Weapon Switch**: Change weapons
- **Jump**: Platform navigation

### Multiplayer Controls
- **Quick Play**: Join matchmaking
- **Character Select**: Choose fighter
- **Weapon Select**: Choose weapon type
- **Ready**: Start combat

## 📊 Performance Metrics

### Target Performance
- **Frame Rate**: 60 FPS
- **Loading Time**: <3 seconds
- **Network Latency**: <100ms
- **Memory Usage**: <200MB

### Optimization Features
- **Asset Compression**: Optimized images and audio
- **Lazy Loading**: Load resources on demand
- **Connection Pooling**: Efficient database connections
- **Caching**: Local data storage

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

### Code Standards
- **Flutter**: Follow official style guide
- **JavaScript**: Use ESLint configuration
- **Documentation**: Update README for new features
- **Testing**: Add unit and integration tests

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Flame Engine**: For 2D game development
- **Socket.IO**: For real-time communication
- **MongoDB**: For database management

## 📞 Support

For support and questions:
- **Issues**: Create GitHub issue
- **Documentation**: Check this README
- **Community**: Join our Discord server

---

**Lords Arena** - Where legends battle for glory! ⚔️🏆
