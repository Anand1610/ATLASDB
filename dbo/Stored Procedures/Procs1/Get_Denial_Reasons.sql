CREATE PROCEDURE [dbo].[Get_Denial_Reasons]
	@DomainId NVARCHAR(50),
	@Treatment_Id int  
as

	select i_txn_treatment_id,
	treatment_id,
	DenialReasons_Type,
	sz_category_color,
	Action_type,
	CONVERT(varchar(10),DenialReasons_Date,110) as DenialReasons_Date,
	CONVERT(varchar(10),IMEDate,110) as IMEDate
	
	 from txn_tbltreatment
		join tblDenialReasons on tblDenialReasons.denialreasons_id = txn_tbltreatment.denialreasons_id
		LEFT OUTER join MST_DENIAL_CATEGORY on MST_DENIAL_CATEGORY.i_category_id = tblDenialReasons.i_category_id
		where txn_tbltreatment.treatment_id = @Treatment_Id and tblDenialReasons.DomainId=@DomainId

