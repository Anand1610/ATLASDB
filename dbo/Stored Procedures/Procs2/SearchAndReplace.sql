CREATE PROCEDURE [dbo].[SearchAndReplace]
(
	@SearchStr nvarchar(100),
	@ReplaceStr nvarchar(100)
)
AS
BEGIN

	-- Copyright 2005 Chetan A. Sharma. All rights reserved. http://www.khidki.com
	-- Purpose: To search all columns of all tables for a given search string and replace it with another string
	-- Date Created: Oct 23rd 2005
	-- Date Modified: Oct 23rd 2005

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110), @SQL nvarchar(4000), @RCTR int
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
	SET @RCTR = 0

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				SET @SQL=	'UPDATE ' + @TableName + 
						' SET ' + @ColumnName 
						+ ' =  REPLACE(' + @ColumnName + ', ' 
						+ QUOTENAME(@SearchStr, '''') + ', ' + QUOTENAME(@ReplaceStr, '''') + 
						') WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				EXEC (@SQL)
				SET @RCTR = @RCTR + @@ROWCOUNT
			END
		END	
	END

	SELECT 'Replaced ' + CAST(@RCTR AS varchar) + ' occurence(s)' AS 'Outcome'
END

