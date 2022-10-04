-- set `bind-address` in /etc/mysql/mysql.conf.d/mysqld.cnf && systemctl restart mysql

-- USE `CardStorageManagement`;


CREATE USER IF NOT EXISTS 'remote'@'localhost' IDENTIFIED BY 'remote';

GRANT ALL PRIVILEGES ON *.* TO 'remote'@'localhost';

FLUSH PRIVILEGES;