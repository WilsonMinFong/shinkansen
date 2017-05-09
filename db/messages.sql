CREATE TABLE messages (
  id INTEGER PRIMARY KEY,
  author VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  location VARCHAR(255)
);

INSERT INTO
  messages (id, author, body, location)
VALUES
  (1, "Washbob Hexpants", "I'm ugly and I'm proud!", "Trunks Top"),
  (2, "Dust Ketchup", "I wanna be the very best, that no one ever was.", "Palette Town"),
  (3, "Albert Humblecore", "We must all face the choice between what is right, and what is easy.", "Bogzits");
