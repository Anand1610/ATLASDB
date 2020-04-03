﻿CREATE PROCEDURE [dbo].[GETPROVIDERS_STATUSAGE] --'40552','0'
	@SZ_PROVIDER_ID NVARCHAR(50),
	@PROVIDER_GROUP VARCHAR(10)
AS
BEGIN
IF @PROVIDER_GROUP <> '0'
BEGIN
	SELECT
		STATUS,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID IN
				(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
					(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) BETWEEN 0 AND 90
				AND STATUS=TC.STATUS
		) AS COUNT_0TO90,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID IN
				(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
					(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) BETWEEN 90 AND 180
				AND STATUS=TC.STATUS
		) AS COUNT_90TO180,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID IN
				(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
					(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) > 180
				AND STATUS=TC.STATUS
		) AS COUNT_180PLUS
	FROM
		TBLCASE TC
	WHERE
		PROVIDER_ID IN
		(SELECT PROVIDER_ID FROM TBLPROVIDER WHERE PROVIDER_GROUPNAME IN
			(SELECT PROVIDER_GROUPNAME FROM TBLPROVIDER WHERE PROVIDER_ID = @SZ_PROVIDER_ID))
	GROUP BY STATUS
	ORDER BY STATUS
END
ELSE
BEGIN
	SELECT
		STATUS,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID = @SZ_PROVIDER_ID
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) BETWEEN 0 AND 90
				AND STATUS=TC.STATUS
		) AS COUNT_0TO90,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID = @SZ_PROVIDER_ID
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) BETWEEN 90 AND 180
				AND STATUS=TC.STATUS
		) AS COUNT_90TO180,
		(SELECT COUNT(*) FROM TBLCASE 
			WHERE
				PROVIDER_ID = @SZ_PROVIDER_ID
				AND
				DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) > 180
				AND STATUS=TC.STATUS
		) AS COUNT_180PLUS
	FROM
		TBLCASE TC
	WHERE
		PROVIDER_ID = @SZ_PROVIDER_ID
	GROUP BY STATUS
	ORDER BY STATUS
END
END

