CREATE PROCEDURE [dbo].[SP_SAVE_PDF]--[SP_SAVE_PDF] 'ZDP-MDM-ROS-0725','Test.pdf','IMG-72919'
@p_szCaseID nvarchar(50),
@p_szFileName nvarchar(255),
@img_id nvarchar(200)

AS
declare @szCaseID nvarchar(50)
declare @iImageID int
declare @iNodeID int
declare @iDocCount int
BEGIN
	-- set @szCaseId = (select SUBSTRING ( @p_szCaseID , charindex('-',@p_szCaseID,0)+1,len(@p_szCaseID)))	
	declare @imageid nvarchar(500)
	declare @filepath nvarchar(500)

	select @imageid =Substring(@img_id,Charindex('-',@img_id)+1,len(@img_id))
	set @filepath =  (select filepath from tbldocimages where imageid= @imageid and filepath like '%' +@p_szCaseID+ '%'
						 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
						 AND IsDeleted=0  
						---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
					 )

	set @szCaseId = @p_szCaseID
	set @iDocCount = (select count(imageid) from tbldocimages where lower([filename]) = lower(@p_szFileName) and lower(filepath) = @filepath
	 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
   AND IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
	)

	if(@iDocCount=0) 
	begin
		insert into tbldocimages([filename],filepath,ocrdata,[status])
		values(@p_szFileName,@filepath,'',1)

		declare @nodename nvarchar(500)
		select @nodename =Substring(@filepath,Charindex('/',@filepath)+1,len(@filepath))
		print @nodename
		select @nodename =Substring(LEFT(@nodename, LEN(@nodename)-1),Charindex('/',LEFT(@nodename, LEN(@nodename)-1))+1,len(LEFT(@nodename, LEN(@nodename)-1)))
		print @nodename
		set @iImageID = (select isnull(max(imageid),1) from tbldocimages)
		set @iNodeID = (select nodeid from tbltags where caseid = @szCaseId and NodeName = @nodename) 
		print @iNodeID
		insert into tblimagetag(imageid,tagid,loginid,dateinserted,datemodified)
		values(@iImageID,@iNodeID,null,default,null)
	end
END

