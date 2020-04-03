CREATE PROCEDURE [dbo].[LCJ_tblClientUpdate]
(

@Client_Id		nvarchar(100),
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
)

AS
--IF EXISTS(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username AND UserID <> @UserId)
	--RETURN 1

--DECLARE @Client_Id nvarchar(100)

--SELECT @RoleId = RoleId FROM IssueTracker_Roles WHERE RoleName = @RoleName
UPDATE tblClient SET
		 
		Client_Name = @Client_Name,
		Client_Type = @Client_Type,
		Client_Local_Address = @Client_Local_Address,
		Client_Local_City = @Client_Local_City,
		Client_Local_State = @Client_Local_State,
		Client_Local_Zip = @Client_Local_Zip,
		Client_Local_Phone = @Client_Local_Phone,
		Client_Local_Fax = @Client_Local_Fax,
		Client_Contact = @Client_Contact,
		Client_Perm_Address = @Client_Perm_Address,
		Client_Perm_City = @Client_Perm_City,
		Client_Perm_State = @Client_Perm_State,
		Client_Perm_Zip = @Client_Perm_Zip,
		Client_Perm_Phone = @Client_Perm_Phone,
		Client_Perm_Fax = @Client_Perm_Fax,
		Client_Email = @Client_Email
WHERE 
		Client_Id = Rtrim(Ltrim(@Client_Id))

