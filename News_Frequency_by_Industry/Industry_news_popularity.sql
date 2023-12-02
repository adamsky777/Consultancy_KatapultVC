SELECT
    SUM(cnf.Frequency) AS FrequencySum,
    cii.PrimaryIndustrySector
FROM
    pitchbook_db.CompanyNewsFrequency cnf
JOIN
    pitchbook_db.Company c ON c.CompanyID = cnf.CompanyID
JOIN
    pitchbook_db.CompanyIndustryInfo cii ON c.CompanyID = cii.CompanyID
GROUP BY
    cii.PrimaryIndustrySector
ORDER BY
    FrequencySum DESC
