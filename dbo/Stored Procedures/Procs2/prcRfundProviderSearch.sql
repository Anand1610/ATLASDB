CREATE PROCEDURE [dbo].[prcRfundProviderSearch]       
(                                                                                                                                                                                                                                                              
 @StartDate varchar(200),   
 @EndDate varchar(200),   
 @Provider nvarchar(200),                                                                                                                                                                                                                                 
 @InsuranceCompany nvarchar(200)                                                                                                                                                                                                                       
 )                                                                                                                                                                                                                                                  
                               
 as                                                                                                                                                                                                                                              
                                  
  declare @st nvarchar(2000)                                                                                                                                                                                                                   
                                     
  declare @stpro nvarchar(2000)                                                                                                                                                                                                             
                                        
  declare @stins nvarchar(2000)                                                                                                                                                                                                          
                                           
                                                                                                                                                                                                                                     
                                              
  set @stpro =  replace(@Provider,',',''',''')                                                                                                                                                                                     
                                                 
  set @stins =  replace(@InsuranceCompany,',',''',''')                           
                                             
                                                                                                                                                                                                                               
 begin                                    
                                                                                                                                                                                                                                         
   set @st='select Case_Id, Provider_Id, status, Provider_Name, InjuredParty_Name, InsuranceCompany_Name, Ins_Claim_Number, Claim_Amount, Settlement_Amount, Settlement_Int, '          
   set @st=@st + '((Settlement_Amount-(Settlement_Amount* isnull(Provider_Billing,0))*0.01) + (Settlement_Int-(Settlement_Int* isnull(Provider_IntBilling,0) )*0.01)) as [Total],(Settlement_Amount-(Settlement_Amount* isnull(Provider_Billing,0))*0.01) as [SettledAmtLessAF], (Settlement_Int-(Settlement_Int* isnull(Provider_IntBilling,0))*0.01) as [InterestAmttLessAF], Settlement_Date,'                                                                                                                                                                     
  
   set @st=@st + '((Settlement_Amount-(Settlement_Amount* isnull(Provider_Billing,0))*0.01) * .92)as [Rfund PR], '                                                                                                                                                       
  
   set @st=@st + '((Settlement_Int-(Settlement_Int* isnull(Provider_IntBilling,0))*0.01) * .92) as [Rfund Int], '                                                                                                                                                        
  
   set @st=@st + '(((Settlement_Amount-(Settlement_Amount* isnull(Provider_Billing,0))*0.01)  + (Settlement_Int-(Settlement_Int* isnull(Provider_IntBilling,0)) *0.01)) * .92) as [Rfund Total]'                                                                                   
  
   set @st=@st + ' from '                                                                                                                                                                                                                                      
  
   set @st=@st + 'LCJ_VW_Casesearchdetails T where Provider_Rfunds=1'                                                                                                                                                                                          
  
   if @Provider <> '0'                                                                                                                                                                                                                                         
  
          begin                                                                                                                                                                                                                                                
  
       set @st=@st + ' and Provider_Id in ('''+ @stpro +''')'                                                                                                                                                                                                  
  
      end                                                                                                                                                                                                                                                      
  
   if @InsuranceCompany <>'0'                                                                                                                                                                                                                                  
    begin              
     set @st=@st + ' and InsuranceCompany_Id in ('''+ @stins +''') '                                                                                     
    end                                                                                                                                                                                                                                               
    if @StartDate <> '0' or  @EndDate <> '0'                                                                                                                                                                                                        
    begin                                                                                                                                                                                                                                       
  set @st=@st + ' and Settlement_Date between '''+@StartDate+''' and ''' +@EndDate +''''                                                                                                                                                  
    end                                                                                                                           
    else                                                                                                                                                                                                                                
    if @StartDate = '0' and @EndDate = '0'                                                                                                                                                                                           
    begin                                                                                                                                                                                                                         
     if @StartDate <> '0'                                                                                                                                                                                                      
         begin                                                                                                                                                                                                                 
                set @st=@st + ' and Settlement_Date = '''+@StartDate+''''                                                                                                                                                         
                end                                                                                                                                                                                                                                           
   
 if @EndDate <> '0'                                                                 
         begin                                                                          
                set @st=@st + ' and Settlement_Date = ''' +@EndDate +''''                  
                end                                                                      
    end                                                                                                                                                                                                                                                        
  
    set @st = @st +' and status not like ''%RAPID FUNDED%'' and status not like ''%CLOSED%'' and settlement_id is not NULL and 0 = (select count(Transactions_Id) from tbltransactions where case_id=T.case_id and transactions_type in (''C'',''I''))'        
  
 exec ( @st)            
 end

