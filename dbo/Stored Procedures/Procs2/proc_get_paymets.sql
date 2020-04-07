CREATE PROCEDURE [dbo].[proc_get_paymets]--- proc_get_paymets @TransactionsDate='01/01/2019',@ID='181603'
@TransactionsDate nvarchar(50),
@ID int
as
begin
 SELECT distinct
			trans.Transactions_Id, 
			cas.Case_Id AS Case_Id	,	
			dbo.fncGetBillNumber(cas.Case_ID) AS BILL_NUMBER,			
			case when isnull(trans.ChequeNo,'') ='' then convert(nvarchar(50),trans.Transactions_Id)+'-'+cas.Case_Id else isnull(trans.ChequeNo,'')end  [ChequeNo],
			case when trans.CheckDate is null  then CONVERT(VARCHAR(10), trans.Transactions_Date, 101)  else trans.CheckDate end[CheckDate],
			convert(decimal(38,2),trans.Transactions_Amount) AS Transactions_Amount,
			CONVERT(VARCHAR(10), trans.Transactions_Date, 101) AS Payment_date,
			trans.Transactions_Type,
		     cas.gb_case_id ,
			trans.BatchNo,
			trans.Transactions_Description [TransactionsDescription]
			
		FROM  dbo.tblCase cas
		     INNER JOIN tblTransactions trans on cas.case_id = trans.Case_Id
              where 
			 trans.Transactions_Id>@ID
			  and trans.DomainId='AF'and 
			  Transactions_Type in('PreCToP',
										'PreC',
										'C',
										'I') and isnull(cas.gb_case_id,'')<>''  and Transactions_Id > @ID

	


			SELECT  TOP 10
				B.PhysicalBaseSubPath +'\'+ I.FilePath [PATH],
				it.DateInserted,t.CaseID,
				Filename[FileName],
				'' [Link],
				I.FILENAME [FileName], 
				B.BasePathId ,
				dbo.fncGetBillNumber(T.CaseID) AS BILL_NUMBER
			from dbo.TBLDOCIMAGES I 
		inner Join dbo.tblImageTag IT on IT.ImageID=i.ImageID 
		inner Join dbo.tblTags T on T.NodeID = IT.TagID 
		INNER JOIN tblBasePath B on I.BasePathId = B.BasePathId
		INNER JOIN tblcase cas ON cas.Case_Id = T.CaseID and GB_CASE_ID is not null
		WHERE NodeName = 'PAYMENTS - PROVIDER' 
		 AND B.BasePathType = 2  
		and  T.DomainId='AF'
		and convert(date,DateInserted)>=convert(date,@TransactionsDate)
		AND cas.Case_Id in ( select Case_Id from tblTransactions WHERE DomainId='AF'and 
			  Transactions_Type in('PreCToP',
										'PreC',
										'C',
										'I') and Transactions_Id>@ID)
    ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
       AND I.IsDeleted=0 AND IT.IsDeleted=0  
    ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  



end

