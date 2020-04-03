CREATE PROCEDURE [dbo].[procimagelist_for_arbitration_New]  --[procimagelist_for_arbitration_New]'FH13-157920'
(  
@case_id varchar(50)  
)  
as  
BEGIN  

	DECLARE @provider_id int
	
	SET @provider_id =(SELect TblProvider.Provider_Id from TblProvider inner join tblcase on tblcase.Provider_Id =tblprovider.Provider_Id Where Case_Id =@case_id)
	
	
	create table #temp(fileName varchar(100))  

	-------------DENIAL OF CLAIM
	If Exists(Select Case_Id from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\DENIAL OF CLAIM.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	
	-------EXPLANATION OF BENEFITS-------
	If Exists(Select Case_Id from tblimages where documentid in ('23') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\EXPLANATION OF BENEFITS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('23') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	ELSE
	BEGIN
	insert into #temp  
		select'exhibits\Arb\EXPLANATION OF BENEFITS.tif'
	END
	
	---VERIFICATION REQUESTS
	If Exists(Select Case_Id from tblimages where documentid in ('45') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\VERIFICATION REQUESTS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('45') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	ELSE
	BEGIN
	insert into #temp  
		select 'exhibits\Arb\VERIFICATION REQUESTS.tif'
	END
	
	---------CHECK OF PAYMENTS---------
	If Exists(Select Case_Id from tblimages where documentid in ('423','4') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\CHECK OF PAYMENTS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('423','4') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	
	---------VERIFICATION OF TREATMENT----------
	If Exists(Select Case_Id from tblimages where documentid in ('13') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\VERIFICATION OF TREATMENT.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('13') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	
	---------ASSIGNMENT OF BENEFITS---------------
	If Exists(Select Case_Id from tblimages where documentid in ('11') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\ASSIGNMENT OF BENEFITS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('11') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END	
	
	---------Supporting Doc---------------
	IF (@provider_id ='40425')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\SUPPORTING DOCUMENTS.tif'
		
		insert into #temp  
		Select 'exhibits\Arb\S1.tif'
		union Select 'exhibits\Arb\S2.tif'
		union Select 'exhibits\Arb\S3.tif'
		union Select 'exhibits\Arb\S4.tif'
		union Select 'exhibits\Arb\S5.tif'
		union Select 'exhibits\Arb\S6.tif'
		union Select 'exhibits\Arb\S7.tif'
		union Select 'exhibits\Arb\S8.tif'
		union Select 'exhibits\Arb\S9.tif'
		
		insert into #temp  
		Select 'exhibits\Arb\S10.tif'
		union Select 'exhibits\Arb\S11.tif'
		union Select 'exhibits\Arb\S12.tif'
	END	
		
	----------MEDICAL REPORTS----------
	If Exists(Select Case_Id from tblimages where documentid in ('29') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\MEDICAL REPORTS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('29') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END	
	
	-------------PROOF OF MAILING-----------
	If Exists(Select Case_Id from tblimages where documentid in ('12') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\PROOF OF MAILING.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('12') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END	
	
	---------POLICE REPORT----------------	
	If Exists(Select Case_Id from tblimages where documentid in ('27') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\POLICE REPORT.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('27') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END		
	
	--------PEER REVIEW----------
	If Exists(Select Case_Id from tblimages where documentid in ('32') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\PEER REVIEW.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('32') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END		
	

	select  * from #temp  
	drop table #temp  
END

