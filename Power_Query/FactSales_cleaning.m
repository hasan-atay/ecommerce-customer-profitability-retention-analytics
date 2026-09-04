// FactSales_cleaning.m
let
    Source = Csv.Document(
        File.Contents("data/FactSales.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Types = Table.TransformColumnTypes(
        Headers,
        {
            {"OrderID", type text}, {"OrderDate", type date},
            {"CustomerID", type text}, {"ProductID", type text},
            {"Quantity", Int64.Type}, {"DiscountRate", type number},
            {"GrossSales", type number}, {"DiscountValue", type number},
            {"NetSales", type number}, {"COGS", type number},
            {"ShippingCost", type number}, {"PaymentCost", type number}
        }
    ),
    Trimmed = Table.TransformColumns(
        Types,
        {{"OrderID", Text.Trim}, {"CustomerID", Text.Trim}, {"ProductID", Text.Trim}}
    ),
    ValidRows = Table.SelectRows(Trimmed, each [OrderID] <> null and [CustomerID] <> null and [ProductID] <> null)
in
    ValidRows
