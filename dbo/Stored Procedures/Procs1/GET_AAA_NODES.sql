CREATE PROCEDURE [dbo].[GET_AAA_NODES] --'AAA Correspondence','03/20/2015','03/25/2015'
	@NodeName varchar(500),
	@dt_From nvarchar(50),
	@dt_To nvarchar(50)
AS
BEGIN
	DECLARE @strsql VARCHAR(MAX)
	SET @strsql  = 'select CaseID,InjuredParty_FirstName + '' '' + InjuredParty_LastName [PatientName],
	usr.UserName,FileName,FilePath,convert(varchar,DateInserted,101)DateInserted
	from tbltags tag inner join tblimagetag imgtag
	on tag.nodeid=imgtag.tagid
	inner join tbldocimages doc on doc.imageid=imgtag.imageid
	inner join dbo.issuetracker_users usr on
	usr.userid=RTRIM(imgtag.loginid)
	inner join dbo.tblcase c on
	c.Case_Id=tag.CaseID
	where imgtag.IsDeleted=0 AND doc.IsDeleted=0 AND nodename =''' + @NodeName + ''''
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	--imgtag.IsDeleted=0 AND doc.IsDeleted=0 AND added
	---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	
	if @dt_From <>'1/1/0001' and @dt_To<>'1/1/0001' and @dt_From<>'' and @dt_To<>''
	begin  
		set @strsql = @strsql + '  and DateInserted Between ''' + @dt_From + ''' and ''' + @dt_To + ''' '
	end 
	set @strsql = @strsql + ' order by convert(datetime,DateInserted) desc,CaseID asc'
	print(@strsql)
	EXEC(@strsql)

/*
Resolution Center Notification   - AAA CLOSING LETTER & AAA Correspondence
Arbitrator Award                 - Arbitration Awards & MISC
Notice of Hearing                - Notice of Hearing
Received settlement offer        - NOTICE OF CONCILIATION-SETTLEMENT
Notice of Settlement             - NOTICE OF CONCILIATION-SETTLEMENT
Initiation Letter                - CONFIRMATION RECEIPT
Case Escalate to Arbitration     - NOTICE OF CONCILIATION-UNRESOLVED
*/
END

