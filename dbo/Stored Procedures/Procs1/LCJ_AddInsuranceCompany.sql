
Create PROCEDURE [dbo].[LCJ_AddInsuranceCompany]
(
@DomainId NVARCHAR(50),
--Client_Id	nvarchar	no	100
@InsuranceCompany_Name		nvarchar(200),
@InsuranceCompany_SuitName	nvarchar(250),
@InsuranceCompany_Type		varchar(40),
@InsuranceCompany_Local_Address	varchar(255),
@InsuranceCompany_Local_Address_1	varchar(255),

@InsuranceCompany_Local_City		varchar(100),
@InsuranceCompany_Local_State	varchar(100),
@InsuranceCompany_Local_Zip		varchar(50),
@InsuranceCompany_Local_Phone	varchar(100),
@InsuranceCompany_Local_Fax		varchar(100),
@InsuranceCompany_Contact		varchar(100),
@InsuranceCompany_Perm_Address	varchar(255),
@InsuranceCompany_Perm_City		varchar(100),
@InsuranceCompany_Perm_State	varchar(100),
@InsuranceCompany_Perm_Zip		varchar(50),
@InsuranceCompany_Perm_Phone	varchar(100),
@InsuranceCompany_Perm_Fax		varchar(100),
@InsuranceCompany_Email		varchar(100),
@Security			varchar(10),
@UserName			Nvarchar(40),
@UserPassword			nvarchar(40),
@OperationResult 		INT OUTPUT,
@NewUserError			INT OUTPUT,
@InsuranceCompany_Address2_Address varchar(255), 
@InsuranceCompany_Address2_City	   varchar(100),
@InsuranceCompany_Address2_State   varchar(100),
@InsuranceCompany_Address2_Zip     varchar(100),
@InsuranceCompany_Address2_Phone   varchar(100),
@InsuranceCompany_Address2_Fax     varchar(100),
@Id int output,
--@OperationResult INTEGER OUT,
-- Served Person Information
--@Served_Person_Name varchar(200),
@InsuranceCompanyGroup varchar(200),
@InsuranceCompany_Local_County varchar(150),  
@InsuranceCompany_Address2_County varchar(150), 
@InsuranceCompany_Perm_County varchar(150),
@i_a_TPA_Group_ID int = null
)
AS

