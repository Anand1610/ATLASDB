CREATE PROCEDURE [dbo].[sp_Get_Document_For_Grid]--[sp_Get_Document_For_Grid] 'localhost','GLF18-102742'
	@DomainId nvarchar(50),
	@CASEID NVARCHAR(255) ='FH07-42372'
AS
BEGIN
	select 
		filename as filename,
		I.ImageID as ImageID,
		Nodename,
		--REPLACE(  REPLACE(B.VirtualBasePath, '/LSCasemanager','') +I.FilePath+I.FileName ,'\','/') as FILEPATH,
		REPLACE(  REPLACE(B.VirtualBasePath, '/LSCasemanager','') +'/'+ I.FilePath + I.FileName ,'\','/') as FILEPATH,
		usrcreated.UserName  as USERNAME,
		usrcreated.UserName  as modified_by,
		CONVERT(varchar, DateInserted,101) as DateInserted ,
		CONVERT(varchar, DateModified,101) as DateModified,
		DateInserted as order_by,
		case WHEN isnull( from_flag,0)=1 THEN 'Document Manager' 
			 WHEN isnull( from_flag,0)=2 THEN 'Template Manager' 
			 WHEN isnull( from_flag,0)=3 THEN 'Document Manager -Edit' 
			 when isnull( from_flag,0)=4 THEN 'Incident' 			 
			 WHEN isnull( from_flag,0)=5 THEN 'Settlement WorkSheet' 
			 WHEN isnull( from_flag,0)=6 THEN 'scanner' 
		ELSE '' END AS FROMLOCATION,
		Description as Description,
		
		case WHEN RIGHT(I.FilePath, 1) = '/' THEN substring (I.FilePath, 0,len(I.FilePath))
		ELSE 
			I.FilePath
		end  as 
			nodeForGrid		,
		DateInserted as DateInserted_sort ,
		DateModified as DateModified_sort
		,UPPER( case when  charindex('.', (filename))=0 then '' else reverse(substring(reverse(filename), 1, 
        charindex('.', reverse(filename))-1)) end  )as Filetype,
         --REPLACE(REPLACE('~/' +I.FilePath+I.FileName ,'\','/') ,char(39),'''') as UNC
		 REPLACE(REPLACE(I.FilePath+I.FileName ,'\','/') ,char(39),'''') as UNC,
		 I.BasePathId,
		 concat(replace(VirtualBasePath, '/', '\'),'\',I.FilePath + I.FileName) as DownloadLink  
	from 
		tblDocImages  I
		Join tblImageTag  IT on IT.ImageID=i.ImageID
		Join tblTags  T on T.NodeID = IT.TagID and T.CaseID= @CASEID
		left join tblBasePath B on B.BasePathId = I.BasePathId
		left join tblApplicationSettings  s on s.parametername='DocumentUploadLocation'  and s.DomainId = @DomainId
		left join dbo.IssueTracker_Users  usrcreated on usrcreated.UserId = case when  isnumeric(loginid)= 1 then  loginid else 1 end
		left join tbl_ImageTag_Modifiedby  modified_by on modified_by.ImageId = IT.ImageID
		left join dbo.IssueTracker_Users  usrmodified on usrmodified.UserId = modified_by.modified_by
		WHERE T.DomainId=@DomainId
		  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
        AND I.IsDeleted=0 AND IT.IsDeleted=0  
         ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  
	order by order_by desc	
	
END
------------------------------------------------------------------------------
