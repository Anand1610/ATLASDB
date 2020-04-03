CREATE PROCEDURE [dbo].[F_Get_USERDETAILS]      
(
	@s_l_fromdate DATETIME,
	@s_l_todate DATETIME
)
AS  
	BEGIN    
	select  A.USER_ID,COUNT( DISTINCT A.case_id) as CASE_ID,count( c.Case_Id) as BILLS,
	        SUM( CONVERT(money, ISNULL(B.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(B.Paid_Amount, 0)) ) as BALANCE
		from tblNotes A WITH(nolock) INNER JOIN tblcase B WITH(nolock)  ON A.Case_Id=B.CASE_ID
		inner join tblTreatment c WITH(nolock) on b.Case_Id=c.Case_Id	
		where Notes_Desc like '%Case Opened%'
		--AND A.Notes_Date BETWEEN @s_l_fromdate AND @s_l_todate
		AND cast(floor(convert( float,Notes_Date)) AS datetime)>= @s_l_fromdate and cast(floor(convert( float,Notes_Date)) AS datetime) <= @s_l_todate
		AND ISNULL(B.IsDeleted,0) = 0
		--AND YEAR(Notes_Date)=2013 and month(Notes_Date)=8 
	    GROUP BY A.USER_ID 
	END

