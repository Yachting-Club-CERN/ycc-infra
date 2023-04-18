CREATE TABLE helpers_app_permissions (
    member_id  NUMBER NOT NULL,
    permission VARCHAR2(10) NOT NULL
);

ALTER TABLE helpers_app_permissions ADD CONSTRAINT helpers_app_permissions_pk PRIMARY KEY ( member_id );

ALTER TABLE helpers_app_permissions
    ADD CONSTRAINT helpers_app_permissions_member_fk FOREIGN KEY ( member_id )
        REFERENCES members ( id );

-- ADMIN: Unrestricted CRUD, including granting and revoking permissions
-- EDITOR: Can see unpublished tasks + mainstream editing options
ALTER TABLE helpers_app_permissions
    ADD CONSTRAINT helpers_app_permissions_check_permission CHECK (permission IN ('ADMIN', 'EDITOR'));
