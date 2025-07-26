*&---------------------------------------------------------------------*
*&  Include           RWBE1F11
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  show_single_stnd_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_single_stnd_grid .

  DATA: lv_formname  TYPE slis_formname,
        lv_formname2 TYPE slis_formname,
        lv_repid     TYPE sy-repid,
        lv_title     TYPE lvc_title,
        ls_layout    TYPE slis_layout_alv.

* size pop-up
  DATA:   lv_sc TYPE i,
          lv_ec TYPE i,
          lv_sl TYPE i,
          lv_el TYPE i.

* general data
  lv_repid = sy-repid.
  lv_formname = 'BUILD_HEADER_SINGLE_LIST'.
  lv_formname2 = 'SET_PF_STAT_FOR_GRID'.
* Layout define
  ls_layout-zebra = 'X'.

* size of pop-up
  PERFORM set_size CHANGING lv_sc lv_ec lv_sl lv_el.

* set tiltebar an text for control
  PERFORM set_titlebar_grid1 CHANGING lv_title.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = lv_repid
      i_callback_pf_status_set = lv_formname2
      i_callback_top_of_page   = lv_formname
      i_grid_title             = lv_title
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat_mbwl
      i_default                = ' '             "note 2748763
      i_screen_start_column    = lv_sc
      i_screen_start_line      = lv_sl
      i_screen_end_column      = lv_ec
      i_screen_end_line        = lv_el
    TABLES
      t_outtab                 = gt_einzelanz_mbwl
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CLEAR  gt_einzelanz_mbwl.
  REFRESH gt_einzelanz_mbwl.

  IF zeilen_kz = ges_zeile.

  ELSE.
    CASE drilldown_level.
      WHEN artlist_level.
        SET TITLEBAR  'GRU' WITH text-025.
      WHEN einzart_level.
        SET TITLEBAR  'GRU' WITH text-026.
      WHEN einzvar_level.
        SET TITLEBAR  'GRU' WITH text-032.
    ENDCASE.

  ENDIF.

ENDFORM.                    " show_single_stnd_grid
*&---------------------------------------------------------------------*
*&      Form  build_fieldcat_mbwl
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat_mbwl .

  FIELD-SYMBOLS: <l_fs> LIKE LINE OF gt_fieldcat_mbwl.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'RMMMBESTN_POPUP'
    CHANGING
      ct_fieldcat            = gt_fieldcat_mbwl
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

* Rechtsbündige Daten
  READ TABLE gt_fieldcat_mbwl
  WITH KEY fieldname = 'BSTNDTXT'
  ASSIGNING <l_fs>.
  IF sy-subrc = 0.
    <l_fs>-just = 'R'.
    UNASSIGN <l_fs>.
  ENDIF.
ENDFORM.                    " build_fieldcat_mbwl
*&---------------------------------------------------------------------*
*&      Form  build_header_single_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_header_single_list.

  DATA: lr_grid  TYPE REF TO cl_salv_form_layout_grid,
        lr_label TYPE REF TO cl_salv_form_label,
        lr_text  TYPE REF TO cl_salv_form_text.

* Objekt erzeugen
  CREATE OBJECT lr_grid.

* Top-of-page nach Ebene (M/B/W/L/C/D) aufbauen
  CASE zeilen_kz.
    WHEN ges_zeile.
*   overall
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-034 ).
*   article
    WHEN man_zeile.
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-007 ).
      lr_text = lr_grid->create_text(
         row     = 1
         column  = 2
         text = zle-matnr ).
      lr_label->set_label_for( lr_text ).
*   site group
    WHEN wgr_zeile.
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-007 ).
      lr_text = lr_grid->create_text(
         row     = 1
         column  = 2
         text = zle-matnr ).
      lr_label->set_label_for( lr_text ).
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-027 ).
*     handle dummy
      IF zle-bwgrp = dummy_bwgrp.
        lr_text = lr_grid->create_text(
           row     = 2
           column  = 2
           text = text-036 ).
        lr_label->set_label_for( lr_text ).
      ELSE.
        lr_text = lr_grid->create_text(
           row     = 2
           column  = 2
           text = zle-bwgrp ).
        lr_label->set_label_for( lr_text ).
      ENDIF.
*   site
    WHEN wrk_zeile.
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-007 ).
      lr_text = lr_grid->create_text(
         row     = 1
         column  = 2
         text = zle-matnr ).
      lr_label->set_label_for( lr_text ).
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-028 ).
      lr_text = lr_grid->create_text(
         row     = 2
         column  = 2
         text = zle-werks ).
      lr_label->set_label_for( lr_text ).
