-- 创建表单数据存储表
CREATE TABLE IF NOT EXISTS health_form_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id VARCHAR(50) UNIQUE NOT NULL COMMENT '提交ID，用于跟踪',
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    height INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    goal_type VARCHAR(20) NOT NULL,
    goal_value DECIMAL(5,2) NOT NULL,
    goal_time INT NOT NULL,
    daily_time INT NOT NULL,
    kitchen_condition VARCHAR(20) NOT NULL,
    facility VARCHAR(20) NOT NULL,
    experience VARCHAR(20) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'pending' COMMENT '处理状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    processed_at TIMESTAMP NULL COMMENT '处理完成时间',
    result_html TEXT NULL COMMENT '最终HTML结果',
    error_message TEXT NULL COMMENT '错误信息',
    INDEX idx_status (status),
    INDEX idx_submission_id (submission_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康表单提交数据表';

-- V3版本加入邮件

ALTER TABLE health_form_submissions 
ADD COLUMN email VARCHAR(255) NOT NULL COMMENT '用户邮箱地址' 
AFTER experience;
