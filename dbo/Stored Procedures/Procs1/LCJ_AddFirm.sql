CREATE PROCEDURE [dbo].[LCJ_AddFirm]
(

--Client_Id	nvarchar	no	100
@Firm_Name		nvarchar(200),
@Firm_Address		varchar(255),
@Firm_City		varchar(100),
@Firm_State		varchar(100),
@Firm_Zip		varchar(50),
@Firm_Phone		varchar(100),
@Firm_Fax		varchar(100),
@Firm_Email		varchar(100)

)
AS
BEGIN
	DECLARE @FirmID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME
			
	
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	
	BEGIN
		
		
		DECLARE @MaxFirm_Id_IDENTITY  INTEGER

		/*Select @MaxFirm_Id =Convert(Integer , SUBSTRING(MAX(Firm_Id),PATINDEX('%-%' , MAX(Firm_Id) )+1, 8)) from tblFirms
	
		IF (@MaxFirm_Id = NULL)
			
			SET @FirmID  = 'I' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + '1'

		ELSE
			
			SET @FirmID = 'I' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxFirm_Id + 1 AS NVARCHAR)

		*/
		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblFirms
		(
		Firm_Id, 
		Firm_Name,
		Firm_Address,
		Firm_City,
		Firm_State,
		Firm_Zip,
		Firm_Phone,
		Firm_Fax,
		Firm_Email

		)
			 
		VALUES(
		'',
		@Firm_Name,		
		@Firm_Address,
		@Firm_City,
		@Firm_State,
		@Firm_Zip,
		@Firm_Phone,
		@Firm_Fax,
		@Firm_Email
		)					
			

		COMMIT TRAN

		SET @MaxFirm_Id_IDENTITY = @@IDENTITY
			
		SET @FirmID  = 'F' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxFirm_Id_IDENTITY AS NVARCHAR)
			
		UPDATE tblFirms SET Firm_Id = @FirmID where Firm_AutoId = @MaxFirm_Id_IDENTITY

	END -- END of ELSE	
	
END

