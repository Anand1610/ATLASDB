-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Total_Client_Payment]
	@i_a_ProviderId int,
	@s_a_DomainId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select  sum(Payment_Amount) As Payment_Amount from tblclientpayment
	where provider_id= @i_a_ProviderId and DomainId= @s_a_DomainId
END
