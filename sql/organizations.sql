begin;

INSERT INTO addresses (
    address_line_1,
    address_line_2,
    city,
    region,
    country,
    zip_code,
    phone
) VALUES
    (
        'test_line_1',
        'test_line_2',
        'test_city',
        'test_region',
        'JP',
        '103-0023',
        '090-0000-1111'
    )
    ,(
        'Mars',
        'Moon',
        'Chuo-ku',
        'Tokyo',
        'JP',
        '000-0001',
        '090-0000-1112'
    )
    ,(
        'Saturn',
        'Sun',
        'Shinjuku-ku',
        'Tokyo',
        'JP',
        '000-0002',
        '090-0000-1113'
    )
    ,(
        'S',
        'S',
        'Shinjuku-ku',
        'Tokyo',
        'JP',
        '000-0003',
        '090-0000-1114'
    )
    ,(
        'A',
        'A',
        'Shinjuku-ku',
        'Tokyo',
        'JP',
        '000-0004',
        '090-0000-1115'
    )
    ,(
        'B',
        'B',
        'Shinjuku-ku',
        'Tokyo',
        'JP',
        '000-0005',
        '090-0000-1116'
    )
    ,(
        'D',
        'D',
        'Shinjuku-ku',
        'Tokyo',
        'JP',
        '000-0005',
        '090-0000-1116'
    )
;

INSERT INTO organizations (
    name,
    address_id,
    type
) VALUES
    (
        'Zoozle',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 0),
        'CUSTOMER'
    )
    ,(
        'Bmazon',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 1),
        'ENTERPRISE'
    )
    ,(
        'Ncrosoft',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 2),
        'ENTERPRISE_CUSTOMER'
    )
    ,(
        'Moomle',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 3),
        'ENTERPRISE_CUSTOMER'
    )
    ,(
        'Cmazon',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 4),
        'ENTERPRISE_CUSTOMER'
    )
    ,(
        'Zcrosoft',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 5),
        'ENTERPRISE'
    )
    ,(
        'Ecrosoft',
        (SELECT id FROM addresses ORDER BY id ASC LIMIT 1 OFFSET 6),
        'ENTERPRISE_CUSTOMER'
    )
;

INSERT INTO enterprise_sales_enterprise_customers (
    sales_organization_id,
    customer_organization_id
) VALUES
    (
        (SELECT id FROM organizations WHERE name = 'Bmazon' ORDER BY id DESC LIMIT 1),
        (SELECT id FROM organizations WHERE name = 'Ncrosoft' ORDER BY id DESC LIMIT 1)
    )
    ,(
        (SELECT id FROM organizations WHERE name = 'Bmazon' ORDER BY id DESC LIMIT 1),
        (SELECT id FROM organizations WHERE name = 'Moomle' ORDER BY id DESC LIMIT 1)
    )
    ,(
        (SELECT id FROM organizations WHERE name = 'Bmazon' ORDER BY id DESC LIMIT 1),
        (SELECT id FROM organizations WHERE name = 'Cmazon' ORDER BY id DESC LIMIT 1)
    )
    ,(
        (SELECT id FROM organizations WHERE name = 'Bmazon' ORDER BY id DESC LIMIT 1),
        (SELECT id FROM organizations WHERE name = 'Zcrosoft' ORDER BY id DESC LIMIT 1)
    )
    ,(
        (SELECT id FROM organizations WHERE name = 'Zcrosoft' ORDER BY id DESC LIMIT 1),
        (SELECT id FROM organizations WHERE name = 'Ncrosoft' ORDER BY id DESC LIMIT 1)
    )
;

commit;
