CREATE PROCEDURE [dbo].[SP_GET_REJECTION_REQUEST]-- [SP_GET_REJECTION_REQUEST] 'FH12-95855','REQUEST LIST'
(  
   @Case_ID nvarchar(50),
   @List_Status nvarchar(50)
)  
as  
begin  
	
	select List_Id ,List_Name,
	isnull((select case when isnull(List_Id,0) <> '0' then 1 
			else 0 end from tblREJECTION_REQUEST 
			where case_id= @Case_ID and List_Id = MST.List_Id),0) as upload_status 
	from MST_REQUEST_REJECTION_MASTER MST 
	where List_Status = @List_Status
	order by List_Name
end

