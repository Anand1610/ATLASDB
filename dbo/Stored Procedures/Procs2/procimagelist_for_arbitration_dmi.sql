CREATE PROCEDURE [dbo].[procimagelist_for_arbitration_dmi]  --[procimagelist_for_arbitration_dmi] 'FH12-101093'
(  
@case_id varchar(50)  
)  
as  
BEGIN  

	DECLARE @provider_id int
	
	SET @provider_id =(SELect TblProvider.Provider_Id from TblProvider inner join tblcase on tblcase.Provider_Id =tblprovider.Provider_Id Where Case_Id =@case_id)
	
	
	create table #temp(fileName varchar(100))  
	
	---------VERIFICATION OF TREATMENT(BILLS)
	If Exists(Select Case_Id from tblimages where documentid in ('13') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\VERIFICATION OF TREATMENT.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('13') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	
	---------ASSIGNMENT OF BENEFITS(A.O.B)---------------
	If Exists(Select Case_Id from tblimages where documentid in ('11') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\ASSIGNMENT OF BENEFITS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('11') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END

	-------------DENIAL OF CLAIM(DENIALS)
	If Exists(Select Case_Id from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\DENIAL OF CLAIM.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END
	
	
	
	---VERIFICATION REQUESTS(VERIFICATION REQUEST)
	IF Not Exists(Select Case_Id from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	Begin
		If Exists(Select Case_Id from tblimages where documentid in ('45') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
		BEGIN
			insert into #temp  
			select 'exhibits\Arb\VERIFICATION REQUESTS.tif'
			
			insert into #temp 
			select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('45') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
		END
		Else
		Begin
			If Exists(Select Case_Id from tblimages where documentid in ('465') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
			BEGIN
				insert into #temp  
				select 'exhibits\Arb\VERIFICATION REQUESTS.tif'
				
				insert into #temp 
				select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('465') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
			END
		End
	End
	
	----------MEDICAL REPORTS(MEDICAL REPORTS)----------
	If Exists(Select Case_Id from tblimages where documentid in ('29') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	BEGIN
		insert into #temp  
		select 'exhibits\Arb\MEDICAL REPORTS.tif'
		
		insert into #temp 
		select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('29') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END	
	
	-------------PROOF OF MAILING(PROOF OF MAILING)-----------
	---- You Need Poof of mailing --------
	--IF  Exists(Select Case_Id from tblimages where documentid in ('12') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	
	--- You did not need PROOF of mailing if denial exist
	IF Not Exists(Select Case_Id from tblimages where documentid in ('14') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	
	
	Begin
		If Exists(Select Case_Id from tblimages where documentid in ('12') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '')
	--	BEGIN
			insert into #temp  
			select 'exhibits\Arb\PROOF OF MAILING.tif'
			
			insert into #temp 
			select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in ('12') and case_id = @case_id  and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '' order by imageid asc
	END	
	--End
	
	---------Supporting Doc---------------	
		insert into #temp  
		select 'exhibits\Arb\SUPPORTING DOCUMENTS.tif'
		
		insert into #temp  
		Select 'exhibits\Dmi\EUO0001.tif'
		union Select 'exhibits\Dmi\EUO0002.tif'
		union Select 'exhibits\Dmi\EUO0003.tif'
		union Select 'exhibits\Dmi\EUO0004.tif'
		union Select 'exhibits\Dmi\EUO0005.tif'
		union Select 'exhibits\Dmi\EUO0006.tif'
		union Select 'exhibits\Dmi\EUO0007.tif'
		union Select 'exhibits\Dmi\EUO0008.tif'
		union Select 'exhibits\Dmi\EUO0009.tif'
		union Select 'exhibits\Dmi\EUO0010.tif'
		union Select 'exhibits\Dmi\EUO0011.tif'
		union Select 'exhibits\Dmi\EUO0012.tif'
		union Select 'exhibits\Dmi\EUO0013.tif'
		union Select 'exhibits\Dmi\EUO0014.tif'
		union Select 'exhibits\Dmi\EUO0015.tif'
		union Select 'exhibits\Dmi\EUO0016.tif'
		union Select 'exhibits\Dmi\EUO0017.tif'
		union Select 'exhibits\Dmi\EUO0018.tif'
		union Select 'exhibits\Dmi\EUO0019.tif'
		union Select 'exhibits\Dmi\EUO0020.tif'
		union Select 'exhibits\Dmi\EUO0021.tif'
		union Select 'exhibits\Dmi\EUO0022.tif'
		union Select 'exhibits\Dmi\EUO0023.tif'
		union Select 'exhibits\Dmi\EUO0024.tif'
		union Select 'exhibits\Dmi\EUO0025.tif'
		union Select 'exhibits\Dmi\EUO0026.tif'
		union Select 'exhibits\Dmi\EUO0027.tif'
		union Select 'exhibits\Dmi\EUO0028.tif'
		union Select 'exhibits\Dmi\EUO0029.tif'
		union Select 'exhibits\Dmi\EUO0030.tif'
		union Select 'exhibits\Dmi\EUO0031.tif'
		union Select 'exhibits\Dmi\EUO0032.tif'
		union Select 'exhibits\Dmi\EUO0033.tif'
		union Select 'exhibits\Dmi\EUO0034.tif'
		union Select 'exhibits\Dmi\EUO0035.tif'
		union Select 'exhibits\Dmi\EUO0036.tif'
		union Select 'exhibits\Dmi\EUO0037.tif'
		union Select 'exhibits\Dmi\EUO0038.tif'
		union Select 'exhibits\Dmi\EUO0039.tif'
		union Select 'exhibits\Dmi\EUO0040.tif'
		union Select 'exhibits\Dmi\EUO0041.tif'
		union Select 'exhibits\Dmi\EUO0042.tif'
		union Select 'exhibits\Dmi\EUO0043.tif'
		union Select 'exhibits\Dmi\EUO0044.tif'
		union Select 'exhibits\Dmi\EUO0045.tif'
		union Select 'exhibits\Dmi\EUO0046.tif'
		union Select 'exhibits\Dmi\EUO0047.tif'
		union Select 'exhibits\Dmi\EUO0048.tif'
		union Select 'exhibits\Dmi\EUO0049.tif'
		union Select 'exhibits\Dmi\EUO0050.tif'
		union Select 'exhibits\Dmi\EUO0051.tif'
		union Select 'exhibits\Dmi\EUO0052.tif'
		union Select 'exhibits\Dmi\EUO0053.tif'
		union Select 'exhibits\Dmi\EUO0054.tif'
		union Select 'exhibits\Dmi\EUO0055.tif'
		union Select 'exhibits\Dmi\EUO0056.tif'
		union Select 'exhibits\Dmi\EUO0057.tif'
		union Select 'exhibits\Dmi\EUO0058.tif'
		union Select 'exhibits\Dmi\EUO0059.tif'
		union Select 'exhibits\Dmi\EUO0060.tif'
		union Select 'exhibits\Dmi\EUO0061.tif'
		union Select 'exhibits\Dmi\EUO0062.tif'
		union Select 'exhibits\Dmi\EUO0063.tif'
		union Select 'exhibits\Dmi\EUO0064.tif'
		union Select 'exhibits\Dmi\EUO0065.tif'
		union Select 'exhibits\Dmi\EUO0066.tif'
		union Select 'exhibits\Dmi\EUO0067.tif'
		union Select 'exhibits\Dmi\EUO0068.tif'
		union Select 'exhibits\Dmi\EUO0069.tif'
		union Select 'exhibits\Dmi\EUO0070.tif'
		union Select 'exhibits\Dmi\EUO0071.tif'
		union Select 'exhibits\Dmi\EUO0072.tif'
		union Select 'exhibits\Dmi\EUO0073.tif'
		union Select 'exhibits\Dmi\EUO0074.tif'
		union Select 'exhibits\Dmi\EUO0075.tif'
		union Select 'exhibits\Dmi\EUO0076.tif'
		union Select 'exhibits\Dmi\EUO0077.tif'
		union Select 'exhibits\Dmi\EUO0078.tif'
		union Select 'exhibits\Dmi\EUO0079.tif'
		union Select 'exhibits\Dmi\EUO0080.tif'
		union Select 'exhibits\Dmi\EUO0081.tif'
		union Select 'exhibits\Dmi\EUO0082.tif'
		union Select 'exhibits\Dmi\EUO0083.tif'
		union Select 'exhibits\Dmi\EUO0084.tif'
		union Select 'exhibits\Dmi\EUO0085.tif'
		union Select 'exhibits\Dmi\EUO0086.tif'
		union Select 'exhibits\Dmi\EUO0087.tif'
		union Select 'exhibits\Dmi\EUO0088.tif'
		union Select 'exhibits\Dmi\EUO0089.tif'
		union Select 'exhibits\Dmi\EUO0090.tif'
		union Select 'exhibits\Dmi\EUO0091.tif'
		union Select 'exhibits\Dmi\EUO0092.tif'
		union Select 'exhibits\Dmi\EUO0093.tif'
		union Select 'exhibits\Dmi\EUO0094.tif'
		union Select 'exhibits\Dmi\EUO0095.tif'
		union Select 'exhibits\Dmi\EUO0096.tif'
		union Select 'exhibits\Dmi\EUO0097.tif'
		union Select 'exhibits\Dmi\EUO0098.tif'
		union Select 'exhibits\Dmi\EUO0099.tif'
		union Select 'exhibits\Dmi\EUO0100.tif'
		union Select 'exhibits\Dmi\EUO0101.tif'
		union Select 'exhibits\Dmi\EUO0102.tif'
		union Select 'exhibits\Dmi\EUO0103.tif'
		union Select 'exhibits\Dmi\EUO0104.tif'
		union Select 'exhibits\Dmi\EUO0105.tif'
		union Select 'exhibits\Dmi\EUO0106.tif'
		union Select 'exhibits\Dmi\EUO0107.tif'
		union Select 'exhibits\Dmi\EUO0108.tif'
		union Select 'exhibits\Dmi\EUO0109.tif'
		union Select 'exhibits\Dmi\EUO0110.tif'
		union Select 'exhibits\Dmi\EUO0111.tif'
		union Select 'exhibits\Dmi\EUO0112.tif'
		union Select 'exhibits\Dmi\EUO0113.tif'
		union Select 'exhibits\Dmi\EUO0114.tif'
		union Select 'exhibits\Dmi\EUO0115.tif'
		union Select 'exhibits\Dmi\EUO0116.tif'
		union Select 'exhibits\Dmi\EUO0117.tif'
		union Select 'exhibits\Dmi\EUO0118.tif'
		union Select 'exhibits\Dmi\EUO0119.tif'
		union Select 'exhibits\Dmi\DMI-VER1.tif'
		union Select 'exhibits\Dmi\DMI-VER2.tif'
        union Select 'exhibits\Dmi\DMI-VER3.tif'
		union Select 'exhibits\Dmi\DMI-VER4.tif'
		union Select 'exhibits\Dmi\DMI-VER5.tif'
		union Select 'exhibits\Dmi\DMI-VER6.tif'
		union Select 'exhibits\Dmi\DMI-VER7.tif'
		union Select 'exhibits\Dmi\DMI-VER8.tif'
		union Select 'exhibits\Dmi\DMI-VER9.tif'
		
	select  * from #temp  
	drop table #temp  
END

