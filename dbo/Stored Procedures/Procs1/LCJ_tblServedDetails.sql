CREATE PROCEDURE [dbo].[LCJ_tblServedDetails]
(
@DomainId						NVARCHAR(512),
@InsuranceCompany_Id			int
)
AS
Begin

		select Name, age,Weight,Height,skin,hair,sex,ID 
		from tblServed 
		where DomainId=@DomainId and InsuranceCompany_Id=@InsuranceCompany_Id
End
