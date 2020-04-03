CREATE PROCEDURE [dbo].[F_Get_PROVIDERDETAILS]      
(
	@s_l_fromdate DATETIME,
	@s_l_todate DATETIME
)
AS  
	BEGIN    
		SELECT Provider_Name,COUNT(DISTINCT b.case_id) AS CASE_ID, COUNT(c.Case_ID) AS BILLS,SUM(CONVERT(money, ISNULL(b.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(b.Paid_Amount, 0))) AS BALANCE
		FROM tblCase  b with(nolock) inner join tblTreatment c ON b.Case_Id=c.Case_Id
        INNER JOIN dbo.tblProvider WITH (NOLOCK) ON b.Provider_Id = dbo.tblProvider.Provider_Id   
		--WHERE B.Date_Opened BETWEEN @s_l_fromdate AND @s_l_todate
		WHERE ISNULL(b.IsDeleted,0) = 0   AND cast(floor(convert( float,b.Date_Opened)) AS datetime)>= @s_l_fromdate and cast(floor(convert( float,b.Date_Opened)) AS datetime) <= @s_l_todate
		--WHERE month(b.date_opened) =8 and year(b.date_opened) =2013 and b.Provider_Name='Advanced Orthopaedics PLLC'
		 GROUP BY Provider_Name
		 
		 
	END

