

CREATE PROCEDURE [dbo].[ActiveDelay_Case_Status_Update]
	@DomainID VARCHAR(50),
	@s_a_Status VARCHAR(100),
	@s_a_Case_ID VARCHAR(100),	
	@s_a_UserName VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result INT
	DECLARE @s_l_message VARCHAR(500)
	DECLARE @Old_Case_Status VARCHAR(300) 
	DECLARE @Flag INT=0
	DECLARE @s_l_Namemessage VARCHAR(500)=''
    DECLARE @newStatusHierarchy int
	DECLARE @oldStatusHierarchy int
	BEGIN TRAN

		SET @Old_Case_Status=(select Status from tblCase WHERE DomainID =@DomainID AND Case_Id =@s_a_Case_ID)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Case_Status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_a_Status)

		if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT', 'PDC')))
		BEGIN
				UPDATE tblCase 
				SET Status =@s_a_Status	WHERE DomainID =@DomainID AND Case_Id =@s_a_Case_ID

				UPDATE Auto_Billing_Packet_Info 
				SET Status =@s_a_Status	WHERE DomainID =@DomainID AND Case_Id=@s_a_Case_ID

				UPDATE Auto_Packet_Info 
				SET Status =@s_a_Status	WHERE DomainID =@DomainID AND Case_Id=@s_a_Case_ID

				IF(@s_a_Status != @Old_Case_Status)
				BEGIN
					INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
					values('Case Status Changed from '+@Old_Case_Status+' to '+@s_a_Status ,'Activity', 1,@s_a_Case_ID,GETDATE(),@s_a_UserName,@DomainID)
				END
			
				SET @s_l_message	= 'Case Status Changed successfully for Case_ID - '+ @s_a_Case_ID 
				SET @i_l_result		=  0
      
			
       END
	   ELSE
	   BEGIN
		INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
					values('You Can not change the Case Status '+@Old_Case_Status+' to '+@s_a_Status ,'Activity', 1,@s_a_Case_ID,GETDATE(),@s_a_UserName,@DomainID)
					SET @s_l_message	='You Can not change the Case Status '+@Old_Case_Status+' to '+@s_a_Status
					SET @i_l_result		=  0
	   END
	   COMMIT TRAN
		SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]
END
