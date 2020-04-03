
CREATE PROCEDURE [dbo].[TransactionType_DDL]
@DomainId varchar(50)=null
AS
BEGIN
    SELECT '0 'AS payment_value,' ---Select--- ' AS payment_type, '0' AS autoid 
	UNION
	SELECT   DISTINCT payment_value, 
					payment_type, 
					autoid
	FROM			tblTransactionType
	ORDER BY		payment_type
END

