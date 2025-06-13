# 🌦️📰 Weather & News Dashboard App

A beautifully designed, feature-rich Flutter mobile application combining real-time **weather updates** and **latest news** in a single dashboard. Built with modern Flutter practices, clean architecture, and optimized for performance and offline usage.

---

## 📱 Features

### ☁️ Weather Section
- 🌍 **Current Weather with Location Detection**
- 📅 **5-Day Forecast** with Hourly Breakdown
- 🌐 **Multiple City Comparison**
- 🚨 **Weather Alerts & Notifications**

### 📰 News Section
- 🗞️ **Top Headlines** with Category Filters (Business, Tech, Sports)
- 🔍 **Article Search** with Debounced Input
- 📌 **Bookmark Articles** for Offline Reading
- 📤 **Share Articles** via Installed Apps

### 🌈 User Experience
- 🔄 **Pull-to-Refresh** Support
- 📶 **Offline Mode** with Smart Caching
- 🌙 **Dark/Light Theme** (Auto-detect System Preference)
- 🎞️ **Smooth Animations** & Micro-interactions

---

## 🛠️ Technical Stack

| Component         | Technology          |
|------------------|---------------------|
| Framework        | Flutter (Latest)    |
| State Management | Riverpod or Provider|
| Weather API      | OpenWeatherMap      |
| News API         | NewsAPI             |
| Local Storage    | Hive / SQLite       |
| Architecture     | Clean Architecture  |
| Networking       | Dio + Interceptors  |
| Location         | Geolocator Package  |

---

## 🧩 Architecture

- **Clean Architecture**  
  Separation into `presentation`, `domain`, and `data` layers for better scalability and testability.
- **Repository Pattern**  
  Abstract data sources with clear interface boundaries.
- **Riverpod / Provider**  
  Efficient and testable state management for UI responsiveness and reactivity.

---

## 🎨 UI/UX Highlights

- 🎴 **Custom Weather Cards** with Animated Icons
- 🧱 **Skeleton Loaders** for News Tiles
- 🔍 **Custom Search Bar** with Debounce
- 🧭 **Blurred App Bars**, Hero Transitions & Page Animations
- 📱 Fully **Responsive Layout** for different screen sizes

---

## ⚙️ Advanced Features

- 📦 **Smart Caching** with Offline Access
- 🧮 **Debounced Search Input** for News
- 📉 **Lazy Loading & Pagination**
- 🧠 **Error States**: Retry Buttons, Empty States, Permission Handling
- 🔋 **Optimized Image Caching** and Memory Management
- 🛑 **API Rate Limit Handling**

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- API Keys for:
  - [OpenWeatherMap](https://openweathermap.org/api)
  - [NewsAPI](https://newsapi.org)
