INSERT INTO brain_rot (id, name, url) VALUES
(1, 'Bombardiro Crocodilo', 'https://www.youtube.com/watch?v=v6DqxQDldnk'),
(2, 'Tralalero Tralala', 'https://www.youtube.com/watch?v=fFN3_p0E_8w'),
(3, 'Tung Tung Tung Sahur', 'https://www.youtube.com/watch?v=RuTQ9wE-cD8');

SELECT setval('brain_rot_id_seq', (SELECT MAX(id) FROM brain_rot));