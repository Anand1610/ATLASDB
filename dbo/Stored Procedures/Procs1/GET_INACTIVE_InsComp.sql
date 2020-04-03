CREATE PROCEDURE [dbo].[GET_INACTIVE_InsComp]
(
@DomainId nvarchar(50)
)
AS
Begin
	select insuranceCompany_id, insurancecompany_name, insuranceCompany_Local_Address  from tblInsuranceCompany where ActiveStatus = 0 AND DomainId = @DomainId
	order by 2
--select insuranceCompany_id, insurancecompany_name, insuranceCompany_Local_Address +' '+ InsuranceCompany_Local_Address+' '+ insuranceCompany_Local_City+ ' '+insuranceCompany_Local_State+' '+insuranceCompany_Local_Zip as insuranceCompany_Local_Address from tblinsurancecompany where ActiveStatus = 0
End

