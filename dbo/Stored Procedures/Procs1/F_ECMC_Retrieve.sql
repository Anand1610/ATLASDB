CREATE PROCEDURE [dbo].[F_ECMC_Retrieve]--[dbo].[F_ECMC_Retrieve] 'FH13-160356','24343','21ST CENTURY ASSURANCE COMPANY','4354','','-1','ERIC'
	(								
		@s_a_FHKP_case_id NVARCHAR(50),
		@s_a_patient_name NVARCHAR(50),
		@s_a_insurance NVARCHAR(255),
		@s_a_billid  NVARCHAR(50),
		@s_a_account  NVARCHAR(50),
		@s_a_UCR  NVARCHAR(50),
		@dt_a_dt_of_accident DATETIME,
		@i_a_denialreasonid int,
		@s_a_sendby VARCHAR(50)
	)
	AS
	BEGIN
	DECLARE @desc varchar(200),
			@s_l_message NVARCHAR(500),
			@strsql varchar(MAX),
			@denialreason_type VARCHAR(8000)
		
		set @strsql='SELECT distinct ecmc.[Patient Name],ecmc.FHKP_Case_Id,ecmc.Insurance,
		
	STUFF(
    (SELECT distinct '','' + DenialReason FROM MST_DenialReasons
     INNER JOIN tbl_Case_Denial on tbl_Case_Denial.FK_Denial_ID = MST_DenialReasons.PK_Denial_ID WHERE Case_Id=FHKP_Case_Id
     FOR XML PATH('''')),1,1,'''') AS DenialReason,
     
 
		
		(select(select COALESCE(CAST(fk_denial_Id AS VARCHAR(MAX))+'','','''')   
		from tbl_Case_Denial inner join MST_DenialReasons on MST_DenialReasons.PK_Denial_ID=tbl_Case_Denial.FK_Denial_ID 
		where Case_Id=ecmc.FHKP_Case_Id for xml path(''''))) DenialReasonId,
		
		ecmc.Send_BY,ecmc.Bill_No,ecmc.Account,ecmc.UCR,convert(varchar,ecmc.Date_of_Accident,101) as Date_of_Accident FROM  dbo.ECMC ecmc
	    LEFT OUTER  JOIN tbl_Case_Denial denial ON ecmc.FHKP_Case_Id=denial.Case_Id
		LEFT OUTER  JOIN MST_DenialReasons mst ON mst.PK_Denial_ID=denial.FK_Denial_ID	 WHERE 1=1'
		 
		if @s_a_FHKP_case_id <> ''  
		begin  
			set @strsql = @strsql + ' AND ecmc.FHKP_Case_Id Like ''%' + @s_a_FHKP_case_id + '%'''               
		end  
		
		 if @s_a_patient_name <> ''  
		begin  
			set @strsql = @strsql + ' AND ecmc.[Patient Name] Like ''%' + @s_a_patient_name + '%'''               
		end  
				
		 if @s_a_insurance <> '' and @s_a_insurance <> ' ---SELECT Insurance Company--- '
		begin  
			set @strsql = @strsql + ' AND ecmc.Insurance Like ''%' + @s_a_insurance + '%'''               
		end  
		
		 if @i_a_denialreasonid <> '' and @i_a_denialreasonid <> -1
		begin  
			set @strsql = @strsql + ' AND denial.FK_Denial_ID = ' + @i_a_denialreasonid + ''              
		end  
		if @s_a_sendby <> '' and @s_a_sendby <> '---SELECT---'
		begin  
			set @strsql = @strsql + ' AND ecmc.Send_BY = ''' + @s_a_sendby + ''' '             
		end 
		if @dt_a_dt_of_accident <> '' 
		begin  
			set @strsql = @strsql + ' AND ecmc.Date_of_Accident = ''' + @dt_a_dt_of_accident + ''' '             
		end 
		if @s_a_account <> '' 
		begin  
			set @strsql = @strsql + ' AND ecmc.Account = ''' + @s_a_account + ''' '             
		end 
			if @s_a_UCR <> '' 
		begin  
			set @strsql = @strsql + ' AND ecmc.UCR = ''' + @s_a_UCR + ''' '             
		end 
		
		 print (@strsql)
		 exec (@strsql)
		 
	END

