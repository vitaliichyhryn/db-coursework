-- Insert permissions
INSERT INTO permission (`name`)
VALUES
  ('CREATE_PROJECT'),
  ('UPDATE_PROJECT'),
  ('DELETE_PROJECT'),
  ('CREATE_TASK'),
  ('UPDATE_TASK'),
  ('DELETE_TASK'),
  ('CREATE_COMMENT'),
  ('UPDATE_COMMENT'),
  ('DELETE_COMMENT'),
  ('CREATE_MEMBER'),
  ('UPDATE_MEMBER'),
  ('DELETE_MEMBER'),
  ('BAN_USER'),
  ('UNBAN_USER');

-- Insert roles
INSERT INTO role (`name`, `description`)
VALUES
  ('ADMINISTRATOR', 'Has full access'),
  ('MANAGER', 'Manages projects and teams'),
  ('WORKER', 'Works on tasks');

-- Insert grants
INSERT INTO `grant` (`role_id`, `permission_id`)
VALUES
-- Grants for administrator
  (1, 1),  -- CREATE_PROJECT
  (1, 2),  -- UPDATE_PROJECT
  (1, 3),  -- DELETE_PROJECTgrant
  (1, 4),  -- CREATE_TASK
  (1, 5),  -- UPDATE_TASK
  (1, 6),  -- DELETE_TASK
  (1, 7),  -- CREATE_COMMENT
  (1, 8),  -- UPDATE_COMMENT
  (1, 9),  -- DELETE_COMMENT
  (1, 10), -- CREATE_MEMBER
  (1, 11), -- UPDATE_MEMBER
  (1, 12), -- DELETE_MEMBER
  (1, 13), -- BAN_USER
  (1, 14), -- UNBAN_USER

-- Grants for manager
  (2, 2),  -- UPDATE_PROJECT
  (2, 4),  -- CREATE_TASK
  (2, 5),  -- UPDATE_TASK
  (2, 6),  -- DELETE_TASK
  (2, 7),  -- CREATE_COMMENT
  (2, 8),  -- UPDATE_COMMENT
  (2, 9),  -- DELETE_COMMENT
  (2, 10), -- CREATE_MEMBER
  (2, 11), -- UPDATE_MEMBER
  (2, 12), -- DELETE_MEMBER

-- Grants for worker
  (3, 5),  -- UPDATE_TASK
  (3, 6),  -- DELETE_TASK
  (3, 7),  -- CREATE_COMMENT
  (3, 8),  -- UPDATE_COMMENT
  (3, 9);  -- DELETE_COMMENT

-- Insert users
INSERT INTO user (`name`, `email`, `password`, `profile_picture`, `status`)
VALUES
  ('Ivan Shevchenko', 'ivan.shevchenko@example.com', 'hashed_password_1', 'https://example.com/profile1.jpg', 'ACTIVE'),
  ('Olga Ivanova', 'olga.ivanova@example.com', 'hashed_password_2', 'https://example.com/profile2.jpg', 'ACTIVE'),
  ('Natalia Kovalenko', 'natalia.kovalenko@example.com', 'hashed_password_3', NULL, 'ACTIVE'),
  ('Mykola Petrov', 'mykola.petrov@example.com', 'hashed_password_4', 'https://example.com/profile4.jpg', 'ACTIVE'),
  ('Daryna Tarasenko', 'daryna.tarasenko@example.com', 'hashed_password_5', 'https://example.com/profile5.jpg', 'ACTIVE');

-- Insert Project
INSERT INTO project (`name`, `description`, `creation_date`, `status`)
VALUES
  ('Project Alpha', 'A description for Project Alpha', '2024-11-01 00:00:00', 'ACTIVE');

-- Insert members
INSERT INTO member (`user_id`, `project_id`, `role_id`)
VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 3),
  (4, 1, 3),
  (5, 1, 3);

-- Insert tasks
INSERT INTO task (`name`, `status`, `description`, `start_date`, `due_date`, `project_id`)
VALUES
  ('Task 1', 'OPEN', 'Task 1 description', '2024-11-01 09:00:00', '2024-11-10 18:00:00', 1);

-- Insert task comments
INSERT INTO task_comment (`content`, `creation_date`, `task_id`, `author_id`)
VALUES
  ('This is the first comment on Task 1', '2024-11-01 10:00:00', 1, 1);

-- Insert tags
INSERT INTO tag (`name`, `color`)
VALUES
  ('Backend', '#FF5733'),   -- Red
  ('Frontend', '#33C1FF'),  -- Blue
  ('Testing', '#FF9800');   -- Orange

-- Insert task tags
INSERT INTO tasks_tag (`task_id`, `tag_id`)
VALUES
  (1, 1);  -- Task 1 tagged with Backend

-- Insert assignees
INSERT INTO assignee (`member_id`, `task_id`)
VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 1),
  (5, 1);
