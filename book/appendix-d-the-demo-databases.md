# Appendix D. The demo databases

Chapter 23 reads fourteen databases that the book ran as containers on its gateway's server. This appendix says how, so that you can run your own. It is about the databases, not about Minimal: nothing here belongs to Studio or to the Core.

## Conventions

- **One private network.** Every container joins the network that the Core already uses to reach its own databases, and none publishes a port. The Core reaches a container by its name; nothing outside the server can reach it. In the commands below, `$NET` is that network.
- **No password, but one.** Thirteen engines run so that their login needs none: some by a setting in the table, the others by default. That is acceptable only because of the private network. SingleStore's image is started with a root password instead, which Studio's **Password** field takes.
- **A name each.** Containers are called `poly-<engine>`; the database inside each has the name chapter 23 uses.
- **Limits.** `--memory` caps each container, and `--oom-score-adj 500` makes the kernel choose these containers before the Core's own services if memory runs out. The book also gave the 4 GB server a 2 GB swap file. After the server was enlarged to 8 CPUs and 16 GB, all fourteen ran together: a reading taken with all fourteen running showed about 6 GB in use and about 10 GB available.
- **Starting again.** The book started the containers with Docker's default, which does not bring a container back after the server is powered off and on. After the enlargement it started each one again by hand. To have them come back by themselves, add `--restart unless-stopped` to the front of the commands, which is given under the table.
- **Loading.** After a container answers, its table is made with the engine's own client and the SQL under "The data" below. Wait for the real server, not the one the image starts for its own set-up: the PostgreSQL and MySQL images answer once before they restart.

## The containers

| Container | Image | Started with |
|---|---|---|
| `poly-postgres` | `postgres:17` | `-e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_DB=bookshop` |
| `poly-timescaledb` | `timescale/timescaledb:latest-pg17` | the same two settings, `-e POSTGRES_DB=weather` |
| `poly-citus` | `citusdata/citus:latest` | the same two settings, `-e POSTGRES_DB=invoices` |
| `poly-cockroach` | `cockroachdb/cockroach:latest` | `start-single-node --insecure --cache=128MiB --max-sql-memory=128MiB` |
| `poly-yugabyte` | `yugabytedb/yugabyte:latest` | `bin/yugabyted start --background=false --ui=false` |
| `poly-risingwave` | `risingwavelabs/risingwave:latest` | `playground` |
| `poly-mysql` | `mysql:8.4` | `-e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_ROOT_HOST=%`, then `--innodb-buffer-pool-size=64M --performance-schema=OFF` |
| `poly-percona` | `percona/percona-server:8.4` | the same as MySQL |
| `poly-vitess` | `vitess/vttestserver:mysql80` | `-e PORT=33574 -e KEYSPACES=accounts -e NUM_SHARDS=1 -e MYSQL_BIND_HOST=0.0.0.0` |
| `poly-tidb` | `pingcap/tidb:latest` | nothing more |
| `poly-starrocks` | `starrocks/allin1-ubuntu:latest` | a copy of `fe.conf` with `-Xmx8192m` changed to `-Xmx1024m`, mounted over the original |
| `poly-singlestore` | `ghcr.io/singlestore-labs/singlestoredb-dev:latest` | `-e ROOT_PASSWORD=<a password of your own>` |
| `poly-mariadb` | `mariadb:11` | `-e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1` |
| `poly-clickhouse` | `clickhouse/clickhouse-server:latest` | `-e CLICKHOUSE_SKIP_USER_SETUP=1`, and a small `low-memory.xml` in `config.d` |

Every command has the same front: `docker run -d --name <container> --network $NET --memory <limit> --oom-score-adj 500`. The limits the book used were 384 MB for the small PostgreSQL-family and MariaDB containers, 448 to 768 MB for TimescaleDB, CockroachDB, TiDB and MySQL, 512 MB for Percona, 900 MB for ClickHouse, 1.2 GB for RisingWave, 1.4 GB for Vitess, 1.8 GB for YugabyteDB and 2.8 GB for StarRocks; SingleStore, added after the enlargement, got 8 GB and idled at about 780 MB.

Five things the book met:

- **ClickHouse** idles at about 650 MB. It refused to start when the book lowered its background pool sizes (a merge setting must stay below their product); a `max_server_memory_usage` and the removal of its own log tables worked instead.
- **Vitess** names its database a keyspace, and the keyspace is set when the container starts. The MySQL port of its gateway is the `PORT` you gave it plus three: 33577.
- **StarRocks** answered in under a minute once its heap was lowered. The image's own setting is 8 GB for the front end, more than the whole server had before it was enlarged.
- **SingleStore** wants a root password to start, speaks the MySQL protocol on 3306, and answered about ten seconds after its container started. Its maker recommends 8 GB of memory and four CPUs for it, and the image's download falls under SingleStore's Free Tier License Agreement: read it before you run the image.
- **RisingWave** (started with `playground`) and **Vitess** (`vttestserver`) keep nothing across a restart. When the server was powered off and on, both came back empty, and the book ran their statements again. The other engines kept their data in the containers.

