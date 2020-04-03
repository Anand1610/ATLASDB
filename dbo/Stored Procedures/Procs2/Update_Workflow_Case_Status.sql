CREATE PROCEDURE [dbo].[Update_Workflow_Case_Status] 
	--@s_a_DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @s_a_CaseId varchar(50);
	Declare @NotesType varchar(50) = 'Workflow';
	Declare @s_a_DomainId varchar(50);
	declare @Old_Status varchar(200);

	DECLARE AnswerNotReceivedCases CURSOR READ_ONLY
    FOR
	--Select cd.Case_Id, cd.DomainId from tblCase_Date_Details cd inner join tblcase c on c.Case_Id = cd.Case_Id inner join tbl_Client cl on cl.DomainId = cd.DomainId
	--where
	--Date_Summons_Expires is not null and DATEDIFF(Day,Date_Summons_Expires, GETDATE()) = 32 
	--and Date_Answer_Received is null and lower(cl.CompanyType) = 'funding' --cd.DomainId = @s_a_DomainId 
	--and lower(Status) != 'default letter to attorney'

    Select cd.Case_Id, cd.DomainId from tblCase_Date_Details cd inner join tblcase c on c.Case_Id = cd.Case_Id 
    inner join tbl_Client cl on cl.DomainId = cd.DomainId
	where
	Date_Summons_Expires is not null and DATEDIFF(Day,Date_Summons_Expires, GETDATE()) = 32 
	and Date_Answer_Received is null and lower(cl.CompanyType) = 'funding' --cd.DomainId = @s_a_DomainId 
	and lower(Status) != 'default letter to attorney'
	and cd.case_id  NOT  in (select note.case_id  from tblnotes note with(nolock) 
	inner JOIN tblcase cas with(nolock) on note.Case_Id = cas.Case_Id
	where   note.Notes_Type='Activity' and note.user_id='admin' and note.Notes_Priority=0  
	AND Notes_Desc like '%Status Hierarchy Constraint error :Status cannot be changed from%'+status+'%to%Default Letter To Attorney%'
	group by note.Case_Id
	)


	OPEN  AnswerNotReceivedCases
	FETCH NEXT FROM AnswerNotReceivedCases INTO @s_a_CaseId, @s_a_DomainId

	 WHILE @@FETCH_STATUS = 0
	 BEGIN
	    
		DECLARE @oldStatusHierarchy int
		DECLARE @newStatusHierarchy int
		DECLARE @DomainID VARCHAR(10)
		Select top 1 @Old_Status = Status,@DomainID=DomainId From tblcase with(nolock) where DomainId=@s_a_DomainId and Case_id=@s_a_CaseId

		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Default Letter To Attorney')

	   if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
        BEGIN
		Update tblcase set Status = 'Default Letter To Attorney' where Case_Id = @s_a_CaseId and DomainId = @s_a_DomainId
		EXEC LCJ_AddNotes @DomainId=@s_a_DomainId, @case_id=@s_a_CaseId,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Default Letter To Attorney', 
		@user_Id='admin', @ApplyToGroup = 0  
		END
		ELSE
		BEGIN
		declare @Description VARCHAR(200) ='Status Hierarchy Constraint error :Status cannot be changed from ' + @Old_Status + ' to ' + 'Default Letter To Attorney' + ','   
        EXEC F_Add_Activity_Notes   @DomainID =@s_a_DomainId  
                            ,@s_a_case_id = @s_a_CaseId    
          ,@s_a_notes_type = 'Activity'    
          ,@s_a_ndesc = @Description  
          ,@s_a_user_Id = 'admin'   
          ,@i_a_applytogroup = 0   
		END

		FETCH NEXT FROM AnswerNotReceivedCases INTO @s_a_CaseId, @s_a_DomainId
	 END
     
	  CLOSE AnswerNotReceivedCases
      DEALLOCATE AnswerNotReceivedCases
END
