# 株主優待マップ (Shareholder Benefit Map)

日本の株主向けに、株主優待券を使用できる店舗を検索・表示するFlutterアプリケーションです。

## 機能

- 株主優待券の一覧表示
- 優待券ごとの利用可能店舗の表示
- 店舗の地図上での表示
- 検索・フィルタリング機能
- 都道府県別の店舗絞り込み
- 店舗詳細情報の表示

## セットアップ

### 1. 依存関係のインストール

```bash
flutter pub get
```

### 2. Google Maps APIキーの設定

#### Android
`android/app/src/main/AndroidManifest.xml` の以下の部分を編集してください：

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

#### iOS
`ios/Runner/AppDelegate.swift` にAPIキーを設定してください。

### 3. アプリの実行

```bash
flutter run
```

## アーキテクチャ

- `lib/models/` - データモデル
- `lib/screens/` - 画面UI
- `lib/widgets/` - 再利用可能なUIコンポーネント
- `lib/services/` - ビジネスロジックとデータ管理
- `assets/` - 画像やデータファイル

## 主要な機能

### ホーム画面
- 株主優待券の一覧表示
- 検索機能（会社名、優待内容、銘柄コードで検索）
- 地図ボタンで全店舗マップに移動

### 店舗一覧画面
- 選択した優待券で利用できる店舗一覧
- 都道府県別フィルタリング
- 各店舗の詳細情報表示

### 地図画面
- Google Mapsを使用した店舗位置表示
- カテゴリ別フィルタリング
- マーカーのカラーコーディング

## サンプルデータ

アプリには以下の企業の株主優待データが含まれています：
- イオン（買い物券）
- すかいらーくホールディングス（食事券）
- 三越伊勢丹ホールディングス（割引券）
- ヤマダホールディングス（商品券）