## The data

Each database holds the table of chapter 23, with five or six invented rows. Run the statements with each engine's own client once its container answers. The PostgreSQL, TimescaleDB and Citus images make their database from `POSTGRES_DB`; every other database, except Vitess's, is made by the first statement.

```sql
-- PostgreSQL (database bookshop)
CREATE TABLE book (id INT PRIMARY KEY, title TEXT NOT NULL, author TEXT NOT NULL, price NUMERIC(6,2) NOT NULL, in_stock BOOLEAN NOT NULL);
INSERT INTO book VALUES (1,'Gardens of Salt','Jane Doe',12.50,true),(2,'The Long Quiet','John Doe',9.90,true),(3,'Harbour Lights','Jane Doe',14.00,false),(4,'A Map of Small Things','John Doe',11.25,true),(5,'Winter Orchard','Jane Doe',10.00,true);

-- TimescaleDB (database weather)
CREATE TABLE reading (ts TIMESTAMPTZ NOT NULL, station TEXT NOT NULL, temp_c NUMERIC(4,1) NOT NULL);
SELECT create_hypertable('reading', 'ts');
INSERT INTO reading VALUES ('2026-11-01 06:00+00','North Pier',4.5),('2026-11-01 07:00+00','North Pier',5.1),('2026-11-01 08:00+00','North Pier',6.0),('2026-11-01 06:00+00','Hill Top',1.2),('2026-11-01 07:00+00','Hill Top',1.9),('2026-11-01 08:00+00','Hill Top',2.8);

-- Citus (database invoices)
CREATE TABLE invoice (tenant_id INT NOT NULL, number INT NOT NULL, amount NUMERIC(8,2) NOT NULL, PRIMARY KEY (tenant_id, number));
INSERT INTO invoice VALUES (1,1001,250.00),(1,1002,80.00),(2,2001,1200.00),(2,2002,45.50),(3,3001,310.00);

-- CockroachDB
CREATE DATABASE hotel;
CREATE TABLE hotel.public.booking (id INT PRIMARY KEY, guest STRING NOT NULL, city STRING NOT NULL, nights INT NOT NULL);
INSERT INTO hotel.public.booking VALUES (1,'John Doe','Lisbon',2),(2,'Jane Doe','Osaka',4),(3,'John Doe','Nairobi',3),(4,'Jane Doe','Lima',5),(5,'John Doe','Oslo',1);

-- YugabyteDB (connect to the new database before the next two statements)
CREATE DATABASE payments;
CREATE TABLE payment (id INT PRIMARY KEY, payer TEXT NOT NULL, amount NUMERIC(8,2) NOT NULL, method TEXT NOT NULL);
INSERT INTO payment VALUES (1,'John Doe',120.00,'card'),(2,'Jane Doe',75.50,'transfer'),(3,'John Doe',18.20,'wallet'),(4,'Jane Doe',240.00,'card'),(5,'John Doe',9.99,'wallet');

-- RisingWave (connect to the new database before the next statements)
CREATE DATABASE clicks;
CREATE TABLE click (id INT PRIMARY KEY, visitor VARCHAR, page VARCHAR);
INSERT INTO click VALUES (1,'John Doe','/home'),(2,'Jane Doe','/pricing'),(3,'John Doe','/pricing'),(4,'Jane Doe','/docs'),(5,'John Doe','/pricing');
CREATE MATERIALIZED VIEW clicks_per_page AS SELECT page, COUNT(*) AS clicks FROM click GROUP BY page;
FLUSH;

-- MySQL
CREATE DATABASE webshop;
CREATE TABLE webshop.product (id INT PRIMARY KEY, name VARCHAR(60) NOT NULL, price DECIMAL(8,2) NOT NULL, stock INT NOT NULL);
INSERT INTO webshop.product VALUES (1,'Ceramic Mug',8.50,120),(2,'Desk Lamp',24.00,35),(3,'Notebook',4.20,300),(4,'Tote Bag',12.00,80),(5,'Water Bottle',15.90,64);

-- Percona Server
CREATE DATABASE helpdesk;
CREATE TABLE helpdesk.ticket (id INT PRIMARY KEY, subject VARCHAR(80) NOT NULL, status VARCHAR(12) NOT NULL, priority VARCHAR(8) NOT NULL);
INSERT INTO helpdesk.ticket VALUES (1,'Cannot sign in','open','high'),(2,'Invoice question','closed','low'),(3,'Export is slow','open','medium'),(4,'Wrong delivery address','pending','low'),(5,'Password reset','closed','medium');

-- Vitess: the keyspace accounts exists from the start; no CREATE DATABASE
CREATE TABLE customer (id INT PRIMARY KEY, name VARCHAR(60) NOT NULL, plan VARCHAR(12) NOT NULL);
INSERT INTO customer VALUES (1,'John Doe','free'),(2,'Jane Doe','pro'),(3,'John Smith','team'),(4,'Jane Smith','pro'),(5,'Alex Doe','free');

-- TiDB
CREATE DATABASE orders;
CREATE TABLE orders.customer_order (id INT PRIMARY KEY, customer VARCHAR(60) NOT NULL, total DECIMAL(8,2) NOT NULL, placed_on DATE NOT NULL);
INSERT INTO orders.customer_order VALUES (1,'John Doe',58.40,'2026-10-28'),(2,'Jane Doe',12.00,'2026-10-29'),(3,'John Doe',199.99,'2026-10-30'),(4,'Jane Doe',34.75,'2026-11-01'),(5,'John Doe',8.20,'2026-11-02');

-- StarRocks: a primary-key table with one replica
CREATE DATABASE sales;
CREATE TABLE sales.daily_sales (day DATE NOT NULL, region VARCHAR(20) NOT NULL, units INT NOT NULL)
PRIMARY KEY (day, region) DISTRIBUTED BY HASH(day, region) BUCKETS 1 PROPERTIES ("replication_num" = "1");
INSERT INTO sales.daily_sales VALUES ("2026-11-01","North",120),("2026-11-01","South",95),("2026-11-02","North",130),("2026-11-02","South",88),("2026-11-03","North",142),("2026-11-03","South",101);

-- SingleStore
CREATE DATABASE rides;
CREATE TABLE rides.trip (id INT PRIMARY KEY, rider VARCHAR(60) NOT NULL, city VARCHAR(40) NOT NULL, distance_km DECIMAL(6,1) NOT NULL, fare DECIMAL(8,2) NOT NULL);
INSERT INTO rides.trip VALUES (1,'John Doe','Lisbon',4.2,7.80),(2,'Jane Doe','Osaka',12.5,21.40),(3,'John Doe','Nairobi',6.0,9.10),(4,'Jane Doe','Lima',3.3,5.60),(5,'John Doe','Oslo',9.8,18.25);

-- MariaDB
CREATE DATABASE library;
CREATE TABLE library.loan (id INT PRIMARY KEY, member VARCHAR(60) NOT NULL, title VARCHAR(80) NOT NULL, due_on DATE NOT NULL);
INSERT INTO library.loan VALUES (1,'John Doe','Atlas of Rivers','2026-11-14'),(2,'Jane Doe','Cooking for Two','2026-11-16'),(3,'John Doe','Night Trains','2026-11-20'),(4,'Jane Doe','Small Gardens','2026-11-21'),(5,'John Doe','The Quiet Coast','2026-11-25');

-- ClickHouse
CREATE DATABASE weblogs;
CREATE TABLE weblogs.hit (ts DateTime, path String, status UInt16, ms UInt32) ENGINE = MergeTree ORDER BY ts;
INSERT INTO weblogs.hit VALUES ('2026-11-01 09:00:01','/home',200,12),('2026-11-01 09:00:05','/pricing',200,18),('2026-11-01 09:01:10','/docs',200,25),('2026-11-01 09:02:30','/missing',404,3),('2026-11-01 09:03:00','/api/items',500,140),('2026-11-01 09:03:42','/home',200,9);
```

The people are John Doe and Jane Doe, and in `customer` also John Smith, Jane Smith and Alex Doe. The versions in chapter 23 were read from the running containers with each engine's own client.

## A network of its own

The book put the containers on the Core's existing private network to keep the example short. That network also holds the Core's own databases, and thirteen of the demo engines have no password, so a cleaner way is a network that only the databases and the Core join: make it with `docker network create`, start the containers on it, and attach the Core to it with `docker network connect`.

## Taking them away

`docker rm -f` on each container removes it. The registrations in the project are removed separately, with **Edit connections** (Chapter 16): remove the added rows, and for the project's own connection select **Load current passwords into the rows below** before you save, or the save can replace its stored password. A database that is stopped but still registered makes **Probe** slow, as chapter 23 shows.
