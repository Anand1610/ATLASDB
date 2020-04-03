CREATE PROCEDURE [dbo].[Update_Transactions_Provider]        
AS   

		
	

	update tre
	set provider_id = cas.Provider_id from tbltransactions tre
	join tblcase cas on tre.case_id = cas.case_id
	where tre.provider_id <> cas.provider_id  
	and (Transactions_status <> 'FREEZED' or Transactions_status IS NULL)