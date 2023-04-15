-- Simple audit log
--
-- This is a flexible, simple way of audit logging. It will be probably very
-- rare that we need it. The main advantage of this is solution is that there
-- is no need to maintain tables/triggers as the schema or the applications
-- change.

CREATE TABLE audit_log (
    id                NUMBER GENERATED ALWAYS AS IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    "DATE"            DATE DEFAULT SYSDATE NOT NULL,
    application       VARCHAR2(200) NOT NULL,
    "USER"            VARCHAR2(200) NOT NULL,
    short_description VARCHAR2(200) NOT NULL,
    long_description  CLOB
);
