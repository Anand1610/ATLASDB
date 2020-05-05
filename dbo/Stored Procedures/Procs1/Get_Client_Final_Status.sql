/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Final_Status] 
    @i_a_provider_id int,
	@s_a_DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
		final_status
		,count(distinct case_id) as [Count_Cases]  
	FROM tblCASE(NOLOCK) LEFT OUTER JOIN tblStatus(NOLOCK) ON  tblCASE.Status = Status_Abr and tblcase.DomainId = tblStatus.DomainId
	WHERE provider_id = @i_a_provider_id and tblCASE.DomainId = @s_a_DomainId and status <> 'IN ARB OR LIT' 
	group by final_status order by final_status
	
END