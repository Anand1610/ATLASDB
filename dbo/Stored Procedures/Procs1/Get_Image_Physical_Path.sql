-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Image_Physical_Path]
    @i_a_imageId AS INT
AS
SET NOCOUNT ON

DECLARE @BASEFOLDER AS NVARCHAR(255)

BEGIN

	SELECT @BASEFOLDER=PhysicalBasePath FROM [tblBasePath] Where BasePathId = (Select BasePathId from TBLDOCIMAGES Where ImageId=@i_a_imageId
	
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted =0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	)

	SELECT (@BASEFOLDER+FILEPATH + FILENAME) As ImagePath FROM TBLDOCIMAGES WHERE IMAGEID=@i_a_imageId
	---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    AND IsDeleted =0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
	--print(@FILEPATH)

END
