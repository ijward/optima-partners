# Web/UI Component Library

## Purpose

Reusable UI component patterns using Flask Jinja2 templates. Templates for headers, forms, modals, tables with consistent styling and behavior.

## When to Use

- Building consistent UI across Flask pages
- Reducing template duplication with components
- Creating forms with validation and error handling
- Rapid feature development with pre-built components

## Core Concepts

- **Template Inheritance**: Base templates with block extension
- **Jinja2 Macros**: Reusable template functions for components
- **Props Pattern**: Parameters passed like React props
- **Include Patterns**: Modular component organization
- **Semantic HTML**: Accessibility and SEO-friendly elements

## Reference Examples

### Base Template

```html
<!DOCTYPE html>
<html>
<head><title>{% block title %}App{% endblock %}</title></head>
<body>
  {% include 'header.html' %}
  <main>{% block content %}{% endblock %}</main>
  {% include 'footer.html' %}
</body>
</html>
```

### Button and Form Macros

```html
{% macro button(text, type='button', classes='btn-primary', url=None) %}
  {% if url %}
    <a href="{{ url }}" class="btn {{ classes }}">{{ text }}</a>
  {% else %}
    <button type="{{ type }}" class="btn {{ classes }}">{{ text }}</button>
  {% endif %}
{% endmacro %}

{% macro form_field(field, classes='') %}
  <div class="form-group">
    {% if field.type != 'HiddenField' %}
      <label for="{{ field.id }}">{{ field.label.text }}
        {% if field.flags.required %}<span class="required">*</span>{% endif %}
      </label>
    {% endif %}
    {{ field(class='form-control ' + classes) }}
    {% if field.errors %}
      <div class="form-error">
        {% for error in field.errors %}<p>{{ error }}</p>{% endfor %}
      </div>
    {% endif %}
  </div>
{% endmacro %}
```

### Table and Other Components

```html
{% macro data_table(items, columns, actions_url=None) %}
  <table class="table">
    <thead><tr>{% for col in columns %}<th>{{ col.label }}</th>{% endfor %}</tr></thead>
    <tbody>{% for item in items %}<tr>{% for col in columns %}<td>{{ item[col.key] }}</td>{% endfor %}</tr>{% endfor %}</tbody>
  </table>
{% endmacro %}

{% macro modal(title, id, content) %}
  <div class="modal" id="{{ id }}"><div class="modal-header">{{ title }}</div><div class="modal-body">{{ content }}</div></div>
{% endmacro %}
```

### Usage Pattern

```html
{% extends 'base.html' %}
{% from 'buttons.html' import button %}
{% from 'table.html' import data_table %}

{% block content %}
  <h1>Products</h1>
  {{ button('Add', url=url_for('create')) }}
  {{ data_table(products, columns=[{'key': 'name', 'label': 'Name'}]) }}
{% endblock %}
```

## Common Pitfalls

- Overly complex macros; keep parameters focused
- Logic in templates; move to views instead
- Missing defaults on optional parameters
- Duplicated template blocks; extract to macros/includes
- Ignoring accessibility; add labels and ARIA attributes
- No component documentation

## Dependencies

- **Flask**: `pip install Flask` (includes Jinja2)
- **WTForms**: `pip install WTForms` (for form components)
- **Jinja2**: Filters, tests, syntax reference

## Limitations

- Less powerful than React/Vue frameworks
- Server-side rendering can add latency
- Client-side interactivity requires separate JS
- Macro inheritance has composition limits
- Large libraries require versioning discipline

---

**Engine**: Jinja2 | **Pattern**: Macros + Template Inheritance + includes | **Last Updated**: March 2, 2026
