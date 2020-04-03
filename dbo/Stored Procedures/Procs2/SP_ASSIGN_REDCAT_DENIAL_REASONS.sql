CREATE PROCEDURE [dbo].[SP_ASSIGN_REDCAT_DENIAL_REASONS]
	@DomainId NVARCHAR(50),
	@s_a_case_id AS VARCHAR(100)
AS
BEGIN

IF EXISTS( SELECT TOP 1 case_ID from tblTreatment 
   INNER JOIN TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
   INNER JOIN tblDenialReasons on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
   where I_CATEGORY_ID = 2 and tblDenialReasons.DenialReasons_Id<>0 and case_id=@s_a_case_id and tblTreatment.DomainId=@DomainId
		 )
BEGIN
	exec [ASSIGN_ANSWER_RECD] @DomainId, @s_a_case_id

END

END

