USE `CardStorageManagement`;

--
-- https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_rand
--

-- DROP FUNCTION IF EXISTS `randrange`;

CREATE FUNCTION `randrange`(`i` INT, `j` INT) RETURNS INT NO SQL
    RETURN FLOOR((`j` - `i`) * RAND(UNIX_TIMESTAMP() + RAND()) + `i`);