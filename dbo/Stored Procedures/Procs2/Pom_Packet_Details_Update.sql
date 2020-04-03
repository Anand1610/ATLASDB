-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Pom_Packet_Details_Update] 
	-- Add the parameters for the stored procedure here
	@POM_PacketFileName varchar(500),
	@pom_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update tblPomCase set POM_PacketFileName=@POM_PacketFileName where pom_id=@pom_id
END
