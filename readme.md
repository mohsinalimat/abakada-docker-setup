# Prerequisites
- Docker 
- Git

# Development setup

Clone the Abakada docker dev repository
``` sh
$ git clone https://github.com/kabkd/abakada-docker-setup.git
```

Build the setup
``` sh
$ docker-compose build
```

Activate the setup
``` sh
$ docker-compose up -d
```

View containers
```
$ docker-compose ps
NAME                             COMMAND                  SERVICE             STATUS              PORTS
containerized-adminer-1          "entrypoint.sh docke…"   adminer             running             0.0.0.0:8080->8080/tcp
containerized-frappe-1           "python3"                frappe              running             0.0.0.0:8000->8000/tcp
containerized-mariadb-1          "docker-entrypoint.s…"   mariadb             running             0.0.0.0:3306->3306/tcp
containerized-redis-cache-1      "docker-entrypoint.s…"   redis-cache         running             6379/tcp
containerized-redis-queue-1      "docker-entrypoint.s…"   redis-queue         running             6379/tcp
containerized-redis-socketio-1   "docker-entrypoint.s…"   redis-socketio      running             6379/tcp
```

Run a command in a running container
```sh
$ docker-compose exec <service> bash
```
or 
```sh
$ docker-compose exec <service> bash <your command>
```
Example
```shell
$ docker-compose exec frappe bash bench init --skip-redis-config-generation --frappe-branch version-13
```

# Setup Frappe 
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench init --skip-redis-config-generation --frappe-branch version-13
```

Update the `common_site_config.json` from `apps/frappe-bench/sites/`
```json
{
    "background_workers": 1,
    "db_host": "mariadb",
    "file_watcher_port": 6787,
    "frappe_user": "frappe",
    "gunicorn_workers": 9,
    "live_reload": true,
    "rebase_on_pull": false,
    "redis_cache": "redis://redis-cache:6379",
    "redis_queue": "redis://redis-queue:6379",
    "redis_socketio": "redis://redis-socketio:6379",
    "restart_supervisor_on_update": false,
    "restart_systemd_on_update": false,
    "serve_default_site": true,
    "shallow_clone": true,
    "socketio_port": 9000,
    "use_redis_auth": false,
    "webserver_port": 8000
}
```

Create new site
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench new-site dev.local --mariadb-root-password 12345 --admin-password admin --no-mariadb-socket --force
```

Enable developers mode
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench --site dev.local set-config developer_mode 1
```

Clear cache
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench --site dev.local clear-cache
```

Pull Abakada erpnext.

Note:
If you want to setup Trinity project then choose trinity branch.
For other projects like mapecon, contact mapecon devs.
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench get-app --branch trinity https://github.com/GURU-ABKD/erpnext.git
```

Pull Abakada Trinity.
If you using http as login, generate token here `https://github.com/settings/tokens`. Use the generated token as password.
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench get-app https://github.com/GURU-ABKD/trinity-erp.git
```

Intall Abakada erpnext and trinity
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench --site dev.local install-app erpnext
frappe@081dc138d589: bench --site dev.local install-app trinity_app
```

Serve your project
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench start
```

Other bench commands:
`https://frappeframework.com/docs/v13/user/en/bench/bench-commands`


# To restore database backup
```sh
$ docker-compose exec frappe bash
frappe@081dc138d589: bench --force --site dev.local restore <path.sql>
frappe@081dc138d589: bench --site dev.local migrate
```

# Access database via Web
Open browser and nagivate to: `localhost:8080`

# Local Setup
Mac/Linux:
`$ sudo nano /etc/hosts`

Windows:
`C:\Windows\System32\drivers\etc\hosts`

Add host/site:
`127.0.0.1       dev.local`


# Preview your project
Open browser and nagivate to:
[https://dev.local][Plod] 

Default account: `administrator`

Password: `admin`

[Plod]: <https://dev.local>