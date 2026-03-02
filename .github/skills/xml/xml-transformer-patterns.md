# XML Transformer Patterns

## Purpose
Reference patterns for transforming XML documents using XPath/XSLT and converting between XML and other formats (JSON, CSV, plain text).

## When to Use
- Converting API responses from XML to JSON/CSV for downstream processing
- Applying complex structural transformations using XSLT
- Extracting and reformatting specific data from XML sources
- Integrating with systems expecting different data formats
- Building ETL pipelines with format conversion steps

## Core Concepts
- **XPath**: Query language for selecting elements, attributes, and text nodes
- **XSLT**: XML transformation language; powerful but steep learning curve
- **Element Mapping**: Direct field-to-field transformation between formats
- **Hierarchical Flattening**: Converting nested structures to flat formats (CSV)
- **Format Normalization**: Standardizing data representation across systems

## Reference Examples

### XPath + Python to JSON
```python
from lxml import etree
import json

tree = etree.parse('products.xml')
root = tree.getroot()

products = []
for product in root.xpath('//product[@available="true"]'):
    products.append({
        'id': product.xpath('string(@id)'),
        'name': product.xpath('string(name)'),
        'price': float(product.xpath('string(price)')),
        'tags': product.xpath('tag/text()')  # List of tags
    })

with open('output.json', 'w') as f:
    json.dump(products, f, indent=2)
```

### XML to CSV (Flattening)
```python
import csv
from lxml import etree

tree = etree.parse('data.xml')
root = tree.getroot()

with open('output.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id', 'name', 'price', 'category'])
    
    for product in root.findall('product'):
        writer.writerow([
            product.get('id'),
            product.find('name').text,
            product.find('price').text,
            product.find('category').text
        ])
```

### XSLT Transformation (Template-based)
```xml
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <json>
      <xsl:for-each select="//product">
        <product>
          <id><xsl:value-of select="@id"/></id>
          <name><xsl:value-of select="name"/></name>
          <price><xsl:value-of select="price * 1.1"/></price>
        </product>
      </xsl:for-each>
    </json>
  </xsl:template>
</xsl:stylesheet>
```

## Common Pitfalls
- **Namespace Handling**: Forgetting namespaces in XPath expressions; use namespace maps
- **Type Conversion**: Not handling type conversions when moving to JSON/CSV; explicitly cast values
- **Large Document Memory**: XSLT in-memory processing can overflow; use streaming for large files
- **Complex Nesting**: Flattening deeply nested structures loses hierarchical information
- **Performance Bottlenecks**: Complex XSLT templates slow; profile and optimize XPath expressions
- **Lossy Transformation**: Converting hierarchical XML to flat CSV loses structure; document limitations

## Dependencies
- **lxml**: `pip install lxml` (XPath, XSLT support)
- **xmltodict**: `pip install xmltodict` (quick XML-to-dict conversion)
- **Saxon**: XSLT processor for complex stylesheet needs
- **Python xml.etree**: Built-in basic XSLT support

## Limitations
- XSLT steep learning curve; simpler transformations better with Python
- XPath performance degrades on complex queries and large documents
- Some XML-to-JSON conversions lose type information (all strings in CSV)
- Streaming transformations miss context needed for complex logic
- Bidirectional transformations (XML ↔ JSON) not lossless

---

**Standards**: XPath 2.0, XSLT 1.0 | **Tools**: Saxon, lxml, xmltodict | **Last Updated**: March 2, 2026
