CREATE PROCEDURE [dbo].[SP_Get_Search_Result]
(
@szCaseId		nvarchar(50),        
@szFileStatus   nvarchar(50),        
@szProcessType  nvarchar(50)
)
As
Declare @szQuery As Varchar(4000)
Begin
set @szQuery = 'select  SZ_CASE_ID ,SZ_FILENAME,
						SZ_PROCESS_ID=CASE
						When SZ_PROCESS_ID=''PROC-001'' then ''Discovery Motion''
						When SZ_PROCESS_ID=''PROC-002'' then ''Response''
						End,
						I_UPLOAD_STATUS=CASE
						When I_UPLOAD_STATUS=''0'' then ''Process''
						When I_UPLOAD_STATUS=''1'' then ''Success''
						When I_UPLOAD_STATUS=''2'' then ''Error''
						End
				From MCR_TXN_FILE_UPLOAD
				Where 1=1 '
			
		if @szCaseId <> ''
				set @szQuery = @szQuery + ' And SZ_CASE_ID like ''%'+@szCaseId+'%'''

		if @szFileStatus <> '-1'
				set @szQuery = @szQuery + ' And I_UPLOAD_STATUS='''+@szFileStatus+''''

		if @szProcessType <> '-1'
				set @szQuery = @szQuery + ' And SZ_PROCESS_ID='''+@szProcessType+''''

		exec (@szQuery)
		--print @szQuery
		
End

