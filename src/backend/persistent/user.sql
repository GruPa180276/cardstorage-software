CREATE USER IF NOT EXISTS 'remote'@'localhost' IDENTIFIED BY 'remote';

GRANT ALL PRIVILEGES ON *.* TO 'remote'@'localhost';

FLUSH PRIVILEGES;

# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
#
# FLUSH PRIVILEGES;
