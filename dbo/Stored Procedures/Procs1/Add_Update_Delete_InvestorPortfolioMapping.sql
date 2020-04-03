CREATE PROCEDURE [dbo].[Add_Update_Delete_InvestorPortfolioMapping]                  
(            
@Id int =0,            
@InvestorId int =0,            
@PortfolioId int =0,            
@InvestmentAmount int =0,            
@DomainId varchar(50),              
@Action varchar(10)              
 )               
AS                  
BEGIN         
        
 DECLARE @fundingAmt numeric(18,2)        
        
 SELECT             
              @fundingAmt = sum( (tpr.Advance_Rate*(CASE WHEN tsl.Settlement_Amount IS NULL       
              THEN(CASE WHEN tc.Claim_Amount is null THEN 0           
                                                        WHEN     tc.Claim_Amount =''       
              THEN 0           
              ELSE   CONVERT(NUMERIC(18,2),tc.Claim_Amount)           
                                                     END)          
                    WHEN  tsl.Settlement_Amount =''       
                          THEN   (CASE WHEN tc.Claim_Amount is null THEN 0           
                                       WHEN tc.Claim_Amount ='' THEN 0           
                                       ELSE   CONVERT(NUMERIC(18,2),tc.Claim_Amount)           
                                  END)          
                    ELSE  CONVERT(NUMERIC(18,2),tsl.Settlement_Amount) END))/100 )           
              
FROM            tblcase tc             
              
JOIN   tbl_Portfolio tpf ON tc.PortfolioId =tpf.Id            
JOIN   tbl_Program  tpr ON tpf.ProgramId = tpr.Id            
LEFT JOIN  tblSettlements tsl ON tc.Case_Id=tsl.Case_Id            
            
WHERE   tc.[DomainId] =@DomainId  AND tpf.Id=@PortfolioId         
    
      
               
if( @Action ='Insert')              
 Begin          
         
             
 insert into  [dbo].[tbl_InvestorPortfolio](InvestorId,            
                                    PortfolioId,            
            InvestmentAmount,            
            InvestmentPercentage,            
            DomainId)             
values     (@InvestorId,            
            @PortfolioId,            
            @InvestmentAmount,            
            CASE WHEN (@fundingAmt=0 OR @fundingAmt IS NULL OR @InvestmentAmount=0 ) THEN  0    
     ELSE (ISNULL(@InvestmentAmount,0)/ISNULL(@fundingAmt,0))*100    
   END,            
            @DomainId            
            )              
             
 end               
 if(@Action ='Delete')              
  Begin              
   Delete from [dbo].[tbl_InvestorPortfolio] where Id = @Id and DomainId =@DomainId                
 end               
              
 if(@Action ='Select')              
  BEGIN              
   SELECT       u.UserId,            
    i.InvestorId,            
      i.Name,            
    i.Email,            
    i.ContactNo,                 
      u.UserRole,            
    u.UserName,            
    u.UserPassword,            
    u.IsActive,            
    i.Address,            
    i.Country,            
    i.State,            
    i.City,            
    i.Zip,        
    u.RoleId            
            
            
            
                    
   FROM        IssueTracker_Users u             
   JOIN        tbl_Investor i            
   ON          u.UserId = i.UserId            
   WHERE       u.DomainId=@DomainId            
   AND         i.DomainId=@DomainId         
   AND         u.IsActive=1           
                     
END               
              
 if(@Action ='Update')              
  Begin              
   Update  [dbo].[tbl_InvestorPortfolio]     
   set   InvestmentAmount=        @InvestmentAmount,    
    InvestmentPercentage=     CASE WHEN (@fundingAmt=0 OR @fundingAmt IS NULL OR @InvestmentAmount=0) THEN  0     
              ELSE (ISNULL(@InvestmentAmount,0)/ISNULL(@fundingAmt,0))*100      
            END    
    
   where        DomainId = @DomainId and Id=@Id            
                
 end               
              
END
