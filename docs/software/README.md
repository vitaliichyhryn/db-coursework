# Реалізація інформаційного та програмного забезпечення

## SQL-скрипт для створення початкового наповнення бази даних

_migrate.sql_

```sql
-- CreateTable
CREATE TABLE `Permission` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,

    UNIQUE INDEX `Permission_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Role` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` ENUM('ADMINISTRATOR', 'MANAGER', 'WORKER') NOT NULL,
    `description` VARCHAR(64) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Grant` (
    `roleId` INTEGER NOT NULL,
    `permissionId` INTEGER NOT NULL,

    PRIMARY KEY (`roleId`, `permissionId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `profilePicture` VARCHAR(255) NULL,
    `status` ENUM('BANNED', 'NOT_BANNED') NOT NULL DEFAULT 'NOT_BANNED',

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Task` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `status` VARCHAR(16) NOT NULL,
    `description` VARCHAR(512) NULL,
    `startDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dueDate` TIMESTAMP NULL,
    `projectId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TaskComment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `content` VARCHAR(1024) NOT NULL,
    `creationDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `taskId` INTEGER NOT NULL,
    `authorId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Attachment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `link` VARCHAR(64) NOT NULL,
    `fileType` VARCHAR(16) NOT NULL,
    `fileSize` INTEGER NOT NULL,
    `taskId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Tag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(16) NOT NULL,
    `color` VARCHAR(16) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TasksTag` (
    `taskId` INTEGER NOT NULL,
    `tagId` INTEGER NOT NULL,

    PRIMARY KEY (`taskId`, `tagId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Assignee` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `memberId` INTEGER NOT NULL,
    `taskId` INTEGER NOT NULL,

    UNIQUE INDEX `Assignee_memberId_taskId_key`(`memberId`, `taskId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Member` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NOT NULL,
    `projectId` INTEGER NOT NULL,
    `roleId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Project` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `description` VARCHAR(512) NULL,
    `creationDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` ENUM('ACTIVE', 'INACTIVE') NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Grant` ADD CONSTRAINT `Grant_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `Role`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Grant` ADD CONSTRAINT `Grant_permissionId_fkey` FOREIGN KEY (`permissionId`) REFERENCES `Permission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Task` ADD CONSTRAINT `Task_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `Project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TaskComment` ADD CONSTRAINT `TaskComment_authorId_fkey` FOREIGN KEY (`authorId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TaskComment` ADD CONSTRAINT `TaskComment_taskId_fkey` FOREIGN KEY (`taskId`) REFERENCES `Task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Attachment` ADD CONSTRAINT `Attachment_taskId_fkey` FOREIGN KEY (`taskId`) REFERENCES `Task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TasksTag` ADD CONSTRAINT `TasksTag_taskId_fkey` FOREIGN KEY (`taskId`) REFERENCES `Task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TasksTag` ADD CONSTRAINT `TasksTag_tagId_fkey` FOREIGN KEY (`tagId`) REFERENCES `Tag`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Assignee` ADD CONSTRAINT `Assignee_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Assignee` ADD CONSTRAINT `Assignee_taskId_fkey` FOREIGN KEY (`taskId`) REFERENCES `Task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Member` ADD CONSTRAINT `Member_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Member` ADD CONSTRAINT `Member_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `Role`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Member` ADD CONSTRAINT `Member_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `Project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
```

_seed.sql_

```sql

-- Insert Permissions
INSERT INTO Permission (`name`)
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

-- Insert Roles
INSERT INTO Role (`name`, `description`)
VALUES
  ('ADMINISTRATOR', 'Has full access'),
  ('MANAGER', 'Manages projects and teams'),
  ('WORKER', 'Works on tasks');

-- Insert Grants
INSERT INTO `grant` (roleId, permissionId)
VALUES
-- Grants for Administrator
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

-- Grants for Manager
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

-- Grants for Worker
  (3, 5),  -- UPDATE_TASK
  (3, 6),  -- DELETE_TASK
  (3, 7),  -- CREATE_COMMENT
  (3, 8),  -- UPDATE_COMMENT
  (3, 9);  -- DELETE_COMMENT

-- Insert Users
INSERT INTO User (`name`, `email`, `password`, `profilePicture`, `status`)
VALUES
  ('Ivan Shevchenko', 'ivan.shevchenko@example.com', 'hashed_password_1', 'https://example.com/profile1.jpg', 'NOT_BANNED'),
  ('Olga Ivanova', 'olga.ivanova@example.com', 'hashed_password_2', 'https://example.com/profile2.jpg', 'NOT_BANNED'),
  ('Natalia Kovalenko', 'natalia.kovalenko@example.com', 'hashed_password_3', NULL, 'NOT_BANNED'),
  ('Mykola Petrov', 'mykola.petrov@example.com', 'hashed_password_4', 'https://example.com/profile4.jpg', 'NOT_BANNED'),
  ('Daryna Tarasenko', 'daryna.tarasenko@example.com', 'hashed_password_5', 'https://example.com/profile5.jpg', 'NOT_BANNED');

-- Insert Project
INSERT INTO Project (`name`, `description`, `creationDate`, `status`)
VALUES
  ('Project Alpha', 'A description for Project Alpha', '2024-11-01 00:00:00', 'ACTIVE');

-- Insert Members
INSERT INTO Member (`userId`, `projectId`, `roleId`)
VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 3),
  (4, 1, 3),
  (5, 1, 3);

-- Insert Tasks
INSERT INTO Task (`name`, `status`, `description`, `startDate`, `dueDate`, `projectId`)
VALUES
  ('Task 1', 'OPEN', 'Task 1 description', '2024-11-01 09:00:00', '2024-11-10 18:00:00', 1);

-- Insert Task Comments
INSERT INTO TaskComment (`content`, `creationDate`, `taskId`, `authorId`)
VALUES
  ('This is the first comment on Task 1', '2024-11-01 10:00:00', 1, 1);

-- Insert Tags
INSERT INTO Tag (`name`, `color`)
VALUES
  ('Backend', '#FF5733'),   -- Red
  ('Frontend', '#33C1FF'),  -- Blue
  ('Testing', '#FF9800');   -- Orange

-- Insert Task Tags
INSERT INTO TasksTag (`taskId`, `tagId`)
VALUES
  (1, 1);  -- Task 1 tagged with Backend

-- Insert Assignees
INSERT INTO Assignee (`memberId`, `taskId`)
VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 1),
  (5, 1);
```

## RESTfull сервіс для управління даними