Set NOCOUNT ON
	DECLARE @InsuranceCompanyID AS NVARCHAR(20) ,@CurrentDate AS SMALLDATETIME
	SET @CurrentDate = Convert(Varchar(15), GetDate(),102)

	IF EXISTS(Select InsuranceCompany_Name from tblInsuranceCompany where InsuranceCompany_Name = @InsuranceCompany_Name and DomainId=@DomainId) 
		BEGIN
			SET @OperationResult = 1
			Return 1
		END
	Else


		BEGIN
	
	
	
			DECLARE @MaxInsuranceCompany_Id_IDENTITY INTEGER
			
			-- Insert the records
			BEGIN TRAN
	
			INSERT INTO tblInsuranceCompany
			(
			InsuranceCompany_Name,
			InsuranceCompany_SuitName,
			InsuranceCompany_Type,
			InsuranceCompany_Local_Address,
			InsuranceCompany_Local_Address_1,
			InsuranceCompany_Local_City,
			InsuranceCompany_Local_State,
			InsuranceCompany_Local_Zip,
			InsuranceCompany_Local_Phone,
			InsuranceCompany_Local_Fax,
			InsuranceCompany_Contact,
			InsuranceCompany_Perm_Address,
			InsuranceCompany_Perm_City,
			InsuranceCompany_Perm_State,
			InsuranceCompany_Perm_Zip,
			InsuranceCompany_Perm_Phone,
			InsuranceCompany_Perm_Fax,
			InsuranceCompany_Email,
			InsuranceCompany_Initial_Address,
			InsuranceCompany_Initial_City,
			InsuranceCompany_Initial_State,
			InsuranceCompany_Initial_Zip,
			InsuranceCompany_Address2_Address,
			InsuranceCompany_Address2_City,
			InsuranceCompany_Address2_State,
			InsuranceCompany_Address2_Zip,
			InsuranceCompany_Address2_Phone,
			InsuranceCompany_Address2_Fax,
			DomainId,
			InsuranceCompany_GroupName,
			InsuranceCompany_Local_County,  
			InsuranceCompany_Address2_County, 
			InsuranceCompany_Perm_County,
			InsuranceCompany_Initial_County,
			fk_TPA_Group_ID
			)
	
			VALUES(
				
			@InsuranceCompany_Name,
			@InsuranceCompany_SuitName,
			@InsuranceCompany_Type,
			@InsuranceCompany_Local_Address,
			@InsuranceCompany_Local_Address_1,
			@InsuranceCompany_Local_City,
			@InsuranceCompany_Local_State,
			@InsuranceCompany_Local_Zip,
			@InsuranceCompany_Local_Phone,
			@InsuranceCompany_Local_Fax,
			@InsuranceCompany_Contact,
			@InsuranceCompany_Perm_Address,
			@InsuranceCompany_Perm_City,
			@InsuranceCompany_Perm_State,
			@InsuranceCompany_Perm_Zip,
			@InsuranceCompany_Perm_Phone,
			@InsuranceCompany_Perm_Fax,
			@InsuranceCompany_Email,
			@InsuranceCompany_Local_Address,
			@InsuranceCompany_Local_City,
			@InsuranceCompany_Local_State,
			@InsuranceCompany_Local_Zip,
			@InsuranceCompany_Address2_Address,
			@InsuranceCompany_Address2_City,
			@InsuranceCompany_Address2_State,
			@InsuranceCompany_Address2_Zip,
			@InsuranceCompany_Address2_Phone,
			@InsuranceCompany_Address2_Fax,
			@DomainId,
			--@Served_Person_Name ,
			@InsuranceCompanyGroup,
			@InsuranceCompany_Local_County,  
			@InsuranceCompany_Address2_County, 
			@InsuranceCompany_Perm_County,
			@InsuranceCompany_Local_County,
			@i_a_TPA_Group_ID
			)					
	
	
			COMMIT TRAN
	        SET @id=SCOPE_IDENTITY()
      RETURN  @id
 
			SELECT @MaxInsuranceCompany_Id_IDENTITY = MAX(InsuranceCompany_Id) from tblinsurancecompany WHERE DomainId=@DomainId
					
			IF @Security = 'True'
				BEGIN
					
					IF (EXISTS(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username and DomainId=@DomainId) OR EXISTS(SELECT UserId FROM IssueTracker_Users WHERE UserTypeLogin = @InsuranceCompanyID and DomainId=@DomainId))

					--IF EXISTS(SELECT Username FROM IssueTracker_Users WHERE Username = @Username)
						
						BEGIN

							SET @NewUserError = 1
	
							RETURN 1

						END
					Else
						
						BEGIN

								INSERT IssueTracker_Users
								(
									Username,
									RoleId,
									Email,
									DisplayName,
									UserPassword,
									UserTypeLogin,
									UserType,
									DomainId
								) 
								VALUES 
								(
									@Username,
									'3',
									@InsuranceCompany_Email,
									@Username,
									@UserPassword,
									Rtrim(Ltrim(@InsuranceCompanyID)),
									'I',
									@DomainId
								)
		
								SET @NewUserError = 0
			
								RETURN 0
						END
						
				END

			declare
			@cnt int,
			@iname varchar(100)
			select @iname = insurancecompany_name from tblinsurancecompany where InsuranceCompany_Id = @MaxInsuranceCompany_Id_IDENTITY and DomainId=@DomainId
			select @cnt = count(*) from tbldesk where desk_name = @iname
			if @cnt =0
			begin
				insert into tbldesk values (@iname, @DomainId)
			end
	
	
	
		END -- END of ELSE
