
CREATE PROCEDURE [dbo].[F_Packet_CaseType_Update]
(
	@DomainID VARCHAR(50),
	@s_a_PacketID VARCHAR(100),
	@i_a_CaseType_Id INT,
	@s_a_UserName NVARCHAR(100)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @i_l_result INT
	DECLARE @s_l_message NVARCHAR(500)

	IF(@i_a_CaseType_Id= 0)
		SET @i_a_CaseType_Id = Null
		
	IF EXISTS(SELECT PacketID FROM tblPacket WHERE PacketID = @s_a_PacketID and DomainID =@DomainID)
	BEGIN
		BEGIN TRAN
			DECLARE @NDesc varchar(500)
			DECLARE @s_l_CaseType  VARCHAR(1000)
			SET @s_l_CaseType = (SELECT CaseType FROM dbo.MST_PacketCaseType WHERE PK_CaseType_ID = @i_a_CaseType_Id and DomainID =@DomainID)
			
			SET @s_l_message	=  'Case type successfuly changed -' + @s_a_PacketID
			SET @i_l_result    =  (SELECT TOP 1 Packet_Auto_ID FROM tblPacket WHERE PacketID = @s_a_PacketID and DomainID =@DomainID)
			
			UPDATE tblPacket 
			SET FK_CaseType_Id = @i_a_CaseType_Id
			WHERE PacketID = @s_a_PacketID AND DomainID =@DomainID
			
			set @NDesc = 'Packet Case Type Changed To - ' + @s_l_CaseType

			INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
			SELECT @NDesc,'Activity',1,Case_ID,getdate(),@s_a_UserName,@DomainID FROM tblCase WHERE FK_Packet_ID IN (SELECT Packet_Auto_ID FROM tblPacket WHERE PacketID = @s_a_PacketID AND DomainID =@DomainID)          
		COMMIT TRAN 
	END
	ELSE
	BEGIN
		SET @s_l_message	=  'Packet ID Not Exists - ' + @s_a_PacketID
		SET @i_l_result    =  0
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

