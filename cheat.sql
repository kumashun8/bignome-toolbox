-- インデックス追加(昇順)
ALTER TABLE `cheat` ADD INDEX `idx_cheat_1` (`user_id` ASC);

-- インデックス追加(降順)
ALTER TABLE `cheat` ADD INDEX `idx_cheat_2` (`user_id` DESC);

-- インデックス削除
ALTER TABLE `cheat` DROP INDEX `idx_cheat_1`;

-- インデックス追加(複合)
ALTER TABLE `cheat` ADD INDEX `idx_cheat_3` (`user_id` ASC, `cheat_id` ASC);

-- SPATIALインデックス追加
ALTER TABLE `cheat` ADD SPATIAL INDEX `idx_cheat_4` (`location`);

-- カラム追加
ALTER TABLE `cheat` ADD COLUMN `cheat_name` VARCHAR(255) NOT NULL;

-- カラム削除
ALTER TABLE `cheat` DROP COLUMN `cheat_name`;

-- カラム変更
ALTER TABLE `cheat` CHANGE COLUMN `cheat_price` `cheat_price` INT(11) NOT NULL DEFAULT '0';

-- 追加したカラムにデフォルト値を設定
ALTER TABLE `cheat` ALTER COLUMN `cheat_price` SET DEFAULT '0';

-- 既存のレコードのカラムの値を変更
UPDATE `cheat` SET `cheat_price` = 0 WHERE `cheat_price` IS NULL;

-- 既存のレコードのカラムの値を他のカラムの値を使って変更
UPDATE `cheat` SET `cheat_price` = `cheat_price` * 1.08;

-- 条件に合うレコードを削除
DELETE FROM `cheat` WHERE `cheat_price` = 0;

-- 条件に合うレコードを1件だけ残す
DELETE FROM `cheat` WHERE `cheat_id` NOT IN (SELECT `cheat_id` FROM `cheat` ORDER BY `cheat_id` DESC LIMIT 1);