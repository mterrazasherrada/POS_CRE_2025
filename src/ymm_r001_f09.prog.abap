*----------------------------------------------------------------------*
*   INCLUDE RWBE1F09                                                   *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SHOW_STOCKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM show_stocks.
* call screen for maintree
  IF p_kzalv IS INITIAL.
    CALL SCREEN 800.
  ELSE.
    CALL SCREEN 801.
  ENDIF.

ENDFORM.                               " SHOW_STOCKS
*&---------------------------------------------------------------------*
*&      Form  INIT_MATTREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM init_mattree USING p_var_tree TYPE c.  "tga unicode

  DATA: l_tree_container_name(30) TYPE c,
        lv_tree_container_name(30) TYPE c.
* name of tree containers
  l_tree_container_name  = 'MATTREE1'. "mainmattree
  lv_tree_container_name = 'MATTREE2'. "variants mattree
* set basics for ALV Layout if nothing else done before
  IF ls_variant IS INITIAL.
    ls_variant-report = sy-repid.
  ENDIF.
* build fieldcatalog, noting if storage location or site level is
* chosen for display level
  IF gt_fieldcat IS INITIAL.
    PERFORM build_fieldcat USING p_kzlgo.
  ENDIF.
* prepare tree for outtab
  IF p_var_tree = yes.
    PERFORM build_mattree2 USING ls_variant lv_tree_container_name.
  ELSE.
    PERFORM build_mattree1 USING ls_variant l_tree_container_name.
  ENDIF.

ENDFORM.                               " INIT_MATTREE

*&---------------------------------------------------------------------*
*&      Form  BUILD_HIERARCHY_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_L_HIERARCHY_HEADER  text
*----------------------------------------------------------------------*
FORM build_hierarchy_header CHANGING p_l_hierarchy_header
                            TYPE treev_hhdr.

  p_l_hierarchy_header-heading = text-106. " 'Gesamt/BWGrp/Wrk/Lgort

  p_l_hierarchy_header-tooltip = text-107.

  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
    p_l_hierarchy_header-heading = text-115.
    p_l_hierarchy_header-tooltip = text-116.
  ENDIF.

  p_l_hierarchy_header-width = 25.
  p_l_hierarchy_header-width_pix = ' '.

ENDFORM.                               " BUILD_HIERARCHY_HEADER

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat USING p_p_kzlgo LIKE rmmmb-kzlgo.

* p_kzlgo  kennzeichen lagerort mitanzeigen
  DATA: h_index LIKE sy-index VALUE 1.
  CLEAR: gs_fieldcat.
  gs_fieldcat-fieldname    =  'MATNR'.
* gs_fieldcat-ref_field    =  'MATNR'.
* gs_fieldcat-ref_table    =  'MARA'.
  gs_fieldcat-key          =  'X'.
  gs_fieldcat-tech         =  'X'.
  gs_fieldcat-no_out       =  'X'.
* gs_fieldcat-row_pos      =  '1'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.

  gs_fieldcat-fieldname    =  'BWGRP'.
* gs_fieldcat-ref_field    =  'BWGRP'.
* gs_fieldcat-ref_table    =  'RWBWG'.
  gs_fieldcat-key          =  'X'.
  gs_fieldcat-tech         =  'X'.
  gs_fieldcat-no_out       =  'X'.
* gs_fieldcat-row_pos      =  '1'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.

  IF p_chrg IS NOT INITIAL.
    gs_fieldcat-fieldname    =  'WERKS'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.

    gs_fieldcat-fieldname    =  'LGORT'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    CLEAR gs_fieldcat.
    h_index = h_index + 1.

    gs_fieldcat-fieldname    =  'CHARG'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    CLEAR gs_fieldcat.
    h_index = h_index + 1.

    gs_fieldcat-fieldname    =  'SGT_SCAT'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  CLEAR gs_fieldcat.
  h_index = h_index + 1.

* p_p_kzlgo  flag storage location is included
  ELSEIF  p_p_kzlgo = 'X'.
    gs_fieldcat-fieldname    =  'WERKS'.
*   gs_fieldcat-ref_field    =  'WERKS'.
*   gs_fieldcat-ref_table    =  'MARCV'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
* gs_fieldcat-row_pos      =  '1'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.

    gs_fieldcat-fieldname    =  'EX_LGORT'.
*   gs_fieldcat-ref_table    =  'MARD'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    CLEAR gs_fieldcat.
    h_index = h_index + 1.
  ELSE.
    gs_fieldcat-fieldname    =  'EX_WERKS'.
*   gs_fieldcat-ref_table    =  'MARCV'.
*   gs_fieldcat-inttype      =  'C'.
    gs_fieldcat-key          =  'X'.
    gs_fieldcat-tech         =  'X'.
    gs_fieldcat-no_out       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
    CLEAR gs_fieldcat.
  ENDIF.

  gs_fieldcat-fieldname    =  'MEINH'.
* gs_fieldcat-ref_field    =  'MEINH'.
* gs_fieldcat-ref_table    =  'MARM'.
  gs_fieldcat-coltext      =   text-083.
  gs_fieldcat-seltext      =   text-016.
  gs_fieldcat-scrtext_l    =   text-016.
  gs_fieldcat-outputlen    =  '5'.
  gs_fieldcat-convexit     =  'CUNIT'.                    "note 1666055
* gs_fieldcat-emphasize    =  'C311'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  CLEAR gs_fieldcat.
  h_index = h_index + 1.

*  LVORM                   "Löschvormerkung
  gs_fieldcat-fieldname    =  'LVORM'.
*  gs_fieldcat-inttype      =  'CHAR'.
  gs_fieldcat-dd_roll      =  'KKGCH3'.
  gs_fieldcat-outputlen    =  '5'.
  gs_fieldcat-coltext      =  text-105.
  gs_fieldcat-seltext      =  text-105.
  gs_fieldcat-scrtext_l    =  text-105.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  CLEAR gs_fieldcat.
  h_index = h_index + 1.

* description of different objects  (mat., site, ...)
  gs_fieldcat-fieldname    =  'NAME1'.
*  gs_fieldcat-ref_field    =  'NAME1'.
*  gs_fieldcat-ref_table    =  'MARCV'.
  gs_fieldcat-coltext      =   text-080.
  gs_fieldcat-seltext      =   text-080.
  gs_fieldcat-scrtext_l    =   text-080.
  gs_fieldcat-outputlen    =  '20'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  CLEAR gs_fieldcat.
  h_index = h_index + 1.

ENHANCEMENT-POINT RWBE1F09_G1 SPOTS ES_RWBEST01 .

  gs_fieldcat-fieldname    =  'LABST'.
  gs_fieldcat-ref_field    =  'LABST'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
  gs_fieldcat-no_zero      =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
* CLEAR gs_fieldcat.
  h_index = h_index + 1.

  gs_fieldcat-fieldname    =  'UMLME'.
  gs_fieldcat-ref_field    =  'UMLME'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
* gs_fieldcat-row_pos      =  '1'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
* CLEAR gs_fieldcat.
  h_index = h_index + 1.
*
  gs_fieldcat-fieldname    =  'INSME'.
  gs_fieldcat-ref_field    =  'INSME'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.

  gs_fieldcat-fieldname    =  'EINME'.
  gs_fieldcat-ref_field    =  'EINME'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.
*
  gs_fieldcat-fieldname    =  'SPEME'.
  gs_fieldcat-ref_field    =  'SPEME'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.

  gs_fieldcat-fieldname    =  'RETME'.
  gs_fieldcat-ref_field    =  'RETME'.
  gs_fieldcat-ref_table    =  'MARD'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.
*  IF  p_p_kzlgo NE 'X'.
  gs_fieldcat-fieldname    =  'UMLMC'.
  gs_fieldcat-ref_field    =  'UMLMC'.
  gs_fieldcat-ref_table    =  'MARC'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.

  gs_fieldcat-fieldname    =  'TRAME'.
  gs_fieldcat-ref_field    =  'TRAME'.
  gs_fieldcat-ref_table    =  'MARC'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.
*****************online stocks******************************************
  IF p_kzlon  = 'X'.
    gs_fieldcat-fieldname    =  'TRASF'.
    gs_fieldcat-ref_field    =  'TRASF'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*  WE-Sperrbestand
    gs_fieldcat-fieldname    =  'WESPB'.
    gs_fieldcat-ref_field    =  'WESBS'.
    gs_fieldcat-ref_table    =  'EKBE'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Kundenanfragen
    gs_fieldcat-fieldname    =  'VBMNA'.
    gs_fieldcat-ref_field    =  'VBMNA'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Angebote an Kunden
    gs_fieldcat-fieldname    =  'VBMNB'.
    gs_fieldcat-ref_field    =  'VBMNB'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Kundenaufträge
    gs_fieldcat-fieldname    =  'VBMNC'.
    gs_fieldcat-ref_field    =  'VBMNC'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Kundenlieferpläne
    gs_fieldcat-fieldname    =  'VBMNE'.
    gs_fieldcat-ref_field    =  'VBMNE'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Kundenkontrakte
    gs_fieldcat-fieldname    =  'VBMNG'.
    gs_fieldcat-ref_field    =  'VBMNG'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Kostenlose Lieferung an Kund
    gs_fieldcat-fieldname    =  'VBMNI'.
    gs_fieldcat-ref_field    =  'VBMNI'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Lieferungen an Kunden
    gs_fieldcat-fieldname    =  'OMENG'.
    gs_fieldcat-ref_field    =  'OMENG'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* offener Bestellbestand
    gs_fieldcat-fieldname    =  'MENGE'.
    gs_fieldcat-ref_field    =  'MENGE'.
    gs_fieldcat-ref_table    =  'EKPO'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Offener Bestell. Konsilief
    gs_fieldcat-fieldname    =  'MENGK'.
    gs_fieldcat-ref_field    =  'MENGK'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* Reservierter Bestand
    gs_fieldcat-fieldname    =  'BDMNG'.
    gs_fieldcat-ref_field    =  'BDMNG'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       BDMNS TYPE F,                 "Geplante Zugänge (Sollreserv
    gs_fieldcat-fieldname    =  'BDMNS'.
    gs_fieldcat-ref_field    =  'BDMNS'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*  IF  p_p_kzlgo NE 'X'.
*       BSABR TYPE F,                 "Abrufe UL-Bestellungen
    gs_fieldcat-fieldname    =  'BSABR'.
    gs_fieldcat-ref_field    =  'BSABR'.
    gs_fieldcat-ref_table    =  'RMMMB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
  ENDIF.
***********************special stocks**********************************
  IF p_kzlso = 'X'.
*       FAMNG TYPE F,                 "FAUF-Menge
*  gs_fieldcat-fieldname    =  'FAMNG'.
*  gs_fieldcat-ref_field    =  'FAMNG'.
*  gs_fieldcat-ref_table    =  'RMMMB'.
*  ENDIF.
*       KLABS TYPE F,                 "L.Konsi. frei verwendbar
    gs_fieldcat-fieldname    =  'KLABS'.
    gs_fieldcat-ref_field    =  'KLABS'.
    gs_fieldcat-ref_table    =  'MARD'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KINSM TYPE F,                 "L.Konsi. in Qualitätsprüfung
    gs_fieldcat-fieldname    =  'KINSM'.
    gs_fieldcat-ref_field    =  'KINSM'.
    gs_fieldcat-ref_table    =  'MARD'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KEINM TYPE F,                 "L.Konsi. eingeschränkt verw.
    gs_fieldcat-fieldname    =  'KEINM'.
    gs_fieldcat-ref_field    =  'KEINM'.
    gs_fieldcat-ref_table    =  'MARD'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KSPEM TYPE F,                 "L.Konsi. gesperrt
    gs_fieldcat-fieldname    =  'KSPEM'.
    gs_fieldcat-ref_field    =  'KSPEM'.
    gs_fieldcat-ref_table    =  'MARD'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.

*        CALAB TYPE F,                 "K.A.Best. beim Lief. fr. verw
* gs_fieldcat-fieldname    =  'CALAB'.
* gs_fieldcat-ref_field    =  'CALAB'.
* gs_fieldcat-ref_table    =  'MSCA'.
* gs_fieldcat-do_sum       =  'X'.
* INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
* h_index = h_index + '1'.
*        CAINS TYPE F,                 "K.A.Best. beim Lief. QualPrf.
* gs_fieldcat-fieldname    =  'CAINS'.
* gs_fieldcat-ref_field    =  'CAINS'.
* gs_fieldcat-ref_table    =  'MSCA'.
* gs_fieldcat-do_sum       =  'X'.
* INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
* h_index = h_index + '1'.

*       KALAB TYPE F,                 "K.Auftr.Best. frei verwendbar
    gs_fieldcat-fieldname    =  'KALAB'.
    gs_fieldcat-ref_field    =  'KALAB'.
    gs_fieldcat-ref_table    =  'MSKA'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KAINS TYPE F,                 "K.Auftr.Best. Qualitätsprüfg.
    gs_fieldcat-fieldname    =  'KAINS'.
    gs_fieldcat-ref_field    =  'KAINS'.
    gs_fieldcat-ref_table    =  'MSKA'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KASPE TYPE F,                 "K.Auftr.Best. Sperrbestand
    gs_fieldcat-fieldname    =  'KASPE'.
    gs_fieldcat-ref_field    =  'KASPE'.
    gs_fieldcat-ref_table    =  'MSKA'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       KAEIN TYPE F,                 "K.Auftr.Best. eing. verw.
*                                     "MTV = Mehrwegtransportverpackung
    gs_fieldcat-fieldname    =  'KAEIN'.
    gs_fieldcat-ref_field    =  'KAEIN'.
    gs_fieldcat-ref_table    =  'MSKA'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
************************************************************************
*        KULAV TYPE F,                 "K.Leergut frei verwendbar
    gs_fieldcat-fieldname    =  'KULAV'.
    gs_fieldcat-ref_field    =  'KULAB'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        KUINV TYPE F,                 "K.Leergut Qualitätsprüfung
    gs_fieldcat-fieldname    =  'KUINV'.
    gs_fieldcat-ref_field    =  'KUINS'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        KUEIV TYPE F,                 "K.Leergut eing. verw.
    gs_fieldcat-fieldname    =  'KUEIV'.
    gs_fieldcat-ref_field    =  'KUEIN'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        KULAW TYPE F,                 "K.Konsign. frei verwendbar
    gs_fieldcat-fieldname    =  'KULAW'.
    gs_fieldcat-ref_field    =  'KULAB'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        KUINW TYPE F,                 "K.Konsign. Qualitätsprüfung
    gs_fieldcat-fieldname    =  'KUINW'.
    gs_fieldcat-ref_field    =  'KUINS'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        KUEIW TYPE F,                 "K.Konsign. eing. verw.
    gs_fieldcat-fieldname    =  'KUEIW'.
    gs_fieldcat-ref_field    =  'KUEIN'.
    gs_fieldcat-ref_table    =  'MSKU'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        LBLAB TYPE F,                 "L.Beistellung frei verwendbar
    gs_fieldcat-fieldname    =  'LBLAB'.
    gs_fieldcat-ref_field    =  'LBLAB'.
    gs_fieldcat-ref_table    =  'MSLB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        LBINS TYPE F,                 "L.Beistellung Qualitätsprüfg.
    gs_fieldcat-fieldname    =  'LBINS'.
    gs_fieldcat-ref_field    =  'LBINS'.
    gs_fieldcat-ref_table    =  'MSLB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*        LBEIN TYPE F,                 "L.Beistellung eing. verw.
    gs_fieldcat-fieldname    =  'LBEIN'.
    gs_fieldcat-ref_field    =  'LBEIN'.
    gs_fieldcat-ref_table    =  'MSLB'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
************************************************************************
*       MLABS TYPE F,                 "MTV frei verwendbar
    gs_fieldcat-fieldname    =  'MLABS'.
    gs_fieldcat-ref_field    =  'SLABS'.
    gs_fieldcat-ref_table    =  'MKOL'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       MINSM TYPE F,                 "MTV in Qualitätsprüfung
    gs_fieldcat-fieldname    =  'MINSM'.
    gs_fieldcat-ref_field    =  'SINSM'.
    gs_fieldcat-ref_table    =  'MKOL'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       MEINM TYPE F,                 "MTV eingeschränkt verw.
    gs_fieldcat-fieldname    =  'MEINM'.
    gs_fieldcat-ref_field    =  'SEINM'.
    gs_fieldcat-ref_table    =  'MKOL'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
*       MSPEM TYPE F,                 "MTV gesperrt
    gs_fieldcat-fieldname    =  'MSPEM'.
    gs_fieldcat-ref_field    =  'SSPEM'.
    gs_fieldcat-ref_table    =  'MKOL'.
    gs_fieldcat-do_sum       =  'X'.
    INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
    h_index = h_index + 1.
* no project stocks
*       PRLAB TYPE F,                 "Projektbest. frei verwendbar
*  gs_fieldcat-fieldname    =  'PRLAB'.
*  gs_fieldcat-ref_field    =  'PRLAB'.
*  gs_fieldcat-ref_table    =  'MSPR'.
*       PRINS TYPE F,                 "Projektbest. Qualitätsprüfg.
*  gs_fieldcat-fieldname    =  'PRINS'.
*  gs_fieldcat-ref_field    =  'PRINS'.
*  gs_fieldcat-ref_table    =  'MSPR'.
*       PRSPE TYPE F,                 "Projektbest. Sperrbestand
*  gs_fieldcat-fieldname    =  'PRSPE'.
*  gs_fieldcat-ref_field    =  'PRSPE'.
*  gs_fieldcat-ref_table    =  'MSPR'.
*       PREIN TYPE F,                 "Projektbest. eing. verwendb.
*  gs_fieldcat-fieldname    =  'PREIN'.
*  gs_fieldcat-ref_field    =  'PREIN'.
*  gs_fieldcat-ref_table    =  'MSPR'.
*  IF  p_p_kzlgo NE 'X'.
  ENDIF.
*   GLGMG                  "Gebundene Leergutmenge
  gs_fieldcat-fieldname    =  'GLGMG'.
  gs_fieldcat-ref_field    =  'GLGMG'.
  gs_fieldcat-ref_table    =  'MARC'.
  gs_fieldcat-do_sum       =  'X'.
  INSERT gs_fieldcat INTO gt_fieldcat INDEX h_index.
  h_index = h_index + 1.
  CLEAR gs_fieldcat.


  CLEAR gs_fieldcat.
  PERFORM column_txt TABLES   gt_fieldcat
                     CHANGING gs_fieldcat.

ENDFORM.                               " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  BUILD_MATTREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_VARIANT  text
*      -->P_L_TREE_CONTAINER_NAME  text
*----------------------------------------------------------------------*
FORM build_mattree1 USING    p_ls_variant TYPE disvariant
                             p_l_tree_container_name TYPE any. "tga unicode
  DATA: l_custom_container TYPE REF TO cl_gui_custom_container,
        l_hierarchy_header TYPE treev_hhdr.
*create custom container
  IF  l_custom_container IS INITIAL.
    CREATE OBJECT l_custom_container
          EXPORTING
             container_name = p_l_tree_container_name
          EXCEPTIONS
              cntl_error                  = 1
              cntl_system_error           = 2
              create_error                = 3
              lifetime_error              = 4
              lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
* create tree control
    CREATE OBJECT mattree1
       EXPORTING
          parent              = l_custom_container
          node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
          item_selection      = 'X'
          no_html_header      = 'X'
          no_toolbar          = ''
         EXCEPTIONS
          cntl_error                   = 1
          cntl_system_error            = 2
          create_error                 = 3
          lifetime_error               = 4
          illegal_node_selection_mode  = 5
          failed                       = 6
          illegal_column_name          = 7.
  ENDIF.
  IF sy-subrc NE 0.
    MESSAGE a096.
  ENDIF.
*first column header
  PERFORM build_hierarchy_header CHANGING l_hierarchy_header.
* different outtabs for on batch or stock category level
  IF p_kzcha EQ 'X'
  OR p_kzseg EQ 'X'.
* create empty tree-control
    CALL METHOD mattree1->set_table_for_first_display
         EXPORTING
                 is_hierarchy_header  = l_hierarchy_header
*                it_list_commentary   = lt_list_commentary
*                i_logo               = l_logo
*                i_background_id      = 'ALV_BACKGROUND'
                 i_save = x_save
                 is_variant = p_ls_variant
          CHANGING
                 it_outtab       = gt_cbe    "table must be empty !!
                 it_fieldcatalog = gt_fieldcat.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
* different outtabs for on site or storage loc level
  ELSEIF  p_kzlgo NE 'X'
  AND     p_chrg  NE 'X'.
* create empty tree-control
    CALL METHOD mattree1->set_table_for_first_display
         EXPORTING
                 is_hierarchy_header  = l_hierarchy_header
*                it_list_commentary   = lt_list_commentary
*                i_logo               = l_logo
*                i_background_id      = 'ALV_BACKGROUND'
                 i_save = x_save
                 is_variant = p_ls_variant
          CHANGING
                 it_outtab       = gt_wbe    "table must be empty !!
                 it_fieldcatalog = gt_fieldcat.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
  ELSEIF p_kzlgo EQ 'X'
  AND    p_chrg  NE 'X'.
* create empty tree-control
    CALL METHOD mattree1->set_table_for_first_display
         EXPORTING
                 is_hierarchy_header  = l_hierarchy_header
*              it_list_commentary   = lt_list_commentary
*               i_logo               = l_logo
*               i_background_id      = 'ALV_BACKGROUND'
                 i_save = x_save
                 is_variant = p_ls_variant
          CHANGING
                 it_outtab       = gt_lbe    "table must be empty !!
                 it_fieldcatalog = gt_fieldcat.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
  ENDIF.
ENHANCEMENT-POINT RWBE1F09_G4 SPOTS ES_RWBEST01 .

ENDFORM.                               " BUILD_MATTREE1

