CREATE PROCEDURE [dbo].[Get_BatchBreakDownDetail_ProvGroupNm] 
(
	@Prov_GroupName nvarchar(100),
	@fromdate int
)
  
AS
	select provider_id,box_rec_date,batch_no,max(no_of_cases) as no_of_cases 
	,isnull((select count(provider_id) from tblcase where provider_id=tblproviderboxdetails.provider_id 
	and batchcode=tblproviderboxdetails.batch_no 
	),0) as file_scanned,(max(no_of_cases)-isnull((select count(provider_id) from tblcase where provider_id=tblproviderboxdetails.provider_id 
	and batchcode=tblproviderboxdetails.batch_no 
	),0)) as file_pending from tblproviderboxdetails 
	where provider_id in (select provider_id from tblprovider where provider_groupName=@Prov_GroupName) and file_pending>0 
	and datediff(m,box_rec_date,getdate())<=@fromdate
	group by provider_id,batch_no,box_rec_date

