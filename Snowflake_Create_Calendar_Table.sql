CREATE TABLE CALENDAR (
	CALENDAR_ID                 int NOT NULL COMMENT 'Identifier of the calendar entry',
	CALENDAR_DATE               date COMMENT 'Date for which report is generated',
	DAY_OF_YEAR                 int COMMENT 'Day of the year: 1-365',
	DAY_OF_MONTH                int COMMENT 'Day of month: 1-31',
	DAY_OF_WEEK                 int COMMENT 'Day of week: 1-7, where 1 is Sunday',
	DAY_OF_WEEK_NAME            varchar(50) COMMENT 'Name of the weekday',
	DAY_OF_WEEK_NAME_SHORT      varchar(50) COMMENT 'Short name of the weekday',
	FIRST_DAY_OF_MONTH          date COMMENT 'First day of the month',
	FIRST_DAY_OF_QUARTER        date COMMENT 'First day of the quarter',
	FIRST_DAY_OF_YEAR           date COMMENT 'First day of the  year',
	LAST_DAY_OF_MONTH           date COMMENT 'Last day of the month',
	LAST_DAY_OF_MONTH_INDICATOR int COMMENT 'Indicator of the last day of the month',
	MONTH_NUM                   int COMMENT 'Month number: 1-12',
	MONTH_NAME                  varchar(50) COMMENT 'Month name',
	MONTH_NAME_SHORT            varchar(50) COMMENT 'Short name of the month',
	QUARTER                     int COMMENT 'Quarter number: 1-4',
	WEEK_NUMBER                 int COMMENT 'Number of the week: 1-52',
	YEAR_NUM                    int COMMENT 'Year number',
	CONSTRAINT PK_CALENDAR PRIMARY KEY ( CALENDAR_ID )
);

-- Set range
SET RANGE_START_DATE = date'1900-01-01';
SET RANGE_END_DATE = date'2100-01-01';

-- Generate row IDs, generator cannot take variables as parameters
insert into CALENDAR(CALENDAR_ID)
select SEQ8() as id FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- Calculate dates
update CALENDAR set CALENDAR_DATE = $RANGE_START_DATE + CALENDAR_ID;

-- Remove out of range values
delete from CALENDAR where CALENDAR_DATE > $RANGE_END_DATE;

update CALENDAR set DAY_OF_YEAR = dayofyear(CALENDAR_DATE);
update CALENDAR set DAY_OF_MONTH = day(CALENDAR_DATE);
update CALENDAR set DAY_OF_WEEK = dayofweek(CALENDAR_DATE);
update CALENDAR set DAY_OF_WEEK_NAME = 
    case DAY_OF_WEEK
        when 0 then 'Sunday' 
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
        end;
update CALENDAR set DAY_OF_WEEK_NAME_SHORT = DAYNAME(CALENDAR_DATE);
update CALENDAR set FIRST_DAY_OF_MONTH = CALENDAR_DATE - day(CALENDAR_DATE) + 1;
update CALENDAR set FIRST_DAY_OF_QUARTER = 
    case quarter(CALENDAR_DATE)
        when 1 then DATE_FROM_PARTS(year(CALENDAR_DATE), 1, 1)
        when 2 then DATE_FROM_PARTS(year(CALENDAR_DATE), 4, 1)
        when 3 then DATE_FROM_PARTS(year(CALENDAR_DATE), 7, 1)
        when 4 then DATE_FROM_PARTS(year(CALENDAR_DATE), 10, 1)
    end;
update CALENDAR set FIRST_DAY_OF_YEAR = DATE_FROM_PARTS(year(CALENDAR_DATE),1,1);
update CALENDAR set LAST_DAY_OF_MONTH = 
	ADD_MONTHS(CALENDAR_DATE, 1) - day(ADD_MONTHS(CALENDAR_DATE, 1));
update CALENDAR set LAST_DAY_OF_MONTH_INDICATOR = 
    case when LAST_DAY_OF_MONTH = CALENDAR_DATE then 1 else 0 end;
update CALENDAR set MONTH_NUM = month(CALENDAR_DATE);
update CALENDAR set MONTH_NAME =
    case month(CALENDAR_DATE) 
        when 1 then 'January'
        when 2 then 'February'
        when 3 then 'March'
        when 4 then 'April'
        when 5 then 'May'
        when 6 then 'June'
        when 7 then 'July'
        when 8 then 'August'
        when 9 then 'September'
        when 10 then 'October'
        when 11 then 'November'
        when 12 then 'December'
    end;
update CALENDAR set MONTH_NAME_SHORT = MONTHNAME(CALENDAR_DATE);
update CALENDAR set QUARTER = quarter(CALENDAR_DATE);
update CALENDAR set WEEK_NUMBER = WEEK(CALENDAR_DATE);
update CALENDAR set YEAR_NUM = year(CALENDAR_DATE);