*&---------------------------------------------------------------------*
*&      Form  CREATE_MATHIERARCHIE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_mathierarchie.
* prepare for display, create different outtabs depending on
* display level
  REFRESH: t_wbe, t_lbe, t_cbe.
  IF var_tree = yes.
    PERFORM build_outtab_tree2 TABLES t_wbe t_lbe.
  ELSE.
    IF gv_tree IS INITIAL.
      PERFORM build_outtab_tree1 TABLES t_wbe t_lbe t_cbe.
    ELSE.
      PERFORM build_gen_outtab_tree1 TABLES t_wbe t_lbe t_cbe.
    ENDIF.
  ENDIF.
  IF p_kzcha NE space
  OR p_kzseg NE space.
    IF NOT t_cbe IS INITIAL.
      IF gv_tree IS INITIAL.
        SORT t_cbe ASCENDING
                   BY matnr bwgrp werks ex_lgort-lgort
                      ex_lgort-lgortkz ex_lgort-sondcha
                      sgt_scat charg.
        PERFORM provide_mattree TABLES t_wbe t_lbe t_cbe.
      ELSE.
        SORT t_cbe ASCENDING
                   BY satnr matnr bwgrp werks ex_lgort-lgort
                      ex_lgort-lgortkz ex_lgort-sondcha
                      sgt_scat charg.
        PERFORM provide_gen_mattree TABLES t_wbe t_lbe t_cbe.
      ENDIF.
   ELSE.
      MESSAGE i098.
      PERFORM exit_program.
    ENDIF.
  ELSEIF p_kzlgo EQ space
  AND    p_chrg  EQ space.
    IF NOT t_wbe IS INITIAL.
      IF gv_tree IS INITIAL.
        SORT t_wbe ASCENDING BY matnr bwgrp ex_werks-werks
                                          ex_werks-sondcha.
        PERFORM provide_mattree TABLES t_wbe t_lbe t_cbe.
      ELSE.
        SORT t_wbe ASCENDING BY satnr matnr bwgrp ex_werks-werks
                                          ex_werks-sondcha.
        PERFORM provide_gen_mattree TABLES t_wbe t_lbe t_cbe.
      ENDIF.
    ELSE.
      MESSAGE i098.
      PERFORM exit_program.
    ENDIF.
  ELSEIF p_kzlgo NE space
  AND    p_chrg  EQ space.
    IF NOT t_lbe IS INITIAL.
      IF gv_tree IS INITIAL.
        SORT t_lbe ASCENDING BY matnr bwgrp werks ex_lgort-lgort
                                ex_lgort-lgortkz ex_lgort-sondcha.
        PERFORM provide_mattree TABLES t_wbe t_lbe t_cbe.
      ELSE.
        SORT t_lbe ASCENDING BY satnr matnr bwgrp werks ex_lgort-lgort
                                ex_lgort-lgortkz ex_lgort-sondcha.
        PERFORM provide_gen_mattree TABLES t_wbe t_lbe t_cbe.
      ENDIF.
    ELSE.
      MESSAGE i098.
      PERFORM exit_program.
    ENDIF.
  ENDIF.

ENHANCEMENT-POINT RWBE1F09_G7 SPOTS ES_RWBEST01 .

ENDFORM.                               " CREATE_MATHIERARCHIE

*&---------------------------------------------------------------------*
*&      Form  BUILD_OUTTAB_TREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_outtab_tree1 TABLES p_t_wbe TYPE t_wbe
                               p_t_lbe TYPE t_lbe
                               p_t_cbe TYPE t_cbe.

  DATA: h_index LIKE sy-index,
        ls_hierarchy_header TYPE treev_hhdr,
        lt_fieldcatalog     TYPE lvc_t_fcat,
        ls_fieldcatalog     TYPE lvc_s_fcat,
        gen_exist,           "exists generic article ?
        spec_exist.          " special stocks found
  DATA: BEGIN OF lt_lbe OCCURS 0.
          INCLUDE STRUCTURE lbe.
  DATA: END   OF lt_lbe.

  REFRESH: p_t_wbe, p_t_lbe , p_t_cbe.
* in the following the outtab which will be given to the tree control
* will be build on site or storage location level
  LOOP AT t_matnr.
    CLEAR gen_exist.
    IF t_matnr-attyp = attyp_var.
      READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr BINARY SEARCH
                        TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        gen_exist = yes.
      ENDIF.
    ENDIF.
****** Stock segment level
   IF  p_chrg EQ 'X' AND gen_exist IS INITIAL.
*If batch stock exist for the material
* for first display no variants if the gen. art. is also selected
      READ TABLE cbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT cbe FROM h_index.
        IF cbe-matnr NE t_matnr-matnr.
          EXIT.
        ENDIF.
        CLEAR s_cbe.
ENHANCEMENT-SECTION RWBE1F09_G2 SPOTS ES_RWBEST01 .
        MOVE-CORRESPONDING cbe TO s_cbe.
        READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                werks = s_cbe-werks BINARY SEARCH.
        IF sy-subrc = 0.
          s_cbe-bwgrp = wbe-bwgrp.
        ELSE.
           CHECK 'x' = 'y'.     "leave current loop pass
        ENDIF.
        IF p_kzcha EQ 'X'.
          CLEAR s_cbe-sgt_scat.
        ENDIF.

        IF p_kzlso = 'X'.       "Special Stock
          PERFORM provide_sp_charg TABLES    p_t_cbe
                                   CHANGING  s_cbe spec_exist.
        ENDIF.

        IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
          PERFORM checknull_charg USING s_cbe.
        ELSE.
          nullcheck = '1'.
        ENDIF.

        IF NOT nullcheck IS INITIAL.
        s_cbe-ex_lgort-lgortkz = norm_sl.
        s_cbe-ex_lgort-lgort   = cbe-lgort.
        s_cbe-ex_lgort-sondcha = space.

        INSERT s_cbe INTO p_t_cbe INDEX 1.
        ENDIF.
END-ENHANCEMENT-SECTION.
      ENDLOOP.
      IF p_kzsea IS INITIAL.
        lt_lbe[] = lbe[].
        CLEAR s_cbe.
        IF p_t_cbe[] IS NOT INITIAL.
          LOOP AT p_t_cbe INTO s_cbe WHERE matnr = t_matnr-matnr.
            READ TABLE lt_lbe WITH KEY matnr = s_cbe-matnr
                                       werks = s_cbe-werks
                                       lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
            IF sy-subrc = 0.
              DELETE TABLE lt_lbe FROM lt_lbe.
            ENDIF.
          ENDLOOP.
        ENDIF.
*If batch stock not exist for the material will display plant level stock
        READ TABLE lt_lbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
        h_index = sy-tabix.
        LOOP AT lt_lbe FROM h_index.
            IF lt_lbe-matnr NE t_matnr-matnr.
               EXIT.
            ENDIF.
            CLEAR: nullcheck, s_cbe, spec_exist.
            MOVE-CORRESPONDING lt_lbe TO s_cbe.
*    here the special stocks are processed
            IF  p_kzlso = 'X'.
              PERFORM provide_sp_charg TABLES p_t_cbe
                                       CHANGING s_cbe spec_exist.
            ENDIF.
*      zerocheck for 'normal' stocks if no special stock exists
            IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
              PERFORM checknull_charg USING s_cbe.
            ELSE.
              nullcheck = '1'.
            ENDIF.
            IF NOT nullcheck IS INITIAL.
              READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                      werks = s_cbe-werks BINARY SEARCH.
              IF sy-subrc = 0.
                s_cbe-bwgrp = wbe-bwgrp.
              ELSE.
                 CHECK 'x' = 'y'.     "leave current loop pass
              ENDIF.
*    normal stocks of lgort ( sl )
              s_cbe-ex_lgort-lgort   = lt_lbe-lgort.
              s_cbe-ex_lgort-lgortkz = norm_sl."normaler Lagerort
              s_cbe-ex_lgort-sondcha = space.

              INSERT s_cbe INTO p_t_cbe INDEX 1.
            ENDIF.
        ENDLOOP.
* sites without stocks should be shown, wbe without stocks needed
* no mard existing for the site
        IF p_kznul IS INITIAL.
          PERFORM wrk_zerostocks_cbe USING t_matnr-matnr.
        ENDIF.
* here the werks only stocks are given to the outtab ( werks only means
* stocks on site level which can exist also on storage loc level )
* these stocks are necessary for the cumulation on higher levels
        LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = t_matnr-matnr.
          CLEAR s_cbe.
          MOVE-CORRESPONDING s_w_lbe TO s_cbe.
          READ TABLE wbe WITH KEY matnr = s_w_lbe-matnr
                                  werks = s_w_lbe-werks BINARY SEARCH.
          IF sy-subrc = 0.
            s_cbe-bwgrp = wbe-bwgrp.
          ELSE.
             CHECK 'x' = 'y'.
          ENDIF.
          s_cbe-ex_lgort-lgort   = '0000'.
          s_cbe-ex_lgort-lgortkz = no_sl."normaler Lagerort
          s_cbe-ex_lgort-sondcha = space.

          INSERT s_cbe INTO p_t_cbe INDEX 1.
        ENDLOOP.
      ELSE.
ENHANCEMENT-POINT RWBE1F09_09 SPOTS ES_RWBEST01 .

      ENDIF.
****** here the site site level
   ELSEIF p_kzlgo NE 'X' AND gen_exist IS INITIAL.
* for first display no variants if the gen. art. is also selected
      READ TABLE wbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT wbe FROM h_index.
        IF wbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
* tga note 356164
        CLEAR: nullcheck, spec_exist, s_wbe.
*       CLEAR: nullcheck, spec_exist.
        MOVE-CORRESPONDING wbe TO s_wbe.
        s_wbe-ex_werks-werks = wbe-werks.
*here the special stocks are processed
        IF  p_kzlso = 'X'.
          PERFORM provide_sp_werks TABLES p_t_wbe
                                   CHANGING spec_exist s_wbe.
        ENDIF.
* check zero stocks when p_kznul is choosen
        IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
          PERFORM checknull_werk USING s_wbe.
        ELSE.
          nullcheck = '1'.
        ENDIF.
*
        IF NOT nullcheck IS INITIAL.

*         s_wbe-ex_werks-werks = wbe-werks.
          INSERT s_wbe INTO p_t_wbe INDEX 1.
        ENDIF.
      ENDLOOP.                            "loop at wbe
****** here the storage location level**********************************
    ELSEIF p_kzlgo EQ 'X' AND gen_exist IS INITIAL.

      CLEAR: obs, vbs, wbs.
      READ TABLE lbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT lbe FROM h_index.
        IF lbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
        CLEAR: nullcheck, s_lbe, spec_exist.
        MOVE-CORRESPONDING lbe TO s_lbe.
*here the special stocks are processed
        IF  p_kzlso = 'X'.
          PERFORM provide_sp_lgort TABLES p_t_lbe
                                   CHANGING s_lbe spec_exist.
        ENDIF.
*  zerocheck for 'normal' stocks if no special stock exists
        IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
          PERFORM checknull_lgort USING s_lbe.
        ELSE.
          nullcheck = '1'.
        ENDIF.
        IF NOT nullcheck IS INITIAL.
          READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                  werks = s_lbe-werks BINARY SEARCH.
          IF sy-subrc = 0.
            s_lbe-bwgrp = wbe-bwgrp.
          ELSE.
             CHECK 'x' = 'y'.     "leave current loop pass
*            MESSAGE a038 WITH 'WBE'.
          ENDIF.
*normal stocks of lgort ( sl )
          s_lbe-ex_lgort-lgort   = lbe-lgort.
          s_lbe-ex_lgort-lgortkz = norm_sl."normaler Lagerort
          s_lbe-ex_lgort-sondcha = space.

          INSERT s_lbe INTO p_t_lbe INDEX 1.
        ENDIF.
      ENDLOOP.                       "loop at lbe
* sites without stocks should be shown, wbe without stocks needed
* no mard existing for the site
      IF p_kznul IS INITIAL.
         PERFORM wrk_zerostocks USING t_matnr-matnr.
      ENDIF.
* here the werks only stocks are given to the outtab ( werks only means
* stocks on site level which can exist also on storage loc level )
* these stocks are necessary for the cumulation on higher levels
      LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = t_matnr-matnr.
        CLEAR s_lbe.
        MOVE-CORRESPONDING s_w_lbe TO s_lbe.
        READ TABLE wbe WITH KEY matnr = s_w_lbe-matnr
                              werks = s_w_lbe-werks BINARY SEARCH.
        IF sy-subrc = 0.
          s_lbe-bwgrp = wbe-bwgrp.
        ELSE.
           CHECK 'x' = 'y'.           "<<<insert note 0207759 tga
*          MESSAGE a038 WITH 'WBE'.   "<<<delete note 0207759 tga
        ENDIF.
        s_lbe-ex_lgort-lgort   = '0000'.
        s_lbe-ex_lgort-lgortkz = no_sl."normaler Lagerort
        s_lbe-ex_lgort-sondcha = space.

        INSERT s_lbe INTO p_t_lbe INDEX 1.
      ENDLOOP.
    ENDIF.
  ENDLOOP.                              "loop at t_matnr
ENDFORM.                               " BUILD_OUTTAB_TREE1

*&---------------------------------------------------------------------*
*&      Form  PROVIDE_MATTREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*----------------------------------------------------------------------*
FORM provide_mattree TABLES   p_t_wbe TYPE  t_wbe
                              p_t_lbe TYPE  t_lbe
                              p_t_cbe TYPE  t_cbe.

  DATA: node_level TYPE c.  "tga unicode
* add data to tree
  DATA: l_matnr_key TYPE lvc_nkey,
        l_bwgrp_key TYPE lvc_nkey,
        l_werks_key TYPE lvc_nkey,
        l_last_key  TYPE lvc_nkey,
        l_lgort_key TYPE lvc_nkey,
        l_scat_key  TYPE lvc_nkey,
        sgt_scope   TYPE sgt_scope.

*******************level including site ********************************
* add data to tree
* Batch Level
  IF p_kzcha NE space.
    LOOP AT p_t_cbe INTO s_cbe.
         gv_charg = s_cbe-charg.
      AT NEW matnr.
        node_level = man_zeile.        "node for material
        READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr BINARY SEARCH.
        PERFORM line_of_cmatnr USING s_cbe ' ' node_level
                              CHANGING  l_matnr_key.
      ENDAT.

      AT NEW bwgrp.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_cbwgrp USING s_cbe  l_matnr_key node_level
                               CHANGING  l_bwgrp_key.
      ENDAT.
*
      AT NEW werks.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_cwerks USING s_cbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
      ENDAT.
* For no batch level stock,we are showing plant level stock
* at this point of time no need to show segment and batch if stock is not there
      READ TABLE cbe WITH KEY matnr = s_cbe-matnr
                              werks = s_cbe-werks
                              lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
      IF sy-subrc = 0.
*    last node at storage-location level
        AT NEW ex_lgort.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        ENDAT.
*       last node at Batch level
        node_level = ch_zeile.
        PERFORM line_of_charg USING l_lgort_key node_level
                                CHANGING s_cbe l_last_key.
      ELSE.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.

      ENDIF.
      CLEAR gv_charg.
    ENDLOOP.
* Batch Via Stock Segment
  ELSEIF p_kzseg NE space.
    LOOP AT p_t_cbe INTO s_cbe.
        gv_charg = s_cbe-charg.
      AT NEW matnr.
        node_level = man_zeile.        "node for material
        READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr BINARY SEARCH.
        PERFORM line_of_cmatnr USING s_cbe ' ' node_level
                              CHANGING  l_matnr_key.
      ENDAT.

      AT NEW bwgrp.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_cbwgrp USING s_cbe  l_matnr_key node_level
                               CHANGING  l_bwgrp_key.
      ENDAT.
*
      AT NEW werks.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_cwerks USING s_cbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
      ENDAT.
* For no batch level stock,we are showing plant level stock
* at this point of time no need to show segment and batch if stock is not there
      READ TABLE cbe WITH KEY matnr = s_cbe-matnr
                              werks = s_cbe-werks
                              lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
      IF sy-subrc = 0.
*    last node at storage-location level
        AT NEW ex_lgort.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        ENDAT.

        AT NEW sgt_scat.
*       Check if its stock segment relevant
        CALL FUNCTION 'SGTG_CHECK_CAT_REL'
          EXPORTING
            iv_matnr       = s_cbe-matnr
            iv_werks       = s_cbe-werks
         IMPORTING
            ev_scope       = sgt_scope .
          IF sgt_scope EQ 1.
            node_level = ch_zeile.
            PERFORM line_of_cscat USING tt_cbe s_cbe l_lgort_key node_level
                                CHANGING l_scat_key.
          ELSE.
            l_scat_key = l_lgort_key.
          ENDIF.
        ENDAT.
*     last node at batch level
        node_level = ch_zeile.
        PERFORM line_of_charg USING l_scat_key node_level
                              CHANGING s_cbe l_last_key.
      ELSE.
       node_level = lag_zeile.          "node for storage location
       PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                              CHANGING  l_lgort_key.

      ENDIF.

    ENDLOOP.
* Batch via Plant
  ELSEIF p_kzlgo NE 'X'
  AND    p_chrg  EQ space.
    LOOP AT p_t_wbe INTO s_wbe.
      AT NEW matnr.
        node_level = man_zeile.        "node for material
        READ TABLE t_matnr WITH KEY matnr = s_wbe-matnr BINARY SEARCH.
        PERFORM line_of_matnr USING s_wbe '' node_level
                              CHANGING  l_matnr_key.
      ENDAT.
      AT NEW bwgrp.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_bwgrp USING s_wbe  l_matnr_key node_level
                             CHANGING  l_bwgrp_key.
      ENDAT.
*    last node at werks level
      node_level = wrk_zeile.          "node for site
      PERFORM line_of_werks USING     l_bwgrp_key node_level
                            CHANGING  s_wbe l_werks_key.
    ENDLOOP.
*******************level including storage location*********************
  ELSEIF p_kzlgo EQ 'X'
  AND    p_chrg EQ space.
    LOOP AT p_t_lbe INTO s_lbe.
      AT NEW matnr.
        node_level = man_zeile.        "node for material
        READ TABLE t_matnr WITH KEY matnr = s_lbe-matnr BINARY SEARCH.
        PERFORM line_of_lmatnr USING s_lbe '' node_level
                              CHANGING  l_matnr_key.
      ENDAT.

      AT NEW bwgrp.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_lbwgrp USING s_lbe  l_matnr_key node_level
                             CHANGING  l_bwgrp_key.
      ENDAT.

      AT NEW werks.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_lwerks USING s_lbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
      ENDAT.
*    last node at storage-location level
      node_level = lag_zeile.          "node for storage location
      PERFORM line_of_lgort USING l_werks_key node_level
                             CHANGING s_lbe l_last_key.
    ENDLOOP.
  ENDIF.

ENDFORM.                               " PROVIDE_MATTREE1

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_WBE  text
*      -->P_1465   text
*      -->P_NODE_LEVEL  text
*      <--P_L_MATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_matnr USING    p_s_wbe TYPE s_wbe
                            p_relat_key TYPE lvc_nkey
                            p_node_level TYPE c         "tga unicode
                   CHANGING p_node_key TYPE lvc_nkey.
  DATA: l_node_text TYPE lvc_value,
        lr_wbe TYPE s_wbe.
* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image   = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.
* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
  IF NOT t_matnr-attyp = attyp_sam.
* tga / accessibility
    MOVE '@3Q@'   TO h_icon.
    MOVE text-111 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.   " vorher @3Q@
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
*    tga acc accessibility
*    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
* mat to delete
    IF t_matnr-lvorm NE space.
      CLEAR: ls_item_layout.           "noch mal prüfen
      ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
      MOVE '@11@' TO h_icon.
      MOVE text-105 TO h_text.
      PERFORM build_tooltip CHANGING h_icon
                                     h_text
                                     h_tv_image.
      ls_item_layout-t_image = h_tv_image. "icon delete
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.
* give a special sign if it's a generic article
  ELSE.
    CLEAR ls_item_layout.
* tga / accessibility
      MOVE '@0R@' TO h_icon.
      MOVE text-013 TO h_text.
      PERFORM build_tooltip CHANGING h_icon
                                     h_text
                                     h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.
* give a special sign if it's a component
  PERFORM check_structured_article TABLES t_matnr.
  IF strart_exist = yes.
    CLEAR ls_item_layout.
* tga / accessibility
    MOVE '@2Q@' TO h_icon.
    MOVE text-112 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = 'NAME1'.
    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.

* add node inital
* tga / conversion-exit will otherwise not be considered
*  l_node_text =  p_s_wbe-matnr.
  WRITE p_s_wbe-matnr TO l_node_text.
  lr_wbe-meinh = t_matnr-meins.
  lr_wbe-name1 = t_matnr-maktx.
ENHANCEMENT-POINT RWBE1F09_02 SPOTS ES_RWBEST01 .

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_wbe-matnr '' '' ''
                                   p_s_wbe-meinh p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_wbe-matnr '' '' ''
                                   p_s_wbe-meinh p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.
ENDFORM.                               " LINE_OF_MATNR

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_BWGRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_WBE  text
*      -->P_L_MATNR_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_BWGRP_KEY  text
*----------------------------------------------------------------------*
FORM line_of_bwgrp USING    p_s_wbe TYPE s_wbe
                            p_relat_key TYPE lvc_nkey
                            p_node_level TYPE c         "tga unicode
                   CHANGING p_node_key  TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_wbe TYPE s_wbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
* tga / accessibility
  MOVE '@A5@' TO h_icon.
  MOVE text-027 TO h_text.
  PERFORM build_tooltip CHANGING h_icon
                                 h_text
                                 h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
*  tga acc acessibility
*  ls_item_layout-style   =
*                        cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

* add node inital
  l_node_text =  p_s_wbe-bwgrp.
  IF p_s_wbe-bwgrp = dummy_bwgrp.
    l_node_text  = text-036.
    lr_wbe-name1 = text-035.
  ELSE.
    READ TABLE t_bwgrp WITH KEY bwgrp = p_s_wbe-bwgrp BINARY SEARCH.
    lr_wbe-name1 = t_bwgrp-bwgbz.
  ENDIF.
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_wbe-matnr  p_s_wbe-bwgrp
                              '' '' p_s_wbe-meinh p_node_level ''
                              t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_wbe-matnr  p_s_wbe-bwgrp
                                   '' '' p_s_wbe-meinh p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.
ENDFORM.                               " LINE_OF_BWGRP

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_WERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_WBE  text
*      -->P_L_BWGRP_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_WERKS_KEY  text
*----------------------------------------------------------------------*
FORM line_of_werks USING    p_relat_key   TYPE lvc_nkey
                            p_node_level  TYPE c         "tga unicode
                   CHANGING p_s_wbe TYPE s_wbe
                            p_node_key    TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value.
*        lr_wbe TYPE s_wbe.
  DATA: lt_item_layout  TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image   = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.
*  tga acc accessibility
*  ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.

* add node inital
  l_node_text =  p_s_wbe-ex_werks-werks.
  CASE p_s_wbe-ex_werks-sondcha.
    WHEN beistlief.
      IF NOT beistlief IN s_sobkz.
        ls_node_layout-hidden = 'X'.
      ENDIF.
      ls_item_layout-togg_right = 'X'.
      l_node_text =  beistlief.
      p_s_wbe-name1 = text-044.
    WHEN lrgutkunde.
      IF NOT lrgutkunde IN s_sobkz.
        ls_node_layout-hidden = 'X'.
      ENDIF.
*      ls_item_layout-togg_right = 'X'.
      l_node_text =  lrgutkunde.
      p_s_wbe-name1 = text-046.
    WHEN konsikunde.
      IF NOT konsikunde IN s_sobkz.
        ls_node_layout-hidden = 'X'.
      ENDIF.
      l_node_text =  konsikunde.
      p_s_wbe-name1 = text-049.
  ENDCASE.
* set item-layout
  READ TABLE t_werks WITH KEY werks =
                                   p_s_wbe-ex_werks-werks BINARY SEARCH.
  IF t_werks-vlfkz     = 'A'.
* tga / accessibility
    MOVE '@A8@' TO h_icon.                  "icon plant
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = 'B'.
* tga / accessibility
    MOVE '@A1@' TO h_icon.            " icon dc
    MOVE text-113 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = ' '.
