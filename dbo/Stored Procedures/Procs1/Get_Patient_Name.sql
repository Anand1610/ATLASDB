CREATE PROCEDURE [dbo].[Get_Patient_Name]
	@Case_Id VARCHAR(100)
AS
BEGIN
	SELECT InjuredParty_FirstName + ' ' + InjuredParty_LastName [Patient_Name] from tblcase where Case_Id=@Case_Id
END

