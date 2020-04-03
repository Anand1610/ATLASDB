

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_UserActivity] -- [dbo].[Report_UserActivity] 'localhost','08/17/2018','08/17/2018',''
	-- Add the parameters for the stored procedure here
	@domainId				   nvarchar(50),
	@s_a_date_FROM	VARCHAR(20)=''	,
	@s_a_date_To	VARCHAR(20)='',
	@s_a_UserID varchar(30)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT distinct
		cas.Case_Id,		  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') AS Provider_Name,  
		ins.InsuranceCompany_Name, 	
		notes.Notes_Desc,
		notes.User_Id,
		notes.Notes_Date
	FROM tblCase cas  WITH (NOLOCK)
	INNER JOIN tblprovider pro  WITH (NOLOCK) on cas.provider_id=pro.provider_id
	INNER JOIN tblinsurancecompany ins  WITH (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
	INNER JOIN tblNotes notes WITH (NOLOCK) on cas.Case_Id = notes.Case_Id
	WHERE
		cas.domainId = @domainId
		AND (@s_a_UserID = '' OR notes.User_ID = @s_a_UserID )
		AND (@s_a_date_FROM='' OR (notes.Notes_Date Between CONVERT(datetime,@s_a_date_FROM) And CONVERT(datetime,@s_a_date_To) + 1))		
	ORDER BY User_Id,Notes_Date	desc
	-- select * from tblnotes where DomainID = 'GLF' and User_Id not like 'ls-%' order by notes_id desc 
END
