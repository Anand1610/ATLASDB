CREATE PROCEDURE Get_Provider_Document
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50),
	@s_a_DocumentType varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;
       
	  SELECT ('\'+File_Path+FileName) AS File_Path  
		     ,FileName  
		     ,ISNULL(PD.BasePathId,0) AS BasePathId 
		     ,ProviderDoc_Type  
			 ,CAS.Provider_Id
			 --,P.Provider_Name
	 FROM tblcase CAS(NOLOCK) 
		  --INNER JOIN tblProvider P(NOLOCK) ON P.Provider_Id = CAS.Provider_Id 
	      INNER JOIN Provider_Documents PD(NOLOCK) ON PD.Provider_Id = CAS.Provider_Id
		  INNER JOIN Provider_Document_Type PDT(NOLOCK) ON PD.DocType_ID=PDT.Doc_Id  
		  LEFT JOIN tblBasePath BP(NOLOCK) ON BP.BasePathId = PD.BasePathId 
	 Where CAS.Case_Id = @s_a_CaseId AND CAS.DomainId = @s_a_DomainId AND PDT.ProviderDoc_Type = @s_a_DocumentType
END
