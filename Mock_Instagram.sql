# In this project I created a mock instagram schema. The queries below show my understanding of creating tables and linking tables with primary and foreign keys.


DROP DATABASE IF EXISTS instagram;
CREATE DATABASE ig_clone;
USE ig_clone; 

CREATE TABLE users (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photos (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(255) NOT NULL,
    photo_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE likes (
    user_id INTEGER NOT NULL,
    photo_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    PRIMARY KEY(user_id, photo_id)
);

CREATE TABLE follows (
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE tags (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags (
    photo_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);

# I then inserted thousands of rows of sample data into the tables. A snippet of the data can be seen here

INSERT INTO users (username, created_at) VALUES ('Kenton_Kirlin', '2017-02-16 18:22:10.846'), ('Andre_Purdy85', '2017-04-02 17:11:21.417'), ('Harley_Lind18', '2017-02-21 11:12:32.574'), ('Arely_Bogan63', '2016-08-13 01:28:43.085'), ('Aniya_Hackett', '2016-12-07 01:04:39.298'), ('Travon.Waters', '2017-04-30 13:26:14.496'), ('Kasandra_Homenick', '2016-12-12 06:50:07.996'), ('Tabitha_Schamberger11', '2016-08-20 02:19:45.512'), ('Gus93', '2016-06-24 19:36:30.978'), ('Presley_McClure', '2016-08-07 16:25:48.561'), ('Justina.Gaylord27', '2017-05-04 16:32:15.577')
INSERT INTO photos(image_url, user_id) VALUES ('http://elijah.biz', 1), ('https://shanon.org', 1), ('http://vicky.biz', 1), ('http://oleta.net', 1), ('https://jennings.biz', 1), ('https://quinn.biz', 2), ('https://selina.name', 2), ('http://malvina.org', 2), ('https://branson.biz', 2), ('https://elenor.name', 3), ('https://marcelino.com', 3), ('http://felicity.name', 3), ('https://fred.com', 3), ('https://gerhard.biz', 4), ('https://sherwood.net', 4), ('https://maudie.org', 4), ('http://annamae.name', 6), ('https://mac.org', 6), ('http://miracle.info', 6), ('http://emmet.com', 6), ('https://lisa.com', 6), ('https://brooklyn.name', 8), ('http://madison.net', 8), ('http://annie.name', 8), ('http://darron.info', 8)
INSERT INTO follows(follower_id, followee_id) VALUES (2, 1), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10), (2, 11), (2, 12), (2, 13), (2, 14), (2, 15), (2, 16), (2, 17), (2, 18), (2, 19), (2, 20), (2, 21), (2, 22), (2, 23), (2, 24), (2, 25), (2, 26), (2, 27), (2, 28), (2, 29), (2, 30), (2, 31), (2, 32), (2, 33), (2, 34), (2, 35), (2, 36), (2, 37), (2, 38), (2, 39), (2, 40), (2, 41), (2, 42), (2, 43), (2, 44), (2, 45), (2, 46), (2, 47), (2, 48), (2, 49), (2, 50), (2, 51), (2, 52), (2, 53), (2, 54), (2, 55), (2, 56), (2, 57), (2, 58), (2, 59)
INSERT INTO comments(comment_text, user_id, photo_id) VALUES ('unde at dolorem', 2, 1), ('quae ea ducimus', 3, 1), ('alias a voluptatum', 5, 1), ('facere suscipit sunt', 14, 1), ('totam eligendi quaerat', 17, 1), ('vitae quia aliquam', 21, 1), ('exercitationem occaecati neque', 24, 1), ('sint ad fugiat', 31, 1), ('nesciunt aut nesciunt', 36, 1), ('laudantium ut nostrum', 41, 1), ('omnis aut asperiores', 52, 1), ('et eum molestias', 54, 1), ('alias pariatur neque', 55, 1), ('amet iure adipisci', 57, 1), ('cum enim repellat', 62, 1), ('provident dolorem non'
INSERT INTO likes(user_id,photo_id) VALUES (2, 1), (5, 1), (9, 1), (10, 1), (11, 1), (14, 1), (19, 1), (21, 1), (24, 1), (35, 1), (36, 1), (41, 1), (46, 1), (47, 1), (54, 1), (55, 1), (57, 1), (66, 1), (69, 1), (71, 1), (75, 1), (76, 1), (78, 1), (82, 1), (91, 1), (3, 2), (5, 2), (6, 2), (8, 2), (14, 2), (17, 2), (19, 2), (21, 2), (24, 2), (26, 2), (27, 2), (30, 2), (31, 2), (33, 2), (36, 2), (38, 2), (40, 2), (41, 2), (44, 2), (52, 2), (54, 2), (56, 2), (57, 2), (62, 2), (63, 2), (66, 2), (71, 2), (75, 2), (76, 2), (82, 2), (87, 2), (91, 2), (92, 2), (94, 2)
INSERT INTO tags(tag_name) VALUES ('sunset'), ('photography'), ('sunrise'), ('landscape'), ('food'), ('foodie'), ('delicious'), ('beauty'), ('stunning'), ('dreamy'), ('lol'), ('happy'), ('fun'), ('style'), ('hair'), ('fashion'), ('party'), ('concert'), ('drunk'), ('beach'), ('smile')
INSERT INTO photo_tags(photo_id, tag_id) VALUES (1, 18), (1, 17), (1, 21), (1, 13), (1, 19), (2, 4), (2, 3), (2, 20), (2, 2), (3, 8), (4, 12), (4, 11), (4, 21), (4, 13), (5, 15), (5, 14), (5, 17), (5, 16), (6, 19), (6, 13), (6, 17), (6, 21), (7, 11), (7, 12), (7, 21), (7, 13), (8, 17), (8, 21), (8, 13), (8, 19), (9, 18), (10, 2), (11, 12), (11, 21), (11, 11), (12, 4), (13, 13), (13, 19), (14, 1), (14, 20), (17, 19), (17, 13), (17, 18), (19, 5), (21, 20), (21, 3), (21, 1), (21, 4), (22, 7), (22, 5), (22, 6), (23, 18), (23, 19), (23, 13), (23, 21), (24, 12)



# Here are some sample queries that show my understanding of aggregate functions, joins, subqueries, and aliasing. 


#Finding the 5 oldest users
SELECT * 
FROM users 
ORDER BY created_at
LIMIT 5;


#The most popular registration date
SELECT  DATE_FORMAT(created_at,'%W') AS day,
        COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;


#Identify inactive users (users with no photos)
SELECT  users.id,
        username
FROM users 
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE photos.id IS NULL;


#Identify the most popular photo and user who created it
SELECT  users.user_id,
        username,
        photos.id,
        photos.image_url,
        COUNT(*) AS total
FROM likes
INNER JOIN photos
    ON likes.photo_id = photos.id
INNER JOIN users 
    ON users.id = photos.user_id
GROUP BY photos.id
ORDER BY total DESC 
LIMIT 1;

#Calculate the average number of photos per user
SELECT (SELECT COUNT(*) 
        FROM photos) / (SELECT COUNT(*) 
                        FROM users) AS avg;


#Find the five most popular hashtags
 SELECT photo_tags.tag_id,
        tags.tag_name,
        COUNT(*) AS total
FROM photo_tags
INNER JOIN tags 
    ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC 
LIMIT 5;


#Find any bots (users who have liked every single photo)
SELECT  user_id,
        username,
        COUNT(*) AS total_likes
FROM users 
INNER JOIN likes 
    ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING total_likes = (SELECT COUNT(*)
                      FROM photos);
