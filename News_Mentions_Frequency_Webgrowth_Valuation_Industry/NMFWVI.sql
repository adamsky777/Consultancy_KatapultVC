SELECT 
    c.CompanyID, 
    c.Frequency, 
    cfi.LastKnownValuation, 
    cfi.Revenue, 
    c.CompanyName, 
    coi.WebGrowthRate,
    cii.PrimaryIndustrySector
FROM (
    SELECT 
        cnf.CompanyID, cnf.Frequency, cbs.BusinessStatus, c.CompanyName
    FROM 
        CompanyNewsFrequency cnf
    JOIN 
        Company c ON cnf.CompanyID = c.CompanyID  
    JOIN
    	CompanyBusinessStatus cbs on cbs.CompanyID = c.CompanyID
    Where
        cbs.BusinessStatus != 'Out of business'
 ) as c
JOIN 
    CompanyBusinessStatus cbs ON cbs.CompanyID = c.CompanyID
JOIN 
    CompanyFinancialInfo cfi ON cfi.CompanyID = c.CompanyID
JOIN 
    CompanyIndustryInfo cii ON cii.CompanyID = c.CompanyID
JOIN 
    CompanyOnlineInfo coi ON coi.CompanyID = c.CompanyID
