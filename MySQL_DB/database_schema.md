# AI SkinPerfection Database Schema

本文件說明 AI SkinPerfection 系統的 MySQL資料庫設計，包含靜態資料表與動態資料表。

---

# 靜態資料表 (Static Tables)

## 1. ingredients（成分表）

用途：儲存保養品成分資料，以及其對六種肌膚問題的功效。

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| ingredient_id | INT | PRIMARY KEY, AUTO_INCREMENT | 成分唯一識別碼 |
| ingredient_name_zh | VARCHAR(100) | NOT NULL, UNIQUE | 成分中文名稱 |
| ingredient_name_en | JSON | NULL | 成分英文名稱（陣列） |
| spot_primary | TINYINT(1) | DEFAULT 0 | 斑點主要功效 |
| spot_support | TINYINT(1) | DEFAULT 0 | 斑點輔助功效 |
| wrinkle_primary | TINYINT(1) | DEFAULT 0 | 皺紋主要功效 |
| wrinkle_support | TINYINT(1) | DEFAULT 0 | 皺紋輔助功效 |
| pore_primary | TINYINT(1) | DEFAULT 0 | 毛孔主要功效 |
| pore_support | TINYINT(1) | DEFAULT 0 | 毛孔輔助功效 |
| acne_primary | TINYINT(1) | DEFAULT 0 | 痘痘主要功效 |
| acne_support | TINYINT(1) | DEFAULT 0 | 痘痘輔助功效 |
| comedone_primary | TINYINT(1) | DEFAULT 0 | 粉刺主要功效 |
| comedone_support | TINYINT(1) | DEFAULT 0 | 粉刺輔助功效 |
| dark_circle_primary | TINYINT(1) | DEFAULT 0 | 黑眼圈主要功效 |
| dark_circle_support | TINYINT(1) | DEFAULT 0 | 黑眼圈輔助功效 |

---

## 2. products（產品表）

用途：儲存保養品產品資訊。

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| product_id | INT | PRIMARY KEY, AUTO_INCREMENT | 產品唯一識別碼 |
| brand | VARCHAR(100) | NOT NULL | 品牌 |
| price_tier | VARCHAR(20) | NULL | 價格區間 |
| category | VARCHAR(50) | NOT NULL | 產品類別 |
| name | VARCHAR(255) | NOT NULL | 產品名稱 |
| price | DECIMAL(10,2) | NULL | 價格 |
| description | TEXT | NULL | 產品描述 |
| ingredients | JSON | NULL | 成分列表 |
| concerns | JSON | NULL | 適用肌膚問題 |
| skintypes | VARCHAR(100) | NULL | 適用膚質 |
| sensitivity | VARCHAR(50) | NULL | 敏感肌適用性 |
| anti_aging | TINYINT(1) | DEFAULT 0 | 抗老 |
| moisturizing | TINYINT(1) | DEFAULT 0 | 保濕 |
| product_url | VARCHAR(500) | NULL | 產品頁面 |
| image_url | VARCHAR(500) | NULL | 產品圖片 |
| crawled_at | TIMESTAMP | NULL | 爬蟲時間 |

---

## 3. product_ingredients（產品成分關聯表）

用途：紀錄產品與成分的多對多關係。

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| ingredient_id | INT | PK | 成分 ID |
| ingredient_name_zh | VARCHAR(100) | NOT NULL | 成分名稱 |
| product_id | INT | PK | 產品 ID |
| category | VARCHAR(50) | NULL | 產品類別 |
| name | VARCHAR(255) | NULL | 產品名稱 |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | 建立時間 |

複合主鍵：
PRIMARY KEY (ingredient_id, product_id)


---

## 4. ingredient_effects（成分說明表）

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| ing_effect_id | BIGINT | PRIMARY KEY | 主鍵 |
| ingredient | VARCHAR(100) | NOT NULL | 成分名稱 |
| effect | VARCHAR(255) | NOT NULL | 功效標籤 |
| user_description | TEXT | NOT NULL | 專業效果說明 |

---

# 動態資料表 (Dynamic Tables)

