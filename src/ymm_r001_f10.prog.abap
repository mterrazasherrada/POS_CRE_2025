*----------------------------------------------------------------------*
*   INCLUDE RWBE1F10                                                   *
*----------------------------------------------------------------------*
***************CLASS LCL_TREE_EVENT_RECEIVER****************************
***************         DEFINITION             *************************
CLASS lcl_tree_event_receiver DEFINITION.

  PUBLIC SECTION.
* item_double_click
    METHODS handle_item_double_click
      FOR EVENT item_double_click OF cl_gui_alv_tree
      IMPORTING node_key
                fieldname
                sender.
* node_double_click
*    METHODS handle_node_double_click
*      FOR EVENT node_double_click OF cl_gui_alv_tree
*      IMPORTING node_key
*                sender.

ENDCLASS.                    "lcl_tree_event_receiver DEFINITION
*---------------------------------------------------------------------*
********CLASS lcl_tree_event_receiver IMPLEMENTATION*******************
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_tree_event_receiver IMPLEMENTATION.

  METHOD handle_item_double_click.
    DATA ls_cbe TYPE s_cbe.

    IF NOT node_key IS INITIAL.
      IF fieldname = '&Hierarchy'.
        PERFORM provide_hide USING node_key.
* if last level is reached call method leads to a cntl_error
        IF NOT zeilen_kz = lag_zeile.
          IF zeilen_kz  = wrk_zeile.
            IF sond_kz IS INITIAL. " expand possible note 1227255
              READ TABLE t_lbe INDEX 1 TRANSPORTING NO FIELDS.
              IF sy-subrc = 0.
                CALL METHOD sender->expand_node
                  EXPORTING
                    i_node_key    = node_key
                    i_level_count = 2.
              ELSE.
                READ TABLE t_cbe INTO ls_cbe WITH KEY matnr = t_zle-matnr
                                                      werks = t_zle-werks.
                IF sy-subrc = 0 AND ls_cbe-charg IS NOT INITIAL.
                CALL METHOD sender->expand_node
                  EXPORTING
                    i_node_key    = node_key
                    i_level_count = 2.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSEIF zeilen_kz = ch_zeile.
            EXIT.
          ELSE.
            CALL METHOD sender->expand_node
              EXPORTING
                i_node_key    = node_key
                i_level_count = 2.
          ENDIF.
        ELSEIF NOT zeilen_kz = ch_zeile.
          IF zeilen_kz = lag_zeile.
             READ TABLE t_cbe INTO ls_cbe WITH KEY matnr = t_zle-matnr
                                                   werks = t_zle-werks
                                                   ex_lgort-lgort = t_zle-lgort.

              IF sy-subrc = 0 AND ls_cbe-charg IS NOT INITIAL.
                CALL METHOD sender->expand_node
                  EXPORTING
                    i_node_key    = node_key
                    i_level_count = 2.
              ENDIF.
         ELSE.
          CALL METHOD sender->expand_node
            EXPORTING
              i_node_key    = node_key
              i_level_count = 2.
         ENDIF.
        ENDIF.
      ELSE.
        CASE sender.
          WHEN mattree1.
            PERFORM provide_hide USING node_key.
            drilldown_level = einzart_level.
          WHEN mattree2.
            var_tree = yes.
            PERFORM provide_hide USING node_key.
            drilldown_level = einzvar_level.
            CLEAR var_tree.
        ENDCASE.
        PERFORM e00_einzel_liste.
      ENDIF.
    ELSE.
      MESSAGE i019.   " cursor in tree
    ENDIF.
*   CASE sender.
*     WHEN mattree1.
*       SET PF-STATUS 'MAINTREE'.
*       SET TITLEBAR 'TRE'.
*     WHEN mattree2.
*       SET PF-STATUS 'VARI100'.
*       SET TITLEBAR 'VAR'.
*   ENDCASE.
ENHANCEMENT-POINT RWBE1F10_G1 SPOTS ES_RWBEST01 .

    CLEAR drilldown_level.
  ENDMETHOD.                    "handle_item_double_click

ENDCLASS.                    "lcl_tree_event_receiver IMPLEMENTATION

