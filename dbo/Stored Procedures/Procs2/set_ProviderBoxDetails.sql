--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[set_ProviderBoxDetails] --[set_ProviderBoxDetails] '943','Acupuncture Prime Care, P.C.','10/19/2010',100,'Delivered'
  
(  
	@Provider_Id varchar(50), 
	@Provider_Name varchar(100),
	@BoxRevDate varchar(50),
	@No_Of_Cases int,  
	@status  varchar(50),
	@UserName varchar(510)       
)  
AS  
BEGIN
	declare @batchright varchar(50)
	declare @batch varchar(50)
	declare @proname varchar(5)
	declare @yy varchar(2)
	declare @mm varchar(2)
	declare @dd varchar(2)
	declare @newbatch varchar(50)
	declare @cntbatch varchar(5)
	declare @ibatch varchar(50)	

	set @batchright =(select isnull((right(max(batch_no),3)+1),101) from tblProviderBoxDetails where box_rec_date=@BoxRevDate)
	set @proname= (select left(ltrim(@Provider_Name),5)) 
	set @yy= (select right(ltrim(year(@BoxRevDate)),2))
	set @mm= (select month(@BoxRevDate))
	set @dd = (select day(@BoxRevDate))
			
	set @batch =(CAST(@proname AS varchar(12)) + CAST(@yy AS varchar(12)) + CAST(@mm AS varchar(12))+ CAST(@dd AS varchar(12))+CAST(@batchright AS varchar(12)))
	print @batch
	

	Begin
		insert into tblProviderBoxDetails
		(
		provider_id,
		provider_name,
		box_rec_date,
		no_of_cases,
		status,
		batch_no,
		file_scanned,
		file_pending,
		UserName
		)
		values(@Provider_Id, @Provider_Name,@BoxRevDate,@No_Of_Cases,@status,@batch,0,@No_Of_Cases,@UserName)
	end

			

	select max(batch_no) as batch_no from tblProviderBoxDetails where provider_id=@Provider_Id and box_rec_date=@BoxRevDate --and batch_no=@batch
		
End

