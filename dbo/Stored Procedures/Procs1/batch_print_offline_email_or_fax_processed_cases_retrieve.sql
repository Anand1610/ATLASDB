CREATE PROCEDURE [dbo].[batch_print_offline_email_or_fax_processed_cases_retrieve] 
	@fk_batch_print_id	INT,
	@DomainID			VARCHAR(50)
AS BEGIN
	DECLARE @s_l_caseIds VARCHAR(MAX)=''
	Select @s_l_caseIds = COALESCE(@s_l_caseIds + ',',' ') + LTRIM(RTRIM(case_Id)) FROM tbl_batch_print_offline_email_fax_status WHERE fk_batch_print_id = @fk_batch_print_id AND DomainID = @DomainID AND ISNULL(isDeleted,0) = 0

	select @s_l_caseIds AS case_ids
END
