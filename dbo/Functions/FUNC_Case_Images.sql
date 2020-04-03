-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FUNC_Case_Images]
(@CASE_ID varchar(50)
)
RETURNS  int
AS
BEGIN
	
	declare @value int
SELECT @value=COUNT(ImageId) FROM tblImages WHERE Case_Id = @CASE_ID

return @value 

END
