const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize SQLite database
const db = new sqlite3.Database('./database/f3a.db');

// Initialize database from JSON files
function initializeDatabase() {
  // Create tables if they don't exist
  db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS brands (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      website TEXT,
      country TEXT,
      specialty TEXT
    )`);

    db.run(`CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      description TEXT,
      required_for_f3a BOOLEAN
    )`);

    db.run(`CREATE TABLE IF NOT EXISTS brand_categories (
      brand_name TEXT,
      category_name TEXT,
      PRIMARY KEY (brand_name, category_name)
    )`);

    // Load and insert data from JSON files
    try {
      const brands = JSON.parse(fs.readFileSync('./data/brands.json', 'utf8'));
      const categories = JSON.parse(fs.readFileSync('./data/categories.json', 'utf8'));

      // Insert categories
      categories.forEach(category => {
        db.run('INSERT OR REPLACE INTO categories (name, description, required_for_f3a) VALUES (?, ?, ?)',
          [category.name, category.description, category.required_for_f3a]);
      });

      // Insert brands and their categories
      brands.forEach(brand => {
        db.run('INSERT OR REPLACE INTO brands (name, website, country, specialty) VALUES (?, ?, ?, ?)',
          [brand.name, brand.website, brand.country, brand.specialty]);

        // Insert brand-category relationships
        brand.categories.forEach(categoryName => {
          db.run('INSERT OR REPLACE INTO brand_categories (brand_name, category_name) VALUES (?, ?)',
            [brand.name, categoryName]);
        });
      });

      console.log('✅ Database initialized from JSON files');
    } catch (error) {
      console.error('❌ Error initializing database:', error);
    }
  });
}

// Initialize database on startup
initializeDatabase();

// Middleware
app.use(helmet());
app.use(cors({
  origin: [
    'https://f3a-pattern-aerobatics-rc.club',
    'https://considerable.github.io',
    'http://localhost:3000'
  ],
  credentials: true
}));
app.use(compression());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'f3a-microservice',
    version: '1.0.0'
  });
});

// Club information API
app.get('/api/club', (req, res) => {
  res.json({
    name: 'F3A Pattern Aerobatics RC Club',
    description: 'Precision aerobatic flying with radio-controlled aircraft',
    location: 'Pacific Northwest',
    founded: '1985',
    website: 'https://f3a-pattern-aerobatics-rc.club',
    activities: [
      'F3A Pattern Competition',
      'Training Workshops',
      'Monthly Fly-ins',
      'Equipment Reviews'
    ],
    contact: {
      email: 'info@f3a-pattern-aerobatics-rc.club',
      meetings: 'First Saturday of each month'
    }
  });
});

// Events API
app.get('/api/events', (req, res) => {
  res.json({
    upcoming: [
      {
        id: 1,
        title: 'Monthly Club Meeting',
        date: '2024-02-03',
        time: '10:00 AM',
        location: 'Club Field',
        description: 'Monthly meeting and practice session'
      },
      {
        id: 2,
        title: 'F3A Pattern Workshop',
        date: '2024-02-17',
        time: '9:00 AM',
        location: 'Club Field',
        description: 'Advanced pattern flying techniques'
      }
    ]
  });
});

// Aircraft API
app.get('/api/aircraft', (req, res) => {
  res.json({
    recommended: [
      {
        name: 'Extra 330SC',
        wingspan: '2.0m',
        weight: '4.5kg',
        engine: '120cc',
        skill_level: 'Advanced'
      },
      {
        name: 'Yak 54',
        wingspan: '1.8m',
        weight: '3.8kg',
        engine: '100cc',
        skill_level: 'Intermediate'
      }
    ]
  });
});

// Brands API
app.get('/api/brands', (req, res) => {
  db.all('SELECT * FROM brands ORDER BY name', (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ brands: rows });
  });
});

// Categories API
app.get('/api/categories', (req, res) => {
  db.all('SELECT * FROM categories ORDER BY name', (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ categories: rows });
  });
});

// Components by category API
app.get('/api/components/:category', (req, res) => {
  const category = req.params.category;
  const query = `
    SELECT b.* FROM brands b
    JOIN brand_categories bc ON b.name = bc.brand_name
    WHERE bc.category_name = ?
    ORDER BY b.name
  `;

  db.all(query, [category], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({
      category: category,
      brands: rows
    });
  });
});



// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    timestamp: new Date().toISOString()
  });
});

// Graceful shutdown
process.on('SIGINT', () => {
  db.close((err) => {
    if (err) {
      console.error(err.message);
    }
    console.log('Database connection closed.');
    process.exit(0);
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 F3A Microservice running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🏠 Website: http://localhost:${PORT}`);
  console.log(`🗄️ SQLite database: ./database/f3a.db`);
});
