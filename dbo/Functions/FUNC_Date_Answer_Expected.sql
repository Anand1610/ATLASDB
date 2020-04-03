CREATE FUNCTION [dbo].[FUNC_Date_Answer_Expected] (@Case_Id varchar(50))

returns date
AS
begin
declare @date  date

SELECT @DATE= CASE WHEN (Date_Ext_Of_Time_3 IS NOT NULL) 
                      THEN (Date_Ext_Of_Time_3 + 5) WHEN (Date_Ext_Of_Time_2 IS NOT NULL) AND (Date_Ext_Of_Time_3 IS NULL) THEN (Date_Ext_Of_Time_2 + 5) 
                      WHEN (Date_Ext_Of_Time IS NOT NULL) AND (Date_Ext_Of_Time_2 IS NULL) THEN (Date_Ext_Of_Time + 5) WHEN (Date_Ext_Of_Time IS NULL) AND 
                      (InsuranceCompany_Name NOT LIKE '%GEICO%') THEN (Date_Afidavit_Filed + 45) WHEN (Date_Ext_Of_Time IS NULL) AND 
                      (InsuranceCompany_Name LIKE '%GEICO%') THEN (Served_on_date + 65) END 
FROM         dbo.tblcase INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
WHERE     dbo.tblcase.CASE_ID=@CASE_ID


RETURN @DATE


end
