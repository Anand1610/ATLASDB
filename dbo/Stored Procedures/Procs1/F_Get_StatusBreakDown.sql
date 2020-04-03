CREATE PROCEDURE [dbo].[F_Get_StatusBreakDown]   --[dbo].[F_Get_StatusBreakDown] '40392'   
(
	@PROVIDER_ID NVARCHAR(100)
)
AS  
	BEGIN
		SELECT Provider_id,Status,COUNT(DISTINCT case_id) AS [cnt]
		FROM tblcase 
		INNER JOIN tblStatus ON TBLSTATUS.Status_Type=tblcase.Status 
		WHERE provider_id=@PROVIDER_ID
		AND Status NOT IN ('CLOSED','Closed Arbitration','Closed as per RCF','Closed Judgement','Closed Withdrawn with Prejudice','Closed Withdrawn without prejudice','Settled','Withdrawn-with-prejudice','withdrawn-without-prejudice','Carrier In Rehab','Pending','Open-Old','Trial Lost')
		GROUP BY Status,tblStatus.hierarchy_Id,tblStatus.forum,Provider_id ORDER BY tblStatus.hierarchy_Id,tblStatus.forum ASC
		 
		END

