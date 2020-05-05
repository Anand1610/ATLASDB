CREATE PROCEDURE [dbo].[LCJ_UpdateDefendant]
(
@DomainId			nvarchar(50),
@Defendant_Id		nvarchar(200),
@Defendant_Name 	nvarchar(200),
@Defendant_Address	nvarchar(200),
@Defendant_City	nvarchar(50),
@Defendant_State	nvarchar(50),
@Defendant_Zip	nvarchar(50),
@Defendant_Phone	nvarchar(20),
@Defendant_Fax	nvarchar(20),
@Defendant_Email	nvarchar(100),
@Defendant_DisplayName varchar(100)
)
AS
BEGIN	
	BEGIN
		
		BEGIN TRAN

		UPDATE  tblDefendant 
		
		SET 

		Defendant_Name = @Defendant_Name,
		Defendant_Address = @Defendant_Address,
		Defendant_City = @Defendant_City,
		Defendant_State = @Defendant_State,
		Defendant_Zip = @Defendant_Zip,
		Defendant_Phone = @Defendant_Phone,
		Defendant_Fax = @Defendant_Fax,
		Defendant_Email = @Defendant_Email,
		Defendant_DisplayName=@Defendant_DisplayName

		WHERE

		Defendant_Id = @Defendant_Id and
		DomainId = @DomainId

		COMMIT TRAN

		

	END

END
