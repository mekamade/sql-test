SQL test
===

### Prerequisistes

```bash
$ python3 -m pip install pipenv --user
```

- Use virtualenv

```bash
$ PIPENV_VENV_IN_PROJECT=true pipenv shell
```

- Install dependencies

```bash
$ pipenv install --dev
```

### Usage

- Run up Postgresql server

```bash
$ docker-compose up db
```

- Stop Postgresql server

```bash
$ docker-compose down
```

- Connect to test database on Postgresql server using psql

```bash
$ docker-compose exec db psql -U postgres test
```

- Execute SQL file

```bash
$ docker-compose exec db psql -v ON_ERROR_STOP=1 -U postgres test -a -f "sql/schema.sql"
```

- Testing using database

```bash
$ docker-compose up dbtest
```

### Solution Notes
#### Problem 1: `count_the_number_of_subordinates`

```
SELECT 
    (SELECT 
        COUNT(*)
    FROM 
        enterprise_sales_enterprise_customers
    WHERE
        enterprise_sales_enterprise_customers.sales_organization_id = organizations.id)
    AS subordinates_count,
    organizations.id AS id
FROM 
    organizations;
```

- Conventional SQL Query where the number of corresponding records in another table are counted.