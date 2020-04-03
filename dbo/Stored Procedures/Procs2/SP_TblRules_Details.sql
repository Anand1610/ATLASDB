


CREATE PROCEDURE [dbo].[SP_TblRules_Details]
(
@DomainId nvarchar(50)
)

AS
BEGIN
	SET NOCOUNT ON;
		SELECT r.Rules_ID, 
			r.Rules_Disc, 
			r.Provider_ID, 
			r.InsuranceCompanyID, 
			r.Provider_Group,
			r.Insurance_Group, 
			r.Status, 
			i.InsuranceCompany_Name,
			i.InsuranceCompany_Id, 
			p.Provider_Name,
			CONVERT(VARCHAR,r.Date_Created,101)Date_Created, 
			r.Created_By, 
			r.Rule_RequestedBy, 
			r.Rule_Component, 
			r.Rule_Action, 
			r.Rule_Type,
			r.FilePath,
			r.Filename,
			r.Category,
			IG.InsuranceCompanyGroup_Name
FROM Tbl_Rules AS r 
left JOIN tblInsuranceCompany AS i ON i.InsuranceCompany_Id = r.InsuranceCompanyID 
left JOIN tblProvider AS p ON p.Provider_Id = r.Provider_ID
left join tblInsuranceCompanyGroup IG ON IG.InsuranceCompanyGroup_ID=r.Insurance_Group
Where r.[DomainId] = @DomainId
END


