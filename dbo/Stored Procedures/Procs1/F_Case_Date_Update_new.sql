CREATE PROCEDURE [dbo].[F_Case_Date_Update_new](
@DomainId nvarchar(50),        
@Cases CaseSearch readonly,        
@newValue NVARCHAR(200), 
@fieldName NVARCHAR(200), 
@fieldtextname NVARCHAR(200),    
@user_id NVARCHAR(50)      
)        
AS        
BEGIN   
	DECLARE        
	@newDesc NVARCHAR(200),
	@oldValue NVARCHAR(200),
	@strQuery NVARCHAR(MAX)
	Declare @update varchar(max)
	Declare @InsertNotes varchar(max)
	set @update='update t1 set '

	set @InsertNotes =' Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)  '
	SELECT * INTO #TEMP  FROM @Cases

	IF EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'tblcase' AND COLUMN_NAME = '' + @fieldName+ '')  
	BEGIN
		If @fieldName = 'DATE_90_DAY_NOTICE_RECEIVED' or @fieldtextname='DATE_90_DAY_NOTICE_RECEIVED'
		BEGIN
			set @InsertNotes+=' 
			SELECT  ''Date 90 DAY NOTICE ISSUED  changed from ''+ ISNULL(t1.'+@fieldName+','''') +'' to  '' +  ISNULL('''+@newValue+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId '

			
									
		end
		else
		begin
			set @InsertNotes+=' 
			SELECT '''+@fieldName+'''+ '' Date changed from ''+ ISNULL(convert(varchar(20),t1.'+@fieldName+',101),'''') +'' to  '' +  ISNULL('''+@newValue+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblcase t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId '
									
		END
		set @update +='t1.'+@fieldName+'= '''+ @newValue+''' '
		set @update+=' from tblcase t1 join #TEMP t3 on t3.CaseId=t1.case_id '
		set @update+=' where t1.DomainId='''+@DomainId+''' '
		print @InsertNotes
		print @update
		exec(@InsertNotes)	
		Exec(@update)
	END
	ELSE IF EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'tblCase_Date_Details' AND COLUMN_NAME = '' + @fieldName+ '')  
    BEGIN
		 SELECT * into #tempNew from  #TEMP where CaseId  not in(select distinct Case_Id from tblCase_Date_Details where DomainId=@DomainId)

		 INSERT INTO tblCase_Date_Details(DomainId,Case_Id )
		 select	 @DomainId,CaseId 
		 from	#tempNew

		 set @InsertNotes+=' 
			SELECT '''+@fieldName+'''+ '' Date changed from ''+ ISNULL(convert(varchar(20),t1.'+@fieldName+',101),'''') +'' to  '' +  ISNULL('''+@newValue+''','''') 
			,''Activity'',1,t1.Case_Id,getdate(),'''+@User_Id+''','''+ @DomainId+'''
			from  tblCase_Date_Details t1 
			JOIN #TEMP t2  On t1.Case_Id = t2.CaseId '

			set @update +='t1.'+@fieldName+'= '''+ @newValue+''' '
			set @update+=' from tblCase_Date_Details t1 join #TEMP t3 on t3.CaseId=t1.case_id '
			set @update+=' where t1.DomainId='''+@DomainId+''' '

			exec(@InsertNotes)	
			Exec(@update)
	end
	drop table #TEMP  
END