CREATE PROCEDURE [dbo].[Get_ProviderBoxDetails] 
(
	@provider_name varchar(100)
)
  
AS  
BEGIN

	SELECT provider_name,batch_no,convert(varchar(10),box_rec_Date,101) as box_rec_Date,no_of_cases,ISNULL(UserName,'') AS UserName
	FROM tblProviderBoxDetails
	WHERE provider_name like @provider_name + '%' and box_rec_date is not null 
	ORDER BY provider_name

End

