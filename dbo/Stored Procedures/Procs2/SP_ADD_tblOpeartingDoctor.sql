CREATE PROCEDURE [dbo].[SP_ADD_tblOpeartingDoctor]
@DomainId nvarchar(50),
@DOCTOR_NAME NVARCHAR(100)
AS
BEGIN
 INSERT INTO TblOperatingDoctor (Doctor_Name, Active, DomainId)
	VALUES(@DOCTOR_NAME,1,@DomainId)
 
END