***************CLASS LCL_TOOLBAR_EVENT_RECEIVER*************************
***************         DEFINITION             *************************
CLASS lcl_toolbar_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS: on_function_selected
               FOR EVENT function_selected OF cl_gui_toolbar
               IMPORTING fcode
                         sender,

             on_toolbar_dropdown
                FOR EVENT dropdown_clicked OF cl_gui_toolbar
                  IMPORTING fcode
                            posx
                            posy
                            sender.
ENDCLASS.                    "lcl_toolbar_event_receiver DEFINITION
***************         IMPLEMENTATION             *********************
************************************************************************
CLASS lcl_toolbar_event_receiver IMPLEMENTATION.
  METHOD on_function_selected.
    DATA: lt_selected_node TYPE lvc_t_nkey.
* tables to save outtab of maintree
    DATA: sav_gt_lbe TYPE t_lbe,
          sav_gt_wbe TYPE t_wbe,
          sav_t_lbe  TYPE t_lbe,
          sav_t_wbe  TYPE t_wbe.

    CLEAR: lt_sel_node, lt_sel_name.

ENHANCEMENT-POINT RWBE1F10_G2 SPOTS ES_RWBEST01 .

    CASE fcode.
******************variant list******************************************
      WHEN 'VARI'.
        CALL METHOD mattree1->get_selected_item
          IMPORTING
            e_selected_node = lt_sel_node
            e_fieldname     = lt_sel_name.

        PERFORM provide_hide USING lt_sel_node.
        IF t_zle-attyp EQ attyp_sam.
          IF t_zle-bwgrp IS INITIAL.   "only on level of the article
* build a new tree for variants
            PERFORM sav_outtab TABLES t_wbe  t_lbe  sav_t_wbe   sav_t_lbe
                                     gt_wbe gt_lbe sav_gt_wbe  sav_gt_lbe.
            PERFORM mattree2_for_var.
            CALL METHOD mattree2->delete_all_nodes.
* restore gt_outtab
            PERFORM rest_outtab TABLES t_wbe  t_lbe  sav_t_wbe   sav_t_lbe
                                      gt_wbe gt_lbe sav_gt_wbe  sav_gt_lbe.
          ELSE.
            MESSAGE i044.
          ENDIF.
        ELSE.
          MESSAGE i097.
        ENDIF.
* ******************* single list *************************************
      WHEN 'DETA'.
        CASE sender.
          WHEN ex_toolbar.
            CALL METHOD mattree1->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
          WHEN ex_v_toolbar.
            CALL METHOD mattree2->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
*Start of note 1096408
*            var_tree        =  yes.
*End of note 1096408
        ENDCASE.
        IF NOT lt_sel_node IS INITIAL.
*necessary to use 'e00_einzel_liste'
          drilldown_level = einzart_level.
          IF lt_sel_name NE '&Hierarchy'.
            PERFORM provide_hide USING lt_sel_node.
            PERFORM e00_einzel_liste.
          ENDIF.
        ENDIF.
***************ekvk liste*******************************************
      WHEN ekvk.
        CASE sender.
          WHEN ex_toolbar.
            drilldown_level = einzart_level.
            CALL METHOD mattree1->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
          WHEN ex_v_toolbar.
            drilldown_level = einzvar_level.
            CALL METHOD mattree2->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
            var_tree        =  yes.
        ENDCASE.
        IF NOT lt_sel_node IS INITIAL.
          PERFORM provide_hide USING lt_sel_node.
          PERFORM ek_vk_anzeigen.
        ELSE.
          MESSAGE i019.
        ENDIF.
        CLEAR drilldown_level.
****************refresh*************************************************
      WHEN refresh.
        REFRESH: mbe, gbe, wbe, lbe, ebs, kbe, mps, obs, vbs,
                 wbs, oeb, ek_vk, t_wbe, t_lbe,cbe, t_cbe,
                 wbs_seg.
        CLEAR    wbs_Seg.
        CALL METHOD mattree1->delete_all_nodes.
*         PERFORM bestandsdaten_lesen TABLES t_matnr
*                                     t_werks
*                                     mbe gbe wbe lbe ebs kbe
*                                     mps obs vbs wbs oeb ek_vk.
        drilldown_level = artlist_level.
        PERFORM refresh.
        PERFORM werks_only.          "note 1706018
        CLEAR drilldown_level.
        PERFORM create_mathierarchie.
        CALL METHOD mattree1->update_calculations.
        CALL METHOD mattree1->frontend_update.
