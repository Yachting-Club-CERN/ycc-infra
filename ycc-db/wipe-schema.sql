-- WARNING: This script will drop all objects in the current schema.
--
-- Use only in test environments. NEVER run in production.

BEGIN
  -- Drop all constraints
  FOR c IN (
    SELECT constraint_name, table_name 
    FROM user_constraints 
    WHERE constraint_type = 'R'
  ) LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE "' || c.table_name || '" DROP CONSTRAINT "' || c.constraint_name || '"';
  END LOOP;

  -- Drop all triggers
  FOR trg IN (SELECT trigger_name FROM user_triggers) LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER "' || trg.trigger_name || '"';
  END LOOP;

  -- Drop all tables
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;

  -- Drop all views
  FOR v IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW "' || v.view_name || '"';
  END LOOP;

  -- Drop all sequences
  FOR s IN (
    SELECT sequence_name 
    FROM user_sequences 
    WHERE sequence_name NOT LIKE 'ISEQ$$_%'  -- Skip system-generated sequences
  ) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || s.sequence_name || '"';
  END LOOP;

  -- Drop all procedures
  FOR p IN (SELECT object_name FROM user_objects WHERE object_type = 'PROCEDURE') LOOP
    EXECUTE IMMEDIATE 'DROP PROCEDURE "' || p.object_name || '"';
  END LOOP;

  -- Drop all functions
  FOR f IN (SELECT object_name FROM user_objects WHERE object_type = 'FUNCTION') LOOP
    EXECUTE IMMEDIATE 'DROP FUNCTION "' || f.object_name || '"';
  END LOOP;

  -- Drop all packages
  FOR pkg IN (SELECT object_name FROM user_objects WHERE object_type = 'PACKAGE') LOOP
    EXECUTE IMMEDIATE 'DROP PACKAGE "' || pkg.object_name || '"';
  END LOOP;

  -- Drop all types
  FOR typ IN (SELECT type_name FROM user_types) LOOP
    EXECUTE IMMEDIATE 'DROP TYPE "' || typ.type_name || '" FORCE';
  END LOOP;

  -- Drop all synonyms
  FOR syn IN (SELECT synonym_name FROM user_synonyms) loop
    EXECUTE IMMEDIATE 'DROP SYNONYM "' || syn.synonym_name || '"';
  END LOOP;
END;
/
