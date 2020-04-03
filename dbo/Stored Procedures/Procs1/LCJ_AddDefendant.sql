CREATE PROCEDURE [dbo].[LCJ_AddDefendant]
(
@DomainId NVARCHAR(50),
--Client_Id	nvarchar	no	100
@Defendant_Name		nvarchar(200),
@Defendant_Address		varchar(255),
@Defendant_City		varchar(100),
@Defendant_State		varchar(100),
@Defendant_Zip		varchar(50),
@Defendant_Phone		varchar(100),
@Defendant_Fax		varchar(100),
@Defendant_Email		varchar(100)

)
AS
BEGIN
	

		INSERT INTO tblDefendant
		(
		Defendant_Name,
		Defendant_DisplayName,
		Defendant_Address,
		Defendant_City,
		Defendant_State,
		Defendant_Zip,
		Defendant_Phone,
		Defendant_Fax,
		Defendant_Email,
		DomainId

		)

		VALUES(
		@Defendant_Name,
		@Defendant_Name,		
		@Defendant_Address,
		@Defendant_City,
		@Defendant_State,
		@Defendant_Zip,
		@Defendant_Phone,
		@Defendant_Fax,
		@Defendant_Email,
		@DomainId
		)					


	
	
END

