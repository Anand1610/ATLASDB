CREATE PROCEDURE [dbo].[verification_response_template_data]
@i_verification_id	INT,
@DomainID			VARCHAR(50)
AS
BEGIN
	select TOP 1
		i_verification_id,
		VERIFICATION_REQUEST_DATE=isnull(convert(nvarchar(10),dt_verification_received,101),''),		
		VERIFICATION_RESPONSE_NOTES=ISNULL(VerificationResponse,''),
		BILL_NUMBER=(SELECT TOP 1 T.BILL_NUMBER FROM tblTreatment T WHERE ISNULL(T.BILL_NUMBER,'') <> '' AND T.Case_Id = VR.SZ_CASE_ID AND T.DomainId = VR.DomainId)
	from
		TXN_VERIFICATION_REQUEST VR
	where 
		VR.i_verification_id	=	@i_verification_id AND 
		VR.DomainID				=	@DomainID
END