## 5. users（使用者表）

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| user_id | INT | PRIMARY KEY, AUTO_INCREMENT | 系統使用者 ID |
| line_id | VARCHAR(50) | NOT NULL, UNIQUE | LINE 使用者 ID |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 加入時間 |
| last_session_at | TIMESTAMP | NULL | 最後分析時間 |

---

## 6. sessions（分析會話表）

| 欄位名稱 | 資料型態 | 約束條件 | 說明 |
|---|---|---|---|
| session_id | INT | PRIMARY KEY, AUTO_INCREMENT | 會話 ID |
| user_id | INT | FOREIGN KEY | users.user_id |
| photoload_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 照片上傳時間 |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | 更新時間 |
| original_photo_url | VARCHAR(500) | NULL | 原始照片 |
| analyzed_photo_url | VARCHAR(500) | NULL | 分析後照片 |
| status | ENUM | pending / analyzing / completed / failed |

---

## 7. questionnaire_answers_tags（問卷答案表）

| 欄位名稱 | 資料型態 | 說明 |
|---|---|---|
| session_id | INT | PK / FK |
| answer1_tag | VARCHAR(100) | |
| answer2_tag | VARCHAR(100) | |
| answer3_tag | VARCHAR(100) | |
| answer4_tag | VARCHAR(100) | |
| answer5_tag | VARCHAR(100) | |
| answer6_tag | VARCHAR(100) | |
| answer7_tag | VARCHAR(100) | |
| answer8_tag | VARCHAR(100) | |
| answer9_tag | VARCHAR(100) | |
| questionnaire_version | VARCHAR(20) | |
| answered_at | DATETIME | |

---

## 8. session_llm_analysis（LLM 分析結果）

| 欄位名稱 | 資料型態 | 說明 |
|---|---|---|
| session_id | INT | PK |
| a_score | DECIMAL(3,1) | 氣色分數 |
| a_complexion_text | TEXT | AI 氣色分析 |
| a_massage_action | JSON | 按摩建議 |
| dietary_advice | JSON | 飲食建議 |

---

## 9. session_skin_scores（肌膚評分）

| 欄位名稱 | 資料型態 |
|---|---|
| session_id | INT |
| acne_score | DECIMAL(3,1) |
| comedone_score | DECIMAL(3,1) |
| wrinkle_score | DECIMAL(3,1) |
| spot_score | DECIMAL(3,1) |
| dark_circle_score | DECIMAL(3,1) |
| top_1_issues | VARCHAR(100) |
| top_2_issues | VARCHAR(100) |
| llm_1_text | TEXT |
| llm_2_text | TEXT |

---

## 10. session_recommendations（推薦結果）

| 欄位名稱 | 資料型態 |
|---|---|
| recommendation_id | INT |
| session_id | INT |
| matched_ingredients | JSON |
| products_snapshot | JSON |
| product_id_1 | INT |
| product_id_2 | INT |
| product_id_3 | INT |
| product_id_4 | INT |
| product_id_5 | INT |
| product_id_6 | INT |
| algorithm_version | VARCHAR(10) |
| funnel_stats | JSON |

---

## 11. ga_events（使用者行為追蹤）

| 欄位名稱 | 資料型態 |
|---|---|
| event_id | INT |
| session_id | INT |
| overview_duration | INT |
| section_a_duration | INT |
| section_b_duration | INT |
| section_c_duration | INT |
| section_d_duration | INT |
| clicked_products | JSON |
| products_click_count | INT |
| exit_method | VARCHAR(50) |
| exit_time | TIMESTAMP |
| created_at | TIMESTAMP |
| updated_at | TIMESTAMP |

---

# Database Design Notes

設計資料庫時比較三種資料存放方式：

### 字串 (String)
優點：簡單  
缺點：查詢困難

### JSON
優點：保留結構、彈性高  
缺點：查詢效率較低

### 結構化 (Relational)
優點：查詢效率最高  
缺點：設計成本高

目前系統採用 **JSON + 結構化混合設計**，未來會透過：

- Slow Query Log
- Index Optimization
- Schema Refactoring

逐步優化。
