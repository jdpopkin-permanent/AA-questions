CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  reply TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id), --NOT NULL,
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
  ---likes INTEGER
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Colin', 'MacKenzie'), ('Jackson','Popkin');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Lunch',"What's for lunch?", 1);

INSERT INTO
  question_followers(user_id, question_id)
VALUES
  (2, 1);

INSERT INTO
  replies(reply, question_id, user_id)
VALUES
  ("I don't know", 1, 2);

INSERT INTO
  replies(reply, question_id, reply_id, user_id)
VALUES
  ("Really", 1, 1, 1);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1);
