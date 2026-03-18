-- =====================================================
-- AI SkinPerfection Database
-- =====================================================

CREATE DATABASE IF NOT EXISTS skin_perfection
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE skin_perfection;

-- =====================================================
-- 1. ingredients
-- =====================================================

CREATE TABLE ingredients (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name_zh VARCHAR(100) NOT NULL UNIQUE,
    ingredient_name_en JSON NULL,

    spot_primary TINYINT(1) DEFAULT 0,
    spot_support TINYINT(1) DEFAULT 0,

    wrinkle_primary TINYINT(1) DEFAULT 0,
    wrinkle_support TINYINT(1) DEFAULT 0,

    pore_primary TINYINT(1) DEFAULT 0,
    pore_support TINYINT(1) DEFAULT 0,

    acne_primary TINYINT(1) DEFAULT 0,
    acne_support TINYINT(1) DEFAULT 0,

    comedone_primary TINYINT(1) DEFAULT 0,
    comedone_support TINYINT(1) DEFAULT 0,

    dark_circle_primary TINYINT(1) DEFAULT 0,
    dark_circle_support TINYINT(1) DEFAULT 0
);

-- =====================================================
-- 2. products
-- =====================================================

CREATE TABLE products (

    product_id INT AUTO_INCREMENT PRIMARY KEY,

    brand VARCHAR(100) NOT NULL,

    price_tier VARCHAR(20) NULL,

    category VARCHAR(50) NOT NULL,

    name VARCHAR(255) NOT NULL,

    price DECIMAL(10,2) NULL,

    description TEXT NULL,

    ingredients JSON NULL,

    concerns JSON NULL,

    skintypes VARCHAR(100) NULL,

    sensitivity VARCHAR(50) NULL,

    anti_aging TINYINT(1) DEFAULT 0,

    moisturizing TINYINT(1) DEFAULT 0,

    product_url VARCHAR(500) NULL,

    image_url VARCHAR(500) NULL,

    crawled_at TIMESTAMP NULL
);

-- =====================================================
-- 3. product_ingredients
-- =====================================================

CREATE TABLE product_ingredients (

    ingredient_id INT NOT NULL,

    ingredient_name_zh VARCHAR(100) NOT NULL,

    product_id INT NOT NULL,

    category VARCHAR(50) NULL,

    name VARCHAR(255) NULL,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (ingredient_id, product_id),

    FOREIGN KEY (ingredient_id)
        REFERENCES ingredients(ingredient_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- =====================================================
-- 4. ingredient_effects
-- =====================================================

CREATE TABLE ingredient_effects (

    ing_effect_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    ingredient VARCHAR(100) NOT NULL,

    effect VARCHAR(255) NOT NULL,

    user_description TEXT NOT NULL
);

-- =====================================================
-- 5. users
-- =====================================================

CREATE TABLE users (

    user_id INT AUTO_INCREMENT PRIMARY KEY,

    line_id VARCHAR(50) NOT NULL UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    last_session_at TIMESTAMP NULL
);

-- =====================================================
-- 6. sessions
-- =====================================================

CREATE TABLE sessions (

    session_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    photoload_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    original_photo_url VARCHAR(500) NULL,

    analyzed_photo_url VARCHAR(500) NULL,

    status ENUM(
        'pending',
        'analyzing',
        'completed',
        'failed'
    ) DEFAULT 'pending',

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

-- =====================================================
-- 7. questionnaire_answers_tags
-- =====================================================

CREATE TABLE questionnaire_answers_tags (

    session_id INT PRIMARY KEY,

    answer1_tag VARCHAR(100) NOT NULL,
    answer2_tag VARCHAR(100) NOT NULL,
    answer3_tag VARCHAR(100) NOT NULL,
    answer4_tag VARCHAR(100) NOT NULL,
    answer5_tag VARCHAR(100) NOT NULL,
    answer6_tag VARCHAR(100) NOT NULL,
    answer7_tag VARCHAR(100) NOT NULL,
    answer8_tag VARCHAR(100) NOT NULL,
    answer9_tag VARCHAR(100) NOT NULL,

    questionnaire_version VARCHAR(20) NOT NULL,

    answered_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
);

-- =====================================================
-- 8. session_llm_analysis
-- =====================================================

CREATE TABLE session_llm_analysis (

    session_id INT PRIMARY KEY,

    a_score DECIMAL(3,1) NULL,

    a_complexion_text TEXT NULL,

    a_massage_action JSON NULL,

    dietary_advice JSON NULL,

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
);

-- =====================================================
-- 9. session_skin_scores
-- =====================================================

CREATE TABLE session_skin_scores (

    session_id INT PRIMARY KEY,

    acne_score DECIMAL(3,1) NULL,

    comedone_score DECIMAL(3,1) NULL,

    wrinkle_score DECIMAL(3,1) NULL,

    spot_score DECIMAL(3,1) NULL,

    dark_circle_score DECIMAL(3,1) NULL,

    top_1_issues VARCHAR(100) NULL,

    top_2_issues VARCHAR(100) NULL,

    llm_1_text TEXT NULL,

    llm_2_text TEXT NULL,

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
);

-- =====================================================
-- 10. session_recommendations
-- =====================================================

CREATE TABLE session_recommendations (

    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,

    session_id INT NOT NULL UNIQUE,

    matched_ingredients JSON NULL,

    products_snapshot JSON NULL,

    product_id_1 INT NULL,
    product_id_2 INT NULL,
    product_id_3 INT NULL,
    product_id_4 INT NULL,
    product_id_5 INT NULL,
    product_id_6 INT NULL,

    algorithm_version VARCHAR(10) NULL,

    funnel_stats JSON NULL,

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
);

-- =====================================================
-- 11. ga_events
-- =====================================================

CREATE TABLE ga_events (

    event_id INT AUTO_INCREMENT PRIMARY KEY,

    session_id INT NOT NULL,

    overview_duration INT NULL,

    section_a_duration INT NULL,

    section_b_duration INT NULL,

    section_c_duration INT NULL,

    section_d_duration INT NULL,

    clicked_products JSON NULL,

    products_click_count INT DEFAULT 0,

    exit_method VARCHAR(50) NULL,

    exit_time TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
);