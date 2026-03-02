# DataBricks Optimization Checklist

## Purpose

Systematic 5-phase audit and optimization process for DataBricks workloads. Actionable checklist for identifying and implementing performance and cost improvements.

## When to Use

- Production optimization initiatives or cost reduction projects
- Regular auditing of existing deployments
- Onboarding teams to best practices

## Core Concepts

### Phase 1: Assessment

- [ ] List all jobs/queries to optimize
- [ ] Measure baseline: duration, cost, volume
- [ ] Set targets for improvement
- [ ] Enable monitoring and cost tracking
- [ ] Profile top 5 expensive workloads

### Phase 2: Analysis

- [ ] Review query execution plans for inefficiencies
- [ ] Detect data skew and task imbalance
- [ ] Check cluster CPU/memory utilization
- [ ] Analyze join costs and shuffles
- [ ] Review partition strategy alignment

### Phase 3: Optimization

- [ ] Add partition filters to queries
- [ ] Apply broadcast joins for small lookup tables
- [ ] Implement bucketing for frequent joins
- [ ] Cache frequently-used results
- [ ] Optimize join ordering (broadcast small tables first)
- [ ] Use Delta optimization (`OPTIMIZE` command)

### Phase 4: Validation

- [ ] Re-run profiled queries; measure improvement
- [ ] Verify result correctness (before/after)
- [ ] Compare DBU consumption
- [ ] Monitor for regressions
- [ ] Document changes and results

### Phase 5: Sustainment

- [ ] Set performance and cost alerts
- [ ] Schedule quarterly reviews
- [ ] Update runbooks with new patterns
- [ ] Share learnings across teams
- [ ] Track KPIs over time

## Reference Examples

| Metric | Healthy | Warning |
| ------ | ------- | -------- |
| CPU Utilization | 60-80% | <40% or >90% |
| Memory Utilization | 50-75% | <30% or >85% |
| Shuffle Ratio | <2x | >5x |
| Query Duration Trend | Stable/improving | +20% increase |
| Task Duration Variance | <2x | >10x (skew) |

## Quick Wins

1. Partition filters: 5-50% speedup
2. Broadcast joins: 2-10x speedup
3. Reduce over-provisioned workers: 20-40% savings
4. Enable Delta statistics: Instant gains
5. Handle hot partitions: Parallel processing

## Common Pitfalls

- Optimizing non-critical queries; focus on expensive 20%
- Skipping downstream testing; changes can cascade
- Same strategy for all workloads; profile individually
- No baseline measurements; can't prove ROI
- Skipping follow-up reviews; degradation is inevitable

## Dependencies

- **Databricks**: Job history and SQL insight
- **Delta Lake**: Optimization and pruning commands
- **Spark UI**: Query diagnostics
- **Monitoring**: Databricks, Grafana, or DataDog

## Limitations

- Complex workloads require iterative tuning
- Network and I/O can be bottlenecks
- Cost reduction varies by cluster type

---

**Process**: Assess → Analyze → Optimize → Validate → Sustain | **Effort**: 1-2 weeks per project | **Last Updated**: March 2, 2026
