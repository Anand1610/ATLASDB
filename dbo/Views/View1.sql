CREATE VIEW [dbo].[View1]
AS
SELECT      dbo.tblcase.Case_Id, dbo.[SJR-SETTLEMENTS_FULL].Sett_tot, ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0) AS PAYMENTS, 
                        dbo.[SJR-SETTLEMENTS_FULL].Sett_tot - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0) AS Balance, 
                        dbo.[SJR-SETTLEMENTS_FULL].Settl_date, CONVERT(int, GETDATE() - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS Aging, CONVERT(int, 
                        dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date - dbo.[SJR-SETTLED_PAYMENTS_FULL].Min_Date) AS Pay_spread, CONVERT(int, 
                        dbo.[SJR-SETTLED_PAYMENTS_FULL].Min_Date - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS Min_delay, CONVERT(int, 
                        dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS Max_delay, CONVERT(int, GETDATE() 
                        - dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date) AS Idle_time, dbo.tblcase.Status, 
                        dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName AS Claimant, dbo.tblProvider.Provider_Name AS Provider, 
                        dbo.tblInsuranceCompany.InsuranceCompany_Name AS Ins_Co, dbo.tblcase.Ins_Claim_Number AS Claim#, 
                        dbo.tblcase.IndexOrAAA_Number AS [Index], dbo.tblcase.Case_Code
FROM          dbo.tblInsuranceCompany INNER JOIN
                        dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id INNER JOIN
                        dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                        dbo.[SJR-SETTLEMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id LEFT OUTER JOIN
                        dbo.[SJR-SETTLED_PAYMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id
WHERE      (CONVERT(int, GETDATE() - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) > 30) AND (dbo.tblcase.Status = N'SETTLED') OR
                        (dbo.tblcase.Status = N'PAYMENT DISBURSED') OR
                        (dbo.tblcase.Status = N'PAID')

GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
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
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 183
               Left = 0
               Bottom = 296
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 34
               Left = 445
               Bottom = 147
               Right = 718
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 238
               Left = 658
               Bottom = 351
               Right = 856
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-SETTLEMENTS_FULL"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-SETTLED_PAYMENTS_FULL"
            Begin Extent = 
               Top = 6
               Left = 230
               Bottom = 119
               Right = 384
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
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7410
         Alias = 1905
         Table = 2835
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'= 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View1';

