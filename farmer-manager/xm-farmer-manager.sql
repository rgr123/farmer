/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50739
Source Host           : localhost:3306
Source Database       : xm-farmer-manager

Target Server Type    : MYSQL
Target Server Version : 50739
File Encoding         : 65001

Date: 2025-05-05 10:31:02
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色标识',
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='管理员';

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('1', 'admin', 'admin', '管理员', 'http://localhost:9090/files/1744598284343-b1284c3e6279e6178eadd7b3d780636f.jpeg', 'ADMIN', '18091250158', '1315171281@qq.com');

-- ----------------------------
-- Table structure for agritainment
-- ----------------------------
DROP TABLE IF EXISTS `agritainment`;
CREATE TABLE `agritainment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of agritainment
-- ----------------------------
INSERT INTO `agritainment` VALUES ('2', '1111', null, null, '2025-04-29 00:00:00', '<p>11111</p>', 'http://localhost:9090/files/1745898274546-811ba429d108297db4bef87205876036.jpeg');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `policy_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `policy_id` (`policy_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES ('5', '3', '1', '0', '好好好', '2025-04-29 17:06:34');
INSERT INTO `comment` VALUES ('7', '2', '1', '5', '是吗', '2025-04-29 17:07:49');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `num` int(11) NOT NULL,
  `sales` int(11) NOT NULL DEFAULT '0',
  `img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES ('1', '农夫山泉', '2.00', '97', '0', 'http://localhost:9090/files/1745834196806-img_053.jpg', null);
INSERT INTO `goods` VALUES ('2', '红富士苹果', '4.00', '100', '0', 'http://localhost:9090/files/1746062103565-img_217.jpg', null);
INSERT INTO `goods` VALUES ('5', '东鹏特饮', '5.00', '99', '0', 'http://localhost:9090/files/1746246051157-img_011.jpg', null);
INSERT INTO `goods` VALUES ('9', '红牛', '6.00', '91', '3', 'http://localhost:9090/files/1746269035657-img_153.jpg', null);
INSERT INTO `goods` VALUES ('13', '百事可乐', '3.00', '0', '0', 'http://localhost:9090/files/1746269315634-e060b5332a432ef1b3eceb3ea92f1820.jpeg', null);

-- ----------------------------
-- Table structure for information
-- ----------------------------
DROP TABLE IF EXISTS `information`;
CREATE TABLE `information` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  `user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of information
-- ----------------------------
INSERT INTO `information` VALUES ('1', '农产品大降价', null, '<p>近日将大幅度降低农产品的价格，大伙火速购买</p>', '2025-04-29 17:05:07', null);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `content` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
  `time` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建时间',
  `user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='公告信息表';

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES ('1', '今天系统正式上线，开始内测', '今天系统正式上线，开始内测', '2025-03-13', 'admin');
INSERT INTO `notice` VALUES ('2', '所有功能都已完成，可以正常使用', '所有功能都已完成，可以正常使用', '2025-03-13', 'admin');
INSERT INTO `notice` VALUES ('3', '今天天气很不错，可以出去一起玩了', '今天天气很不错，可以出去一起玩了', '2025-03-13', 'admin');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  `price` decimal(10,2) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', '1', '2', '20250427163834', '2025-04-27 16:38:34', '2.00', '已发货');
INSERT INTO `orders` VALUES ('2', '1', '3', '20250427165824', '2025-04-27 16:58:24', '2.00', '已完成');
INSERT INTO `orders` VALUES ('3', '1', '3', '20250427165824', '2025-04-27 16:58:24', '2.00', '已完成');
INSERT INTO `orders` VALUES ('4', '1', '3', '20250428190600', '2025-04-28 19:06:00', '2.00', '已完成');
INSERT INTO `orders` VALUES ('5', '1', '3', '20250429162141', '2025-04-29 16:21:41', '2.00', '已完成');
INSERT INTO `orders` VALUES ('6', '5', '3', '20250503122149', '2025-05-03 12:21:49', '5.00', '已完成');
INSERT INTO `orders` VALUES ('7', '13', '3', '20250505100910', '2025-05-05 10:09:10', '3.00', '已完成');
INSERT INTO `orders` VALUES ('8', '9', '3', '20250505101836', '2025-05-05 10:18:36', '6.00', '已完成');
INSERT INTO `orders` VALUES ('9', '9', '3', '20250505101837', '2025-05-05 10:18:37', '6.00', '已完成');
INSERT INTO `orders` VALUES ('10', '9', '3', '20250505101838', '2025-05-05 10:18:38', '6.00', '已完成');
INSERT INTO `orders` VALUES ('11', '9', '3', '20250505102405', '2025-05-05 10:24:05', '6.00', '待发货');
INSERT INTO `orders` VALUES ('12', '9', '3', '20250505102405', '2025-05-05 10:24:05', '6.00', '待发货');
INSERT INTO `orders` VALUES ('13', '9', '3', '20250505102405', '2025-05-05 10:24:05', '6.00', '待发货');
INSERT INTO `orders` VALUES ('14', '9', '3', '20250505102822', '2025-05-05 10:28:22', '6.00', '待发货');
INSERT INTO `orders` VALUES ('15', '9', '3', '20250505102822', '2025-05-05 10:28:22', '6.00', '待发货');
INSERT INTO `orders` VALUES ('16', '9', '3', '20250505102822', '2025-05-05 10:28:22', '6.00', '待发货');

-- ----------------------------
-- Table structure for policy
+
-- ----------------------------
DROP TABLE IF EXISTS `policy`;
CREATE TABLE `policy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of policy
-- ----------------------------
INSERT INTO `policy` VALUES ('1', '新政策', '<p>一条新的政策</p>', '2025-04-29 17:05:44', '0');

-- ----------------------------
-- Table structure for poorapply
-- ----------------------------
DROP TABLE IF EXISTS `poorapply`;
CREATE TABLE `poorapply` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '申请内容',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT '申请状态',
  `time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='贫困申请表';

-- ----------------------------
-- Records of poorapply
-- ----------------------------
INSERT INTO `poorapply` VALUES ('2', '3', null, '审核通过', '2025-04-27 00:00:00');

-- ----------------------------
-- Table structure for praise
-- ----------------------------
DROP TABLE IF EXISTS `praise`;
CREATE TABLE `praise` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `policy_id` int(11) NOT NULL,
  `time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `praise_ibfk_2` (`policy_id`),
  CONSTRAINT `praise_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `praise_ibfk_2` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of praise
-- ----------------------------
INSERT INTO `praise` VALUES ('1', '3', '1', '2025-04-29 17:06:29');

-- ----------------------------
-- Table structure for projectapply
-- ----------------------------
DROP TABLE IF EXISTS `projectapply`;
CREATE TABLE `projectapply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `project_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '未命名项目' COMMENT '项目名称',
  `apply_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `description` text COLLATE utf8mb4_unicode_ci,
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '申请内容',
  `time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `descr` text COLLATE utf8mb4_unicode_ci COMMENT '描述信息',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `projectapply_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of projectapply
-- ----------------------------
INSERT INTO `projectapply` VALUES ('2', '2', '未命名项目', '2025-04-27 16:46:22', '审核通过', null, '123', '2025-04-27 00:00:00', '123');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  `level` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account` double(255,0) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('2', '123', '123', '123', null, null, 'USER', '普通户', null, '298');
INSERT INTO `user` VALUES ('3', 'rgr', '123', 'rgr', null, null, 'USER', '贫困户', 'http://localhost:9090/files/1745917622337-报名照片.jpg', '36');
INSERT INTO `user` VALUES ('4', 'lfh123', '123', 'lfh123', null, null, 'USER', '普通户', null, null);