***************variant-matrix*******************************************
      WHEN matx.

        CALL METHOD mattree1->get_selected_item
          IMPORTING
            e_selected_node = lt_sel_node
            e_fieldname     = lt_sel_name.

        PERFORM provide_hide USING lt_sel_node.
        IF t_zle-attyp EQ attyp_sam.
*        drilldown_level = einzart_level.
          PERFORM sav_outtab TABLES t_wbe  t_lbe sav_t_wbe   sav_t_lbe
                                   gt_wbe gt_lbe sav_gt_wbe  sav_gt_lbe.
          PERFORM matrix_aus_alv USING lt_sel_node lt_sel_name.

* list  for single variant is requested
          PERFORM rest_outtab TABLES
                           t_wbe  t_lbe  sav_t_wbe   sav_t_lbe
                           gt_wbe gt_lbe sav_gt_wbe  sav_gt_lbe.

          IF ret_comm = 'ENDE'.                             " bei 'F15'
*---- leave program
            PERFORM rwbe_beenden.
          ENDIF.
        ELSE.
          MESSAGE i097.
        ENDIF.
***************allowed units of measure*********************************
      WHEN zul_me.
        DATA new_unit.
        CLEAR new_unit.
        CASE sender.
          WHEN ex_toolbar.
            CALL METHOD mattree1->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
            tree_act = maintree_act.
          WHEN ex_v_toolbar.
            CALL METHOD mattree2->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
            var_tree        =  yes.   "needed to find right hide table
* especially needed for proc. out of class lcl_toolbar_event_receiver
* replaces variable 'sender' which is only known in class area
            tree_act = vartree_act.
            external_call   =  yes.

        ENDCASE.
        PERFORM provide_hide USING lt_sel_node.
*cursor in line with unit
        IF zle-bwgrp IS INITIAL.
          PERFORM units_in_alv CHANGING new_unit.
          IF NOT new_unit IS INITIAL.
*change outtab with converted values
            PERFORM change_outtab TABLES t_wbe t_lbe.
            PERFORM change_nodes USING lt_sel_node tree_act.
            CASE tree_act.
              WHEN maintree_act.
                CALL METHOD mattree1->update_calculations.
              WHEN vartree_act.
                CALL METHOD mattree2->update_calculations.
            ENDCASE.
          ENDIF.
        ELSE.
          MESSAGE i044.
        ENDIF.
***************************others***************************************
      WHEN mm43 OR mmbe OR md04 OR me2m OR mb24 OR mb51
                OR ls26 OR stru
                OR equi OR co21 or 'HULI'.                "note 2274587
        CASE sender.
          WHEN ex_toolbar.
            CALL METHOD mattree1->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
          WHEN ex_v_toolbar.
            CALL METHOD mattree2->get_selected_item
              IMPORTING
                e_selected_node = lt_sel_node
                e_fieldname     = lt_sel_name.
            var_tree        =  yes.   "needed to find right hide table
            external_call   =  yes.
        ENDCASE.
        PERFORM fcode_mattree USING lt_sel_node lt_sel_name
                              CHANGING fcode.
    ENDCASE.
    CLEAR drilldown_level.
  ENDMETHOD.                    "on_function_selected
***********************on_toolbar_dropdown******************************
  METHOD on_toolbar_dropdown.
*   create contextmenu
    DATA: l_menu TYPE REF TO cl_ctmenu,
          l_fc_handled TYPE as4flag.

    DATA: show_text TYPE gui_text.                   "note 967716

    CREATE OBJECT l_menu.
    CLEAR l_fc_handled.

    CASE fcode.
      WHEN 'OTHERS'.
        l_fc_handled = 'X'.
*       material master data
        show_text = text-007.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'MM43'
            text  = show_text.                "note 967716
*       other stock overview
        show_text = text-090.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'MMBE'
            text  = show_text.                 "note 967716

        show_text = text-091.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'MD04'
            text  = show_text.                "note 967716

        show_text = text-092.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'ME2M'
            text  = show_text.                "note 967716

        show_text = text-093.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'MB24'
            text  = show_text.                "note 967716

        show_text = text-094.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'MB51'
            text  = show_text.                "note 967716

        show_text = text-095.                        "note 967716
        CALL METHOD l_menu->add_function
          EXPORTING
            fcode = 'LS26'
            text  = show_text.                 "note 967716

    ENDCASE.
    IF l_fc_handled = 'X'.
