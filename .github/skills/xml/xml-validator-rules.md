# XML Validator Rules

## Purpose
Patterns and practices for validating XML documents against schemas, implementing custom validation rules, and ensuring data quality across workflows.

## When to Use
- Validating XML against XSD schemas before data processing
- Implementing business rule validation on XML documents
- Enforcing data quality standards in ETL pipelines
- Detecting malformed or incomplete XML documents
- Building compliance checks for regulated data

## Core Concepts
- **XSD (Schema)**: Define element structure, data types, and constraints; most common validation method
- **DTD (Document Type Definition)**: Legacy but still used; defines allowed elements and document structure
- **Schematron**: Rule-based validation; excellent for business logic constraints
- **Custom Validators**: Programmatic validation for complex domain-specific rules
- **Error Reporting**: Detailed validation messages for debugging and compliance auditing

## Reference Examples

### XSD Validation (Python)
```python
from lxml import etree

# Load schema
schema_doc = etree.parse('schema.xsd')
schema = etree.XMLSchema(schema_doc)

# Validate document
doc = etree.parse('data.xml')
if schema.validate(doc):
    print("Valid!")
else:
    for error in schema.error_log:
        print(f"Error at line {error.line}: {error.message}")
```

### Custom Python Validation
```python
def validate_product_xml(xml_file):
    tree = etree.parse(xml_file)
    root = tree.getroot()
    
    errors = []
    for product in root.findall('product'):
        name = product.find('name')
        price = product.find('price')
        
        # Custom rules
        if name is None or not name.text:
            errors.append(f"Product missing name")
        if price is None or float(price.text) <= 0:
            errors.append(f"Product {name.text} has invalid price")
    
    return len(errors) == 0, errors
```

### Schematron Example (Business Rules)
```xml
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:pattern id="business_rules">
    <sch:rule context="product">
      <sch:assert test="price &gt; cost">
        Product price must be greater than cost
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
```

## Common Pitfalls
- **Namespace Mismatches**: Schema and document use different namespace URIs; ensure alignment
- **Missing Schema Resources**: XSD imports/includes not accessible; provide absolute paths
- **Overly Broad Schemas**: Schemas too permissive; use minOccurs, maxOccurs, and restrictions
- **Poor Error Messages**: Generic validation errors; implement custom reporting for clarity
- **Performance Issues**: Validating large batches sequentially; batch validate in parallel when possible

## Dependencies
- **lxml**: `pip install lxml` (XSD, DTD validation)
- **xmlschema**: `pip install xmlschema` (alternative XSD validator)
- **Oxygen XML**: Commercial tool for schema design and validation UI

## Limitations
- XSD schemas can become complex; design simple, maintainable schemas
- Custom validation logic may not scale to very large documents
- Schematron requires XSLT processing; adds complexity
- Some validation rules are better implemented at data model layer
- Performance impact with deeply nested validations

---

**Standards**: XSD 1.1, DTD, Schematron | **Libraries**: lxml, xmlschema | **Last Updated**: March 2, 2026