*   storage location
    WHEN lag_zeile.
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-007 ).
      lr_text = lr_grid->create_text(
         row     = 1
         column  = 2
         text = zle-matnr ).
      lr_label->set_label_for( lr_text ).
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-028 ).
      lr_text = lr_grid->create_text(
         row     = 2
         column  = 2
         text = zle-werks ).
      lr_label = lr_grid->create_label(
         row     = 3
         column  = 1
         text    = text-029 ).
      lr_text = lr_grid->create_text(
         row     = 3
         column  = 2
         text = zle-lgort ).
      lr_label->set_label_for( lr_text ).
    WHEN ch_zeile .
      lr_label = lr_grid->create_label(
         row     = 1
         column  = 1
         text    = text-007 ).
      lr_text = lr_grid->create_text(
         row     = 1
         column  = 2
         text = zle-matnr ).
      lr_label->set_label_for( lr_text ).
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-028 ).
      lr_text = lr_grid->create_text(
         row     = 2
         column  = 2
         text = zle-werks ).
      lr_label->set_label_for( lr_text ).

      lr_label = lr_grid->create_label(
         row     = 3
         column  = 1
         text    = text-029 ).
      lr_text = lr_grid->create_text(
         row     = 3
         column  = 2
         text = zle-lgort ).
      lr_label->set_label_for( lr_text ).
      IF zle-charg IS INITIAL AND
         zle-sgt_scat IS NOT INITIAL.
        IF p_kzseg IS NOT INITIAL.
          lr_label = lr_grid->create_label(
             row     = 4
             column  = 1
             text    = text-118 ).
          lr_text = lr_grid->create_text(
             row     = 4
             column  = 2
             text = zle-sgt_scat ).
        ENDIF.
ENHANCEMENT-POINT RWBE1F11_01 SPOTS ES_RWBEST01 .

      ELSE .
        lr_label = lr_grid->create_label(
           row     = 4
           column  = 1
           text    = text-015 ).
        lr_text = lr_grid->create_text(
           row     = 4
           column  = 2
           text = zle-charg ).
      ENDIF.
      lr_label->set_label_for( lr_text ).
  ENDCASE.

* Erzeugtes Top-of.Page übergeben
  CALL METHOD cl_salv_form_content=>set
    EXPORTING
      value = lr_grid.

ENDFORM.                    " build_header_single_list
*&---------------------------------------------------------------------*
*&      Form  show_single_detail
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_single_detail .


  CLEAR:
  gt_einzelanz_mbwl,
  gt_einzelanz_lief, wa_einzelanz_lief,
  gt_einzelanz_kd,   wa_einzelanz_kd,
  gt_einzelanz_auf,  wa_einzelanz_auf .

* Build fieldcat once for man/bukrs/wrk/lgo/cha
  PERFORM build_fieldcat_mbwl.

  IF kz_list <> ek_vk_liste.

    PERFORM einzelanzeige_felder.

    CASE zeilen_kz.
      WHEN ges_zeile.
        PERFORM einzelanzeige_ges_write.
      WHEN man_zeile.
        PERFORM einzelanzeige_man_write.
      WHEN wgr_zeile.
        PERFORM einzelanzeige_wgr_write.
************************site level*************************************
      WHEN wrk_zeile.
        CASE sond_kz.
          WHEN space.
            PERFORM einzelanzeige_wrk_write.
          WHEN beistlief.
            PERFORM einzelanzeige_beistlief_write.
          WHEN konsikunde.
            PERFORM einzelanzeige_konsikunde_write.
          WHEN lrgutkunde.
            PERFORM einzelanzeige_lrgutkunde_write.
        ENDCASE.
*************************storage location level*************************
      WHEN lag_zeile.
        CASE sond_kz.
          WHEN space.
            PERFORM einzelanzeige_lgo_write.
          WHEN aufbskunde.
            PERFORM einzelanzeige_aufbskunde_write.
          WHEN konsilief.
            PERFORM einzelanzeige_konsilief_write.
          WHEN mtverpack.
            PERFORM einzelanzeige_mtverpack_write.
          WHEN beistlief.
            PERFORM einzelanzeige_beistlief_write.
        ENDCASE.
      WHEN ch_zeile.
        CASE sond_kz.
          WHEN space.
            PERFORM einzelanzeige_ch_write.
          WHEN aufbskunde.
            PERFORM einzelanzeige_aufbskunde_write.
          WHEN konsikunde.
            PERFORM einzelanzeige_aufbskunde_write.
          WHEN beistlief.
            PERFORM einzelanzeige_beistlief_write.
        ENDCASE.
    ENDCASE.

  ELSEIF kz_list = ek_vk_liste.

    SET PF-STATUS pfstatus_eman.
    PERFORM ek_vk_anzeige_felder.

    CASE zeilen_kz.
      WHEN man_zeile.
        PERFORM ek_vk_anzeige_man_write.
      WHEN wgr_zeile.
        PERFORM ek_vk_anzeige_wgr_write.
      WHEN wrk_zeile.
        PERFORM ek_vk_anzeige_wrk_write.
    ENDCASE.

  ENDIF.



