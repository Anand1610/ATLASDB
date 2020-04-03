CREATE PROCEDURE [dbo].[GETCAL]  --EXEC GETCAL @DT1='11/10/2014',@DT2='11/24/2014',@PROVIDER_ID='ALL',@INSURANCECOMPANY_ID='ALL',@DEFENDANT_ID='ALL',@COURT_ID='ALL',@ctype='ALL' 
(  
@dt1 varchar(50),  
@dt2 varchar(50),  
@provider_id nvarchar(1000),  
@insurancecompany_id nvarchar(1000),  
@defendant_id nvarchar(1000),  
@court_id nvarchar(500),  
@ctype varchar(100)  
)  
as  
begin  
DECLARE   
@ST NVARCHAR(3000),  
@PID NVARCHAR(1000),  
@IID NVARCHAR(1000),  
@DID NVARCHAR(1000),  
@CID NVARCHAR(1000)  
  
SET @ST = '
select distinct V.case_id,
		InjuredParty_Name, 
		Provider_Name, 
		InsuranceCompany_Name,
		V.status,
		Defendant_Name,
		DATEOFSERVICE_START,FEE_SCHEDULE,
		IndexOrAAA_Number,
		Court_Name,
		EVTTYPE.EVENTTYPENAME as [EVENT_TYPE],
		EVTSTATUS.EVENTSTATUSNAME as EVENT_STATUS, 
		EVT.EVENT_DATE as EVENT_DATE, 
		ISNULL(CONVERT(NVARCHAR(5),EVT.EVENT_TIME,114),'''') as EVENT_TIME,
		ISNULL(EVT.EVENT_NOTES,'''') [EVENT_DESCRIPTION],
		EVT.ASSIGNED_TO as ASSIGNED_TO    
		from dbo.LCJ_VW_CaseSearchDetails V
		LEFT OUTER JOIN tblevent EVT on V.Case_Id = EVT.Case_Id
		LEFT OUTER JOIN TBLEVENTTYPE EVTTYPE ON EVTTYPE.EVENTTYPEID = EVT.EVENTTYPEID 
		LEFT OUTER JOIN TBLEVENTSTATUS EVTSTATUS ON EVTSTATUS.EVENTSTATUSID = EVT.EVENTSTATUSID 
		where (1=1)
		'

		if @ctype <> 'ALL'  
		SET @ST = @ST + ' AND '+ @CTYPE + '  BETWEEN ''' + @DT1 + ''' AND ''' + @DT2 + ''''  
		else  
		SET @ST = @ST + ' AND CONVERT(VARCHAR(10),EVT.Event_Date,101)  BETWEEN ''' + @DT1 + ''' AND ''' + @DT2 + ''''  
  
		IF @PROVIDER_ID <> '' AND @PROVIDER_ID <> 'ALL'  
		BEGIN  
			SET @PID = REPLACE(@PROVIDER_ID,' ','')   
			SET @ST = @ST + ' AND PROVIDER_ID IN (''' + REPLACE(@PID,',',''',''')   + ''')'  
		END  
  
		IF @INSURANCECOMPANY_ID <> '' AND @INSURANCECOMPANY_ID <> 'ALL'  
		BEGIN  
		SET @IID = REPLACE(@INSURANCECOMPANY_ID,' ','')   
		SET @ST = @ST + ' AND INSURANCECOMPANY_ID IN (''' + REPLACE(@IID,',',''',''')   + ''')'  
		END  
  
		IF @DEFENDANT_ID <> '' AND @DEFENDANT_ID <> 'ALL'  
		BEGIN  
		SET @DID = REPLACE(@DEFENDANT_ID,' ','')   
		SET @ST = @ST + ' AND DEFENDANT_ID IN (''' + REPLACE(@DID,',',''',''')   + ''')'  
		END  
  
		IF @COURT_ID <> '' AND @COURT_ID <> 'ALL'  
		BEGIN  
		SET @CID = REPLACE(@COURT_ID,' ','')   
		SET @ST = @ST + ' AND COURT_ID IN (''' + REPLACE(@CID,',',''',''')   + ''')'  
		END  
  
		SET @ST = @ST + ' ORDER BY EVT.EVENT_DATE asc'  
  
--PRINT @ST   
  
EXECUTE SP_EXECUTESQL @ST  
end

