CREATE PROCEDURE [dbo].[batch_print_offline_fax_status_save] 
	@fk_batch_print_id			INT,
	@case_Id					NVARCHAR(100),
	@DomainID					VARCHAR(50),
	@fk_batch_entity_type_id	INT,
	@documentImageID			BIGINT,
	@faxStatus					VARCHAR(10),
	@faxStatusDate				DATETIME,	
	@ResendCount				INT
AS BEGIN
	DECLARE @pk_bp_ef_status_id	BIGINT

	IF NOT EXISTS(SELECT 1 FROM tbl_batch_print_offline_email_fax_status WHERE fk_batch_print_id = @fk_batch_print_id AND case_Id = @case_Id AND fk_batch_entity_type_id = @fk_batch_entity_type_id AND ISNULL(isDeleted,0) = 0)
	BEGIN
			INSERT INTO tbl_batch_print_offline_email_fax_status
			(
				fk_batch_print_id,		
				case_Id,
				DomainID,
				fk_batch_entity_type_id,
				documentImageID,
				faxStatus,
				faxStatusDate,				
				isDeleted,
				in_progress,
				ResendCount
			)
			VALUES
			(
				@fk_batch_print_id,
				@case_Id,
				@DomainID,
				@fk_batch_entity_type_id,
				CASE WHEN @documentImageID = -1 THEN NULL ELSE @documentImageID END,
				@faxStatus,
				@faxStatusDate,				
				0,
				0,
				@ResendCount
			)

			SET @pk_bp_ef_status_id = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
			UPDATE
				tbl_batch_print_offline_email_fax_status
			SET
				documentImageID			=	CASE WHEN @documentImageID = -1 THEN NULL ELSE @documentImageID END,
				faxStatus				=	@faxStatus,
				faxStatusDate			=	@faxStatusDate,
				ResendCount				=	@ResendCount
			WHERE
				fk_batch_print_id		=	@fk_batch_print_id AND
				case_Id					=	@case_Id AND
				fk_batch_entity_type_id	=	@fk_batch_entity_type_id AND
				ISNULL(isDeleted,0)		=	0

			SELECT TOP 1
				@pk_bp_ef_status_id		=	pk_bp_ef_status_id 
			FROM 
				tbl_batch_print_offline_email_fax_status 
			WHERE 
				fk_batch_print_id		=	@fk_batch_print_id AND 
				case_Id					=	@case_Id AND
				fk_batch_entity_type_id	=	@fk_batch_entity_type_id AND
				ISNULL(isDeleted,0)		=	0
	END	

	SELECT 
		@pk_bp_ef_status_id AS pk_bp_ef_status_id,
		'Inserted Successfully..!!' as Result
END
