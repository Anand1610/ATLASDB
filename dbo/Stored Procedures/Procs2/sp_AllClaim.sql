CREATE PROCEDURE [dbo].[sp_AllClaim](@cid varchar(50),@UID VARCHAR(100)='admin')
as
select *,USER_INITIALS = (CASE @UID 
								 
								 WHEN 'admin' THEN 'adm' 
								  ELSE 'ab' END)
from LCJ_VW_CaseSearchDetails_RTF where case_id =@cid

