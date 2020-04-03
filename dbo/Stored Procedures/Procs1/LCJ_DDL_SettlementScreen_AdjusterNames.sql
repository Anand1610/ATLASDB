  
CREATE PROCEDURE [dbo].[LCJ_DDL_SettlementScreen_AdjusterNames]  -- LCJ_DDL_SettlementScreen_AdjusterNames 'PDC'  
@DomainId NVARCHAR(50)  
AS  
  
begin  
  
SELECT '0' AS Adjuster_Id, ' --- Select Adjuster --- ' AS Adjuster_Name_Details  
 UNION  
 SELECT    Adjuster_Id, Upper(ISNULL(LTRIM(RTRIM(Adjuster_FirstName)) + ' ' + LTRIM(RTRIM(Adjuster_LastName)), '') + ' =>' + '[Adj.Ph#: ' + ISNULL(Adjuster_Phone,'') +' /' + 'Adj fax#: ' + ISNULL(Adjuster_Fax,'') + ']') AS Adjuster_Name_Details  
 FROM         tbladjusters  
 WHERE     (1 = 1 ) and tbladjusters.DomainId = @DomainId order by Adjuster_Name_Details
  
   
end  
  