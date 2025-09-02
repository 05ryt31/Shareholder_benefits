# API Key Setup Guide

## Google Maps API Key Setup

### 1. Get Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable "Maps SDK for iOS" API
4. Go to APIs & Services → Credentials
5. Create API Key
6. Restrict the API key to iOS apps with your bundle ID

### 2. Configure iOS
1. Copy `ios/Runner/Info.plist.template` to `ios/Runner/Info.plist`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key
3. Run `cd ios && pod install`

### 3. Configure Android (if needed)
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

### Security Notes
- Never commit API keys to version control
- Use environment variables or secure configuration files
- The actual `Info.plist` file is gitignored for security
