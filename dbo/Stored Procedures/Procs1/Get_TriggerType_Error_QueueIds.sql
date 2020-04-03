CREATE PROCEDURE Get_TriggerType_Error_QueueIds 
	@s_a_DomainId varchar(250),
	@i_a_QueueType int
AS
BEGIN
	
	SET NOCOUNT ON;
	IF @i_a_QueueType = 2 OR @i_a_QueueType = 4
		BEGIN
			Select 0 AS Id, '--Select Queue Id--' AS Type
			Union
			Select distinct QueueSourceId AS Id, Convert(Varchar(50), QueueSourceId) AS Type From tblTriggerTypeErrorLog TE
			INNER JOIN tbl_batch_print_offline_queue Q ON Q.pk_batch_print_Id = TE.QueueSourceId AND ISNULL(TE.QueueType,0) = 2
			LEFT JOIN tbl_batch_type BT ON Q.fk_batch_type_id = BT.ID
			Where TE.DomainId = @s_a_DomainId and ISNULL(IsResolved,0) = 0 AND
			((ISNULL(@i_a_QueueType,0) = 0 or TE.QueueType = @i_a_QueueType and lower(BT.Name)!='email') or (ISNULL(@i_a_QueueType,0) = 4 AND lower(BT.Name)='email'))
		END
	ELSE
		BEGIN
			Select 0 AS Id, '--Select Queue Id--' AS Type
			Union
			Select distinct QueueSourceId AS Id, Convert(Varchar(50), QueueSourceId) AS Type From tblTriggerTypeErrorLog 
			Where DomainId = @s_a_DomainId and QueueType = @i_a_QueueType and ISNULL(IsResolved,0) = 0
		END
END
