CREATE PROCEDURE [dbo].[LCJ_AddPersonServed]
(
			@InsuranceCompany_Id			int,
			@Name							varchar(50),
			@Age							varchar(10),
			@Weight							varchar(10),
			@Height							varchar(10),
			@Skin							varchar(50),
			@Hair							varchar(50),
			@Sex							varchar(10),
			@DomainId						nvarchar(512)


)
AS
BEGIN
	
	BEGIN


		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblServed 
		(
			InsuranceCompany_Id	,		
			Name,							
			Age	,						
			Weight	,						
			Height	,						
			Skin,							
			Hair,							
			Sex	,						
			DomainId
		)

		VALUES(
			@InsuranceCompany_Id,			
			@Name,							
			@Age,							
			@Weight	,						
			@Height,							
			@Skin,							
			@Hair,							
			@Sex,							
			@DomainId	
		)					

		COMMIT TRAN

	END -- END of ELSE	

END

