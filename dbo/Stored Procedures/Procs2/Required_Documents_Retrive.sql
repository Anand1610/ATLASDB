
CREATE PROCEDURE [dbo].[Required_Documents_Retrive]
(
	@DomainID varchar(50),
	@s_a_Case_ID varchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    Select ID, [DomainID], [Case_ID], [DocumentType], CONVERT(VARCHAR(10), [ReminderDate], 101) as [ReminderDate]
	, isCompleted, Message, Complted_Date From Required_Documents
	WHERE DomainID = @DomainID
		-- AND ISNULL(isCompleted,0) = 0
		AND Case_ID = @s_a_Case_ID 
	ORDER BY ReminderDate
		--select *   From Required_Documents
END
