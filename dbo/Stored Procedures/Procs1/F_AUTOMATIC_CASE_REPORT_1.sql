CREATE PROCEDURE [dbo].[F_AUTOMATIC_CASE_REPORT_1] --[dbo].[F_AUTOMATIC_CASE_REPORT_1]  '01/18/2014','WEEKDAY'  
(
	@DATE DATETIME='01/18/2014',
	@TYPE NVARCHAR(50)
)
AS
BEGIN
DECLARE @DAYPART AS INT
DECLARE @START_DATE AS DATETIME
DECLARE @END_DATE AS DATETIME

SELECT  @DAYPART=DATEPART(dw, '2014-01-17 14:26:56.930')
if @TYPE='WEEKDAY'
BEGIN
IF @DAYPART=7
BEGIN
select @START_DATE=DATEADD(dd, -(DATEPART(dw, GETDATE())-2), GETDATE())
select @END_DATE=DATEADD(dd, 6-(DATEPART(dw, GETDATE())), GETDATE())
END
IF @DAYPART=6
BEGIN
select @START_DATE=DATEADD(dd, -(DATEPART(dw, GETDATE())-3), GETDATE())
select @END_DATE=DATEADD(dd, 7-(DATEPART(dw, GETDATE())), GETDATE())
END
END

--SET @START_DATE='07/07/2013'
--SET @END_DATE='12/12/2013'

	Create Table #Temp_Data
	(
		Case_Id NVARCHAR(100),
		Provider_Name NVARCHAR(2000),
		User_Id NVARCHAR(100),
		Balance NUMERIC(36,2),
		Bill_Count INT,
		Date_Opened DATETIME
	)
	
	INSERT INTO #Temp_Data
	select Distinct C.Case_Id,P.Provider_Name, N.User_Id,SUM(T.Fee_Schedule) - SUM(T.Paid_Amount) AS Balance,COUNT(T.Case_id) AS Bill_Count,Convert(VARCHAR(10),MAX(C.Date_Opened),101) AS  Date_Opened
	FROM tblcase C
	INNER JOIN tblNotes N on N.Case_Id = C.Case_Id and N.Notes_Desc = 'Case Opened'
	INNER JOIN TblProvider P On P.Provider_Id = C.Provider_Id
	LEFT OUTER JOIN tblTreatment T ON T.Case_Id = N.Case_Id
	where Date_Opened  between @START_DATE AND @END_DATE
	GROUP BY C.Case_Id, N.User_Id, P.Provider_Name
	
	---------  table 0--------
	SELECT CONVERT(VARCHAR(10),@START_DATE,101) as startdate,CONVERT(VARCHAR(10),@END_DATE,101) as enddate
	
	---------- table 1--------
	SELECT 
		DISTINCT --CONVERT(VARCHAR(100), DATENAME(weekday,Date_Opened) +', ' + DATENAME(MONTH,Date_Opened) +' '+ CONVERT(VARCHAR(20),DAY(Date_Opened)) +', ' + CONVERT(VARCHAR(20),Year(Date_Opened)),101) AS Date_Opened,
		CONVERT(VARCHAR(10),Date_Opened,101) AS [Date],
		--USER_ID,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		CASE WHEN SUM(Balance) IS NULL  THEN 0 ELSE SUM(Balance) END  AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		Date_Opened
		
	
	---------- table 2--------
	SELECT 
		Distinct USER_ID,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		CASE WHEN SUM(Balance) IS NULL  THEN 0 ELSE SUM(Balance) END  AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		USER_ID
	
	---------- table3--------
	
	SELECT 
		Distinct Provider_Name,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		CASE WHEN SUM(Balance) IS NULL  THEN 0 ELSE SUM(Balance) END  AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		Provider_Name	
END