ENDFORM.                    " show_single_detail
*&---------------------------------------------------------------------*
*&      Form  set_pf_status_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_pf_stat_for_grid USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'ALVPOPUP'. " TGA ACC retail

ENDFORM.                    " set_pf_stat_for_grid
*&---------------------------------------------------------------------*
*&      Form  show_single_special_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_single_special_grid .

  DATA:  lr_columns          TYPE REF TO cl_salv_columns,
         lr_column           TYPE REF TO cl_salv_column,
         lr_content          TYPE REF TO cl_salv_form_layout_grid,
         lr_patern           TYPE REF TO cl_salv_display_settings,
         lr_display_settings TYPE REF TO cl_salv_display_settings,
         lr_sorts            TYPE REF TO cl_salv_sorts,
         l_title             TYPE lvc_title,
         lv_repid            TYPE sy-repid.

  CONSTANTS:   lc_true  TYPE sap_bool VALUE 'X',
               lc_group TYPE salv_de_sort_group VALUE 1.

* Größe POPUP
  DATA:   lv_sc TYPE i VALUE '5',
          lv_ec TYPE i VALUE '70',
          lv_sl TYPE i VALUE '5',
          lv_el TYPE i VALUE '25'.

  FIELD-SYMBOLS: <f> TYPE ANY TABLE.
  DATA: lv_sort1 TYPE lvc_fname,
        lv_sort2 TYPE lvc_fname.

* Je nach Sond-Kz:
* a) Datentabelle assignen
* b) Sortierung festlegen
* c) Titel festlegen
  CASE sond_kz.
    WHEN beistlief OR konsilief OR mtverpack.
      lv_ec = 109.
      ASSIGN gt_einzelanz_lief TO <f>.
      lv_sort1 = 'LIFNR'.
      lv_sort2 = 'LIEFE'.
      CASE sond_kz.
        WHEN beistlief.
          l_title = text-022.
        WHEN konsilief.
          l_title = text-051.
        WHEN mtverpack.
          l_title = text-052.
      ENDCASE.
    WHEN lrgutkunde OR konsikunde.
      lv_ec = 134.
      ASSIGN gt_einzelanz_kd TO <f>.
      lv_sort1 = 'KDNNA'.
      lv_sort2 = 'NAME1'.
      IF sond_kz EQ lrgutkunde.
        l_title = text-024.
      ELSE.
        l_title = text-023.
      ENDIF.
    WHEN aufbskunde.
      ASSIGN gt_einzelanz_auf TO <f>.
      lv_sort1 = 'BELEGNUMR'.
      l_title = text-050.
    WHEN OTHERS.

  ENDCASE.

  lv_repid = sy-repid.

* Create an ALV table as Fullscreen Grid Display.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = <f> ).
    CATCH cx_salv_msg.
    CATCH cx_salv_not_found.
  ENDTRY.

* Register to the events of cl_salv_table
*  DATA: lr_events TYPE REF TO cl_salv_events_table.
*  lr_events = gr_table->get_event( ).
*  CREATE OBJECT gr_events.
** PF-STATUS für konsilief lgort/charg
*  IF sond-kz EQ konsilief.
*    TRY.
*        gr_table->set_screen_status(
*          pfstatus      =  'ALVPOPUP3'
*          report        =   lv_repid
*          set_functions = gr_table->c_functions_all ).
*      CATCH cx_salv_method_not_supported.
*    ENDTRY.
**   Register to the event USER_COMMAND
*    SET HANDLER gr_events->on_user_command FOR lr_events.
*  ENDIF.

** PF-STATUS für konsikunde + charg
*  IF ( zeilen_kz EQ cha_zeile ) AND
*  ( sond-kz EQ konsikunde
*  OR sond-kz EQ beistlief
*  OR sond-kz EQ lrgutkunde ).
*    gr_table->set_screen_status(
*      pfstatus      =  'ALVPOPUP2'
*      report        =   lv_repid
*      set_functions = gr_table->c_functions_all ).
**   Register to the event USER_COMMAND
*    SET HANDLER gr_events->on_user_command FOR lr_events.
*  ENDIF.
*

* Spaltenoptimierung
  TRY.
      lr_columns = gr_table->get_columns(  ).
      lr_column = lr_columns->get_column( 'BSTNDTXT' ).
      lr_column->set_alignment( if_salv_c_alignment=>right ).
    CATCH cx_salv_not_found.
  ENDTRY.

* Set selected columns for the first screen call
  DATA: lr_sel TYPE REF TO cl_salv_selections.
  DATA: ls_rows TYPE lvc_fname,
        lt_rows TYPE salv_t_row.
  lr_sel = gr_table->get_selections( ).
  ls_rows = 1.
  APPEND ls_rows TO lt_rows.
  lr_sel->set_selected_rows( lt_rows ).

