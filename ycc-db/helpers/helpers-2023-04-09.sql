-- If you need the SQL Developer Data Modeler files, just ask Lajos

CREATE TABLE helper_task_categories (
    id                NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    title             VARCHAR2(50) NOT NULL,
    short_description VARCHAR2(200) NOT NULL,
    long_description  CLOB
);

ALTER TABLE helper_task_categories ADD CONSTRAINT helper_task_categories_pk PRIMARY KEY ( id );

CREATE TABLE helper_tasks (
    -- In Sachsa's system there are 1885 entries as of 2023-04-05, keep a cosy for migration
    id                               NUMBER GENERATED ALWAYS as IDENTITY(START with 3000 INCREMENT by 1) NOT NULL,
    category_id                      NUMBER NOT NULL,
    title                            VARCHAR2(50) NOT NULL,
    short_description                VARCHAR2(200) NOT NULL,
    long_description                 CLOB,
    contact_id                       NUMBER NOT NULL,
    "START"                          DATE,
    end                              DATE,
    deadline                         DATE,
    urgent                           NUMBER(1) NOT NULL,
    captain_required_licence_info_id NUMBER,
    helpers_min_count                NUMBER NOT NULL,
    helpers_max_count                NUMBER NOT NULL,
    published                        NUMBER(1) NOT NULL,
    captain_id                       NUMBER,
    captain_subscribed_at            DATE
);

ALTER TABLE helper_tasks ADD CONSTRAINT helper_tasks_pk PRIMARY KEY ( id );

CREATE TABLE helper_task_helpers (
    task_id       NUMBER NOT NULL,
    member_id     NUMBER NOT NULL,
    subscribed_at DATE NOT NULL
);

ALTER TABLE helper_task_helpers ADD CONSTRAINT helper_task_helpers_pk PRIMARY KEY ( task_id,
                                                                                    member_id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_category_fk FOREIGN KEY ( category_id )
        REFERENCES helper_task_categories ( id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_contact_fk FOREIGN KEY ( contact_id )
        REFERENCES members ( id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_captain_fk FOREIGN KEY ( captain_id )
        REFERENCES members ( id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_captain_required_licence_info_fk FOREIGN KEY ( captain_required_licence_info_id )
        REFERENCES infolicences ( infoid );

ALTER TABLE helper_task_helpers
    ADD CONSTRAINT helper_task_helpers_task_fk FOREIGN KEY ( task_id )
        REFERENCES helper_tasks ( id );

ALTER TABLE helper_task_helpers
    ADD CONSTRAINT helper_task_helpers_member_fk FOREIGN KEY ( member_id )
        REFERENCES members ( id );

--
-- CHECK constraints
--

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_timing
    CHECK ( ( "START" IS NOT NULL AND end IS NOT NULL AND deadline IS     NULL and "START" < end )
         OR ( "START" IS     NULL AND end IS     NULL AND deadline IS NOT NULL) );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_captain_fields
    CHECK ( ( captain_id IS     NULL AND captain_subscribed_at IS     NULL )
         OR ( captain_id IS NOT NULL AND captain_subscribed_at IS NOT NULL ) );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_helpers_min_max_count
    CHECK (helpers_min_count <= helpers_max_count);

-- This simplifies a lot, also the application works in subscribe/unsubscribe mode. During "task exchange" one can run a transaction with one DELETE and one INSERT.
CREATE OR REPLACE TRIGGER helper_task_helpers_forbid_updates
BEFORE UPDATE ON helper_task_helpers
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'Updates to helper_task_helpers are not allowed - try deleting and re-inserting');
END;

-- CHECK captain cannot be helper (and vica versa) for the same task

CREATE OR REPLACE TRIGGER helper_tasks_check_cannot_be_captain_if_already_helper
BEFORE INSERT OR UPDATE OF captain_id ON helper_tasks
FOR EACH ROW
DECLARE
    v_helper_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_helper_count
    FROM helper_task_helpers
    WHERE task_id = :NEW.id
      AND member_id = :NEW.captain_id;

    IF v_helper_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be captain because they are also a helper for the same task');
    END IF;
END;

CREATE OR REPLACE TRIGGER helper_tasks_check_cannot_be_helper_if_already_captain
BEFORE INSERT OR UPDATE OF task_id, member_id ON helper_task_helpers
FOR EACH ROW
DECLARE
    v_captain_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_captain_count
    FROM helper_tasks
    WHERE id = :NEW.task_id
      AND captain_id = :NEW.member_id;

    IF v_captain_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be helper because they are also a captain for the same task');
    END IF;
END;

-- CHECK Respect max helper counts

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

    SELECT helpers_max_count INTO v_max_helper_count
    FROM helper_tasks
    WHERE id = :NEW.task_id;

    IF v_helper_count > v_max_helper_count THEN
        RAISE_APPLICATION_ERROR(-20000, 'Member cannot be helper because there are already enough helpers for the task');
    END IF;
END;

CREATE OR REPLACE TRIGGER helper_tasks_check_min_helper_count
BEFORE UPDATE OF helpers_max_count ON helper_tasks
FOR EACH ROW
DECLARE
    v_helper_count NUMBER;
BEGIN
    -- Get the number of subscribed helpers for the task
    SELECT COUNT(*)
    INTO v_helper_count
    FROM helper_task_helpers
    WHERE task_id = :NEW.id;

    -- Check if the new helpers_max_count value is less than the current number of subscribed helpers
    IF :NEW.helpers_max_count < v_helper_count THEN
        RAISE_APPLICATION_ERROR(-20000, 'The maximum number of helpers cannot be reduced below the current number of subscribed helpers');
    END IF;
END;

-- Backend service checks:
-- - A captain should be an active member for the season when they are subscribing
-- - A captain should have an active licence (if required) when they are subscribing (licence can become inactive later)
-- - A helper should be an active member for the season when they are subscribing
