CREATE PROCEDURE [dbo].[Update_Cases_Status_By_UserID]
(
	@DomainId VARCHAR(50),
	@status varchar(100),
	@case_id varchar(20),
	@User_Id INT
)
AS
BEGIN
    Declare @NDesc varchar(max),
    --@Description VARCHAR(2000),
	@old_stat_hierc int,  
	@new_stat_hierc int,
	@motion_stat_hierc smallint,
	@PROVIDER_ID VARCHAR(50) ,
	@provider_ff nchar(10),
	@status_bill money,
	@status_bill_type VARCHAR(20),
	@status_bill_notes varchar(200),
	@st varchar(MAX)

	DECLARE @OldValue VARCHAR(100), @newValue VARCHAR(100)
				declare @s_l_user VARCHAR(100)
				DECLARE @oldStatus VARCHAR(500)
				DECLARE @newStatus VARCHAR(500)

		SET @newStatus=@status
		SET @s_l_user = (SELECT USERNAME FROM IssueTracker_Users (NOLOCK) WHERE userid = @User_Id)

	   DECLARE @TotalCount INT = 0
       DECLARE @Counter INT = 1
       DECLARE @s_l_CaseID VARCHAR(100) = ''
       DECLARE @tbCaseIds TABLE
              (
                     ID INT IDENTITY(1,1),
                     [CaseId] VARCHAR(100) NOT NULL
              )

       INSERT INTO  @tbCaseIds
       SELECT Case_ID 
		FROM DBO.TBLCASE CAS
		LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
		WHERE 
			pkt.PacketID = @case_id OR cas.Case_Id = @case_id


       SELECT @TotalCount = COUNT(*) FROM @tbCaseIds
       WHILE(@Counter <= @TotalCount)
       BEGIN
               SELECT @s_l_CaseID = CaseID FROM @tbCaseIds   WHERE ID = @Counter

				
				SET @oldStatus = (select status from tblcase (NOLOCK) where case_id = @s_l_CaseID and DomainId=@DomainId)
				
	
				if(@status<>'')
				begin
				DECLARE @oldStatusHierarchy int
				DECLARE @newStatusHierarchy int
					if(@oldStatus <> @newStatus)
					BEGIN
					SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@oldStatus)
					SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@newStatus)
					        if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                            BEGIN
								UPDATE tblcase SET STATUS = @newStatus WHERE CASE_ID = @s_l_CaseID AND DomainId = @DomainId
								set @NDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus       
							exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@s_l_CaseID,@Notes_Type='Activity',@Ndesc = @NDesc,@user_Id= @s_l_user,@ApplyToGroup = 0  
							END
							ELSE
							BEGIN
							declare @Description VARCHAR(200) ='Status Hierarchy Constraint error :Status cannot be changed from ' + @oldStatus + ' to ' + @newStatus + ',' 
                            EXEC F_Add_Activity_Notes   @DomainID =@DomainId
	                           ,@s_a_case_id    = @s_l_CaseID  
							   ,@s_a_notes_type = 'Activity'  
							   ,@s_a_ndesc = @Description
							   ,@s_a_user_Id = @user_Id 
							   ,@i_a_applytogroup = 0 
							END
					end
				END
              Print @s_l_CaseID
              -- Reight your logic here         
              SET @Counter = @Counter + 1
              SET @s_l_CaseID = NULL
       END
END

