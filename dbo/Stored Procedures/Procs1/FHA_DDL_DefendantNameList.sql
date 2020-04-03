-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FHA_DDL_DefendantNameList]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		SELECT DISTINCT
		Defendant_Id,DEFENDANT_DISPLAYNAME
		AS 
		Defendant_Name
		FROM         tblDEFENDANT
		WHERE
		(1 = 1 ) AND (Active=1 )
ORDER BY DEFENDANT_NAME ASC


END

