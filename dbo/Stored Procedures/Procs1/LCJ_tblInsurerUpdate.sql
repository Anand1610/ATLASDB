CREATE PROCEDURE [dbo].[LCJ_tblInsurerUpdate]
(

@Insurer_Id			nvarchar(100),
@Insurer_Name			nvarchar(200),
@Insurer_Type		 	varchar(40),
@Insurer_Local_Address 	varchar(	255),
@Insurer_Local_City		varchar(100),
@Insurer_Local_State		varchar(100),
@Insurer_Local_Zip		varchar(50),
@Insurer_Local_Phone		varchar(100),
@Insurer_Local_Fax		varchar(100),
@Insurer_Contact		varchar(100),
@Insurer_Perm_Address		varchar(255),
@Insurer_Perm_City		varchar(100),
@Insurer_Perm_State		varchar(100),
@Insurer_Perm_Zip		varchar(50),
@Insurer_Perm_Phone		varchar(100),
@Insurer_Perm_Fax		varchar(100),
@Insurer_Email			varchar(100)

)

AS
--IF EXISTS(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username AND UserID <> @UserId)
	--RETURN 1

--DECLARE @Insurer_Id nvarchar(100)

--SELECT @RoleId = RoleId FROM IssueTracker_Roles WHERE RoleName = @RoleName
UPDATE tblInsurer SET
	
	Insurer_Name = @Insurer_Name,
	Insurer_Type = @Insurer_Type,
	Insurer_Local_Address = @Insurer_Local_Address,
	Insurer_Local_City = @Insurer_Local_City,
	Insurer_Local_State = @Insurer_Local_State,
	Insurer_Local_Zip = @Insurer_Local_Zip,
	Insurer_Local_Phone = @Insurer_Local_Phone,
	Insurer_Local_Fax = @Insurer_Local_Fax,
	Insurer_Contact = @Insurer_Contact,
	Insurer_Perm_Address = @Insurer_Perm_Address,
	Insurer_Perm_City = @Insurer_Perm_City,
	Insurer_Perm_State = @Insurer_Perm_State,
	Insurer_Perm_Zip = @Insurer_Perm_Zip,
	Insurer_Perm_Phone = @Insurer_Perm_Phone,
	Insurer_Perm_Fax = @Insurer_Perm_Fax,
	Insurer_Email = @Insurer_Email
WHERE 
	Insurer_Id = Rtrim(Ltrim(@Insurer_Id))

