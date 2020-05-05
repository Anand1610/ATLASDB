/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Initial_Status] 
    @i_a_provider_id int,
	@s_a_DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

   SELECT 
		 initial_status
		,count(distinct case_id) as [Count_Cases] 
	FROM tblcase(NOLOCK)
	WHERE provider_id = @i_a_provider_id and DomainId = @s_a_DomainId and STATUS <> 'IN ARB OR LIT' 
	group by initial_status order by initial_status
    
END