/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Information] 
	 @i_a_provider_id int,
	 @s_a_Provider_GroupName nvarchar(500),
     @s_a_DomainId varchar(50)
AS
BEGIN
	    SET NOCOUNT ON;

		SELECT 
			 provider_name 
			,provider_local_address
			,provider_billing
			,cost_balance
			,Provider_GroupName
	   from tblprovider(NOLOCK) 
	   where (provider_id = @i_a_provider_id or Provider_GroupName = @s_a_Provider_GroupName) 
	   and (provider_id != 0 or Provider_GroupName != '')
	   and DomainId = @s_a_DomainId
END