CREATE PROCEDURE [dbo].[EDIDATA] AS
begin

INSERT into LCJEDI.dbo.EDIDATA
select Case_Id,injuredparty_name,Court_Name,Court_Venue,Provider_Name,
InsuranceCompany_Name,Indexoraaa_number,Date_Opened 
from LCJ.dbo.LCJ_VW_CaseSearchDetails where Datediff(d,Date_opened,getdate())=0 

end

