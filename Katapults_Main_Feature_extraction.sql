SELECT 
    c.CompanyName, 
    c.CompanyID,
    c.YearFounded , 
	c.TotalRaised, 
    cfi.EnterpriseValue, 
    cfi.Revenue,
    c.TotalRaised,
    c.YearFounded,
    c.Employees,
    coi.GrowthRate,
    cii.PrimaryIndustryGroup,
    ac.BusinessStatus,  -- Take the business status from the "ac" Active companies main query
    ac.BusinessStatusDate, -- Same for the date
    coi.WebGrowthRate,
    coi.GrowthRate,
    coi.SocialGrowthRate,
    coi.WebGrowthRate,
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
    c.Website
FROM 
    (
        SELECT pc.CompanyID, cbs.BusinessStatus, cbs.BusinessStatusDate
        FROM pitchbook_db.Company AS pc
        JOIN pitchbook_db.CompanyBusinessStatus AS cbs ON pc.CompanyID = cbs.CompanyID
        JOIN pitchbook_db.PortfolioUpdated pu on pc.CompanyID = pu.CompanyID
        where cbs.BusinessStatus NOT in  ('Out of Business', 'Bankruptcy: Admin/Reorg', 'Bankruptcy')
    ) AS ac  -- Refer to as "ac" Active Companies that are NOT out of business 
JOIN 
    pitchbook_db.Company AS c ON ac.CompanyID = c.CompanyID  -- Join the active companies with the Company table
JOIN 
    pitchbook_db.CompanyFinancialInfo AS cfi ON c.CompanyID = cfi.CompanyID 
JOIN 
    pitchbook_db.CompanyOnlineInfo AS coi ON c.CompanyID = coi.CompanyID 
JOIN 
	pitchbook_db.CompanyIndustryInfo cii on c.CompanyID = cii.CompanyID
JOIN
	pitchbook_db.Deal d on c.CompanyID = d.CompanyID
JOIN 
	pitchbook_db.DealTypeInfo dti on dti.DealID = d.DealID
