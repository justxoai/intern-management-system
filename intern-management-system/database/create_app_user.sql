-- Replace the placeholder before running this file.
-- This creates the least-privileged application account only when it is absent.
CREATE USER IF NOT EXISTS 'intern_app'@'localhost'
    IDENTIFIED BY 'REPLACE_WITH_A_STRONG_PASSWORD';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON internship_management.* TO 'intern_app'@'localhost';

FLUSH PRIVILEGES;
