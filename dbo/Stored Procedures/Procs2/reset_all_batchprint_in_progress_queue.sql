CREATE PROCEDURE [dbo].[reset_all_batchprint_in_progress_queue]
AS
BEGIN	
	UPDATE
		tbl_batch_print_offline_queue
	SET
		in_progress				=	0
	WHERE
		ISNULL(in_progress,0)	=	1
END