* tga / accessibility
    MOVE '@A8@' TO h_icon.
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.
  IF NOT p_s_wbe-ex_werks-sondcha IS INITIAL.
* tga / accessibility
    MOVE '@EL@' TO h_icon.              " icon when special stock exists
    MOVE text-114 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  APPEND ls_item_layout TO lt_item_layout.
*  mat to delete
  IF p_s_wbe-lvorm NE space.
    CLEAR: ls_item_layout, p_s_wbe-lvorm.                   "
    ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
    MOVE '@11@' TO h_icon.                 " icon delete
    MOVE text-105 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.
* check negative quantities
  PERFORM chk_negquant TABLES   lt_item_layout
                       USING    ls_item_layout p_s_wbe.
* add lines with quantities.
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_wbe-matnr  p_s_wbe-bwgrp
                                   p_s_wbe-ex_werks-werks ''
                                   p_s_wbe-meinh p_node_level
                                   p_s_wbe-ex_werks-sondcha
                                   t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "main tree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_wbe-matnr  p_s_wbe-bwgrp
                                   p_s_wbe-ex_werks-werks ''
                                   p_s_wbe-meinh p_node_level
                                   p_s_wbe-ex_werks-sondcha
                                   t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.
ENDFORM.                               " LINE_OF_WERKS

*&---------------------------------------------------------------------*
*&      Form  EXIT_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exit_program.

  CALL METHOD mattree1->free.

  IF NOT mattree2 IS INITIAL.
    CALL METHOD mattree2->free.
  ENDIF.
  IF ( sy-calld EQ space )
  OR ( NOT p_mcall IS INITIAL ).
*---- Aufruf aus Menü heraus
*---- -> Rücksprung ins Selektionsbild, wobei die vorherigen Eingaben
*----    bis auf etwaige Merkmalswerteeinschränkungen erhalten bleiben
    PERFORM neustart_f3.
  ELSE.
*---- Aufruf per CALL TRANSACTION oder SUBMIT (auch aus SE38 und SE80
*---- heraus)
    IF ( sy-tcode = 'SE38' )
    OR ( sy-tcode = 'SE80' ).
*---- Rücksprung ins Selektionsbild, wobei die vorherigen Eingaben
*---- bis auf etwaige Merkmalswerteeinschränkungen erhalten bleiben
      PERFORM neustart_f3.
    ELSE.
      LEAVE.           "Rücksprung zur aufrufenden TA/Programm
    ENDIF.
  ENDIF.

ENDFORM.                               " EXIT_PROGRAM

*&---------------------------------------------------------------------*
*&      Form  PROVIDE_EX_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM provide_sp_lgort TABLES p_t_lbe TYPE t_lbe
                      CHANGING p_s_lbe TYPE s_lbe
                               p_spec_exist TYPE c. "tga unicode
  DATA: h_s_lbe TYPE s_lbe,
  h_matnr LIKE mara-matnr.
  h_matnr = p_s_lbe-matnr.
* bwgrp of wbe needed
     READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                             werks = p_s_lbe-werks BINARY SEARCH.
* kundenauftrag ********************************************************
  IF p_s_lbe-kalab NE space      OR p_s_lbe-kains NE space
     OR p_s_lbe-kaspe NE space   OR p_s_lbe-kaein NE space.
* versorgen key
    h_s_lbe-matnr             =    p_s_lbe-matnr.
    h_s_lbe-bwgrp             =    wbe-bwgrp.
    h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
* expanded lgort (sl)
    h_s_lbe-ex_lgort-lgort     = lbe-lgort.
    h_s_lbe-ex_lgort-lgortkz   = sp_sl."sl with special stocks
    h_s_lbe-ex_lgort-sondcha   = aufbskunde.   "customer order
* fields with values
    h_s_lbe-kalab = p_s_lbe-kalab.
    h_s_lbe-kains = p_s_lbe-kains.
    h_s_lbe-kaspe = p_s_lbe-kaspe.
    h_s_lbe-kaein = p_s_lbe-kaein.
* necessary to clear because these stocks would apper two times
    CLEAR: p_s_lbe-kalab, p_s_lbe-kains, p_s_lbe-kaspe, p_s_lbe-kaein.
    INSERT h_s_lbe INTO p_t_lbe INDEX 1.
    p_spec_exist = yes.
    CLEAR h_s_lbe.
  ENDIF.
* Liefkonsi **********************************************************
  READ TABLE kbe WITH KEY matnr = p_s_lbe-matnr
                          werks = p_s_lbe-werks
*                         lgort = lbe-lgort.      "note 319513 tga
                          lgort = lbe-lgort BINARY SEARCH.
  IF sy-subrc EQ 0.
* versorgen key
    h_s_lbe-matnr             =    p_s_lbe-matnr.
    h_s_lbe-bwgrp             =    wbe-bwgrp.
    h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
    h_s_lbe-ex_lgort-lgort    =  lbe-lgort.
    h_s_lbe-ex_lgort-lgortkz  =  sp_sl."sl with sonderbest
    h_s_lbe-ex_lgort-sondcha  =  konsilief.   "vendorkonsi
* tga wrong values for vendor consignment note 319513 / start
*    h_s_lbe-klabs = wbe-klabs.
*    h_s_lbe-kinsm = wbe-kinsm.
*    h_s_lbe-keinm = wbe-keinm.
*    h_s_lbe-kspem = wbe-kspem.
    LOOP AT kbe FROM sy-tabix.
* tga / wrong cumulation
*      IF kbe-lgort NE lbe-lgort. EXIT. ENDIF.
         IF kbe-matnr NE lbe-matnr OR
            kbe-werks NE lbe-werks OR
            kbe-lgort NE lbe-lgort.
              EXIT.
         ENDIF.

         ADD kbe-labst TO h_s_lbe-klabs.
         ADD kbe-insme TO h_s_lbe-kinsm.
         ADD kbe-einme TO h_s_lbe-keinm.
         ADD kbe-speme TO h_s_lbe-kspem.
    ENDLOOP.
* tga wrong values for vendor consignment note 319513 / end
* necessary to clear because these stocks would appear two times
    CLEAR: p_s_lbe-klabs, p_s_lbe-kinsm, p_s_lbe-keinm, p_s_lbe-kspem.

    INSERT h_s_lbe INTO p_t_lbe INDEX 1.
    p_spec_exist = yes.
    CLEAR h_s_lbe.
  ENDIF.
* Liefmtv***************************************************************
  IF p_s_lbe-mlabs NE space      OR p_s_lbe-minsm NE space
     OR p_s_lbe-meinm NE space   OR p_s_lbe-mspem NE space.
* versorgen key
    h_s_lbe-matnr             =    p_s_lbe-matnr.
    h_s_lbe-bwgrp             =    wbe-bwgrp.
    h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
* expanded lgort (sl)
    h_s_lbe-ex_lgort-lgort    =  lbe-lgort.
    h_s_lbe-ex_lgort-lgortkz  =  sp_sl."sl with sonderbest
    h_s_lbe-ex_lgort-sondcha  =  mtverpack.   "customer order
* fields with values
    h_s_lbe-mlabs = p_s_lbe-mlabs.
    h_s_lbe-minsm = p_s_lbe-minsm.
    h_s_lbe-meinm = p_s_lbe-meinm.
    h_s_lbe-mspem = p_s_lbe-mspem.
* necessary to clear because these stocks would apper two times
    CLEAR: p_s_lbe-mlabs, p_s_lbe-minsm, p_s_lbe-meinm, p_s_lbe-mspem.
    INSERT h_s_lbe INTO p_t_lbe INDEX 1.
    CLEAR h_s_lbe.
  ENDIF.
* Liefbeist*************************************************************
  IF obs-matnr NE h_matnr.

    LOOP AT obs WHERE matnr = p_s_lbe-matnr  AND
                      werks = p_s_lbe-werks.

      ADD obs-labst TO h_s_lbe-lblab.
      ADD obs-insme TO h_s_lbe-lbins.
      ADD obs-einme TO h_s_lbe-lbein.
    ENDLOOP.
    IF sy-subrc = 0.
*  versorgen key
      h_s_lbe-matnr             =    p_s_lbe-matnr.
      h_s_lbe-bwgrp             =    wbe-bwgrp.
      h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
      h_s_lbe-ex_lgort-lgort   = space.
      h_s_lbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
      h_s_lbe-ex_lgort-sondcha  = beistlief.   "vendorkonsi
      INSERT h_s_lbe INTO p_t_lbe INDEX 1.
      p_spec_exist = yes.
      CLEAR h_s_lbe.
    ENDIF.
  ENDIF.
*Kundenbest-lgut********************************************************
  IF vbs-matnr NE h_matnr.
    LOOP AT vbs WHERE matnr = p_s_lbe-matnr AND
                            werks = p_s_lbe-werks.

      ADD vbs-labst TO h_s_lbe-kulav.
      ADD vbs-insme TO h_s_lbe-kuinv.
      ADD vbs-einme TO h_s_lbe-kueiv.
    ENDLOOP.
    IF sy-subrc = 0.
*  versorgen key
      h_s_lbe-matnr             =    p_s_lbe-matnr.
      h_s_lbe-bwgrp             =    wbe-bwgrp.
      h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
      h_s_lbe-ex_lgort-lgort   = space.
      h_s_lbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
      h_s_lbe-ex_lgort-sondcha  = lrgutkunde.   "LRGUT at customer
      INSERT h_s_lbe INTO p_t_lbe INDEX 1.
      p_spec_exist = yes.
      CLEAR h_s_lbe.
    ENDIF.
  ENDIF.
*kundenbest-konsi*******************************************************
  IF wbs-matnr NE h_matnr.

    LOOP AT wbs WHERE  matnr = p_s_lbe-matnr  AND
                       werks = p_s_lbe-werks.

      ADD wbs-labst TO h_s_lbe-kulaw.
      ADD wbs-insme TO h_s_lbe-kuinw.
      ADD wbs-einme TO h_s_lbe-kueiw.
    ENDLOOP.
    IF sy-subrc = 0.
*  versorgen key
      h_s_lbe-matnr             =    p_s_lbe-matnr.
      h_s_lbe-bwgrp             =    wbe-bwgrp.
      h_s_lbe-werks             =    p_s_lbe-werks.
    if gv_tree NE space.
      h_s_lbe-satnr           = p_s_lbe-satnr.
    endif.
      h_s_lbe-ex_lgort-lgort   = space.
      h_s_lbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
      h_s_lbe-ex_lgort-sondcha  = konsikunde.   "Kons at customer

      INSERT h_s_lbe INTO p_t_lbe INDEX 1.
      p_spec_exist = yes.
      CLEAR h_s_lbe.
    ENDIF.
  ENDIF.
ENDFORM.                               " PROVIDE_SP_LGORT

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_LMATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_1936   text
*      -->P_NODE_LEVEL  text
*      <--P_L_MATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_lmatnr USING    p_s_lbe TYPE s_lbe
                             p_relat_key TYPE lvc_nkey
                             p_node_level TYPE c          "tga unicode
                    CHANGING p_node_key TYPE lvc_nkey.
  DATA: l_node_text TYPE lvc_value,
        lr_sbe TYPE s_lbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.

  IF NOT t_matnr-attyp = attyp_sam.
* tga / accessibility
    MOVE '@3Q@'   TO h_icon.
    MOVE text-111 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
*   tga acc  accessibility
*    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
* mat to delete
    IF t_matnr-lvorm NE space.
      CLEAR: ls_item_layout.           "noch mal prüfen
      ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
      MOVE '@11@' TO h_icon.
      MOVE text-105 TO h_text.
      PERFORM build_tooltip USING    h_icon
                                     h_text
                            CHANGING h_tv_image.
      ls_item_layout-t_image = h_tv_image. "icon delete
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.
* give a special sign if it's a generic article
  ELSE.
    CLEAR ls_item_layout.
* tga / accessibility
      MOVE '@0R@' TO h_icon.
      MOVE text-013 TO h_text.
      PERFORM build_tooltip USING    h_icon
                                     h_text
                            CHANGING h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
*   tga acc accessibility
*    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.
* give a special sign if it's a component
  PERFORM check_structured_article TABLES t_matnr.
  IF strart_exist = yes.
    CLEAR ls_item_layout.
* tga / accessibility tooltip for tree-icon
    MOVE '@2Q@' TO h_icon.
    MOVE text-112 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = 'NAME1'.
*   tga acc accessibility
*    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.

* add node inital
* tga / conversion-exit will otherwise not be considered
*  l_node_text =  p_s_lbe-matnr.
  WRITE p_s_lbe-matnr TO l_node_text.
  lr_sbe-meinh = t_matnr-meins.
  lr_sbe-name1 = t_matnr-maktx.
ENHANCEMENT-POINT RWBE1F09_03 SPOTS ES_RWBEST01 .

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_lbe-matnr '' '' ''
                                   p_s_lbe-meinh p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.

    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_lbe-matnr '' '' ''
                                   p_s_lbe-meinh p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.

ENDFORM.                               " LINE_OF_LMATNR

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_LBWGRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_L_MATNR_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_BWGRP_KEY  text
*----------------------------------------------------------------------*
FORM line_of_lbwgrp USING    p_s_lbe TYPE s_lbe
                             p_relat_key TYPE lvc_nkey
                             p_node_level TYPE c  "tga unicode
                    CHANGING p_node_key TYPE lvc_nkey.
  DATA: l_node_text TYPE lvc_value,
        lr_sbe TYPE s_lbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
* tga / accessibility
  MOVE '@A5@' TO h_icon.
  MOVE text-027 TO h_text.
  PERFORM build_tooltip CHANGING h_icon
                                 h_text
                                 h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
* tga accessibility
*  ls_item_layout-style   =
*                        cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

* add node inital
  l_node_text =  p_s_lbe-bwgrp.
  IF p_s_lbe-bwgrp = dummy_bwgrp.
    l_node_text  = text-036.
    lr_sbe-name1 = text-035.
  ELSE.
    READ TABLE t_bwgrp WITH KEY bwgrp = p_s_lbe-bwgrp BINARY SEARCH.
    lr_sbe-name1 = t_bwgrp-bwgbz.
  ENDIF.
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   '' '' '' p_node_level ''
                                   t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   '' '' '' p_node_level ''
                                   t_matnr-attyp  '' ''.
    ENDIF.
  ENDIF.

ENDFORM.                               " LINE_OF_LBWGRP

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_LWERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_L_BWGRP_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_WERKS_KEY  text
*----------------------------------------------------------------------*
FORM line_of_lwerks USING    p_s_lbe TYPE s_lbe
                             p_relat_key TYPE lvc_nkey
                             p_node_level TYPE c    "tga unicode
                    CHANGING p_node_key TYPE lvc_nkey.
  DATA: l_node_text TYPE lvc_value,
        lr_sbe TYPE s_lbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
  READ TABLE t_werks WITH KEY werks = p_s_lbe-werks BINARY SEARCH.
  IF t_werks-vlfkz = 'A'.
* tga / accessibility
    MOVE '@A8@' TO h_icon.                  "icon plant
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = 'B'.
* tga / accessibility
* tga / wrong icon
*    MOVE '@A8@' TO h_icon.                  "icon dc
    MOVE '@A1@' TO h_icon.            " icon dc
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = ' '.
* tga / accessibility
    MOVE '@A8@' TO h_icon.                  "icon plant
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
*  tga acc accessibility
*  ls_item_layout-style   =
*                        cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.
* material to delete ?
  IF t_matnr-lvorm NE space.
    CLEAR: ls_item_layout.
    ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
    MOVE '@11@' TO h_icon.                 " icon delete
    MOVE text-105 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    APPEND ls_item_layout TO lt_item_layout.
  ELSE.
    READ TABLE wbe WITH KEY matnr = p_s_lbe-matnr
                            bwgrp = p_s_lbe-bwgrp
                            werks = p_s_lbe-werks BINARY SEARCH.
    IF wbe-lvorm NE space.
      CLEAR: ls_item_layout.
      ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
      MOVE '@11@' TO h_icon.                 " icon delete
      MOVE text-105 TO h_text.
      PERFORM build_tooltip CHANGING h_icon
                                     h_text
                                     h_tv_image.
      ls_item_layout-t_image = h_tv_image.
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.
  ENDIF.
* add node inital
  l_node_text =  p_s_lbe-werks.
  READ TABLE t_werks WITH KEY werks = p_s_lbe-werks BINARY SEARCH.
  lr_sbe-name1 = t_werks-wrkbz.        " text!!tga
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   p_s_lbe-werks '' ''
                                   p_node_level '' t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_sbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   p_s_lbe-werks '' ''
                                   p_node_level '' t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.

ENDFORM.                               " LINE_OF_LWERKS

*&---------------------------------------------------------------------*
*&      Form  LINE_OF_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_L_WERKS_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_LAST_KEY  text
*----------------------------------------------------------------------*
FORM line_of_lgort USING   p_relat_key TYPE lvc_nkey
                            p_node_level TYPE c        "tga unicode
                   CHANGING p_s_lbe TYPE s_lbe
                            p_node_key TYPE lvc_nkey.
  DATA: l_node_text TYPE lvc_value.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
  IF p_s_lbe-ex_lgort-lgortkz     = '2'.
* tga / accessibility
    MOVE '@EL@' TO h_icon.              " icon when special stock exists
    MOVE text-114 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ELSE.
* tga / accessibility
    MOVE '@AC@' TO h_icon.              " icon when special stock exists
    MOVE text-029 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
* tga accessibility
*  ls_item_layout-style   = cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.
  IF p_s_lbe-lvorm NE space.
    CLEAR: ls_item_layout, p_s_lbe-lvorm.                   "
    ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
    MOVE '@11@' TO h_icon.                 " icon delete
    MOVE text-105 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.

* add node inital  @BN@
*  clear: p_s_lbe-ex_lgort.
  l_node_text =  p_s_lbe-ex_lgort-lgort.

  CASE p_s_lbe-ex_lgort-lgortkz.
    WHEN no_sl.
* werks only, needed for accumulation on higher levels
      ls_node_layout-hidden = 'X'.
    WHEN norm_sl.                      "normal stor loc
      SELECT SINGLE * FROM t001l
                    WHERE werks = p_s_lbe-werks
                    AND   lgort = p_s_lbe-ex_lgort-lgort.
      p_s_lbe-name1 = t001l-lgobe.
    WHEN sp_sl.                        "special stocks
      CASE p_s_lbe-ex_lgort-sondcha.
        WHEN konsilief.
          IF NOT konsilief IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  konsilief.
          p_s_lbe-name1 = text-047.
        WHEN aufbskunde.
          IF NOT aufbskunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  aufbskunde.
          p_s_lbe-name1 = text-048.
        WHEN mtverpack.
          IF NOT mtverpack IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  mtverpack.
          p_s_lbe-name1 = text-049.
        WHEN beistlief.
          IF NOT beistlief IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  beistlief.    "Lieferantenbeistellung
          p_s_lbe-name1 = text-058.
        WHEN lrgutkunde.
          IF NOT lrgutkunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  lrgutkunde.   "Kundenleihgut
          p_s_lbe-name1 = text-046.
        WHEN konsikunde.
          IF NOT konsikunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  konsikunde.   "Kundenkonsignation
          p_s_lbe-name1 = text-045.
      ENDCASE.
  ENDCASE.
* check negative quantities
   PERFORM chk_negquant TABLES   lt_item_layout
                        USING    ls_item_layout p_s_lbe.
* node with values in outtab line
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_lbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   p_s_lbe-werks p_s_lbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_lbe-ex_lgort-sondcha
                                   t_matnr-attyp '' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_lbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_lbe-matnr p_s_lbe-bwgrp
                                   p_s_lbe-werks p_s_lbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_lbe-ex_lgort-sondcha
                                   t_matnr-attyp '' ''.
    ENDIF.
  ENDIF.

ENDFORM.                               " LINE_OF_LGORT

*&---------------------------------------------------------------------*
*&      Form  FILL_ZLE_HIDE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_LBE  text
*      -->P_P_NODE_LEVEL  text
*----------------------------------------------------------------------*
FORM fill_zle_hide TABLES   p_t_zle STRUCTURE t_zle
                   USING    p_matnr TYPE matnr           " tga unicode
                            p_bwgrp TYPE figrp           " tga unicode
                            p_werks TYPE werks_d         " tga unicode
                            p_lgort TYPE lgort_d         " tga unicode
                            p_meinh TYPE lrmei           " tga unicode
                            p_p_node_level TYPE c        " tga unicode
                            p_sondcha      TYPE c        " tga unicode
                            p_t_matnr_attyp TYPE attyp   " tga unicode
                            p_charg         TYPE charg_d
                            p_scat          TYPE sgt_scat.
  CLEAR: p_t_zle.
*refresh: t_zle.
  CASE p_p_node_level.
    WHEN man_zeile.
      p_t_zle-matnr           =    p_matnr.
      p_t_zle-zeilen_kz       =    man_zeile.
      p_t_zle-attyp           =    p_t_matnr_attyp.
      APPEND p_t_zle.
    WHEN wgr_zeile.
      p_t_zle-matnr           =    p_matnr.
      p_t_zle-bwgrp           =    p_bwgrp.
      p_t_zle-zeilen_kz       =    wgr_zeile.
      p_t_zle-attyp           =    p_t_matnr_attyp.
      APPEND p_t_zle.
    WHEN wrk_zeile.
      p_t_zle-matnr           =    p_matnr.
      p_t_zle-bwgrp           =    p_bwgrp.
      p_t_zle-werks           =    p_werks.
      p_t_zle-zeilen_kz       =    wrk_zeile.
      p_t_zle-sond_kz         =    p_sondcha.
      p_t_zle-attyp           =    p_t_matnr_attyp.
      APPEND p_t_zle.
    WHEN lag_zeile.
      p_t_zle-matnr           =    p_matnr.
      p_t_zle-bwgrp           =    p_bwgrp.
      p_t_zle-werks           =    p_werks.
      p_t_zle-lgort           =    p_lgort.
      p_t_zle-zeilen_kz       =    lag_zeile.
      p_t_zle-sond_kz         =    p_sondcha.
      p_t_zle-attyp           =    p_t_matnr_attyp.
      APPEND p_t_zle.
   WHEN ch_zeile.
      p_t_zle-matnr           =    p_matnr.
      p_t_zle-bwgrp           =    p_bwgrp.
      p_t_zle-werks           =    p_werks.
      p_t_zle-lgort           =    p_lgort.
      p_t_zle-sgt_scat        =    p_scat.
      p_t_zle-charg           =    p_charg.
      p_t_zle-zeilen_kz       =    ch_zeile.
      p_t_zle-sond_kz         =    p_sondcha.
      p_t_zle-attyp           =    p_t_matnr_attyp.
      APPEND p_t_zle.
  ENDCASE.

ENDFORM.                               " FILL_ZLE_HIDE

*&---------------------------------------------------------------------*
*&      Form  PROVIDE_EX_WERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_T_WBE  text
*      -->P_S_WBE  text
*----------------------------------------------------------------------*
FORM provide_sp_werks TABLES   p_t_wbe TYPE t_wbe
                      CHANGING p_spec_exist TYPE c " tga unicode
                               p_s_wbe TYPE s_wbe. " tga unicode

  DATA: h_s_wbe TYPE s_wbe.

