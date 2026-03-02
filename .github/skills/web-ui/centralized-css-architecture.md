# Centralized CSS Architecture

## Purpose

Patterns for building scalable CSS systems in Flask applications. Emphasizes SCSS preprocessing, reusable class libraries, and eliminating inline styles for consistent, maintainable styling at scale.

## When to Use

- Establishing consistent design system across web application
- Organizing CSS for teams building multiple pages/features
- Managing theming, colors, typography, and spacing systematically
- Reducing CSS duplication and improving code reusability
- Supporting multiple viewport sizes and accessibility requirements

## Core Concepts

- **CSS Preprocessing (SCSS)**: Variables, mixins, nesting for DRY CSS code
- **Utility-First Classes**: Small, single-purpose classes (spacing, colors, layout)
- **Component Classes**: Semantic classes for UI elements (btn, card, modal)
- **No Inline Styles**: Move all styling to external stylesheets for maintainability
- **Design Tokens**: Centralized definitions for colors, fonts, spacing, breakpoints

## Reference Examples

### SCSS Organization Structure

```scss
// styles/main.scss - Main entry point
@import 'tokens/colors';
@import 'tokens/typography';
@import 'tokens/spacing';
@import 'utilities/layout';
@import 'utilities/colors';
@import 'utilities/spacing';
@import 'components/button';
@import 'components/form';
@import 'components/modal';

// styles/tokens/_colors.scss - Design tokens
$color-primary: #007bff;
$color-secondary: #6c757d;
$color-danger: #dc3545;
$colors: (
  'primary': $color-primary,
  'secondary': $color-secondary,
  'danger': $color-danger
);

// Utility generator
@mixin text-color($name, $color) {
  .text-#{$name} { color: $color; }
}

@each $name, $color in $colors {
  @include text-color($name, $color);
}
```

### Reusable Component Classes

```html
<!-- NO INLINE STYLES -->
<!-- ✗ AVOID -->
<button style="background-color: blue; padding: 10px 20px; border-radius: 4px">
  Click me
</button>

<!-- ✓ CORRECT -->
<button class="btn btn-primary btn-md">
  Click me
</button>
```

### SCSS Button Component

```scss
// styles/components/_button.scss
.btn {
  display: inline-block;
  padding: $spacing-sm $spacing-md;
  border: 1px solid transparent;
  border-radius: $border-radius;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    transform: translateY(-2px);
  }

  &.btn-primary {
    background-color: $color-primary;
    color: white;
    
    &:hover {
      background-color: darken($color-primary, 10%);
    }
  }

  &.btn-md { padding: $spacing-md $spacing-lg; }
  &.btn-sm { padding: $spacing-xs $spacing-sm; }
}
```

## Common Pitfalls

- **Inline Styles**: Scattered styling logic makes maintenance hard; centralize in stylesheets
- **Magic Numbers**: Hardcoded pixel values; use design tokens and SCSS variables
- **CSS Duplication**: Similar rules repeated; leverage mixins and utility classes
- **No Variable Naming Convention**: Inconsistent color/spacing names; establish naming standard
- **Overly Complex Nesting**: SCSS nesting > 3 levels becomes hard to follow; keep structure flat
- **Missing Media Queries**: Responsive design scattered; establish breakpoint tokens
- **Large Stylesheet**: Single CSS file becomes unmaintainable; split by component/concern

## Dependencies

- **SCSS Compiler**: `pip install libsass` or use Node.js `sass` package
- **PostCSS** (optional): For vendor prefixes and CSS optimization
- **Flask-Assets**: `pip install Flask-Assets` for automatic SCSS compilation in Flask

## Limitations

- SCSS compilation adds build step; requires preprocessing before deployment
- Utility-first approach increases HTML class attributes (semantic tradeoff)
- Design tokens require discipline; team must follow conventions
- Large stylesheets still need organization; SCSS alone doesn't solve all problems
- Browser support must be considered when using advanced SCSS features

---

**Approach**: SCSS + Utilities + Components | **Pattern**: Design Tokens + Mixins | **Last Updated**: March 2, 2026
