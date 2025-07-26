*-------------------------------------------------------------------
***INCLUDE RWBE1O01 .
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Module  SUPPRESS_DIALOG  OUTPUT
*&---------------------------------------------------------------------*
*       Menüeigenschaften des Dialogfensters unterdrücken bzw. Fenster *
*       schließen beim Beenden der Einzellistanzeige
*----------------------------------------------------------------------*
MODULE suppress_dialog OUTPUT.

  IF kz_prozessiert IS INITIAL.
    SUPPRESS DIALOG.
    kz_prozessiert = x.
  ELSE.
    CLEAR kz_prozessiert.
    SET SCREEN 0.
    LEAVE SCREEN.
  ENDIF.

ENDMODULE.                 " SUPPRESS_DIALOG  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  EINZEL_ANZEIGE  OUTPUT
*&---------------------------------------------------------------------*
*       Anzeigen der Einzelliste zu der ausgewählten Organisationsebene
*----------------------------------------------------------------------*
MODULE einzel_anzeige OUTPUT.

  SET PF-STATUS pfstatus_eman. "<<<tga, pf status on pbo for conc. dynp
  LEAVE TO LIST-PROCESSING.
  PERFORM einzelanzeige_felder.

* tga / acc retail
  IF NOT cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CLEAR:
    gt_einzelanz_mbwl,
    gt_einzelanz_lief, wa_einzelanz_lief,
    gt_einzelanz_kd,   wa_einzelanz_kd,
    gt_einzelanz_auf,  wa_einzelanz_auf .
* Build fieldcat once for man/bukrs/wrk/lgo/cha
    PERFORM build_fieldcat_mbwl.
  ENDIF.

  CASE zeilen_kz.
    WHEN ges_zeile.
      PERFORM einzelanzeige_ges_write.
    WHEN man_zeile.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
      CASE drilldown_level.
        WHEN einzart_level.
          SET TITLEBAR 'EIN' WITH text-014 text-026.
        WHEN einzvar_level.
          SET TITLEBAR 'EIN' WITH text-014 text-032.
        WHEN artlist_level.
          SET TITLEBAR 'EIN' WITH text-014 text-025.
      ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
      PERFORM einzelanzeige_man_write.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*   WHEN BUK_ZEILE.
*      PERFORM EINZELANZEIGE_BUK_WRITE.
    WHEN wgr_zeile.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
      CASE drilldown_level.
        WHEN einzart_level.
          SET TITLEBAR 'EIN' WITH text-027 text-026.
        WHEN einzvar_level.
          SET TITLEBAR 'EIN' WITH text-027 text-032.
        WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
      ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
      PERFORM einzelanzeige_wgr_write.
************************werks level*************************************
    WHEN wrk_zeile.
      CASE sond_kz.
        WHEN space.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-028 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-028 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_wrk_write.
        WHEN beistlief.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-044 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-044 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_beistlief_write.
        WHEN konsikunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-045 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-045 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_konsikunde_write.
        WHEN lrgutkunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-046 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-046 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_lrgutkunde_write.
      ENDCASE.
*************************storage location level*************************
    WHEN lag_zeile.
      CASE sond_kz.
        WHEN space.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-029 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-029 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_lgo_write.
        WHEN aufbskunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-048 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-048 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_aufbskunde_write.
        WHEN konsilief.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          SET PF-STATUS pfstatus_eson.
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-047 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-047 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_konsilief_write.
*       WHEN PRJBESTAND.      ????uninteressant für Handel?
*         PERFORM EINZELANZEIGE_PRJBESTAND_WRITE.
        WHEN mtverpack.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-049 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-049 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_mtverpack_write.
      ENDCASE.
      WHEN ch_zeile.
        CASE sond_kz.
          WHEN space.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-029 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-029 text-032.
              WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
            ENDCASE.
            PERFORM einzelanzeige_ch_write.

        WHEN aufbskunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-048 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-048 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_aufbskunde_write.

        WHEN konsikunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
          CASE drilldown_level.
            WHEN einzart_level.
              SET TITLEBAR 'EIN' WITH text-045 text-026.
            WHEN einzvar_level.
              SET TITLEBAR 'EIN' WITH text-045 text-032.
            WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
          ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
          PERFORM einzelanzeige_konsikunde_charg.
        ENDCASE.
