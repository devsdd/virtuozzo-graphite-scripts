# OS is assumed to be centos - will have to change manifest for other distros

$apache_docroot = "/var/www/html"

include apache
include mysql
include php
include fio

class apache {
	$packages = ['httpd', 'httpd-tools', 'sysstat']

	package {$packages:
		ensure	=> installed,
	}

	service {'httpd':
		ensure	=> running,
		enable	=> true,
		require	=> Package['httpd'],
	}

	file {'test.html':
		require	=> Package['httpd'],
		ensure	=> present,
		path	=> "$::apache_docroot/test.html",
		content	=> "<HTML><head><title>Apache Test Page</title></head><body><h1>Hello, World!</h1></body></HTML>"
	}

	cron {'apache-bench':
		command	=> "/usr/bin/ab -n 1000 -c 100 http://localhost/test.html >> /var/log/apache-bench.log",
		user	=> root,
		hour	=> "*",
		minute	=> 15,
	}
}

class php {

	include apache

	$packages = ['php', 'unzip', 'curl', 'wget']

	package {$packages:
		ensure	=> installed,
		require	=> Package['httpd'],
		notify	=> Service['httpd'],
	}

	exec {'download':
	command	=> "/usr/bin/wget http://www.php-benchmark-script.com/bench.zip && /usr/bin/unzip -o bench.zip -d $::apache_docroot",
		require	=> Package['unzip'],
	}

	cron {'php-bench':
		command	=> "/usr/bin/curl http://localhost/bench.php >> /var/log/php-bench.log",
		user	=> root,
		hour	=> "*",
		minute	=> 30,
	}

}

class mysql {

	$packages = ['mysql-server', 'mysql-bench', 'perl-DBD-MySQL']
	package {$packages:
		ensure	=> installed,
	}

	service {'mysqld':
		ensure	=> running,
		enable	=> true,
		require	=> Package['mysql-server'],
	}

	cron {'mysql-bench':
		command	=> "cd /usr/share/sql-bench/ && ./run-all-tests --random --tcpip >> /var/log/mysql-bench.log",
		user	=> root,
		hour	=> "*",
		minute	=> 15,
	}
}

class fio {
	package {'fio':
		ensure	=> installed,
	}

	file {'/var/log/fio':
		ensure	=> directory,
	}

	file {'/var/log/fio/data':
		ensure	=> directory,
		require	=> File['/var/log/fio'],
	}

	cron {'fio':
		command	=> "/usr/bin/fio --name=random-rw --numjobs=128 --rw=randrw --size=58k --directory=/var/log/fio/data/ --ioengine=sync --iodepth=1 --direct=0 >> /var/log/fio/data/fio.log",
		user	=> root,
		hour	=> "*",
		minute	=> 30,
	}
}
