
CREATE PROCEDURE [dbo].[LCJ_Update_status]--[LCJ_Update_status] 'FH13-161296','SUMMONS-PRINTED ','tech'
(
	@DomainID VARCHAR(50),
	@case_id VARCHAR(100),
	@Status VARCHAR(100),
	@UserId VARCHAR(100)
)
AS
Declare @Old_Status AS VARCHAR(100)
DECLARE @newStatusHierarchy int
DECLARE @oldStatusHierarchy int
 declare @Description VARCHAR(200)

BEGIN

		SET @Old_Status =(select status from tblcase where Case_Id =@case_id and DomainId=@DomainID)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Status)

    if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
         BEGIN
		 update tblcase set status=@Status where case_id=@case_id and DomainId=@DomainID
		 insert into tblnotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId) values ('Status changed from '+@Old_Status+' to '+@Status,'Activity',1,@case_id,GETDATE(),@UserId,@DomainID)
		 END
		 ELSE
		 BEGIN
		 SET @Description  ='Status Hierarchy Constraint error :Status cannot be changed from ' + @Old_Status + ' to ' + @Status + ',' 
		 EXEC F_Add_Activity_Notes   @DomainID =@DomainID
								   ,@s_a_case_id = @Case_Id  
								   ,@s_a_notes_type = 'Activity'  
								   ,@s_a_ndesc = @Description
								   ,@s_a_user_Id = @UserId 
								   ,@i_a_applytogroup = 0  
								   RETURN
		END

      
   IF(LTRIM(RTRIM(@Status)) = 'SUMMONS-PRINTED')
   BEGIN
		update tblcase 
		set date_summons_printed = getdate()
		where date_summons_printed is null and case_id = @case_id and DomainId=@DomainID
   END
 
END

