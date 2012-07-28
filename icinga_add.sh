#!/bin/bash
 
# Variaveis do script
nagiosCurrent="/usr/local/icinga/etc/objects/hosts"
CloudStackBDHost="<IP>"
CloudStackDBUser="<user>"
CloudStackDBPass="<pass>"
CloudStackDBName="cloud.icinga_monit"
Query="select name,uuid,private_ip_address,state from $CloudStackDBName where state='Running' or state='Stopped'"
mysql=`/usr/bin/mysql -h $CloudStackBDHost -u $CloudStackDBUser -p$CloudStackDBPass -e "$Query"| wc -l`
 
cont="1"
 
while   [ "$cont" -le "$mysql" ]
do
 
        ls $nagiosCurrent/|grep -v '^abd' |xargs rm -f
        node_alias=`/usr/bin/mysql -h $CloudStackBDHost -u $CloudStackDBUser -p$CloudStackDBPass -e "$Query"|awk '{print $1}'|tail -$cont|head -1`
        node_name=`/usr/bin/mysql -h $CloudStackBDHost -u $CloudStackDBUser -p$CloudStackDBPass -e "$Query"|awk '{print $2}'|tail -$cont|head -1`
        node_ip=`/usr/bin/mysql -h $CloudStackBDHost -u $CloudStackDBUser -p$CloudStackDBPass -e "$Query"|awk '{print $3}'|tail -$cont|head -1`
 
 
        if [ ! -e $nagiosCurrent/${node_alias}.cfg ];
        then
                echo "define host{"                     >> $nagiosCurrent/${node_alias}.cfg
                echo "  use             linux-server"   >> $nagiosCurrent/${node_alias}.cfg
                echo "  host_name       ${node_name}"     >> $nagiosCurrent/${node_alias}.cfg
                echo "  alias           ${node_alias}"     >> $nagiosCurrent/${node_alias}.cfg
                echo "  address         ${node_ip}"     >> $nagiosCurrent/${node_alias}.cfg
                echo "  hostgroups      unix-local"   >> $nagiosCurrent/${node_alias}.cfg
                echo "}"                                >> $nagiosCurrent/${node_alias}.cfg
        fi
 
        cont=`expr $cont + 1`
done
