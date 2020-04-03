CREATE PROCEDURE [dbo].[SP_AllStatus_Details_New]
(
 @DomainId nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @CaseData TABLE
	(
	[Case_ID] varchar(50)  INDEX IDX_CaseData Clustered,
	[Status] varchar(50),
	[Rebuttal_Status] varchar(200)

	)

    DECLARE @tbluserstatus TABLE
    (
	  [ID] INT identity(1,1) ,
	  criticaldays varchar(200),
	  Status varchar(1000),
	  StatusType varchar(50)
	)



	INSERT INTO @tbluserstatus(criticaldays, Status, StatusType)
	select criticaldays, Status, StatusType from tbluserstatus where domainid = @DomainId

	INSERT INTO @CaseData(Case_ID, Status, Rebuttal_Status)
	SELECT Case_ID, Status, Rebuttal_Status from TBLCASE with(nolock)
	where domainid = @DomainId AND ISNULL(IsDeleted,0)=0

	  DECLARE @tblstatus TABLE
    (
	 
	  Status_Id INT  INDEX IDX_Status Clustered,
	  Status_Type varchar(100),
	  status_age_limit varchar(20)
	  
	)


	Insert INTO @tblstatus(Status_Id, Status_Type, status_age_limit)
	SELECT Status_Id, Status_Type, status_age_limit  FROM tblStatus  with(nolock)

	 where 
		  DomainId = @DomainId


		(SELECT 
		 'Status' As StatusType
		  ,st.Status_Id
		 ,st.Status_Type AS Status
		 ,(SELECT COUNT (ISNULL(cas.Case_Id,0))  FROM @CaseData cas WHERE Status=st.Status_Type 
		  )AS Case_count
		
		 ,(select criticaldays from @tbluserstatus where Status=st.Status_Type and StatusType='status'  )[Criticaldays]
		 FROM @tblstatus st  
	
		 GROUP BY st.Status_Id,st.Status_Type,st.status_age_limit)


		 Union
		 (Select 
		 'Rebuttal' As StatusType
		 ,PK_Rebuttal_Status_ID as Status_Id
		 ,Rebuttal_Status as Status
		 ,(SELECT COUNT (ISNULL(cas.Case_Id,0))  FROM @CaseData cas WHERE cas.Rebuttal_Status=rs.Rebuttal_Status   
		 )AS Case_count
		 ,(select criticaldays from @tbluserstatus usstat where Status=rs.Rebuttal_Status and StatusType='rebuttal' )[Criticaldays]
		 from Rebuttal_Status rs where DomainId = @DomainId
	     GROUP BY rs.PK_Rebuttal_Status_ID,rs.Rebuttal_Status)
		 order by StatusType desc, Status
		 
END
