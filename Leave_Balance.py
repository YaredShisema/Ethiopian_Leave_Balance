import datetime

def generate_series(n):
    series = [16]  # Initialize the series with the first value
    increment = 16  # Initial increment value
    
    for i in range(1, n):
        if i % 2 == 1:  # Odd year
            series.append(series[-1] + increment)  # Add the increment value
            increment += 1  # Increase the increment value for the next odd year
        else:  # Even year
            series.append(series[-1] + increment)  # Add the current value without an increment
    
    return series

input_date_str = input("Enter a date (YYYY-MM-DD): ")
input_date = datetime.datetime.strptime(input_date_str, "%Y-%m-%d")
currentDate = datetime.datetime.now()


num_years = currentDate.year - input_date.year
num_months = num_years * 12 + currentDate.month - input_date.month
num_days = num_years * 365 + currentDate.day - input_date.day

series = generate_series(num_years)

if num_years > 0 and num_years <= len(series):
    Year_Balance = series[-1]
    Monthly_Balance = (Year_Balance / (num_years*12)) * num_months
    Day_balance = (Year_Balance / (num_years * 365)) * num_days
    print("Year Balance:", Year_Balance)
    print("Monthly Balance:", Monthly_Balance)
    print("Day Balance:", Day_balance)
    print("No of Month:", num_months)
    print("No of days:", num_days)
  
else:
    print("Invalid input. The calculated number of years is out of range.")
