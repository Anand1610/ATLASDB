CREATE PROCEDURE [dbo].[LCJ_AddClient]
(

--Client_Id	nvarchar	no	100
@Client_Name		nvarchar(200),
@Client_Type		varchar(40),
@Client_Local_Address	varchar(	255),
@Client_Local_City	varchar(100),
@Client_Local_State	varchar(100),
@Client_Local_Zip	varchar(50),
@Client_Local_Phone	varchar(100),
@Client_Local_Fax	varchar(100),
@Client_Contact	varchar(100),
@Client_Perm_Address	varchar(255),
@Client_Perm_City	varchar(100),
@Client_Perm_State	varchar(100),
@Client_Perm_Zip	varchar(50),
@Client_Perm_Phone	varchar(100),
@Client_Perm_Fax	varchar(100),
@Client_Email		varchar(100)


--@OperationResult INTEGER OUT
)
AS
BEGIN
	DECLARE @ClientID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME					
	
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)
	

	BEGIN
		
		
		DECLARE @MaxClient_Id_IDENTITY  INTEGER

		/*
		Select @MaxClient_Id =Convert(Integer , SUBSTRING(MAX(Client_Id),PATINDEX('%-%' , MAX(Client_Id) )+1, 8)) from tblClient 
	
		IF (@MaxClient_Id = NULL)
			--SET @ClientID  = 'LCJ' + DATEPART(year, GETDATE()) + '-' + '1'
			SET @ClientID  = 'CL' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + '1'

		ELSE
			--SET @ClientID  = 'LCJ' + DATEPART(year, GETDATE()) + '-' + CONVERT(VARCHAR(8) , (@MaxClient_Id + 1))
			SET @ClientID = 'CL' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxClient_Id + 1 AS NVARCHAR)
		*/
	
		-- Insert the records
		BEGIN TRAN
			-- Insert Claim Details
		INSERT INTO tblClient 
		(
		Client_Id, 
		Client_Name,
		Client_Type,
		Client_Local_Address,
		Client_Local_City,
		Client_Local_State,
		Client_Local_Zip,
		Client_Local_Phone,
		Client_Local_Fax,
		Client_Contact,
		Client_Perm_Address,
		Client_Perm_City,
		Client_Perm_State,
		Client_Perm_Zip,
		Client_Perm_Phone,
		Client_Perm_Fax,
		Client_Email

		)
			 
		VALUES(

		'',
		@Client_Name,
		@Client_Type,
		@Client_Local_Address,
		@Client_Local_City,
		@Client_Local_State,
		@Client_Local_Zip,
		@Client_Local_Phone,
		@Client_Local_Fax,
		@Client_Contact,
		@Client_Perm_Address,
		@Client_Perm_City,
		@Client_Perm_State,
		@Client_Perm_Zip,
		@Client_Perm_Phone,
		@Client_Perm_Fax,
		@Client_Email
		)					
			

		COMMIT TRAN
		
		SET @MaxClient_Id_IDENTITY = @@IDENTITY
			
		SET @ClientID  = 'CL' + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR),2) + '-' + CAST(@MaxClient_Id_IDENTITY AS NVARCHAR)
			
		UPDATE tblClient SET Client_Id = @ClientID where Client_AutoId = @MaxClient_Id_IDENTITY

	END -- END of ELSE	
	
END