* Top_of_list je nach PopUp generieren
  PERFORM build_tol_grid CHANGING lr_content.
  gr_table->set_top_of_list( lr_content ).

* Zebra-Muster setzen
  lr_patern = gr_table->get_display_settings( ).
  lr_patern->set_striped_pattern( abap_true ).

* Spalten sortieren -> Anzeige aufbereiten
  lr_sorts   = gr_table->get_sorts( ).
  lr_sorts->clear( ).
  TRY.
      lr_sorts->add_sort(
       EXPORTING
        columnname = lv_sort1
        position   = 1
        group      = lc_group
         ).
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
    CATCH cx_salv_data_error.
  ENDTRY.
  TRY.
      lr_sorts->add_sort(
    EXPORTING
     columnname = lv_sort2
     position   = 2
      ).
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
    CATCH cx_salv_data_error.
  ENDTRY.

* Titel ds PopUp setzen
  lr_display_settings = gr_table->get_display_settings( ).
  lr_display_settings->set_list_header( l_title ).

* PopUp Koordinaten setzen
  gr_table->set_screen_popup(
    start_column = lv_sc
    end_column   = lv_ec
    start_line   = lv_sl
    end_line     = lv_el ).

* Anzeige des Grids
  gr_table->display( ).

ENDFORM.                    " show_single_special_grid
*&---------------------------------------------------------------------*
*&      Form  build_tol_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_tol_grid CHANGING xr_content
                      TYPE REF TO cl_salv_form_layout_grid.

  DATA: lr_grid    TYPE REF TO cl_salv_form_layout_grid,
        lr_label   TYPE REF TO cl_salv_form_label,
        lr_text    TYPE REF TO cl_salv_form_text,
        lv_bestart TYPE char25.

  CREATE OBJECT lr_grid.

* Bestandsart füllen
  CASE sond_kz.
    WHEN beistlief.
      lv_bestart = text-022.
    WHEN lrgutkunde.
      lv_bestart = text-024.
    WHEN konsikunde.
      lv_bestart = text-045.
    WHEN konsilief.
      lv_bestart = text-051.
    WHEN aufbskunde.
      lv_bestart = text-050.
    WHEN mtverpack.
      lv_bestart = text-052.
    WHEN OTHERS.
  ENDCASE.

* Überschrift für jede SondBestArt
  lr_label  = lr_grid->create_label(
     row     = 1
     column  = 1
     text = text-030 ).
  lr_text = lr_grid->create_text(
     row     = 1
     column  = 2
     text = lv_bestart ).
  lr_label->set_label_for( lr_text ).

* Werk in jedem SondBest vorhanden
  lr_label  = lr_grid->create_label(
     row     = 2
     column  = 1
     text = text-028 ).
  lr_text = lr_grid->create_text(
     row     = 2
     column  = 2
     text = zle-werks ).
  lr_label->set_label_for( lr_text ).

  IF zle-charg IS INITIAL
    AND zle-sgt_scat IS NOT INITIAL.

    lr_label  = lr_grid->create_label(
       row     = 3
       column  = 1
       text = text-118 ).
    lr_text = lr_grid->create_text(
       row     = 3
       column  = 2
       text = zle-sgt_scat ).

   lr_label->set_label_for( lr_text ).

  ELSEIF zle-charg IS NOT INITIAL.

    lr_label  = lr_grid->create_label(
       row     = 3
       column  = 1
       text = text-015 ).
    lr_text = lr_grid->create_text(
       row     = 3
       column  = 2
       text = zle-charg ).

   lr_label->set_label_for( lr_text ).

  ENDIF.

* Lagerort für Lagerort-/Chargenebene und
* nicht für Chargen unter Werk
  IF zeilen_kz EQ lag_zeile.
*    OR zeilen-kz EQ cha_zeile
*    AND wa_outtab-sobkz2 IS INITIAL.
    lr_label  = lr_grid->create_label(
       row     = 3
       column  = 1
       text = text-029 ).
    lr_text = lr_grid->create_text(
       row     = 3
       column  = 2
       text = zle-lgort ).
    lr_label->set_label_for( lr_text ).
  ENDIF.

* Abschließende Übergabe
  xr_content = lr_grid.

ENDFORM.                    " build_tol_grid
*&---------------------------------------------------------------------*
*&      Form  show_comp_stock_grid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_comp_stock_grid .

  DATA: lv_formname  TYPE slis_formname,
        lv_formname2 TYPE slis_formname,
        lv_repid     TYPE sy-repid,
        lv_title     TYPE lvc_title,
        ls_layout    TYPE slis_layout_alv.

* Größe POPUP
  DATA:   lv_sc TYPE i VALUE '10',
          lv_ec TYPE i VALUE '110',
          lv_sl TYPE i VALUE '10',
          lv_el TYPE i VALUE '20'.

