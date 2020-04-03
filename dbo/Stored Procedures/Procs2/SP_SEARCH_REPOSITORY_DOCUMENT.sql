CREATE PROCEDURE [dbo].[SP_SEARCH_REPOSITORY_DOCUMENT]  
	@DomainId NVARCHAR(50),
	@SZ_USER_ID NVARCHAR(20) = NULL,  
	@SZ_CAPTION as NVARCHAR(50) = NULL,  
	@SZ_PROCESS as NVARCHAR(50) = NULL,   
	@SZ_NOTES as NVARCHAR(255) = NULL,  
	@SZ_DOC_URL as nvarchar(1000)= NULL  
AS    
	BEGIN    
		Declare @szPath As varchar(100)    
		set @szPath = ''  
		Declare @szHyperLink As varchar(100)  
		set @szHyperLink = @SZ_DOC_URL  
		DECLARE @strsql as nvarchar(4000)  
     
		SET @strsql = 'Select SZ_PROCESS_NAME,' +    
		'''<a href='''''+@szHyperLink + @szPath + ''' + SZ_FILENAME +' + '''' + '''''>''+SZ_FILENAME+''</a>''' + '[FileName],    
		SZ_USER_ID,    
		sz_notes,    
		DT_UPLOAD_TIME [DT_UPLOAD_TIME],    
		SZ_CAPTION    
		From TXN_REPOSITORY_UPLOAD  AS TXN_REPOSITORY_UPLOAD,MST_PROCESS  AS MST_PROCESS    
		WHERE 1=1 AND TXN_REPOSITORY_UPLOAD.SZ_PROCESS_ID=MST_PROCESS.SZ_PROCESS_CODE AND MST_PROCESS.DomainId = @DomainId'    
    
		if @SZ_PROCESS <> '' AND @SZ_PROCESS <> 'NA'
		begin    
			set @strsql = @strsql + ' AND SZ_PROCESS_ID Like ''%' + @SZ_PROCESS + '%'''    
		end    
    
		if @SZ_CAPTION <> ''    
		begin    
			set @strsql = @strsql + ' AND SZ_CAPTION Like ''%' + @SZ_CAPTION + '%'''    
		end    
    
		if @SZ_NOTES <> ''    
		begin    
			set @strsql = @strsql + ' AND sz_notes Like ''%' + @SZ_NOTES + '%'''    
		end    
    
		set @strsql = @strsql + ' ORDER BY DT_UPLOAD_TIME DESC'    
    
		insert into tbllog values(@strsql,@DomainId)    
		EXEC(@strsql)    
 END

