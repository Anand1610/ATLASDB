--STP_DSP_GET_CASEDOCUMENTNODELIST '1312','0'
CREATE PROCEDURE [dbo].[STP_DSP_GET_CASEDOCUMENTNODELIST]
@CASEID NVARCHAR(255),
@ISARCHIVED NCHAR,
@SZ_COMPANY_ID NVARCHAR(20)=null 
AS

IF @ISARCHIVED='0'
	Select cast(T.NodeID as nvarchar) NodeID, T.ParentID, T.NodeName, T.NodeIcon, T.NodeLevel, T.Expanded 
	from tblTags T Where CaseID=@CASEID  
	union  Select 'IMG-' + Cast(I.ImageID as nvarchar), T.NodeID, 
	'<a href='''+s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>', 'page.gif', 


	T.NodeLevel+1, 1 from TBLDOCIMAGES I  
	Inner Join tblImageTag IT on IT.ImageID=i.ImageID  
	Inner Join tblTags T on T.NodeID=IT.TagID and T.CaseID=@CASEID 
	left join tblApplicationSettings s on s.parametername='DocumentUploadLocation' order by nodelevel, nodename
ELSE
	Select cast(T.NodeID as nvarchar) NodeID, T.ParentID, T.NodeName, T.NodeIcon, T.NodeLevel, T.Expanded 
	from tblTags T Where CaseID=@CASEID  
	union  Select 'IMG-' + Cast(I.ImageID as nvarchar), T.NodeID, 

'<a href='''+s.ParameterValue+I.FilePath+I.FileName +''' target=''imageframe'' onclick=''VisibleFrame();''>'+I.FileName+'</a>', 'page.gif', 

	T.NodeLevel+1, 1 from TBLDOCIMAGES I  
	Inner Join tblImageTag IT on IT.ImageID=i.ImageID  
	Inner Join tblTags T on T.NodeID=IT.TagID and T.CaseID=@CASEID 
	left join tblApplicationSettings s on s.parametername='ArchivedDocumentUploadLocation' order by nodelevel, nodename

