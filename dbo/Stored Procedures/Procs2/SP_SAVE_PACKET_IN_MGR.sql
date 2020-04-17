CREATE PROCEDURE  [dbo].[SP_SAVE_PACKET_IN_MGR]  
@p_szCaseID nvarchar(50),  
@p_szFileName nvarchar(255)  
AS  
declare @szCaseID nvarchar(50)  
declare @iImageID int  
declare @iNodeID int  
declare @iDocCount int  
BEGIN  
 -- set @szCaseId = (select SUBSTRING ( @p_szCaseID , charindex('-',@p_szCaseID,0)+1,len(@p_szCaseID)))   
 set @szCaseId = @p_szCaseID  
 set @iDocCount = (select count(imageid) from tbldocimages where lower([filename]) = lower(@p_szFileName)  
 and lower(filepath) = lower(@szCaseId + '/packet exhibits/')
    ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  AND IsDeleted=0   
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
 )  
  
 if(@iDocCount=0)   
 begin  
  insert into tbldocimages([filename],filepath,ocrdata,[status])  
  values(@p_szFileName,@szCaseId + '/packet exhibits/','',1)  
  
  set @iImageID = (select isnull(max(imageid),1) from tbldocimages)  
  set @iNodeID = (select TOP 1 nodeid from tbltags where caseid = @szCaseId and nodetype = 'SVDPAK')  
  
  insert into tblimagetag(imageid,tagid,loginid,dateinserted,datemodified)  
  values(@iImageID,@iNodeID,null,default,null)  
 end  
END

