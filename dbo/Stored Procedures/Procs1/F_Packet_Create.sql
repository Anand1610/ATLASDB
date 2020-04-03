
CREATE PROCEDURE [dbo].[F_Packet_Create]
(
	@DomainID VARCHAR(50),
	@s_a_caption VARCHAR(MAX),
	@i_a_CaseType_Id INT,
	@s_a_MultipleCase_ID VARCHAR(MAX),
	@s_a_UserName NVARCHAR(100)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @i_l_result INT
	DECLARE @s_l_message NVARCHAR(500)

	IF(@i_a_CaseType_Id= 0)
		SET @i_a_CaseType_Id = Null
		
	IF NOT EXISTS(SELECT Case_ID FROM tblCase INNER JOIN tblPacket ON tblCase.FK_Packet_ID = tblPacket.Packet_Auto_ID  WHERE tblCase.DomainID =@DomainID AND Case_Id  IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
	BEGIN
		DECLARE @MaxPacket_ID VARCHAR(100)
		DECLARE @MaxPacketAuto_ID INTEGER
		DECLARE @PacketID VARCHAR(50)
		DECLARE @NDesc varchar(500)   
		SET @MaxPacket_ID=ISNULL((SELECT top 1 tblPacket.PacketID FROM tblPacket  WHERE DomainId=@DomainID 
							ORDER BY Packet_Auto_ID DESC),'100000')

		SET @MaxPacketAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxPacket_ID,'-') Order by autoid desc)
		SET @PacketID  = Upper(@DomainID) +'-PKT' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxPacketAuto_ID AS NVARCHAR)
	      
		BEGIN TRAN
			INSERT INTO tblPacket
			(
				PacketID,
				PacketCaption,
				FK_CaseType_Id,
				DomainId		
			)
			VALUES
			(
				@PacketID,
				@s_a_caption,
				@i_a_CaseType_Id,
				@DomainID		
			)
			SET @s_l_message	=  'Packet create successfuly - Packet ID : ' + @PacketID
			SET @i_l_result    =  SCOPE_IDENTITY()
			
			UPDATE tblCase 
			SET FK_Packet_ID = @i_l_result
			WHERE DomainID =@DomainID AND Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,','))
			
			set @NDesc = 'Case added to Packet : ' + @PacketID
			
			INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
			SELECT @NDesc,'Activity',1,s,getdate(),@s_a_UserName,@DomainID FROM dbo.SplitString(@s_a_MultipleCase_ID,',')      
		COMMIT TRAN 
	END
	ELSE
	BEGIN
		DECLARE @s_l_Case_ID VARCHAR(50)
		
		SET @s_l_Case_ID = (SELECT top 1 Case_ID FROM tblCase INNER JOIN tblPacket ON tblCase.FK_Packet_ID = tblPacket.Packet_Auto_ID  WHERE tblCase.DomainId = @DomainID AND Case_Id  IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')))
		SET @s_l_message	= 'Packet not created. Case ID is already '+ @s_l_Case_ID +' associated with packet.'
		SET @i_l_result		=  0
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

