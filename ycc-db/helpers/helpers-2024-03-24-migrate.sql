ALTER TABLE helper_tasks ADD marked_as_done_at      DATE;
ALTER TABLE helper_tasks ADD marked_as_done_by_id   NUMBER;
ALTER TABLE helper_tasks ADD marked_as_done_comment CLOB;
ALTER TABLE helper_tasks ADD validated_at           DATE;
ALTER TABLE helper_tasks ADD validated_by_id        NUMBER;
ALTER TABLE helper_tasks ADD validation_comment     CLOB;

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_marked_as_done_by_fk FOREIGN KEY ( marked_as_done_by_id )
        REFERENCES members ( id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_validated_by_fk FOREIGN KEY ( validated_by_id )
        REFERENCES members ( id );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_marked_as_done_fields
        CHECK ( (marked_as_done_at IS     NULL AND marked_as_done_by_id IS     NULL)
             OR (marked_as_done_at IS NOT NULL AND marked_as_done_by_id IS NOT NULL) );

ALTER TABLE helper_tasks
    ADD CONSTRAINT helper_tasks_check_validated_fields
        CHECK ( (validated_at IS     NULL AND validated_by_id IS     NULL)
             OR (validated_at IS NOT NULL AND validated_by_id IS NOT NULL) );
