CREATE PROCEDURE [dbo].[LCJ_DDL_WorkArea_AssignTo] 

AS

select Desk_Id, UPPER(Desk_Name) as Desk_Name from tblDesk where Desk_Name 
not in (select Provider_Name from tblProvider) 
and Desk_Name 
not in (select InsuranceCompany_Name from tblInsuranceCompany) 
and Desk_Name not in (Select Status_type from tblStatus) ORDER BY 2

