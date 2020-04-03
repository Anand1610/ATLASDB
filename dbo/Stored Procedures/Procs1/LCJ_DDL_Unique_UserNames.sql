CREATE PROCEDURE [dbo].[LCJ_DDL_Unique_UserNames]  
As 
Begin	
select '0' as userid,'...Select...' as userName
union
select distinct username [userid],userName from issuetracker_users where (userName not in('')) order by userName
end

