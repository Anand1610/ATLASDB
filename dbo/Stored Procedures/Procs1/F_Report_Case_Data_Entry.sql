CREATE PROCEDURE [dbo].[F_Report_Case_Data_Entry]			-- [dbo].[F_Report_Case_Data_Entry]   '2013-08-1 00:00:00.000','2013-08-31 00:00:00.000'
(
	@dt_Start DATETIME = Null,
	@dt_End DATETIME= Null
)
AS
BEGIN

	IF @dt_Start is Null
		SET @dt_Start = GETDATE()
		
	IF @dt_End is null
		SET @dt_End = GETDATE()
		
		
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
	where Date_Opened  between @dt_Start AND @dt_End
	GROUP BY C.Case_Id, N.User_Id, P.Provider_Name
	
	---------- table 0--------
	SELECT 
		DISTINCT CONVERT(VARCHAR(100), DATENAME(weekday,Date_Opened) +', ' + DATENAME(MONTH,Date_Opened) +' '+ CONVERT(VARCHAR(20),DAY(Date_Opened)) +', ' + CONVERT(VARCHAR(20),Year(Date_Opened)),101) AS Date_Opened,
		Date_Opened AS [Date],
		USER_ID,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		SUM(Balance) AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		Date_Opened,USER_ID
		
	
	---------- table 1--------
	SELECT 
		Distinct USER_ID,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		SUM(Balance) AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		USER_ID
	
	---------- table 2--------
	
	SELECT 
		Distinct Provider_Name,
		COUNT(Case_Id) AS CASE_COUNT,
		SUM(Bill_Count) AS Bill_Count,
		SUM(Balance) AS Balance
	 FROM 
		#Temp_Data
	 GROUP BY
		Provider_Name
		
		
		
		
		
		
		
		
		
		
		
END

