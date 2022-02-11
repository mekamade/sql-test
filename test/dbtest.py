import unittest

import functools
import psycopg2
import os
from typing import Any


def dbconnect(func):
    @functools.wraps(func)
    def inner(*args, **kwargs):
        inner.__wrapped__ = func
        params = {
            "host": "testdb",
            "port": 5432,
            "dbname": "test",
            "user": "postgres",
            "password": "password",
        }
        print(f"Connecting for {params}")
        # http://initd.org/psycopg/docs/usage.html#with-statement
        conn = None
        try:
            with psycopg2.connect(**params) as conn:
                func(*args, conn=conn, **kwargs)
        finally:
            if conn:
                print(f"Close connection for {params}")
                conn.close()
    return inner


class DbTest(unittest.TestCase):
    @dbconnect
    def setUp(self, conn):
        print("Invoking setUp")
        print("Set up database schema")
        path_to_schema = os.path.join(
            os.path.dirname(__file__),
            "..",
            "sql",
            "schema.sql"
        )
        with conn.cursor() as cur:
            cur.execute("CREATE SCHEMA IF NOT EXISTS public;")
            schema_sql = self.read_file(path_to_schema)
            print(f"Loading {path_to_schema}")
            cur.execute(schema_sql)
            print(f"Loaded {path_to_schema}")

    @dbconnect
    def tearDown(self, conn):
        print("Invoking tearDown")
        print("Tore down database schema")
        with conn.cursor() as cur:
            print("Droping schema")
            cur.execute("DROP SCHEMA IF EXISTS public CASCADE;")
            print("Dropped schema")


    def load_fixtures(self, conn: Any, *path_to_sqls: str) -> None:
        for path_to_sql in path_to_sqls:
            sql = self.read_file(path_to_sql)
            with conn.cursor() as cur:
                print(f"Executing {path_to_sql}")
                cur.execute(sql)
                print(f"Executed {path_to_sql}")


    def read_file(self, path_to_file: str) -> str:
        with open(path_to_file, "r") as f:
            return f.read()