* prepare
  SET TITLEBAR 'COM'.

  PERFORM build_fieldcat_comp.

  PERFORM build_comp_mat_stock.

* genral data
  lv_repid = sy-repid.
  lv_formname = 'BUILD_HEADER_COMP'.
  lv_formname2 = 'SET_PF_STAT_FOR_GRID'.
* Layout festlegen.
  ls_layout-zebra = 'X'.
* set tiltebar an text for control
  lv_title = text-040.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = lv_repid
      i_callback_pf_status_set = lv_formname2
      i_callback_top_of_page   = lv_formname
      i_grid_title             = lv_title
      is_layout                = ls_layout
      it_fieldcat              = gt_fieldcat_comp
      i_default                = ' '              "note 2748763
      i_screen_start_column    = lv_sc
      i_screen_start_line      = lv_sl
      i_screen_end_column      = lv_ec
      i_screen_end_line        = lv_el
    TABLES
      t_outtab                 = gt_comp_mat_stock
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CLEAR  gt_comp_mat_stock.
  REFRESH gt_comp_mat_stock.

  IF zeilen_kz = ges_zeile.

  ELSE.
    CASE drilldown_level.
      WHEN artlist_level.
        SET TITLEBAR  'GRU' WITH text-025.
      WHEN einzart_level.
        SET TITLEBAR  'GRU' WITH text-026.
      WHEN einzvar_level.
        SET TITLEBAR  'GRU' WITH text-032.
    ENDCASE.
  ENDIF.

ENDFORM.                    " show_comp_stock_grid
*&---------------------------------------------------------------------*
*&      Form  build_header_comp
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_header_comp .
  DATA: lr_grid  TYPE REF TO cl_salv_form_layout_grid,
        lr_label TYPE REF TO cl_salv_form_label,
        lr_text  TYPE REF TO cl_salv_form_text.

  DATA: l_head_text(55)  TYPE c,
        l_help_text1(17) TYPE c,
        l_help_text2(35) TYPE c.

  READ TABLE grund_anzeige  WITH KEY fname = 'LABST'.
  l_help_text1 = grund_anzeige-text.

  READ TABLE t_t157b INTO s_t157b WITH KEY feldv = 'LABST'.
  IF sy-subrc = 0.
    l_help_text1 = s_t157b-ftext.
  ENDIF.
  l_help_text2 = text-037.
  CONCATENATE l_help_text1 l_help_text2 INTO l_head_text
                                        SEPARATED BY space.
* Objekt erzeugen
  CREATE OBJECT lr_grid.

**   article
*  lr_label = lr_grid->create_label(
*     row     = 1
*     column  = 1
*     text    = text-007 ).
*  lr_text = lr_grid->create_text(
*     row     = 1
*     column  = 2
*     text = zle-matnr ).
*  lr_label->set_label_for( lr_text ).

  CASE zeilen_kz.
*   site level
    WHEN wrk_zeile.
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-028 ).
      lr_text = lr_grid->create_text(
         row     = 2
         column  = 2
         text = zle-werks ).
      lr_label->set_label_for( lr_text ).
*     stock
      lr_label = lr_grid->create_label(
        row     = 3
        column  = 1
        text    = text-030 ).
      lr_text = lr_grid->create_text(
        row     = 3
        column  = 2
        text = l_head_text ).
      lr_label->set_label_for( lr_text ).

*   storage loc level
    WHEN lag_zeile.
      lr_label = lr_grid->create_label(
         row     = 2
         column  = 1
         text    = text-028 ).
      lr_text = lr_grid->create_text(
         row     = 2
         column  = 2
         text = zle-werks ).
      lr_label->set_label_for( lr_text ).

      lr_label = lr_grid->create_label(
         row     = 3
         column  = 1
         text    = text-029 ).
      lr_text = lr_grid->create_text(
         row     = 3
         column  = 2
         text = zle-lgort ).
      lr_label->set_label_for( lr_text ).
*     stock
      lr_label = lr_grid->create_label(
        row     = 4
        column  = 1
        text    = text-030 ).
      lr_text = lr_grid->create_text(
        row     = 4
        column  = 2
        text = l_head_text ).
      lr_label->set_label_for( lr_text ).

  ENDCASE.


* Erzeugtes Top-of.Page übergeben
  CALL METHOD cl_salv_form_content=>set
    EXPORTING
      value = lr_grid.
ENDFORM.                    " build_header_comp
*&---------------------------------------------------------------------*
*&      Form  build_fieldcat_comp
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat_comp .



  FIELD-SYMBOLS: <l_fs_lfc> TYPE slis_fieldcat_alv.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_structure_name       = 'COMP_MAT_STOCK'
    CHANGING
      ct_fieldcat            = gt_fieldcat_comp
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

