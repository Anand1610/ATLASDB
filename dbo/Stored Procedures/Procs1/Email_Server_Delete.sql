
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Email_Server_Delete] 
	-- Add the parameters for the stored procedure here
	@DomainId nvarchar(100),
	@i_a_auto_id nvarchar(100)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @s_l_message NVARCHAR(500)
    
	delete from Email_Server where DomainID=@DomainId AND AutoID = @i_a_auto_id
	SET @s_l_message= 'Record deleted'
	SELECT @s_l_message AS [MESSAGE]
END

