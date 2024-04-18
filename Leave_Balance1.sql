DECLARE @input_date_str VARCHAR(10);
SET @input_date_str = '2020-01-17'; -- Replace 'YYYY-MM-DD' with the desired input date

DECLARE @currentDate DATE;
SET @currentDate = GETDATE();

DECLARE @input_date DATE;
SET @input_date = CAST(@input_date_str AS DATE);

DECLARE @num_years INT;
DECLARE @num_months INT;
DECLARE @num_days INT;

IF @input_date <= @currentDate
BEGIN
    SET @num_years = YEAR(@currentDate) - YEAR(@input_date);
    
    IF @num_years = 0
    BEGIN
        SET @num_months = @num_years * 12 + MONTH(@currentDate) - MONTH(@input_date);
        SET @num_days = @num_months * 30 + DAY(@currentDate) - DAY(@input_date);
    END
    ELSE
    BEGIN
        SET @num_months = @num_years * 12 + MONTH(@currentDate) - MONTH(@input_date);
        SET @num_days = @num_years * 365 + DAY(@currentDate) - DAY(@input_date);
    END
END
ELSE
BEGIN
    SET @num_years = -1;
    SET @num_months = -1;
    SET @num_days = -1;
END

DECLARE @series TABLE (value INT);
DECLARE @i INT = 1;
DECLARE @prev_value INT = 0;
DECLARE @increment INT = 16;

WHILE @i <= @num_years
BEGIN
    IF @i % 2 = 1 -- Odd iteration
    BEGIN
        SET @prev_value = @prev_value + @increment;
        INSERT INTO @series (value) VALUES (@prev_value);
    END
    ELSE -- Even iteration
    BEGIN
        SET @prev_value = @prev_value + @increment;
        INSERT INTO @series (value) VALUES (@prev_value);
        SET @increment = @increment + 1;
    END;

    SET @i = @i + 1;
END;

IF @num_years >= 0 AND @num_years <= (SELECT COUNT(*) FROM @series)
BEGIN
    DECLARE @Year_Balance INT;
    DECLARE @Monthly_Balance DECIMAL(10, 2);
	DECLARE @Monthly_Balance1 DECIMAL(10, 2);
    DECLARE @Day_Balance DECIMAL(10, 2);
	DECLARE @Day_Balance1 DECIMAL(10, 2);
	DECLARE @hour_Balance INT = 24;
    
    SET @Year_Balance = (SELECT value FROM (SELECT ROW_NUMBER() OVER (ORDER BY value) AS rn, value FROM @series) AS subquery WHERE rn = @num_years);

    SET @Monthly_Balance = (@Year_Balance / (@num_years * 12.0)) * @num_months;
	SET @Monthly_Balance1 = (@num_months / (@num_months * 30.0)) * @num_days;
    SET @Day_Balance = (@Year_Balance / (@num_years * 365.0)) * @num_days;
	SET @Day_Balance1 = (@num_days / (@num_days * 24.0)) * @num_days;
    
    SELECT   CASE WHEN @num_years = 0 THEN 0 ELSE @num_years END AS No_of_Years,
             CASE WHEN @num_years = 0 THEN 0 ELSE @Year_Balance END AS Year_Balance,
             CASE WHEN @num_years = 0 THEN  @num_months ELSE @num_months END AS No_of_Months,
             CASE WHEN @num_years = 0 THEN  @Monthly_Balance1 ELSE @Monthly_Balance END AS Monthly_Balance,
             CASE WHEN @num_years = 0 THEN  @num_days ELSE @num_days END AS No_of_Days,
             CASE WHEN @num_years = 0 THEN  @Day_Balance1 ELSE @Day_Balance END AS Day_Balance;
			 
END
ELSE
    PRINT 'Invalid input. The calculated number of years is out of range.';
