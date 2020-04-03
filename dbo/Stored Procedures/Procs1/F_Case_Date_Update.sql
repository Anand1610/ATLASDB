--[F_Case_Date_Update] 'FH07-42372','2014-12-12 00:00:00.000','Date_of_AAA_Awards','AAA Awards','tech'
CREATE PROCEDURE [dbo].[F_Case_Date_Update](
@DomainId nvarchar(50),        
@Case_Id NVARCHAR(200),        
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

	IF EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'tblcase' AND COLUMN_NAME = '' + @fieldName+ '')  
    BEGIN
		
		DECLARE @columnVal TABLE (columnVal nvarchar(255)); 
		DECLARE @SQL nvarchar(max) = 'SELECT ISNULL(Convert(nvarchar,' + @fieldName + ',101),'''')   FROM tblcase WHERE Case_Id=''' + @Case_Id +''' and DomainId='''+@DomainId+''''
		
		INSERT @columnVal EXEC sp_executesql @sql

		SET @oldValue = ISNULL((SELECT columnVal FROM @columnVal),'')
		
		PRINT @oldValue
		SET @SQL = 'UPDATE tblcase SET ' + @fieldName +' = '''+ @newValue+''' WHERE Case_Id = ''' + @Case_Id +''' and DomainId='''+@DomainId+''''
		print @SQL
		exec(@SQL)
		
		--SET @newValue = (SELECT CONVERT(varchar(10),@newValue,101))

		If @fieldName = 'DATE_90_DAY_NOTICE_RECEIVED' or @fieldtextname='DATE_90_DAY_NOTICE_RECEIVED'
		BEGIN
			SET @newDesc = 'Date 90 DAY NOTICE ISSUED changed from ' + @oldValue + ' to ' + @newValue  
		END
		ELSE
		BEGIN
		SET @newDesc = @fieldName + ' Date changed from ' + @oldValue + ' to ' + @newValue  
		END
		EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
    END
	ELSE IF EXISTS (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'tblCase_Date_Details' AND COLUMN_NAME = '' + @fieldName+ '')  
    BEGIN
		IF NOT EXISTS(SELECT Case_ID from tblCase_Date_Details WHERE Case_Id = @Case_Id and DomainId = @DomainId)
		BEGIN
			INSERT INTO tblCase_Date_Details(DomainId,Case_Id )
			VALUES(@DomainId, @Case_Id)
		END
		
		DECLARE @columnVal_2 TABLE (columnVal nvarchar(255)); 
		DECLARE @SQL_2 nvarchar(max) = 'SELECT ISNULL(Convert(nvarchar,' + @fieldName + ',101),'''')   FROM tblCase_Date_Details WHERE Case_Id=''' + @Case_Id +''' and DomainId='''+@DomainId+''''
		
		INSERT @columnVal_2 EXEC sp_executesql @sql

		SET @oldValue = ISNULL((SELECT columnVal FROM @columnVal_2),'')
		
		PRINT @oldValue
		SET @SQL_2 = 'UPDATE tblCase_Date_Details SET ' + @fieldName +' = '''+ @newValue+''' WHERE Case_Id = ''' + @Case_Id +''' and DomainId='''+@DomainId+''''
		print @SQL_2
		exec(@SQL_2)
		
		--SET @newValue = (SELECT CONVERT(varchar(10),@newValue,101))

		
		SET @newDesc = @fieldName + ' Date changed from ' + @oldValue + ' to ' + @newValue  
		
		EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
    END
  
	 
	  --  IF(@fieldName='Date_AAA_Arb_Filed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_AAA_Arb_Filed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET Date_AAA_Arb_Filed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_of_AAA_Awards')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_of_AAA_Awards,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET Date_of_AAA_Awards=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_AAA_Concilation_Over')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_AAA_Concilation_Over,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET Date_AAA_Concilation_Over=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	   
	  --   IF(@fieldName='AAA_Confirmed_Date')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,AAA_Confirmed_Date,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET AAA_Confirmed_Date=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	     
	  --   IF(@fieldName='DateAAA_packagePrinting')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,DateAAA_packagePrinting,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET DateAAA_packagePrinting=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	    
	  --  IF(@fieldName='DateAAA_ResponceRecieved')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,DateAAA_ResponceRecieved,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET DateAAA_ResponceRecieved=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Date_Afidavit_Filed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Afidavit_Filed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase  
			--	SET Date_Afidavit_Filed=@newValue WHERE Case_Id=@Case_Id  and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Date_Answer_Received')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Answer_Received,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Answer_Received=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --  IF(@fieldName='Date_Bill_Submitted')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Bill_Submitted,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Bill_Submitted=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Defendant_Discovery_Due_Date')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Defendant_Discovery_Due_Date,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Defendant_Discovery_Due_Date=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Date_Demands_Printed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Demands_Printed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Demands_Printed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Disc_Conf_Letter_Printed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Disc_Conf_Letter_Printed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Disc_Conf_Letter_Printed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --  IF(@fieldName='Date_Ext_Of_Time')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Ext_Of_Time,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Ext_Of_Time=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Ext_Of_Time_2')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Ext_Of_Time_2,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Ext_Of_Time_2=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Date_Ext_Of_Time_3')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Ext_Of_Time_3,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Ext_Of_Time_3=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Index_Number_Purchased')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Index_Number_Purchased,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Index_Number_Purchased=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_NAM_ARB_Filed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_NAM_ARB_Filed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_NAM_ARB_Filed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --  IF(@fieldName='Date_of_NAM_Awards')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_of_NAM_Awards,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_of_NAM_Awards=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --  IF(@fieldName='Date_NAM_Confirmed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_NAM_Confirmed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_NAM_Confirmed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Date_NAM_Package_Printed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_NAM_Package_Printed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_NAM_Package_Printed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_NAM_Response_Received')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_NAM_Response_Received,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_NAM_Response_Received=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='DateNotice_TrialFiled')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,DateNotice_TrialFiled,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET DateNotice_TrialFiled=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --  IF(@fieldName='Date_Open_Verification_Response_Sent1')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Open_Verification_Response_Sent1,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Open_Verification_Response_Sent1=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --     IF(@fieldName='Date_Open_Verification_Response_Sent2')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Open_Verification_Response_Sent2,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Open_Verification_Response_Sent2=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Plaintiff_Discovery_Due_Date')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Plaintiff_Discovery_Due_Date,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Plaintiff_Discovery_Due_Date=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Reply_To_Disc_Conf_Letter_Recd')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Reply_To_Disc_Conf_Letter_Recd,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Reply_To_Disc_Conf_Letter_Recd=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Summons_Printed')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Summons_Printed,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Summons_Printed=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --   IF(@fieldName='Date_Summons_Sent_Court')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Date_Summons_Sent_Court,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Date_Summons_Sent_Court=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	  --    IF(@fieldName='Served_On_Date')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,Served_On_Date,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET Served_On_Date=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
	    
	  --  IF(@fieldName='DateFile_Trial_DeNovo')  
	  --  BEGIN
			--SET @oldValue=isnull((SELECT Convert(nvarchar,DateFile_Trial_DeNovo,101) FROM tblcase  WHERE Case_Id=@Case_Id and DomainId=@DomainId),'')
			--	UPDATE tblcase 
			--	SET DateFile_Trial_DeNovo=@newValue WHERE Case_Id=@Case_Id and DomainId=@DomainId
				
			--	SET @newDesc = @fieldtextname+ ' Date changed from ' + @oldValue + ' to ' + @newValue  
			--	EXEC LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id=@user_id,@ApplyToGroup = 0
	  --  END
	    
END

