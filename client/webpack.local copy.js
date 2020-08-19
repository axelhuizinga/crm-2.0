
var production = {
	//host:'crm.bi4.me',
	//org:'bi4.me',
	org:'Schutzengelwerk.de',
	//port:666,
	root:'/var/www/vhosts/pitverwaltung.de/httpdocs/',
	host:'pitverwaltung.de'
};

var dev = {
	//host:'crm.bi4.me',
	//org:'bi4.me',
	org:'Schutzengelwerk.de',
	//port:666,
	root:'/var/www/vhosts/pitverwaltung.de/httpdocs/dev.pitverwaltung.de',
	host:'dev.pitverwaltung.de',
	//host:'pitverwaltung.de',
	ip:'192.168.178.20',
    key:  '../../mkcert/192.168.178.20-key.pem',
	cert: '../../mkcert/192.168.178.20.pem'
};

module.exports = function(env,args){
	console.log(args);
	return env.build == 'production'?production:dev;
}

/*[
	{
		org:'Schutzengelwerk.de',
		root:'/var/www/vhosts/pitverwaltung.de/httpdocs/',
		host:'pitverwaltung.de',
		name: 'production'
	},
	{
		//host:'crm.bi4.me',
		//org:'bi4.me',
		org:'Schutzengelwerk.de',
		//port:666,
		root:'/var/www/vhosts/pitverwaltung.de/httpdocs/dev.pitverwaltung.de',
		host:'dev.pitverwaltung.de',
		//host:'pitverwaltung.de',
		ip:'192.168.178.20',
		key:  '../../mkcert/192.168.178.20-key.pem',
		cert: '../../mkcert/192.168.178.20.pem',
		name: 'development'
	}
];*/