CREATE PROCEDURE [dbo].[LCJ_AdjusterDetails]
	
	(
		@DomainId nvarchar(50),
		@Adjuster_Id int
		
	)

AS

BEGIN

	SELECT    Adjuster_Id, Adjuster_LastName, Adjuster_FirstName, InsuranceCompany_Id, 
		    Adjuster_Phone,Adjuster_Address, Adjuster_Fax, Adjuster_Email,Adjuster_Extension
	FROM       tblAdjusters 
	WHERE    Adjuster_Id = @Adjuster_Id and DomainId = @DomainId

END

