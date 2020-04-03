CREATE PROCEDURE [dbo].[prcRfundSettlementUpdate]           
(          
@Case_Id varchar(200),          
@Settlement_Rfund_PR money,          
@Settlement_Rfund_Int money,          
@Settlement_Rfund_Total money,          
@Settlement_Rfund_UserId varchar(200),          
@Rfund_Deposite_Amount money,          
@Rfund_Deposite_Number varchar(500),          
@Provider_Id varchar(200),          
@Transactions_PR money,        
@Transactions_Int money         
        
)          
as          
 declare @Trans_SettledAmt_PR money,@Trans_SettledAmt_Int money, @Transactions_Amount money, @Transactions_Type varchar(2), @getdate datetime, @New_Provider_id varchar(10),@LastStatus varchar(100)  --@GetBatch int,        
begin          
 set @getdate=getdate()        
 set @New_Provider_id = (select provider_id from tblcase where case_id=@case_id)        
 set @LastStatus = (select Last_Status from tblCase where case_id=@Case_Id)      
 BEGIN          
  update tblSettlements set Settlement_Rfund_PR=@Settlement_Rfund_PR,           
  Settlement_Rfund_Int=@Settlement_Rfund_Int ,          
  Settlement_Rfund_Total=@Settlement_Rfund_Total,          
  Settlement_Rfund_date=@getdate,          
  Settlement_Rfund_UserId=@Settlement_Rfund_UserId           
  where case_id =@Case_Id        
 END      
 BEGIN     
		
	
				
         update t1 
		 set Status= case when t3.Status_Hierarchy >= t2.Status_Hierarchy  then 'RAPID FUNDED' else t1.Status end,
		 Last_Status=case when t3.Status_Hierarchy >= t2.Status_Hierarchy  then  @LastStatus else t1.Last_Status end
		 from tblCase t1
		 join tblStatus t2 on t1.Status=t2.Status_Type
		 join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type='RAPID FUNDED'      
         where case_id in (@Case_Id)      
 END
       
 BEGIN      
		 insert into tblNotes(Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_date,User_Id )      
         values ('Unconfirmed Rfund Deposit Amount '+convert(varchar(20),@Rfund_Deposite_Amount)+' Deposit Number '+@Rfund_Deposite_Number,'GENERAL','0',@Case_Id,getDate(),@Settlement_Rfund_UserId)  
		        
         insert into tblNotes(Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_date,User_Id )      
         values ('Status changed from '+@LastStatus+' to RAPID FUNDED','GENERAL','0',@Case_Id,getDate(),@Settlement_Rfund_UserId)         

 END          
 BEGIN          
 begin        
     if  @Transactions_PR >0        
     begin        
   set  @Trans_SettledAmt_PR=@Transactions_PR        
     end        
       if @Transactions_Int >0        
     begin        
   set @Trans_SettledAmt_Int=@Transactions_Int         
     end        
 end            
  begin           
  if @Settlement_Rfund_PR >0         
   begin         
       set @Transactions_Amount =@Settlement_Rfund_PR          
       set @Transactions_Type='C'         

   insert into tblTransactions        
    (          
    Rfund_Settled_Amount,          
    Transactions_Type,          
    Rfund_Deposite_Number,          
    Rfund_Deposite_Amount,          
    Transactions_Status,           
    Case_Id,          
    Transactions_Date,          
    Provider_Id,          
    Transactions_Amount,        
    [User_Id]           
    )          
    values           
    (          
    @Trans_SettledAmt_PR,        
    @Transactions_Type,          
    @Rfund_Deposite_Number,          
    @Rfund_Deposite_Amount,          
    'UNCONFIRMED',          
    @Case_Id,          
    @getdate,          
    @New_Provider_id,          
    @Transactions_Amount,            
    @Settlement_Rfund_UserId        
      )      
       end        
    if @Settlement_Rfund_Int >0          
   begin        
       set @Transactions_Amount =@Settlement_Rfund_Int          
       set @Transactions_Type='I'    
	         
   insert into tblTransactions        
    (          
    Rfund_Settled_Amount,          
    Transactions_Type,          
    Rfund_Deposite_Number,          
    Rfund_Deposite_Amount,          
    Transactions_Status,           
    Case_Id,          
    Transactions_Date,          
    Provider_Id,          
    Transactions_Amount,        
    [User_Id]           
    )          
    values           
    (          
    @Trans_SettledAmt_Int,        
    @Transactions_Type,          
    @Rfund_Deposite_Number,          
    @Rfund_Deposite_Amount,          
    'UNCONFIRMED',          
    @Case_Id,          
    @getdate,          
    @New_Provider_id,          
    @Transactions_Amount,            
    @Settlement_Rfund_UserId        
       )             
  end        
   end           
 END          
end

