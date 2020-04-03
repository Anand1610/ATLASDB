﻿CREATE PROCEDURE [dbo].[SP_GET_TREATMENT_DOCTOR]
	(@DomainID NVARCHAR(50),
	@Treatment_Id int  )
AS
SELECT ID, D.DOCTOR_NAME
FROM TXN_CASE_PEER_REVIEW_DOCTOR TXN, TblReviewingDoctor D
WHERE D.DOCTOR_ID = TXN.DOCTOR_ID and TREATMENT_ID=@Treatment_Id
and TXN.DomainId = @domainId

