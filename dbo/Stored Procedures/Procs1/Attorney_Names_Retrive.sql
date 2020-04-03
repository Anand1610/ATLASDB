
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Attorney_Names_Retrive] 
	-- Add the parameters for the stored procedure here
	@s_a_DomainID NVARCHAR(512),
	@i_a_Attorney_Type_Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 0 AS Attorney_Id,'--Select Attorney Name--' AS AttorneyName
	UNION
	SELECT
	Attorney_Id
	, (ISNULL(Attorney_FirstName,'') + ' '+ ISNULL(Attorney_LastName,'')) AS AttorneyName
	from tblAttorney_Master WITH (NOLOCK)
	WHERE 
	DomainId=@s_a_DomainID
	AND Attorney_Type_Id=@i_a_Attorney_Type_Id
	Order by AttorneyName,Attorney_Id

END

