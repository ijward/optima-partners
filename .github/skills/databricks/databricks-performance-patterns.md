# DataBricks Performance Patterns

## Purpose
Best practices and design patterns for optimizing DataBricks job performance, infrastructure utilization, and query execution across production ETL and analytics workloads.

## When to Use
- Designing efficient data pipelines and transformation logic
- Configuring clusters for specific workload types
- Implementing caching and memoization strategies
- Building scalable SQL queries and Spark jobs
- Establishing performance baselines and SLAs

## Core Concepts
- **Partitioning Strategy**: Organizing data by query patterns; improves partition pruning efficiency
- **Bucketing**: Hash-based partitioning for optimized joins; pre-sorts data
- **Caching**: Persisting intermediate results with appropriate storage levels
- **Shuffle Optimization**: Minimizing data movement between nodes; use broadcast joins
- **SQL Hints**: Explicit optimizer direction (join order, broadcast hints)

## Reference Examples

### Efficient Join with Broadcast Hint (PySpark)
```python
large_df = spark.read.table("large_table")
small_df = spark.read.table("lookup_table")

# Force broadcast of smaller table
result = large_df.join(
    F.broadcast(small_df),
    on="key",
    how="left"
)
# Result: Avoids expensive shuffle; each executor gets small_df copy
```

### Partition and Cache Strategy
```python
# Read data partitioned by date
df = spark.read.table("events") \
    .filter(F.col("date") >= "2024-01-01") \
    .repartition(100, "event_id")  # Repartition for better parallelism

# Cache the intermediate result
df.persist(pyspark.StorageLevel.MEMORY_AND_DISK)

# Perform multiple aggregations on cached data
daily_summary = df.groupBy("date").agg(F.count("*"))
hourly_summary = df.groupBy("date", "hour").agg(F.avg("duration"))

df.unpersist()  # Release cache when done
```

### SQL Window Functions (Efficient)
```sql
-- Compute aggregations and rankings in single pass
SELECT 
  transaction_id,
  customer_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id ORDER BY date) as running_total,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY date) as seq
FROM transactions
WHERE year = 2024;
-- Single shuffle; efficient computation
```

## Common Pitfalls
- **Collect to Driver**: Using `.collect()` on large DataFrames; moves data to driver memory
- **Unnecessary Shuffles**: Multiple groupBy operations; combine into single operation
- **Wrong Partitioning**: Partitioning by high-cardinality columns; creates thousands of tiny files
- **Cache Persistence**: Forgetting to unpersist; can cause memory issues downstream
- **Implicit Type Conversions**: Using strings instead of native types; adds serialization overhead
- **Correlated Subqueries**: Nested queries with correlations; rewrite as joins

## Dependencies
- **Delta Lake**: For ACID guarantees and partition pruning
- **Databricks SQL Warehouse**: SQL-based optimization and monitoring
- **Apache Spark**: Core execution engine and optimization
- **PySpark/Scala**: For programmatic optimization (UDFs, custom logic)

## Limitations
- Some optimizations trade memory for speed; cluster size matters
- Partitioning strategy requires knowledge of query patterns
- Caching adds complexity; profile to ensure net benefit
- Some workloads fundamentally need resources (no magic optimization)
- Cloud storage I/O still disk-bound; optimization has limits

---

**Patterns**: Broadcast Joins, Partitioning, Window Functions, Bucketing | **Last Updated**: March 2, 2026
