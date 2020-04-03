--sp_helptext sp_billing_report_DK_new

CREATE proc sp_billing_report_DK_new  
  
As  
Begin  
  
EXEC sp_open_cases_billing_report_DK  
EXEC sp_Field_cases_billing_report_DK  
EXEC sp_closed_cases_billing_report_DK 
EXEC sp_SandCGENERATED_cases_billing_report_DK  
  
  
End