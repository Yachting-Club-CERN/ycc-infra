--
-- Add note column to helpers_app_permissions
--
ALTER TABLE helpers_app_permissions ADD (
    note NVARCHAR2(200)
);

--
-- Migrate helper_task_categories to use NVARCHAR2/NCLOB
--

ALTER TABLE helper_task_categories MODIFY (
    title             NVARCHAR2(50),
    short_description NVARCHAR2(200)
);

ALTER TABLE helper_task_categories ADD (
    long_description_n NCLOB
);

UPDATE helper_task_categories SET
    long_description_n = long_description;
COMMIT;

ALTER TABLE helper_task_categories DROP (
    long_description
);
ALTER TABLE helper_task_categories RENAME COLUMN long_description_n TO long_description;

--
-- Migrate TABLE helper_tasks to use NVARCHAR2/NCLOB
--

ALTER TABLE helper_tasks MODIFY (
    title             NVARCHAR2(50),
    short_description NVARCHAR2(200)
);

ALTER TABLE helper_tasks ADD (
    long_description_n         NCLOB,
    marked_as_done_comment_n   NCLOB,
    validation_comment_n       NCLOB
);

UPDATE helper_tasks SET
    long_description_n       = long_description,
    marked_as_done_comment_n = marked_as_done_comment,
    validation_comment_n     = validation_comment;
COMMIT;

ALTER TABLE helper_tasks DROP (
    long_description,
    marked_as_done_comment,
    validation_comment
);

ALTER TABLE helper_tasks RENAME COLUMN long_description_n TO long_description;
ALTER TABLE helper_tasks RENAME COLUMN marked_as_done_comment_n TO marked_as_done_comment;
ALTER TABLE helper_tasks RENAME COLUMN validation_comment_n TO validation_comment;
