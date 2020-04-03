CREATE PROCEDURE [dbo].[Get_BatchReport] 
(
	@provider_id int,
	@fromdate varchar(10),
	@todate varchar(10)
)
  
AS  

	select provider_id,box_rec_date,batch_no,max(no_of_cases) as no_of_cases
	,isnull((select count(provider_id) from tblcase where provider_id=tblproviderboxdetails.provider_id 
	and batchcode=tblproviderboxdetails.batch_no 
	),0) as file_scanned,(max(no_of_cases)-isnull((select count(provider_id) from tblcase where provider_id=tblproviderboxdetails.provider_id 
	and batchcode=tblproviderboxdetails.batch_no 
	),0)) as file_pending from tblproviderboxdetails 
	where provider_id=@provider_id and file_pending>0 
	and CAST(FLOOR(CAST(box_rec_date AS FLOAT))AS DATETIME) >=@fromdate 
	and CAST(FLOOR(CAST(box_rec_date AS FLOAT))AS DATETIME) <=@todate
	group by provider_id,batch_no,box_rec_date
	order by provider_id,box_rec_date,batch_no