* Liefbeist*************************************************************
  LOOP AT obs WHERE matnr = p_s_wbe-matnr  AND
                    werks = p_s_wbe-ex_werks-werks.
    ADD obs-labst TO h_s_wbe-lblab.
    ADD obs-insme TO h_s_wbe-lbins.
    ADD obs-einme TO h_s_wbe-lbein.
  ENDLOOP.
  IF sy-subrc = 0.
*  versorgen key
    h_s_wbe-matnr             =    p_s_wbe-matnr.
    h_s_wbe-bwgrp             =    p_s_wbe-bwgrp.
    h_s_wbe-ex_werks-werks    =    p_s_wbe-ex_werks-werks.
    if gv_tree NE space.
      h_s_wbe-satnr           = p_s_wbe-satnr.
    endif.
    h_s_wbe-ex_werks-sondcha  =    beistlief.   "konsi at vendor
    INSERT h_s_wbe INTO p_t_wbe INDEX 1.
    p_spec_exist = 'X'.
    CLEAR: p_s_wbe-lblab, p_s_wbe-lbins, p_s_wbe-lbein.
    CLEAR h_s_wbe.
  ENDIF.
*Kundenbest-lgut********************************************************
  LOOP AT vbs WHERE matnr = p_s_wbe-matnr AND
                    werks = p_s_wbe-ex_werks-werks.

    ADD vbs-labst TO h_s_wbe-kulav.
    ADD vbs-insme TO h_s_wbe-kuinv.
    ADD vbs-einme TO h_s_wbe-kueiv.
  ENDLOOP.
  IF sy-subrc = 0.
*  provide key
    h_s_wbe-matnr             =    p_s_wbe-matnr.
    h_s_wbe-bwgrp             =    p_s_wbe-bwgrp.
    if gv_tree NE space.
      h_s_wbe-satnr           = p_s_wbe-satnr.
    endif.
    h_s_wbe-ex_werks-werks    =    p_s_wbe-ex_werks-werks.
    h_s_wbe-ex_werks-sondcha  =    lrgutkunde.   "LRGUT at customer
    INSERT h_s_wbe INTO p_t_wbe INDEX 1.
    p_spec_exist = 'X'.
    CLEAR: p_s_wbe-kulav, p_s_wbe-kuinv, p_s_wbe-kueiv.
    CLEAR h_s_wbe.
  ENDIF.
*kundenbest-konsi*******************************************************
  LOOP AT wbs WHERE  matnr = p_s_wbe-matnr  AND
                     werks = p_s_wbe-ex_werks-werks.

    ADD wbs-labst TO h_s_wbe-kulaw.
    ADD wbs-insme TO h_s_wbe-kuinw.
    ADD wbs-einme TO h_s_wbe-kueiw.
  ENDLOOP.
  IF sy-subrc = 0.
*  versorgen key
    h_s_wbe-matnr             =    p_s_wbe-matnr.
    h_s_wbe-bwgrp             =    p_s_wbe-bwgrp.
    if gv_tree NE space.
      h_s_wbe-satnr           = p_s_wbe-satnr.
    endif.
    h_s_wbe-ex_werks-werks    =    p_s_wbe-ex_werks-werks.
    h_s_wbe-ex_werks-sondcha  =    konsikunde.   "Kons at customer
    INSERT h_s_wbe INTO p_t_wbe INDEX 1.
    p_spec_exist = 'X'.
    CLEAR: p_s_wbe-kulaw, p_s_wbe-kuinw,p_s_wbe-kueiw.
    CLEAR h_s_wbe.
  ENDIF.
* ENDIF.
ENDFORM.                               " PROVIDE_EX_WERKS

*&---------------------------------------------------------------------*
*&      Form  CHECKNULL_WERK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_WBE  text
*----------------------------------------------------------------------*
FORM checknull_werk USING    p_s_wbe TYPE s_wbe.
  DATA: check_wbe TYPE s_wbe.
  CLEAR: nullcheck.
  check_wbe = p_s_wbe.
*initialize non value fields
  check_wbe-matnr    = space.
  check_wbe-bwgrp    = space.
  check_wbe-ex_werks = space.
  check_wbe-meinh    = space.
  check_wbe-name1    = space.
  check_wbe-lvorm    = space.
* its possible that these stocks are filled from marc
  IF p_kzson IS INITIAL.
    check_wbe-klabs  = space.
    check_wbe-kinsm  = space.
    check_wbe-keinm  = space.
    check_wbe-kspem  = space.
  ENDIF.
  IF NOT check_wbe IS INITIAL.
    nullcheck = '1'.
  ENDIF.
ENDFORM.                               " CHECKNULL_WERK

*&---------------------------------------------------------------------*
*&      Form  CHECKNULL_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_L  text
*      -->P_BE  text
*----------------------------------------------------------------------*
FORM checknull_lgort USING    p_s_lbe TYPE s_lbe.
  DATA: check_lbe TYPE s_lbe.
  CLEAR: nullcheck.
  check_lbe = p_s_lbe.
*initialize non value fields
  check_lbe-matnr    = space.
  check_lbe-bwgrp    = space.
  check_lbe-werks    = space.
  check_lbe-ex_lgort = space.
  check_lbe-meinh    = space.
  check_lbe-name1    = space.
  check_lbe-lvorm    = space.
  check_lbe-satnr    = space.
* special stocks which are in mard and in mkol
  IF p_kzson IS INITIAL.
    check_lbe-klabs  = space.
    check_lbe-kinsm  = space.
    check_lbe-keinm  = space.
    check_lbe-kspem  = space.
  ENDIF.
  IF NOT check_lbe IS INITIAL.
    nullcheck = '1'.
  ENDIF.

ENDFORM.                               " CHECKNULL_LGORT

*&---------------------------------------------------------------------*
*&      Form  COLUMN_TXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_FIELDCAT_REF_FIELD  text
*      <--P_GS_FIELDCAT_SCRTEXT_S  text
*----------------------------------------------------------------------*
FORM column_txt TABLES      p_gt_fieldcat TYPE lvc_t_fcat
                CHANGING    p_gs_fieldcat LIKE lvc_s_fcat.

  SELECT * FROM t157b INTO TABLE t_t157b WHERE spras = sy-langu.
  LOOP AT p_gt_fieldcat INTO p_gs_fieldcat.

    READ TABLE t_t157b WITH KEY feldv = p_gs_fieldcat-fieldname
                                        INTO s_t157b.
    IF sy-subrc = 0.
      p_gs_fieldcat-coltext   = s_t157b-ftext.
      p_gs_fieldcat-seltext   = s_t157b-ftext.
      p_gs_fieldcat-scrtext_l = s_t157b-ftext.

      MODIFY p_gt_fieldcat FROM p_gs_fieldcat.
    ENDIF.
  ENDLOOP.
ENDFORM.                               " COLUMN_TXT

*&---------------------------------------------------------------------*
*&      Form  CHANGE_TOOLBAR_TREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_toolbar_tree1.
*get toolbar control
  CALL METHOD mattree1->get_toolbar_object
         IMPORTING
             er_toolbar = ex_toolbar.

  CHECK NOT ex_toolbar IS INITIAL.
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* Disable the Variant of Articles if user parameter is set
  IF gv_tree IS INITIAL.
* add Standard Button to toolbar (for variants of articles)
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'VARI'
              icon      = '@0R@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-069.    " variants of gen art
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'MATX'
              icon      = '@4T@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-081.    " variant matrix
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT
  ENDIF.
* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'DETA'
              icon      = '@16@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-082.    "detail
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list values)
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'EKVK'
              icon      = '@3H@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-068.    "stock values
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add  Button to toolbar (for units of measure)
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'ZLME'
              icon      = '@BV@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-061.    "units of measure
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT
* add  Button to toolbar (for stocks in structures materials)
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'STRU'
              icon      = '@2Q@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-096.    "struct mat
* add seperator to toolbar
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.
* add  Button to toolbar (for stocks in structures materials)
  CALL METHOD ex_toolbar->add_button
          EXPORTING
              fcode     = 'REFR'
              icon      = '@42@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-110.    "refresh

ENHANCEMENT-POINT RWBE1F09_G10 SPOTS ES_RWBEST01 .

* add Dropdown Button to toolbar (for single list 'detail')
*  CALL METHOD ex_toolbar->add_button
*          EXPORTING
*              fcode     = 'OTHERS'
*              icon      = '@2Q@'
*              butn_type = cntb_btype_dropdown
*              text      = ''
*              quickinfo = text-073.                         "#EC NOTEXT
* set event-handler for toolbar-control
  CREATE OBJECT toolbar_event_receiver.

  SET HANDLER toolbar_event_receiver->on_function_selected
                                                      FOR ex_toolbar.
  SET HANDLER toolbar_event_receiver->on_toolbar_dropdown
                                                      FOR ex_toolbar.

ENDFORM.                               " CHANGE_TOOLBAR

*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM register_events_tree1.
* define the events which will be passed to the backend
  DATA: lt_events TYPE cntl_simple_events,
        l_event TYPE cntl_simple_event.

* define the events which will be passed to the backend
* l_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
* APPEND l_event TO lt_events.
* l_event-eventid = cl_gui_column_tree=>eventid_item_context_menu_req.
* APPEND l_event TO lt_events.
* l_event-eventid = cl_gui_column_tree=>eventid_header_context_men_req.
* APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_header_click.
  APPEND l_event TO lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_item_keypress.
  APPEND l_event TO lt_events.
************************************************************************
  l_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  APPEND l_event TO lt_events.

  l_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  APPEND l_event TO lt_events.
************************************************************************

  CALL METHOD mattree1->set_registered_events
    EXPORTING
      events                    = lt_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.

  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  DATA: l_event_receiver TYPE REF TO lcl_tree_event_receiver.
  CREATE OBJECT l_event_receiver.
* SET HANDLER l_event_receiver->handle_header_click FOR arttree1.
* SET HANDLER l_event_receiver->handle_item_keypress FOR arttree1.
* SET HANDLER l_event_receiver->handle_node_double_click FOR mattree1.
  SET HANDLER l_event_receiver->handle_item_double_click FOR mattree1.
*after_user_command   ohne vorherige Registrierung
*  SET HANDLER l_event_receiver->handle_after_user_command FOR arttree1.

ENDFORM.                               " REGISTER_EVENTS

*&---------------------------------------------------------------------*
*&      Form  MATRIX_AUS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM matrix_aus_alv USING p_lt_sel_node TYPE lvc_nkey    "tga unicode
                          p_lt_sel_name TYPE lvc_fname . "tga unicode

  DATA:  sav_zle LIKE zle,
         sav_zeilen_kz,
         sav_sond_kz.

  sav_zle        = zle.
  sav_zeilen_kz  = zeilen_kz.
  sav_sond_kz    = sond_kz.

  READ TABLE t_t157b WITH KEY feldv = p_lt_sel_name
                                      INTO s_t157b.
  IF sy-subrc = 0.
    MOVE: s_t157b-feldv    TO sav_fname_var+4,
          s_t157b-ftext    TO sav_text_var.
    REFRESH: t_varart, t_varme.
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    PERFORM mengeneinheiten_lesen TABLES t_matnr.
    PERFORM merkmale_nachlesen.
    CASE zeilen_kz.
      WHEN man_zeile.
*---- Variantenbestände zum Mandanten anzeigen ------------------------*
        PERFORM mandt_matrix_anzeigen.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*     WHEN BUK_ZEILE.
*---- Variantenbestände zum Buchungskreis anzeigen --------------------*
*       PERFORM BUKRS_MATRIX_ANZEIGEN.
*#jhl 31.01.96 (Ende)

      WHEN wgr_zeile.
*---- Variantenbestände zur Basiswerksgruppe anzeigen -----------------*
        PERFORM bwgrp_matrix_anzeigen.

      WHEN wrk_zeile.
*---- Variantenbestände zum Werk anzeigen -----------------------------*
        PERFORM werks_matrix_anzeigen.

      WHEN lag_zeile.
*---- Variantenbestände zum Lagerort anzeigen -------------------------*
        PERFORM lgort_matrix_anzeigen.
    ENDCASE.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
  ELSE.
    MESSAGE i029.
  ENDIF.
  IF ( ret_comm = gogv ) OR ( ret_comm = '#SN1' ).
    PERFORM retcode_aus_alv USING p_lt_sel_node p_lt_sel_name
                            sav_zle sav_zeilen_kz sav_sond_kz.
  ENDIF.
  CLEAR: t_varart, t_varme.
ENDFORM.                               " MATRIX_AUS_ALV

*&---------------------------------------------------------------------*
*&      Form  BUILD_MATTREE2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_VARIANT  text
*      -->P_LV_TREE_CONTAINER_NAME  text
*----------------------------------------------------------------------*
FORM build_mattree2 USING    p_ls_variant             TYPE disvariant   "tga unicode
                             p_lv_tree_container_name TYPE any.         "tga unicode

  DATA: lv_custom_container TYPE REF TO cl_gui_custom_container,
        l_hierarchy_header TYPE treev_hhdr.

*create custom container
  IF  lv_custom_container IS INITIAL.
    CREATE OBJECT lv_custom_container
          EXPORTING
             container_name = p_lv_tree_container_name
          EXCEPTIONS
              cntl_error  = 1
              cntl_system_error = 2
              create_error = 3
              lifetime_error = 4
              lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
* create tree control
    CREATE OBJECT mattree2
          EXPORTING
           parent  = lv_custom_container
         node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
           item_selection  = 'X'
           no_html_header = 'X'
           no_toolbar = ''
         EXCEPTIONS
           cntl_error  = 1
           cntl_system_error = 2
           create_error = 3
           lifetime_error = 4
           illegal_node_selection_mode  = 5
           failed = 6
           illegal_column_name = 7.
  ENDIF.
  IF sy-subrc NE 0.
    MESSAGE a096.
  ENDIF.

*first column header
  PERFORM build_hierarchy_header CHANGING l_hierarchy_header.
  IF  p_kzlgo NE 'X'.
* create empty tree-control
    CALL METHOD mattree2->set_table_for_first_display
         EXPORTING
                 is_hierarchy_header  = l_hierarchy_header
*              it_list_commentary   = lt_list_commentary
*               i_logo               = l_logo
*               i_background_id      = 'ALV_BACKGROUND'
                 i_save = x_save
                 is_variant = p_ls_variant
          CHANGING
                 it_outtab = gt_wbe    "table must be empty !!
                 it_fieldcatalog = gt_fieldcat.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
  ELSE.
* create empty tree-control
    CALL METHOD mattree2->set_table_for_first_display
         EXPORTING
                 is_hierarchy_header  = l_hierarchy_header
*              it_list_commentary   = lt_list_commentary
*               i_logo               = l_logo
*               i_background_id      = 'ALV_BACKGROUND'
                 i_save = x_save
                 is_variant = p_ls_variant
          CHANGING
                 it_outtab = gt_lbe    "table must be empty !!
                 it_fieldcatalog = gt_fieldcat.
    IF sy-subrc NE 0.
      MESSAGE a096.
    ENDIF.
  ENDIF.

ENDFORM.                               " BUILD_MATTREE2

*&---------------------------------------------------------------------*
*&      Form  BUILD_OUTTAB_TREE2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*----------------------------------------------------------------------*
FORM build_outtab_tree2 TABLES   p_t_wbe TYPE t_wbe
                                 p_t_lbe TYPE t_lbe.

  DATA: h_index LIKE sy-index VALUE '1',
        spec_exist TYPE c.
  REFRESH: p_t_wbe, p_t_lbe.
*  CLEAR: s_wbe, s_lbe.    " tga note 356164
* site level
  IF p_kzlgo NE 'X'.
* only variants
    LOOP AT wbe WHERE satnr EQ zle-matnr.
      IF NOT t_varart IS INITIAL.
        CHECK wbe-matnr = t_varart-matnr.
      ENDIF.
* tga note 356164
      CLEAR: nullcheck, spec_exist, s_wbe.
*     CLEAR: nullcheck, spec_exist.
* if new tree for variants is needed on different levels
*       IF zle-bwgrp = space OR zle-bwgrp = wbe-bwgrp.
*        IF zle-werks = space OR zle-werks = wbe-werks.
      MOVE-CORRESPONDING wbe TO s_wbe.
      s_wbe-ex_werks-werks = wbe-werks.
* here processing of special stocks
      IF  p_kzlso = 'X'.
        PERFORM provide_sp_werks TABLES p_t_wbe
                                 CHANGING spec_exist s_wbe.
      ENDIF.
      IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
        PERFORM checknull_werk USING s_wbe.
      ELSE.
        nullcheck = '1'.
      ENDIF.
*        ENDIF.
*      ENDIF.
      IF NOT nullcheck IS INITIAL.
*        s_wbe-ex_werks-werks = wbe-werks.
        INSERT s_wbe INTO p_t_wbe INDEX h_index.
      ENDIF.
    ENDLOOP.
* storage location level
  ELSE.
    DATA: h_matnr LIKE mara-matnr.

    CLEAR: obs, vbs, wbs, h_matnr.
    LOOP AT lbe WHERE satnr EQ zle-matnr.
      IF NOT t_varart IS INITIAL.
        CHECK lbe-matnr = t_varart-matnr.
      ENDIF.
* tga note 356164
      CLEAR: nullcheck, spec_exist, s_lbe.
*      CLEAR: nullcheck, spec_exist.
      MOVE-CORRESPONDING lbe TO s_lbe.
*here special stocks
      IF  p_kzlso = 'X'.
        PERFORM provide_sp_lgort TABLES p_t_lbe
                                 CHANGING s_lbe spec_exist.
      ENDIF.
      IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
        PERFORM checknull_lgort USING s_lbe.
      ELSE.
        nullcheck = '1'.
      ENDIF.
*   fill with normal stocks
      IF NOT nullcheck IS INITIAL.
* note 301642 start
         READ TABLE wbe WITH KEY matnr = s_lbe-matnr
                                 werks = s_lbe-werks BINARY SEARCH.
*        READ TABLE wbe WITH KEY werks = s_lbe-werks BINARY SEARCH.
* note 301642 end
        IF sy-subrc = 0.
          s_lbe-bwgrp = wbe-bwgrp.
        ELSE.
           CHECK 'x' = 'y'.          "<<<insert note 0207759 tga
*          MESSAGE a048.                "text!!tga delete note 0207759
        ENDIF.
* complete Key for normal stocks of lgort ( sl )
        s_lbe-ex_lgort-lgort   = lbe-lgort.
        s_lbe-ex_lgort-lgortkz = norm_sl.  "normal storage loc
        s_lbe-ex_lgort-sondcha = space.

        INSERT s_lbe INTO p_t_lbe INDEX h_index.
*here the werks only stocks on stor loc level are given to  outtab
        IF lbe-matnr NE h_matnr.
          h_matnr = lbe-matnr.
          LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = lbe-matnr.
            CLEAR s_lbe.
            MOVE-CORRESPONDING s_w_lbe TO s_lbe.
            READ TABLE wbe WITH KEY matnr = s_w_lbe-matnr
                                    werks = s_w_lbe-werks BINARY SEARCH.
            IF sy-subrc = 0.
              s_lbe-bwgrp = wbe-bwgrp.
            ELSE.
               CHECK 'x' = 'y'.          "<<<insert note 0207759 tga
*              MESSAGE a038 WITH 'WBE'.  "<<<delete note 0207759 tga
            ENDIF.
            s_lbe-ex_lgort-lgort   = '0000'.
            s_lbe-ex_lgort-lgortkz = no_sl. " no storage loc
            s_lbe-ex_lgort-sondcha = space.
            INSERT s_lbe INTO p_t_lbe INDEX 1.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDLOOP.
* sites without stocks should be shown, wbe without stocks needed
* no mard existing for the site
        IF p_kznul IS INITIAL.
          LOOP AT t_matnr WHERE satnr = zle-matnr.
            PERFORM wrk_zerostocks USING t_matnr-matnr.
          ENDLOOP.
        ENDIF.
  ENDIF.

ENDFORM.                               " BUILD_OUTTAB_TREE2

*&---------------------------------------------------------------------*
*&      Form  EXIT_VARIANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exit_variants CHANGING p_ok_code2 LIKE sy-ucomm. " tga unicode

  var_tree = no.
  CLEAR p_ok_code2.
  SET SCREEN 0.
  LEAVE SCREEN.

ENDFORM.                               " EXIT_VARIANTS

*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENTS_TREE2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM register_events_tree2.
* define the events which will be passed to the backend
  DATA: lt_v_events TYPE cntl_simple_events,
        l_v_event TYPE cntl_simple_event.

* define the events which will be passed to the backend
* l_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
* APPEND l_event TO lt_events.
* l_event-eventid = cl_gui_column_tree=>eventid_item_context_menu_req.
* APPEND l_event TO lt_events.
* l_event-eventid = cl_gui_column_tree=>eventid_header_context_men_req.
* APPEND l_event TO lt_events.
  l_v_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  APPEND l_v_event TO lt_v_events.
  l_v_event-eventid = cl_gui_column_tree=>eventid_header_click.
  APPEND l_v_event TO lt_v_events.
  l_v_event-eventid = cl_gui_column_tree=>eventid_item_keypress.
  APPEND l_v_event TO lt_v_events.
************************************************************************
  l_v_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
  APPEND l_v_event TO lt_v_events.

  l_v_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
  APPEND l_v_event TO lt_v_events.
************************************************************************

  CALL METHOD mattree2->set_registered_events
    EXPORTING
      events                    = lt_v_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.

  IF sy-subrc <> 0.
    MESSAGE x208(00) WITH 'ERROR'.                          "#EC NOTEXT
  ENDIF.

  DATA: l_v_event_receiver TYPE REF TO lcl_tree_event_receiver.
  CREATE OBJECT l_v_event_receiver.
* SET HANDLER l_event_receiver->handle_header_click FOR arttree1.
* SET HANDLER l_event_receiver->handle_item_keypress FOR arttree1.
* SET HANDLER l_event_receiver->handle_node_double_click FOR mattree1.
  SET HANDLER l_v_event_receiver->handle_item_double_click FOR mattree2.
*after_user_command   ohne vorherige Registrierung
*  SET HANDLER l_event_receiver->handle_after_user_command FOR arttree1.


ENDFORM.                               " REGISTER_EVENTS_TREE2

*&---------------------------------------------------------------------*
*&      Form  CHANGE_TOOLBAR_TREE2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_toolbar_tree2.
*get toolbar control
  CALL METHOD mattree2->get_toolbar_object
         IMPORTING
             er_toolbar = ex_v_toolbar.

  CHECK NOT ex_v_toolbar IS INITIAL.
* add seperator to toolbar
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = 'DETA'
              icon      = '@16@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-082.    "single List
* add seperator to toolbar
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT
* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = 'EKVK'
              icon      = '@3H@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-068.                         "#EC NOTEXT
* add seperator to toolbar
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = 'ZLME'
              icon      = '@BV@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-061.                         "#EC NOTEXT
