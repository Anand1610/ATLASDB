CREATE PROCEDURE [dbo].[SP_GET_TREATINGDOCTOR_DETAILS]
(	@domainId				   nvarchar(50),
	@Treatment_Id int  
)
AS
SELECT ID, D.DOCTOR_NAME
FROM txn_case_treating_doctor TXN, tblOperatingDoctor D
WHERE D.DOCTOR_ID = TXN.DOCTOR_ID and TREATMENT_ID=@Treatment_Id
and TXN.DomainId = @domainId



