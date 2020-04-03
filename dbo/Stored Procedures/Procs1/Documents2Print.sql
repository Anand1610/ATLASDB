CREATE PROCEDURE [dbo].[Documents2Print]
(
@DomainId NVARCHAR(50),
@Doc_ID as int
)
as
begin
select * from lcj_vw_casesearchdetails where case_id in (select case_id from tblPrintDocs where Doc_ID = @Doc_ID AND Printed_On IS NULL and DomainId=@DomainId ) order by case_id
end