* add seperator to toolbar
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = 'STRU'
              icon      = '@2Q@'
              butn_type = cntb_btype_button
              text      = ''
              quickinfo = text-096.                         "#EC NOTEXT
* add seperator to toolbar
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = ''
              icon      = ''
              butn_type = cntb_btype_sep
              text      = ''
              quickinfo = ''.                               "#EC NOTEXT

* add Dropdown Button to toolbar (for single list 'detail')
  CALL METHOD ex_v_toolbar->add_button
          EXPORTING
              fcode     = 'OTHERS'
              icon      = '@B8@'
              butn_type = cntb_btype_dropdown
              text      = ''
              quickinfo = text-097.    "UMFELD

* set event-handler for toolbar-control
  CREATE OBJECT v_toolbar_event_receiver.

  SET HANDLER v_toolbar_event_receiver->on_function_selected
                                                      FOR ex_v_toolbar.
  SET HANDLER toolbar_event_receiver->on_toolbar_dropdown
                                                      FOR ex_v_toolbar.

ENDFORM.                               " CHANGE_TOOLBAR_TREE2

*&---------------------------------------------------------------------*
*&      Form  CHANGE_OUTTAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*----------------------------------------------------------------------*
FORM change_outtab TABLES p_t_wbe TYPE t_wbe
                          p_t_lbe TYPE t_lbe.
  DATA: h_index LIKE sy-index.

  CLEAR: h_index, s_wbe, s_lbe.
* only one
  READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
  IF p_kzlgo = space.
    READ TABLE wbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
    IF sy-subrc  = 0.
      h_index = sy-tabix.
      LOOP AT wbe FROM h_index.
        IF wbe-matnr NE t_matnr-matnr. EXIT. ENDIF.  "exit from loop
        MOVE-CORRESPONDING wbe TO s_wbe.
*hier die verarbeitung bei Sonderbeständen
        IF  p_kzlso = 'X'.
          PERFORM change_sond_wrk TABLES p_t_wbe.
*                             USING  s_wbe.
        ENDIF.
        READ TABLE p_t_wbe WITH KEY matnr            = wbe-matnr
                                    bwgrp            = wbe-bwgrp
                                    ex_werks-werks   = wbe-werks
                                    ex_werks-sondcha = space.
        IF sy-subrc = 0.
          h_index = sy-tabix.
* provide key
          s_wbe-ex_werks-werks = p_t_wbe-ex_werks-werks.
          s_wbe-name1          = p_t_wbe-name1.
          MODIFY p_t_wbe FROM s_wbe INDEX h_index.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ELSEIF p_kzlgo = 'X'.
    READ TABLE lbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
    IF sy-subrc  = 0.
      h_index = sy-tabix.
      LOOP AT lbe FROM h_index.
        IF lbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
*        CLEAR: nullcheck.
        MOVE-CORRESPONDING lbe TO s_lbe.

* read to get wbe-bwgrp to complete the key of t_lbe
* note 1666055: set wbe-bwgrp before read on special stocks!
        READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                werks = s_lbe-werks BINARY SEARCH.

*hier die verarbeitung bei Sonderbeständen
        IF  p_kzlso = 'X'.
          PERFORM change_sond_lgort TABLES p_t_lbe
                                    USING  s_lbe.
        ENDIF.

        READ TABLE p_t_lbe WITH KEY matnr          =  lbe-matnr
                                    bwgrp          =  wbe-bwgrp
                                    werks          =  lbe-werks
                                    ex_lgort-lgort =  lbe-lgort
                                    ex_lgort-lgortkz = '1'
                                    ex_lgort-sondcha = space
                                    BINARY SEARCH.
        IF sy-subrc = 0.
          h_index = sy-tabix.
          s_lbe-bwgrp = wbe-bwgrp.
          s_lbe-ex_lgort-lgort    =  lbe-lgort.
          s_lbe-ex_lgort-lgortkz  = '1'.
          s_lbe-ex_lgort-sondcha  = space.
*         s_lbe-name1             = s_lbe-name1.
          MODIFY p_t_lbe FROM s_lbe INDEX h_index.
        ENDIF.
      ENDLOOP.
    ENDIF.
* hier noch die reinen werksbestände aus der t_w_lbe einstellen
    READ TABLE t_w_lbe INTO s_w_lbe
                       WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
    IF sy-subrc  = 0.
      h_index = sy-tabix.
      LOOP AT t_w_lbe INTO s_w_lbe FROM h_index.
        IF s_w_lbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
**        CLEAR: nullcheck.
        MOVE-CORRESPONDING s_w_lbe TO s_lbe.
        READ TABLE p_t_lbe WITH KEY matnr          =  s_w_lbe-matnr
*                                    bwgrp          =  wbe-bwgrp
                                     werks          =  s_w_lbe-werks
                                     ex_lgort-lgort =  '0000'
                                     ex_lgort-lgortkz = '0'
                                     ex_lgort-sondcha = space.
        IF sy-subrc = 0.
* if exists modify with converted values
          h_index = sy-tabix.
          MODIFY p_t_lbe FROM s_lbe INDEX h_index
                 TRANSPORTING menge mengk bdmng bdmns vbmna vbmnb vbmnc
                              vbmne vbmng vbmni omeng bsabr trasf wespb
                              umlmc trame glgmg.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                               " CHANGE_OUTTAB

*&---------------------------------------------------------------------*
*&      Form  CHANGE_SOND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_T_WBE  text
*      -->P_S_WBE  text
*----------------------------------------------------------------------*
FORM change_sond_wrk TABLES   p_t_wbe TYPE t_wbe.
*                    USING    p_s_wbe TYPE s_wbe.
  DATA: s_s_wbe TYPE s_wbe.
  CLEAR s_s_wbe.
* Liefbeist*************************************************************
  LOOP AT obs WHERE matnr = wbe-matnr  AND
                    werks = wbe-werks.
    ADD obs-labst TO s_s_wbe-lblab.
    ADD obs-insme TO s_s_wbe-lbins.
    ADD obs-einme TO s_s_wbe-lbein.
  ENDLOOP.
* loop done if nothing found sy-sub <> 0
  IF sy-subrc = 0.
    READ TABLE p_t_wbe WITH KEY matnr         =   wbe-matnr
                                bwgrp         =   wbe-bwgrp
                             ex_werks-werks   =   wbe-werks
                             ex_werks-sondcha =   beistlief.
    IF sy-subrc = 0.
      MODIFY  p_t_wbe FROM s_s_wbe INDEX sy-tabix
                         TRANSPORTING  lblab lbins lbein.
    ENDIF.
  ENDIF.
*Kundenbest-lgut********************************************************
  LOOP AT vbs WHERE matnr = wbe-matnr AND
                    werks = wbe-werks.

    ADD vbs-labst TO s_s_wbe-kulav.
    ADD vbs-insme TO s_s_wbe-kuinv.
    ADD vbs-einme TO s_s_wbe-kueiv.
  ENDLOOP.
  IF sy-subrc = 0.
    READ TABLE p_t_wbe WITH KEY matnr            =   wbe-matnr
                                bwgrp            =   wbe-bwgrp
                                ex_werks-werks   =  wbe-werks
                                ex_werks-sondcha = lrgutkunde.
    IF sy-subrc = 0.
      MODIFY  p_t_wbe FROM s_s_wbe INDEX sy-tabix
                         TRANSPORTING  kulav kuinv kueiv.
    ENDIF.
  ENDIF.
*kundenbest-konsi*******************************************************
  LOOP AT wbs WHERE  matnr = wbe-matnr  AND
                     werks = wbe-werks.

    ADD wbs-labst TO s_s_wbe-kulaw.
    ADD wbs-insme TO s_s_wbe-kuinw.
    ADD wbs-einme TO s_s_wbe-kueiw.
  ENDLOOP.
  IF sy-subrc = 0.
    READ TABLE p_t_wbe WITH KEY matnr            =   wbe-matnr
                                bwgrp            =   wbe-bwgrp
                                ex_werks-werks   =   wbe-werks
                                ex_werks-sondcha =   konsikunde.
    IF sy-subrc = 0.
      MODIFY    p_t_wbe FROM s_s_wbe INDEX sy-tabix
                         TRANSPORTING  kulaw kuinw kueiw.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHANGE_SOND

*&---------------------------------------------------------------------*
*&      Form  PROVIDE_HIDE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_NODE_KEY  text
*----------------------------------------------------------------------*
FORM provide_hide USING  p_lt_sel_node TYPE lvc_nkey.  " tga unicode
  IF var_tree = no.
    READ TABLE t_zle INDEX  p_lt_sel_node.
*provide hide to enable diffrent existing coding
    zeilen_kz  = t_zle-zeilen_kz.
    sond_kz    = t_zle-sond_kz.

    zle-matnr  = t_zle-matnr.
    zle-bwgrp  = t_zle-bwgrp.
    zle-werks  = t_zle-werks.
    zle-lgort  = t_zle-lgort.
    zle-lifnr  = t_zle-lifnr.
    zle-kunnr  = t_zle-kunnr.
    zle-vbeln  = t_zle-vbeln.
    zle-posnr  = t_zle-posnr.
    zle-sgt_scat = t_zle-sgt_scat.
    zle-charg    = t_zle-charg.
* stock lines  with 'space' in lgort means site level
    IF t_zle-lgort = space AND p_kzlgo = 'X'
                           AND zeilen_kz = lag_zeile.
      zeilen_kz   = wrk_zeile.
    ELSEIF sond_kz = 'O' AND zeilen_kz = lag_zeile
                         AND p_kzlgo = 'X'.
      zeilen_kz = wrk_zeile.
    ENDIF.
  ELSEIF var_tree = yes.
    READ TABLE t_v_zle INDEX  p_lt_sel_node.
*provide hide to enable diffrent existing coding
    zeilen_kz  = t_v_zle-zeilen_kz.
    sond_kz    = t_v_zle-sond_kz.

    zle-matnr  = t_v_zle-matnr.
    zle-bwgrp  = t_v_zle-bwgrp.
    zle-werks  = t_v_zle-werks.
    zle-lgort  = t_v_zle-lgort.
    zle-lifnr  = t_v_zle-lifnr.
    zle-kunnr  = t_v_zle-kunnr.
    zle-vbeln  = t_v_zle-vbeln.
    zle-posnr  = t_v_zle-posnr.
    zle-sgt_scat = t_v_zle-sgt_scat.
    zle-charg    = t_v_zle-charg.
* stock lines  with 'space' in lgort means site level
    IF t_v_zle-lgort = space AND p_kzlgo = 'X'
                           AND zeilen_kz = lag_zeile.
      zeilen_kz   = wrk_zeile.
    ENDIF.
  ENDIF.
*    leads to wrong assignment
*  var_tree        =  no.
ENDFORM.                               " PROVIDE_HIDE

*&---------------------------------------------------------------------*
*&      Form  CHANGE_SOND_LGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_T_LBE  text
*      -->P_S_LBE  text
*----------------------------------------------------------------------*
FORM change_sond_lgort TABLES   p_p_t_lbe TYPE t_lbe
                       USING    p_s_lbe   TYPE s_lbe.
  DATA: s_s_lbe TYPE s_lbe.
* kundenauftrag ********************************************************
  READ TABLE p_p_t_lbe WITH KEY matnr             =  p_s_lbe-matnr
                                bwgrp             =  wbe-bwgrp
                                werks             =  p_s_lbe-werks
                                ex_lgort-lgort    =  lbe-lgort
                                ex_lgort-lgortkz  =  '2'     "sl with so
                                ex_lgort-sondcha  =  aufbskunde
                                BINARY SEARCH.
  IF sy-subrc = 0.
* fields with values
    MODIFY p_p_t_lbe FROM p_s_lbe INDEX sy-tabix
                                  TRANSPORTING kalab kains kaspe kaein.
*   note 1666055 necessary to clear as the stocks would appear two times
    CLEAR: p_s_lbe-kalab, p_s_lbe-kains, p_s_lbe-kaspe, p_s_lbe-kaein.
  ENDIF.
* Liefkonsi **********************************************************
  READ TABLE p_p_t_lbe WITH KEY matnr             =  p_s_lbe-matnr
                                bwgrp             =  wbe-bwgrp
                                werks             =  p_s_lbe-werks
                                ex_lgort-lgort    =  lbe-lgort
                                ex_lgort-lgortkz  =  '2'  "sl with so
                                ex_lgort-sondcha  =  konsilief
                                BINARY SEARCH.
  IF sy-subrc = 0.
* fields with values
    MODIFY p_p_t_lbe FROM p_s_lbe INDEX sy-tabix
                                  TRANSPORTING klabs kinsm keinm kspem.
*   note 1666055 necessary to clear as the stocks would appear two times
    CLEAR: p_s_lbe-klabs, p_s_lbe-kinsm, p_s_lbe-keinm, p_s_lbe-kspem.
  ENDIF.
* Liefmtv***************************************************************
  READ TABLE p_p_t_lbe WITH KEY matnr             =  p_s_lbe-matnr
                                bwgrp             =  wbe-bwgrp
                                werks             =  p_s_lbe-werks
                                ex_lgort-lgort    =  lbe-lgort
                                ex_lgort-lgortkz  =  '2'  "sl with so
                                ex_lgort-sondcha  =  mtverpack
                                BINARY SEARCH.
  IF sy-subrc = 0.
* fields with values
    MODIFY p_p_t_lbe FROM p_s_lbe INDEX sy-tabix
                                  TRANSPORTING mlabs minsm meinm mspem.
*   note 1666055 necessary to clear as the stocks would appear two times
    CLEAR: p_s_lbe-mlabs, p_s_lbe-minsm, p_s_lbe-meinm, p_s_lbe-mspem.
  ENDIF.
* Liefbeist*************************************************************
  LOOP AT obs WHERE matnr = p_s_lbe-matnr  AND
                    werks = p_s_lbe-werks.

    ADD obs-labst TO s_s_lbe-lblab.
    ADD obs-insme TO s_s_lbe-lbins.
    ADD obs-einme TO s_s_lbe-lbein.
  ENDLOOP.
  IF sy-subrc = 0.
    READ TABLE p_p_t_lbe WITH KEY matnr             =  p_s_lbe-matnr
                                  bwgrp             =  wbe-bwgrp
                                  werks             =  p_s_lbe-werks
                                  ex_lgort-lgort    =  space
                                  ex_lgort-lgortkz  =  '2'  "sl with so
                                  ex_lgort-sondcha  =  beistlief
                                  BINARY SEARCH.
    IF sy-subrc = 0.
* fields with values
      MODIFY p_p_t_lbe FROM s_s_lbe INDEX sy-tabix
                                TRANSPORTING lblab lbins lbein.
    ENDIF.
    CLEAR s_s_lbe.
  ENDIF.
*Kundenbest-lgut********************************************************
  LOOP AT vbs WHERE matnr = p_s_lbe-matnr AND
                          werks = p_s_lbe-werks.
    ADD vbs-labst TO s_s_lbe-kulav.
    ADD vbs-insme TO s_s_lbe-kuinv.
    ADD vbs-einme TO s_s_lbe-kueiv.
  ENDLOOP.
  IF sy-subrc = 0.
    READ TABLE p_p_t_lbe WITH KEY matnr             =  p_s_lbe-matnr
                                  bwgrp             =  wbe-bwgrp
                                  werks             =  p_s_lbe-werks
                                  ex_lgort-lgort    =  space
                                  ex_lgort-lgortkz  =  '2'  "sl with so
                                  ex_lgort-sondcha  =  lrgutkunde
                                  BINARY SEARCH.
    IF sy-subrc = 0.
* fields with values
      MODIFY p_p_t_lbe FROM s_s_lbe INDEX sy-tabix
                                TRANSPORTING kulav kuinv kueiv.
    ENDIF.
    CLEAR s_s_lbe.
  ENDIF.
*kundenbest-konsi*******************************************************
  LOOP AT wbs WHERE  matnr = p_s_lbe-matnr  AND
                     werks = p_s_lbe-werks.

    ADD wbs-labst TO s_s_lbe-kulaw.
    ADD wbs-insme TO s_s_lbe-kuinw.
    ADD wbs-einme TO s_s_lbe-kueiw.
  ENDLOOP.
  IF sy-subrc = 0.
    READ TABLE p_p_t_lbe WITH KEY matnr           =  p_s_lbe-matnr
                                bwgrp             =  wbe-bwgrp
                                werks             =  p_s_lbe-werks
                                ex_lgort-lgort    =  space
                                ex_lgort-lgortkz  =  '2'  "sl with so
                                ex_lgort-sondcha  =  konsikunde
                                BINARY SEARCH.
    IF sy-subrc = 0.
* fields with values
      MODIFY p_p_t_lbe FROM s_s_lbe INDEX sy-tabix
                                TRANSPORTING kulaw kuinw kueiw.
    ENDIF.
    CLEAR s_s_lbe.
  ENDIF.

ENDFORM.                               " CHANGE_SOND_LGORT


*&---------------------------------------------------------------------*
*&      Form  RETCODE_AUS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM retcode_aus_alv USING p_lt_sel_node TYPE lvc_nkey    "tga unicode
                           p_lt_sel_name TYPE lvc_fname   "tga unicode
                           p_sav_zle     LIKE zle         "tga unicode
                           p_sav_zeilen_kz TYPE c         "tga unicode
                           p_sav_sond_kz TYPE c.          "tga unicode
*---- Markierte Variante ermitteln ------------------------------------*
  READ TABLE t_varart WITH KEY knsta = '#'.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_VARART'.
*   Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle &
  ENDIF.
* here the tree for vartiants is called
  var_tree        =  yes.
* hide informations from initial screen
  zle        =  p_sav_zle.
  zeilen_kz  =  p_sav_zeilen_kz.
  sond_kz    =  p_sav_sond_kz.
  CALL SCREEN 810 STARTING AT 20 04.
  CALL METHOD mattree2->delete_all_nodes.
  CLEAR: t_varart, t_varme.
* tga note 356164 / start
  zle        =  p_sav_zle.
  zeilen_kz  =  p_sav_zeilen_kz.
  sond_kz    =  p_sav_sond_kz.
* tga note 356164 / end
  PERFORM matrix_aus_alv USING p_lt_sel_node p_lt_sel_name.
*    sel_variante = t_varart-matnr.
*    drilldown_level = einzvar_level.

ENDFORM.                               " RETCODE_AUS_ALV

*&---------------------------------------------------------------------*
*&      Form  SAV_OUTTAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_WBE  text
*      -->P_T_LBE  text
*      -->P_SAV_GT_WBE  text
*      -->P_SAV_GT_LBE  text
*----------------------------------------------------------------------*
FORM sav_outtab TABLES   p_t_wbe      TYPE t_wbe
                         p_t_lbe      TYPE t_lbe
                         p_sav_t_wbe  TYPE t_wbe
                         p_sav_t_lbe  TYPE t_lbe
                         p_gt_wbe     TYPE t_wbe
                         p_gt_lbe     TYPE t_lbe
                         p_sav_gt_wbe TYPE t_wbe
                         p_sav_gt_lbe TYPE t_lbe.
* save of gt_outtabs of maintree
  IF  p_kzlgo = space.
    p_sav_t_wbe[]  = p_t_wbe[].
    p_sav_gt_wbe[] = p_gt_wbe[].
  ELSE.
    p_sav_t_lbe[]  = p_t_lbe[].
    p_sav_gt_lbe[] = p_gt_lbe[].
  ENDIF.

ENDFORM.                               " SAV_OUTTAB

*&---------------------------------------------------------------------*
*&      Form  REST_OUTTAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*      -->P_SAV_T_WBE  text
*      -->P_SAV_T_LBE  text
*      -->P_GT_WBE  text
*      -->P_GT_LBE  text
*      -->P_SAV_GT_WBE  text
*      -->P_SAV_GT_LBE  text
*----------------------------------------------------------------------*
FORM rest_outtab TABLES  p_t_wbe       TYPE t_wbe
                         p_t_lbe       TYPE t_lbe
                         p_sav_t_wbe   TYPE t_wbe
                         p_sav_t_lbe   TYPE t_lbe
                         p_gt_wbe      TYPE t_wbe
                         p_gt_lbe      TYPE t_lbe
                         p_sav_gt_wbe  TYPE t_wbe
                         p_sav_gt_lbe  TYPE t_lbe.
* restore of gt_outtabs of maintree
  IF  p_kzlgo = space.
    p_t_wbe[]  = p_sav_t_wbe[].
    p_gt_wbe[] = p_sav_gt_wbe[].
  ELSE.
    p_t_lbe[] =  p_sav_t_lbe[].
    p_gt_lbe[] = p_sav_gt_lbe[].
  ENDIF.

ENDFORM.                               " REST_OUTTAB

*&---------------------------------------------------------------------*
*&      Form  FCODE_MATTREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_SEL_NODE  text
*      <--P_OK_CODE1  text
*----------------------------------------------------------------------*
FORM fcode_mattree USING    p_lt_sel_node  TYPE lvc_nkey    "tga unicode
                            p_lt_sel_name  TYPE lvc_fname   "tga unicode
                    CHANGING p_ok_code     LIKE sy-ucomm.   "tga unicode

* tga note 356164
*  IF NOT p_ok_code EQ 'EXIT' OR NOT p_ok_code EQ 'ENDE'
*                             OR NOT p_ok_code EQ 'CANC'.
   IF NOT p_ok_code EQ 'EXIT' AND
      NOT p_ok_code EQ 'ENDE' AND
      NOT p_ok_code EQ 'CANC'.

    PERFORM provide_hide   USING p_lt_sel_node.
  ENDIF.
ENHANCEMENT-POINT RWBE1F09_G11 SPOTS ES_RWBEST01 .

  CASE p_ok_code.
    WHEN 'EXIT' OR 'ENDE' OR 'CANC'.
      PERFORM exit_program.
    WHEN 'MATX'.
*     PERFORM provide_hide   USING p_lt_sel_node.
      PERFORM matrix_aus_alv USING p_lt_sel_node p_lt_sel_name.
    WHEN 'EKVK'.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        drilldown_level = einzart_level.
        PERFORM ek_vk_anzeigen.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN zul_me.
      DATA new_unit. CLEAR new_unit.
      tree_act = maintree_act.         " only maintree possible.
*       PERFORM provide_hide USING p_lt_sel_node.
*cursor in line with unit
      IF zle-bwgrp IS INITIAL.
        PERFORM units_in_alv CHANGING new_unit.
        IF NOT new_unit IS INITIAL.
*change outtab with converted values
          PERFORM change_outtab TABLES t_wbe t_lbe.
          PERFORM change_nodes USING lt_sel_node tree_act.
          CALL METHOD mattree1->update_calculations.
        ENDIF.
      ELSE.
        MESSAGE i044.
      ENDIF.

    WHEN 'MM43'.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM material_stammdaten.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN 'MMBE'.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM alte_bestandsuebersicht.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN md04.
*     PERFORM provide_hide USING p_lt_sel_node.
      PERFORM bedarfsliste.
    WHEN me2m.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM bestellungen.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN mb24.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM reservierungen.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN mb51.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM materialbewegungen.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN ls26.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM lvs_quants.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN 'STRU'.
      IF NOT p_lt_sel_node IS INITIAL.
