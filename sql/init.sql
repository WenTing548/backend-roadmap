-- backend-roadmap 数据库初始化脚本
-- 执行方式：mysql -u root -p --default-character-set=utf8mb4 < init.sql

CREATE DATABASE IF NOT EXISTS backend_roadmap
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE backend_roadmap;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id         BIGINT       PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  username   VARCHAR(50)  NOT NULL UNIQUE            COMMENT '用户名',
  password   VARCHAR(100) NOT NULL                   COMMENT '密码(演示用,生产必须加密)',
  nickname   VARCHAR(50)  DEFAULT NULL               COMMENT '昵称',
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

INSERT INTO users (username, password, nickname) VALUES
  ('zhangsan', '123456', '张三'),
  ('lisi',     '123456', '李四'),
  ('wangwu',   '123456', '王五');

SELECT id, username, nickname, created_at FROM users;
