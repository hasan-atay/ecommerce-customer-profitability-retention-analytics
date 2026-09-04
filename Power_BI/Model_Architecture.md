# Power BI Model Architecture

## Star schema
FactSales
- DimDate[Date]
- DimCustomer[CustomerID]
- DimProduct[ProductID]

FactReturns
- DimDate[Date]
- DimProduct[ProductID]

FactMarketing
- DimDate[Month]
- DimCustomer[AcquisitionChannel] via channel dimension if needed

## Report pages
01 Executive Command Center
02 Commercial Performance
03 Customer Profitability
04 Retention & Cohorts
05 Discount & Returns
06 Management Actions

## Interaction design
- Global Date / Country / Category / Acquisition Channel slicers
- Drill-through from customer segment to customer detail
- Tooltip pages for margin, retention and discount context
- Page navigation buttons
- KPI definitions documented in the model