*       PERFORM provide_hide USING p_lt_sel_node.
        PERFORM info_struct_art.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN equi.                                          "v note 2274587
      IF NOT p_lt_sel_node IS INITIAL.
        PERFORM equi_anzeigen.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN 'HULI'.
      IF NOT p_lt_sel_node IS INITIAL.
        PERFORM handling_unit.
      ELSE.
        MESSAGE i019.
      ENDIF.
    WHEN co21.
      IF NOT p_lt_sel_node IS INITIAL.
        PERFORM fertauftraege.
      ELSE.
        MESSAGE i019.
      ENDIF.                                            "^ note 2274587
    WHEN OTHERS.
      CALL METHOD cl_gui_cfw=>dispatch.
  ENDCASE.
  CLEAR: p_ok_code, drilldown_level.

ENDFORM.                               " FCODE_MATTREE1

*&---------------------------------------------------------------------*
*&      Form  PREPARE_MEFELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_mefeld USING p_gt_fieldcat TYPE lvc_t_fcat.
  DATA: count TYPE  i,
        h_index LIKE sy-tabix.

  DESCRIBE TABLE t_mefeld LINES count.
  IF count < '1'.
* fields with quantities specified in fieldcatalogue after key,
* text etc, these fields are summed up in ALV if do_sum = X
    READ TABLE gt_fieldcat INTO gs_fieldcat WITH KEY do_sum = 'X'.
    h_index = sy-tabix.
    LOOP AT p_gt_fieldcat INTO gs_fieldcat FROM h_index.
      t_mefeld-fname = gs_fieldcat-fieldname.
      APPEND t_mefeld.
    ENDLOOP.

*   note 1666055: add also LBKUM to do uom conversion in tree case
*   to have correct values on the EK/VK popup
    READ TABLE t_mefeld WITH KEY fname = 'LBKUM' BINARY SEARCH.
    IF sy-subrc NE 0.
      t_mefeld-fname = 'LBKUM'.
      INSERT t_mefeld INDEX sy-tabix.
    ENDIF.
  ENDIF.
ENDFORM.                               " PREPARE_MEFELD
*&---------------------------------------------------------------------*
*&      Form  CHK_NEGQUANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ITEM_LAYOUT  text
*      <--P_LS_ITEM_LAYOUT  text
*----------------------------------------------------------------------*
FORM chk_negquant TABLES   p_lt_item_layout TYPE lvc_t_layi
                  USING    p_ls_item_layout TYPE lvc_s_layi
                           p_s_bes          TYPE any.

  FIELD-SYMBOLS: <fc> TYPE any.
  DATA: chk_name(30) TYPE c,
        h_index LIKE sy-tabix,
        c_wbe   TYPE s_wbe,
        c_lbe   TYPE s_lbe.
  CLEAR: p_ls_item_layout.

    IF p_kzlgo IS INITIAL.
      MOVE p_s_bes TO c_wbe.
      MOVE 'C_WBE-' TO chk_name(6).
    ELSE.
      MOVE p_s_bes TO c_lbe.
      MOVE 'C_LBE-' TO chk_name(6).
    ENDIF.
* fields with quantities specified in fieldcatalogue after key,
* text etc, these fields are summed up in ALV if do_sum = X
* so find first with do_sum to get a start index
* tga / note 326933, possible, that table is not sorted as expected
*  READ TABLE gt_fieldcat INTO gs_fieldcat with key do_sum = 'X'.
*  h_index = sy-tabix.

*  LOOP AT gt_fieldcat INTO gs_fieldcat from h_index.
  LOOP AT gt_fieldcat INTO gs_fieldcat WHERE do_sum EQ 'X'.

    MOVE gs_fieldcat-fieldname TO chk_name+6.
    ASSIGN (chk_name) TO <fc>.
    IF <fc> LT 0.
       MOVE gs_fieldcat-fieldname TO p_ls_item_layout-fieldname.
       MOVE 5                     TO p_ls_item_layout-style.
       INSERT p_ls_item_layout INTO p_lt_item_layout INDEX 1.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " CHK_NEGQUANT
*&---------------------------------------------------------------------*
*&      Form  wrk_zerostocks
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM wrk_zerostocks USING p_matnr TYPE matnr.   "tga unicode
  DATA:  h_index LIKE sy-tabix.
  DATA h_s_lbe TYPE s_lbe.
  READ TABLE wbe  WITH KEY matnr = p_matnr.
  h_index = sy-tabix.
  LOOP AT wbe FROM h_index.
    IF wbe-matnr NE p_matnr. EXIT. ENDIF.
   MOVE-CORRESPONDING wbe TO s_wbe.
   PERFORM checknull_werk USING s_wbe.
   IF nullcheck IS INITIAL.
      h_s_lbe-matnr            = wbe-matnr.
      h_s_lbe-bwgrp            = wbe-bwgrp.
      h_s_lbe-werks            = wbe-werks.
      h_s_lbe-ex_lgort-lgort   = '0000'.
      h_s_lbe-ex_lgort-lgortkz = no_sl.     "no storage location
      h_s_lbe-ex_lgort-sondcha = space.
* if read was successfull, a row for the current article
* on site level exists => no insert
      READ TABLE t_lbe INTO s_lbe WITH KEY matnr = p_matnr
                                           werks = wbe-werks.
      IF sy-subrc <> 0.
       INSERT h_s_lbe INTO t_lbe INDEX 1.
      ENDIF.
   ELSE.
    CLEAR nullcheck.
   ENDIF.
  ENDLOOP.

ENDFORM.                    " wrk_zerostocks
*&---------------------------------------------------------------------*
*&      Form  build_tooltip
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ICON  text
*      <--P_H_TV_IMAGE  text
*----------------------------------------------------------------------*
FORM build_tooltip  CHANGING p_icon     TYPE any
                             p_text     TYPE char40
                             p_tv_image TYPE tv_image.



        CALL FUNCTION 'ICON_CREATE'
          EXPORTING
            name                        = p_icon
*           TEXT                        = ' '
            info                        = p_text
*           ADD_STDINF                  = 'X'
          IMPORTING
            result                      = p_tv_image
*         EXCEPTIONS
*           ICON_NOT_FOUND              = 1
*           OUTPUTFIELD_TOO_SHORT       = 2
*           OTHERS                      = 3
                  .
*        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ENDIF.
CLEAR: p_icon, p_text.

ENDFORM.                    " build_tooltip
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CMATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*      -->P_2029   text
*      -->P_NODE_LEVEL  text
*      <--P_L_MATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_cmatnr USING    p_s_cbe      TYPE s_cbe
                             p_relat_key  TYPE lvc_nkey
                             p_node_level TYPE c          "tga unicode
                    CHANGING p_node_key   TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_cbe TYPE s_cbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.

  IF NOT t_matnr-attyp = attyp_sam.
* tga / accessibility
    MOVE '@3Q@'   TO h_icon.
    MOVE text-111 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
* mat to delete
    IF t_matnr-lvorm NE space.
      CLEAR: ls_item_layout.           "noch mal prüfen
      ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
      MOVE '@11@' TO h_icon.
      MOVE text-105 TO h_text.
      PERFORM build_tooltip USING    h_icon
                                     h_text
                            CHANGING h_tv_image.
      ls_item_layout-t_image = h_tv_image. "icon delete
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.
* give a special sign if it's a generic article
  ELSE.
    CLEAR ls_item_layout.
* tga / accessibility
      MOVE '@0R@' TO h_icon.
      MOVE text-013 TO h_text.
      PERFORM build_tooltip USING    h_icon
                                     h_text
                            CHANGING h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.
* give a special sign if it's a component
  PERFORM check_structured_article TABLES t_matnr.
  IF strart_exist = yes.
    CLEAR ls_item_layout.
* tga / accessibility tooltip for tree-icon
    MOVE '@2Q@' TO h_icon.
    MOVE text-112 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    ls_item_layout-fieldname = 'NAME1'.
    ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.

  WRITE p_s_cbe-matnr TO l_node_text.
  lr_cbe-meinh = t_matnr-meins.
  lr_cbe-name1 = t_matnr-maktx.
ENHANCEMENT-POINT RWBE1F09_01 SPOTS ES_RWBEST01 .

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-matnr '' '' ''
                                   p_s_cbe-meinh p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.

    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr '' '' ''
                                   p_s_cbe-meinh p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_CMATNR
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CBWGRP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*      -->P_L_MATNR_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_BWGRP_KEY  text
*----------------------------------------------------------------------*
FORM line_of_cbwgrp  USING  p_s_cbe      TYPE s_cbe
                            p_relat_key  TYPE lvc_nkey
                            p_node_level TYPE c
                   CHANGING p_node_key   TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_cbe TYPE s_cbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
* tga / accessibility
  MOVE '@A5@' TO h_icon.
  MOVE text-027 TO h_text.
  PERFORM build_tooltip CHANGING h_icon
                                 h_text
                                 h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style   =
                        cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

* add node inital
  l_node_text =  p_s_cbe-bwgrp.
  IF p_s_cbe-bwgrp = dummy_bwgrp.
    l_node_text  = text-036.
    lr_cbe-name1 = text-035.
  ELSE.
    READ TABLE t_bwgrp WITH KEY bwgrp = p_s_cbe-bwgrp BINARY SEARCH.
    lr_cbe-name1 = t_bwgrp-bwgbz.
  ENDIF.
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-matnr  p_s_cbe-bwgrp
                              '' '' p_s_cbe-meinh p_node_level ''
                              t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr  p_s_cbe-bwgrp
                                   '' '' '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.

ENDFORM.                    " LINE_OF_CBWGRP
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CWERKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*      -->P_L_BWGRP_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_WERKS_KEY  text
*----------------------------------------------------------------------*
FORM line_of_cwerks USING    p_s_cbe TYPE s_cbe
                             p_relat_key TYPE lvc_nkey
                             p_node_level TYPE c
                    CHANGING p_node_key TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_cbe TYPE s_cbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.


  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
  CLEAR wbe.
  READ TABLE t_werks WITH KEY werks = p_s_cbe-werks BINARY SEARCH.
  IF t_werks-vlfkz = 'A'.
* tga / accessibility
    MOVE '@A8@' TO h_icon.                  "icon plant
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = 'B'.
* tga / accessibility
* tga / wrong icon
*    MOVE '@A8@' TO h_icon.                  "icon dc
    MOVE '@A1@' TO h_icon.            " icon dc
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

  ELSEIF t_werks-vlfkz = ' '.
* tga / accessibility
    MOVE '@A8@' TO h_icon.                  "icon plant
    MOVE text-028 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style   =
                        cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

* material to delete ?
  IF t_matnr-lvorm NE space.
    CLEAR: ls_item_layout.
    ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
    MOVE '@11@' TO h_icon.                 " icon delete
    MOVE text-105 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    APPEND ls_item_layout TO lt_item_layout.
  ELSE.
    READ TABLE wbe WITH KEY matnr = p_s_cbe-matnr
                            bwgrp = p_s_cbe-bwgrp
                            werks = p_s_cbe-werks
                            BINARY SEARCH.
    IF wbe-lvorm NE space.
      CLEAR: ls_item_layout.
      ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
      MOVE '@11@' TO h_icon.                 " icon delete
      MOVE text-105 TO h_text.
      PERFORM build_tooltip CHANGING h_icon
                                     h_text
                                     h_tv_image.
      ls_item_layout-t_image = h_tv_image.
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.
  ENDIF.

* add node inital
  l_node_text =  p_s_cbe-werks.
  READ TABLE t_werks WITH KEY werks = p_s_cbe-werks BINARY SEARCH.
  lr_cbe-name1 = t_werks-wrkbz.        " text!!tga
  IF wbe-menge IS NOT INITIAL.
    lr_cbe-menge = wbe-menge.
  ENDIF.
  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks '' ''
                                   p_node_level '' t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks '' ''
                                   p_node_level '' t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.

ENDFORM.                    " LINE_OF_CWERKS
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CLGORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*      -->P_L_WERKS_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_LGORT_KEY  text
*----------------------------------------------------------------------*
FORM line_of_clgort  USING    p_s_cbe    TYPE s_cbe
                              p_relat_key TYPE lvc_nkey
                              p_node_level TYPE c        "tga unicode
                     CHANGING p_node_key TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_cbe      TYPE s_cbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.
  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.
  CLEAR lbe.
  IF p_s_cbe-ex_lgort-lgortkz    = '2'.
* tga / accessibility
    MOVE '@EL@' TO h_icon.              " icon when special stock exists
    MOVE text-114 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.

    READ TABLE cbe WITH KEY matnr = p_s_cbe-matnr
                            werks = p_s_cbe-werks
                            charg = gv_charg.
    IF sy-subrc IS INITIAL.
      p_s_cbe-ex_lgort-lgort = cbe-lgort.
    ENDIF.


  ELSE.

    MOVE '@AC@' TO h_icon.
    MOVE text-029 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
  ENDIF.

* For no batch level stock,we are showing plant level stock
* at this point of time no need to show segment and batch if stock is not there
  READ TABLE t_cbe INTO DATA(ls_cbe) WITH KEY matnr    = p_s_cbe-matnr
                                              werks    = p_s_cbe-werks
                                              ex_lgort = p_s_cbe-ex_lgort." BINARY SEARCH.
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING ls_cbe TO lr_cbe.
  ENDIF.

    ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
    ls_item_layout-style   = cl_gui_column_tree=>style_intensifd_critical.
    APPEND ls_item_layout TO lt_item_layout.

    READ TABLE lbe WITH KEY matnr = p_s_cbe-matnr
                            werks = p_s_cbe-werks
                            lgort = p_s_cbe-ex_lgort-lgort
                            BINARY SEARCH.
    IF lbe-lvorm NE space.
      clear: ls_item_layout.
      ls_item_layout-fieldname = 'LVORM'.
      MOVE '@11@' TO h_icon.                 " icon delete
      MOVE text-105 TO h_text.
      PERFORM build_tooltip CHANGING h_icon
                                     h_text
                                     h_tv_image.
      ls_item_layout-t_image = h_tv_image.
      APPEND ls_item_layout TO lt_item_layout.
    ENDIF.

  l_node_text =  p_s_cbe-ex_lgort-lgort.

  CASE  p_s_cbe-ex_lgort-lgortkz.
    WHEN no_sl.
* werks only, needed for accumulation on higher levels
      ls_node_layout-hidden = 'X'.
    WHEN norm_sl.                      "normal stor loc
      SELECT SINGLE * FROM t001l
                    WHERE werks = p_s_cbe-werks
                    AND   lgort = p_s_cbe-ex_lgort-lgort.
      lr_cbe-name1 = t001l-lgobe.
    WHEN sp_sl.                        "special stocks
      CASE p_s_cbe-ex_lgort-sondcha.
        WHEN konsilief.
          IF NOT konsilief IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  konsilief.
          lr_cbe-name1 = text-047.
        WHEN aufbskunde.
          IF NOT aufbskunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  aufbskunde.
          lr_cbe-name1 = text-048.
        WHEN mtverpack.
          IF NOT mtverpack IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  mtverpack.
          lr_cbe-name1 = text-049.
        WHEN beistlief.
          IF NOT beistlief IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  beistlief.    "Lieferantenbeistellung
          lr_cbe-name1 = text-058.
        WHEN lrgutkunde.
          IF NOT lrgutkunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  lrgutkunde.   "Kundenleihgut
          lr_cbe-name1 = text-046.
        WHEN konsikunde.
          IF NOT konsikunde IN s_sobkz.
            ls_node_layout-hidden = 'X'.
          ENDIF.
          l_node_text =  konsikunde.   "Kundenkonsignation
          lr_cbe-name1 = text-045.
      ENDCASE.
  ENDCASE.

  lr_cbe-ex_lgort-lgort = p_s_cbe-ex_lgort-lgort.
  IF lbe-menge IS NOT INITIAL.
    lr_cbe-menge = lbe-menge.
  ELSEIF p_s_cbe-ex_lgort-lgort EQ '0000' AND
         t_matnr-attyp          NE '01'.
    READ TABLE wbe WITH KEY matnr = p_s_cbe-matnr
                            bwgrp = p_s_cbe-bwgrp
                            werks = p_s_cbe-werks
                            BINARY SEARCH.
    IF sy-subrc = 0.
      lr_cbe-menge = wbe-menge.
      CLEAR wbe.
    ENDIF.
  ENDIF.
ENHANCEMENT-POINT EP_RWBE1F09_02 SPOTS ES_RWBEST01 .

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_cbe-ex_lgort-sondcha
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
*   provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_cbe-ex_lgort-sondcha
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_CLGORT
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CSCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TT_CBE  text
*      -->P_S_CBE  text
*      -->P_L_LGORT_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_L_SCAT_KEY  text
*----------------------------------------------------------------------*
FORM line_of_cscat  USING    p_tt_cbe       TYPE t_cbe
                             p_s_cbe        TYPE s_cbe
                             p_relat_key    TYPE lvc_nkey
                             p_node_level   TYPE c
                    CHANGING p_node_key     TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value,
        lr_cbe      TYPE s_cbe,
        wa_cbe      TYPE s_cbe.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.

  IF p_s_cbe-ex_lgort-lgort IS INITIAL.
    READ TABLE cbe WITH KEY matnr = p_s_cbe-matnr
                            werks = p_s_cbe-werks
                            charg = gv_charg.
    IF sy-subrc IS INITIAL.
      p_s_cbe-ex_lgort-lgort = cbe-lgort.
    ENDIF.
  ENDIF.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

* set item-layout
  DATA: lt_item_layout TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.

* tga / accessibility
    MOVE '@56@' TO h_icon.
    MOVE text-119 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
*  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style   = cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

* node with values in outtab line
 l_node_text = p_s_cbe-sgt_scat.
 lr_cbe-sgt_scat = p_s_cbe-sgt_scat.
* text
  READ TABLE t_mara1 WITH KEY matnr = p_s_cbe-matnr.
  IF sy-subrc IS INITIAL.
    CALL FUNCTION 'SGTG_GET_COMBI_TEXT'
      EXPORTING
        iv_csgr             = t_mara1-sgt_csgr
        iv_catv             = p_s_cbe-sgt_scat
     IMPORTING
       EV_COMBI_TEXT        = lr_cbe-name1.
              .
    IF sy-subrc NE 0.
      CLEAR lr_cbe-name1.
    ENDIF.
  ENDIF.


  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      IF p_s_cbe-sgt_scat IS NOT INITIAL.
       PERFORM fill_zle_hide TABLES t_v_zle
                             USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                    p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                    '' p_node_level
                                    ' '
                                    t_matnr-attyp ' ' p_s_cbe-sgt_scat.
      ELSE.
* some cases blank stock-segment is allowed at this time,when you doubli click on
* blank stock-segment it is Exit the process in order to avoid it passing batch
       PERFORM fill_zle_hide TABLES t_v_zle
                             USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                    p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                    '' p_node_level
                                    ' '
                                    t_matnr-attyp gv_charg p_s_cbe-sgt_scat.
      ENDIF.
    ENDIF.
  ELSE.                                "maintree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      IF p_s_cbe-sgt_scat IS NOT INITIAL.

      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_cbe-ex_lgort-sondcha
                                   t_matnr-attyp ' ' p_s_cbe-sgt_scat.
      ELSE.
* some cases blank stock-segment is allowed at this time,when you doubli click on
* blank stock-segment it is Exit the process in order to avoid it passing batch
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr p_s_cbe-bwgrp
                                   p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_cbe-ex_lgort-sondcha
                                   t_matnr-attyp gv_charg p_s_cbe-sgt_scat.

      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_CSCAT
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CHARG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_L_SCAT_KEY  text
*      -->P_NODE_LEVEL  text
*      <--P_S_CBE  text
*      <--P_L_LAST_KEY  text
*----------------------------------------------------------------------*
FORM line_of_charg  USING   p_relat_key   TYPE lvc_nkey
                            p_node_level  TYPE c         "tga unicode
                   CHANGING p_s_cbe TYPE  s_cbe
                            p_node_key    TYPE lvc_nkey.

  DATA: l_node_text TYPE lvc_value.
*        lr_wbe TYPE s_wbe.
  DATA: lt_item_layout  TYPE lvc_t_layi,
        ls_item_layout TYPE lvc_s_layi.

* tga / accessibility
  DATA: h_tv_image TYPE tv_image,
        h_icon(6)  TYPE c,
        h_text     TYPE char40.

* set node-layout
  DATA: ls_node_layout TYPE lvc_s_layn.

  IF p_s_cbe-ex_lgort-lgort IS INITIAL.
    READ TABLE cbe WITH KEY matnr = p_s_cbe-matnr
                            werks = p_s_cbe-werks
                            charg = p_s_cbe-charg.
    IF sy-subrc IS INITIAL.
      p_s_cbe-ex_lgort-lgort = cbe-lgort.
    ENDIF.
  ENDIF.

  ls_node_layout-n_image   = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

  ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.

* tga / accessibility
    MOVE '@EJ@' TO h_icon.
    MOVE text-114 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
*  ENDIF.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  APPEND ls_item_layout TO lt_item_layout.

*  mat to delete
  IF p_s_cbe-lvorm NE space.
    CLEAR: ls_item_layout, p_s_cbe-lvorm.                   "
    ls_item_layout-fieldname = 'LVORM'.
* tga / accessibility
    MOVE '@11@' TO h_icon.                 " icon delete
    MOVE text-105 TO h_text.
    PERFORM build_tooltip CHANGING h_icon
                                   h_text
                                   h_tv_image.
    ls_item_layout-t_image = h_tv_image.
    APPEND ls_item_layout TO lt_item_layout.
  ENDIF.

  l_node_text =  p_s_cbe-charg.
ENHANCEMENT-POINT EP_RWBE1F09_03 SPOTS ES_RWBEST01 .

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-matnr  p_s_cbe-bwgrp
                                   p_s_cbe-werks p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   ' '
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.                                "main tree
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = p_s_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
* provide 'hide area'
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-matnr  p_s_cbe-bwgrp
                                   p_s_cbe-werks  p_s_cbe-ex_lgort-lgort
                                   '' p_node_level
                                   p_s_cbe-ex_lgort-sondcha
                                   t_matnr-attyp p_s_cbe-charg p_s_cbe-sgt_scat.
    ENDIF.
  ENDIF.

ENDFORM.                    " LINE_OF_CHARG
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_CSATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*      -->P_2253   text
*      -->P_NODE_LEVEL  text
*      <--P_L_SATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_csatnr  USING    p_s_cbe       TYPE s_cbe
                              p_relat_key   TYPE lvc_nkey
                              p_node_level  TYPE c
                     CHANGING p_node_key    TYPE lvc_nkey.

  DATA:
    l_node_text    TYPE lvc_value,
    lr_cbe         TYPE s_cbe,
    h_tv_image     TYPE tv_image,
    h_icon(6)      TYPE C,
    h_text         TYPE CHAR40,
    ls_node_layout TYPE lvc_s_layn,
    lt_item_layout TYPE lvc_t_layi,
    ls_item_layout TYPE lvc_s_layi.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

  clear ls_item_layout.
