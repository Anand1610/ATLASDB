CREATE PROCEDURE [dbo].[F_Get_ProductionDetails]     --[dbo].[F_Get_ProductionDetails] '08/01/2013','08/31/2013'
(
	@s_l_fromdate DATETIME,
	@s_l_todate DATETIME
)
AS  
	BEGIN    
				select  A.USER_ID,COUNT( DISTINCT A.case_id) as CASE_ID,SUM(CONVERT(money, ISNULL(B.Claim_Amount, 0))       
                      - CONVERT(float, ISNULL(B.Paid_Amount, 0))) as BALANCE,count( c.Case_Id) as BILLS,
				DATENAME(dw,Notes_Date)+','+CONVERT(VARCHAR, Notes_Date, 106) as NameOfDay,DAY(Notes_Date) AS DAY
				from tblNotes A INNER JOIN tblcase  B With(nolock) ON A.Case_Id=B.CASE_ID
				inner join tblTreatment c on b.Case_Id=c.Case_Id
				where  ISNULL(B.IsDeleted,0) = 0 AND Notes_Desc like '%Case Opened%'
				AND cast(floor(convert( float,Notes_Date)) AS datetime)>= @s_l_fromdate and cast(floor(convert( float,Notes_Date)) AS datetime) <= @s_l_todate
				GROUP BY A.USER_ID,	DATENAME(dw,Notes_Date)+','+CONVERT(VARCHAR, Notes_Date, 106),DAY(Notes_Date) 
				ORDER BY DATENAME(dw,Notes_Date)+','+CONVERT(VARCHAR, Notes_Date, 106) ASC
	END

