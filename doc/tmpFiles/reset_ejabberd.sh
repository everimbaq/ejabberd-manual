# !/bin/bash
set -n
ejab_host = "matrix.innodealing.com"
innodealing_sql_dir = "/home/matrix/projects/database/innodealing.sql"
ejab_sql_dir = "/home/matrix/projects/ejabberd-matrix/sql/mysql.sql"
shibor_dir = "/home/matrix/scripts/prod_start_data_service.sh"
read -p "Are you sure to reset ejabberd@$ejab_host? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

#RUN=echo
RUN=

${RUN} ejabberdctl stop 


echo "wait for ejabber stop (10 sec) ..."
sleep 10


echo "========================================================================================="
echo "clear_mnesia"
${RUN} rm -rf /var/lib/ejabberd/*
echo "========================================================================================="


echo "========================================================================================="
echo "clear_mysql_database"
${RUN} mysql --user=innodealing --password=innodealing innodealing -e "drop database innodealing;"
echo "========================================================================================="


echo "========================================================================================="
echo "create_mysql_database"
#${RUN} mysql --user=innodealing --password=innodealing  -e "create database innodealing"
${RUN} mysql --user=innodealing --password=innodealing innodealing < $innodealing_sql_dir
${RUN} mysql --user=innodealing --password=innodealing innodealing < $ejab_sql_dir
echo "========================================================================================="


echo "========================================================================================="
echo "wait for ejabber start (5 sec)..."
${RUN} ejabberdctl start
sleep 5 
echo "========================================================================================="

echo "check ejabberd status"
while true
do
	${RUN} ejabberdctl status
	read -p "continue?"  -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]
			break
	else
			exit 1
	fi
done


echo "========================================================================================="
echo "register_system_users"
system_users=(
    admin shibor devman normalize admin_vcard devman_data
)
for user in ${dm_users[@]}; do
        echo "-------------------------------------------------------------------------------------------------------"
        ${RUN} ejabberdctl unregister ${user} $ejab_host    
        sleep 0.2
done;
		${RUN} ejabberdctl  register admin $ejab_host 275770e2c7d42c9629cadf431fdc3786
		${RUN} ejabberdctl  register shibor $ejab_host cacf5b57a4439a32bbde8e091561a243
		${RUN} ejabberdctl  register devman $ejab_host 58bb95b84d8c59915f954b3bec1a5b52
		${RUN} ejabberdctl  register normalize $ejab_host afe3c09bdb09afd284b8841830e36f5f
		${RUN} ejabberdctl  register admin_vcard $ejab_host 134571d239ae5ab5aea223a51bdb39a7
		${RUN} ejabberdctl  register devman_data $ejab_host 72826c54c6fed2e0c9bbd2ab86ab5662 
echo "========================================================================================="

echo "========================================================================================="
echo "start shibor"
$shibor_dir
echo "========================================================================================="