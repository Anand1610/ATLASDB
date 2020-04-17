CREATE PROCEDURE [dbo].[SpGetCasesFiles](
@DOMAINID VARCHAR(10),
@CASEID VARCHAR(25),
@NODENAME VARCHAR(100)
)
AS
BEGIN
	select		doc.ImageId,
				doc.FileName,
				doc.FilePath,
				doc.BasePathId,
				tag.CaseID,
				tag.NodeName,
				tblBasePath.BasePathType
	from		tblDocImages doc
	join		tblImageTag imgtag on doc.ImageId = imgtag.ImageId
	join		tblTags tag on imgtag.TagID = tag.NodeID
	join		tblBasePath on doc.BasePathId = tblBasePath.BasePathId
	where		doc.DomainId = @DOMAINID
	and			tag.CaseID = @CASEID
	and			tag.NodeName = @NODENAME
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND doc.IsDeleted=0 AND imgtag.IsDeleted=0   
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
END

