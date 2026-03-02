# Flask Setup Patterns

## Purpose

Reference patterns for setting up Flask project structure, organizing routing with blueprints, implementing configuration management, and establishing scalable application architecture.

## When to Use

- Initializing new Flask projects with production-ready structure
- Organizing routes logically across multiple feature modules
- Separating configuration for different environments (dev, test, prod)
- Implementing middleware and request/response handlers
- Scaling applications beyond single-file prototypes

## Core Concepts

- **Application Factory**: Create app instances with configuration; supports testing and multiple environments
- **Blueprints**: Modular organization of routes, templates, and static files by feature
- **Configuration Management**: Environment-based settings (DEBUG, DATABASE_URL, API_KEYS)
- **Middleware**: Request/response interceptors for logging, authentication, error handling
- **Request Context**: Flask context for accessing request data, user info, session state

## Reference Examples

### Application Factory Pattern

```python
# app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app(config_name='development'):
    app = Flask(__name__)
    app.config.from_object(f'config.{config_name.title()}Config')
    
    db.init_app(app)
    
    # Register blueprints
    from app.routes import product_bp, admin_bp
    app.register_blueprint(product_bp, url_prefix='/products')
    app.register_blueprint(admin_bp, url_prefix='/admin')
    
    return app

# app/routes/products.py
from flask import Blueprint, render_template
products_bp = Blueprint('products', __name__)

@products_bp.route('/')
def list_products():
    return render_template('products/list.html')
```

### Configuration Management

```python
# config.py
import os

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    SQLALCHEMY_ECHO = False

class DevelopmentConfig(Config):
    DEBUG = True
    TESTING = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///dev.db'

class ProductionConfig(Config):
    DEBUG = False
    TESTING = False
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')

# Usage
app = create_app(os.getenv('FLASK_ENV', 'development'))
```

### Blueprint with Error Handlers

```python
from flask import Blueprint, render_template
from werkzeug.exceptions import NotFound

api_bp = Blueprint('api', __name__, url_prefix='/api')

@api_bp.route('/data/<int:id>')
def get_data(id):
    data = fetch_data(id)
    if not data:
        raise NotFound(f"Data {id} not found")
    return {'id': id, 'data': data}

@api_bp.errorhandler(NotFound)
def handle_not_found(error):
    return {'error': str(error)}, 404
```

## Common Pitfalls

- **Monolithic Routes**: Cramming all routes in single file; use blueprints for organization
- **Hardcoded Config**: Embedding settings in code; use environment variables
- **Circular Imports**: Importing app in modules that get imported at app creation; use factory pattern
- **Missing Error Handlers**: Generic Flask errors aren't user-friendly; add blueprint-level handlers
- **No Request Context**: Trying to access request data outside request context; use context managers
- **Static Files Confusion**: Not organizing static files by blueprint; follow standard structure

## Dependencies

- **Flask**: `pip install Flask` (core framework)
- **Flask-SQLAlchemy**: `pip install Flask-SQLAlchemy` (database ORM)
- **Python-dotenv**: `pip install python-dotenv` (load environment variables)
- **Werkzeug**: Included with Flask; handles HTTP utilities and exceptions

## Limitations

- Blueprint registration must happen at app creation time; dynamic registration limited
- Configuration class inheritance can become complex for many environments
- Error handlers in blueprints don't catch application-level errors
- Context locals (g, request) only accessible within application context
- Template inheritance chains should stay shallow (< 3 levels)

---

**Pattern**: Application Factory + Blueprints | **Configuration**: Environment-based | **Last Updated**: March 2, 2026
