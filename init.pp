class taskize_users {
	group { 'flynn':
		ensure => 'present',
	}

	user { 'flynn':
		ensure => present,
		comment => 'flynn user',
		home => '/home/flynn',
		managehome => true,
		groups => 'flynn',
		require => Group['flynn']
	}
	ssh_authorized_key { 'flynn_ssh':
		user => 'flynn',
		type => 'rsa',
		key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ9J19Lz36JIPa9Rq6SrzgabBvcYYcGCDRJSOoyjSm2uXklLREZ5KtkmRYJaDk3oOBKdO26ScFMRU975/TkB6kr1PRAhhz6LNYt8pRnG1iSINkAv0+rWZYV29fd5R8Mp2Nwa/6gX8FPepIP1yoEJonJLXKPIKeRwl/YDMrO3m0ZLNOlSaas+x8i6J/yj2+SYRuwwdX93Gcz1taMm5trldhGKPIZ6z0MUDb9x9s0+F9y3pu0H/lK5TjSjB69Ej0Kb5YEeBp+WoSeYpn+Nif01GboGUy2eLQjrO1/moIW6NMWl5EG4bIEOrNQ/HowXYwN8Pc6mWS+nhbjYPlYFG9vSBB',
	}
}

class taskize_sudoers {
	class { 'sudo':
		purge => false,
		config_file_replace => false,
	}
	sudo::conf { 'flynn':
		priority => 10,
		content  => "flynn ALL=NOPASSWD:/sbin/reboot",
	}
}

class taskize_motd {
	include motd
	exec { 'customize_motd':
		command => '/bin/echo "############## THIS SYSTEM IS A TEST ##############" >> /etc/motd',
		require => Class['motd'],
	}
}

class taskize_java {
	exec { 'install_jdk':
		command => '/bin/mkdir /tmp/taskize_java/; /usr/bin/wget -P /tmp/taskize_java/ --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz;cd /tmp/taskize_java/; /bin/tar zxf /tmp/taskize_java/jdk-8u65-linux-x64.tar.gz;/bin/mv /tmp/taskize_java/jdk1.8.0_65 /usr/lib/jdk1.8.0_65;sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jdk1.8.0_65/bin/java" 1;sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jdk1.8.0_65/bin/javac" 1;sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jdk1.8.0_65/bin/javaws" 1;sudo chmod a+x /usr/bin/java;sudo chmod a+x /usr/bin/javac;sudo chmod a+x /usr/bin/javaws',
		onlyif => "/usr/bin/test  ! -e /tmp/taskize_java",
	}
}

class taskize_tomcat {
	class { 'tomcat': }
	
	#tomcat::service { 'default':
	#	user => "flynn",
	#}

	tomcat::instance { 'test':
		source_url => 'http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz'
	}->
	tomcat::service { 'default': }
}


###Init
node default {
	include taskize_users
	include taskize_motd
	include taskize_sudoers
	include taskize_java
	include taskize_tomcat
}

