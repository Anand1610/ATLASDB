CREATE PROCEDURE [dbo].[F_Report_Case_Processing_Report]-- [dbo].[F_Report_Case_Processing_Report]   '01/13/2013','01/18/2014'
(
	@dt_Start DATETIME = Null,
	@dt_End DATETIME= Null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
IF @dt_Start is Null
		SET @dt_Start = GETDATE()
		
	IF @dt_End is null
		SET @dt_End = GETDATE()
		
	
	
      
	DECLARE @ProductTotals TABLE
	(
		DATE_Processing DATE,
		Summons_Printed INT,
		Summons_Sent INT,
		Served_On INT,
		AAA_Arb_Filed INT,
		AAA_Confirmed INT
	)

	DECLARE @TOTALCount INT
	SET @dt_Start = DATEADD(DAY,-1,@dt_Start)
	Select  @TOTALCount= DATEDIFF(DD,@dt_Start,@dt_End)-1;

	WITH d AS 
            (
              SELECT top (@TOTALCount) AllDays = DATEADD(DAY, ROW_NUMBER() 
                OVER (ORDER BY object_id), REPLACE(@dt_Start,'-',''))
              FROM sys.all_objects
            )
      
      
      
	INSERT INTO @ProductTotals(DATE_Processing)
	SELECT AllDays From d
	
	
	-------------Summons Printed-------------------------	  
	UPDATE @ProductTotals      
		SET Summons_Printed = CASES
	FROM @ProductTotals      
     INNER JOIN 
		(SELECT DISTINCT CONVERT(DATE,Date_Summons_Printed) AS Date_Summons_Printed,COUNT(CASE_ID) CASES FROM tblCase 
		  WHERE Date_Summons_Printed BETWEEN @dt_Start AND @dt_End
		  GROUP BY CONVERT(DATE,Date_Summons_Printed)) NEW_T ON  DATE_Processing = Date_Summons_Printed
     
     -------------Summons Sent-------------------------	  
     UPDATE @ProductTotals      
		SET Summons_Sent = CASES
	FROM @ProductTotals      
     INNER JOIN 
		(SELECT DISTINCT CONVERT(DATE,Date_Summons_Sent_Court) AS Date_Summons_Sent_Court,COUNT(CASE_ID) CASES FROM tblCase 
		  WHERE Date_Summons_Sent_Court BETWEEN @dt_Start AND @dt_End
		  GROUP BY CONVERT(DATE,Date_Summons_Sent_Court)) NEW_T ON  DATE_Processing = Date_Summons_Sent_Court
		  
		  
	-------------Summons Served-------------------------	  
	UPDATE @ProductTotals      
		SET Served_On = CASES
	FROM @ProductTotals      
     INNER JOIN 
		(SELECT DISTINCT CONVERT(DATE,Served_On_Date) AS Served_On_Date,COUNT(CASE_ID) CASES FROM tblCase 
		  WHERE Served_On_Date BETWEEN @dt_Start AND @dt_End
		  GROUP BY CONVERT(DATE,Served_On_Date)) NEW_T ON  DATE_Processing = Served_On_Date
       		  
	-------------AAA Filed-------------------------
	UPDATE @ProductTotals      
		SET AAA_Arb_Filed = CASES
	FROM @ProductTotals      
     INNER JOIN 
		(SELECT DISTINCT CONVERT(DATE,Date_AAA_Arb_Filed) AS Date_AAA_Arb_Filed,COUNT(CASE_ID) CASES FROM tblCase 
		  WHERE Date_AAA_Arb_Filed BETWEEN @dt_Start AND @dt_End
		  GROUP BY CONVERT(DATE,Date_AAA_Arb_Filed)) NEW_T ON  DATE_Processing = Date_AAA_Arb_Filed
       	  
	-------------AAA Confirmed-------------------------
	UPDATE @ProductTotals      
		SET AAA_Confirmed = CASES
	FROM @ProductTotals      
     INNER JOIN 
		(SELECT DISTINCT CONVERT(DATE,AAA_Confirmed_Date) AS AAA_Confirmed_Date,COUNT(CASE_ID) CASES FROM tblCase 
		  WHERE AAA_Confirmed_Date BETWEEN @dt_Start AND @dt_End
		  GROUP BY CONVERT(DATE,AAA_Confirmed_Date)) NEW_T ON  DATE_Processing = AAA_Confirmed_Date
       

      SELECT datename(WEEKDAY,DATE_Processing)+','+DATENAME(MONTH,DATE_Processing)+' '+CONVERT(VARCHAR(20),DAY(DATE_Processing))+', ' + CONVERT(VARCHAR(20),Year(DATE_Processing),101) AS DATE_Processing 
      ,ISNULL(Summons_Printed,0) Summons_Printed,ISNULL(Summons_Sent,0) Summons_Sent,ISNULL(Served_On,0) Served_On ,isnull(AAA_Arb_Filed,0)AAA_Arb_Filed ,isnull(AAA_Confirmed,0)AAA_Confirmed  FROM @ProductTotals 
   --select SUM (isnull(AAA_Arb_Filed,0)) as cnt_AAA_Arb_Filed,SUM (isnull(AAA_Confirmed,0)) as cnt_AAA_Confirmed FROM @ProductTotals 
       --exec F_Report_Case_Processing_Report @dt_Start='02/03/2014',@dt_End='02/08/2014'
      
     
      
       --SELECT CASE_ID,CONVERT(DATE,AAA_Confirmed_Date) FROM tblCase WHERE AAA_Confirmed_Date BETWEEN @dt_Start AND @dt_End
     
        
	
	--select Case_Id,Date_Summons_Printed,Date_Summons_Sent_Court,Served_On_Date from tblcase

	--select Case_Id,DateAAA_packagePrinting,Date_AAA_Arb_Filed,AAA_Confirmed_Date from tblcase
	
	--INSERT INTO @ProductTotals(DATE_Processing)
	--SELECT DISTINCT 
	
		
END

