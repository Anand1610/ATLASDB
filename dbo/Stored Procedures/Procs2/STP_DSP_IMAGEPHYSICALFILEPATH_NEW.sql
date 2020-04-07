
create PROCEDURE  [dbo].[STP_DSP_IMAGEPHYSICALFILEPATH_NEW] --'24770'
@Images [Images]  READONLY,
@DomainId VARCHAR(10)
AS  
BEGIN 
SET NOCOUNT ON





	----------------------For Azure File
    SELECT  case  when T.ImageId >6 then  FILEPATH + FILENAME else convert(varchar(10),T.ImageId) end   as [InputFilePath],
	 case  when T.ImageId >6 then convert(varchar(10),I.BasePathId) else '' end [BasePathId]
	FROM  @Images T 
	Left JOIN tblDocImages I  ON T.ImageId=I.ImageID
	left Join tblBasePath B ON B.BasePathId=I.BasePathId
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    where  I.IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	

	


END

