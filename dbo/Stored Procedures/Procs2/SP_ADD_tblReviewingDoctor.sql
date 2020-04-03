CREATE PROCEDURE [dbo].[SP_ADD_tblReviewingDoctor]
@DomainId NVARCHAR(50),
@DOCTOR_NAME NVARCHAR(max)
AS
BEGIN
IF(@DOCTOR_NAME <> '')
			BEGIN
					 INSERT INTO TblReviewingDoctor(Doctor_Name,Active,DomainID)  VALUES(@DOCTOR_NAME,1,@DomainId)
			END
END

--select * from TblReviewingDoctor order by Doctor_Name asc
--INSERT INTO TblReviewingDoctor VALUES('test',0)

