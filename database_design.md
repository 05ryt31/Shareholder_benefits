# 株主優待マップアプリ - データベース設計

## 概要
株主優待マップアプリで使用するデータベースのテーブル設計です。現在のアプリ機能（検索、フィルタリング、地図表示）をサポートし、将来の機能拡張にも対応できる設計となっています。

## 主要テーブル設計

### 1. companies（企業テーブル）
企業の基本情報を管理するテーブルです。

```sql
CREATE TABLE companies (
  id SERIAL PRIMARY KEY,
  company_code VARCHAR(10) UNIQUE NOT NULL,  -- 証券コード
  company_name VARCHAR(100) NOT NULL,        -- 企業名
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**主要項目説明**
- `company_code`: 4桁の証券コード（例：8267）
- `company_name`: 企業名（例：イオン）

### 2. shareholder_benefits（株主優待テーブル）
株主優待の詳細情報を管理するテーブルです。

```sql
CREATE TABLE shareholder_benefits (
  id SERIAL PRIMARY KEY,
  company_id INTEGER REFERENCES companies(id),
  benefit_type VARCHAR(50) NOT NULL,         -- 優待種別（買い物券、割引券等）
  description TEXT NOT NULL,                 -- 優待内容詳細
  benefit_value INTEGER,                     -- 優待券面額（円）
  validity_start_date DATE,                  -- 有効期間開始
  validity_end_date DATE,                    -- 有効期間終了
  image_url VARCHAR(255),                    -- 優待券画像URL
  is_active BOOLEAN DEFAULT TRUE,            -- 有効/無効フラグ
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**主要項目説明**
- `benefit_type`: 優待の種類（買い物券、食事券、割引券等）
- `minimum_shares`: 優待を受けるための最低保有株数
- `benefit_value`: 優待の金銭価値
- `rights_date`: 株主として登録される基準日

### 3. stores（店舗テーブル）
株主優待が利用可能な店舗情報を管理するテーブルです。

```sql
CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,                -- 店舗名
  category VARCHAR(50),                      -- 店舗カテゴリ
  address TEXT NOT NULL,                     -- 住所
  prefecture VARCHAR(20) NOT NULL,           -- 都道府県
  city VARCHAR(50) NOT NULL,                 -- 市区町村
  postal_code VARCHAR(10),                   -- 郵便番号
  latitude DECIMAL(10, 8),                   -- 緯度
  longitude DECIMAL(11, 8),                  -- 経度
  phone VARCHAR(20),                         -- 電話番号
  business_hours TEXT,                       -- 営業時間
  is_active BOOLEAN DEFAULT TRUE,            -- 営業中フラグ
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**主要項目説明**
- `category`: 店舗の業種（スーパーマーケット、ファミリーレストラン等）
- `latitude`, `longitude`: 地図表示用の座標情報
- `business_hours`: 営業時間（テキスト形式で柔軟に対応）

### 4. benefit_store_mappings（優待-店舗関連テーブル）
株主優待と利用可能店舗の関連を管理する中間テーブルです。

```sql
CREATE TABLE benefit_store_mappings (
  id SERIAL PRIMARY KEY,
  benefit_id INTEGER REFERENCES shareholder_benefits(id),
  store_id INTEGER REFERENCES stores(id),
  usage_conditions TEXT,                     -- 利用条件
  discount_rate DECIMAL(5,2),                -- 割引率（%）
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(benefit_id, store_id)
);
```

**主要項目説明**
- `usage_conditions`: 店舗固有の利用条件や制限
- `discount_rate`: 割引券の場合の割引率

## 将来の機能拡張用テーブル

### 5. users（ユーザーテーブル）
ユーザー管理機能追加時に使用するテーブルです。

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  username VARCHAR(50),
  password_hash VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. user_holdings（保有株式テーブル）
ユーザーの株式保有情報を管理するテーブルです。

```sql
CREATE TABLE user_holdings (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  company_id INTEGER REFERENCES companies(id),
  shares_count INTEGER NOT NULL,             -- 保有株数
  purchase_date DATE,                        -- 購入日
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, company_id)
);
```

### 7. favorites（お気に入りテーブル）
ユーザーのお気に入り株主優待を管理するテーブルです。

```sql
CREATE TABLE favorites (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  benefit_id INTEGER REFERENCES shareholder_benefits(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, benefit_id)
);
```

## インデックス設計

パフォーマンス向上のため、検索頻度の高い項目にインデックスを設定します。

```sql
-- 企業検索用
CREATE INDEX idx_companies_code ON companies(company_code);
CREATE INDEX idx_companies_name ON companies(company_name);

-- 株主優待検索用
CREATE INDEX idx_benefits_company ON shareholder_benefits(company_id);
CREATE INDEX idx_benefits_type ON shareholder_benefits(benefit_type);
CREATE INDEX idx_benefits_active ON shareholder_benefits(is_active);

-- 店舗検索用（地理的検索）
CREATE INDEX idx_stores_location ON stores(latitude, longitude);
CREATE INDEX idx_stores_prefecture ON stores(prefecture);
CREATE INDEX idx_stores_category ON stores(category);

-- 関連テーブル検索用
CREATE INDEX idx_mappings_benefit ON benefit_store_mappings(benefit_id);
CREATE INDEX idx_mappings_store ON benefit_store_mappings(store_id);
```

## 設計の特徴

### 1. 正規化
- 企業情報と株主優待情報を分離
- 店舗情報を独立管理
- 多対多の関係は中間テーブルで管理

### 2. 柔軟性
- 複数の優待種別に対応
- 店舗固有の利用条件を設定可能
- テキストフィールドで複雑な条件も表現可能

### 3. 地理情報対応
- 緯度経度による地図機能サポート
- 都道府県・市区町村による地域検索対応

### 4. 拡張性
- ユーザー機能の追加に対応
- お気に入り機能やパーソナライゼーション機能に対応
- 将来的なAPI連携にも対応可能

### 5. 検索最適化
- 検索頻度の高い項目にインデックスを設定
- 複合インデックスによる高速検索
- 地理的検索に対応したインデックス

## データ移行について

現在のサンプルデータから本設計への移行方法：

1. **companies テーブル**：現在のハードコードされた企業情報を移行
2. **shareholder_benefits テーブル**：現在の `ShareholderBenefit` モデルデータを移行
3. **stores テーブル**：現在の `Store` モデルデータを移行
4. **benefit_store_mappings テーブル**：現在の `availableStores` 関連を移行

## 運用考慮事項

- **データ更新頻度**：株主優待情報は年1-2回、店舗情報は随時更新
- **データ量**：上場企業約4,000社、優待実施企業約1,500社、店舗数十万件を想定
- **レスポンス時間**：地図検索で1秒以内、一般検索で0.5秒以内を目標