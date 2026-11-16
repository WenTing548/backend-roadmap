-- backend-roadmap 数据库初始化脚本
-- 用法：mysql -u root -p --default-character-set=utf8mb4 < sql/init.sql
-- 说明：可重复执行，会重建表并插入测试数据

CREATE DATABASE IF NOT EXISTS backend_roadmap
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE backend_roadmap;

-- ============================================================
-- 用户表
-- ============================================================
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id         BIGINT       PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
  username   VARCHAR(50)  NOT NULL UNIQUE            COMMENT '用户名',
  password   VARCHAR(100) NOT NULL                   COMMENT '密码(演示用,生产必须加密)',
  nickname   VARCHAR(50)  DEFAULT NULL               COMMENT '昵称',
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================================
-- 商品表
-- ============================================================
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id          BIGINT        PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID',
  seller_id   BIGINT        NOT NULL                   COMMENT '卖家ID',
  title       VARCHAR(100)  NOT NULL                   COMMENT '标题',
  description TEXT                                     COMMENT '描述',
  price       DECIMAL(10,2) NOT NULL                   COMMENT '价格',
  status      TINYINT       NOT NULL DEFAULT 0         COMMENT '0在售 1已售 2下架',
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  KEY idx_seller_id (seller_id),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- ============================================================
-- 订单表
-- ============================================================
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  id          BIGINT        PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
  order_no    VARCHAR(32)   NOT NULL UNIQUE            COMMENT '订单号',
  buyer_id    BIGINT        NOT NULL                   COMMENT '买家ID',
  product_id  BIGINT        NOT NULL                   COMMENT '商品ID',
  amount      DECIMAL(10,2) NOT NULL                   COMMENT '订单金额',
  status      TINYINT       NOT NULL DEFAULT 0         COMMENT '0待支付 1已支付 2已发货 3已完成 4已取消',
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

  KEY idx_buyer_id (buyer_id),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ============================================================
-- 测试数据
-- ============================================================
INSERT INTO users (username, password, nickname) VALUES
  ('zhangsan', '123456', '张三'),
  ('lisi',     '123456', '李四'),
  ('wangwu',   '123456', '王五');

INSERT INTO products (seller_id, title, description, price, status) VALUES
  (1, 'iPhone 13 Pro 256G', '九成新,无划痕,国行',           3999.00, 0),
  (2, 'MacBook Air M2',     '2023款,8G+256G,电池健康98%',    6200.00, 0),
  (1, '机械键盘 87键',       '红轴,用过三个月',              299.00,  1);

INSERT INTO orders (order_no, buyer_id, product_id, amount, status) VALUES
  ('20261116001', 2, 1, 3999.00, 1),
  ('20261116002', 3, 3, 299.00,  0);

-- 验证：三张表的行数
SELECT 'users' AS tbl, COUNT(*) AS cnt FROM users
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders',   COUNT(*) FROM orders;
