-- F3A Aircraft Brands and Components Database
-- Based on Gator RC brands and F3A requirements

-- Categories table for F3A aircraft components
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    required_for_f3a BOOLEAN DEFAULT 0
);

-- Brands table
CREATE TABLE brands (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    website VARCHAR(255),
    country VARCHAR(50),
    specialty TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Brand-Category relationship (many-to-many)
CREATE TABLE brand_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    brand_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    is_primary BOOLEAN DEFAULT 0,
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    UNIQUE(brand_id, category_id)
);

-- Insert F3A component categories
INSERT INTO categories (name, description, required_for_f3a) VALUES
('airframe', '2m F3A pattern aircraft kits and ARF', 1),
('motor', 'Electric motors for F3A aircraft', 1),
('esc', 'Electronic Speed Controllers', 1),
('battery', 'LiPo batteries for F3A power systems', 1),
('propeller', 'Props optimized for F3A performance', 1),
('servo', 'High-precision servos for control surfaces', 1),
('receiver', 'Radio receivers', 1),
('transmitter', 'Radio transmitters', 1),
('gyro', 'Flight stabilization systems', 0),
('spinner', 'Propeller spinners', 0),
('landing-gear', 'Retractable and fixed landing gear', 0),
('covering', 'Aircraft covering materials', 0),
('adhesive', 'CA glue, epoxy, and assembly materials', 0),
('hardware', 'Screws, bolts, and mechanical parts', 0),
('tools', 'Building and maintenance tools', 0);

-- Insert major F3A brands from Gator RC
INSERT INTO brands (name, website, country, specialty) VALUES
('Extreme Flight', 'https://www.extreme-flight.com', 'USA', 'High-performance F3A aircraft'),
('Sebart', 'https://www.sebart.com', 'Italy', 'Competition F3A models'),
('BJ Craft', 'https://www.bjcraft.com', 'USA', '2m F3A pattern aircraft'),
('CA Model', 'https://www.camodel.com', 'China', '2m F3A competition models'),
('HUI YANG F3A', 'https://www.huiyang-f3a.com', 'China', '2m F3A pattern aircraft'),
('Futaba', 'https://www.futabarc.com', 'Japan', 'Radio systems and servos'),
('Spektrum', 'https://www.spektrumrc.com', 'USA', 'Radio systems and electronics'),
('Castle Creations', 'https://www.castlecreations.com', 'USA', 'ESCs and motors'),
('Motrolfly', 'https://www.motrolfly.com', 'USA', 'Electric motors'),
('APC', 'https://www.apcprop.com', 'USA', 'Propellers'),
('Xoar', 'https://www.xoar.com', 'China', 'Carbon fiber propellers'),
('Savox', 'https://www.savoxusa.com', 'South Korea', 'High-torque servos'),
('PowerBox', 'https://www.powerbox-systems.com', 'Germany', 'Power distribution systems'),
('Falcon', 'https://www.falconprop.com', 'USA', 'Composite propellers'),
('Mejzlik', 'https://www.mejzlik.eu', 'Czech Republic', 'Competition propellers'),
('Hacker Motor', 'https://www.hacker-motor.com', 'Germany', 'Brushless motors'),
('YGE', 'https://www.yge.de', 'Germany', 'Electronic speed controllers'),
('Jeti', 'https://www.jetimodel.com', 'Czech Republic', 'Radio systems and telemetry'),
('Graupner', 'https://www.graupner.de', 'Germany', 'Radio systems and accessories'),
('Hitec', 'https://www.hitecrcd.com', 'South Korea', 'Servos and radio systems'),
('JR', 'https://www.jrradios.com', 'Japan', 'Radio transmitters and receivers'),
('Maxford USA', 'https://www.maxfordusa.com', 'USA', 'RC aircraft distributor');

-- Map brands to categories
INSERT INTO brand_categories (brand_id, category_id, is_primary) VALUES
-- 2m F3A Airframe manufacturers
(1, 1, 1), -- Extreme Flight - airframe
(2, 1, 1), -- Sebart - airframe
(3, 1, 1), -- BJ Craft - airframe
(4, 1, 1), -- CA Model - airframe
(5, 1, 1), -- HUI YANG F3A - airframe

-- Radio system brands
(6, 7, 1), (6, 8, 1), (6, 6, 1), -- Futaba - receiver, transmitter, servo
(7, 7, 1), (7, 8, 1), (7, 6, 1), -- Spektrum - receiver, transmitter, servo
(18, 7, 1), (18, 8, 1), -- Jeti - receiver, transmitter
(19, 7, 1), (19, 8, 1), -- Graupner - receiver, transmitter
(20, 6, 1), (20, 7, 1), -- Hitec - servo, receiver
(21, 7, 1), (21, 8, 1), -- JR - receiver, transmitter

-- Motor and ESC brands
(8, 2, 1), (8, 3, 1), -- Castle Creations - motor, esc
(9, 2, 1), -- Motrolfly - motor
(16, 2, 1), -- Hacker Motor - motor
(17, 3, 1), -- YGE - esc

-- Propeller brands
(10, 5, 1), -- APC - propeller
(11, 5, 1), -- Xoar - propeller
(14, 5, 1), -- Falcon - propeller
(15, 5, 1), -- Mejzlik - propeller

-- Servo brands
(12, 6, 1), -- Savox - servo

-- Power systems
(13, 4, 0); -- PowerBox - battery (power distribution)

-- Query examples
-- Find all brands that make F3A airframes
-- SELECT b.name, b.specialty FROM brands b
-- JOIN brand_categories bc ON b.id = bc.brand_id
-- JOIN categories c ON bc.category_id = c.id
-- WHERE c.name = 'airframe';

-- Find all components needed for F3A aircraft
-- SELECT name, description FROM categories WHERE required_for_f3a = 1;

-- Find brands by category
-- SELECT b.name, c.name as category FROM brands b
-- JOIN brand_categories bc ON b.id = bc.brand_id
-- JOIN categories c ON bc.category_id = c.id
-- ORDER BY c.name, b.name;
