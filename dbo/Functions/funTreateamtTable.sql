CREATE FUNCTION [dbo].[funTreateamtTable](@Case_id varchar(50))  
RETURNS VARCHAR(max)  
AS  
BEGIN  
 DECLARE @s_l_treatment_table      VARCHAR(max)  
 
 set  @s_l_treatment_table = '<table border=1 class=''statuscell''><tr><td>Amount of Each Bill</td><td>Amount Paid</td><td>Amount in Dispute</td><td>Dates of Service</td></tr>'
 DECLARE @Claim_amount VARCHAR(100)
 DECLARE @Paid_amount VARCHAR(100)
 Declare @Balance varchar(100)
 Declare @Dos varchar(200)
 DECLARE CUR_Notes CURSOR
 FOR select Claim_amount,Paid_amount,(claim_amount - paid_amount) as balance, 
	Convert(Varchar(10),DateOfService_Start,101)+ ' - ' + Convert(Varchar(10),DateOfService_End,101) 
	from tbltreatment where case_id=@Case_id 
 
 OPEN CUR_Notes
 FETCH CUR_Notes INTO @Claim_amount,@Paid_amount,@Balance,@Dos
 WHILE @@FETCH_STATUS = 0
 BEGIN
   
		 set @s_l_treatment_table = @s_l_treatment_table +'<tr><td class=''statuscell''> $'
												 + @Claim_amount +'</td><td class=''statuscell''> $'
												 + @Paid_amount +'</td><td class=''statuscell''> $'
												 + @Balance +'</td><td class=''statuscell''>'
												 + @Dos +'</td></tr>'

	
   
   FETCH CUR_Notes INTO @Claim_amount,@Paid_amount,@Balance,@Dos
  END
  CLOSE CUR_Notes
 DEALLOCATE CUR_Notes
 
 
return @s_l_treatment_table + '</table>'
END
