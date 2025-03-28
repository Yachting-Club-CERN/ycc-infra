-- Simple audit log
--
-- This is a flexible, simple way of audit logging. It will be probably very
-- rare that we need it. The main advantage of this is solution is that there
-- is no need to maintain tables/triggers as the schema or the applications
-- change.

CREATE TABLE audit_log (
    id          NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    created_at  DATE DEFAULT SYSDATE NOT NULL,
    application NVARCHAR2(200) NOT NULL,
    principal   NVARCHAR2(200) NOT NULL,
    description NVARCHAR2(200) NOT NULL,
    data        NCLOB
);