*   WHEN CHA_ZEILE.    ????entfällt
*     CASE SOND_KZ.
*       WHEN SPACE.
*         PERFORM EINZELANZEIGE_CHA_WRITE.
*       WHEN AUFBSKUNDE.
*         PERFORM EINZELANZEIGE_AUFBSKUNDE_WRITE.
*       WHEN BEISTLIEF.
*         PERFORM EINZELANZEIGE_BEISTLIEF_WRITE.
*       WHEN KONSIKUNDE.
*         PERFORM EINZELANZEIGE_KONSIKUNDE_WRITE.
*       WHEN KONSILIEF.
*         PERFORM EINZELANZEIGE_KONS_WRITE.
*       WHEN LRGUTKUNDE.
*         PERFORM EINZELANZEIGE_LRGUTKUNDE_WRITE.
*       WHEN PRJBESTAND.                                    "neu zu 3.0
*         PERFORM EINZELANZEIGE_PRJBESTAND_WRITE.
*       WHEN MTVERPACK.                                     "neu zu 3.0
*         PERFORM EINZELANZEIGE_MTVERPACK_WRITE.
*     ENDCASE.
  ENDCASE.

ENDMODULE.                 " EINZEL_ANZEIGE  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  EK_VK_ANZEIGE  OUTPUT
*&---------------------------------------------------------------------*
*       Anzeigen der EK/VK-Bestandswerte zu der ausgewählten Organi-
*       sationsebene. Falls auf den Ebenen 'Basiswerksgruppe' und
*       'Gesamt' unterschiedliche Währungen auftreten, wird pro
*       Währung ein EK/VK-Bestandssatz angezeigt.
*----------------------------------------------------------------------*
MODULE ek_vk_anzeige OUTPUT.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro
  SET PF-STATUS pfstatus_eman.  "<<<tga insert
  LEAVE TO LIST-PROCESSING.
  PERFORM ek_vk_anzeige_felder.

  CASE zeilen_kz.
    WHEN ges_zeile.
*???? PERFORM EINZELANZEIGE_GES_WRITE.
    WHEN man_zeile.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
      CASE drilldown_level.
        WHEN einzart_level.
          SET TITLEBAR 'WER' WITH text-014 text-026.
        WHEN einzvar_level.
          SET TITLEBAR 'WER' WITH text-014 text-032.
        WHEN artlist_level.              "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
      ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
      PERFORM ek_vk_anzeige_man_write.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*   WHEN BUK_ZEILE.
*      PERFORM EINZELANZEIGE_BUK_WRITE.
    WHEN wgr_zeile.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
      CASE drilldown_level.
        WHEN einzart_level.
          SET TITLEBAR 'WER' WITH text-027 text-026.
        WHEN einzvar_level.
          SET TITLEBAR 'WER' WITH text-027 text-032.
        WHEN artlist_level.                "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
      ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
      PERFORM ek_vk_anzeige_wgr_write.
    WHEN wrk_zeile.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
      CASE drilldown_level.
        WHEN einzart_level.
          SET TITLEBAR 'WER' WITH text-028 text-026.
        WHEN einzvar_level.
          SET TITLEBAR 'WER' WITH text-028 text-032.
        WHEN artlist_level.                "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
      ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
      PERFORM ek_vk_anzeige_wrk_write.
  ENDCASE.

ENDMODULE.                 " EK_VK_ANZEIGE  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STOCK_IN_STRART  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE stock_in_strart OUTPUT.
  SET PF-STATUS pfstatus_eman.  "<<<tga, pf status on pbo for conc. dynp
  SET TITLEBAR 'COM'.
  LEAVE TO LIST-PROCESSING.
  PERFORM write_stock_of_strart.


ENDMODULE.                             " STOCK_IN_STRART  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBOMATTREE_0800  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE mattree_0800 OUTPUT.
  SET PF-STATUS 'MAINTREE'.
  SET TITLEBAR 'TRE'.
  IF mattree1 IS INITIAL.