* Rechtsbündige Daten
*  READ TABLE gt_fieldcat_comp
*  WITH KEY fieldname = 'BSTNDTXT'
*  ASSIGNING <l_fs>.
*  IF sy-subrc = 0.
*    <l_fs>-just = 'R'.
*    UNASSIGN <l_fs>.
*  ENDIF.

  LOOP AT gt_fieldcat_comp ASSIGNING <l_fs_lfc>.

    IF <l_fs_lfc>-fieldname = 'S_MATNR'.
      <l_fs_lfc>-col_pos = '3'.
    ENDIF.

    IF <l_fs_lfc>-fieldname = 'C_BSTNDTXT'.
      <l_fs_lfc>-col_pos = '2'.
    ENDIF.

    CASE <l_fs_lfc>-fieldname .
      WHEN 'S_MATNR'.
        <l_fs_lfc>-seltext_l  = text-079.
        <l_fs_lfc>-seltext_m  = text-079.
        <l_fs_lfc>-seltext_s  = text-079.
      WHEN 'C_MATNR'.
        <l_fs_lfc>-seltext_l  = text-112.
        <l_fs_lfc>-seltext_m  = text-112.
        <l_fs_lfc>-seltext_s  = text-112.
*   when 'C_BSTNDTXT'.
*        <l_fs_lfc>-seltext_l  =
*        <l_fs_lfc>-seltext_m  =
*        <l_fs_lfc>-seltext_s  =
      WHEN 'S_BSTNDTXT'.
        <l_fs_lfc>-seltext_l  = text-039.
        <l_fs_lfc>-seltext_m  = text-039.
        <l_fs_lfc>-seltext_s  = text-039.
      WHEN 'G_BSTNDTXT'.
        <l_fs_lfc>-seltext_l  = text-038.
        <l_fs_lfc>-seltext_m  = text-038.
        <l_fs_lfc>-seltext_s  = text-038.
    ENDCASE.


  ENDLOOP.


ENDFORM.                    " build_fieldcat_comp
*&---------------------------------------------------------------------*
*&      Form  build_comp_mat_stock
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_comp_mat_stock .

  DATA: sav_zeilen_kz LIKE zeilen_kz,
        l_h_matnr     TYPE matnr.


  CLEAR: str_labst.

  sav_zeilen_kz = zeilen_kz.

  LOOP AT sbe.
    IF l_h_matnr <> sbe-comp_matnr.
      CLEAR: com_labst.
      CASE sav_zeilen_kz.
        WHEN wrk_zeile.
          CLEAR wbe.
          READ TABLE wbe WITH KEY matnr =  sbe-comp_matnr
                                  werks = zle-werks.
          READ TABLE cum_comp WITH KEY comp_matnr = sbe-comp_matnr.
          com_labst = cum_comp-labst + wbe-labst.
        WHEN lag_zeile.
          CLEAR lbe.
          READ TABLE lbe WITH KEY matnr = sbe-comp_matnr
                                  werks = zle-werks
                                  lgort = zle-lgort.
          READ TABLE cum_comp WITH KEY comp_matnr = sbe-comp_matnr.
          com_labst = cum_comp-labst + lbe-labst.
      ENDCASE.
* --- display stock of components over all ------------------------*
      WRITE sbe-comp_matnr TO wa_comp_mat_stock-c_matnr.
      MOVE 'COM_LABST' TO sav_fname0.
      PERFORM write_comp_line_cum.
* --- nicht gebunden verf über struct. article---------------------------*
      CASE sav_zeilen_kz.
        WHEN wrk_zeile.
          MOVE 'WBE-LABST' TO sav_fname0.
          PERFORM write_comp_line_comp.
        WHEN lag_zeile.
          MOVE 'LBE-LABST' TO sav_fname0.
          PERFORM write_comp_line_comp.
      ENDCASE.

*      str_labst = cum_comp-labst.
*      MOVE 'STR_LABST' TO sav_fname0.
*      PERFORM write_comp_line_cum.
    ELSE.
      CLEAR: wa_comp_mat_stock.
    ENDIF.
*----components aof struct materials
    WRITE  sbe-stru_matnr TO wa_comp_mat_stock-s_matnr.
    MOVE 'SBE-LABST' TO sav_fname0.

    PERFORM write_comp_line.

    APPEND wa_comp_mat_stock TO gt_comp_mat_stock.

    l_h_matnr = sbe-comp_matnr.

  ENDLOOP.


ENDFORM.                    " build_comp_mat_stock
*&---------------------------------------------------------------------*
*&      Form  set_titlebar_grid1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_titlebar_grid1 CHANGING ch_title TYPE lvc_title.

  IF kz_list <> ek_vk_liste.

    CASE zeilen_kz.
      WHEN man_zeile.
        ch_title = text-014.

        CASE drilldown_level.
          WHEN einzart_level.
            SET TITLEBAR 'EIN' WITH text-014 text-026.
          WHEN einzvar_level.
            SET TITLEBAR 'EIN' WITH text-014 text-032.
        ENDCASE.
