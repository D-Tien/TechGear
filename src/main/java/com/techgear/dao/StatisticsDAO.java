package com.techgear.dao;

import java.util.Map;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;

/** Skeleton only: return values do not represent database results. */
public class StatisticsDAO {
    public StatisticsDAO() { }

    public BigDecimal getTotalRevenue(LocalDateTime fromInclusive, LocalDateTime toExclusive) {
        // TODO: Implement JDBC operation with parameterized statements.
        return BigDecimal.ZERO;
    }

    public int getOrderCount(LocalDateTime fromInclusive, LocalDateTime toExclusive) {
        // TODO: Implement JDBC operation with parameterized statements.
        return 0;
    }

    public int getCustomerCount() {
        // TODO: Implement JDBC operation with parameterized statements.
        return 0;
    }

    public Map<String, BigDecimal> getMonthlyRevenue(int year) {
        // TODO: Implement JDBC operation with parameterized statements.
        return Collections.emptyMap();
    }
}
