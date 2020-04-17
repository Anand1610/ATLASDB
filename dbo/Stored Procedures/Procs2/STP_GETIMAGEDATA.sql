CREATE PROCEDURE [dbo].[STP_GETIMAGEDATA]
@IMAGEID INT

AS

SELECT * FROM tblDocImages WHERE IMAGEID=@IMAGEID
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
AND IsDeleted=0		
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude

