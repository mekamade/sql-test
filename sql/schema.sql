CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE addresses (
    "id" bigserial PRIMARY KEY NOT NULL,
    "address_line_1" character varying(255) NOT NULL,
    "address_line_2" character varying(255),
    "city" character varying(255) NOT NULL,
    "region" character varying(255) NOT NULL,
    "country" character varying(255) NOT NULL,
    "zip_code" character varying(255) NOT NULL,
    "phone" character varying(255) NOT NULL,
    "uuid" UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4()
);

CREATE TYPE organization_type AS ENUM ('CUSTOMER', 'ENTERPRISE', 'ENTERPRISE_CUSTOMER');

CREATE TABLE organizations (
    "id" bigserial PRIMARY KEY NOT NULL,
    "name" character varying(100) NOT NULL,
    "address_id" integer UNIQUE NOT NULL REFERENCES addresses("id"),
    "type" organization_type NOT NULL,
    "created_at" timestamp with time zone NOT NULL DEFAULT NOW(),
    "uuid" UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4()
);

CREATE TABLE enterprise_sales_enterprise_customers (
    "sales_organization_id" bigint NOT NULL REFERENCES organizations("id"),
    "customer_organization_id" bigint NOT NULL REFERENCES organizations("id"),
    CONSTRAINT sales_organization_customer_organization_key PRIMARY KEY (
        sales_organization_id,
        customer_organization_id
    )
);

CREATE TABLE japan_segments (
    "id" character varying(24) PRIMARY KEY NOT NULL,
    "bounds" geometry(Polygon,4326) NOT NULL
);
