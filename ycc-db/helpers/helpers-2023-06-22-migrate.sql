ALTER TABLE helper_tasks RENAME COLUMN "START" TO starts_at;
ALTER TABLE helper_tasks RENAME COLUMN end TO ends_at;
ALTER TABLE helper_tasks RENAME COLUMN helpers_min_count TO helper_min_count;
ALTER TABLE helper_tasks RENAME COLUMN helpers_max_count TO helper_max_count;
ALTER TABLE helper_tasks RENAME COLUMN captain_subscribed_at TO captain_signed_up_at;
ALTER TABLE helper_tasks RENAME CONSTRAINT helper_tasks_check_helpers_min_max_count TO helper_tasks_check_helper_min_max_count;

ALTER TABLE helper_task_helpers RENAME COLUMN subscribed_at TO signed_up_at;

-- This time you also need to redo all triggers

CREATE OR REPLACE TRIGGER helper_task_helpers_forbid_updates
BEFORE UPDATE ON helper_task_helpers
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'Updates to helper_task_helpers are not allowed - try deleting and re-inserting');
END;
/

-- CHECK using TRIGGER: Captain cannot be helper (and vica versa) for the same task

CREATE OR REPLACE TRIGGER helper_tasks_check_cannot_be_captain_if_already_helper
BEFORE INSERT OR UPDATE OF captain_id ON helper_tasks
FOR EACH ROW
DECLARE
    v_helper_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_helper_count
    FROM helper_task_helpers
    WHERE task_id   = :NEW.id
      AND member_id = :NEW.captain_id;

    IF v_helper_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be captain because they are also a helper for the same task');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER helper_task_helpers_check_cannot_be_helper_if_already_captain
BEFORE INSERT OR UPDATE OF task_id, member_id ON helper_task_helpers
FOR EACH ROW
DECLARE
    v_captain_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_captain_count
    FROM helper_tasks
    WHERE id         = :NEW.task_id
      AND captain_id = :NEW.member_id;

    IF v_captain_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be helper because they are also a captain for the same task');
    END IF;
END;
/

-- CHECK using TRIGGER: Respect max helper counts

CREATE OR REPLACE TRIGGER helper_tasks_check_max_helper_count
BEFORE UPDATE OF helper_max_count ON helper_tasks
FOR EACH ROW
DECLARE
    v_helper_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_helper_count
    FROM helper_task_helpers
    WHERE task_id = :NEW.id;

    IF :NEW.helper_max_count < v_helper_count THEN
        RAISE_APPLICATION_ERROR(-20000, 'The maximum number of helpers cannot be reduced below the current number of signed up helpers');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER helper_task_helpers_check_no_more_helpers_than_max_helper_count
BEFORE INSERT ON helper_task_helpers
FOR EACH ROW
DECLARE
    v_helper_count NUMBER;
    v_max_helper_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_helper_count
    FROM helper_task_helpers
    WHERE task_id = :NEW.task_id;

    SELECT helper_max_count INTO v_max_helper_count
    FROM helper_tasks
    WHERE id = :NEW.task_id;

    IF v_helper_count >= v_max_helper_count THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be helper because there are already enough helpers for the task');
    END IF;
END;
/
