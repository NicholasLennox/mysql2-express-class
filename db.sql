-- Drop & Recreate Database
DROP DATABASE IF EXISTS utube_mini;
CREATE DATABASE utube_mini;
USE utube_mini;

-- Create Channels Table
CREATE TABLE channels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    channel_email VARCHAR(100) NOT NULL,
    channel_name VARCHAR(50) NOT NULL,
    -- Added soft delete flags
    is_deleted ENUM('true','false') DEFAULT 'false',
    deleted_at TIMESTAMP
);

-- Create Videos Table (Proper FK Reference)
CREATE TABLE videos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    video_title VARCHAR(100) NOT NULL,
    uploaded_by INT NOT NULL,
    views INT DEFAULT 0,
    FOREIGN KEY (uploaded_by) REFERENCES channels(id),
	CHECK (views > 0)
);

-- Create Comments Table (Proper FK Reference)
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commented_by INT NOT NULL,
    video INT NOT NULL,
    comment_text TEXT NOT NULL,
    FOREIGN KEY (commented_by) REFERENCES channels(id),
    FOREIGN KEY (video) REFERENCES videos(id)
);

-- Insert Channels
INSERT INTO channels (channel_email, channel_name) VALUES
('creator1@email.com', 'TechExplained'), 
('creator2@email.com', 'GamingZone'),  
('creator3@email.com', 'FoodieHub'),  
('creator4@email.com', 'MusicVibes'),  
('creator5@email.com', 'DailyVlogs');

-- Insert Videos
INSERT INTO videos (video_title, uploaded_by, views) VALUES
('How CPUs Work', 1, 50000),
('Epic Game Compilation', 2, 100000),
('Top 10 Cooking Tips', 3, 75000),
('Live Guitar Session', 4, 8800),
('A Day in Japan', 5, 32000),
('Gaming Review - Best RPGs', 2, 95000),
('How to Build a Gaming PC', 1, 67000);

-- Insert Comments
INSERT INTO comments (commented_by, video, comment_text) VALUES
(2, 1, 'This is super informative!'),
(1, 2, 'Nice gameplay, well edited!'),
(3, 3, 'Great cooking tips! I tried the third one and it was amazing.'),
(2, 5, 'Nice guitar solo! Do you have tutorials?'),
(3, 4, 'Love Japan vlogs! Keep them coming!'),
(4, 2, 'This RPG review is spot on!'),
(5, 1, 'Super helpful breakdown of CPUs. Thanks!'),
(3, 5, 'That PC build guide was very informative!'),
(1, 4, 'Beautiful video production on the Japan vlog.'),
(2, 3, 'Which cooking technique do you recommend for beginners?');

-- Stored procedures
DROP PROCEDURE IF EXISTS sp_get_videos_for_channel;
DELIMITER //
CREATE PROCEDURE sp_get_videos_for_channel(IN channel_id INT)
BEGIN
    SELECT id, video_title, views
	FROM videos
	WHERE uploaded_by = channel_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_insert_channel;
DELIMITER //
CREATE PROCEDURE sp_insert_channel(IN c_name VARCHAR(50), IN c_email VARCHAR(100))
BEGIN
    INSERT INTO channels (channel_name, channel_email) VALUES (c_name, c_email);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_update_channel;
DELIMITER //
CREATE PROCEDURE sp_update_channel(IN c_id INT, IN c_name VARCHAR(50), IN c_email VARCHAR(100))
BEGIN
    UPDATE channels SET channel_name = c_name, channel_email = c_email
    WHERE id = c_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_delete_channel;
DELIMITER //
CREATE PROCEDURE sp_delete_channel(IN c_id INT)
BEGIN
    UPDATE channels SET is_deleted = 'true', deleted_at = CURRENT_TIMESTAMP
    WHERE id = c_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_get_channel_stats;
DELIMITER //
CREATE PROCEDURE sp_get_channel_stats(IN c_id INT)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM utube_mini.videos WHERE uploaded_by = c_id) AS total_videos,
        (SELECT SUM(views) FROM utube_mini.videos WHERE uploaded_by = c_id) AS total_views,
        (SELECT COUNT(*) FROM utube_mini.comments WHERE commented_by = c_id) AS total_comments;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_search_channel;
DELIMITER //
CREATE PROCEDURE sp_search_channel(IN search_name VARCHAR(50))
BEGIN
    SELECT id, channel_name, channel_email
	FROM channels
	WHERE channel_name LIKE CONCAT('%', search_name, '%') -- mysql doesnt use + for concats.
    AND is_deleted = 'false';
END //
DELIMITER ;