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

#### Problem 2: `calculate_center_of_each_segment`

```
    SELECT 
        id, 
        ST_X(ST_Centroid(bounds)) AS longitude,
        ST_Y(ST_Centroid(bounds)) AS latitude 
    FROM 
        japan_segments;
```

- Inferred that the `bounds` data is stored using the `ESPG:4326` (SRID = 4326) projection.
- Using PostGIS we are able to find the centroid of this region.
- The `ESPG:4326` coordinate system is global (curved surface), so we can extract the required `latitude` and `longitude` value.
- Referred PostGIS documentation for the methods: `ST_X`, `ST_Y` & `ST_Centroid`.

#### Problem 3: `segments_using_geojson_boundary`

```
    SELECT
        id
    FROM
        japan_segments
    WHERE ST_Contains(
        ST_GeomFromGeoJSON('{
            "type": "Polygon",
            "coordinates": [[[130.27313232421875, 30.519681272749402],
                    [131.02020263671875, 30.519681272749402],
                    [131.02020263671875, 30.80909017893796],
                    [130.27313232421875, 30.80909017893796],
                    [130.27313232421875, 30.519681272749402]]],
            "crs":{"type":"name","properties":{"name":"EPSG:4326"}}
            }'
        ), 
        bounds
    );
```

- Using `ST_GeomFromGeoJSON` we can get a PostGIS geometry object from the GeoJSON. Only the `geometry` attribute of the GeoJSON needs to be passed. 
- Input geometry from GeoJSON has unknown (0) SRID. So we add `"crs":{"type":"name","properties":{"name":"EPSG:4326"}}` to explicitly define the SRID as 4326.
- Using the `ST_Contains` method from PostGIS, we are able to solve for this query. 

