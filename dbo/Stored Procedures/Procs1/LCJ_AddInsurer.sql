CREATE PROCEDURE [dbo].[LCJ_AddInsurer]
(

--Client_Id	nvarchar	no	100
@Insurer_Name		nvarchar(200),
@Insurer_Type		varchar(40),
@Insurer_Local_Address	varchar(	255),
@Insurer_Local_City	varchar(100),
@Insurer_Local_State	varchar(100),
@Insurer_Local_Zip	varchar(50),
@Insurer_Local_Phone	varchar(100),
@Insurer_Local_Fax	varchar(100),
@Insurer_Contact	varchar(100),
@Insurer_Perm_Address	varchar(255),
@Insurer_Perm_City	varchar(100),
@Insurer_Perm_State	varchar(100),
@Insurer_Perm_Zip	varchar(50),
@Insurer_Perm_Phone	varchar(100),
@Insurer_Perm_Fax	varchar(100),
@Insurer_Email		varchar(100)


--@OperationResult INTEGER OUT
)
AS
BEGIN
	DECLARE @InsurerID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME
			
			
	
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	
	BEGIN
		
		
		
		DECLARE @MaxInsurer_Id_IDENTITY INTEGER
		/*Select @MaxInsurer_Id =Convert(Integer , SUBSTRING(MAX(Insurer_Id),PATINDEX('%-%' , MAX(Insurer_Id) )+1, 8)) from tblInsurer
	
		IF (@MaxInsurer_Id = NULL)
			
			SET @InsurerID  = 'I' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + '1'

		ELSE
			
			SET @InsurerID = 'I' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxInsurer_Id + 1 AS NVARCHAR)

		*/
		-- Insert the records
		BEGIN TRAN
			
		INSERT INTO tblInsurer
		(
		Insurer_Id, 
		Insurer_Name,
		Insurer_Type,
		Insurer_Local_Address,
		Insurer_Local_City,
		Insurer_Local_State,
		Insurer_Local_Zip,
		Insurer_Local_Phone,
		Insurer_Local_Fax,
		Insurer_Contact,
		Insurer_Perm_Address,
		Insurer_Perm_City,
		Insurer_Perm_State,
		Insurer_Perm_Zip,
		Insurer_Perm_Phone,
		Insurer_Perm_Fax,
		Insurer_Email

		)
			 
		VALUES(
		
		'',
		@Insurer_Name,
		@Insurer_Type,
		@Insurer_Local_Address,
		@Insurer_Local_City,
		@Insurer_Local_State,
		@Insurer_Local_Zip,
		@Insurer_Local_Phone,
		@Insurer_Local_Fax,
		@Insurer_Contact,
		@Insurer_Perm_Address,
		@Insurer_Perm_City,
		@Insurer_Perm_State,
		@Insurer_Perm_Zip,
		@Insurer_Perm_Phone,
		@Insurer_Perm_Fax,
		@Insurer_Email
		)					
			

		COMMIT TRAN
		
		SET @MaxInsurer_Id_IDENTITY = @@IDENTITY
			
		SET @InsurerID  = 'I' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxInsurer_Id_IDENTITY AS NVARCHAR)
			
		UPDATE tblInsurer SET Insurer_Id = @InsurerID where Insurer_AutoId = @MaxInsurer_Id_IDENTITY

		

	END -- END of ELSE	
	
END

