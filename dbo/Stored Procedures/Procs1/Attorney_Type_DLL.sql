
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE PROCEDURE [dbo].[Attorney_Type_DLL]  --[Attorney_Type_Retrive] 'test2'
	-- Add the parameters for the stored procedure here
	@DomainID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT '--Select Attorney Type--' as Attorney_Type,0 as Attorney_Type_ID
	UNION
	SELECT
	Attorney_Type,
	Attorney_Type_ID
	FROM tblAttorney_Type with (NOLOCK)
	WHERE 
	DomainID=@DomainID 
	ORDER BY
	Attorney_Type ASC
END

