WITH ActiveCompanies AS (
    SELECT
        pc.CompanyID,
        cbs.BusinessStatus,
        cbs.BusinessStatusDate
    FROM
        pitchbook_db.Company AS pc
        JOIN pitchbook_db.CompanyBusinessStatus AS cbs ON pc.CompanyID = cbs.CompanyID
        JOIN pitchbook_db.PortfolioUpdated pu ON pc.CompanyID = pu.CompanyID
    WHERE
        cbs.BusinessStatus NOT IN ('Out of Business', 'Bankruptcy: Admin/Reorg', 'Bankruptcy')
),
RankedDeals AS (
    SELECT
        c.CompanyName,
        c.CompanyID,
        c.YearFounded,
        c.TotalRaised,
        cfi.EnterpriseValue,
        cfi.Revenue,
        c.Employees,
        coi.GrowthRate,
        cii.PrimaryIndustryGroup,
        ac.BusinessStatus,
        ac.BusinessStatusDate,
        coi.WebGrowthRate,
        coi.SocialGrowthRate,
        c.LastUpdated,
        cfi.FirstFinancingSize,
        cfi.FirstFinancingDate,
        cfi.LastFinancingSize,
        cfi.LastFinancingDate,
        cfi.LastKnownValuation,
        d.VCRound,
        d.TotalInvestedEquity,
        d.TotalInvestedCapital,
        d.Dealsize,
        dti.DealType,
        c.Website,
        ROW_NUMBER() OVER (PARTITION BY c.CompanyID ORDER BY d.DealDate DESC) AS rn
    FROM
        ActiveCompanies ac
        JOIN pitchbook_db.Company AS c ON ac.CompanyID = c.CompanyID
        JOIN pitchbook_db.CompanyFinancialInfo AS cfi ON c.CompanyID = cfi.CompanyID
        JOIN pitchbook_db.CompanyOnlineInfo AS coi ON c.CompanyID = coi.CompanyID
        JOIN pitchbook_db.CompanyIndustryInfo cii ON c.CompanyID = cii.CompanyID
        JOIN pitchbook_db.Deal d ON c.CompanyID = d.CompanyID
        JOIN pitchbook_db.DealTypeInfo dti ON dti.DealID = d.DealID
)
SELECT
    CompanyName,
    CompanyID,
    YearFounded,
    TotalRaised,
    EnterpriseValue,
    Revenue,
    Employees,
    GrowthRate,
    PrimaryIndustryGroup,
    BusinessStatus,
    BusinessStatusDate,
    WebGrowthRate,
    SocialGrowthRate,
    LastUpdated,
    FirstFinancingSize,
    FirstFinancingDate,
    LastFinancingSize,
    LastFinancingDate,
    LastKnownValuation,
    VCRound,
    TotalInvestedEquity,
    TotalInvestedCapital,
    Dealsize,
    DealType,
    Website
FROM
    RankedDeals
WHERE
    rn = 1;
