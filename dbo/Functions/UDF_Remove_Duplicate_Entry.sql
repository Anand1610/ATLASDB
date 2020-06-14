CREATE Function [dbo].[UDF_Remove_Duplicate_Entry]    
(    
      @Duplicate_String VARCHAR(MAX),    
      @delimiter VARCHAR(2)    
)    
RETURNS VARCHAR(MAX)    
BEGIN    
     --DECLARE @Xml XML    
     DECLARE @Removed_Duplicate_String VARCHAR(Max)    
     --SET @Duplicate_String=REPLACE(@Duplicate_String,'&','And')    
     --SET @delimiter=REPLACE(@delimiter,'&','And')    
    
     --SET @Xml = CAST(('<A>'+REPLACE(@Duplicate_String,@delimiter,'</A><A>')+'</A>') AS XML)    
     
     --;WITH CTE AS (SELECT A.value('.', 'varchar(max)') AS [Column]    
     -- FROM @Xml.nodes('A') AS FN(A))    
     
     -- SELECT @Removed_Duplicate_String =Stuff((SELECT '' + @delimiter + '' + [Column]  FROM CTE     
     -- FOR XML PATH('') ),1,1,'')    
    
     -- SET @Removed_Duplicate_String=REPLACE(@Removed_Duplicate_String,'And','&')      
  
  declare @stringvalues table  
  (  
   rownumber int ,  
   stringvalues varchar(400)  
  
  )  
  
  ;with cte as(  
  
    
  select top 1000 row_number() over(partition by s order by zeroBasedOccurance) as rownum, s from SplitString(@Duplicate_String, @delimiter) 
  order by zeroBasedOccurance
  )  
  
  insert into @stringvalues(rownumber, stringvalues)  
  
  select rownum,s from cte  where rownum=1
  order by rownum  
  
  SET  @Removed_Duplicate_String = (SELECT  STUFF((  
  
   select   ','+ stringvalues from @stringvalues  
      
      
  
     FOR XML PATH('')), 1, 1, ''))  
  
  
RETURN (@Removed_Duplicate_String)    
END 
GO


