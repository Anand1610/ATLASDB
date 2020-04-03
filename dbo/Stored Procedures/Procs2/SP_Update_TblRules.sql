
CREATE PROCEDURE [dbo].[SP_Update_TblRules](
@Rules_ID nvarchar(50),
@Rules_Disc nvarchar(3000),
@Provider_ID nvarchar(50),
@InsuranceCompanyID nvarchar(50),
@Provider_Group nvarchar(50),
@DomainId nvarchar(50),
@FilePath nvarchar(Max),
@FileName nvarchar(250),
@Category nvarchar(50),
@Insurance_Group int
)
as
begin

		update Tbl_Rules 
		set Rules_Disc=@Rules_Disc
		, Provider_ID=@Provider_ID
		, InsuranceCompanyID=@InsuranceCompanyID
		, Provider_Group=@Provider_Group
		, FilePath=@FilePath
		, FileName=@FileName
		, Category=@Category
		, Insurance_Group=@Insurance_Group
 where Rules_ID=@Rules_ID And DomainId = @DomainId
end

