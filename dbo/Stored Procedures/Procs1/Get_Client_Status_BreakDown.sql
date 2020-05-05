/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[Get_Client_Status_BreakDown]
	@i_a_provider_id int,
	@s_a_DomainId varchar(50)
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT DISTINCT 
		c.status,
		count(distinct case_id) as [Count_Cases] 
	FROM tblcase c(NOLOCK) inner join tblStatus s (NOLOCK)  on s.Status_Type=c.Status and s.DomainId= @s_a_DomainId   
	WHERE c.DomainId= @s_a_DomainId and provider_id=@i_a_provider_id and status <> 'IN ARB OR LIT' 
	group by status,s.hierarchy_Id,s.forum order by c.status asc

END