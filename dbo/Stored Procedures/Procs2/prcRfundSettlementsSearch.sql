CREATE PROCEDURE [dbo].[prcRfundSettlementsSearch]  
(  
@StartDate varchar(200),  
@EndDate varchar(200),  
@Provider nvarchar(200),  
@RfundBatchNumber varchar(50),  
@Trans_Ref_Number varchar(200),  
@FundingDate varchar(200)  
)  
as  
declare @st nvarchar(4000)  
declare @stpro nvarchar(2000)  
BEGIN  
  
set @stpro =  replace(@Provider,',',''',''')  
  
 set @st= 'select t.Case_Id, Provider_Name, InjuredParty_Name, Ins_Claim_Number, '  
 set @st=@st + 'Claim_Amount, Settlement_Date, Settlement_Amount, Settlement_Int, '  
 set @st=@st + 'Settlement_Total, Settlement_Rfund_PR, Settlement_Rfund_Int, Settlement_Rfund_Total, '  
 set @st=@st + 'Settlement_Rfund_date, Settlement_Rfund_Batch, Transactions_Status, '  
 set @st=@st + ' Rfund_Deposite_Number from LCJ_VW_caseSearchdetails t left outer join tblTransactions a '  
 set @st=@st + ' on t.Case_id=a.Case_id where rfund_batch > 0 '  
  
 if @RfundBatchNumber<>'0'  
  begin  
   set @st=@st+ 'and a.rfund_Batch='+ @RfundBatchNumber  
  end  
 if @Provider <> '0'  
  begin  
   set @st=@st + 'and t.Provider_Id in ('''+ @stpro +''')'  
  end  
 if @StartDate <> '0' or @EndDate <> '0'  
  begin  
   set @st=@st + 'and Settlement_Date between '''+@StartDate+''' and '''+ @EndDate +''''  
  end  
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
 if @Trans_Ref_Number<> '0'  
  begin  
   set @st=@st + 'and Rfund_Deposite_Number in (''' +@Trans_Ref_Number  + ''')'  
  end  
 if @FundingDate<>'0'  
  begin  
   set @st=@st + 'and Settlement_Rfund_date = '''+@FundingDate+''''  
  end  
  
 set @st=@st + 'and settlement_id IS NOT NULL'  
--and ( Transactions_Status=''CONFIRMED'' OR Transactions_Status=''UNCONFIRMED''  
  
--execute sp_executesql @st  
exec (@st)  
--print @st  
END

