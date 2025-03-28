--
-- Migrate TABLE audit_log to use NVARCHAR2/NCLOB
--

ALTER TABLE audit_log MODIFY (
    application NVARCHAR2(200),
    principal   NVARCHAR2(200),
    description NVARCHAR2(200)
);

ALTER TABLE audit_log ADD (
    data_n NCLOB
);

UPDATE audit_log SET data_n = data;
COMMIT;

ALTER TABLE audit_log DROP COLUMN data;
ALTER TABLE audit_log RENAME COLUMN data_n TO data;
