CREATE FUNCTION [dbo].[SJR-ANSWER_EXPECT_ACTION](@ACTION nvarchar(50))
RETURNS TABLE
AS
RETURN (SELECT     [SJR-ANSWER_EXPECT].Case_Id, [SJR-ANSWER_EXPECT].Case_Code, CASE WHEN ANS_EXPECT IS NULL THEN 'ERROR' WHEN GETDATE() 
                      BETWEEN ANS_EXPECT AND (ANS_EXPECT + 0) THEN 'LATE ANSWER' WHEN GETDATE() > (ANS_EXPECT + 0) THEN 'DEFAULT' WHEN GETDATE() 
                      < ANS_EXPECT THEN 'WAITING' END AS ACTION, [SJR-ANSWER_EXPECT].ANS_EXPECT, CONVERT(VARCHAR(4), 
                      YEAR([SJR-ANSWER_EXPECT].ANS_EXPECT)) + '-' + CONVERT(VARCHAR(2), MONTH([SJR-ANSWER_EXPECT].ANS_EXPECT)) AS MONTH, 
                      tblInsuranceCompany.InsuranceCompany_Name, tblProvider.Provider_Name, 
                      tblcase.InjuredParty_FirstName + N' ' + tblcase.InjuredParty_LastName AS Injured_Party, tblcase.Ins_Claim_Number, tblcase.IndexOrAAA_Number, 
                      [SJR-ANSWER_EXPECT].Served_On_Date, 
                      CASE WHEN dbo.[SJR-ANSWER_EXPECT].ANS_EXPECT < dbo.[SJR-ANSWER_EXPECT].Served_on_date THEN 'ERROR' ELSE NULL END AS LAR
FROM         tblProvider INNER JOIN
                      tblcase ON tblProvider.Provider_Id = tblcase.Provider_Id INNER JOIN
                      tblInsuranceCompany ON tblcase.InsuranceCompany_Id = tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      [SJR-ANSWER_EXPECT] ON tblcase.Case_Id = [SJR-ANSWER_EXPECT].Case_Id
WHERE     (CASE WHEN ANS_EXPECT IS NULL THEN 'ERROR' WHEN GETDATE() BETWEEN ANS_EXPECT AND (ANS_EXPECT + 0) 
                      THEN 'LATE ANSWER' WHEN GETDATE() > (ANS_EXPECT + 0) THEN 'DEFAULT' WHEN GETDATE() < ANS_EXPECT THEN 'WAITING' END = @ACTION) )

GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


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
         Configuration = "(H (1 [56] 4 [18] 2))"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 120
               Left = 38
               Bottom = 233
               Right = 311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 234
               Left = 38
               Bottom = 347
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-ANSWER_EXPECT"
            Begin Extent = 
               Top = 126
               Left = 464
               Bottom = 425
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 9945
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'[SJR-ANSWER_EXPECT_ACTION].[MONTH]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ANSWER_EXPECT_ACTION';