*************************site group level*************************
      WHEN wgr_zeile.
        ch_title = text-027.
        CASE drilldown_level.
          WHEN einzart_level.
            SET TITLEBAR 'EIN' WITH text-027 text-026.
          WHEN einzvar_level.
            SET TITLEBAR 'EIN' WITH text-027 text-032.
        ENDCASE.
*************************site level********************************
      WHEN wrk_zeile.
        ch_title = text-028.

        CASE sond_kz.
          WHEN space.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-028 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-028 text-032.
            ENDCASE.

          WHEN beistlief.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-044 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-044 text-032.
            ENDCASE.

          WHEN konsikunde.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-045 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-045 text-032.
              WHEN artlist_level.
            ENDCASE.

          WHEN lrgutkunde.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-046 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-046 text-032.
            ENDCASE.

        ENDCASE.
*************************storage location level*************************
      WHEN lag_zeile.
        ch_title = text-029.

        CASE sond_kz.
          WHEN space.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-029 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-029 text-032.
            ENDCASE.

          WHEN aufbskunde.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-048 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-048 text-032.
            ENDCASE.

          WHEN konsilief.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-047 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-047 text-032.
            ENDCASE.

          WHEN mtverpack.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-049 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-049 text-032.
            ENDCASE.
        ENDCASE.
*************************Batch level*************************
      WHEN ch_zeile.
        ch_title = text-015.

        CASE sond_kz.
          WHEN space.
            CASE drilldown_level.
              WHEN einzart_level.
                IF zle-charg IS INITIAL AND
                   zle-sgt_scat IS NOT INITIAL.
                  IF p_kzseg IS NOT INITIAL.
                    SET TITLEBAR 'EIN' WITH text-118 text-026.
                  ENDIF.
ENHANCEMENT-POINT RWBE1F11_02 SPOTS ES_RWBEST01 .

                ELSE.
                  SET TITLEBAR 'EIN' WITH text-015 text-026.
                ENDIF.
              WHEN einzvar_level.
                IF zle-charg IS INITIAL AND
                   zle-sgt_scat IS NOT INITIAL.
                  IF p_kzseg IS NOT INITIAL.
                    SET TITLEBAR 'EIN' WITH text-118 text-032.
                  ENDIF.
ENHANCEMENT-POINT RWBE1F11_03 SPOTS ES_RWBEST01 .

                ELSE.
                  SET TITLEBAR 'EIN' WITH text-015 text-032.
                ENDIF.
            ENDCASE.

          WHEN aufbskunde.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-048 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-048 text-032.
            ENDCASE.

          WHEN konsikunde.
            CASE drilldown_level.
              WHEN einzart_level.
                SET TITLEBAR 'EIN' WITH text-045 text-026.
              WHEN einzvar_level.
                SET TITLEBAR 'EIN' WITH text-045 text-032.
            ENDCASE.
        ENDCASE.
    ENDCASE.

  ELSEIF kz_list = ek_vk_liste.

    CASE zeilen_kz.
      WHEN man_zeile.
        CASE drilldown_level.
          WHEN einzart_level.
            SET TITLEBAR 'WER' WITH text-014 text-026.
          WHEN einzvar_level.
            SET TITLEBAR 'WER' WITH text-014 text-032.
          WHEN artlist_level.
        ENDCASE.
      WHEN wgr_zeile.
        CASE drilldown_level.
          WHEN einzart_level.
            SET TITLEBAR 'WER' WITH text-027 text-026.
          WHEN einzvar_level.
            SET TITLEBAR 'WER' WITH text-027 text-032.
          WHEN artlist_level.
        ENDCASE.
      WHEN wrk_zeile.
        CASE drilldown_level.
          WHEN einzart_level.
            SET TITLEBAR 'WER' WITH text-028 text-026.
          WHEN einzvar_level.
            SET TITLEBAR 'WER' WITH text-028 text-032.
          WHEN artlist_level.
        ENDCASE.
    ENDCASE.

  ENDIF.

ENDFORM.                    " set_titlebar_grid1
*&---------------------------------------------------------------------*
*&      Form  set_size
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_SC  text
*      <--P_LV_EC  text
*      <--P_LV_SL  text
*      <--P_LV_SE  text
*----------------------------------------------------------------------*
FORM set_size  CHANGING ch_lv_sc TYPE i
                        ch_lv_ec TYPE i
                        ch_lv_sl TYPE i
                        ch_lv_el TYPE i.

  IF kz_list <> ek_vk_liste.
    IF p_kzlso = space.
      ch_lv_sc = 5.
      ch_lv_ec = 70.
      ch_lv_sl = 5.
      ch_lv_el = 20.
    ELSE.
      ch_lv_sc = 5.
      ch_lv_ec = 70.
      ch_lv_sl = 5.
      ch_lv_el = 35.
    ENDIF.

  ELSEIF kz_list = ek_vk_liste.
    ch_lv_sc = 5.
    ch_lv_ec = 70.
    ch_lv_sl = 5.
    ch_lv_el = 15.
  ENDIF.

