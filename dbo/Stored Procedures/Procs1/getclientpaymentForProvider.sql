CREATE PROCEDURE [dbo].[getclientpaymentForProvider] --getclientpaymentForProvider '4541','bt'
@provider_id INT,
@DomainId VARCHAR(10)
AS
BEGIN
	SELECT	clientpaymentid,
			payment_amount,
			convert(date,payment_date,110)[payment_date], 
			Payment_Desc
	FROM	tblclientpayment
	 WHERE 
			provider_id=@provider_id
			and DomainId= @DomainId
	ORDER BY Payment_Date
END