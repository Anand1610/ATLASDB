CREATE PROCEDURE [dbo].[insff]  
(
@DomainID VARCHAR(50),  
@cid varchar(50),  
@fees varchar(10)  
)  
as  
begin  
IF NOT Exists(SELECT Case_ID From	TBLTRANSACTIONS WHERE TRANSACTIONS_TYPE = 'FFB' and case_id = @cid)
BEGIN
	insert into tbltransactions (Case_Id,Transactions_Type,Transactions_Date,Transactions_Amount,Transactions_Description,Provider_Id,User_Id,Transactions_Fee,Transactions_status,Invoice_Id,DomainId)  
	select @cid,'FFB',getdate(),convert(money,@fees),'INDEX FEES',provider_id,'system',convert(money,@fees),null,0,@DomainID FROM 
	lcj_vw_Casesearchdetails WHERE CASE_ID=@CID and provider_ff = 1  
END
insert into tbltransactions (Case_Id,Transactions_Type,Transactions_Date,Transactions_Amount,Transactions_Description,Provider_Id,User_Id,Transactions_Fee,Transactions_status,Invoice_Id,DomainId)  
select @cid,'FFBF',getdate(),convert(money,@fees),'INDEX FEES NOT BILLED TO PROVIDER',provider_id,'system',convert(money,@fees),null,0,@DomainID FROM 
lcj_vw_Casesearchdetails WHERE CASE_ID=@CID and provider_ff = 0  
  
		DECLARE @s_l_Status VARCHAR(500) 
		DECLARE @newStatusHierarchy int
	    DECLARE @oldStatusHierarchy int
		SET @s_l_Status = (SELECT top 1 status From tblCASE (NOLOCK) WHERE Case_ID = @cid AND DomainId = @DomainId)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_Status)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='SUMMONS-SENT-TO-COURT')

		-- if(@newStatusHierarchy>=@oldStatusHierarchy)
		if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
		BEGIN
			UPDATE TBLCASE SET DATE_SUMMONS_SENT_COURT = GETDATE(),status = 'SUMMONS-SENT-TO-COURT'
			WHERE CASE_ID=@CID  AND DomainId=@DomainID  
		END	  


INSERT INTO TBLNOTES  (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
SELECT 'SUMMONS SENT TO COURT AND BILLED','A',0,@CID,GETDATE(),'SYSTEM',@DomainID  
  
  
end

