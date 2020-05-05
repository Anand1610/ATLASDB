/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Firm_Details]
	@DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	 
	 Select top 1 
		LawFirmName, 
		Client_Billing_Address, 
		Client_Billing_City, 
		Client_Billing_State,
		Client_Billing_Zip, 
		Client_Billing_Phone, 
		Client_Billing_Fax 
    from tbl_Client c(NOLOCK) where c.DomainId = @DomainId
END