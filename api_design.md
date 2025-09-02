# 株主優待マップ API設計

## 概要
株主優待マップアプリのバックエンドAPI設計書です。現在のアプリ機能をサポートし、将来の機能拡張に対応できるRESTful APIを定義します。

## ベースURL
```
https://api.shareholder-benefits.jp/v1
```

## 認証
現在は認証なしで設計していますが、将来的にはJWT認証を予定。
```http
Authorization: Bearer <jwt_token>
```

## エンドポイント一覧

### 1. 企業関連 API

#### GET /companies
企業一覧を取得

**リクエスト**
```http
GET /companies?page=1&limit=20&industry_category=小売業
```

**クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| page | integer | No | ページ番号（デフォルト: 1） |
| limit | integer | No | 取得件数（デフォルト: 20、最大: 100） |
| industry_category | string | No | 業界カテゴリでフィルタ |
| search | string | No | 企業名での検索 |

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "companies": [
      {
        "id": 1,
        "company_code": "8267",
        "company_name": "イオン",
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 10,
      "total_count": 200,
      "per_page": 20
    }
  }
}
```

#### GET /companies/{id}
特定企業の詳細情報を取得

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "company": {
      "id": 1,
      "company_code": "8267",
      "company_name": "イオン",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 2. 株主優待関連 API

#### GET /benefits
株主優待一覧を取得（アプリのメイン機能）

**リクエスト**
```http
GET /benefits?page=1&limit=20&search=イオン&benefit_type=買い物券&is_active=true
```

**クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| page | integer | No | ページ番号（デフォルト: 1） |
| limit | integer | No | 取得件数（デフォルト: 20、最大: 100） |
| search | string | No | 企業名、銘柄コード、優待内容での検索 |
| benefit_type | string | No | 優待種別でフィルタ |
| company_id | integer | No | 企業IDでフィルタ |
| is_active | boolean | No | 有効な優待のみ（デフォルト: true） |

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "benefits": [
      {
        "id": 1,
        "company": {
          "id": 1,
          "company_code": "8267",
          "company_name": "イオン"
        },
        "benefit_type": "買い物券",
        "description": "100株以上保有で1,000円分の買い物券",
        "benefit_value": 1000,
        "validity_start_date": "2024-01-01",
        "validity_end_date": "2024-12-31",
        "image_url": "https://api.shareholder-benefits.jp/images/benefits/aeon.png",
        "is_active": true,
        "available_stores_count": 150,
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_count": 100,
      "per_page": 20
    }
  }
}
```

#### GET /benefits/{id}
特定の株主優待詳細情報を取得

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "benefit": {
      "id": 1,
      "company": {
        "id": 1,
        "company_code": "8267",
        "company_name": "イオン"
      },
      "benefit_type": "買い物券",
      "description": "100株以上保有で1,000円分の買い物券",
      "benefit_value": 1000,
      "validity_start_date": "2024-01-01",
      "validity_end_date": "2024-12-31",
      "image_url": "https://api.shareholder-benefits.jp/images/benefits/aeon.png",
      "is_active": true,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  }
}
```

#### GET /benefits/{id}/stores
特定の株主優待で利用可能な店舗一覧を取得

**リクエスト**
```http
GET /benefits/1/stores?prefecture=東京都&category=スーパーマーケット&page=1&limit=20
```

**クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| page | integer | No | ページ番号（デフォルト: 1） |
| limit | integer | No | 取得件数（デフォルト: 20、最大: 100） |
| prefecture | string | No | 都道府県でフィルタ |
| city | string | No | 市区町村でフィルタ |
| category | string | No | 店舗カテゴリでフィルタ |
| is_active | boolean | No | 営業中の店舗のみ（デフォルト: true） |

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "stores": [
      {
        "id": 1,
        "name": "イオン新宿店",
        "address": "東京都新宿区新宿3-1-26",
        "prefecture": "東京都",
        "city": "新宿区",
        "latitude": 35.6906,
        "longitude": 139.7006,
        "phone": "03-1234-5678",
        "business_hours": "10:00-22:00",
        "is_active": true,
        "usage_conditions": "1回につき1枚まで利用可能",
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 8,
      "total_count": 150,
      "per_page": 20
    }
  }
}
```

### 3. 店舗関連 API

#### GET /stores
店舗一覧を取得（地図表示用）

**リクエスト**
```http
GET /stores?lat=35.6906&lng=139.7006&radius=5000&category=スーパーマーケット
```

**クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| page | integer | No | ページ番号（デフォルト: 1） |
| limit | integer | No | 取得件数（デフォルト: 50、最大: 100） |
| lat | float | No | 中心緯度（位置検索用） |
| lng | float | No | 中心経度（位置検索用） |
| radius | integer | No | 検索半径（メートル、最大: 50000） |
| prefecture | string | No | 都道府県でフィルタ |
| city | string | No | 市区町村でフィルタ |
| category | string | No | 店舗カテゴリでフィルタ |
| is_active | boolean | No | 営業中の店舗のみ（デフォルト: true） |

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "stores": [
      {
        "id": 1,
        "name": "イオン新宿店",
        "address": "東京都新宿区新宿3-1-26",
        "prefecture": "東京都",
        "city": "新宿区",
        "latitude": 35.6906,
        "longitude": 139.7006,
        "phone": "03-1234-5678",
        "business_hours": "10:00-22:00",
        "is_active": true,
        "distance_meters": 250,
        "available_benefits": [
          {
            "benefit_id": 1,
            "company_name": "イオン",
            "benefit_type": "買い物券",
            "usage_conditions": "1回につき1枚まで利用可能"
          }
        ],
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_count": 50,
      "per_page": 20
    }
  }
}
```

#### GET /stores/{id}
特定店舗の詳細情報を取得

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "store": {
      "id": 1,
      "name": "イオン新宿店",
      "address": "東京都新宿区新宿3-1-26",
      "prefecture": "東京都",
      "city": "新宿区",
      "postal_code": "160-0022",
      "latitude": 35.6906,
      "longitude": 139.7006,
      "phone": "03-1234-5678",
      "business_hours": "10:00-22:00",
      "website_url": "https://www.aeon.jp/store/shinjuku/",
      "is_active": true,
      "available_benefits": [
        {
          "benefit_id": 1,
          "company": {
            "id": 1,
            "company_code": "8267",
            "company_name": "イオン"
          },
          "benefit_type": "買い物券",
          "usage_conditions": "1回につき1枚まで利用可能",
          "discount_rate": null
        }
      ],
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 4. 検索・フィルタ関連 API

#### GET /search
統合検索API

**リクエスト**
```http
GET /search?q=イオン&type=all&page=1&limit=20
```

**クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|-----------|---|------|------|
| q | string | Yes | 検索クエリ |
| type | enum | No | 検索対象（all/companies/benefits/stores） |
| page | integer | No | ページ番号（デフォルト: 1） |
| limit | integer | No | 取得件数（デフォルト: 20、最大: 50） |

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "results": {
      "companies": [
        {
          "id": 1,
          "company_code": "8267",
          "company_name": "イオン",
          "match_type": "company_name"
        }
      ],
      "benefits": [
        {
          "id": 1,
          "company_name": "イオン",
          "benefit_type": "買い物券",
          "description": "100株以上保有で1,000円分の買い物券",
          "match_type": "company_name"
        }
      ],
      "stores": [
        {
          "id": 1,
          "name": "イオン新宿店",
          "address": "東京都新宿区新宿3-1-26",
          "match_type": "store_name"
        }
      ]
    },
    "total_count": 15,
    "search_query": "イオン"
  }
}
```

#### GET /filters
フィルタ用の選択肢一覧を取得

**レスポンス**
```json
{
  "status": "success",
  "data": {
    "benefit_types": [
      "買い物券",
      "食事券",
      "割引券",
      "商品券",
      "QUOカード"
    ],
    "prefectures": [
      "北海道",
      "青森県",
      "岩手県",
      "..."
    ],
    "store_categories": [
      "スーパーマーケット",
      "ファミリーレストラン",
      "デパート",
      "家電量販店",
      "コンビニエンスストア"
    ]
  }
}
```

## エラーレスポンス

### 標準エラー形式
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "リクエストパラメータが不正です",
    "details": [
      {
        "field": "page",
        "message": "ページ番号は1以上である必要があります"
      }
    ]
  }
}
```

### HTTPステータスコード
| コード | 説明 |
|-------|------|
| 200 | 成功 |
| 400 | リクエストエラー |
| 401 | 認証エラー |
| 403 | 権限不足 |
| 404 | リソースが見つからない |
| 429 | レート制限超過 |
| 500 | サーバーエラー |

## レート制限
- 認証なしユーザー: 1分間に60リクエスト
- 認証済みユーザー: 1分間に1000リクエスト

## 将来の機能拡張用エンドポイント

### ユーザー管理 API（将来実装予定）

#### POST /auth/register
ユーザー登録

#### POST /auth/login
ログイン

#### GET /users/profile
プロフィール取得

#### POST /users/holdings
保有株式登録

#### GET /users/recommendations
おすすめ株主優待取得

#### POST /users/favorites
お気に入り追加

#### GET /users/favorites
お気に入り一覧取得

## データ更新頻度
- 企業情報: 1日1回（深夜バッチ処理）
- 株主優待情報: 1日1回（深夜バッチ処理）
- 店舗情報: リアルタイム更新対応
- 営業時間・電話番号: 週1回更新

## キャッシュ戦略
- 企業一覧: 24時間キャッシュ
- 株主優待一覧: 6時間キャッシュ
- 店舗情報: 1時間キャッシュ
- 検索結果: 30分キャッシュ

## セキュリティ
- HTTPS必須
- CORS設定対応
- SQLインジェクション対策
- XSS対策
- レート制限
- API キーまたはJWT認証（将来実装）