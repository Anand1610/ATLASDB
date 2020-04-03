
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Required_Documents_Delete] 
(	
	@i_a_ID int,
	@s_a_DomainID varchar(50)	
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500)


	DELETE FROM Required_Documents where ID = @i_a_ID and DomainID = @s_a_DomainID
	--UPDATE  Required_Documents 
	--SET Complted_Date = GETDATE(), isCompleted = 1
	--where ID = @i_a_ID and DomainID = @s_a_DomainID

	SET @s_l_message= 'Record deleted successfuly'
	SELECT @s_l_message AS [MESSAGE]
END
