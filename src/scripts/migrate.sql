CREATE TABLE `permission` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,

    UNIQUE INDEX `permission_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `role` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` ENUM('ADMINISTRATOR', 'MANAGER', 'WORKER') NOT NULL,
    `description` VARCHAR(64) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `grant` (
    `role_id` INTEGER NOT NULL,
    `permission_id` INTEGER NOT NULL,

    PRIMARY KEY (`role_id`, `permission_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `profile_picture` VARCHAR(255) NULL,
    `status` ENUM('ACTIVE', 'BANNED') NOT NULL DEFAULT 'ACTIVE',

    UNIQUE INDEX `user_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `task` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `status` VARCHAR(16) NOT NULL,
    `description` VARCHAR(512) NULL,
    `start_date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `due_date` TIMESTAMP NULL,
    `project_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `task_comment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `content` VARCHAR(1024) NOT NULL,
    `creation_date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `task_id` INTEGER NOT NULL,
    `author_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `attachment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `link` VARCHAR(64) NOT NULL,
    `fileType` VARCHAR(16) NOT NULL,
    `fileSize` INTEGER NOT NULL,
    `task_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `tag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(16) NOT NULL,
    `color` VARCHAR(16) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `tasks_tag` (
    `task_id` INTEGER NOT NULL,
    `tag_id` INTEGER NOT NULL,

    PRIMARY KEY (`task_id`, `tag_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `assignee` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `member_id` INTEGER NOT NULL,
    `task_id` INTEGER NOT NULL,

    UNIQUE INDEX `assignee_member_id_task_id_key`(`member_id`, `task_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `member` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `project_id` INTEGER NOT NULL,
    `role_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `project` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `description` VARCHAR(512) NULL,
    `creation_date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` ENUM('ACTIVE', 'INACTIVE') NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `grant` ADD CONSTRAINT `grant_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `role`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `grant` ADD CONSTRAINT `grant_permission_id_fkey` FOREIGN KEY (`permission_id`) REFERENCES `permission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `task` ADD CONSTRAINT `task_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `task_comment` ADD CONSTRAINT `task_comment_author_id_fkey` FOREIGN KEY (`author_id`) REFERENCES `member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `task_comment` ADD CONSTRAINT `task_comment_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `attachment` ADD CONSTRAINT `attachment_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `tasks_tag` ADD CONSTRAINT `tasks_tag_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `tasks_tag` ADD CONSTRAINT `tasks_tag_tag_id_fkey` FOREIGN KEY (`tag_id`) REFERENCES `tag`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `assignee` ADD CONSTRAINT `assignee_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `member`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `assignee` ADD CONSTRAINT `assignee_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `member` ADD CONSTRAINT `member_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `member` ADD CONSTRAINT `member_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `role`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `member` ADD CONSTRAINT `member_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
