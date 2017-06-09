
CREATE TABLE IF NOT EXISTS `items` (
`id` int(11) unsigned NOT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `isIllegal` varchar(255) NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;


INSERT INTO `items` (`id`, `libelle`, `isIllegal`, `value`, `type`) VALUES
(26, 'Sandwich', '0', 30, 2),
(30, 'Hamburger', '0', 35, 2),
(25, 'Frites', '0', 35, 2),
(31, 'Eau', '0', 45, 1),
(33, 'Café', '0', 10, 1),
(34, 'Barre Choco', '0', 20, 2),
(35, 'Coca zero', '0', 35, 1);
