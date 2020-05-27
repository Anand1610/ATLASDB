CREATE PROCEDURE [dbo].[LCJ_UpdateAdjusters]
(
@DomainId nvarchar(50),
@Adjuster_Id		int,
@Adjuster_LastName	nvarchar(200),
@Adjuster_FirstName	nvarchar(200),
@Adjuster_Address  nvarchar(200),
@InsuranceCompany_Id	nvarchar(100),
@Adjuster_Phone	nvarchar(100),
@Adjuster_Fax		nvarchar(100),
@Adjuster_Email	nvarchar(100),
@Adjuster_Extension varchar(100)

)
AS
BEGIN
	
	BEGIN
		
		BEGIN TRAN

		UPDATE  tblAdjusters 
		
		SET 
		DomainId = @DomainId,				
		Adjuster_LastName = @Adjuster_LastName,
		Adjuster_FirstName = @Adjuster_FirstName,
		Adjuster_Address = @Adjuster_Address,
		InsuranceCompany_Id = @InsuranceCompany_Id,
		Adjuster_Phone = @Adjuster_Phone,
		Adjuster_Fax = @Adjuster_Fax,
		Adjuster_Email = @Adjuster_Email,
		Adjuster_Extension = @Adjuster_Extension
		WHERE

		Adjuster_Id = @Adjuster_Id
		COMMIT TRAN

	END

END

