
CREATE PROCEDURE [dbo].[LCJ_DDL_Case_Type]  
@DomainId varchar(50)
AS  
  
begin  
 
 SELECT '0' as PK_CaseType_Id,' --- Select Status --- ' as CaseType
    UNION
 SELECT   DISTINCT PK_CaseType_Id, Upper(ISNULL(CaseType, '')) AS CaseType
	FROM         MST_PacketCaseType
	WHERE     (1 = 1)  and DomainId=@DomainId order by PK_CaseType_Id

end

