CREATE TABLE restaurant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    street_address VARCHAR(255),
    description TEXT
);

CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    restaurant_id INTEGER REFERENCES restaurant(id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    rating INTEGER CHECK (rating >=1 AND rating <=5),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO restaurant (name, street_address, description) VALUES
('Warung Nasi Kucing Terbang 404', 'Jl. Server Down No. 502', 'Nasi uduk misterius'),
('Kopi Paste & Bug', 'Jl. Syntax Error No. 99', 'Kafe spesialis kopi tubruk anti ngantuk'),
('Bakso Rudal Anti Galau', 'Jl. Kemanggisan Raya No. 101', 'Bakso urat kuah kaldu level pedas netizen');

SELECT * FROM restaurant

INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date) VALUES
(1, 'Fakhri Raihan', 5, 'Nasi kucingnya beneran bikin kenyang', '2026-11-20'),
(1, 'John', 3, 'Enak sih, tapi kayak kurang iphone duo', '2026-11-21'),
(2, 'Ternus', 5, 'Sekali seruput kopinya langsung mantab', '2026-11-21'),
(3, 'Jensen', 4, 'Baksonya gede banget kayak harga GPU', '2026-11-22'),
(3, 'Huang', 5, 'Kuah pedasnya bikin agen china ketar ketir', '2026-11-22');

SELECT * FROM review


INSERT INTO restaurant (name, street_address, description) VALUES
('Sate Taichan Senayan', 'Jl. Senayan', 'Sate satean lah pokoknya');


INSERT INTO review (restaurant_id, user_name, rating, review_text, review_date) VALUES
(4, 'elon musk', 5, 'dagingnya juicy luicy mahalini riski febian!', '2026-11-22');


SELECT * FROM review WHERE restaurant_id = 1;


SELECT * FROM review WHERE rating >= 4;


SELECT 
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    rev.user_name,
    rev.rating,
    rev.review_text,
    rev.review_date
FROM restaurant r
JOIN review rev ON r.id = rev.restaurant_id;


-- 3. Update

UPDATE restaurant 
SET description = 'Nasi uduk racing, cepat habis'
WHERE id = 1;


UPDATE review 
SET rating = 5 
WHERE id = 2;

-- 4. Delete

DELETE FROM review WHERE id = 5;


DELETE FROM restaurant WHERE id = 4;








-- 1. Mencari restoran dengan rata-rata rating tertinggi
SELECT 
    r.id,
    r.name,
    ROUND(AVG(rev.rating), 2) AS average_rating
FROM restaurant r
JOIN review rev ON r.id = rev.restaurant_id
GROUP BY r.id, r.name
ORDER BY average_rating DESC
LIMIT 1;



-- 2. Menghitung jumlah review yang diterima masing-masing restoran
SELECT 
    r.id,
    r.name,
    COUNT(rev.id) AS total_reviews
FROM restaurant r
LEFT JOIN review rev ON r.id = rev.restaurant_id
GROUP BY r.id, r.name
ORDER BY total_reviews DESC;



-- 3. Menampilkan review terbaru dari masing-masing restoran
SELECT DISTINCT ON (r.id)
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    rev.user_name,
    rev.rating,
    rev.review_text,
    rev.review_date
FROM restaurant r
JOIN review rev ON r.id = rev.restaurant_id
ORDER BY r.id, rev.review_date DESC, rev.id DESC;


CREATE TABLE menu (
    id SERIAL PRIMARY KEY,
    restaurant_id INTEGER REFERENCES restaurant(id) ON DELETE CASCADE,
    item_name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);



INSERT INTO menu (restaurant_id, item_name, price) VALUES
-- Menu resto 1
(1, 'Nasi uduk Sapi', 35000),
(1, 'Ayam Spesial', 30000),
(1, 'Teh manis', 15000),
-- Menu resto 2
(2, 'Es Kopi Susu Gula Aren', 22000),
(2, 'Almond Croissant', 28000),
(2, 'Matcha Latte', 25000),
-- Menu resto 3
(3, 'Bakso Komplit', 27000),
(3, 'Pangsit Rebus Kuah', 18000),
(3, 'Es Jeruk Murni', 12000);



SELECT 
    r.name AS restaurant_name,
    m.item_name AS menu_item,
    m.price,
    COALESCE(ROUND(rev_avg.average_rating, 2), 0) AS average_rating
FROM restaurant r
LEFT JOIN menu m ON r.id = m.restaurant_id
LEFT JOIN (
    SELECT restaurant_id, AVG(rating) AS average_rating
    FROM review
    GROUP BY restaurant_id
) rev_avg ON r.id = rev_avg.restaurant_id
ORDER BY r.id, m.id;
