
CREATE PROCEDURE [dbo].[Update_Cases_Current_Status_New]
@DomainId NVARCHAR(50),
@status varchar(100)='',
@case_status varchar(100)='',
@Cases CaseSearch readonly,
@User_Id varchar(50),
@Desc nvarchar(2000)='',
@NoteType varchar(100)='',
@CourtId varchar(100)='',
@DefendantID varchar(100)='',
@ProviderID int=0,
@IndexOrAAAno varchar(100)='',
@InsuranceCompany_Id varchar(100)='',
@Portfolio_Id varchar(20)=''
AS
BEGIN
Declare @update varchar(max)
Declare @InsertNotes varchar(max)

declare @intFlag int =0
set @update='update t1 set '
 set @InsertNotes =' Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)  '
SELECT * INTO #TEMP  FROM @Cases

		if(@CourtId <>'')
	begin
	

	set @update +=' Court_Id ='''+ @CourtId+''' '
		set @intFlag=1

		declare @Court_Name varchar(500)
		set @Court_Name=( SELECT Upper(ISNULL( tblcourt.Court_Name, '')) from tblcourt where DomainId=@DomainId and Court_Id=@CourtId)
	

		set @InsertNotes+=' 
		 SELECT '' Court changed from ''+ ISNULL(t3.Court_Name,'''') +'' to  '' +  ISNULL('''+@Court_Name+''','''') 
		 ,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
		 from  tblcase t1 
		 JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
		  join  tblcourt t3  on t3.Court_Id=t1.Court_Id
		 where t1.Court_Id<>'''+@CourtId+''' 		 		  
		 union  all
		 SELECT '' Court changed from  to  '' +  ISNULL('''+@Court_Name+''','''') 
		 ,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
		 from  tblcase t1 
		 JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 		 
		 where isnull(t1.Court_Id,'''') = '''' '
		  
	end

	if(@DefendantID <>'')
	begin
	  declare @Defendant_Name varchar(100)
		 if(@intFlag=1)
		 begin
			set @update +=' ,Defendant_ID ='''+ @DefendantID+''' '
			set @intFlag=1
		 		
			set @Defendant_Name=( SELECT Upper(ISNULL( tblDefendant.Defendant_Name, '')) from tblDefendant where DomainId=@DomainId and Defendant_id=@DefendantID)
		

			set @InsertNotes+=' 
			union 
			SELECT '' Defendant changed from ''+ ISNULL(t3.Defendant_Name,'''')  +'' to  '' +  ISNULL('''+@Defendant_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tblDefendant t3  on t3.Defendant_id=t1.Defendant_id
			where t1.Defendant_id<>'''+@DefendantID+'''
			union 
			SELECT '' Defendant changed  to  '' +  ISNULL('''+@Defendant_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			where isnull(t1.Defendant_id,'''')='''' '

		 end
		 else
		 begin
				set @intFlag=1
				set @update +=' Defendant_ID ='''+ @DefendantID+''' '

				set @Defendant_Name=( SELECT Upper(ISNULL( tblDefendant.Defendant_Name, '')) from tblDefendant where DomainId=@DomainId and Defendant_id=@DefendantID)
		

				set @InsertNotes+=' 
				 
				SELECT '' Defendant changed from ''+ ISNULL(t3.Defendant_Name,'''') +'' to  '' +  ISNULL('''+@Defendant_Name+''','''') 
				,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
				from  tblcase t1 
				JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
				left join  tblDefendant t3  on t3.Defendant_id=t1.Defendant_id
				where t1.Defendant_id<>'''+@DefendantID+''' 
				union 
				SELECT '' Defendant changed  to  '' +  ISNULL('''+@Defendant_Name+''','''') 
				,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
				from  tblcase t1 
				JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
				where isnull(t1.Defendant_id,'''')='''' '
		 end
		
	enD
	
	if(@ProviderID<>0)
	begin
	declare @Provider_Name varchar(200)
	set @Provider_Name=( SELECT Upper(ISNULL( tblProvider.Provider_Name, '')) from tblProvider where DomainId=@DomainId and Provider_Id=@ProviderID)

		if(@intFlag=1)
		begin
			set @update +=' ,Provider_Id ='''+ convert(varchar(20),@ProviderID)+''' '
			
		

			set @InsertNotes+=' 
			union 
			SELECT '' Provider changed from ''+ ISNULL(t3.Provider_Name,'''') +'' to  '' +  ISNULL('''+@Provider_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tblProvider t3  on t3.Provider_Id=t1.Provider_Id
			where t1.Provider_Id<>'''+convert(varchar(20),@ProviderID)+''' 
			union 
			SELECT '' Provider changed  to  '' +  ISNULL('''+@Provider_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where isnull(t1.Provider_Id,'''')='''' '
		end
		else
		begin
			set @intFlag=1
			set @update +=' Provider_Id ='''+ convert(varchar(20), @ProviderID)+''' '
			set @InsertNotes+=' 
			 
			SELECT '' Provider changed from ''+ ISNULL(t3.Provider_Name,'''') +'' to  '' +  ISNULL('''+@Provider_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tblProvider t3  on t3.Provider_Id=t1.Provider_Id
			where t1.Provider_Id<>'''+convert(varchar(20),@ProviderID)+''' 
			union 
			SELECT '' Provider changed  to  '' +  ISNULL('''+@Provider_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where isnull(t1.Provider_Id,'''')='''' '

		end
	end

	if(@InsuranceCompany_Id<>0)
	begin
		declare @InsuranceCompany_Name varchar(250)
	set @InsuranceCompany_Name=( SELECT Upper(ISNULL( tblInsuranceCompany.InsuranceCompany_Name, '')) from tblInsuranceCompany where DomainId=@DomainId and InsuranceCompany_Id=@InsuranceCompany_Id)
	
		if(@intFlag=1)
		begin
			set @update +=' ,InsuranceCompany_Id ='''+ @InsuranceCompany_Id+''' '

			set @InsertNotes+=' 
			union 
			SELECT '' Insurance changed from ''+ ISNULL(t3.InsuranceCompany_Name,'''')  +''to  '' +  ISNULL('''+@InsuranceCompany_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tblInsuranceCompany t3  on t3.InsuranceCompany_Id=t1.InsuranceCompany_Id
			where t1.InsuranceCompany_Id<>'''+@InsuranceCompany_Id+'''
			union
			SELECT '' Insurance changed to  '' +  ISNULL('''+@InsuranceCompany_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where isnull(t1.InsuranceCompany_Id,'''')=''''  '
		end
		else
		begin
			set @intFlag=1
			set @update +=' InsuranceCompany_Id ='''+ @InsuranceCompany_Id+''' '

				set @InsertNotes+=' 
			 
			SELECT '' Insurance changed from ''+ ISNULL(t3.InsuranceCompany_Name,'''') +'' to  '' +  ISNULL('''+@InsuranceCompany_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tblInsuranceCompany t3  on t3.InsuranceCompany_Id=t1.InsuranceCompany_Id
			where t1.InsuranceCompany_Id<>'''+@InsuranceCompany_Id+'''
			union
			SELECT '' Insurance changed to  '' +  ISNULL('''+@InsuranceCompany_Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where isnull(t1.InsuranceCompany_Id,'''')='''' '
		end
	end
	if(@Portfolio_Id<>0)
	begin
		declare @Name varchar(50)
	set @Name=( SELECT Upper(ISNULL( tbl_Portfolio.Name, '')) from tbl_Portfolio where DomainId=@DomainId and Id=@Portfolio_Id)
		if(@intFlag=1)
		begin
			set @update +=' ,PortfolioId ='''+ @Portfolio_Id+''' '

			set @InsertNotes+=' 
			union 
			SELECT '' Portfolio changed from ''+ ISNULL(t3.Name,'''')  +''to  '' +  ISNULL('''+@Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tbl_Portfolio t3  on t3.Id=t1.PortfolioId
			where t1.PortfolioId<>'''+@Portfolio_Id+'''
			union 
			SELECT '' Portfolio changed to  '' +  ISNULL('''+@Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 			
			where isnull(t1.PortfolioId,'''')='''' '
			 
		end
		else
		begin
			set @intFlag=1
			set @update +=' PortfolioId ='''+ @Portfolio_Id+''' '

			set @InsertNotes+=' 
			 
			SELECT '' Portfolio changed from ''+ ISNULL(t3.Name,'''')  +''to  '' +  ISNULL('''+@Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			left join  tbl_Portfolio t3  on t3.Id=t1.PortfolioId
			where t1.PortfolioId <>'''+@Portfolio_Id+'''
			union 
			SELECT '' Portfolio changed to  '' +  ISNULL('''+@Name+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 			
			where isnull(t1.PortfolioId,'''')='''' '
		end
	end

	if(@IndexOrAAAno<>0)
	begin

	
		if(@intFlag=1)
		begin
			set @update +=' ,IndexOrAAA_Number ='''+ @IndexOrAAAno+''' '
			set @InsertNotes+=' 
			union 
			SELECT '' IndexOrAAA Numbe changed from ''+ ISNULL(t1.IndexOrAAA_Number,'''')  +''to  '' +  ISNULL('''+@IndexOrAAAno+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where t1.IndexOrAAA_Number<>'''+@IndexOrAAAno+''' '
		end
		else
		begin
			set @intFlag=1
			set @update +=' IndexOrAAA_Number ='''+ @IndexOrAAAno+''' '
			set @InsertNotes+=' 
			 
			SELECT '' IndexOrAAA Numbe changed from ''+ ISNULL(t1.IndexOrAAA_Number,'''')  +''to  '' +  ISNULL('''+@IndexOrAAAno+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where t1.IndexOrAAA_Number<>'''+@IndexOrAAAno+''' '
		end
	end

	if(@case_status<>'')
	begin
		if(@intFlag=1)
		begin
			set @update +=' ,Initial_Status ='''+ @case_status+''' '

			set @InsertNotes+=' 
			union 
			SELECT '' Initial Status  changed from ''+ ISNULL(t1.Initial_Status,'''')  +''to  '' +  ISNULL('''+@case_status+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where t1.Initial_Status<>'''+@case_status+''' '
		end
		else
		begin
			set @intFlag=1
			set @update +=' Initial_Status ='''+ @case_status+''' '
				set @InsertNotes+=' 
			 
			SELECT '' Initial Status  changed from ''+ ISNULL(t1.Initial_Status,'''')  +''to  '' +  ISNULL('''+@case_status+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			
			where t1.Initial_Status<>'''+@case_status+''' '
		end
	end

	 if(@status<>'')
	begin
	 declare @satushierachy int
	 set @satushierachy=(select isnull(Status_Hierarchy,0) from tblStatus where DomainId=@DomainId and Status_Type =@status)
	 
	-- print 'in'
	
	

	if(@intFlag=1)
		begin

			set @update +=' , STATUS=case when isnull(t2.Status_Hierarchy,0)  <='+CONVERT(varchar(20),@satushierachy) +' then '''+ @status+''' else t1.STATUS end '
			set @InsertNotes+=' 
			union 
			SELECT ''  Status  changed from ''+ ISNULL(t1.Status,'''')  +'' to '' + ISNULL('''+@status+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type=t1.status 
			
			where t1.Status<>'''+@status+''' and t3.Status_Hierarchy  <='+CONVERT(varchar(20),@satushierachy) +''
		end
		else
		begin
		
			--print @InsertNotes
			set @InsertNotes+=' 
			 
			SELECT ''  Status  changed from ''+ ISNULL(t1.Status,'''')  +''to '' + ISNULL('''+@status+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId 
			join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type=t1.status 			
			where t1.Status<>'''+@status+''' and t3.Status_Hierarchy  <='+CONVERT(varchar(20),@satushierachy) 

			--print @InsertNotes
			set @intFlag=1
			set @update +=' STATUS=case when t2.Status_Hierarchy <= '+CONVERT(varchar(20),@satushierachy) +' then '''+ @status+''' else t1.STATUS end  '
		end
	end
	set @update+=' from tblcase t1 join #TEMP t3 on t3.CaseId=t1.case_id '
	 if(@status<>'')
	begin
	set @update+=' join tblStatus t2 on t1.DomainId=t2.DomainId and t2.Status_Type=t1.status '
	end
	set @update+=' where t1.DomainId='''+@DomainId+''' '
	
	print @InsertNotes
	print  @update
	

	if(@intFlag=1)
	begin
		if(@status<>'')
		begin
		print 1
			update  t1
			set t1.status=@status
			from tblcase t1
			join #TEMP t3 on t3.CaseId=t1.case_id
			where isnull(t1.status,'')='' 
			and t1.DomainId=@DomainId
		end
		exec(@InsertNotes)	
		Exec(@update)

		
	end
	
	if(@Desc<>'')
    begin
		insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
		select @Desc,@NoteType,1,CaseId,getdate(),@User_Id,@DomainId
		from #TEMP
	end

END