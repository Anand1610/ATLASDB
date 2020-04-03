CREATE PROCEDURE [dbo].[DocumentsPrinted]
(
@DomainID NVARCHAR(50),
@Doc_ID as int
)
as
begin
update tblPrintDocs set Printed_On = getDate() where Doc_ID = @Doc_ID AND Printed_On IS NULL and DomainId=@DomainID
--select * from lcj_vw_casesearchdetails where case_id in (select case_id from tblPrintDocs where Doc_ID = @Doc_ID AND Printed_On IS NULL ) order by case_id
end

