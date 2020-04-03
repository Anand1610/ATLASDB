-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[F_Case_Activity_Retrive]
(
	@s_a_CaseId VARCHAR(100),
	@s_a_activity_category VARCHAR(100)
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT ON;
   IF(@s_a_activity_category ='')
   BEGIN
   
		SELECT 
			case_id,
			pk_case_activity_id,
			activity_category,
               CONVERT(VARCHAR,activity_date,101) AS activity_date,
               Created_date AS Created_date,
               CONVERT(VARCHAR,followup_date,101) AS followup_date,
               description,                             
               activity_category,               
               completed_notes,
			--SUBSTRING(ISNULL(STUFF(
			--	(
			--		SELECT COALESCE(CAST(fk_group_id AS VARCHAR(MAX))+',',' - ') FROM tbl_case_activity_group_mapping WHERE fk_case_activity_id = pk_case_activity_id
			--		for xml path('')
			--	),1,0,''),','),1,(LEN(ISNULL(STUFF(
			--	(
			--		SELECT COALESCE(CAST(fk_group_id AS VARCHAR(MAX))+',',' - ') FROM tbl_case_activity_group_mapping WHERE fk_case_activity_id = pk_case_activity_id
			--		for xml path('')
			--	),1,0,''),',')))-1) AS group_ids,
			--	SUBSTRING(ISNULL(STUFF(
			--	(
			--		SELECT COALESCE(CAST(fk_user_id AS VARCHAR(MAX))+',',' - ') FROM tbl_case_activity_user_mapping WHERE fk_case_activity_id = pk_case_activity_id
			--		for xml path('')
			--	),1,0,''),','),1,(LEN(ISNULL(STUFF(
			--	(
			--		SELECT COALESCE(CAST(fk_user_id AS VARCHAR(MAX))+',',' - ') FROM tbl_case_activity_user_mapping WHERE fk_case_activity_id = pk_case_activity_id
			--		for xml path('')
			--	),1,0,''),',')))-1) AS user_ids,
				CASE WHEN ISNULL(is_email,0) = 0 THEN 'No' ELSE 'Yes' END is_email,
				CASE WHEN ISNULL(is_email,0) = 0 THEN '' 
				ELSE
				'Groups : ['+ISNULL(SUBSTRING(ISNULL(STUFF(
				(
					SELECT COALESCE(CAST(group_name AS VARCHAR(MAX))+',',' - ') FROM tbl_group WHERE pk_group_id IN (SELECT fk_group_id FROM tbl_case_activity_group_mapping WHERE fk_case_activity_id = pk_case_activity_id)
					for xml path('')
				),1,0,''),','),1,(LEN(ISNULL(STUFF(
				(
					SELECT COALESCE(CAST(group_name AS VARCHAR(MAX))+',',' - ') FROM tbl_group WHERE pk_group_id IN (SELECT fk_group_id FROM tbl_case_activity_group_mapping WHERE fk_case_activity_id = pk_case_activity_id)
					for xml path('')
				),1,0,''),',')))-1),'')+'] / Users : ['+
				ISNULL(SUBSTRING(ISNULL(STUFF(
				(
					SELECT COALESCE(CAST(last_name +', '+first_name AS VARCHAR(MAX))+' | ',' - ') FROM IssueTracker_Users WHERE UserID IN (SELECT fk_user_id FROM tbl_case_activity_user_mapping WHERE fk_case_activity_id = pk_case_activity_id)
					for xml path('')
				),1,0,''),','),1,(LEN(ISNULL(STUFF(
				(
					SELECT COALESCE(CAST(last_name +', '+first_name AS VARCHAR(MAX))+' | ',' - ') FROM IssueTracker_Users WHERE UserID IN (SELECT fk_user_id FROM tbl_case_activity_user_mapping WHERE fk_case_activity_id = pk_case_activity_id)
					for xml path('')
				),1,0,''),',')))-1),'')+'] ' END AS user_list,
				usr_created.username AS created_by
				
			FROM
				tbl_case_activity CA							
				LEFT JOIN IssueTracker_Users usr_created	ON usr_created.UserId = CA.Created_User_ID
			WHERE							
				CA.case_id		=	@s_a_CaseId 
			ORDER 
			BY	pk_case_activity_id desc
   END
   ELSE
   BEGIN
	   SELECT pk_case_activity_id,Description, Created_User_ID, Convert(NVARCHAR(15), Created_date, 101) AS Created_date, activity_category  
	   FROM	tbl_case_activity 
	   WHERE	Case_Id = @s_a_CaseId AND activity_category = @s_a_activity_category
   END	     

   
END

