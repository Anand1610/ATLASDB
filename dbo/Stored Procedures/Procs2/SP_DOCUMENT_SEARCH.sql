CREATE PROCEDURE [dbo].[SP_DOCUMENT_SEARCH]
		@DomainId as NVARCHAR(50),
		@SZ_CASE_ID as NVARCHAR(50) = NULL,
		@SZ_PROCESS_ID as NVARCHAR(50) = NULL,
		@SZ_CAPTION as NVARCHAR(50) = NULL,
		@SZ_NOTES as NVARCHAR(255) = NULL,
		@SZ_USER_ID NVARCHAR(20)
	AS
	BEGIN
		Declare @szPath As varchar(100)
		set @szPath = ( select ParameterValue from tblApplicationSettings  
					where ParameterName='MapUploadFileLocation' and DomainId=@DomainId)
		Declare @szHyperLink As varchar(100)
		IF EXISTS (select * from IssueTracker_Users  where usertype = 'OSS' and UserName = @SZ_USER_ID and DomainId=@DomainId)
			SET @szHyperLink = 'http://nofault.friedharf.com'
		ELSE
			SET @szHyperLink = 'http://fhlk3'
		
		DECLARE @strsql as nvarchar(4000)
		
		SET @strsql = 'Select 	SZ_CASE_ID,SZ_PROCESS_NAME,' +
			'''<a href='''''+@szHyperLink + @szPath + ''' + SZ_FILENAME +' + '''' + '''''>''+SZ_FILENAME+''</a>''' + '[FileName],
			SZ_USER_ID,
			NOTES_DESC,
			DT_UPLOAD_TIME [DT_UPLOAD_TIME],
			SZ_CAPTION
		From TXN_DOCUMENT_UPLOAD ,TBLNOTES ,MST_PROCESS 
		WHERE 1=1 and TXN_DOCUMENT_UPLOAD .I_NOTES_ID = TBLNOTES .Notes_ID and TXN_DOCUMENT_UPLOAD .SZ_PROCESS_ID=MST_PROCESS .SZ_PROCESS_CODE and TXN_DOCUMENT_UPLOAD .DomainId=TBLNOTES .DomainId'

		if @SZ_CASE_ID <> ''
		begin
						set @strsql = @strsql + ' AND SZ_CASE_ID Like ''%' + @SZ_CASE_ID + '%'''
		end

		if @SZ_PROCESS_ID <> ''
		begin
						set @strsql = @strsql + ' AND SZ_PROCESS_ID Like ''%' + @SZ_PROCESS_ID + '%'''
		end

		if @SZ_CAPTION <> ''
		begin
						set @strsql = @strsql + ' AND SZ_CAPTION Like ''%' + @SZ_CAPTION + '%'''
		end

		if @SZ_NOTES <> ''
		begin
						set @strsql = @strsql + ' AND NOTES_DESC Like ''%' + @SZ_NOTES + '%'''
		end

		set @strsql = @strsql + ' ORDER BY DT_UPLOAD_TIME DESC'

		--insert into tbllog values(@strsql)
		EXEC(@strsql)
	END

