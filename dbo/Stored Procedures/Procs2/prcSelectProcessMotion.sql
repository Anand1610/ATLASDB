CREATE PROCEDURE [dbo].[prcSelectProcessMotion]  
(            
@Case_Id varchar(4000),            
@Process_SQlFields varchar(4000),            
@Process_Id varchar(5),      
@Process_SQl varchar(4000)      
)            
as            
declare @case varchar(4000)            
declare @st nvarchar(4000)   
declare @null varchar(4000)   
begin     
        
        set @null=''  
        set @case=''''+replace(@Case_Id,',',''',''')+''''  
 if @Process_SQLFields='0'  
 begin  
  set @Process_SQLFields='''NODATA'''  
 end   
  
 set @st=' select a.case_id [Case_Id],CASE process_id WHEN '+@Process_Id+' THEN case printed when 1 then ''YES'' else ''NO'' END ELSE  ''NO'' END AS ''Printed'','+@Process_SQlFields+' from LCJ_VW_Casesearchdetails a left outer join tblPrintjobs b '  
 set @st=@st+' on a.case_id=b.case_id'  
 if @Process_SQl<>'0'  
  begin  
   set @st= @st + ' where '+@Process_SQl +' and a.case_id in ('+@case+')'  
  end  
 else  
   set @st= @st + ' where a.case_id in ('+@case+')'  
           
 execute sp_executesql @st   
 end

