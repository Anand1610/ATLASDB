CREATE PROCEDURE [dbo].[LCJ_DDL_Nodes]
@DomainId varchar(50)=''
AS 
BEGIN
		Select '---Select Type---' As NodeName
		Union
		SELECT DISTINCT NodeName FROM  MST_DOCUMENT_NODES where DomainId=@DomainId
		
END

