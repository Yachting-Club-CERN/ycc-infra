-- Never use this on production DB
DROP TRIGGER helper_task_helpers_forbid_updates;
DROP TRIGGER helper_tasks_check_cannot_be_captain_if_already_helper;
DROP TRIGGER helper_task_helpers_check_cannot_be_helper_if_already_captain;
DROP TRIGGER helper_tasks_check_max_helper_count;
DROP TRIGGER helper_task_helpers_check_no_more_helpers_than_max_helper_count;

DROP TABLE helper_task_helpers;
DROP TABLE helper_tasks;
DROP TABLE helper_task_categories;
