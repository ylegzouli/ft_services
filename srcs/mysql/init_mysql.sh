#! /bin/bash

# Wait that mysql was up
until mysql
do
	echo "NO_UP"
done

# Init DB
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "CREATE USER 'root'@'%' IDENTIFIED BY 'root';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'%' WITH GRANT OPTION;" | mysql -u root --skip-password
#echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
#echo "DROP DATABASE test" | mysql -u root --skip-password
#echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
mysql wordpress -u root --password=  < wordpress_target.sql



if [ ! -d /app/mysql/mysql ]
then
    echo Creating initial database...
    mysql_install_db --user=root > /dev/null
    echo Done!
fi

if [ ! -d /run/mysqld ]
then
    mkdir -p /run/mysqld
fi

tfile=`mktemp`
if [ ! -f "$tfile" ]
then
    echo Cannot create temp file!
    exit 1
fi

echo Root password is $MYSQL_ROOT_PASSWORD

cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO "$MYSQL_ROOT"@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
EOF

echo Bootstraping...
if ! /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
then
    echo Cannot bootstrap mysql!
    exit 1
fi
rm -f $tfile
echo Bootstraping done!

echo Launching mysql server!
