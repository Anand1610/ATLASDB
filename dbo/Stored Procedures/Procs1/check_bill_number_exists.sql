
--check_bill_number_exists 'localhost','HY2612'

CREATE PROCEDURE [dbo].[check_bill_number_exists]
(     
	@DomainId	VARCHAR(50),
	@BillNumber	VARCHAR(100)
)
AS      
BEGIN      
	SELECT
		COUNT(1) AS count
	FROM
		tblTreatment T (NOLOCK)
	WHERE
		T.DomainId		=	@DomainId AND
		T.BILL_NUMBER	=	@BillNumber
END  

  
