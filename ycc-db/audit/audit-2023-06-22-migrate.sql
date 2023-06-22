ALTER TABLE audit_log RENAME COLUMN "DATE" TO created_at;
ALTER TABLE audit_log RENAME COLUMN "USER" TO principal;
