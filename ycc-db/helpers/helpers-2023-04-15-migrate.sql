CREATE TABLE helpers_app_permissions (
    member_id  NUMBER NOT NULL,
    permission VARCHAR2(10) NOT NULL
);

ALTER TABLE helpers_app_permissions ADD CONSTRAINT helpers_app_permissions_pk PRIMARY KEY ( member_id );

ALTER TABLE helpers_app_permissions
    ADD CONSTRAINT helpers_app_permissions_member_fk FOREIGN KEY ( member_id )
        REFERENCES members ( id );

-- ADMIN: unrestricted CRUD, including granting and revoking permissions
-- EDITOR: can see unpublished tasks, can create tasks (becomes contact), can edit and delete tasks if contact (including adding/removing helpers)
ALTER TABLE helpers_app_permissions
    ADD CONSTRAINT helpers_app_permissions_check_permission CHECK (permission IN ('ADMIN', 'EDITOR'));
