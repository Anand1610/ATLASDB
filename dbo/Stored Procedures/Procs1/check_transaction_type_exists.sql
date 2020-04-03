
--check_transaction_type_exists 'localhost','Pre-Litigation Collected (PreC - From Insurer)'

CREATE PROCEDURE [dbo].[check_transaction_type_exists]
(     
	@DomainId			VARCHAR(50),
	@TransactionType	VARCHAR(MAX)
)
AS      
BEGIN      
	SELECT
		COUNT(*) AS count
	FROM
		tblTransactionType
	WHERE
		--DomainId		=	@DomainId AND
		payment_type	=	@TransactionType
END  

  
