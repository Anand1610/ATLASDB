-- =============================================
-- Author:		Serge Rosenthal
-- ALTER date: 03/30/2009
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FHA_DDL_ReviewingDoctor_All]
		
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT '...SELECT...'  as Doctor_Name, '0' Doctor_id
	UNION
	SELECT     Doctor_Name, Doctor_id
	FROM         TblReviewingDoctor WHERE  Doctor_Name <>'' and Doctor_Name not like '%select%'
	ORDER BY Doctor_name
END

