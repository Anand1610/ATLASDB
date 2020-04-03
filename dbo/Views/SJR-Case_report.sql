


CREATE VIEW [dbo].[SJR-Case_report]
AS
SELECT  DISTINCT  tblcase.Case_Id AS [Case ID],tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName AS Claimant, 
                     tblProvider.Provider_Name AS Provider,tblInsuranceCompany.InsuranceCompany_Name AS [Ins Company], CONVERT(money, 
                     tblcase.Claim_Amount) - CONVERT(money,tblcase.Paid_Amount) AS Balance,tblcase.IndexOrAAA_Number AS [Index],tblcase.Status, 
                      CONVERT(varchar(12),tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12),tblcase.DateOfService_End, 110) AS DOS, 
                     tblcase.Ins_Claim_Number AS Claim#,tblcase.Date_Opened,tblcase.Case_Code,tblcase.Initial_Status,tblcase.Provider_Id, 
                      SUM(CONVERT(MONEY,tblcase.Claim_Amount)) AS Claim_Amount, SUM(CONVERT(MONEY,tblcase.Paid_Amount)) AS Paid_Amount, 
					  SUM(CONVERT(MONEY,tblcase.Fee_Schedule)) AS Fee_Schedule, 
                     tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName AS InjuredParty_Name,tblcase.Accident_Date,tblcase.domainid
FROM        tblcase as tblcase INNER JOIN
                     tblInsuranceCompany as tblInsuranceCompany ON tblcase.InsuranceCompany_Id =tblInsuranceCompany.InsuranceCompany_Id and tblcase.DomainId =  tblInsuranceCompany.DomainId  
					 INNER JOIN tblProvider as tblProvider ON tblcase.Provider_Id =tblProvider.Provider_Id and tblcase.DomainId = tblProvider.DomainId
WHERE tblcase.Case_id NOT IN (SELECT DISTINCT Packeted_Case_ID from Billing_Packet)
GROUP BY tblcase.Case_Id, CONVERT(money,tblcase.Claim_Amount) - CONVERT(money,tblcase.Paid_Amount), 
                     tblInsuranceCompany.InsuranceCompany_Name,tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName, 
                     tblcase.IndexOrAAA_Number,tblcase.Status, CONVERT(varchar(12),tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12), 
                     tblcase.DateOfService_End, 110),tblcase.Ins_Claim_Number,tblProvider.Provider_Name,tblcase.Date_Opened, 
                     tblcase.Case_Code,tblcase.Initial_Status,tblcase.Provider_Id,tblcase.Accident_Date,tblcase.Fee_Schedule,tblcase.domainid



GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[27] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[55] 4[24] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 2
               Left = 256
               Bottom = 328
               Right = 545
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 50
               Left = 568
               Bottom = 163
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 165
               Left = 3
               Bottom = 278
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3945
         Alias = 900
         Table = 2565
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2880
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'[SJR-Case_report].[Date_Opened]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Case_report';

