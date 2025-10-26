SELECT ch.HQCountry, COUNT(*) AS TotalCompanies
FROM pitchbook_db.Company c
JOIN pitchbook_db.CompanyIndustryInfo cii ON c.CompanyID = cii.CompanyID
JOIN pitchbook_db.CompanyHQinfo ch ON c.CompanyID = ch.CompanyID
JOIN pitchbook_db.CompanyFinancialInfo cfi ON c.CompanyID = cfi.CompanyID
WHERE c.YearFounded >= 2020
  AND ch.HQCountry IN ('Norway', 'Estonia', 'Netherlands', 'Germany', 'United Kingdom', 'United States', 'Spain', 'Portugal', 'Italy')
  AND cii.PrimaryIndustrySector = 'Information Technology'
  AND c.TotalRaised IS NOT NULL
GROUP BY 1
ORDER BY 2;


