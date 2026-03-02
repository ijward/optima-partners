# XML Parser Utilities

## Purpose

Reference patterns for efficiently parsing XML documents, extracting specific elements, and handling various XML structures using industry-standard libraries and techniques.

## When to Use

- Extracting data from complex XML documents or API responses
- Parsing configuration files in XML format
- Selecting specific elements using XPath queries
- Processing XML files without loading entire document into memory
- Building custom data extraction workflows

## Core Concepts

- **DOM Parsing**: Load entire XML tree; best for small-to-medium documents with frequent random access
- **SAX Parsing**: Event-driven streaming; memory-efficient for large documents
- **XPath Expressions**: Powerful element selection using path syntax (`//element[@attr='value']`)
- **Element Tree**: Python's built-in balanced approach; good performance for most use cases
- **lxml Library**: High-performance parsing with full XPath/XSLT support

## Reference Examples

### Python - ElementTree (Built-in)

```python
import xml.etree.ElementTree as ET

root = ET.parse('data.xml').getroot()
# XPath query to find all products with price > 100
expensive = root.findall('.//product[@price>100]')
for product in expensive:
    name = product.find('name').text
    price = product.get('price')
    print(f"{name}: ${price}")
```

### Python - lxml (Advanced)

```python
from lxml import etree

tree = etree.parse('data.xml')
root = tree.getroot()
# XPath with namespace handling
products = root.xpath('//ns:product[@currency="USD"]', 
                      namespaces={'ns': 'http://example.com/ns'})
for p in products:
    print(etree.tostring(p, pretty_print=True).decode())
```

### Streaming Large Files (SAX)

```python
import xml.sax
from xml.sax.handler import ContentHandler

class ProductHandler(ContentHandler):
    def startElement(self, name, attrs):
        if name == 'product' and float(attrs['price']) > 100:
            print(f"Found: {attrs['name']}")

handler = ProductHandler()
xml.sax.parse('large_file.xml', handler)
```

## Common Pitfalls

- **Namespace Issues**: Forgetting to handle XML namespaces in XPath queries; always include namespace prefix
- **Memory Overflow**: Using DOM parsing on very large files; switch to SAX streaming instead
- **Encoding Problems**: Not specifying encoding when opening files; use `encoding='utf-8'` explicitly
- **Invalid XPath**: Syntax errors in XPath expressions; test with simple queries first
- **Missing Error Handling**: Not catching parsing exceptions; wrap parse operations in try-except blocks

## Dependencies

- **Built-in**: `xml.etree.ElementTree` (Python standard library)
- **Third-party**: `lxml` (high performance), `BeautifulSoup` (flexible), `xmltodict` (dict conversion)

## Limitations

- XML namespaces require special handling
- XPath performance degrades on very complex documents
- Streaming parsers don't support random access to elements
- Built-in ElementTree has limited XPath support (use lxml for full compliance)
- Large XML files can be memory-intensive with DOM parsing

---

**Reference**: XML 1.0 Spec | **Libraries**: lxml, ElementTree | **Last Updated**: March 2, 2026