* tga / accessibility
  MOVE '@0R@' TO h_icon.
  MOVE text-013 TO h_text.
  PERFORM build_tooltip USING    h_icon
                                 h_text
                        CHANGING h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

  WRITE p_s_cbe-satnr TO l_node_text.
  lr_cbe-meinh = t_matnr-meins.
  lr_cbe-name1 = t_matnr-maktx.

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_cbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_cbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_cbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_CSATNR
*&---------------------------------------------------------------------*
*&      Form  BUILD_GEN_OUTTAB_TREE1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*      -->P_T_CBE  text
*----------------------------------------------------------------------*
FORM build_gen_outtab_tree1  TABLES p_t_wbe TYPE t_wbe
                                    p_t_lbe TYPE t_lbe
                                    p_t_cbe TYPE t_cbe.

  DATA: h_index LIKE sy-index,
        mr_toolbar TYPE REF TO cl_gui_toolbar,
        lt_fieldcatalog     TYPE lvc_t_fcat,
        ls_fieldcatalog     TYPE lvc_s_fcat,
        ls_hierarchy_header TYPE treev_hhdr,
        spec_exist.          " special stocks found
  DATA: BEGIN OF lt_lbe OCCURS 0.
          INCLUDE STRUCTURE lbe.
  DATA: END   OF lt_lbe.
  REFRESH: p_t_wbe, p_t_lbe , p_t_cbe.

  SORT cbe ASCENDING BY matnr.
* in the following the outtab which will be given to the tree control
* will be build on site or storage location level
  LOOP AT t_matnr.
****** Stock segment level
    IF  p_chrg EQ 'X'.
* If batch stock exist for the material
      READ TABLE cbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT cbe FROM h_index.
        IF cbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
        CLEAR s_cbe.
ENHANCEMENT-SECTION RWBE1F09_G3 SPOTS ES_RWBEST01 .
        MOVE-CORRESPONDING cbe TO s_cbe.
        READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                werks = s_cbe-werks BINARY SEARCH.
        IF sy-subrc = 0.
          s_cbe-bwgrp = wbe-bwgrp.
        ELSE.
           CHECK 'x' = 'y'.     "leave current loop pass
        ENDIF.
        IF p_kzcha EQ 'X'.
          CLEAR s_cbe-sgt_scat.
        ENDIF.

        IF p_kzlso = 'X'.       "Special Stock
          PERFORM provide_sp_charg TABLES    p_t_cbe
                                   CHANGING  s_cbe spec_exist.
        ENDIF.
        s_cbe-ex_lgort-lgortkz = norm_sl.
        s_cbe-ex_lgort-lgort   = cbe-lgort.
        s_cbe-ex_lgort-sondcha = space.

        INSERT s_cbe INTO p_t_cbe INDEX 1.

END-ENHANCEMENT-SECTION.
      ENDLOOP.
      IF p_kzsea IS INITIAL.
        lt_lbe[] = lbe[].
        CLEAR s_cbe.
        IF p_t_cbe[] IS NOT INITIAL.
          LOOP AT p_t_cbe INTO s_cbe WHERE matnr = t_matnr-matnr.
            READ TABLE lt_lbe WITH KEY matnr = s_cbe-matnr
                                       werks = s_cbe-werks
                                       lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
            IF sy-subrc = 0.
              DELETE TABLE lt_lbe FROM lt_lbe.
            ENDIF.
          ENDLOOP.
        ENDIF.
* If there is no batch stock we will display plant level stock
        READ TABLE lt_lbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
        h_index = sy-tabix.
          LOOP AT lt_lbe FROM h_index.
            IF lt_lbe-matnr NE t_matnr-matnr.
              EXIT.
            ENDIF.
            CLEAR: nullcheck, s_cbe, spec_exist.
            MOVE-CORRESPONDING lt_lbe TO s_cbe.
*      here the special stocks are processed
            IF  p_kzlso = 'X'.
              PERFORM provide_sp_charg TABLES p_t_cbe
                                       CHANGING s_cbe spec_exist.
            ENDIF.
*      zerocheck for 'normal' stocks if no special stock exists
            IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
              PERFORM checknull_charg USING s_cbe.
            ELSE.
              nullcheck = '1'.
            ENDIF.
            IF NOT nullcheck IS INITIAL.
              READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                      werks = s_cbe-werks BINARY SEARCH.
              IF sy-subrc = 0.
                s_cbe-bwgrp = wbe-bwgrp.
              ELSE.
                 CHECK 'x' = 'y'.     "leave current loop pass
              ENDIF.
*    normal stocks of lgort ( sl )
              s_cbe-ex_lgort-lgort   = lt_lbe-lgort.
              s_cbe-ex_lgort-lgortkz = norm_sl."normaler Lagerort
              s_cbe-ex_lgort-sondcha = space.

              INSERT s_cbe INTO p_t_cbe INDEX 1.
            ENDIF.
          ENDLOOP.
* sites without stocks should be shown, wbe without stocks needed
* no mard existing for the site
          IF p_kznul IS INITIAL.
             PERFORM wrk_zerostocks_cbe USING t_matnr-matnr.
          ENDIF.
* here the werks only stocks are given to the outtab ( werks only means
* stocks on site level which can exist also on storage loc level )
* these stocks are necessary for the cumulation on higher levels
          LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = t_matnr-matnr.
            CLEAR s_cbe.
            MOVE-CORRESPONDING s_w_lbe TO s_cbe.
            READ TABLE wbe WITH KEY matnr = s_w_lbe-matnr
                                    werks = s_w_lbe-werks BINARY SEARCH.
            IF sy-subrc = 0.
              s_cbe-bwgrp = wbe-bwgrp.
              s_cbe-satnr = wbe-satnr.
            ELSE.
               CHECK 'x' = 'y'.
            ENDIF.
            s_cbe-ex_lgort-lgort   = '0000'.
            s_cbe-ex_lgort-lgortkz = no_sl."normaler Lagerort
            s_cbe-ex_lgort-sondcha = space.

            INSERT s_cbe INTO p_t_cbe INDEX 1.
          ENDLOOP.
      ELSE.
ENHANCEMENT-POINT RWBE1F09_08 SPOTS ES_RWBEST01 .

      ENDIF.
****** here the site site level
   ELSEIF p_kzlgo NE 'X' .
* for first display no variants if the gen. art. is also selected
      READ TABLE wbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT wbe FROM h_index.
        IF wbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
* tga note 356164
        CLEAR: nullcheck, spec_exist, s_wbe.
*       CLEAR: nullcheck, spec_exist.
        MOVE-CORRESPONDING wbe TO s_wbe.
        s_wbe-ex_werks-werks = wbe-werks.
*here the special stocks are processed
        IF  p_kzlso = 'X'.
          PERFORM provide_sp_werks TABLES p_t_wbe
                                   CHANGING spec_exist s_wbe.
        ENDIF.
* check zero stocks when p_kznul is choosen
        IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
          PERFORM checknull_werk USING s_wbe.
        ELSE.
          nullcheck = '1'.
        ENDIF.
*
        IF NOT nullcheck IS INITIAL.
*         s_wbe-ex_werks-werks = wbe-werks.
          INSERT s_wbe INTO p_t_wbe INDEX 1.
        ENDIF.
      ENDLOOP.                            "loop at wbe
****** here the storage location level**********************************
    ELSEIF p_kzlgo EQ 'X'.

      CLEAR: obs, vbs, wbs.
      READ TABLE lbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      h_index = sy-tabix.
      LOOP AT lbe FROM h_index.
        IF lbe-matnr NE t_matnr-matnr. EXIT. ENDIF.
        CLEAR: nullcheck, s_lbe, spec_exist.
        MOVE-CORRESPONDING lbe TO s_lbe.
*here the special stocks are processed
        IF  p_kzlso = 'X'.
          PERFORM provide_sp_lgort TABLES p_t_lbe
                                   CHANGING s_lbe spec_exist.
        ENDIF.
*  zerocheck for 'normal' stocks if no special stock exists
        IF NOT p_kznul IS INITIAL AND spec_exist IS INITIAL.
          PERFORM checknull_lgort USING s_lbe.
        ELSE.
          nullcheck = '1'.
        ENDIF.
        IF NOT nullcheck IS INITIAL.
          READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                                  werks = s_lbe-werks BINARY SEARCH.
          IF sy-subrc = 0.
            s_lbe-bwgrp = wbe-bwgrp.
          ELSE.
             CHECK 'x' = 'y'.     "leave current loop pass
*            MESSAGE a038 WITH 'WBE'.
          ENDIF.
*normal stocks of lgort ( sl )
          s_lbe-ex_lgort-lgort   = lbe-lgort.
          s_lbe-ex_lgort-lgortkz = norm_sl."normaler Lagerort
          s_lbe-ex_lgort-sondcha = space.

          INSERT s_lbe INTO p_t_lbe INDEX 1.
        ENDIF.
      ENDLOOP.                       "loop at lbe
* sites without stocks should be shown, wbe without stocks needed
* no mard existing for the site
      IF p_kznul IS INITIAL.
         PERFORM wrk_zerostocks USING t_matnr-matnr.
      ENDIF.
* here the werks only stocks are given to the outtab ( werks only means
* stocks on site level which can exist also on storage loc level )
* these stocks are necessary for the cumulation on higher levels
      LOOP AT t_w_lbe INTO s_w_lbe WHERE matnr = t_matnr-matnr.
        CLEAR s_lbe.
        MOVE-CORRESPONDING s_w_lbe TO s_lbe.
        READ TABLE wbe WITH KEY matnr = s_w_lbe-matnr
                              werks = s_w_lbe-werks BINARY SEARCH.
        IF sy-subrc = 0.
          s_lbe-bwgrp = wbe-bwgrp.
          s_lbe-satnr = wbe-satnr.
        ELSE.
           CHECK 'x' = 'y'.           "<<<insert note 0207759 tga
*          MESSAGE a038 WITH 'WBE'.   "<<<delete note 0207759 tga
        ENDIF.
        s_lbe-ex_lgort-lgort   = '0000'.
        s_lbe-ex_lgort-lgortkz = no_sl."normaler Lagerort
        s_lbe-ex_lgort-sondcha = space.

        INSERT s_lbe INTO p_t_lbe INDEX 1.
      ENDLOOP.
    ENDIF.
  ENDLOOP.                              "loop at t_matnr

ENDFORM.                    " BUILD_GEN_OUTTAB_TREE1
*&---------------------------------------------------------------------*
*&      Form  PROVIDE_GEN_MATTREE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*      -->P_T_CBE  text
*----------------------------------------------------------------------*
FORM provide_gen_mattree  TABLES p_t_wbe TYPE  t_wbe
                                 p_t_lbe TYPE  t_lbe
                                 p_t_cbe TYPE  t_cbe.

  DATA: node_level TYPE c.  "tga unicode
* add data to tree
  DATA: l_matnr_key TYPE lvc_nkey,
        l_bwgrp_key TYPE lvc_nkey,
        l_werks_key TYPE lvc_nkey,
        l_last_key  TYPE lvc_nkey,
        l_lgort_key TYPE lvc_nkey,
        l_satnr_key TYPE lvc_nkey,
        l_scat_key  TYPE lvc_nkey,
        sgt_scope   TYPE sgt_scope.


*******************level including site ********************************
* add data to tree
* Batch Level : Batches
  SORT p_t_cbe BY matnr.
  IF p_kzcha NE space.
    LOOP AT p_t_cbe INTO s_cbe.
       gv_index = sy-tabix.
       gv_charg = s_cbe-charg.
       AT NEW satnr.
         IF s_cbe-satnr IS NOT INITIAL.
           node_level = man_zeile.
           READ TABLE t_matnr WITH KEY matnr = s_cbe-satnr BINARY SEARCH.
           IF sy-subrc NE 0.
             READ TABLE t_matnr WITH KEY satnr = s_cbe-satnr.
           ENDIF.
           PERFORM line_of_csatnr  USING    s_cbe '' node_level
                                   CHANGING l_satnr_key.
         ELSE.
           CLEAR l_satnr_key.
         ENDIF.
       ENDAT.

     READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr BINARY SEARCH.
      AT NEW matnr.
*       if s_cbe-matnr ne s_cbe-satnr
*          and s_cbe-satnr is not initial.
        node_level = man_zeile.        "node for material
*        READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr BINARY SEARCH.
       if s_cbe-matnr ne s_cbe-satnr and
          t_matnr-attyp ne '01'.
        PERFORM line_of_cmatnr USING s_cbe l_satnr_key node_level
                              CHANGING  l_matnr_key.
       endif.
      ENDAT.

      AT NEW bwgrp.
       if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_cbwgrp USING s_cbe  l_matnr_key node_level
                               CHANGING  l_bwgrp_key.
       endif.
      ENDAT.
*
      AT NEW werks.
       if s_cbe-matnr ne s_cbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_cwerks USING s_cbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
       endif.
      ENDAT.
* For no batch level stock,we are showing plant level stock
* at this point of time no need to show segment and batch if stock is not there
      READ TABLE cbe WITH KEY matnr = s_cbe-matnr
                              werks = s_cbe-werks
                              lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
      IF sy-subrc = 0.
*       node at storage-location level
        AT NEW ex_lgort.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        endif.
        ENDAT.

*       last node at storage-location level
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'
          and s_cbe-charg is not initial.
         node_level = ch_zeile.           "node for storage location
         PERFORM line_of_charg USING l_lgort_key node_level
                                CHANGING s_cbe l_last_key.
        endif.
      ELSEIF s_cbe-charg IS NOT INITIAL.
        AT NEW ex_lgort.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        endif.
        ENDAT.

        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
         node_level = ch_zeile.           "node for storage location
         PERFORM line_of_charg USING l_lgort_key node_level
                                CHANGING s_cbe l_last_key.
        endif.

      ELSE.
       if s_cbe-matnr ne s_cbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
       endif.
      ENDIF.
    ENDLOOP.
* Batch : Via Stock Segment
  ELSEIF p_kzseg NE space.
    LOOP AT p_t_cbe INTO s_cbe.
        gv_index = sy-tabix.
        gv_charg = s_cbe-charg.
        AT NEW satnr.
          IF s_cbe-satnr IS NOT INITIAL.
            node_level = man_zeile.
            READ TABLE t_matnr WITH KEY matnr = s_cbe-satnr BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE t_matnr WITH KEY satnr = s_cbe-satnr BINARY SEARCH.
            ENDIF.
            PERFORM line_of_csatnr  USING    s_cbe '' node_level
                                    CHANGING l_satnr_key.
          ELSE.
            CLEAR l_satnr_key.
          ENDIF.
        ENDAT.

      READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr BINARY SEARCH.
      AT NEW matnr.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = man_zeile.        "node for material
        PERFORM line_of_cmatnr USING s_cbe l_satnr_key node_level
                              CHANGING  l_matnr_key.
        endif.
      ENDAT.

      AT NEW bwgrp.
       if s_cbe-matnr ne s_cbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_cbwgrp USING s_cbe  l_matnr_key node_level
                               CHANGING  l_bwgrp_key.
       endif.
      ENDAT.
*
      AT NEW werks.
       if s_cbe-matnr ne s_cbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_cwerks USING s_cbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
       endif.
      ENDAT.
* For no batch level stock,we are showing plant level stock
* at this point of time no need to show segment and batch if stock is not there
      READ TABLE cbe WITH KEY matnr = s_cbe-matnr
                              werks = s_cbe-werks
                              lgort = s_cbe-ex_lgort-lgort BINARY SEARCH.
      IF sy-subrc = 0.
*    last node at storage-location level
        AT NEW ex_lgort.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        endif.
        ENDAT.

        AT NEW sgt_scat.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
*       Check if its stock segment relevant
        CALL FUNCTION 'SGTG_CHECK_CAT_REL'
          EXPORTING
            iv_matnr       = s_cbe-matnr
            IV_WERKS       = s_cbe-werks
         IMPORTING
            EV_SCOPE       = sgt_scope
                  .
          IF sgt_scope EQ 1.
            node_level = ch_zeile.
            PERFORM line_of_cscat USING tt_cbe s_cbe l_lgort_key node_level
                                CHANGING l_scat_key.
          ELSE.
            l_scat_key = l_lgort_key.
          ENDIF.
         endif.
        ENDAT.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'
          and s_cbe-charg is not initial.
*      last node at storage-location level
        node_level = ch_zeile.           "node for storage location
        PERFORM line_of_charg USING l_scat_key node_level
                             CHANGING s_cbe l_last_key.
        endif.
      ELSEIF s_cbe-charg IS NOT INITIAL.

        AT NEW ex_lgort.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        endif.
        ENDAT.

        AT NEW sgt_scat.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
*       Check if its stock segment relevant
        CALL FUNCTION 'SGTG_CHECK_CAT_REL'
          EXPORTING
            iv_matnr       = s_cbe-matnr
            IV_WERKS       = s_cbe-werks
         IMPORTING
            EV_SCOPE       = sgt_scope
                  .
          IF sgt_scope EQ 1.
            node_level = ch_zeile.
            PERFORM line_of_cscat USING tt_cbe s_cbe l_lgort_key node_level
                                CHANGING l_scat_key.
          ELSE.
            l_scat_key = l_lgort_key.
          ENDIF.
         endif.
        ENDAT.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
*      last node at storage-location level
        node_level = ch_zeile.           "node for storage location
        PERFORM line_of_charg USING l_scat_key node_level
                             CHANGING s_cbe l_last_key.
        endif.

      ELSE.
        if s_cbe-matnr ne s_cbe-satnr
          and t_matnr-attyp ne '01'.
        node_level = lag_zeile.          "node for storage location
        PERFORM line_of_clgort USING  s_cbe  l_werks_key node_level
                               CHANGING  l_lgort_key.
        endif.
      ENDIF.

    ENDLOOP.
* Plant Level
  ELSEIF p_kzlgo NE 'X'
  AND    p_chrg  EQ space.
    LOOP AT p_t_wbe INTO s_wbe.
        AT NEW satnr.
          IF s_wbe-satnr IS NOT INITIAL.
            node_level = man_zeile.
            READ TABLE t_matnr WITH KEY matnr = s_wbe-satnr BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE t_matnr WITH KEY satnr = s_wbe-satnr BINARY SEARCH.
            ENDIF.
            PERFORM line_of_wsatnr  USING    s_wbe '' node_level
                                    CHANGING l_satnr_key.
          ELSE.
            CLEAR l_satnr_key.
          ENDIF.
        ENDAT.
      READ TABLE t_matnr WITH KEY matnr = s_wbe-matnr BINARY SEARCH.
      AT NEW matnr.
       if s_wbe-matnr ne s_wbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = man_zeile.        "node for material
        PERFORM line_of_matnr USING s_wbe l_satnr_key node_level
                              CHANGING  l_matnr_key.
       endif.
      ENDAT.
      AT NEW bwgrp.
       if s_wbe-matnr ne s_wbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_bwgrp USING s_wbe  l_matnr_key node_level
                             CHANGING  l_bwgrp_key.
       endif.
      ENDAT.
*    last node at werks level
     if s_wbe-matnr ne s_wbe-satnr
        and t_matnr-attyp ne '01'.
      node_level = wrk_zeile.          "node for site
      PERFORM line_of_werks USING     l_bwgrp_key node_level
                            CHANGING  s_wbe l_werks_key.
     endif.
    ENDLOOP.
*******************level including storage location*********************
  ELSEIF p_kzlgo EQ 'X'
  AND    p_chrg  EQ space.
    LOOP AT p_t_lbe INTO s_lbe.
        AT NEW satnr.
          IF s_lbe-satnr IS NOT INITIAL.
            node_level = man_zeile.
            READ TABLE t_matnr WITH KEY matnr = s_lbe-satnr BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE t_matnr WITH KEY satnr = s_lbe-satnr BINARY SEARCH.
            ENDIF.
            PERFORM line_of_lsatnr  USING    s_lbe '' node_level
                                    CHANGING l_satnr_key.
          ELSE.
            CLEAR l_satnr_key.
          ENDIF.
        ENDAT.
      READ TABLE t_matnr WITH KEY matnr = s_lbe-matnr BINARY SEARCH.
      AT NEW matnr.
       if s_lbe-matnr ne s_lbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = man_zeile.        "node for material
        PERFORM line_of_lmatnr USING s_lbe l_satnr_key node_level
                              CHANGING  l_matnr_key.
       endif.
      ENDAT.

      AT NEW bwgrp.
       if s_lbe-matnr ne s_lbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wgr_zeile.        "node for sitegroup
        PERFORM line_of_lbwgrp USING s_lbe  l_matnr_key node_level
                             CHANGING  l_bwgrp_key.
       endif.
      ENDAT.

      AT NEW werks.
       if s_lbe-matnr ne s_lbe-satnr
         and t_matnr-attyp ne '01'.
        node_level = wrk_zeile.        "node for site
        PERFORM line_of_lwerks USING s_lbe l_bwgrp_key node_level
                              CHANGING  l_werks_key.
       endif.
      ENDAT.
*    last node at storage-location level
     if s_lbe-matnr ne s_lbe-satnr
       and t_matnr-attyp ne '01'.
      node_level = lag_zeile.          "node for storage location
      PERFORM line_of_lgort USING l_werks_key node_level
                             CHANGING s_lbe l_last_key.
     endif.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " PROVIDE_GEN_MATTREE
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_WSATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_WBE  text
*      -->P_0901   text
*      -->P_NODE_LEVEL  text
*      <--P_L_SATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_wsatnr  USING    p_s_wbe       TYPE s_wbe
                              p_relat_key   TYPE lvc_nkey
                              p_node_level  TYPE c
                     CHANGING p_node_key    TYPE lvc_nkey.

  DATA:
    l_node_text    TYPE lvc_value,
    lr_wbe         TYPE s_wbe,
    h_tv_image     TYPE tv_image,
    h_icon(6)      TYPE C,
    h_text         TYPE CHAR40,
    ls_node_layout TYPE lvc_s_layn,
    lt_item_layout TYPE lvc_t_layi,
    ls_item_layout TYPE lvc_s_layi.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

  clear ls_item_layout.
* tga / accessibility
  MOVE '@0R@' TO h_icon.
  MOVE text-013 TO h_text.
  PERFORM build_tooltip USING    h_icon
                                 h_text
                        CHANGING h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

  WRITE p_s_wbe-satnr TO l_node_text.
  lr_wbe-meinh = t_matnr-meins.
  lr_wbe-name1 = t_matnr-maktx.

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_wbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_wbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_wbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_WSATNR
*&---------------------------------------------------------------------*
*&      Form  LINE_OF_LSATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_LBE  text
*      -->P_0993   text
*      -->P_NODE_LEVEL  text
*      <--P_L_SATNR_KEY  text
*----------------------------------------------------------------------*
FORM line_of_lsatnr   USING   p_s_lbe       TYPE s_lbe
                              p_relat_key   TYPE lvc_nkey
                              p_node_level  TYPE c
                     CHANGING p_node_key    TYPE lvc_nkey.

  DATA:
    l_node_text    TYPE lvc_value,
    lr_lbe         TYPE s_lbe,
    h_tv_image     TYPE tv_image,
    h_icon(6)      TYPE C,
    h_text         TYPE CHAR40,
    ls_node_layout TYPE lvc_s_layn,
    lt_item_layout TYPE lvc_t_layi,
    ls_item_layout TYPE lvc_s_layi.

  ls_node_layout-n_image = 'bnone'.
  ls_node_layout-exp_image = 'bnone'.

  clear ls_item_layout.