* show dropdownbox only possible in varianttree
      CALL METHOD ex_v_toolbar->track_context_menu
        EXPORTING
          context_menu = l_menu
          posx         = posx
          posy         = posy.
    ENDIF.
  ENDMETHOD.                    "on_toolbar_dropdown
ENDCLASS.                    "lcl_toolbar_event_receiver IMPLEMENTATION


*&---------------------------------------------------------------------*
*&      Form  MATTREE2_FOR_VAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mattree2_for_var.

  var_tree = yes.
  CALL SCREEN 810 STARTING AT 20 04.
*                ENDING   AT 101 27.                 .

ENDFORM.                               " MATTREE2_FOR_VAR

*&---------------------------------------------------------------------*
*&      Form  UNITS_IN_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM units_in_alv CHANGING p_new_unit TYPE c.   "tga unicode

  READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
  PERFORM mengeneinheiten_lesen TABLES t_matnr.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    PERFORM zul_me_anzeigen.
  ELSE.
    PERFORM show_uom_allowed CHANGING meins_neu.
  ENDIF.

  IF NOT meins_neu IS INITIAL.
    p_new_unit = yes.
*---- Existenzprüfung zur neuen Mengeneinheit und Sprachumwandlung,  --*
*---- denn wenn die Pflegesprache bei den Materialstammdaten von der --*
*---- Anmeldesprache abweicht, wird die Mengeneinheit intern in der  --*
*---- Pflegesprache geführt und erst bei der Anzeige sprachabhängig  --*
*---- umgesetzt, aber der Rückgabewert liegt wieder in der Anmelde-  --*
*---- sprache vor.                                                   --*
    SELECT * FROM t006a
           WHERE spras = sy-langu
           AND   mseh3 = meins_neu.
    ENDSELECT.
    IF sy-subrc = 0.
      meins_neu = t006a-msehi.
    ELSE.
      MESSAGE i080 WITH sy-langu.
*    Eingegebene Mengeneinheit ist für Sprache & nicht vorhanden
      EXIT.                            "raus aus der Form-Routine
    ENDIF.
* prepare t_mefeld which is needed for conversion
    PERFORM prepare_mefeld USING gt_fieldcat.

    PERFORM umrechnen USING t_matnr.
*TGA umrechnen t_w_lbe.*************************************************
    PERFORM umrechnen_alv_werks USING t_matnr.
************************************************************************
*---- Es wurde eine Mengeneinheit selektiert -> Umrechnen der Mengen- -*
*---- felder in den internen Bestandstabellen                         -*
    IF NOT max_stock_value_reached IS INITIAL.             "//KPr1142916
*---- Umrechnung hat zu einem Überlauf geführt -> Meldung ausgeben ----*
*---- und Bestandswerte wieder auf ursprüngliche ME zurückrechnen  ----*
      MESSAGE i109(mm).                "//KPr1142916
*--- Umrechnung in d. ausgewählte Mengeneinheit würde zu einem Überlauf
      meins_alt = t_matnr-meins.       "//KPr1142916
      t_matnr-meins = meins_neu.       "//KPr1142916
      meins_neu = meins_alt.           "//KPr1142916
      t_matnr-umrez_alt = umrez_neu.   "//KPr1142916
      t_matnr-umren_alt = umren_neu.   "//KPr1142916
      PERFORM umrechnen USING t_matnr. "//KPr1142916
*tga umrechnen t_w_lbe.*************************************************
      PERFORM umrechnen_alv_werks USING t_matnr.
    ENDIF.                             "//KPr1142916
*---- Neue Anzeigemengeneinheit und alten Umrechnungsfaktor ablegen ---*
    READ TABLE t_matnr WITH KEY matnr = t_matnr-matnr
                       BINARY SEARCH.  "Index für Eintrag lesen
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
    t_matnr-meins     = meins_neu.
    t_matnr-umrez_alt = umrez_neu.
    t_matnr-umren_alt = umren_neu.
    MODIFY t_matnr INDEX sy-tabix.
  ENDIF.
ENDFORM.                               " UNITS_IN_ALV


