# API Integration Guide - Photobug Flutter App

## 📋 Konfigurasi Flutter

### 1. Update Base URL
File: `lib/services/auth_service.dart`

Ganti `baseUrl` sesuai dengan URL Laravel Anda:
```dart
// Untuk local (laptop yang sama)
static const String baseUrl = 'http://localhost:8000';

// Atau jika menggunakan IP:
static const String baseUrl = 'http://192.168.1.100:8000'; // Sesuaikan IP Anda
```

### 2. Install Dependencies
```bash
flutter pub get
```

---

## 🔌 Laravel Backend Requirements

### Login Endpoint
**Method:** `POST`  
**URL:** `/api/login`

### Request Body
```json
{
  "username": "Daniel",
  "password": "password123"
}
```

### Success Response (Status 200)
```json
{
  "success": true,
  "message": "Login berhasil",
  "token": "your_auth_token_here",
  "user": {
    "id": 1,
    "name": "Daniel",
    "username": "Daniel",
    "email": "daniel@example.com"
  },
  "role": "petani"
}
```

### Role Options
- `petani` → Petani Dashboard
- `penyuluh` → Penyuluh Dashboard  
- `admin` → Admin Dashboard

### Error Response (Status 401)
```json
{
  "success": false,
  "message": "Username atau password salah"
}
```

---

## 🛠️ Contoh Implementasi Laravel

### Routes (routes/api.php)
```php
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
```

### Controller (app/Http/Controllers/AuthController.php)
```php
<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        $user = User::where('username', $request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Username atau password salah'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => $user,
            'role' => $user->role // Pastikan user model punya field 'role'
        ], 200);
    }
}
```

---

## 🧪 Testing dengan Postman

1. **Method:** POST
2. **URL:** `http://localhost:8000/api/login`
3. **Headers:**
   - `Content-Type: application/json`
   - `Accept: application/json`
4. **Body (JSON):**
   ```json
   {
     "username": "Daniel",
     "password": "password123"
   }
   ```

---

## ⚠️ Penting!

1. **Android Emulator ke localhost Laravel:**
   - Gunakan IP address actual laptop Anda, bukan `localhost:8000`
   - Cek IP dengan: `ipconfig` (Windows) atau `ifconfig` (Mac/Linux)

2. **CORS Configuration (Laravel):**
   Jika ada error CORS, update `.env`:
   ```
   APP_URL=http://localhost:8000
   ```

3. **Token Storage:**
   Saat ini token disimpan di memory. Untuk production, simpan di secure storage menggunakan `flutter_secure_storage` package.

---

## 📱 Testing Login Flutter

Gunakan kredensial:
- **Username:** Daniel
- **Password:** password123

Sistem akan otomatis redirect berdasarkan role user di database.
