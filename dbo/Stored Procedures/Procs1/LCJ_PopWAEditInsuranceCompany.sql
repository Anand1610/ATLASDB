CREATE PROCEDURE [dbo].[LCJ_PopWAEditInsuranceCompany]
(

@InsuranceCompany_Id		nvarchar(100),
@Case_Id		nvarchar(100)

)

AS

UPDATE tblCase SET

		InsuranceCompany_Id = @InsuranceCompany_Id
		
WHERE 
		Case_Id = Rtrim(Ltrim(@Case_Id))