*&---------------------------------------------------------------------*
*&      Form  CHANGE_NODES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_nodes USING p_node_key TYPE  lvc_nkey
                        p_tree_act TYPE c.         "tga unicode
  DATA: h_index LIKE sy-tabix.
  h_index = 1.

  IF NOT t_wbe IS INITIAL.
    DATA: h_wbe TYPE t_wbe.

    LOOP AT t_wbe INTO s_wbe WHERE matnr = t_matnr-matnr.
      INSERT s_wbe INTO h_wbe INDEX h_index.
      h_index = h_index + 1.
    ENDLOOP.
    LOOP AT h_wbe INTO s_wbe.
      AT NEW matnr.
*        READ TABLE t_matnr WITH KEY matnr = s_wbe-matnr BINARY SEARCH.
        PERFORM change_item_werks USING p_node_key p_tree_act.
      ENDAT.
      AT NEW bwgrp.
        p_node_key = p_node_key + 1.
      ENDAT.
      p_node_key = p_node_key + 1.
      PERFORM change_node USING  s_wbe p_node_key p_tree_act.
    ENDLOOP.

  ELSE.
    DATA: h_lbe TYPE t_lbe.
    LOOP AT t_lbe INTO s_lbe WHERE matnr = t_matnr-matnr.
      INSERT s_lbe INTO h_lbe INDEX h_index.
      h_index = h_index + 1.
    ENDLOOP.
    LOOP AT h_lbe INTO s_lbe.
      AT NEW matnr.
*        READ TABLE t_matnr WITH KEY matnr = s_wbe-matnr BINARY SEARCH.
        PERFORM change_item_lgort USING p_node_key p_tree_act.
      ENDAT.
      AT NEW bwgrp.
        p_node_key = p_node_key + 1.
      ENDAT.
      AT NEW werks.
        p_node_key = p_node_key + 1.
      ENDAT.
      p_node_key = p_node_key + 1.
*      node_level = 'W'.                "node for site
      PERFORM change_node_lgort CHANGING  s_lbe p_node_key p_tree_act.

    ENDLOOP.
  ENDIF.
ENDFORM.                               " CHANGE_NODES

*&---------------------------------------------------------------------*
*&      Form  CHANGE_NODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_WBE  text
*      -->P_NODE_KEY  text
*      -->P_NODE_LEVEL  text
*----------------------------------------------------------------------*
FORM change_item_werks USING p_node_key TYPE lvc_nkey
                             p_tree_act TYPE c.        "tga unicode

*ls_item_layout-style   = cl_gui_column_tree=>style_intensifd_critical.
  CASE p_tree_act.
    WHEN maintree_act.
      CALL METHOD mattree1->change_item
        EXPORTING
          i_node_key  = p_node_key
          i_fieldname = 'MEINH'
          i_data      = t_matnr-meins      "p_s_wbe-meinh
          i_u_data    = 'X'.
*           IS_ITEM_LAYOUT   =
*      IMPORTING
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
    WHEN vartree_act.
      CALL METHOD mattree2->change_item
        EXPORTING
          i_node_key  = p_node_key
          i_fieldname = 'MEINH'
          i_data      = t_matnr-meins      "p_s_wbe-meinh
          i_u_data    = 'X'.
*           IS_ITEM_LAYOUT   =
*      IMPORTING
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
  ENDCASE.

ENDFORM.                               " CHANGE_NODE

*&---------------------------------------------------------------------*
*&      Form  CHANGE_NODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_L_BWGRP_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_S_WBE  text
*      <--P_L_WERKS_KEY  text
*----------------------------------------------------------------------*
FORM change_node USING p_s_wbe TYPE s_wbe
                       p_node_key TYPE lvc_nkey    "tga unicode
                       p_tree_act TYPE c.          "tga unicode
  CASE p_tree_act.
    WHEN maintree_act.
      CALL METHOD mattree1->change_node
        EXPORTING
          i_node_key    = p_node_key
          i_outtab_line = p_s_wbe.
*          IS_NODE_LAYOUT
*          IT_ITEM_LAYOUT
*          I_NODE_TEXT
*          I_U_NODE_TEXT
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
    WHEN vartree_act.
      CALL METHOD mattree2->change_node
        EXPORTING
          i_node_key    = p_node_key
          i_outtab_line = p_s_wbe.
