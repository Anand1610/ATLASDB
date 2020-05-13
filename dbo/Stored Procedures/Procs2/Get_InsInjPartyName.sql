CREATE Procedure [dbo].[Get_InsInjPartyName]
@CaseId varchar(50),
@editValue varchar(50)
AS
BEGIN

if @editValue ='selectInj'
BEGIN
select case_id,injuredparty_firstname as FirstName,injuredparty_lastname as LastName from tblcase where case_id=@CaseId
END

if @editValue ='selectIns'
BEGIN
select case_id,insuredparty_firstname as FirstName, insuredparty_lastname as LastName from tblcase where case_id=@CaseId
END

END
GO


