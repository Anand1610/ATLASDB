CREATE PROCEDURE [dbo].[LCJ_DDL_DocumentType] --LCJ_DDL_DocumentType 'Fh07-42372'
(  
	@DomainId NVARCHAR(50),
   @Case_ID NVARCHAR(50) 
)  
as  
BEGIN  
SELECT '....SELECT Doc Types....' AS Document_Type,0 AS Document_ID
UNION 
SELECT distinct Document_Type,Document_ID FROM tblDocumentType  
inner join tblimages  on tblDocumentType .Document_Id=tblimages .DocumentId
WHERE case_id = @Case_ID and  tblimages.DomainId=@DomainId and imageid not in (SELECT imageid FROM tblimages  WHERE case_id =@Case_ID and fileName like '%.htm' and DomainId=@DomainId)
ORDER BY Document_Type
END

