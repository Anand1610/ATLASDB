create procedure checkimage
@imageid int
as
begin
SELECT
 COUNT(*) FROM tbldocimages (nolock)
 where imageid=@imageid 
 end

