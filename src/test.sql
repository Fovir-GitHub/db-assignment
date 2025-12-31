-- SOURCE ./src/create.sql;
-- SOURCE ./src/insert.sql;

-- SELECT * FROM fee ORDER BY CONCAT(semester_year, '/', semester_month), payment_status;

SELECT CONCAT(semester_year, '/', semester_month) AS 'Semester',
  payment_status AS `Payment Status`,
  SUM(
    ROUND(
      total_fee * (1.0 - discount), 2
    )
  ) AS `Total Fees`
  FROM fee
  GROUP BY `Semester`, `Payment Status`
  ORDER BY `Semester`;
