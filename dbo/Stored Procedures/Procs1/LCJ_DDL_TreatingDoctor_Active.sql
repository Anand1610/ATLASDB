

CREATE PROCEDURE [dbo].[LCJ_DDL_TreatingDoctor_Active]
@DomainId NVARCHAR(50)		
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT ' --- Select Treating Doctor --- '  as Doctor_Name, '0' Doctor_id
	UNION
	SELECT DOCTOR_NAME, DOCTOR_ID FROM tblOperatingDoctor
	WHERE ACTIVE=1 and DomainId=@DomainId
	ORDER BY DOCTOR_NAME
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FHA_DDL_ReviewingDoctor_Active]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FHA_DDL_ReviewingDoctor_Active]

