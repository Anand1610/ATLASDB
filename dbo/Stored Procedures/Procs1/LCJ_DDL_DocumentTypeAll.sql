CREATE PROCEDURE [dbo].[LCJ_DDL_DocumentTypeAll]
AS
begin
	--select 0 as Document_ID , '...Select...' as Document_Type
	--union 
	select Document_ID, Document_Type from tbldocumenttype where doc_for=0 order by document_Type asc
end