* tga / accessibility
  MOVE '@0R@' TO h_icon.
  MOVE text-013 TO h_text.
  PERFORM build_tooltip USING    h_icon
                                 h_text
                        CHANGING h_tv_image.
  ls_item_layout-t_image = h_tv_image.
  ls_item_layout-fieldname = mattree1->c_hierarchy_column_name.
  ls_item_layout-style = cl_gui_column_tree=>style_intensifd_critical.
  APPEND ls_item_layout TO lt_item_layout.

  WRITE p_s_lbe-satnr TO l_node_text.
  lr_lbe-meinh = t_matnr-meins.
  lr_lbe-name1 = t_matnr-maktx.

  IF var_tree = yes.                   "tree for variants
    CALL METHOD mattree2->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_lbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_v_zle
                            USING  p_s_lbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ELSE.
    CALL METHOD mattree1->add_node
      EXPORTING
            i_relat_node_key = p_relat_key
            i_relationship   = cl_gui_column_tree=>relat_last_child
            i_node_text      = l_node_text
            is_outtab_line   = lr_lbe
            it_item_layout   = lt_item_layout
            is_node_layout   = ls_node_layout
         IMPORTING
            e_new_node_key = p_node_key.
    IF sy-subrc = 0.
      PERFORM fill_zle_hide TABLES t_zle
                            USING  p_s_lbe-satnr '' '' ''
                                   '' p_node_level ''
                                   t_matnr-attyp ' ' ''.
    ENDIF.
  ENDIF.
ENDFORM.                    " LINE_OF_LSATNR
*&---------------------------------------------------------------------*
*&      Form  PROVIDE_SP_CHARG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_T_CBE  text
*      <--P_S_CBE  text
*      <--P_SPEC_EXIST  text
*----------------------------------------------------------------------*
FORM provide_sp_charg  TABLES  p_t_cbe TYPE t_cbe
                      CHANGING p_s_cbe TYPE s_cbe
                               p_spec_exist TYPE C. "tga unicode
  DATA: h_s_cbe TYPE s_cbe,
  h_matnr LIKE mara-matnr.
  h_matnr = p_s_cbe-matnr.
* bwgrp of wbe needed
     READ TABLE wbe WITH KEY matnr = t_matnr-matnr
                             werks = p_s_cbe-werks BINARY SEARCH.
* kundenauftrag ********************************************************
  IF p_s_cbe-kalab NE space      OR p_s_cbe-kains NE space
     OR p_s_cbe-kaspe NE space   OR p_s_cbe-kaein NE space.
* versorgen key
   MOVE-CORRESPONDING p_s_cbe TO h_s_cbe.
    h_s_cbe-matnr             =    p_s_cbe-matnr.
    h_s_cbe-bwgrp             =    wbe-bwgrp.
    h_s_cbe-werks             =    p_s_cbe-werks.
    h_s_cbe-satnr           =    p_s_cbe-satnr.
    h_s_cbe-charg           =    p_s_cbe-charg.
    h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
    h_s_cbe-ex_lgort-lgort     = space.
    h_s_cbe-ex_lgort-lgortkz   = sp_sl."sl with special stocks
    h_s_cbe-ex_lgort-sondcha   = aufbskunde.   "customer order
* fields with values
    h_s_cbe-kalab = p_s_cbe-kalab.
    h_s_cbe-kains = p_s_cbe-kains.
    h_s_cbe-kaspe = p_s_cbe-kaspe.
    h_s_cbe-kaein = p_s_cbe-kaein.
* necessary to clear because these stocks would apper two times
    CLEAR: p_s_cbe-kalab, p_s_cbe-kains, p_s_cbe-kaspe, p_s_cbe-kaein,
           h_s_cbe-labst.
    INSERT h_s_cbe INTO p_t_cbe INDEX 1.
    p_spec_exist = yes.
    CLEAR h_s_cbe.
  ENDIF.
* Liefkonsi **********************************************************
  READ TABLE kbe WITH KEY matnr = p_s_cbe-matnr
                          werks = p_s_cbe-werks
*                         lgort = cbe-lgort.      "note 319513 tga
                          lgort = cbe-lgort BINARY SEARCH.
  IF sy-subrc EQ 0.
    IF p_s_cbe-klabs NE space OR p_s_cbe-kinsm NE space
    OR p_s_cbe-keinm NE space OR p_s_cbe-kspem NE space
    OR p_s_cbe-mlabs NE space OR p_s_cbe-minsm NE space
    OR p_s_cbe-meinm NE space OR p_s_cbe-mspem NE space .
* versorgen key
    h_s_cbe-matnr             =    p_s_cbe-matnr.
    h_s_cbe-bwgrp             =    wbe-bwgrp.
    h_s_cbe-werks             =    p_s_cbe-werks.
    h_s_cbe-satnr           =    p_s_cbe-satnr.
    h_s_cbe-charg           =    p_s_cbe-charg.
    h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
    h_s_cbe-ex_lgort-lgort    =  cbe-lgort.
    h_s_cbe-ex_lgort-lgortkz  =  sp_sl."sl with sonderbest
    h_s_cbe-ex_lgort-sondcha  =  konsilief.   "vendorkonsi
* tga wrong values for vendor consignment note 319513 / start
*    h_s_cbe-klabs = wbe-klabs.
*    h_s_cbe-kinsm = wbe-kinsm.
*    h_s_cbe-keinm = wbe-keinm.
*    h_s_cbe-kspem = wbe-kspem.
    LOOP AT kbe FROM SY-TABIX.
* tga / wrong cumulation
*      IF kbe-lgort NE cbe-lgort. EXIT. ENDIF.
         IF kbe-matnr NE cbe-matnr OR
            kbe-werks NE cbe-werks OR
            kbe-lgort NE cbe-lgort.
              EXIT.
         ENDIF.

         ADD kbe-labst TO h_s_cbe-klabs.
         ADD kbe-insme TO h_s_cbe-kinsm.
         ADD kbe-einme TO h_s_cbe-keinm.
         ADD kbe-speme TO h_s_cbe-kspem.
    ENDLOOP.
* tga wrong values for vendor consignment note 319513 / end
* necessary to clear because these stocks would appear two times
    CLEAR: p_s_cbe-klabs, p_s_cbe-kinsm, p_s_cbe-keinm, p_s_cbe-kspem.

    INSERT h_s_cbe INTO p_t_cbe INDEX 1.
    p_spec_exist = yes.
    CLEAR h_s_cbe.
  ENDIF.
  ENDIF.
* Liefmtv***************************************************************
  IF p_s_cbe-mlabs NE space      OR p_s_cbe-minsm NE space
     OR p_s_cbe-meinm NE space   OR p_s_cbe-mspem NE space.
* versorgen key
    h_s_cbe-matnr             =    p_s_cbe-matnr.
    h_s_cbe-bwgrp             =    wbe-bwgrp.
    h_s_cbe-werks             =    p_s_cbe-werks.
      h_s_cbe-satnr           =    p_s_cbe-satnr.
    h_s_cbe-charg           =    p_s_cbe-charg.
    h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
* expanded lgort (sl)
    h_s_cbe-ex_lgort-lgort    =  cbe-lgort.
    h_s_cbe-ex_lgort-lgortkz  =  sp_sl."sl with sonderbest
    h_s_cbe-ex_lgort-sondcha  =  mtverpack.   "customer order
* fields with values
    h_s_cbe-mlabs = p_s_cbe-mlabs.
    h_s_cbe-minsm = p_s_cbe-minsm.
    h_s_cbe-meinm = p_s_cbe-meinm.
    h_s_cbe-mspem = p_s_cbe-mspem.
* necessary to clear because these stocks would apper two times
    CLEAR: p_s_cbe-mlabs, p_s_cbe-minsm, p_s_cbe-meinm, p_s_cbe-mspem.
    INSERT h_s_cbe INTO p_t_cbe INDEX 1.
    CLEAR h_s_cbe.
  ENDIF.
* Liefbeist*************************************************************
*  IF obs-matnr NE h_matnr.
*
*    LOOP AT obs WHERE matnr = p_s_cbe-matnr  AND
*                      werks = p_s_cbe-werks.
*
*      ADD obs-labst TO h_s_cbe-lblab.
*      ADD obs-insme TO h_s_cbe-lbins.
**      ADD obs-einme TO h_s_cbe-cbein.
*    ENDLOOP.
*    IF sy-subrc = 0.
**  versorgen key
*      h_s_cbe-matnr             =    p_s_cbe-matnr.
*      h_s_cbe-bwgrp             =    wbe-bwgrp.
*      h_s_cbe-werks             =    p_s_cbe-werks.
*      h_s_cbe-satnr             =    p_s_cbe-satnr.
*        h_s_cbe-charg           =    p_s_cbe-charg.
*        h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
*       h_s_cbe-ex_lgort-lgort   = space.
*       h_s_cbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
*      h_s_cbe-ex_lgort-sondcha  = beistlief.   "vendorkonsi
*      INSERT h_s_cbe INTO p_t_cbe INDEX 1.
*      p_spec_exist = yes.
*      CLEAR h_s_cbe.
*    ENDIF.
*  ENDIF.
  IF p_s_cbe-lblab NE space OR p_s_cbe-lbins NE space
     OR p_s_cbe-lbein NE space .
* versorgen key
    h_s_cbe-matnr             =    p_s_cbe-matnr.
    h_s_cbe-bwgrp             =    wbe-bwgrp.
    h_s_cbe-werks             =    p_s_cbe-werks.
      h_s_cbe-satnr           =    p_s_cbe-satnr.
    h_s_cbe-charg           =    p_s_cbe-charg.
    h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
* expanded lgort (sl)
    h_s_cbe-ex_lgort-lgort    =  space.
    h_s_cbe-ex_lgort-lgortkz  =  sp_sl."sl with sonderbest
    h_s_cbe-ex_lgort-sondcha  =  beistlief.   "vendorkonsi
* fields with values
    h_s_cbe-lblab = p_s_cbe-lblab.
    h_s_cbe-lbins = p_s_cbe-lbins.
    h_s_cbe-lbein = p_s_cbe-lbein.
* necessary to clear because these stocks would apper two times
    CLEAR: p_s_cbe-lblab, p_s_cbe-lbins, p_s_cbe-lbein.
    INSERT h_s_cbe INTO p_t_cbe INDEX 1.
    CLEAR h_s_cbe.
  ENDIF.
*Kundenbest-lgut********************************************************
  IF vbs-matnr NE h_matnr.
    LOOP AT vbs WHERE matnr = p_s_cbe-matnr AND
                            werks = p_s_cbe-werks.

      ADD vbs-labst TO h_s_cbe-kulav.
      ADD vbs-insme TO h_s_cbe-kuinv.
      ADD vbs-einme TO h_s_cbe-kueiv.
    ENDLOOP.
    IF sy-subrc = 0.
*  versorgen key
      h_s_cbe-matnr             =    p_s_cbe-matnr.
      h_s_cbe-bwgrp             =    wbe-bwgrp.
      h_s_cbe-werks             =    p_s_cbe-werks.
      h_s_cbe-satnr           =    p_s_cbe-satnr.
      h_s_cbe-charg           =    p_s_cbe-charg.
      h_s_cbe-sgt_scat        =    p_s_cbe-sgt_scat.
      h_s_cbe-ex_lgort-lgort   = space.
      h_s_cbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
      h_s_cbe-ex_lgort-sondcha  = lrgutkunde.   "LRGUT at customer
      INSERT h_s_cbe INTO p_t_cbe INDEX 1.
      p_spec_exist = yes.
      CLEAR h_s_cbe.
    ENDIF.
  ENDIF.
*kundenbest-konsi*******************************************************
  IF wbs_seg-matnr NE h_matnr.
    LOOP AT wbs_seg WHERE  matnr = p_s_cbe-matnr  AND
                       werks = p_s_cbe-werks.
      MOVE-CORRESPONDING p_s_cbe TO h_s_cbe.
      h_s_cbe-kulaw = wbs_seg-labst.
      h_s_cbe-kuinw = wbs_seg-insme.
      h_s_cbe-kueiw = wbs_seg-einme.
      h_s_cbe-charg = wbs_seg-charg.
      h_s_cbe-sgt_scat  = wbs_seg-sgt_scat.
      h_s_cbe-matnr             =    p_s_cbe-matnr.
      h_s_cbe-bwgrp             =    wbe-bwgrp.
      h_s_cbe-werks             =    p_s_cbe-werks.
      h_s_cbe-satnr           =    p_s_cbe-satnr.
      h_s_cbe-ex_lgort-lgort   = space.
      h_s_cbe-ex_lgort-lgortkz = sp_sl."sl with sonderbest
      h_s_cbe-ex_lgort-sondcha  = konsikunde.   "Kons at customer
      CLEAR : h_s_cbe-labst.
      INSERT h_s_cbe INTO p_t_cbe INDEX 1.
      CLEAR h_s_cbe.
    ENDLOOP.
    IF sy-subrc = 0.
      p_spec_exist = yes.
    ENDIF.
  ENDIF.

ENDFORM.                    " PROVIDE_SP_CHARG
ENHANCEMENT-POINT RWBE1F09_G6 SPOTS ES_RWBEST01 STATIC .

*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .
 CONSTANTS :
        container TYPE char12 VALUE 'MATTREE'.

  DATA :
      layout TYPE   lvc_s_layo,
      ls_layout TYPE disvariant.

  CLEAR ls_layout.

  IF cont IS INITIAL.

*   //creates a container for the ALV grid in the custom
*   //control developed in screen painter
    CREATE OBJECT cont
      EXPORTING
*       //this is the name of the custom container that
*       //was created in screen painter
        container_name = container.
*   //if there is a problem creating the container
    IF sy-subrc NE 0.
*     //Display System message on the selection screen
      MESSAGE ID     sy-msgid
              TYPE   'S'
              NUMBER sy-msgno
              WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.

*   //create the alv grid object to hold the alv structure
*   //and link it to the container that was just created.
    CREATE OBJECT mattree
      EXPORTING
        i_parent = cont.
    IF sy-subrc NE 0.
*     //Display System message on the selection screen
      MESSAGE ID     sy-msgid
              TYPE   'S'
              NUMBER sy-msgno
              WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.

   PERFORM f_build_fieldcat.

   ls_layout-report = sy-repid.

  IF p_chrg IS NOT INITIAL
  AND ( p_kzcha IS NOT INITIAL
  OR    p_kzseg IS NOT INITIAL ).
      CALL METHOD mattree->set_table_for_first_display
        EXPORTING
          i_structure_name              = sgt_cbe
*        is_layout                     = layout
*       it_toolbar_excluding          = gi_exclude_sca
        is_variant                     = ls_layout
        i_save                         = 'A'
        CHANGING
          it_fieldcatalog               = fieldcat
          it_outtab                     = final_cbe
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3.
      IF sy-subrc NE 0.
*       //Display System message on the selection screen
        MESSAGE ID     sy-msgid
                TYPE   'S'
                NUMBER sy-msgno
                WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
  ELSEIF p_kzlgo IS NOT INITIAL
  AND    p_chrg IS INITIAL.
    CALL METHOD mattree->set_table_for_first_display
      EXPORTING
        i_structure_name              = sgt_lbe
*      is_layout                     = layout
*     it_toolbar_excluding          = gi_exclude_sca
      CHANGING
        it_fieldcatalog               = fieldcat
        it_outtab                     = final_lbe
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3.
    IF sy-subrc NE 0.
*     //Display System message on the selection screen
      MESSAGE ID     sy-msgid
              TYPE   'S'
              NUMBER sy-msgno
              WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ELSEIF p_kzlgo IS INITIAL
  AND    p_chrg IS INITIAL.
    CALL METHOD mattree->set_table_for_first_display
      EXPORTING
        i_structure_name              = sgt_wbe
*      is_layout                     = layout
*     it_toolbar_excluding          = gi_exclude_sca
      CHANGING
        it_fieldcatalog               = fieldcat
        it_outtab                     = final_wbe
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3.
    IF sy-subrc NE 0.
*     //Display System message on the selection screen
      MESSAGE ID     sy-msgid
              TYPE   'S'
              NUMBER sy-msgno
              WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
ENHANCEMENT-POINT RWBE1F09_G8 SPOTS ES_RWBEST01 .


 ENDIf.
ENDFORM.                    " ALV_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcat .

 DATA struc TYPE dd02l-tabname.
  IF p_chrg IS NOT INITIAL
  AND ( p_kzseg IS NOT INITIAL
  OR    p_kzcha IS NOT INITIAL ).
   struc = sgt_cbe.
  ELSEIF p_kzlgo IS NOT INITIAL
  AND    p_chrg IS INITIAL.
   struc = sgt_lbe.
  ELSEIF p_kzlgo IS INITIAL
  AND    p_chrg IS INITIAL.
   struc = sgt_cbe.
  ENDIF.
ENHANCEMENT-POINT RWBE1F09_G9 SPOTS ES_RWBEST01 .

* //Get the field catalog using the DDIC structure
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = struc
    CHANGING
      ct_fieldcat            = fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc NE 0.
*   //Display System message on the selection screen
    MESSAGE ID     sy-msgid
            TYPE   'S'
            NUMBER sy-msgno
            WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
            DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FINAL_INTERNAL_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_WBE  text
*      -->P_T_LBE  text
*      -->P_T_CBE  text
*----------------------------------------------------------------------*
FORM build_final_internal_table  TABLES   p_t_wbe TYPE t_wbe
                                          p_t_lbe TYPE t_lbe
                                          p_t_cbe TYPE t_cbe.
DATA:
  wa_cbe TYPE sgt_alv_cbe,
  wa_lbe TYPE sgt_alv_lbe,
  wa_wbe TYPE sgt_alv_wbe.

IF p_chrg IS NOT INITIAL.
ENHANCEMENT-SECTION RWBE1F09_G5 SPOTS ES_RWBEST01 .
  LOOP AT p_t_cbe INTO s_cbe.
  MOVE-CORRESPONDING s_cbe TO wa_cbe.
  wa_cbe-sondcha = s_cbe-ex_lgort-sondcha.
  wa_cbe-lgort   = s_cbe-ex_lgort-lgort.
  READ TABLE t_matnr WITH KEY matnr = s_cbe-matnr
                     BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    wa_cbe-name = t_matnr-maktx.
  ENDIF.
  APPEND wa_cbe TO final_cbe.
  CLEAR :
    wa_cbe, s_cbe.
  ENDLOOP.
END-ENHANCEMENT-SECTION.
ELSEIF p_kzlgo IS NOT INITIAL.
 LOOP AT p_t_lbe INTO s_lbe.
   MOVE-CORRESPONDING s_lbe TO wa_lbe.
   wa_lbe-sondcha = s_lbe-ex_lgort-sondcha.
   wa_lbe-lgort   = s_lbe-ex_lgort-lgort.
      READ TABLE t_matnr WITH KEY matnr = s_lbe-matnr                   " n_2663196
                      BINARY SEARCH.
   if sy-subrc IS INITIAL.
     wa_lbe-name1 = t_matnr-maktx.
   endif.
ENHANCEMENT-POINT RWBE1F09_04 SPOTS ES_RWBEST01 .

   APPEND wa_lbe TO final_lbe.
   CLEAR :
     s_lbe, wa_lbe.
 ENDLOOP.
ELSE.
  LOOP AT p_t_wbe INTO s_wbe.
   MOVE-CORRESPONDING s_wbe TO wa_wbe.
   wa_wbe-sondcha = s_wbe-ex_werks-sondcha.
   READ TABLE t_matnr WITH KEY matnr = s_wbe-matnr
                      BINARY SEARCH.
   if sy-subrc IS INITIAL.
    wa_wbe-name1 = t_matnr-maktx.
   endif.
ENHANCEMENT-POINT RWBE1F09_05 SPOTS ES_RWBEST01 .

   APPEND wa_wbe TO final_wbe.
   CLEAR :
     s_wbe , wa_wbe.
  ENDLOOP.
ENDIF.
ENDFORM.                    " BUILD_FINAL_INTERNAL_TABLE
*&---------------------------------------------------------------------*
*&      Form  CHECKNULL_CHARG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_CBE  text
*----------------------------------------------------------------------*
FORM checknull_charg  USING    p_s_cbe TYPE s_cbe.
  DATA: check_cbe TYPE s_cbe.
  CLEAR: nullcheck.
  check_cbe = p_s_cbe.
*initialize non value fields
  check_cbe-matnr    = space.
  check_cbe-bwgrp    = space.
  check_cbe-werks    = space.
  check_cbe-ex_lgort = space.
  check_cbe-meinh    = space.
  check_cbe-name1    = space.
  check_cbe-lvorm    = space.
  check_cbe-charg    = space.
  check_cbe-sgt_scat = space.
  check_cbe-satnr    = space.
* special stocks which are in mard and in mkol
  IF p_kzson IS INITIAL.
    check_cbe-klabs  = space.
    check_cbe-kinsm  = space.
    check_cbe-keinm  = space.
    check_cbe-kspem  = space.
  ENDIF.
  IF NOT check_cbe IS INITIAL.
    nullcheck = '1'.
  ENDIF.
ENDFORM.                    " CHECKNULL_CHARG
*&---------------------------------------------------------------------*
*&      Form  WRK_ZEROSTOCKS_CBE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_MATNR_MATNR  text
*----------------------------------------------------------------------*
FORM wrk_zerostocks_cbe  USING  p_matnr TYPE matnr.

  DATA:  h_index LIKE sy-tabix.
  DATA h_s_cbe TYPE s_cbe.
  READ TABLE wbe  WITH KEY matnr = p_matnr.
  h_index = sy-tabix.
  LOOP AT wbe FROM h_index.
    IF wbe-matnr NE p_matnr. EXIT. ENDIF.
   MOVE-CORRESPONDING wbe TO s_wbe.
   PERFORM checknull_werk USING s_wbe.
   IF nullcheck IS INITIAL.
      h_s_cbe-matnr            = wbe-matnr.
      h_s_cbe-bwgrp            = wbe-bwgrp.
      h_s_cbe-werks            = wbe-werks.
      h_s_cbe-ex_lgort-lgort   = '0000'.
      h_s_cbe-ex_lgort-lgortkz = no_sl.     "no storage location
      h_s_cbe-ex_lgort-sondcha = space.
* if read was successfull, a row for the current article
* on site level exists => no insert
      READ TABLE t_cbe INTO s_cbe WITH KEY matnr = p_matnr
                                           werks = wbe-werks.
      IF sy-subrc <> 0.
       INSERT h_s_cbe INTO t_cbe INDEX 1.
      ENDIF.
   ELSE.
    CLEAR nullcheck.
   ENDIF.
  ENDLOOP.

ENDFORM.
