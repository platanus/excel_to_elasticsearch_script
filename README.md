# Excel to Elasticsearch

## Usage

### Generating a configuration

```ruby
ruby add_to_index generate_config your_excel.xlsx new_config.yml
```

Example configuration file:

```yaml
---
index: 'index_name'
url: 'http://localhost:9200'
type: 'data_type'
bulk_size: 100 # size of batch upload
columns:
  Row ID:
    type: float
  Order Date:
    type: date
  Order Year:
    type: string
    calculated: true
    formula: self["Order Date"].year
```

In `calculated` columns, you can use any ruby methods taking into account that `self` refers to the current processed row.

### Uploading a file

```ruby
ruby add_to_index upload your_excel.xlsx new_config.yml
```

You can pass some additional options:
- `-v` To put elasticsearch in verbose mode
- `-r` To replace the index (drop and recreate)
