-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP PROCEDURE [dbo].[Reteive_LawFirm_By_Provider] 
CREATE PROCEDURE [dbo].[LawFirm_Details_Retrive] 
    @s_a_DomainId varchar(50) --,
	--@i_a_providerId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    Select LawFirmName, Client_Billing_Address, Client_Billing_City, Client_Billing_State,Client_Billing_Zip,
	 Client_Billing_Phone, Client_Billing_Fax from tbl_Client c 
	 --inner join tblprovider p on c.DomainId=p.DomainId 
	 --where --provider_id=@i_a_providerId and 
	 where c.DomainId = @s_a_DomainId
END
