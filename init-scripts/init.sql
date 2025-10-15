create database hivedb;
CREATE TABLE `hivedb`.`account` (
  account_uid BIGINT AUTO_INCREMENT PRIMARY KEY,
  hive_user_id VARCHAR(255) NOT NULL UNIQUE,
  hive_user_pw CHAR(64) NOT NULL,  -- SHA-256 �ؽ� ����� �׻� 64 ������ ���ڿ�
  create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  salt CHAR(64) NOT NULL
);
CREATE TABLE `hivedb`.`login_token` (
    hive_user_id VARCHAR(255) NOT NULL PRIMARY KEY,
    hive_token CHAR(64) NOT NULL,
    create_dt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_dt DATETIME NOT NULL
);

create database gamedb;
CREATE TABLE `gamedb`.`player_info` (
  player_uid BIGINT AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(255) NOT NULL UNIQUE,
  nickname VARCHAR(27),
  exp INT,
  level INT,
  win INT,
  lose INT,
  draw INT,
  create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE `gamedb`.`player_money` (
  player_uid BIGINT NOT NULL PRIMARY KEY COMMENT '�÷��̾� UID',
  game_money BIGINT DEFAULT 0,
  diamond BIGINT DEFAULT 0
);
CREATE TABLE `gamedb`.player_item (
	player_item_code BIGINT AUTO_INCREMENT PRIMARY KEY,
    	player_uid BIGINT NOT NULL COMMENT '�÷��̾� UID',
    	item_code INT NOT NULL COMMENT '������ ID',
    	item_cnt INT NOT NULL COMMENT '������ ��'
);
CREATE TABLE `gamedb`.mailbox (
  mail_id BIGINT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  content TEXT NOT NULL,
  item_code INT NOT NULL,
  item_cnt INT NOT NULL,
  send_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expire_dt TIMESTAMP NOT NULL,
  receive_dt TIMESTAMP NULL,
  receive_yn TINYINT NOT NULL DEFAULT 0 COMMENT '���� ����',
  player_uid BIGINT NOT NULL
);
CREATE TABLE `gamedb`.attendance (
    player_uid BIGINT NOT NULL PRIMARY KEY, 
    attendance_cnt INT NOT NULL COMMENT '�⼮ Ƚ��', 
    recent_attendance_dt DATETIME COMMENT '�ֱ� �⼮ �Ͻ�'
);
CREATE TABLE `gamedb`.friend (
    player_uid BIGINT NOT NULL COMMENT '�÷��̾� UID',
    friend_player_uid BIGINT NOT NULL COMMENT 'ģ�� UID',
    friend_player_nickname VARCHAR(27) NOT NULL COMMENT 'ģ�� �г���',
    create_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���� �Ͻ�',
    PRIMARY KEY (player_uid, friend_player_uid)
);
CREATE TABLE `gamedb`.friend_request (
    send_player_uid BIGINT NOT NULL COMMENT '�߼� �÷��̾� UID',
    receive_player_uid BIGINT NOT NULL COMMENT '���� �÷��̾� UID',
    send_player_nickname VARCHAR(27) NOT NULL COMMENT '�߼� �÷��̾� �г���',
    receive_player_nickname VARCHAR(27) NOT NULL COMMENT '���� �÷��̾� �г���',
    request_state TINYINT NOT NULL DEFAULT 0 COMMENT '��û ����(0:���, 1:����)',
    create_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���� �Ͻ�',
    PRIMARY KEY (send_player_uid, receive_player_uid)
);

USE masterdb;
CREATE TABLE IF NOT EXISTS `masterdb`.attendance_reward (
  day_seq INT,
  reward_item INT,
  item_count INT
);
INSERT INTO `masterdb`.attendance_reward (day_seq, reward_item, item_count) VALUES
(1, 1, 100), (2, 1, 100), (3, 1, 100), (4, 1, 100), (5, 1, 100), (6, 1, 100), (7, 1, 200), (8, 1, 200), (9, 1, 200), (10, 1, 200),
(11, 1, 200), (12, 2, 10), (13, 2, 10), (14, 2, 10), (15, 2, 10), (16, 2, 10), (17, 2, 10), (18, 2, 10), (19, 2, 10), (20, 2, 10),
(21, 2, 10), (22, 2, 10), (23, 2, 20), (24, 2, 20), (25, 2, 20), (26, 2, 20), (27, 2, 20), (28, 2, 20), (29, 2, 20), (30, 2, 20),
(31, 3, 1);

CREATE TABLE `masterdb`.item (
  item_code INT,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(128) NOT NULL,
  countable TINYINT NOT NULL COMMENT '��ĥ �� �ִ� ������ : 1'
);
INSERT INTO `masterdb`.item (item_code, name, description, countable) VALUES
(1, 'game_money', '���� �Ӵ�(�ΰ��� ��ȭ)', 1),
(2, 'diamond', '���̾Ƹ��(���� ��ȭ)', 1),
(3, '������ ������', '�ڽ��� ���ʿ� ���� ���� �� ����', 1),
(4, '�г��Ӻ���', '�⺻ �г��ӿ��� ������ �� ����', 1);

CREATE TABLE `masterdb`.first_item (
    item_code INT,
    count INT
  );
INSERT INTO `masterdb`.first_item (item_code, count) VALUES
(1, 1000),
(3, 1),
(4, 1);

CREATE TABLE `masterdb`.version (
    app_version VARCHAR(64),
    master_data_version VARCHAR(64)
  );
INSERT INTO `masterdb`.version (app_version, master_data_version) VALUES
('0.1.0', '0.1.0');
