# DataBricks Efficiency Analysis

## Purpose

Patterns for identifying inefficiency sources, cost drivers, and optimization opportunities in DataBricks workloads through profiling, monitoring, and root cause analysis.

## When to Use

- Investigating why specific queries or jobs run slowly
- Finding cost optimization opportunities in existing workloads
- Diagnosing cluster over-provisioning or underutilization
- Identifying data transfer bottlenecks and network issues
- Profiling jobs before and after optimization attempts

## Core Concepts

- **Spark UI Analysis**: Viewing task execution graphs, stage metrics, and task timings
- **Query Plans**: Examining logical and physical execution plans for inefficiencies
- **Bottleneck Detection**: Identifying stages consuming most CPU, memory, or network resources
- **Data Profiling**: Analyzing data distribution, skew, and partitioning effectiveness
- **Cost Attribution**: Mapping expensive operations to business logic and queries

## Reference Examples

### Examine Query Plan

```sql
EXPLAIN EXTENDED
SELECT customer_id, SUM(amount) as total
FROM transactions
WHERE year = 2024
GROUP BY customer_id;

-- Look for: Scans without pushdown, shuffles, broadcasts of large tables
-- Red flags: Full table scans, cartesian products, unpartitioned aggregations
```

### Identify Data Skew (PySpark)

```python
from pyspark.sql import functions as F

# Find skewed partitions
df.groupBy("partition_column").count().describe().show()

# Check execution: watch for few tasks handling far more data than others
# Solution: repartition with salting or change partitioning strategy
df.repartition(200, "partition_column").write.mode("overwrite").path
```

### Check Cluster Utilization

```python
# Monitor via Spark UI metrics or Databricks SQL
SELECT 
  SUM(task_memory_used) as total_mem_gb,
  COUNT(*) as num_tasks,
  MAX(task_duration_ms) as max_task_time_ms
FROM system.query.executor_metrics
WHERE query_timestamp > current_timestamp() - INTERVAL 1 HOUR;
```

## Common Pitfalls

- **Missing Join Order Analysis**: Not examining join order in execution plan; reorder large-to-small
- **Ignoring Partition Pruning**: Queries reading entire partitions unnecessarily; add partition filters
- **Broadcasting Large Tables**: Default behavior may cause OOM; use `broadcast()` hint explicitly
- **No Data Locality**: Shuffling data across regions; co-locate compute and storage
- **Inefficient Aggregations**: Multiple passes over data; combine aggregations into single query
- **Task Imbalance**: Skewed data causing few tasks to process majority; implement salting or repartitioning

## Dependencies

- **Spark UI**: Built-in Databricks diagnostic tool
- **Delta Lake Statistics**: `ANALYZE TABLE` for optimizer hints
- **Databricks SQL Warehouse**: For query performance monitoring
- **DBUtils Secrets**: For accessing monitoring APIs securely

## Limitations

- Spark UI only shows recent history; use Delta Lake logs for comprehensive auditing
- Cost analysis requires proper tagging and DBU tracking setup
- Large-scale analysis of terabyte datasets can be expensive itself
- Some efficiency issues require data model changes, not just query optimization
- External system integration issues may limit optimization potential

---

**Tools**: Spark UI, Databricks SQL, Delta Lake Log | **Metrics**: Tasks, Shuffle Size, Memory Usage | **Last Updated**: March 2, 2026
