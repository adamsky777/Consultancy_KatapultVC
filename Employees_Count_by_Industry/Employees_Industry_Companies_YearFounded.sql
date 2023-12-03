SELECT
	c.CompanyName,
    c.YearFounded,
    c.Employees,
    cnf.Frequency,
    cii.PrimaryIndustrySector
FROM
    pitchbook_db.Company c
JOIN
	pitchbook_db.CompanyNewsFrequency cnf on cnf.CompanyID = c.CompanyID 
JOIN
    pitchbook_db.CompanyIndustryInfo cii ON c.CompanyID = cii.CompanyID
ORDER BY
    3 DESC;
    
