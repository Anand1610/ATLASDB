-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_TypeOfBatchPrint]
	-- Add the parameters for the stored procedure here
	@DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	Select 
	'---Select Type of Printing---' As Printing_Type,
	'---Select Type of Printing---' As Printing_Type
	union
    Select 
	Printing_Type
	,Printing_Type 
	from  [dbo].[TypeOfBatchPrint]
	Where Domain_Id = @DomainId
END
