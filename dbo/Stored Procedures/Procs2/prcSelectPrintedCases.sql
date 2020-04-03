CREATE PROCEDURE [dbo].[prcSelectPrintedCases]    
(              
--@Case_Id varchar(4000),              
@Process_SQlFields varchar(4000),              
@Process_Id varchar(5),        
@Process_SQl varchar(4000)        
)              
as              
--declare @case varchar(4000)              
declare @st nvarchar(4000)     
declare @null varchar(4000)     
begin       
          
        set @null=''    
 --       set @case=''''+replace(@Case_Id,',',''',''')+''''    
 if @Process_SQLFields='0'    
 begin    
  set @Process_SQLFields='''NODATA'''    
 end     
    
 set @st=' select a.case_id [Case_Id],case printed when 1 then ''YES'' else ''NO'' END AS ''Printed'','+@Process_SQlFields+' from LCJ_VW_Casesearchdetails a join tblPrintjobs b '    
 set @st=@st+' on a.case_id=b.case_id where '    
 if @Process_SQl<>'0'    
  begin    
   set @st= @st + @Process_SQl + 'and b.process_id='+@Process_Id  
  end    
 else    
   set @st= @st + ' b.process_id='+@Process_Id    
             
 execute sp_executesql @st     
 end