ENDFORM.                    " set_size
*&---------------------------------------------------------------------*
*&      Form  show_uom_allowed
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_MEINS_NEU  text
*----------------------------------------------------------------------*
FORM show_uom_allowed  CHANGING ch_meins_neu TYPE meins.

  DATA: ret_list TYPE c.
  DATA: lt_fieldcat_metexte TYPE slis_t_fieldcat_alv.
  DATA: lv_selfield TYPE slis_selfield.
  DATA: wa_allowed_uom LIKE LINE OF gt_allowed_uom.

  CLEAR: ch_meins_neu,
         lt_fieldcat_metexte,
         gt_allowed_uom.

*---- display fields arrange -----------------------------*
  CLEAR   t_fields.
  REFRESH t_fields.
  t_fields-tabname    = 'T006A'.
  t_fields-fieldname  = 'MSEHI'.
  t_fields-selectflag = 'X'.
  APPEND t_fields.
  t_fields-tabname    = 'T006A'.
  t_fields-fieldname  = 'MSEHL'.
  t_fields-selectflag = ' '.
  APPEND t_fields.

*---- display values arrange ------------------------------*
  CLEAR   t_values.
  REFRESH t_values.
  LOOP AT t_meeinh WHERE matnr = t_matnr-matnr.
    READ TABLE t_metext WITH KEY meinh = t_meeinh-meinh
                        BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_METEXT'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
    wa_allowed_uom-meinh = t_metext-meinh.
    wa_allowed_uom-msehl = t_metext-msehl.
    APPEND wa_allowed_uom TO gt_allowed_uom.
  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
*     I_INTERNAL_TABNAME     =
      i_structure_name       = 'RMMMBESTN_POPUP_METEXTE'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      ct_fieldcat            = lt_fieldcat_metexte
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title            = text-061
      i_selection        = 'X'
*     I_ALLOW_NO_SELECTION          =
      i_zebra            = 'X'
*     i_screen_start_column         = 5
*     i_screen_start_line           = 5
*     i_screen_end_column           = 30
*     i_screen_end_line  = 25
*     I_CHECKBOX_FIELDNAME          =
*     I_LINEMARK_FIELDNAME          =
*     I_SCROLL_TO_SEL_LINE          = 'X'
      i_tabname          = 'METEXTE'
*     I_STRUCTURE_NAME   =
      it_fieldcat        = lt_fieldcat_metexte
*     IT_EXCLUDING       =
      i_callback_program = sy-repid
*     i_callback_user_command       = 'FCODE_HANDLING'
*     IS_PRIVATE         =
    IMPORTING
      es_selfield        = lv_selfield
*     E_EXIT             =
    TABLES
      t_outtab           = gt_allowed_uom
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Übergabe des selektierten Feldes
  READ TABLE gt_allowed_uom INDEX lv_selfield-tabindex INTO wa_allowed_uom.
  SELECT * FROM t006a                                                "Note 1803863
    WHERE spras = sy-langu                                           "Note 1803863
      AND msehi = wa_allowed_uom-meinh.                              "Note 1803863
  ENDSELECT.                                                         "Note 1803863
  meins_neu = t006a-mseh3.                                           "Note 1803863

ENDFORM.                    " show_uom_allowed
*&---------------------------------------------------------------------*
*&      Form  write_comp_line_comp
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_comp_line_comp .
  ASSIGN (sav_fname0) TO <f0>.
  PERFORM umschluesseln_einzelbestand.

  IF p_kzngc IS INITIAL.
    WRITE  <d0>  TO wa_comp_mat_stock-c_bstndtxt.
  ELSE.
    WRITE <d0>  UNIT t_matnr-meins TO wa_comp_mat_stock-c_bstndtxt.
  ENDIF.

ENDFORM.                    " write_comp_line_comp

*&---------------------------------------------------------------------*
*&      Form  write_comp_line_cum
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_comp_line_cum .
  ASSIGN (sav_fname0) TO <f0>.
  PERFORM umschluesseln_einzelbestand.

  IF p_kzngc IS INITIAL.
    WRITE  <d0>  TO wa_comp_mat_stock-g_bstndtxt.
  ELSE.
    WRITE <d0>  UNIT t_matnr-meins TO wa_comp_mat_stock-g_bstndtxt.
  ENDIF.

ENDFORM.                    " write_comp_line_cum
