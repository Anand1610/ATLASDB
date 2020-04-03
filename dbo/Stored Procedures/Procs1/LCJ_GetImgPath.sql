CREATE PROCEDURE [dbo].[LCJ_GetImgPath]
(  
	@DomainId NVARCHAR(50),
   @ImgID nvarchar(50)   
)  
as  
begin  
select imagepath from tblimages  where imageId=@ImgID and DomainId=@DomainId
end

