CREATE TABLE helper_task_categories (
    id                NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    title             VARCHAR2(50) NOT NULL,
    short_description VARCHAR2(200) NOT NULL,
    long_description  CLOB
);

ALTER TABLE helper_task_categories ADD CONSTRAINT helper_task_categories_pk PRIMARY KEY ( id );

CREATE TABLE helper_tasks (
    -- In Sachsa's system there are 1885 entries as of 2023-04-05, keep a cosy for migration
    id                               NUMBER GENERATED ALWAYS AS IDENTITY(START with 3000 INCREMENT by 1) NOT NULL,
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
        CHECK ( ( "START" IS NOT NULL AND end IS NOT NULL AND deadline IS     NULL)
             OR ( "START" IS     NULL AND end IS     NULL AND deadline IS NOT NULL) );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_captain_fields
        CHECK ( ( captain_id IS     NULL AND captain_subscribed_at IS     NULL )
             OR ( captain_id IS NOT NULL AND captain_subscribed_at IS NOT NULL ) );
