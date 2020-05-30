CREATE PROCEDURE [dbo].[LCJ_DeleteTreatment]
(
@DomainId	nvarchar(50),
@Treatment_Id nvarchar(3000),
@User_Id VARCHAR(50)
)


AS
begin

DECLARE @DOS_START VARCHAR(12)
DECLARE @DOS_END VARCHAR(12)
DECLARE @CASE_ID VARCHAR(50)
DECLARE @desc varchar(1000)
SET @DOS_START = (SELECT CONVERT(VARCHAR(20),DateOfService_Start,100) from tblTreatment where Treatment_Id = + @Treatment_Id)
SET @DOS_END = (SELECT CONVERT(VARCHAR(20),DateOfService_End,100) from tblTreatment where Treatment_Id = + @Treatment_Id)
SET @CASE_ID = (SELECT Case_Id from tblTreatment where Treatment_Id = + @Treatment_Id )

SET @desc = 'Bill deleted for DOS ' + @DOS_START + ' - ' + @DOS_END

exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@case_id,@notes_type='Activity',@Ndesc=@desc,@User_id=@User_Id,@Applytogroup=0


DELETE from TXN_tblTreatment where Treatment_Id = + @Treatment_Id
DELETE from TXN_CASE_PEER_REVIEW_DOCTOR where Treatment_Id = + @Treatment_Id
DELETE from TXN_CASE_Treating_Doctor where Treatment_Id = + @Treatment_Id
DELETE from tblTreatment where Treatment_Id = + @Treatment_Id
DELETE FROM BILLS_WITH_PROCEDURE_CODES WHERE fk_Treatment_Id=@Treatment_Id


exec Update_Denial_Case @CASE_ID

end

