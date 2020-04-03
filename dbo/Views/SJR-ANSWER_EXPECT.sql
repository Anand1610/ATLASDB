CREATE VIEW [dbo].[SJR-ANSWER_EXPECT]
AS
SELECT     dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, dbo.tblcase.Status, dbo.tblInsuranceCompany.InsuranceCompany_Name, dbo.tblcase.Served_On_Date, 
                      dbo.tblcase.Date_Ext_Of_Time, dbo.tblcase.Date_Ext_Of_Time_2, dbo.tblcase.Date_Ext_Of_Time_3, CASE WHEN (Date_Ext_Of_Time_3 IS NOT NULL) 
                      THEN (Date_Ext_Of_Time_3 + 5) WHEN (Date_Ext_Of_Time_2 IS NOT NULL) AND (Date_Ext_Of_Time_3 IS NULL) THEN (Date_Ext_Of_Time_2 + 5) 
                      WHEN (Date_Ext_Of_Time IS NOT NULL) AND (Date_Ext_Of_Time_2 IS NULL) THEN (Date_Ext_Of_Time + 5) WHEN (Date_Ext_Of_Time IS NULL) AND 
                      (InsuranceCompany_Name NOT LIKE '%GEICO%') THEN (Date_Afidavit_Filed + 45) WHEN (Date_Ext_Of_Time IS NULL) AND 
                      (InsuranceCompany_Name LIKE '%GEICO%') THEN (Served_on_date + 65) END AS ANS_EXPECT, 
                      dbo.tblcase.InjuredParty_LastName + ', ' + dbo.tblcase.InjuredParty_FirstName AS Patient_Name
FROM         dbo.tblcase INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
WHERE     (dbo.tblcase.Status = N'AFFIDAVITS FILED IN COURT') AND (dbo.tblcase.Served_On_Date > GETDATE() - 365)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[19] 2[32] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 1
               Left = 49
               Bottom = 455
               Right = 339
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 6
               Left = 377
               Bottom = 121
               Right = 626
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1245
         Width = 885
         Width = 1725
         Width = 1875
         Width = 1620
         Width = 1830
         Width = 1785
         Width = 2115
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2925
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2670
         Or = 2190
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-ANSWER_EXPECT';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-ANSWER_EXPECT';

