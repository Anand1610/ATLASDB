--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[I_ProviderBoxDetails] --[I_ProviderBoxDetails] '943','Acupuncture Prime Care, P.C.','10/19/2010',100,'Delivered'
  
(  
	@Provider_Id varchar(50), 
	@Provider_Name varchar(100),
	@BoxRevDate varchar(50),
	@No_Of_Cases int,  
	@status  varchar(50)       
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

	set @batchright =(select isnull(max(batch_no),'') from tblProviderBoxDetails where provider_id=@Provider_Id and box_rec_date=@BoxRevDate)
	
	set @proname= (select left(ltrim(@Provider_Name),5)) 

	set @yy= (select right(ltrim(year(@BoxRevDate)),2))
	
	set @mm= (select month(@BoxRevDate))

	set @dd = (select day(@BoxRevDate))

				
	set @batch =(CAST(@proname AS varchar(12)) + CAST(@yy AS varchar(12)) + CAST(@mm AS varchar(12))+ CAST(@dd AS varchar(12))+CAST(101 AS varchar(12)))
	print @batch
	
	if(@batchright='')

		Begin
			
			set @newbatch = (select isnull(max(batch_no),'1') from tblProviderBoxDetails where batch_no=@batch)
			print  @newbatch
			if (@newbatch='1')
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
					file_pending
					)
					values(@Provider_Id, @Provider_Name,@BoxRevDate,@No_Of_Cases,@status,@batch,0,@No_Of_Cases)
				end
			else 
				Begin
				declare @per varchar(5)
				declare @like varchar(20)
				set @per='%'	
				set @like =CAST(@proname AS varchar(12)) + CAST(@per AS varchar(12))
				set @cntbatch= (select right(max(batch_no),3)+100 from tblProviderBoxDetails where provider_name like @like)
				print @cntbatch
				print @proname
				print @yy
				print @mm
				print @dd

				set @ibatch= (CAST(@proname AS varchar(12)) + CAST(@yy AS varchar(12)) + CAST(@mm AS varchar(12))+ CAST(@dd AS varchar(12))+CAST(@cntbatch AS varchar(12)))
				print @ibatch

				insert into tblProviderBoxDetails
					(
						provider_id,
						provider_name,
						box_rec_date,
						no_of_cases,
						status,
						batch_no,
						file_scanned,
						file_pending
					)
					values(@Provider_Id, @Provider_Name,@BoxRevDate,@No_Of_Cases,@status,@ibatch,0,@No_Of_Cases)
				end
			

		select max(batch_no) as batch_no from tblProviderBoxDetails where provider_id=@Provider_Id and box_rec_date=@BoxRevDate --and batch_no=@batch
		end

	else
		Begin
			declare @batchext varchar(5)
			set @batchext = (select right(@batchright,3) + 1 )

			set @proname= (select left(ltrim(@Provider_Name),5)) 
			set @yy= (select right(ltrim(year(@BoxRevDate)),2))
			set @mm= (select month(@BoxRevDate))
			set @dd = (select day(@BoxRevDate))

			set @batch =CAST(@proname AS varchar(12)) + CAST(@yy AS varchar(12)) + CAST(@mm AS varchar(12))+ CAST(@dd AS varchar(12))+CAST(@batchext AS varchar(12))

			insert into tblProviderBoxDetails
			(
			provider_id,
			provider_name,
			box_rec_date,
			no_of_cases,
			status,
			batch_no,
			file_scanned,
			file_pending
			)
			values(@Provider_Id, @Provider_Name,@BoxRevDate,@No_Of_Cases,@status,@batch,0,@No_Of_Cases)

		select max(batch_no) as batch_no  from tblProviderBoxDetails where provider_id=@Provider_Id and box_rec_date=@BoxRevDate and batch_no=@batch
			
		end
End

