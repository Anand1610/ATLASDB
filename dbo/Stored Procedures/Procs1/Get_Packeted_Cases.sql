-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Packeted_Cases] 
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @PacketId int

	Select @PacketId = isnull(FK_Packet_ID, 0) from tblCase(NOLOCK) where Case_Id = @s_a_CaseId and DomainId = @s_a_DomainId

	Select Case_Id from tblCase(NOLOCK) 
	where (Case_Id=@s_a_CaseId or (@PacketId != 0 and FK_Packet_ID=@PacketId)) and DomainId = @s_a_DomainId

END
