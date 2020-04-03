CREATE PROCEDURE [dbo].[SP_UserStatus_Details] -- SP_UserStatus_Details @User_name,@DomainId
@User_name nvarchar(200),
@DomainId nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
		 
SELECT DISTINCT 'Status' as StatusType
	, Status 
	, (SELECT COUNT (ISNULL(tblcase.Case_Id,0)) FROM tblcase (NOLOCK) WHERE Status=us.Status And DomainId = us.DomainId and ISNULL(IsDeleted, 0) = 0) AS Case_count
	, (SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase (NOLOCK) WHERE DATEDIFF(dd,ISNULL(Date_Status_Changed,Date_Opened),GETDATE()) >= max(us.CriticalDays) and Status=us.Status And DomainId = us.DomainId and ISNULL(IsDeleted, 0) = 0) AS critical_cases
	, MAX(CriticalDays) AS Criticaldays
FROM tblUserStatus us
where  StatusType = 'status' and us.username=@User_name And us.DomainId = @DomainId
GROUP BY us.DomainId, us.Status

		 UNION

SELECT DISTINCT 'Rebuttal' as StatusType
	, Status 
	, (SELECT COUNT (ISNULL(tblcase.Case_Id,0)) FROM tblcase (NOLOCK) WHERE Rebuttal_Status=us.Status And DomainId = us.DomainId and ISNULL(IsDeleted, 0) = 0) AS Case_count
	, (SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase (NOLOCK) WHERE DATEDIFF(dd,Date_Rebuttal_Status_Changed,GETDATE()) >= max(us.CriticalDays) and Rebuttal_Status=us.Status And DomainId = us.DomainId and ISNULL(IsDeleted, 0) = 0) AS critical_cases
	, MAX(CriticalDays) AS Criticaldays
FROM tblUserStatus us
where  StatusType = 'rebuttal' and us.username=@User_name And us.DomainId = @DomainId
GROUP BY us.DomainId, us.Status
ORDER BY Status
		 
	--( SELECT DISTINCT 
	--'Status' as StatusType
	--, st.Status_Id,st.Status_Type AS Status
	--, (SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase WHERE Status=st.Status_Type And DomainId = @DomainId)AS Case_count
	--, (SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase where DateDiff(dd,ISNULL(Date_Status_Changed,Date_Opened),GETDATE()) >= (select CriticalDays from tblUserStatus where Status=st.Status_Type and StatusType='status') and Status=st.Status_Type And DomainId = @DomainId) AS critical_cases
	----, status_age_limit
	--, (select criticaldays from tbluserstatus where Status=st.Status_Type And StatusType='status' and DomainId = @DomainId)[Criticaldays]
	--	 FROM tblStatus st inner join tblUserStatus us on status=st.Status_Type and StatusType='status'  and us.DomainId = st.DomainId
	--	 where us.username=@User_name And us.DomainId = @DomainId
	--	 GROUP BY st.Status_Id,st.Status_Type,st.status_age_limit,st.DomainId
	--	)

	--	 Union

	--( Select DISTINCT 
	--  'Rebuttal' as StatusType
	--  , PK_Rebuttal_Status_ID as Status_Id
	--  , Rebuttal_Status as Status
	--  ,	(SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase WHERE Rebuttal_Status=rs.Rebuttal_Status And DomainId = @DomainId)AS Case_count
	--  ,	(SELECT COUNT (ISNULL(tblcase.Case_Id,0))  FROM tblcase 
	--	where DateDiff(dd,ISNULL(date_Rebuttal_Status_changed,Date_Opened),GETDATE()) >= 
	--	(select CriticalDays from tblUserStatus where Status=rs.Rebuttal_Status and StatusType='rebuttal') and Rebuttal_Status= rs.Rebuttal_Status 
	--	And DomainId = @DomainId) AS critical_cases
	--  ,	(select criticaldays from tbluserstatus where Status=rs.Rebuttal_Status and StatusType='rebuttal' And DomainId = @DomainId)[Criticaldays]
	--	from Rebuttal_Status rs inner join tblUserStatus us on status=rs.Rebuttal_Status and StatusType='rebuttal'  and us.DomainId = rs.DomainId
	--	Where rs.DomainId = @DomainId
	--	GROUP BY rs.PK_Rebuttal_Status_ID, rs.Rebuttal_Status,rs.DomainId)
	--    ORDER BY Status
END