*          IS_NODE_LAYOUT
*          IT_ITEM_LAYOUT
*          I_NODE_TEXT
*          I_U_NODE_TEXT
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
  ENDCASE.
ENDFORM.                               " CHANGE_NODE

*&---------------------------------------------------------------------*
*&      Form  CHANGE_ITEM_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_P_NODE_KEY  text
*----------------------------------------------------------------------*
FORM change_item_lgort USING    p_node_key TYPE lvc_nkey   "tga unicode
                                p_tree_act TYPE c.         "tga unicode

  CASE p_tree_act.
    WHEN maintree_act.
      CALL METHOD mattree1->change_item
        EXPORTING
          i_node_key  = p_node_key
          i_fieldname = 'MEINH'
          i_data      = t_matnr-meins      "p_s_wbe-meinh
          i_u_data    = 'X'.
*           IS_ITEM_LAYOUT   =
*      IMPORTING
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
    WHEN vartree_act.
      CALL METHOD mattree2->change_item
        EXPORTING
          i_node_key  = p_node_key
          i_fieldname = 'MEINH'
          i_data      = t_matnr-meins      "p_s_wbe-meinh
          i_u_data    = 'X'.
*           IS_ITEM_LAYOUT   =
*      IMPORTING
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
  ENDCASE.

ENDFORM.                               " CHANGE_ITEM_LGORT

*&---------------------------------------------------------------------*
*&      Form  CHANGE_NODE_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_S_WBE  text
*      <--P_P_NODE_KEY  text
*----------------------------------------------------------------------*
FORM change_node_lgort CHANGING p_s_lbe TYPE s_lbe
                                p_node_key TYPE lvc_nkey   "tga unicode
                                p_tree_act TYPE c.         "tga unicode
  CASE p_tree_act.
    WHEN maintree_act.
      CALL METHOD mattree1->change_node
        EXPORTING
          i_node_key    = p_node_key
          i_outtab_line = p_s_lbe.
*          IS_NODE_LAYOUT
*          IT_ITEM_LAYOUT
*          I_NODE_TEXT
*          I_U_NODE_TEXT
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
    WHEN vartree_act.
      CALL METHOD mattree2->change_node
        EXPORTING
          i_node_key    = p_node_key
          i_outtab_line = p_s_lbe.
*          IS_NODE_LAYOUT
*          IT_ITEM_LAYOUT
*          I_NODE_TEXT
*          I_U_NODE_TEXT
      IF sy-subrc NE 0.
        MESSAGE a096.
      ENDIF.
  ENDCASE.
ENDFORM.                               " CHANGE_NODE_LGORT
*&---------------------------------------------------------------------*
*&      Form  UMRECHNEN_ALV_WERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM umrechnen_alv_werks USING p_t_matnr STRUCTURE t_matnr.   "tga unicode

  DATA: h_index LIKE sy-tabix.
  MOVE 'S_W_LBE-' TO sav_fname0(8).
  LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = p_t_matnr-matnr.
    h_index = sy-tabix.
    LOOP AT t_mefeld.
      MOVE t_mefeld-fname TO sav_fname0+8.
      ASSIGN (sav_fname0) TO <f0>.
      IF sy-subrc = 0.     "Falls ASSIGN-Zuweisung erfolgreich war.
        CATCH SYSTEM-EXCEPTIONS
               arithmetic_errors = 1
               OTHERS = 99.

          <f0> = <f0> * umren_neu * umrez_alt / ( umrez_neu * umren_alt ).
        ENDCATCH.
        IF NOT sy-subrc IS INITIAL.
* Die Umrechnung von großen Bestandswerten auf eine, im metrischen Sinne
* kleinere Einheit, kann zu einem Wert führen, der nicht mehr in den
* Feldern <D1>, <D2>, <D3>, die auf einen Datentyp P(7) verweisen,
* dargestellt werden können
* -> Meldung ausgeben und auf ursprüngliche Mengeneinheit zurückgehen
          max_stock_value_reached = x.   "//KPr 1142916
        ENDIF.                           "//KPR 1142916
        MODIFY t_w_lbe FROM s_w_lbe INDEX h_index.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDFORM.                    " UMRECHNEN_ALV_WERKS
