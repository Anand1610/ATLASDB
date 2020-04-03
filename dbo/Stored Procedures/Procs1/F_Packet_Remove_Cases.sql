
CREATE PROCEDURE [dbo].[F_Packet_Remove_Cases]
(
	@DomainID VARCHAR(50),
	@s_a_MultipleCase_ID VARCHAR(MAX),
	@s_a_UserName NVARCHAR(100)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @i_l_result INT
	DECLARE @s_l_message NVARCHAR(500)

		      
			BEGIN TRAN
				DECLARE @NDesc varchar(500) 
				SET @s_l_message	=  'Cases successfuly removed from Packet' 


				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
				SELECT 'Case removed from Packet : ' + PacketID, 'Activity',1,Case_Id,getdate(),@s_a_UserName, @DomainID FROM tblCase INNER JOIN tblPacket ON tblCase.FK_Packet_ID = tblPacket.Packet_Auto_ID WHERE tblCase.DomainId =@DomainID AND Case_Id  IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,','))

				UPDATE tblCase 
				SET FK_Packet_ID = null
				WHERE Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) And DomainId =@DomainID

				    
			COMMIT TRAN 
	

	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

