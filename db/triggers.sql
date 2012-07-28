DELIMITER ;;
BEFORE INSERT ON `vm_instance` FOR EACH ROW BEGIN
   delete from cloud.icinga_monit;
   insert into cloud.icinga_monit select id, name, uuid, state, private_ip_address from cloud.vm_instance where state = 'Running' or state = 'Stopped';
END */;;

`trg_icinga_update` BEFORE UPDATE ON `vm_instance` FOR EACH ROW BEGIN
   delete from cloud.icinga_monit;
   insert into cloud.icinga_monit select id, name, uuid, state, private_ip_address from cloud.vm_instance where state = 'Running' or state = 'Stopped';
END */;;

DELIMITER ;
