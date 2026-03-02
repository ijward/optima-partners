# Web/UI Flask Skills Platform

## Overview
Flask web development patterns and UI architecture for building scalable, maintainable web applications. This domain covers project structure, routing, component design, and CSS organization for production Flask applications.

## Domain Scope

| Category | Coverage |
|----------|----------|
| **Architecture** | Project structure, blueprints, application factory pattern, configuration management |
| **Routing** | URL routing, request handling, error handling, middleware patterns |
| **UI Components** | Reusable Jinja2 templates, component libraries, form patterns, modal/table components |
| **Styling** | SCSS/CSS preprocessing, centralized CSS architecture, class libraries, no inline styles |
| **Security** | CSRF protection, session management, input validation, template escaping |
| **Performance** | Template optimization, static file handling, caching strategies |

## When to Use This Domain

- **Building New Flask Applications**: Setting up projects with best practices from the start
- **Scaling Existing Apps**: Organizing code as applications grow beyond single file
- **Component Reuse**: Creating UI patterns that scale across multiple pages and features
- **Styling at Scale**: Managing CSS for consistent design without style duplication
- **Team Collaboration**: Standardizing patterns and conventions for multiple developers

## Quick Reference

| Task | Skill | Coverage |
|------|-------|----------|
| Set up project structure and routing | `flask-setup-patterns.md` | Blueprints, application factory, middleware |
| Organize CSS and styling system | `centralized-css-architecture.md` | SCSS, utilities, component classes, no inline styles |
| Build reusable UI elements | `web-ui-component-library.md` | Headers, forms, modals, tables, Jinja2 patterns |

## Available Skills
1. [flask-setup-patterns.md](flask-setup-patterns.md)
2. [centralized-css-architecture.md](centralized-css-architecture.md)
3. [web-ui-component-library.md](web-ui-component-library.md)

## Key Principles
- **Separation of Concerns**: Templates, routes, models, and styles in separate files
- **DRY (Don't Repeat Yourself)**: Reusable components and template inheritance
- **Maintainability**: Organized project structure supports long-term development
- **Performance**: Efficient template rendering and minimal CSS payload
- **Accessibility**: Semantic HTML and ARIA attributes in components

---

**Framework**: Flask | **Template Engine**: Jinja2 | **Last Updated**: March 2, 2026
