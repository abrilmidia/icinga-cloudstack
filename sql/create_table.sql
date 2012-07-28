DROP TABLE IF EXISTS `icinga_monit`;
CREATE TABLE `icinga_monit` (
  `id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `uuid` varchar(40) default NULL,
  `state` varchar(32) NOT NULL,
  `private_ip_address` char(40) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
