CREATE PROCEDURE [dbo].[LCJ_tblInsuranceCompanyUpdate]
(
@DomainId					    nvarchar(50),
@InsuranceCompany_Id			nvarchar(100),
@InsuranceCompany_Name			nvarchar(200),
@InsuranceCompany_SuitName		nvarchar(200),
@InsuranceCompany_Type		 	varchar(40),
@InsuranceCompany_Local_Address 	varchar(255),
@InsuranceCompany_Local_City		varchar(100),
@InsuranceCompany_Local_State		varchar(100),
@InsuranceCompany_Local_Zip		varchar(50),
@InsuranceCompany_Local_Phone		varchar(100),
@InsuranceCompany_Local_Fax		varchar(100),
@InsuranceCompany_Contact		varchar(100),
@InsuranceCompany_Perm_Address		varchar(255),
@InsuranceCompany_Perm_City		varchar(100),
@InsuranceCompany_Perm_State		varchar(100),
@InsuranceCompany_Perm_Zip		varchar(50),
@InsuranceCompany_Perm_Phone		varchar(100),
@InsuranceCompany_Perm_Fax		varchar(100),
@InsuranceCompany_Email			varchar(100),
@activestatus int,
@InsuranceCompany_Address2_Address	varchar(250),
@InsuranceCompany_Address2_City		varchar(100),
@InsuranceCompany_Address2_State		varchar(100),
@InsuranceCompany_Address2_Zip		varchar(100),
@InsuranceCompany_Address2_Phone		varchar(100),
@InsuranceCompany_Address2_Fax		varchar(100),
-- Served Person Information
@InsuranceCompanyGroup varchar(200),
@InsuranceCompany_Local_County varchar(150),  
@InsuranceCompany_Address2_County varchar(150), 
@InsuranceCompany_Perm_County varchar(150),
@i_a_TPA_Group_ID int = null
)

AS
--IF EXISTS(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username AND UserID <> @UserId)
	--RETURN 1

--DECLARE @InsuranceCompany_Id nvarchar(100)

--SELECT @RoleId = RoleId FROM IssueTracker_Roles WHERE RoleName = @RoleName
UPDATE tblInsuranceCompany  SET
	
	InsuranceCompany_Name = @InsuranceCompany_Name,
	InsuranceCompany_suitName = @InsuranceCompany_SuitName,
	InsuranceCompany_Type = @InsuranceCompany_Type,
	InsuranceCompany_Local_Address = @InsuranceCompany_Local_Address,
	InsuranceCompany_Local_City = @InsuranceCompany_Local_City,
	InsuranceCompany_Local_State = @InsuranceCompany_Local_State,
	InsuranceCompany_Local_Zip = @InsuranceCompany_Local_Zip,
	InsuranceCompany_Local_Phone = @InsuranceCompany_Local_Phone,
	InsuranceCompany_Local_Fax = @InsuranceCompany_Local_Fax,
	InsuranceCompany_Contact = @InsuranceCompany_Contact,
	InsuranceCompany_Perm_Address = @InsuranceCompany_Perm_Address,
	InsuranceCompany_Perm_City = @InsuranceCompany_Perm_City,
	InsuranceCompany_Perm_State = @InsuranceCompany_Perm_State,
	InsuranceCompany_Perm_Zip = @InsuranceCompany_Perm_Zip,
	InsuranceCompany_Perm_Phone = @InsuranceCompany_Perm_Phone,
	InsuranceCompany_Perm_Fax = @InsuranceCompany_Perm_Fax,
	InsuranceCompany_Email = @InsuranceCompany_Email,
	InsuranceCompany_Address2_Address = @InsuranceCompany_Address2_Address,
	InsuranceCompany_Address2_City  =   @InsuranceCompany_Address2_City,
	InsuranceCompany_Address2_State =   @InsuranceCompany_Address2_State,
	InsuranceCompany_Address2_Zip =     @InsuranceCompany_Address2_Zip,
	InsuranceCompany_Address2_Phone =   @InsuranceCompany_Address2_Phone,
	InsuranceCompany_Address2_Fax =     @InsuranceCompany_Address2_Fax,	
	ActiveStatus = @activestatus,
	InsuranceCompany_GroupName =@InsuranceCompanyGroup,
	InsuranceCompany_Local_County = @InsuranceCompany_Local_County,  
	InsuranceCompany_Address2_County = @InsuranceCompany_Address2_County, 
	InsuranceCompany_Perm_County = @InsuranceCompany_Perm_County,
	fk_TPA_Group_ID = @i_a_TPA_Group_ID
WHERE 
	InsuranceCompany_Id = Rtrim(Ltrim(@InsuranceCompany_Id))
	and DomainId=@DomainId
