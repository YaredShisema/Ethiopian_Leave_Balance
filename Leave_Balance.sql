DECLARE @input_date_str VARCHAR(10);
SET @input_date_str = '2004-04-17'; -- Replace 'YYYY-MM-DD' with the desired input date

DECLARE @currentDate DATE;
SET @currentDate = GETDATE();

DECLARE @input_date DATE;
SET @input_date = CAST(@input_date_str AS DATE);

DECLARE @num_years INT;
SET @num_years = YEAR(@currentDate) - YEAR(@input_date);

DECLARE @num_months INT;
SET @num_months = @num_years * 12 + MONTH(@currentDate) - MONTH(@input_date);

DECLARE @num_days INT;
SET @num_days = @num_years * 365 + DAY(@currentDate) - DAY(@input_date);

DECLARE @series TABLE (value INT)
DECLARE @i INT = 1
DECLARE @prev_value INT = 0
DECLARE @increment INT = 16

WHILE @i <= @num_years
BEGIN
    IF @i % 2 = 1 -- Odd iteration
    BEGIN
        SET @prev_value = @prev_value + @increment
        INSERT INTO @series (value) VALUES (@prev_value)
    END
    ELSE -- Even iteration
    BEGIN
        SET @prev_value = @prev_value + @increment
        INSERT INTO @series (value) VALUES (@prev_value)
        SET @increment = @increment + 1
    END

    SET @i = @i + 1
END


IF @num_years > 0 AND @num_years <= (SELECT COUNT(*) FROM @series)
BEGIN
    DECLARE @Year_Balance INT;
    DECLARE @Monthly_Balance DECIMAL(10, 2);
	DECLARE @Day_Balance DECIMAL(10, 2);
    
	SET @Year_Balance = (SELECT value FROM (SELECT ROW_NUMBER() OVER (ORDER BY value) AS rn, value FROM @series) AS subquery WHERE rn = @num_years);

    
    SET @Monthly_Balance = (@Year_Balance / (@num_years * 12)) * @num_months;

	SET @Day_Balance = (@Year_Balance / (@num_years * 365.0 )) * @num_days;
    
    SELECT   @num_years AS No_of_Years,
			 @Year_Balance AS Year_Balance,
			 @num_months AS No_of_Month,
			 @Monthly_Balance AS Monthly_Balance,
			 @num_days AS No_of_days,
			 @Day_Balance AS Day_Balance;
			 
END
ELSE
    PRINT 'Invalid input. The calculated number of years is out of range.';
