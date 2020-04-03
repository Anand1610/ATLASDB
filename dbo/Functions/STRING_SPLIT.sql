CREATE FUNCTION [dbo].[STRING_SPLIT](@String varchar(8000), @Delimiter char(1))        
returns @temptable TABLE (autoid int,items varchar(8000))        
as        
begin        
	declare @iTerate INT = 0
    declare @idx int        
    declare @slice varchar(8000)        
       
    select @idx = 1        
        if len(@String)<1 or @String is null  return        
       
    while @idx!= 0        
    begin        
        set @idx = charindex(@Delimiter,@String)        
        if @idx!=0        
            set @slice = left(@String,@idx - 1)        
        else        
            set @slice = @String        
           
        if(len(@slice)>0)   
            insert into @temptable(autoid,Items) values(@iTerate,@slice)
  
        set @String = right(@String,len(@String) - @idx)        
        if len(@String) = 0 break        
        SET @iTerate = @iTerate + 1
    end    
return        
end
