-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_ARB_BatchCode] 
	-- Add the parameters for the stored procedure here
	@DomainId nvarchar(50),
	@s_a_Type nvarchar(50),
	@Output nvarchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @ExistingBatchCode Nvarchar(50)
	if(@s_a_Type = 'Arbitration Submission')
	BEGIN
	Select @ExistingBatchCode= BatchCode  from tblArbitrationCases where DomainId=@DomainId AND AutoId=(select Max(AutoId) from tblArbitrationCases where DomainId=@DomainId)
	END
	ELSE IF(@s_a_Type = 'Amended AR1')
	BEGIN
	Select @ExistingBatchCode= BatchCode  from tblBatchMailSend where DomainId=@DomainId AND MailSendDate=(select Max(MailSendDate) from tblBatchMailSend where DomainId=@DomainId)
	END

	if(@ExistingBatchCode IS NULL)
	BEGIN
	  Select @Output= 'ARB-000000001'
	END
	ELSE
	BEGIN
	select @Output ='ARB-'+ right( POWER(10, 9) + (SELECT CAST( SUBSTRING(@ExistingBatchCode, CHARINDEX('-', @ExistingBatchCode)+1, 9) AS bigint)+1), 9)
	END


	--SET @Output=@ExistingBatchCode
	
	select @Output
END
