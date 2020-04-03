CREATE PROCEDURE [dbo].[F_ZipList_Retrieve]
(
	@s_a_Value NVARCHAR(255)
)
 AS
	BEGIN
		SELECT City,ST FROM ZipList WHERE ZipCode=@s_a_Value
	END

