CREATE Procedure [dbo].[Update_InsInjPartyName]
@FirstName varchar(200),
@LastName varchar(200),
@CaseId varchar(50),
@editValue varchar(50)

AS
BEGIN

if @editValue ='updateInj'
BEGIN
 update tblcase set injuredparty_firstname =@FirstName  ,injuredparty_lastname=@LastName
 where case_id= @CaseId
END

if @editValue ='updateIns'
BEGIN
update tblcase set insuredparty_firstname = @FirstName,insuredparty_lastname=@LastName
where case_id=@CaseId
END

END
