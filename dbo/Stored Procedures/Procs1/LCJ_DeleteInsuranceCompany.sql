CREATE PROCEDURE [dbo].[LCJ_DeleteInsuranceCompany]
(
@DomainId nvarchar(50),
@InsuranceCompany_Id int,
@OperationResult INT OUTPUT

)


AS

		IF EXISTS(Select InsuranceCompany_Id  
		
			FROM  tblCase 
			WHERE 
			InsuranceCompany_Id = @InsuranceCompany_Id
			and DomainId = @DomainId
		
			  
		)

			BEGIN
				SET @OperationResult = 1
				Return 1
				
			END
	
		ELSE
			BEGIN
				DELETE from tblInsuranceCompany  where InsuranceCompany_Id = @InsuranceCompany_Id and DomainId = @DomainId
				SET @OperationResult = 0
				Return 0
			END

