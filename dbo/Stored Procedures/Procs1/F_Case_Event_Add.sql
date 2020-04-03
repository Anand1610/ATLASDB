CREATE PROCEDURE [dbo].[F_Case_Event_Add]
(
	@DomainId			varchar(50),
	@i_a_EventId		INT,
	@s_a_CaseId		VARCHAR(100),
	@dt_a_EventDate	DATETIME= NULL,
	@i_a_EventTypeID	INT= 0,
	@i_a_EventStatusId	INT= 0,
	@s_a_EventDesc		NVARCHAR(500)= NULL,
	@s_a_AssignedTo	NVARCHAR(500)= NULL,
	@i_a_ArbitratorID	INT= 0,
	@s_a_UserName		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result					INT
	DECLARE @s_l_message				NVARCHAR(500)
	DECLARE @s_l_Notes VARCHAR(200)
	DECLARE @s_l_Event_Type_Name NVARCHAR(200)
	
	
	SET @s_l_Event_Type_Name = (SELECT EventTypeName FROM tblEventType  WHERE EventTypeId = @i_a_EventTypeID and DomainId=@DomainId)

	
	IF @i_a_ArbitratorID = 0
		SET @i_a_ArbitratorID = null
	
	
	
	IF(@i_a_EventId = 0)
	BEGIN
		BEGIN TRAN
		INSERT INTO tblEvent 
		(
			DomainId,
			Case_Id,
			Event_Date,
			Event_Time,
			EventTypeId,
			EventStatusId,
			Event_Notes,
			Assigned_To,
			arbitrator_id,
			User_id
		)
		VALUES
		(
			@DomainId,
			@s_a_CaseId,
			@dt_a_EventDate,
			@dt_a_EventDate,
			@i_a_EventTypeID,
			@i_a_EventStatusId,
			@s_a_EventDesc,
			@s_a_AssignedTo,
			@i_a_ArbitratorID,
			@s_a_UserName
		)
		SET @s_l_message	=  'Event details saved successfuly'
		SET @i_l_result		=  SCOPE_IDENTITY()

		SET @s_l_Notes = 'Event - ' + @s_l_Event_Type_Name + ' added for ' + convert(nvarchar(12),@dt_a_EventDate,101) + ' assigned to ' + @s_a_AssignedTo
		exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc=@s_l_Notes,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup=0

		
		COMMIT TRAN
		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		UPDATE tblEvent 
		SET 
			Event_Date = @dt_a_EventDate,
			Event_Time = @dt_a_EventDate,
			EventTypeId = @i_a_EventTypeID,
			EventStatusId = @i_a_EventStatusId,
			Event_Notes = @s_a_EventDesc,
			Assigned_To = @s_a_AssignedTo,
			arbitrator_id = @i_a_ArbitratorID,
			User_id = @s_a_UserName
		WHERE Event_Id = @i_a_EventId
		AND DomainId=@DomainId
		SET @s_l_message	=  'Event details updated successfuly'
		SET @i_l_result	=  @i_a_EventId


		SET @s_l_Notes = 'Event - ' + @s_l_Event_Type_Name + ' updated for ' + convert(nvarchar(12),@dt_a_EventDate,101) + ' assigned to ' + @s_a_AssignedTo
		exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc=@s_l_Notes,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup=0

		
		COMMIT TRAN			
		
	END
	
	UPDATE tblEvent 
	SET Status = 0
	Where Case_id =@s_a_CaseId
	and DomainId=@DomainId
	
	
	UPDATE tblEvent 
	SET Status = 1
	from tblEvent EVE
	INNER JOIN 
	(select TOP 1 Event_id,CONVERT(DATETIME,CONVERT(VARCHAR(10),EVE.Event_Date,101) + ' '+ LTRIM(RIGHT(CONVERT(VARCHAR(20),EVE.Event_Time, 100), 7))) AS Event_Date_Time
	from tblEvent  EVE where DomainId=@DomainId and Case_id =@s_a_CaseId order by Event_Date_Time desc) A ON A.Event_id =  EVE.Event_id
	
  
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

