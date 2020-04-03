-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Task_Delete] 
	@Task_ID int,
	@DomainID varchar(50),
	@Case_ID varchar(50)
AS
BEGIN
	Delete from Task Where Task_ID = @Task_ID and DomainID = @DomainID and Case_ID = @Case_ID
END
