CREATE PROCEDURE [dbo].[F_Case_Event_Delete]
(
	@DomainId NVARCHAR(50),
	@i_a_EventId	INT,
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
	
	
	DECLARE @s_l_Event_Date VARCHAR(12)
	DECLARE @s_l_CASE_ID VARCHAR(50)

	
	SET @s_l_Event_Date = (SELECT CONVERT(VARCHAR(20),Event_Date,100) from tblEvent where Event_Id =  @i_a_EventId)
	
	SET @s_l_CASE_ID = (SELECT Case_Id from tblEvent where Event_Id = @i_a_EventId)


	DELETE FROM tblEvent WHERE Event_id = @i_a_EventId
	
	UPDATE tblEvent
	SET Status = 0
	Where Case_id =@s_l_CASE_ID
	
	
	UPDATE tblEvent
	SET Status = 1
	from tblEvent EVE
	INNER JOIN 
	(select TOP 1 Event_id,CONVERT(DATETIME,CONVERT(VARCHAR(10),EVE.Event_Date,101) + ' '+ LTRIM(RIGHT(CONVERT(VARCHAR(20),EVE.Event_Time, 100), 7))) AS Event_Date_Time
	from tblEvent EVE where Case_id =@s_l_CASE_ID order by Event_Date_Time desc) A ON A.Event_id =  EVE.Event_id
	
	

	SET @s_l_Notes = 'Event - deleted for Date ' + @s_l_Event_Date 
	EXEC F_Add_Activity_Notes @DomainId, @s_l_CASE_ID,'Activity',@s_l_Notes,@s_a_UserName,0


	
	SET @s_l_message	=  'Event details deleted successfuly'
	SET @i_l_result		=  ''
		

	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

