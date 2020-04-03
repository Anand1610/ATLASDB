CREATE PROCEDURE [dbo].[F_Case_Event_Retrive] --[F_Case_Event_Retrive] 'test','TEST17-100001',0
(
	@DomainId NVARCHAR(50),
	@s_a_CASE_ID NVARCHAR(50) = 'FH07-42372',
	@i_a_Event_id INT = 0
)
AS        
BEGIN  

IF(@i_a_Event_id = 0)
BEGIN
		SELECT 
		EVE.Case_id,
		EVE.Event_id,
		CONVERT(VARCHAR(10),EVE.Event_Date,101) + ' '+ LTRIM(RIGHT(CONVERT(VARCHAR(20),EVE.Event_Time, 100), 7)) AS Event_Date_Time,
		Event_Date,
		ISNULL(EVE_TYPE.EventTypeId,0) AS EventTypeId,
		ISNULL(EVE_TYPE.EventTypeName,0) AS EventTypeName,
		ISNULL(EVE_STATUS.EventStatusName,'') AS EventStatusName,
		ISNULL(EVE_STATUS.EventStatusId,0) AS EventStatusId,
		ISNULL(EVE.Event_Notes,'') AS Event_Notes,
		Assigned_To,
		ISNULL(USR.UserId,0) AS Assigned_To_ID,
		ISNULL(ARB.ARBITRATOR_ID,0) AS ARBITRATOR_ID,
		ISNULL(ARB.ARBITRATOR_NAME,'') AS ARBITRATOR_NAME
	FROM
		tblEvent EVE
	LEFT OUTER JOIN 
		tblEventType EVE_TYPE on EVE_TYPE.EventTypeId = EVE.EventTypeId 
	LEFT OUTER JOIN 
		tblEventStatus EVE_STATUS on EVE_STATUS.EventStatusId = EVE.EventStatusId 
	LEFT OUTER JOIN
		TblArbitrator ARB ON ARB.ARBITRATOR_ID = EVE.arbitrator_id 
	LEFT OUTER JOIN
		IssueTracker_Users USR ON USR.UserName = EVE.Assigned_To and USR.DomainId = EVE.DomainId
			
	WHERE 
		EVE.Case_id = @s_a_CASE_ID and EVE.DomainId =@DomainId
		
	ORDER BY 
		EVE.Event_Date DESC
		
END
ELSE
BEGIN
		SELECT 
		EVE.Case_id,
		EVE.Event_id,
		CONVERT(VARCHAR(10),EVE.Event_Date,101) + ' '+ LTRIM(RIGHT(CONVERT(VARCHAR(20),EVE.Event_Time, 100), 7)) AS Event_Date_Time,
		Event_Date,
		ISNULL(EVE_TYPE.EventTypeId,0) AS EventTypeId,
		ISNULL(EVE_TYPE.EventTypeName,0) AS EventTypeName,
		ISNULL(EVE_STATUS.EventStatusName,'') AS EventStatusName,
		ISNULL(EVE_STATUS.EventStatusId,0) AS EventStatusId,
		ISNULL(EVE.Event_Notes,'') AS Event_Notes,
		Assigned_To,
		ISNULL(USR.UserId,0) AS Assigned_To_ID,
		ISNULL(ARB.ARBITRATOR_ID,0) AS ARBITRATOR_ID,
		ISNULL(ARB.ARBITRATOR_NAME,'') AS ARBITRATOR_NAME
	FROM
		tblEvent EVE
	LEFT OUTER JOIN 
		tblEventType EVE_TYPE on EVE_TYPE.EventTypeId = EVE.EventTypeId 
	LEFT OUTER JOIN 
		tblEventStatus EVE_STATUS on EVE_STATUS.EventStatusId = EVE.EventStatusId 
	LEFT OUTER JOIN
		TblArbitrator ARB ON ARB.ARBITRATOR_ID = EVE.arbitrator_id 
	LEFT OUTER JOIN
		IssueTracker_Users USR ON USR.UserName = EVE.Assigned_To and USR.DomainId = EVE.DomainId
			
	WHERE 
		EVE.Case_id = @s_a_CASE_ID and EVE.DomainId =@DomainId and Event_id =@i_a_Event_id
		
	ORDER BY 
		EVE.Event_Date DESC
		
END


	
END