* initialize tree and build fielcatalog
    PERFORM init_mattree USING var_tree.
* register events of cl_gui_column_tree
    PERFORM register_events_tree1.
* own buttons for the toolbar
    PERFORM change_toolbar_tree1.
* create outtab and hierarchie for mainscreen
    PERFORM create_mathierarchie.
* cumulate values
    CALL METHOD mattree1->update_calculations.
*  CALL METHOD mattree1->frontend_update.

  ENDIF.
ENDMODULE.                             " MATTREE_0800  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PAIMATTREE_0800  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE mattree_0800 INPUT.

  ok_code1 = sy-ucomm.
* tga note 356164
*  IF NOT ok_code1 EQ 'EXIT' OR NOT ok_code1 EQ 'ENDE'
*                            OR NOt ok_code1 EQ 'CANC'.
  IF NOT ok_code1 EQ 'EXIT' AND
     NOT ok_code1 EQ 'ENDE' AND
     NOT ok_code1 EQ 'CANC'.

    CALL METHOD mattree1->get_selected_item
      IMPORTING
        e_selected_node = lt_sel_node
        e_fieldname     = lt_sel_name.
  ENDIF.
  PERFORM fcode_mattree USING lt_sel_node lt_sel_name
                         CHANGING ok_code1.

ENDMODULE.                             " MATTREE_0800  INPUT

*&---------------------------------------------------------------------*
*&      Module  PBOMATTREE_0810  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE vartree_0810 OUTPUT.

  SET PF-STATUS 'VARI100'.
  SET TITLEBAR 'VAR'.
*initialize tree2
  IF mattree2 IS INITIAL.
    PERFORM init_mattree USING var_tree.
* register events of cl_gui_column_tree
    PERFORM register_events_tree2.
* own buttons for the toolbar
    PERFORM change_toolbar_tree2.
  ENDIF.
*will be prcessed coming from the main screen.
  IF var_tree = yes AND external_call = space.
* create hierarchie for variants
    PERFORM create_mathierarchie.

    CALL METHOD mattree2->update_calculations.
*    CALL METHOD mattree2->frontend_update.
*    leads to wrong assignment
*    CLEAR var_tree.
  ENDIF.
  CLEAR external_call.
ENDMODULE.                             " VARTREE_0810  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PAIMATTREE_0810  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE vartree_0810 INPUT.

  ok_code2 = sy-ucomm.

  CASE ok_code2.
    WHEN 'RW' OR 'ABBR'.
      PERFORM exit_variants CHANGING ok_code2.
    WHEN OTHERS.
      CLEAR var_tree.
      CALL METHOD cl_gui_cfw=>dispatch.
  ENDCASE.
  CLEAR ok_code2.
*  call method cl_gui_cfw=>flush.



ENDMODULE.                             " VARTREE_0810  INPUT
*&---------------------------------------------------------------------*
*&      Module  MATTREE_0801  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE mattree_0801 OUTPUT.
  SET PF-STATUS 'MAINTREE'.
  SET TITLEBAR 'TRE'.
  IF p_kzalv IS NOT INITIAL.
    IF gv_tree IS INITIAL.
      PERFORM build_outtab_tree1 TABLES t_wbe t_lbe t_cbe.
    ELSE.
      PERFORM build_gen_outtab_tree1 TABLES t_wbe t_lbe t_cbe.
    ENDIF.

   PERFORM build_final_internal_table TABLES t_wbe t_lbe t_cbe.

    PERFORM alv_display.
  ENDIF.
ENDMODULE.                 " MATTREE_0801  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  MATTREE_0801  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE mattree_0801 INPUT.
  ok_code1 = sy-ucomm.

  IF NOT ok_code EQ 'EXIT' AND
     NOT ok_code EQ 'ENDE' AND
     NOT ok_code EQ 'CANC'.
    LEAVE TO SCREEN 0.
  ENDIf.
ENDMODULE.                 " MATTREE_0801  INPUT
