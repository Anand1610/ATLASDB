CREATE FUNCTION [dbo].[funTreateamtTable_RTF](@Case_id varchar(50))  
RETURNS VARCHAR(max)  
AS  
BEGIN  
 DECLARE @s_l_treatment_table      VARCHAR(max)
 DECLARE @s_l_Provider_Name Varchar(500)  
 
 SET @s_l_Provider_Name =(Select TOP 1 PROVIDER_NAME from LCJ_VW_CaseSearchDetails_RTF WHERE CASE_ID = @Case_id)
 
 set  @s_l_treatment_table = '{\rtf1\deff0{\fonttbl{\f0 arial;}}\fs20\trowd
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx1500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx2500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx3500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx4500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx6500
\intbl\b Provider \b0\cell
\intbl\b Amount of Each Bill \b0\cell
\intbl\b Amount Paid \b0\cell  
\intbl \b Amount in Dispute \b0\cell 
\intbl \b Date(s) Of Services \b0\cell 
\row'



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
   
		 set @s_l_treatment_table = @s_l_treatment_table  
		 +
		 '\rtf1\deff0{\fonttbl {\f0 arial;}}\fs20\trowd
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx1500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx2500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx3500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx4500
\clbrdrt\brdrs\clbrdrl\brdrs\clbrdrb\brdrs\clbrdrr\brdrs\cellx6500'
		 +
								+ '\intbl  '+ @s_l_Provider_Name +' \cell '
								+ '\intbl  '+ @Claim_amount +' \cell '
								+ '\intbl  '+ @Paid_amount +' \cell '
								+ '\intbl  '+ @Balance +' \cell '
								+ '\intbl  '+ @Dos +' \cell\row}'
	
   
   FETCH CUR_Notes INTO @Claim_amount,@Paid_amount,@Balance,@Dos
  END
  CLOSE CUR_Notes
 DEALLOCATE CUR_Notes
 
 
return @s_l_treatment_table + '  \pard'
END
