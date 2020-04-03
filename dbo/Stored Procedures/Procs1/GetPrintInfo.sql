
--Exec GetPrintInfo 'localhost','','','Date_AAA_Arb_Filed-tblcase','',''
CREATE PROCEDURE [dbo].[GetPrintInfo]
(
	@domainId nvarchar(50),
	@dt1 varchar(50),  
	@dt2 varchar(50),  
	@printtype varchar(100),  
	@status varchar(50),
	@opened_by varchar(100)
)  
AS  
BEGIN  
  
	
	DECLARE @printtype_ColumnName varchar(100),@printtype_TableName varchar(50)

	Select @printtype_ColumnName=Substring(@printtype, 1,Charindex('-', @printtype)-1),
	@printtype_TableName=Substring(@printtype, Charindex('-', @printtype)+1, LEN(@printtype))

	--select @printtype_ColumnName,@printtype_TableName

	DECLARE @sQuery nvarchar(max) 

	set @sQuery='SELECT tblcase.case_id
	 , tblcase.CASE_CODE
	 , ISNULL(tblcase.InjuredParty_FirstName, N'''') + '' ''+ISNULL(tblcase.InjuredParty_LastName, N'''')AS InjuredParty_Name
	 , prov.provider_name
	 , insComp.insurancecompany_name
	 , tblcase.claim_amount
	 , tblcase.paid_amount
	 , convert(varchar(100),tblcase.Fee_Schedule)as Fee_Schedule
	 , tblcase.date_opened
	 , tblcase.date_summons_printed
	 , tblcase.served_on_date
	 , tblcase.indexoraaa_number
	 , tblcase.status
	 , tblcase.initial_status
	 , court.court_name
	 , tblcase.opened_by,
	  convert(decimal(38,2),(convert(money,convert(float,(tblcase.Fee_Schedule)) - convert(float,(tblcase.Paid_Amount))))) as FS_Balance,
	  convert(decimal(38,2),(convert(money,convert(float,(tblcase.Claim_Amount)) - convert(float,(tblcase.Paid_Amount))))) as Claim_Balance,'
	  +@printtype_TableName+'.'+@printtype_ColumnName+' As SelectedDate  
	  from tblcase WITH (NOLOCK)
	  INNER JOIN dbo.tblProvider prov WITH (NOLOCK) ON tblcase.Provider_Id = prov.Provider_Id  
	  INNER JOIN  dbo.tblInsuranceCompany insComp WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = insComp.InsuranceCompany_Id 
	  LEFT OUTER JOIN  dbo.tblCourt court WITH (NOLOCK) ON tblcase.Court_Id = court.Court_Id 
	  LEFT OUTER JOIN dbo.tblCase_Date_Details WITH (NOLOCK) ON (tblcase.Case_Id=tblCase_Date_Details.Case_Id and tblcase.DomainId=tblCase_Date_Details.DomainId)
	  where 
      tblcase.DomainId='''+@domainId+''''
	  
	  SET @sQuery= @sQuery+' AND CAST(FLOOR(CAST('+@printtype_TableName+'.'+@printtype_ColumnName+'  AS FLOAT))AS DATETIME) >= Replace('''+ @dt1+''',''/'',''-'')
								AND CAST(FLOOR(CAST('+@printtype_TableName+'.'+@printtype_ColumnName+' AS FLOAT))AS DATETIME) <= Replace( '''+@dt2+''',''/'',''-'')'
	  SET @sQuery=@sQuery+' AND ('''+@status+''' = '''' OR  tblcase.status ='''+ @status+''' )
							 AND ('''+@opened_by+''' = ''''  OR tblcase.opened_by = '''+@opened_by+''' )
							 order by court.court_name,tblcase.case_id'

	 --PRINT @sQuery
	 execute sp_executesql @sQuery  
	  
end


