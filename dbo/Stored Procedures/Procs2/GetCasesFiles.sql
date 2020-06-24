CREATE PROCEDURE [GetCasesFiles]
(
@DOMAINID VARCHAR(10),
@CASEID VARCHAR(25),
@NODENAME VARCHAR(100),
@NODELEVEL INT
)
AS
BEGIN
	select		Top 1
				doc.ImageId,
				doc.FileName,
				doc.FilePath,
				doc.BasePathId,
				tag.CaseID,
				tag.NodeName,
				tblBasePath.BasePathType
	from		tblDocImages(nolock) doc
	join		tblImageTag(nolock) imgtag on doc.ImageId = imgtag.ImageId
	join		tblTags(nolock) tag on imgtag.TagID = tag.NodeID
	join		tblBasePath(nolock) on doc.BasePathId = tblBasePath.BasePathId
	where		doc.DomainId = @DOMAINID
	and			tag.CaseID = @CASEID
	and			tag.NodeName = @NODENAME
	and			tag.NodeLevel = @NODELEVEL
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND doc.IsDeleted=0 AND imgtag.IsDeleted=0   
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
	ORDER BY	ImageID DESC
END

