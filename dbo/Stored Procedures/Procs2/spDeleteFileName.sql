CREATE PROCEDURE [dbo].[spDeleteFileName](  
@getFName varchar(100)  
) as  
begin  
    declare   
 --@getFName varchar(100),  
 @st nvarchar(200)  
 --set @getFName='9-30-2003-5-38-50-PM-0.6991308_1.tif'  
        set @st = 'UPDATE tblimages  set deleteflag=1 where filename = '''+@getFName+''''  
 execute sp_executesql @st  
 --print @st  
end

