
CREATE VIEW [dbo].[Insurance]
AS
SELECT     TOP (100) PERCENT InsuranceCompany_Id, InsuranceCompany_Name, InsuranceCompany_SuitName, InsuranceCompany_Type, 
                      InsuranceCompany_Local_Address, InsuranceCompany_Local_City, InsuranceCompany_Local_State, InsuranceCompany_Local_Zip, 
                      InsuranceCompany_Local_Phone, InsuranceCompany_Local_Fax, InsuranceCompany_Perm_Address, InsuranceCompany_Perm_City, 
                      InsuranceCompany_Perm_State, InsuranceCompany_Perm_Zip, InsuranceCompany_Perm_Phone, InsuranceCompany_Perm_Fax, 
                      InsuranceCompany_Contact, InsuranceCompany_Email, InsuranceCompany_GroupName, Active, BILLING_ADDRESS, BILLING_CITY, BILLING_STATE, 
                      BILLING_ZIP
FROM         dbo.tblInsuranceCompany
ORDER BY InsuranceCompany_Name
