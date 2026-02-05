# State-Aware Orchestration デモ

このドキュメントでは、dbt の State-aware orchestration の効果を実演します。

## 概要

State-aware orchestration を使うと、**変更があったモデルだけ**を再ビルドできます。
これにより、重いモデルを毎回ビルドする必要がなくなり、大幅な時間短縮が可能です。

## モデル構成

| モデル | 実行時間 | 説明 |
|--------|----------|------|
| `heavy_customer_analytics` | 15-30秒 | 重い処理（日次累積統計） |
| `light_order_summary` | <1秒 | 軽い処理（注文サマリー） |
| `customers` | <1秒 | 顧客マスター |
| `stg_customers`, `stg_orders` | <1秒 | ステージングモデル |

## デモ手順

### Step 1: 初回ビルド（全モデル）

```bash
# 全モデルをビルドし、state を保存
dbt build

# ビルド時間を確認（heavy_customer_analytics が時間がかかる）
```

### Step 2: State の保存

```bash
# 現在の manifest を保存（比較用）
cp target/manifest.json target/manifest_baseline.json
```

### Step 3: 軽いモデルだけを変更

`models/marts/light_order_summary.sql` に小さな変更を加えます：

```sql
-- コメントを追加するだけでも変更として検出される
-- Updated: 2025-02-06
```

### Step 4: State-aware ビルド（変更分のみ）

```bash
# 変更されたモデルだけをビルド
dbt run --select state:modified+ --state target/manifest_baseline.json

# または defer を使用
dbt run --select state:modified+ --defer --state target/manifest_baseline.json
```

**結果**: `light_order_summary` だけがビルドされ、`heavy_customer_analytics` はスキップされます！

### Step 5: 時間比較

| シナリオ | 実行時間 |
|----------|----------|
| `dbt run` (全モデル) | 約20-35秒 |
| `dbt run --select state:modified+` (変更分のみ) | 約1-2秒 |

## State Selectors

| Selector | 説明 |
|----------|------|
| `state:modified` | コードが変更されたモデル |
| `state:modified+` | 変更されたモデル + その下流モデル |
| `state:new` | 新しく追加されたモデル |
| `state:old` | 削除されたモデル |

## dbt Cloud での設定

dbt Cloud では、CI/CD ジョブで自動的に state comparison が利用可能です：

```yaml
# dbt Cloud ジョブの設定例
dbt build --select state:modified+
```

Slim CI として設定すると、PR ごとに変更されたモデルだけをテストできます。

## ベストプラクティス

1. **本番環境の manifest を保存**: CI/CD で本番の state と比較
2. **Slim CI の活用**: PR で変更されたモデルだけをテスト
3. **heavy タグの活用**: 重いモデルには `tags: ['heavy']` を付けて管理

```bash
# heavy タグのモデルを除外してビルド
dbt run --exclude tag:heavy

# heavy タグのモデルだけをビルド（深夜バッチなど）
dbt run --select tag:heavy
```

## トラブルシューティング

### Q: state:modified が何も選択しない

manifest.json のパスが正しいか確認してください：

```bash
ls -la target/manifest_baseline.json
```

### Q: 依存関係のあるモデルも再ビルドしたい

`+` サフィックスを使用してください：

```bash
dbt run --select state:modified+  # 変更 + 下流
dbt run --select +state:modified  # 上流 + 変更
dbt run --select +state:modified+ # 上流 + 変更 + 下流
```
