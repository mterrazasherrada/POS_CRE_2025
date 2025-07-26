*----------------------------------------------------------------------*
***INCLUDE RWBE1F12 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  Bestandsdaten_lesen_new
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM bestandsdaten_lesen_new TABLES pt_matnr STRUCTURE t_matnr"#EC NEEDED
                                    pt_werks STRUCTURE t_werks"#EC NEEDED
                                    pt_mbe STRUCTURE mbe
                                    pt_gbe STRUCTURE gbe
                                    pt_wbe STRUCTURE wbe
                                    pt_lbe STRUCTURE lbe
                                    pt_ebs STRUCTURE ebs
                                    pt_kbe STRUCTURE kbe
                                    pt_mps STRUCTURE mps
                                    pt_obs STRUCTURE obs
                                    pt_vbs STRUCTURE vbs
                                    pt_wbs STRUCTURE wbs
                                    pt_oeb STRUCTURE oeb
                                    pt_ek_vk STRUCTURE ek_vk.

  DATA: sy_tabix  LIKE sy-tabix,
        anz_werke LIKE sy-tfill,
        text_xxx(30).

  DATA:
      lt_matnr_batch        TYPE imil_matnr_batch_tty,
      ls_matnr_batch        TYPE imil_matnr_batch_sty,
      lt_plant_sloc         TYPE imil_plant_sloc_tty,
      ls_plant_sloc         TYPE imil_plant_sloc_sty,
      lt_spec_stock_vend    TYPE imil_spec_stock_vend_key_tty,
      lt_spec_stock_cust    TYPE imil_spec_stock_cust_key_tty,
      lt_sales_order_stock  TYPE imil_sales_order_stock_key_tty,
      lt_project_stock      TYPE imil_project_stock_key_tty,
      ls_control_main       TYPE imil_control_main_sty,
      ls_control_valu       TYPE imil_control_valu_sty,
      ls_control_spec_stock TYPE imil_control_spec_stock_sty,
      ls_control_commitment TYPE imil_control_commitment_sty,
      lt_basic_level1       TYPE imil_basic_stock_level1_tty,
      lt_basic_level2       TYPE imil_basic_stock_level2_tty,
      lt_basic_level3       TYPE imil_basic_stock_level3_tty,
      lt_basic_level4       TYPE imil_basic_stock_level4_tty,
      lt_plant_stock        TYPE imil_plant_stock_tty,
      lt_valu_matnr         TYPE imil_valu_matnr_tty,
      lt_valu_sales_order   TYPE imil_valu_sales_order_tty,
      lt_valu_project       TYPE imil_valu_project_tty,
      lt_valu_subcontract   TYPE imil_valu_subcontract_tty,
      lt_vend_consign       TYPE imil_vendor_spec_stock_tty,
      lt_vend_retpack       TYPE imil_vendor_spec_stock_tty,
      lt_vend_subcontract   TYPE imil_subcontract_stock_tty,
      lt_cust_consign       TYPE imil_customer_spec_stock_tty,
      lt_cust_retpack       TYPE imil_customer_spec_stock_tty,
      lt_sales_order        TYPE imil_sales_order_stock_tty,
      lt_project            TYPE imil_project_stock_tty,
      lt_commitment         TYPE imil_commitment_stock_tty,
      lt_reservation        TYPE imil_reservation_stock_tty,
      lt_sales_req          TYPE imil_sales_requirement_tty,
      lt_prod_order_quan    TYPE imil_prod_order_quan_tty,
      lt_return             TYPE imil_return_message_tty.   "#EC NEEDED

  DATA:
    ls_mbe         LIKE mbe,
    ls_wbe         LIKE wbe,
    ls_gbe         LIKE gbe,
    lt_werks       LIKE STANDARD TABLE OF rwwkh WITH HEADER LINE,
    ls_werks       LIKE rwwkh,
    ls_lines_werks LIKE sy-tfill.

  FIELD-SYMBOLS:
    <ls_plant_sloc> TYPE imil_plant_sloc_sty,
    <ls_return>     TYPE imil_return_messsage_sty.


  prt_matnr[] = pt_matnr[].
  prt_matnr = pt_matnr.

  REFRESH: prt_mbe, prt_gbe, prt_wbe, prt_lbe, prt_ebs, prt_kbe,
           prt_mps, prt_obs, prt_vbs, prt_wbs, prt_oeb, prt_ek_vk.

*---- Initialisierungen für Progressindicator -------------------------*
  progr_indic = anz_mat_ges / 10.
  IF progr_indic = 0. progr_indic = 1. ENDIF.
  bas_proz = 100 DIV ( anz_mat_ges DIV progr_indic ).
  prozent = 1.
  text_xxx       = text-066.
  text_xxx+23(3) = prozent.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = prozent
      text       = text_xxx
    EXCEPTIONS
      OTHERS     = 1.                                       "#EC *

* Copy of pt_werks to ls_werks
  LOOP AT pt_werks INTO pt_werks.
      ls_werks-werks = pt_werks-werks.
      ls_werks-wrkbz = pt_werks-wrkbz.
      ls_werks-vlfkz = pt_werks-vlfkz.
      ls_werks-bwgrp = pt_werks-bwgrp.
      ls_werks-waers = pt_werks-waers.
      APPEND ls_werks TO lt_werks.
  ENDLOOP.

  PERFORM prefetch_marc_mard_mbew TABLES pt_werks.
  IF nbwrk_done = no.
    PERFORM nachbearbeitung_werke.
    nbwrk_done = yes.
  ENDIF.
  DESCRIBE TABLE pt_werks LINES anz_werke.
  DESCRIBE TABLE lt_werks LINES ls_lines_werks.

* fill import-data
  ls_control_main-req_sloc       = x.
  ls_control_main-req_plant      = x.

  IF ( anz_werke > 0 ).
    ls_control_valu-req_valu_matnr = x.
  ENDIF.

*  IF p_kzlgo IS NOT INITIAL.
  ls_control_main-break_sloc = x.
*  ENDIF.

*  ls_control_main-req_salesset   = x.
*  ls_control_main-req_prepack    = x.
*  ls_control_main-req_display    = x.
*  ls_control_main-break_variants  = x.

  IF  ( NOT p_kzlso IS INITIAL )
  AND ( anz_werke > 0 ).

    ls_control_spec_stock-req_vend_consign   = x.
    ls_control_spec_stock-break_vend_consign = '1'.
    ls_control_spec_stock-req_vend_retpack   = x.
    ls_control_spec_stock-break_vend_retpack = '1'.
    ls_control_spec_stock-req_vend_subcontract    = x.
    ls_control_spec_stock-break_vend_subcontract  = '1'.
    ls_control_spec_stock-req_cust_consign   = x.
    ls_control_spec_stock-break_cust_consign = '1'.
    ls_control_spec_stock-req_cust_retpack   = x.
    ls_control_spec_stock-break_cust_retpack = '1'.
    ls_control_spec_stock-req_sales_order    = x.
    ls_control_spec_stock-break_sales_order  = '1'.
*    ls_control_spec_stock-req_project        = x.
*    ls_control_spec_stock-break_project      = '1'.

  ENDIF.

  IF  ( NOT p_kzlon IS INITIAL )
  AND ( anz_werke > 0 ).

    ls_control_commitment-req_on_order         = x.
    ls_control_commitment-req_on_order_consign = x.
    ls_control_commitment-req_gr_blocked       = x.
    ls_control_commitment-req_trspt_order      = x.
    ls_control_commitment-req_transit_cc       = x.
    ls_control_commitment-req_reservation      = x.
    ls_control_commitment-req_reserv_rcpt      = x.
    ls_control_commitment-req_salreq_inquiry   = x.
    ls_control_commitment-req_salreq_quotation = x.
    ls_control_commitment-req_salreq_order     = x.
    ls_control_commitment-req_salreq_sched_agr = x.
    ls_control_commitment-req_salreq_contract  = x.
    ls_control_commitment-req_salreq_wo_charge = x.
    ls_control_commitment-req_salreq_delivery  = x.
    ls_control_commitment-req_prod_order       = x.

  ENDIF.

  LOOP AT pt_werks INTO pt_werks.

    ls_plant_sloc-werks = pt_werks-werks.
*    ls_plant_sloc-sloc  = prt_werks_sloc.
    APPEND ls_plant_sloc TO lt_plant_sloc.

  ENDLOOP.

*fill the import for get and already the needed prt-tables for later
  LOOP AT pt_matnr INTO prt_matnr.

    CLEAR ls_matnr_batch.

    ls_matnr_batch = prt_matnr-matnr.
    APPEND ls_matnr_batch TO lt_matnr_batch.

* create "empty" item in prt-tables if necessary (mbe, wbe, gbe)
    ls_mbe-matnr = prt_matnr-matnr.

    APPEND ls_mbe TO prt_mbe.

    LOOP AT lt_plant_sloc ASSIGNING <ls_plant_sloc>.

      CLEAR ls_wbe.
      CLEAR ls_gbe.

      READ TABLE pt_werks WITH KEY werks = <ls_plant_sloc>-werks  BINARY SEARCH.

      MOVE-CORRESPONDING <ls_plant_sloc> TO ls_wbe.         "#EC ENHOK
      MOVE-CORRESPONDING pt_werks TO ls_wbe.                "#EC ENHOK
      ls_wbe-name1 = pt_werks-wrkbz.
      ls_wbe-matnr = prt_matnr-matnr.
      INSERT ls_wbe INTO TABLE prt_wbe.

      MOVE-CORRESPONDING pt_werks TO ls_gbe.                "#EC ENHOK
      ls_gbe-matnr = prt_matnr-matnr.

*      READ TABLE prt_gbe WITH KEY bwgrp = pt_werks-bwgrp
*
*      IF sy-subrc <> 0.
      INSERT ls_gbe INTO TABLE prt_gbe.
*      ENDIF.

    ENDLOOP.

  ENDLOOP.

* Begin: Case when a plant does not exist in MARC but it should be considered when calling the RFC
  IF ( anz_werke = 0 ) AND ( ls_lines_werks > 0 ).
    LOOP AT lt_werks INTO ls_werks.
      ls_plant_sloc-werks = ls_werks-werks.
      APPEND ls_plant_sloc TO lt_plant_sloc.
    ENDLOOP.
  ENDIF.
* End

  SORT prt_gbe BY matnr bwgrp.
  DELETE ADJACENT DUPLICATES FROM prt_gbe.

*  SET RUN TIME ANALYZER ON.

  CLEAR lt_return.

  CALL FUNCTION 'INVENTORY_LOOKUP_REALTIME'
  EXPORTING
   is_control_main             = ls_control_main
   is_control_valu             = ls_control_valu
   is_control_spec_stock       = ls_control_spec_stock
   is_control_commitment       = ls_control_commitment
*     I_REQ_POS_DATA              = 'X'
  TABLES
    it_matnr_batch        = lt_matnr_batch
    it_plant_sloc         = lt_plant_sloc
    it_spec_stock_vend    = lt_spec_stock_vend
    it_spec_stock_cust    = lt_spec_stock_cust
    it_sales_order_stock  = lt_sales_order_stock
    it_project_stock      = lt_project_stock
*     IT_VALU_MATNR               =
*     IT_VALU_SALES_ORDER         =
*     IT_VALU_PROJECT             =
*     IT_VALU_SUBCONTRACT         =
    et_basic_level1       = lt_basic_level1
    et_basic_level2       = lt_basic_level2
    et_basic_level3       = lt_basic_level3
*        et_basic_level4       = lt_basic_level4
    et_plant_stock        = lt_plant_stock
    et_valu_matnr         = lt_valu_matnr
*        et_valu_sales_order   = lt_valu_sales_order
*        et_valu_project       = lt_valu_project
*        et_valu_subcontract   = lt_valu_subcontract
    et_vend_consign       = lt_vend_consign
    et_vend_retpack       = lt_vend_retpack
    et_vend_subcontract   = lt_vend_subcontract
    et_cust_consign       = lt_cust_consign
    et_cust_retpack       = lt_cust_retpack
    et_sales_order        = lt_sales_order
*        et_project            = lt_project
    et_commitment         = lt_commitment
    et_reservation        = lt_reservation
    et_sales_req          = lt_sales_req
    et_prod_order_quan    = lt_prod_order_quan
    et_return             = lt_return.            .

*  SET RUN TIME ANALYZER OFF.

  IF lt_return IS NOT INITIAL.

    LOOP AT lt_return ASSIGNING <ls_return>.

      IF  <ls_return>-type = 'E'.

       MESSAGE ID     'MW'
               TYPE   <ls_return>-type
               NUMBER '898'
               WITH <ls_return>-message(50)
                    <ls_return>-message+50(50)
                    <ls_return>-message+100(50)
                    <ls_return>-message+150(50)
        RAISING error.

      ENDIF.

    ENDLOOP.

  ENDIF.


* übernahme der export-daten in die prt-tabellen
  PERFORM build_prt_tables
    TABLES pt_matnr
           pt_werks
    CHANGING lt_matnr_batch
             lt_plant_sloc
             lt_basic_level1
             lt_basic_level2
             lt_basic_level3
             lt_basic_level4
             lt_plant_stock
             lt_valu_matnr
             lt_valu_sales_order
             lt_valu_project
             lt_valu_subcontract
             lt_vend_consign
             lt_vend_retpack
             lt_vend_subcontract
             lt_cust_consign
             lt_cust_retpack
             lt_sales_order
             lt_project
             lt_commitment
             lt_reservation
             lt_sales_req
             lt_prod_order_quan.

*---- Test, ob neuer Progress-Indicator angezeigt werden soll ---------*
  prozent = sy_tabix MOD progr_indic.
  IF prozent = 0.
    prozent = bas_proz * ( sy_tabix DIV progr_indic ).
    text_xxx+23(3) = prozent.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = prozent
        text       = text_xxx
      EXCEPTIONS
        OTHERS     = 1.                                     "#EC *
  ENDIF.

  SORT prt_lbe[] BY matnr werks lgort.

* zurückliefern an die Schnittstelle
  pt_mbe[] = prt_mbe[].
  pt_gbe[] = prt_gbe[].
  pt_wbe[] = prt_wbe[].
  pt_lbe[] = prt_lbe[].
  pt_ebs[] = prt_ebs[].
  pt_kbe[] = prt_kbe[].
  pt_mps[] = prt_mps[].
  pt_obs[] = prt_obs[].
  pt_vbs[] = prt_vbs[].
  pt_wbs[] = prt_wbs[].
  pt_oeb[] = prt_oeb[].
  pt_ek_vk[] = prt_ek_vk[].

ENDFORM.                    " Bestandsdaten_lesen_new

*&---------------------------------------------------------------------*
*&      Form  build_prt_tables
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM build_prt_tables
 TABLES
      pt_matnr STRUCTURE t_matnr                            "#EC NEEDED
      pt_werks STRUCTURE t_werks                            "#EC NEEDED
*      pt_mbe   STRUCTURE mbe
*      pt_gbe   STRUCTURE gbe
*      pt_wbe   STRUCTURE wbe
*      pt_lbe   STRUCTURE lbe
*      pt_ebs   STRUCTURE ebs
*      pt_kbe   STRUCTURE kbe
*      pt_mps   STRUCTURE mps
*      pt_obs   STRUCTURE obs
*      pt_vbs   STRUCTURE vbs
*      pt_wbs   STRUCTURE wbs
*      pt_oeb   STRUCTURE oeb
*      pt_ek_vk STRUCTURE ek_vk
  CHANGING
      pt_matnr_batch        TYPE imil_matnr_batch_tty
      pt_plant_sloc         TYPE imil_plant_sloc_tty
      pt_basic_level1       TYPE imil_basic_stock_level1_tty
      pt_basic_level2       TYPE imil_basic_stock_level2_tty
      pt_basic_level3       TYPE imil_basic_stock_level3_tty
      pt_basic_level4       TYPE imil_basic_stock_level4_tty
      pt_plant_stock        TYPE imil_plant_stock_tty
      pt_valu_matnr         TYPE imil_valu_matnr_tty
      pt_valu_sales_order   TYPE imil_valu_sales_order_tty
      pt_valu_project       TYPE imil_valu_project_tty
      pt_valu_subcontract   TYPE imil_valu_subcontract_tty
      pt_vend_consign       TYPE imil_vendor_spec_stock_tty
      pt_vend_retpack       TYPE imil_vendor_spec_stock_tty
      pt_vend_subcontract   TYPE imil_subcontract_stock_tty
      pt_cust_consign       TYPE imil_customer_spec_stock_tty
      pt_cust_retpack       TYPE imil_customer_spec_stock_tty
      pt_sales_order        TYPE imil_sales_order_stock_tty
      pt_project            TYPE imil_project_stock_tty
      pt_commitment         TYPE imil_commitment_stock_tty
      pt_reservation        TYPE imil_reservation_stock_tty
      pt_sales_req          TYPE imil_sales_requirement_tty
      pt_prod_order_quan    TYPE imil_prod_order_quan_tty.

  DATA:
    ls_mbe   LIKE mbe,
    ls_wbe   LIKE wbe,
    ls_gbe   LIKE gbe,
    ls_lbe   LIKE lbe,
    ls_ebs   LIKE ebs,
    ls_kbe   LIKE kbe,
    ls_mps   LIKE mps,
    ls_obs   LIKE obs,
    ls_vbs   LIKE vbs,
    ls_wbs   LIKE wbs,
    ls_ek_vk LIKE ek_vk.

  FIELD-SYMBOLS:
      <ls_plant_sloc>         TYPE imil_plant_sloc_sty,
      <ls_basic_level1>       TYPE imil_basic_stock_level1_sty,
      <ls_basic_level2>       TYPE imil_basic_stock_level2_sty,
      <ls_basic_level3>       TYPE imil_basic_stock_level3_sty,
      <ls_plant_stock>        TYPE imil_plant_stock_sty,
      <ls_valu_matnr>         TYPE imil_valu_matnr_sty,
      <ls_vend_consign>       TYPE imil_vendor_spec_stock_sty,
      <ls_vend_retpack>       TYPE imil_vendor_spec_stock_sty,
      <ls_cust_consign>       TYPE imil_customer_spec_stock_sty,
      <ls_cust_retpack>       TYPE imil_customer_spec_stock_sty,
      <ls_sales_order>        TYPE imil_sales_order_stock_sty,
*      <ls_project>            TYPE imil_project_stock_sty,
      <ls_subcontract>        TYPE imil_subcontract_stock_sty,
      <ls_commitment>         TYPE imil_commitment_stock_sty,
      <ls_reservation>        TYPE imil_reservation_stock_sty,
      <ls_sales_req>          TYPE imil_sales_requirement_sty.
*      <ls_prod_order_quan>    TYPE imil_prod_order_quan_sty.

** create "empty" item in prt-tables if necessary (mbe, wbe, gbe)
*  ls_mbe-matnr = prt_matnr-matnr.
*  APPEND ls_mbe TO prt_mbe.
*
*  LOOP AT pt_plant_sloc ASSIGNING <ls_plant_sloc>.
*
*    CLEAR ls_wbe.
*    CLEAR ls_gbe.
*
*    READ TABLE pt_werks with key werks = <ls_plant_sloc>-werks  BINARY search.
*
*    MOVE-CORRESPONDING <ls_plant_sloc> TO ls_wbe.           "#EC ENHOK
*    MOVE-CORRESPONDING pt_werks TO ls_wbe.                  "#EC ENHOK
*    ls_wbe-name1 = pt_werks-wrkbz.
*    ls_wbe-matnr = prt_matnr-matnr.
*    INSERT ls_wbe INTO TABLE prt_wbe.
*
*    MOVE-CORRESPONDING pt_werks TO ls_gbe.                  "#EC ENHOK
*    ls_gbe-matnr = prt_matnr-matnr.
*
*    READ TABLE prt_gbe with key bwgrp = pt_werks-bwgrp          BINARY search.
*
*    IF sy-subrc <> 0.
*      INSERT ls_gbe INTO TABLE prt_gbe.
*    ENDIF.
*
*  ENDLOOP.

* fill the prt-tables

* sorting for correct binary search
  SORT prt_mbe BY matnr.
  SORT prt_lbe BY matnr werks lgort.
  SORT prt_gbe BY matnr bwgrp.
  SORT prt_wbe BY matnr werks.
  SORT prt_ebs BY matnr werks lgort.
  SORT prt_kbe BY matnr werks lgort.
  SORT prt_obs BY matnr werks.
  SORT prt_vbs BY matnr werks.
  SORT prt_oeb BY matnr werks.
  SORT prt_ek_vk BY matnr werks.

* basic stock data

  IF pt_basic_level1 IS NOT INITIAL.

    SORT pt_basic_level1 BY matnr.

    LOOP AT pt_basic_level1 ASSIGNING <ls_basic_level1>.

* fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level1>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level1>-labst TO prt_mbe-labst.
        ADD <ls_basic_level1>-umlme TO prt_mbe-umlme.
        ADD <ls_basic_level1>-insme TO prt_mbe-insme.
        ADD <ls_basic_level1>-einme TO prt_mbe-einme.
        ADD <ls_basic_level1>-speme TO prt_mbe-speme.
        ADD <ls_basic_level1>-retme TO prt_mbe-retme.
        prt_mbe-satnr = <ls_basic_level1>-gen_matnr.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill item for generic article
      IF <ls_basic_level1>-gen_matnr IS NOT INITIAL.

        READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level1>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level1>-labst TO prt_mbe-labst.
          ADD <ls_basic_level1>-umlme TO prt_mbe-umlme.
          ADD <ls_basic_level1>-insme TO prt_mbe-insme.
          ADD <ls_basic_level1>-einme TO prt_mbe-einme.
          ADD <ls_basic_level1>-speme TO prt_mbe-speme.
          ADD <ls_basic_level1>-retme TO prt_mbe-retme.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_basic_level2 IS NOT INITIAL.

    SORT pt_basic_level2 BY matnr.

    LOOP AT pt_basic_level2 ASSIGNING <ls_basic_level2>.

* fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level2>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level2>-labst TO prt_mbe-labst.
        ADD <ls_basic_level2>-umlme TO prt_mbe-umlme.
        ADD <ls_basic_level2>-insme TO prt_mbe-insme.
        ADD <ls_basic_level2>-einme TO prt_mbe-einme.
        ADD <ls_basic_level2>-speme TO prt_mbe-speme.
        ADD <ls_basic_level2>-retme TO prt_mbe-retme.
        prt_mbe-satnr = <ls_basic_level2>-gen_matnr.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_basic_level2>-matnr
                                  werks = <ls_basic_level2>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level2>-labst TO prt_wbe-labst.
        ADD <ls_basic_level2>-umlme TO prt_wbe-umlme.
        ADD <ls_basic_level2>-insme TO prt_wbe-insme.
        ADD <ls_basic_level2>-einme TO prt_wbe-einme.
        ADD <ls_basic_level2>-speme TO prt_wbe-speme.
        ADD <ls_basic_level2>-retme TO prt_wbe-retme.
        prt_wbe-satnr = <ls_basic_level2>-gen_matnr.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_basic_level2>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_basic_level2>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level2>-labst TO prt_gbe-labst.
        ADD <ls_basic_level2>-umlme TO prt_gbe-umlme.
        ADD <ls_basic_level2>-insme TO prt_gbe-insme.
        ADD <ls_basic_level2>-einme TO prt_gbe-einme.
        ADD <ls_basic_level2>-speme TO prt_gbe-speme.
        ADD <ls_basic_level2>-retme TO prt_gbe-retme.
        prt_gbe-satnr = <ls_basic_level2>-gen_matnr.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill item for generic article
      IF <ls_basic_level2>-gen_matnr IS NOT INITIAL.

* fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level2>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level2>-labst TO prt_mbe-labst.
          ADD <ls_basic_level2>-umlme TO prt_mbe-umlme.
          ADD <ls_basic_level2>-insme TO prt_mbe-insme.
          ADD <ls_basic_level2>-einme TO prt_mbe-einme.
          ADD <ls_basic_level2>-speme TO prt_mbe-speme.
          ADD <ls_basic_level2>-retme TO prt_mbe-retme.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_basic_level2>-gen_matnr
                                    werks = <ls_basic_level2>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level2>-labst TO prt_wbe-labst.
          ADD <ls_basic_level2>-umlme TO prt_wbe-umlme.
          ADD <ls_basic_level2>-insme TO prt_wbe-insme.
          ADD <ls_basic_level2>-einme TO prt_wbe-einme.
          ADD <ls_basic_level2>-speme TO prt_wbe-speme.
          ADD <ls_basic_level2>-retme TO prt_wbe-retme.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article

        READ TABLE pt_werks WITH KEY werks = <ls_basic_level2>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_basic_level2>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level2>-labst TO prt_gbe-labst.
          ADD <ls_basic_level2>-umlme TO prt_gbe-umlme.
          ADD <ls_basic_level2>-insme TO prt_gbe-insme.
          ADD <ls_basic_level2>-einme TO prt_gbe-einme.
          ADD <ls_basic_level2>-speme TO prt_gbe-speme.
          ADD <ls_basic_level2>-retme TO prt_gbe-retme.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_basic_level3 IS NOT INITIAL.

    SORT pt_basic_level3 BY matnr.

    LOOP AT pt_basic_level3 ASSIGNING <ls_basic_level3>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level3>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level3>-labst TO prt_mbe-labst.
        ADD <ls_basic_level3>-umlme TO prt_mbe-umlme.
        ADD <ls_basic_level3>-insme TO prt_mbe-insme.
        ADD <ls_basic_level3>-einme TO prt_mbe-einme.
        ADD <ls_basic_level3>-speme TO prt_mbe-speme.
        ADD <ls_basic_level3>-retme TO prt_mbe-retme.
        prt_mbe-satnr = <ls_basic_level3>-gen_matnr.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_basic_level3>-matnr
                                  werks = <ls_basic_level3>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level3>-labst TO prt_wbe-labst.
        ADD <ls_basic_level3>-umlme TO prt_wbe-umlme.
        ADD <ls_basic_level3>-insme TO prt_wbe-insme.
        ADD <ls_basic_level3>-einme TO prt_wbe-einme.
        ADD <ls_basic_level3>-speme TO prt_wbe-speme.
        ADD <ls_basic_level3>-retme TO prt_wbe-retme.
        prt_wbe-satnr = <ls_basic_level3>-gen_matnr.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_basic_level3>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_basic_level3>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_basic_level3>-labst TO prt_gbe-labst.
        ADD <ls_basic_level3>-umlme TO prt_gbe-umlme.
        ADD <ls_basic_level3>-insme TO prt_gbe-insme.
        ADD <ls_basic_level3>-einme TO prt_gbe-einme.
        ADD <ls_basic_level3>-speme TO prt_gbe-speme.
        ADD <ls_basic_level3>-retme TO prt_gbe-retme.
        prt_gbe-satnr = <ls_basic_level3>-gen_matnr.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_basic_level3>-matnr
                                  werks = <ls_basic_level3>-werks
                                  lgort = <ls_basic_level3>-lgort.

      IF sy-subrc = 0.

        ADD <ls_basic_level3>-labst TO prt_lbe-labst.
        ADD <ls_basic_level3>-umlme TO prt_lbe-umlme.
        ADD <ls_basic_level3>-insme TO prt_lbe-insme.
        ADD <ls_basic_level3>-einme TO prt_lbe-einme.
        ADD <ls_basic_level3>-speme TO prt_lbe-speme.
        prt_lbe-satnr = <ls_basic_level3>-gen_matnr.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        CLEAR ls_lbe.
        MOVE-CORRESPONDING <ls_basic_level3> TO ls_lbe.     "#EC ENHOK
        ls_lbe-labst = <ls_basic_level3>-labst.
        ls_lbe-insme = <ls_basic_level3>-insme.
        ls_lbe-einme = <ls_basic_level3>-einme.
        ls_lbe-speme = <ls_basic_level3>-speme.
        ls_lbe-satnr = <ls_basic_level3>-gen_matnr.
        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.


* fill item for generic article
      IF <ls_basic_level3>-gen_matnr IS NOT INITIAL.

* fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_basic_level3>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level3>-labst TO prt_mbe-labst.
          ADD <ls_basic_level3>-umlme TO prt_mbe-umlme.
          ADD <ls_basic_level3>-insme TO prt_mbe-insme.
          ADD <ls_basic_level3>-einme TO prt_mbe-einme.
          ADD <ls_basic_level3>-speme TO prt_mbe-speme.
          ADD <ls_basic_level3>-retme TO prt_mbe-retme.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_basic_level3>-gen_matnr
                                    werks = <ls_basic_level3>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level3>-labst TO prt_wbe-labst.
          ADD <ls_basic_level3>-umlme TO prt_wbe-umlme.
          ADD <ls_basic_level3>-insme TO prt_wbe-insme.
          ADD <ls_basic_level3>-einme TO prt_wbe-einme.
          ADD <ls_basic_level3>-speme TO prt_wbe-speme.
          ADD <ls_basic_level3>-retme TO prt_wbe-retme.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article

        READ TABLE pt_werks WITH KEY werks = <ls_basic_level3>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_basic_level3>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_basic_level3>-labst TO prt_gbe-labst.
          ADD <ls_basic_level3>-umlme TO prt_gbe-umlme.
          ADD <ls_basic_level3>-insme TO prt_gbe-insme.
          ADD <ls_basic_level3>-einme TO prt_gbe-einme.
          ADD <ls_basic_level3>-speme TO prt_gbe-speme.
          ADD <ls_basic_level3>-retme TO prt_gbe-retme.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_basic_level3>-gen_matnr
                                    werks = <ls_basic_level3>-werks
                                    lgort = <ls_basic_level3>-lgort.

        IF sy-subrc = 0.

          ADD <ls_basic_level3>-labst TO prt_lbe-labst.
          ADD <ls_basic_level3>-umlme TO prt_lbe-umlme.
          ADD <ls_basic_level3>-insme TO prt_lbe-insme.
          ADD <ls_basic_level3>-einme TO prt_lbe-einme.
          ADD <ls_basic_level3>-speme TO prt_lbe-speme.
          MODIFY prt_lbe INDEX sy-tabix.

        ELSE.

          CLEAR ls_lbe.
          MOVE-CORRESPONDING <ls_basic_level3> TO ls_lbe.   "#EC ENHOK
          ls_lbe-matnr = <ls_basic_level3>-gen_matnr.
          ls_lbe-labst = <ls_basic_level3>-labst.
          ls_lbe-insme = <ls_basic_level3>-insme.
          ls_lbe-einme = <ls_basic_level3>-einme.
          ls_lbe-speme = <ls_basic_level3>-speme.
          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_plant_stock IS NOT INITIAL.

    SORT pt_plant_stock BY matnr.

    LOOP AT pt_plant_stock  ASSIGNING <ls_plant_stock>.

* fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_plant_stock>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_plant_stock>-umlmc TO prt_mbe-umlmc.
        ADD <ls_plant_stock>-trame TO prt_mbe-trame.
        ADD <ls_plant_stock>-glgmg TO prt_mbe-glgmg.
        ADD <ls_plant_stock>-bwesb TO prt_mbe-wespb.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_plant_stock>-matnr
                                  werks = <ls_plant_stock>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_plant_stock>-umlmc TO prt_wbe-umlmc.
        ADD <ls_plant_stock>-trame TO prt_wbe-trame.
        ADD <ls_plant_stock>-glgmg TO prt_wbe-glgmg.
        ADD <ls_plant_stock>-bwesb TO prt_wbe-wespb.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_plant_stock>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_plant_stock>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_plant_stock>-umlmc TO prt_gbe-umlmc.
        ADD <ls_plant_stock>-trame TO prt_gbe-trame.
        ADD <ls_plant_stock>-glgmg TO prt_gbe-glgmg.
        ADD <ls_plant_stock>-bwesb TO prt_gbe-wespb.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill item for generic article
      IF <ls_plant_stock>-gen_matnr IS NOT INITIAL.

* fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_plant_stock>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_plant_stock>-umlmc TO prt_mbe-umlmc.
          ADD <ls_plant_stock>-trame TO prt_mbe-trame.
          ADD <ls_plant_stock>-glgmg TO prt_mbe-glgmg.
          ADD <ls_plant_stock>-bwesb TO prt_mbe-wespb.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_plant_stock>-gen_matnr
                                    werks = <ls_plant_stock>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_plant_stock>-umlmc TO prt_wbe-umlmc.
          ADD <ls_plant_stock>-trame TO prt_wbe-trame.
          ADD <ls_plant_stock>-glgmg TO prt_wbe-glgmg.
          ADD <ls_plant_stock>-bwesb TO prt_wbe-wespb.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_plant_stock>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_plant_stock>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_plant_stock>-umlmc TO prt_gbe-umlmc.
          ADD <ls_plant_stock>-trame TO prt_gbe-trame.
          ADD <ls_plant_stock>-glgmg TO prt_gbe-glgmg.
          ADD <ls_plant_stock>-bwesb TO prt_gbe-wespb.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

* fill valuated stock data
  IF pt_valu_matnr IS NOT INITIAL.

    SORT pt_valu_matnr BY matnr.

    LOOP AT pt_valu_matnr ASSIGNING <ls_valu_matnr>.

      CLEAR ls_ek_vk.
      MOVE-CORRESPONDING <ls_valu_matnr> TO ls_ek_vk.       "#EC ENHOK
      ls_ek_vk-ekwer =  <ls_valu_matnr>-salk3.
      ls_ek_vk-vkwer =  <ls_valu_matnr>-vksal.
      INSERT ls_ek_vk INTO TABLE prt_ek_vk.

* fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_valu_matnr>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_valu_matnr>-lbkum TO prt_mbe-lbkum.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_valu_matnr>-matnr
                                  werks = <ls_valu_matnr>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_valu_matnr>-lbkum TO prt_wbe-lbkum.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_valu_matnr>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_valu_matnr>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_valu_matnr>-lbkum TO prt_gbe-lbkum.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.


* fill item for generic article
      IF <ls_valu_matnr>-gen_matnr IS NOT INITIAL.

        READ TABLE prt_ek_vk WITH KEY matnr = <ls_valu_matnr>-gen_matnr
                                      werks = pt_werks-bwgrp.

        IF sy-subrc = 0.

          ADD <ls_valu_matnr>-salk3 TO prt_ek_vk-ekwer.
          ADD <ls_valu_matnr>-vksal TO prt_ek_vk-vkwer.
          MODIFY prt_ek_vk INDEX sy-tabix.

        ELSE.

          CLEAR ls_ek_vk.
          MOVE-CORRESPONDING <ls_valu_matnr> TO ls_ek_vk.   "#EC ENHOK
          ls_ek_vk-matnr = <ls_valu_matnr>-gen_matnr.
          ls_ek_vk-ekwer =  <ls_valu_matnr>-salk3.
          ls_ek_vk-vkwer =  <ls_valu_matnr>-vksal.
          INSERT ls_ek_vk INTO TABLE prt_ek_vk.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

* fill special stock data
  IF pt_vend_consign IS NOT INITIAL.

    SORT pt_vend_consign BY matnr.

    LOOP AT pt_vend_consign ASSIGNING <ls_vend_consign>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_vend_consign>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_consign>-slabs TO prt_mbe-klabs.
        ADD <ls_vend_consign>-sinsm TO prt_mbe-kinsm.
        ADD <ls_vend_consign>-seinm TO prt_mbe-keinm.
        ADD <ls_vend_consign>-sspem TO prt_mbe-kspem.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_vend_consign>-matnr
                                  werks = <ls_vend_consign>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_consign>-slabs TO prt_wbe-klabs.
        ADD <ls_vend_consign>-sinsm TO prt_wbe-kinsm.
        ADD <ls_vend_consign>-seinm TO prt_wbe-keinm.
        ADD <ls_vend_consign>-sspem TO prt_wbe-kspem.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_vend_consign>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_vend_consign>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_consign>-slabs TO prt_gbe-klabs.
        ADD <ls_vend_consign>-sinsm TO prt_gbe-kinsm.
        ADD <ls_vend_consign>-seinm TO prt_gbe-keinm.
        ADD <ls_vend_consign>-sspem TO prt_gbe-kspem.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_vend_consign>-matnr
                                  werks = <ls_vend_consign>-werks
                                  lgort = <ls_vend_consign>-lgort.

      IF sy-subrc = 0.

        ADD <ls_vend_consign>-slabs TO prt_lbe-klabs.
        ADD <ls_vend_consign>-sinsm TO prt_lbe-kinsm.
        ADD <ls_vend_consign>-seinm TO prt_lbe-keinm.
        ADD <ls_vend_consign>-sspem TO prt_lbe-kspem.
        prt_lbe-satnr = <ls_vend_consign>-gen_matnr.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        CLEAR ls_lbe.
        MOVE-CORRESPONDING <ls_vend_consign> TO ls_lbe.     "#EC ENHOK
        ls_lbe-klabs = <ls_vend_consign>-slabs.
        ls_lbe-kinsm = <ls_vend_consign>-sinsm.
        ls_lbe-keinm = <ls_vend_consign>-seinm.
        ls_lbe-kspem = <ls_vend_consign>-sspem.
        ls_lbe-satnr = <ls_vend_consign>-gen_matnr.
        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.

* fill kbe
      CLEAR ls_kbe.
      MOVE-CORRESPONDING <ls_vend_consign> TO ls_kbe.       "#EC ENHOK
      ls_kbe-labst = <ls_vend_consign>-slabs.
      ls_kbe-insme = <ls_vend_consign>-sinsm.
      ls_kbe-einme = <ls_vend_consign>-seinm.
      ls_kbe-speme = <ls_vend_consign>-sspem.
      ls_kbe-satnr = <ls_vend_consign>-gen_matnr.
      INSERT ls_kbe INTO TABLE prt_kbe.

      kz_sond_exist = x.

* fill item for generic article
      IF <ls_vend_consign>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_vend_consign>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_consign>-slabs TO prt_mbe-klabs.
          ADD <ls_vend_consign>-sinsm TO prt_mbe-kinsm.
          ADD <ls_vend_consign>-seinm TO prt_mbe-keinm.
          ADD <ls_vend_consign>-sspem TO prt_mbe-kspem.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_vend_consign>-gen_matnr
                                    werks = <ls_vend_consign>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_consign>-slabs TO prt_wbe-klabs.
          ADD <ls_vend_consign>-sinsm TO prt_wbe-kinsm.
          ADD <ls_vend_consign>-seinm TO prt_wbe-keinm.
          ADD <ls_vend_consign>-sspem TO prt_wbe-kspem.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_vend_consign>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_vend_consign>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_consign>-slabs TO prt_gbe-klabs.
          ADD <ls_vend_consign>-sinsm TO prt_gbe-kinsm.
          ADD <ls_vend_consign>-seinm TO prt_gbe-keinm.
          ADD <ls_vend_consign>-sspem TO prt_gbe-kspem.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_vend_consign>-gen_matnr
                                    werks = <ls_vend_consign>-werks
                                    lgort = <ls_vend_consign>-lgort.

        IF sy-subrc = 0.

          ADD <ls_vend_consign>-slabs TO prt_lbe-klabs.
          ADD <ls_vend_consign>-sinsm TO prt_lbe-kinsm.
          ADD <ls_vend_consign>-seinm TO prt_lbe-keinm.
          ADD <ls_vend_consign>-sspem TO prt_lbe-kspem.
          MODIFY prt_lbe INDEX sy-tabix.

*        ELSE.
*
*          CLEAR ls_lbe.
*          MOVE-CORRESPONDING <ls_vend_consign> TO ls_lbe.   "#EC ENHOK
*          ls_lbe-matnr = <ls_vend_consign>-gen_matnr.
*          ls_lbe-klabs = <ls_vend_consign>-slabs.
*          ls_lbe-kinsm = <ls_vend_consign>-sinsm.
*          ls_lbe-keinm = <ls_vend_consign>-seinm.
*          ls_lbe-kspem = <ls_vend_consign>-sspem.
*          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

* fill kbe for generic article
        READ TABLE prt_kbe WITH KEY matnr = <ls_vend_consign>-gen_matnr
                                    werks = <ls_vend_consign>-werks
                                    lgort = <ls_vend_consign>-lgort
                                    lifnr = <ls_vend_consign>-lifnr.

        IF sy-subrc = 0.

          ADD <ls_vend_consign>-slabs TO prt_kbe-labst.
          ADD <ls_vend_consign>-sinsm TO prt_kbe-insme.
          ADD <ls_vend_consign>-seinm TO prt_kbe-einme.
          ADD <ls_vend_consign>-sspem TO prt_kbe-speme.
          MODIFY prt_kbe INDEX sy-tabix.

        ELSE.

          CLEAR ls_kbe.
          MOVE-CORRESPONDING <ls_vend_consign> TO ls_kbe.   "#EC ENHOK
          ls_kbe-matnr = <ls_vend_consign>-gen_matnr.
          ls_kbe-labst = <ls_vend_consign>-slabs.
          ls_kbe-insme = <ls_vend_consign>-sinsm.
          ls_kbe-einme = <ls_vend_consign>-seinm.
          ls_kbe-speme = <ls_vend_consign>-sspem.
          INSERT ls_kbe INTO TABLE prt_kbe.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_vend_retpack IS NOT INITIAL.

    SORT pt_vend_retpack BY matnr.

    LOOP AT pt_vend_retpack ASSIGNING <ls_vend_retpack>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_vend_retpack>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_retpack>-slabs TO prt_mbe-mlabs.
        ADD <ls_vend_retpack>-sinsm TO prt_mbe-minsm.
        ADD <ls_vend_retpack>-seinm TO prt_mbe-meinm.
        ADD <ls_vend_retpack>-sspem TO prt_mbe-mspem.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_vend_retpack>-matnr
                                  werks = <ls_vend_retpack>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_retpack>-slabs TO prt_wbe-mlabs.
        ADD <ls_vend_retpack>-sinsm TO prt_wbe-minsm.
        ADD <ls_vend_retpack>-seinm TO prt_wbe-meinm.
        ADD <ls_vend_retpack>-sspem TO prt_wbe-mspem.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_vend_retpack>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_vend_retpack>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_vend_retpack>-slabs TO prt_gbe-mlabs.
        ADD <ls_vend_retpack>-sinsm TO prt_gbe-minsm.
        ADD <ls_vend_retpack>-seinm TO prt_gbe-meinm.
        ADD <ls_vend_retpack>-sspem TO prt_gbe-mspem.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_vend_retpack>-matnr
                                  werks = <ls_vend_retpack>-werks
                                  lgort = <ls_vend_retpack>-lgort.

      IF sy-subrc = 0.

        ADD <ls_vend_retpack>-slabs TO prt_lbe-mlabs.
        ADD <ls_vend_retpack>-sinsm TO prt_lbe-minsm.
        ADD <ls_vend_retpack>-seinm TO prt_lbe-meinm.
        ADD <ls_vend_retpack>-sspem TO prt_lbe-mspem.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        MOVE-CORRESPONDING <ls_vend_retpack> TO ls_lbe.     "#EC ENHOK
        ls_lbe-mlabs = <ls_vend_retpack>-slabs.
        ls_lbe-minsm = <ls_vend_retpack>-sinsm.
        ls_lbe-meinm = <ls_vend_retpack>-seinm.
        ls_lbe-mspem = <ls_vend_retpack>-sspem.
        ls_lbe-satnr = <ls_vend_retpack>-gen_matnr.

        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.

* fill mps
      CLEAR ls_mps.
      MOVE-CORRESPONDING <ls_vend_retpack> TO ls_mps.       "#EC ENHOK
      ls_mps-labst = <ls_vend_retpack>-slabs.
      ls_mps-insme = <ls_vend_retpack>-sinsm.
      ls_mps-einme = <ls_vend_retpack>-seinm.
      ls_mps-speme = <ls_vend_retpack>-sspem.
      ls_mps-satnr = <ls_vend_retpack>-gen_matnr.

      INSERT ls_mps INTO TABLE prt_mps.

      kz_sond_exist = x.

* fill item for generic article
      IF <ls_vend_retpack>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_vend_retpack>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_retpack>-slabs TO prt_mbe-mlabs.
          ADD <ls_vend_retpack>-sinsm TO prt_mbe-minsm.
          ADD <ls_vend_retpack>-seinm TO prt_mbe-meinm.
          ADD <ls_vend_retpack>-sspem TO prt_mbe-mspem.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_vend_retpack>-gen_matnr
                                    werks = <ls_vend_retpack>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_retpack>-slabs TO prt_wbe-mlabs.
          ADD <ls_vend_retpack>-sinsm TO prt_wbe-minsm.
          ADD <ls_vend_retpack>-seinm TO prt_wbe-meinm.
          ADD <ls_vend_retpack>-sspem TO prt_wbe-mspem.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_vend_retpack>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_vend_retpack>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_vend_retpack>-slabs TO prt_gbe-mlabs.
          ADD <ls_vend_retpack>-sinsm TO prt_gbe-minsm.
          ADD <ls_vend_retpack>-seinm TO prt_gbe-meinm.
          ADD <ls_vend_retpack>-sspem TO prt_gbe-mspem.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_vend_retpack>-gen_matnr
                                    werks = <ls_vend_retpack>-werks
                                    lgort = <ls_vend_retpack>-lgort.

        IF sy-subrc = 0.

          ADD <ls_vend_retpack>-slabs TO prt_lbe-mlabs.
          ADD <ls_vend_retpack>-sinsm TO prt_lbe-minsm.
          ADD <ls_vend_retpack>-seinm TO prt_lbe-meinm.
          ADD <ls_vend_retpack>-sspem TO prt_lbe-mspem.
          MODIFY prt_lbe INDEX sy-tabix.

*        ELSE.
*
*          MOVE-CORRESPONDING <ls_vend_retpack> TO ls_lbe.   "#EC ENHOK
*          ls_lbe-matnr = <ls_vend_consign>-gen_matnr.
*          ls_lbe-mlabs = <ls_vend_retpack>-slabs.
*          ls_lbe-minsm = <ls_vend_retpack>-sinsm.
*          ls_lbe-meinm = <ls_vend_retpack>-seinm.
*          ls_lbe-mspem = <ls_vend_retpack>-sspem.
*          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

* fill mps for generic article
        READ TABLE prt_mps WITH KEY matnr = <ls_vend_retpack>-gen_matnr
                                    werks = <ls_vend_retpack>-werks
                                    lgort = <ls_vend_retpack>-lgort
                                    lifnr = <ls_vend_retpack>-lifnr.

        IF sy-subrc = 0.

          ADD <ls_vend_retpack>-slabs TO prt_mps-labst.
          ADD <ls_vend_retpack>-sinsm TO prt_mps-insme.
          ADD <ls_vend_retpack>-seinm TO prt_mps-einme.
          ADD <ls_vend_retpack>-sspem TO prt_mps-speme.
          MODIFY prt_mps INDEX sy-tabix.

        ELSE.

          CLEAR ls_mps.
          MOVE-CORRESPONDING <ls_vend_retpack> TO ls_mps.   "#EC ENHOK
          ls_mps-matnr = <ls_vend_retpack>-gen_matnr.
          ls_mps-labst = <ls_vend_retpack>-slabs.
          ls_mps-insme = <ls_vend_retpack>-sinsm.
          ls_mps-einme = <ls_vend_retpack>-seinm.
          ls_mps-speme = <ls_vend_retpack>-sspem.

          INSERT ls_mps INTO TABLE prt_mps.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_vend_subcontract IS NOT INITIAL.

    SORT pt_vend_subcontract BY matnr.

    LOOP AT pt_vend_subcontract ASSIGNING <ls_subcontract>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_subcontract>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
        ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
        ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_subcontract>-matnr
                                  werks = <ls_subcontract>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
        ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
        ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_subcontract>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_subcontract>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
        ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
        ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_subcontract>-matnr
                                  werks = <ls_subcontract>-werks.

      IF sy-subrc = 0.

        ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
        ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
        ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        CLEAR ls_lbe.
        MOVE-CORRESPONDING <ls_subcontract> TO ls_lbe.      "#EC ENHOK
        ls_lbe-satnr = <ls_subcontract>-gen_matnr.
        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.

* fill obs
      CLEAR ls_obs.
      MOVE-CORRESPONDING <ls_subcontract> TO ls_obs.        "#EC ENHOK
      ls_obs-labst = <ls_subcontract>-lblab.
      ls_obs-insme = <ls_subcontract>-lbins.
      ls_obs-einme = <ls_subcontract>-lbein.
      ls_obs-satnr = <ls_subcontract>-gen_matnr.
      INSERT ls_obs INTO TABLE prt_obs.

* fill item for generic article
      IF <ls_subcontract>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_subcontract>-matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
          ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
          ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_subcontract>-gen_matnr
                                    werks = <ls_subcontract>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
          ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
          ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_subcontract>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_subcontract>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
          ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
          ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_subcontract>-gen_matnr
                                    werks = <ls_subcontract>-werks.

        IF sy-subrc = 0.

          ADD <ls_subcontract>-lblab TO prt_mbe-lblab.
          ADD <ls_subcontract>-lbins TO prt_mbe-lbins.
          ADD <ls_subcontract>-lbein TO prt_mbe-lbein.
          MODIFY prt_lbe INDEX sy-tabix.

*        ELSE.
*
*          CLEAR ls_lbe.
*          MOVE-CORRESPONDING <ls_subcontract> TO ls_lbe.    "#EC ENHOK
*          ls_lbe-matnr = <ls_vend_consign>-gen_matnr.
*          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

* fill obs for generic article
        READ TABLE prt_obs WITH KEY matnr = <ls_subcontract>-gen_matnr
                                    werks = <ls_subcontract>-werks
                                    lifnr = <ls_subcontract>-lifnr.

        IF sy-subrc = 0.

          ADD <ls_subcontract>-lblab TO prt_obs-labst.
          ADD <ls_subcontract>-lbins TO prt_obs-insme.
          ADD <ls_subcontract>-lbein TO prt_obs-einme.
          MODIFY prt_obs INDEX sy-tabix.


        ELSE.

          CLEAR ls_obs.
          MOVE-CORRESPONDING <ls_subcontract> TO ls_obs.    "#EC ENHOK
          ls_obs-matnr = <ls_subcontract>-gen_matnr.
          ls_obs-labst = <ls_subcontract>-lblab.
          ls_obs-insme = <ls_subcontract>-lbins.
          ls_obs-einme = <ls_subcontract>-lbein.
          INSERT ls_obs INTO TABLE prt_obs.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.


  IF pt_cust_consign IS NOT INITIAL.

    SORT pt_vend_consign BY matnr.

    LOOP AT pt_cust_consign ASSIGNING <ls_cust_consign>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_cust_consign>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_consign>-kulab TO prt_mbe-kulaw.
        ADD <ls_cust_consign>-kuins TO prt_mbe-kuinw.
        ADD <ls_cust_consign>-kuein TO prt_mbe-kueiw.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_cust_consign>-matnr
                                  werks = <ls_cust_consign>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_consign>-kulab TO prt_wbe-kulaw.
        ADD <ls_cust_consign>-kuins TO prt_wbe-kuinw.
        ADD <ls_cust_consign>-kuein TO prt_wbe-kueiw.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_cust_consign>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_cust_consign>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_consign>-kulab TO prt_gbe-kulaw.
        ADD <ls_cust_consign>-kuins TO prt_gbe-kuinw.
        ADD <ls_cust_consign>-kuein TO prt_gbe-kueiw.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill wbs
      CLEAR ls_wbs.
      MOVE-CORRESPONDING <ls_cust_consign> TO ls_wbs.       "#EC ENHOK
      ls_wbs-labst = <ls_cust_consign>-kulab.
      ls_wbs-insme = <ls_cust_consign>-kuins.
      ls_wbs-einme = <ls_cust_consign>-kuein.
      ls_wbs-satnr = <ls_cust_consign>-gen_matnr.
      INSERT ls_wbs INTO TABLE prt_wbs.

* fill item for generic article
      IF <ls_cust_consign>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_cust_consign>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_consign>-kulab TO prt_mbe-kulaw.
          ADD <ls_cust_consign>-kuins TO prt_mbe-kuinw.
          ADD <ls_cust_consign>-kuein TO prt_mbe-kueiw.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_cust_consign>-gen_matnr
                                    werks = <ls_cust_consign>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_consign>-kulab TO prt_wbe-kulaw.
          ADD <ls_cust_consign>-kuins TO prt_wbe-kuinw.
          ADD <ls_cust_consign>-kuein TO prt_wbe-kueiw.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_cust_consign>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_cust_consign>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_consign>-kulab TO prt_gbe-kulaw.
          ADD <ls_cust_consign>-kuins TO prt_gbe-kuinw.
          ADD <ls_cust_consign>-kuein TO prt_gbe-kueiw.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill wbs for generic article
        READ TABLE prt_wbs WITH KEY matnr = <ls_cust_consign>-gen_matnr
                                    werks = pt_werks-bwgrp
                                    kunnr = <ls_cust_consign>-kunnr.

        IF sy-subrc = 0.

          ADD <ls_cust_consign>-kulab TO prt_wbs-labst.
          ADD <ls_cust_consign>-kuins TO prt_wbs-insme.
          ADD <ls_cust_consign>-kuein TO prt_wbs-einme.
          MODIFY prt_wbs INDEX sy-tabix.

        ELSE.

          CLEAR ls_wbs.
          MOVE-CORRESPONDING <ls_cust_consign> TO ls_wbs.   "#EC ENHOK
          ls_wbs-matnr = <ls_cust_consign>-gen_matnr.
          ls_wbs-labst = <ls_cust_consign>-kulab.
          ls_wbs-insme = <ls_cust_consign>-kuins.
          ls_wbs-einme = <ls_cust_consign>-kuein.
          INSERT ls_wbs INTO TABLE prt_wbs.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_cust_retpack IS NOT INITIAL.

    SORT pt_cust_retpack BY matnr.

    LOOP AT pt_cust_retpack ASSIGNING <ls_cust_retpack>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_cust_retpack>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_retpack>-kulab TO prt_mbe-kulav.
        ADD <ls_cust_retpack>-kuins TO prt_mbe-kuinv.
        ADD <ls_cust_retpack>-kuein TO prt_mbe-kueiv.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_cust_retpack>-matnr
                                  werks = <ls_cust_retpack>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_retpack>-kulab TO prt_wbe-kulav.
        ADD <ls_cust_retpack>-kuins TO prt_wbe-kuinv.
        ADD <ls_cust_retpack>-kuein TO prt_wbe-kueiv.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_cust_retpack>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_cust_retpack>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_cust_retpack>-kulab TO prt_gbe-kulav.
        ADD <ls_cust_retpack>-kuins TO prt_gbe-kuinv.
        ADD <ls_cust_retpack>-kuein TO prt_gbe-kueiv.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill vbs
      CLEAR ls_vbs.
      MOVE-CORRESPONDING <ls_cust_retpack> TO ls_vbs.       "#EC ENHOK
      ls_vbs-labst = <ls_cust_retpack>-kulab.
      ls_vbs-insme = <ls_cust_retpack>-kuins.
      ls_vbs-einme = <ls_cust_retpack>-kuein.
      ls_vbs-satnr = <ls_cust_retpack>-gen_matnr.
      INSERT ls_vbs INTO TABLE prt_vbs.

* fill item for generic article
      IF <ls_cust_retpack>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_cust_retpack>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_retpack>-kulab TO prt_mbe-kulav.
          ADD <ls_cust_retpack>-kuins TO prt_mbe-kuinv.
          ADD <ls_cust_retpack>-kuein TO prt_mbe-kueiv.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_cust_retpack>-gen_matnr
                                    werks = <ls_cust_retpack>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_retpack>-kulab TO prt_wbe-kulav.
          ADD <ls_cust_retpack>-kuins TO prt_wbe-kuinv.
          ADD <ls_cust_retpack>-kuein TO prt_wbe-kueiv.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_cust_retpack>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_cust_retpack>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_cust_retpack>-kulab TO prt_gbe-kulav.
          ADD <ls_cust_retpack>-kuins TO prt_gbe-kuinv.
          ADD <ls_cust_retpack>-kuein TO prt_gbe-kueiv.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill vbs for generic article
        READ TABLE prt_vbs WITH KEY matnr = <ls_cust_retpack>-gen_matnr
                                            werks = pt_werks-bwgrp
                                            kunnr = <ls_cust_consign>-kunnr.

        IF sy-subrc = 0.

          ADD <ls_cust_retpack>-kulab TO prt_vbs-labst.
          ADD <ls_cust_retpack>-kuins TO prt_vbs-insme.
          ADD <ls_cust_retpack>-kuein TO prt_vbs-einme.
          MODIFY prt_vbs INDEX sy-tabix.

        ELSE.

          CLEAR ls_vbs.
          MOVE-CORRESPONDING <ls_cust_retpack> TO ls_vbs.   "#EC ENHOK
          ls_vbs-matnr = <ls_cust_retpack>-gen_matnr.
          ls_vbs-labst = <ls_cust_retpack>-kulab.
          ls_vbs-insme = <ls_cust_retpack>-kuins.
          ls_vbs-einme = <ls_cust_retpack>-kuein.
          INSERT ls_vbs INTO TABLE prt_vbs.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_sales_order IS NOT INITIAL.

    SORT pt_sales_order BY matnr.

    LOOP AT pt_sales_order ASSIGNING <ls_sales_order>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_sales_order>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_sales_order>-kalab TO prt_mbe-kalab.
        ADD <ls_sales_order>-kains TO prt_mbe-kains.
        ADD <ls_sales_order>-kaein TO prt_mbe-kaein.
        ADD <ls_sales_order>-kaspe TO prt_mbe-kaspe.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_sales_order>-matnr
                                  werks = <ls_sales_order>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_sales_order>-kalab TO prt_wbe-kalab.
        ADD <ls_sales_order>-kains TO prt_wbe-kains.
        ADD <ls_sales_order>-kaein TO prt_wbe-kaein.
        ADD <ls_sales_order>-kaspe TO prt_wbe-kaspe.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_sales_order>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_sales_order>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_sales_order>-kalab TO prt_gbe-kalab.
        ADD <ls_sales_order>-kains TO prt_gbe-kains.
        ADD <ls_sales_order>-kaein TO prt_gbe-kaein.
        ADD <ls_sales_order>-kaspe TO prt_gbe-kaspe.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_sales_order>-matnr
                                  werks = <ls_sales_order>-werks
                                  lgort = <ls_sales_order>-lgort.

      IF sy-subrc = 0.

        ADD <ls_sales_order>-kalab TO prt_lbe-kalab.
        ADD <ls_sales_order>-kains TO prt_lbe-kains.
        ADD <ls_sales_order>-kaein TO prt_lbe-kaein.
        ADD <ls_sales_order>-kaspe TO prt_lbe-kaspe.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        CLEAR ls_lbe.
        MOVE-CORRESPONDING <ls_sales_order> TO ls_lbe.      "#EC ENHOK
        ls_lbe-satnr = <ls_sales_order>-gen_matnr.
        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.

* fill ebs
      CLEAR ls_ebs.
      MOVE-CORRESPONDING <ls_sales_order> TO ls_ebs.        "#EC ENHOK
      ls_ebs-labst = <ls_sales_order>-kalab.
      ls_ebs-insme = <ls_sales_order>-kains.
      ls_ebs-einme = <ls_sales_order>-kaein.
      ls_ebs-speme = <ls_sales_order>-kaspe.
      ls_ebs-satnr = <ls_sales_order>-gen_matnr.
      INSERT ls_ebs INTO TABLE prt_ebs.

      kz_sond_exist = x.

* fill item for generic article
      IF <ls_sales_order>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_sales_order>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_sales_order>-kalab TO prt_mbe-kalab.
          ADD <ls_sales_order>-kains TO prt_mbe-kains.
          ADD <ls_sales_order>-kaein TO prt_mbe-kaein.
          ADD <ls_sales_order>-kaspe TO prt_mbe-kaspe.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_sales_order>-gen_matnr
                                    werks = <ls_sales_order>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_sales_order>-kalab TO prt_wbe-kalab.
          ADD <ls_sales_order>-kains TO prt_wbe-kains.
          ADD <ls_sales_order>-kaein TO prt_wbe-kaein.
          ADD <ls_sales_order>-kaspe TO prt_wbe-kaspe.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_sales_order>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_sales_order>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_sales_order>-kalab TO prt_gbe-kalab.
          ADD <ls_sales_order>-kains TO prt_gbe-kains.
          ADD <ls_sales_order>-kaein TO prt_gbe-kaein.
          ADD <ls_sales_order>-kaspe TO prt_gbe-kaspe.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_sales_order>-gen_matnr
                                    werks = <ls_sales_order>-werks
                                    lgort = <ls_sales_order>-lgort.

        IF sy-subrc = 0.

          ADD <ls_sales_order>-kalab TO prt_lbe-kalab.
          ADD <ls_sales_order>-kains TO prt_lbe-kains.
          ADD <ls_sales_order>-kaein TO prt_lbe-kaein.
          ADD <ls_sales_order>-kaspe TO prt_lbe-kaspe.
          MODIFY prt_lbe INDEX sy-tabix.

*        ELSE.
*
*          CLEAR ls_lbe.
*          MOVE-CORRESPONDING <ls_sales_order> TO ls_lbe.    "#EC ENHOK
*          ls_lbe-matnr = <ls_sales_order>-gen_matnr.
*          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

* fill ebs for generic article
* for every variant one single item.
        CLEAR ls_ebs.
        MOVE-CORRESPONDING <ls_sales_order> TO ls_ebs.      "#EC ENHOK
        ls_ebs-matnr = <ls_sales_order>-gen_matnr.
        ls_ebs-labst = <ls_sales_order>-kalab.
        ls_ebs-insme = <ls_sales_order>-kains.
        ls_ebs-einme = <ls_sales_order>-kaein.
        ls_ebs-speme = <ls_sales_order>-kaspe.
        INSERT ls_ebs INTO TABLE prt_ebs.

      ENDIF.

    ENDLOOP.

  ENDIF.


* fill commitment data

  IF pt_commitment IS NOT INITIAL.

    SORT pt_commitment BY matnr.

    LOOP AT pt_commitment ASSIGNING <ls_commitment>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_commitment>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_commitment>-on_order         TO prt_mbe-menge.
        ADD <ls_commitment>-on_order_consign TO prt_mbe-mengk.
        ADD <ls_commitment>-gr_blocked       TO prt_mbe-wespb.
        ADD <ls_commitment>-transit_cc       TO prt_mbe-trasf.
        ADD <ls_commitment>-trspt_order      TO prt_mbe-bsabr.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_commitment>-matnr
                                  werks = <ls_commitment>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_commitment>-on_order         TO prt_wbe-menge.
        ADD <ls_commitment>-on_order_consign TO prt_wbe-mengk.
        ADD <ls_commitment>-gr_blocked       TO prt_wbe-wespb.
        ADD <ls_commitment>-transit_cc       TO prt_wbe-trasf.
        ADD <ls_commitment>-trspt_order      TO prt_wbe-bsabr.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_commitment>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_commitment>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_commitment>-on_order         TO prt_gbe-menge.
        ADD <ls_commitment>-on_order_consign TO prt_gbe-mengk.
        ADD <ls_commitment>-gr_blocked       TO prt_gbe-wespb.
        ADD <ls_commitment>-transit_cc       TO prt_gbe-trasf.
        ADD <ls_commitment>-trspt_order      TO prt_gbe-bsabr.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
* only if lgort is specified
      IF <ls_commitment>-lgort IS NOT INITIAL.

        READ TABLE prt_lbe WITH KEY matnr = <ls_commitment>-matnr
                                    werks = <ls_commitment>-werks
                                    lgort = <ls_commitment>-lgort.

        IF sy-subrc = 0.

          ADD <ls_commitment>-on_order         TO prt_lbe-menge.
          ADD <ls_commitment>-on_order_consign TO prt_lbe-mengk.
*          ADD <ls_commitment>-gr_blocked       TO prt_lbe-wespb.
*          ADD <ls_commitment>-transit_cc       TO prt_lbe-trasf.
*          ADD <ls_commitment>-trspt_order      TO prt_lbe-bsabr.
          MODIFY prt_lbe INDEX sy-tabix.

        ELSE.

          CLEAR ls_lbe.
          MOVE-CORRESPONDING <ls_commitment> TO ls_lbe.     "#EC ENHOK
          ls_lbe-menge = <ls_commitment>-on_order.
          ls_lbe-mengk = <ls_commitment>-on_order_consign.
          ls_lbe-satnr = <ls_commitment>-gen_matnr.
          INSERT ls_lbe INTO TABLE prt_lbe.

        ENDIF.

      ENDIF.

* fill item for generic article
      IF <ls_commitment>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_commitment>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_commitment>-on_order         TO prt_mbe-menge.
          ADD <ls_commitment>-on_order_consign TO prt_mbe-mengk.
          ADD <ls_commitment>-gr_blocked       TO prt_mbe-wespb.
          ADD <ls_commitment>-transit_cc       TO prt_mbe-trasf.
          ADD <ls_commitment>-trspt_order      TO prt_mbe-bsabr.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_commitment>-gen_matnr
                                    werks = <ls_commitment>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_commitment>-on_order         TO prt_wbe-menge.
          ADD <ls_commitment>-on_order_consign TO prt_wbe-mengk.
          ADD <ls_commitment>-gr_blocked       TO prt_wbe-wespb.
          ADD <ls_commitment>-transit_cc       TO prt_wbe-trasf.
          ADD <ls_commitment>-trspt_order      TO prt_wbe-bsabr.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_commitment>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_commitment>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_commitment>-on_order         TO prt_gbe-menge.
          ADD <ls_commitment>-on_order_consign TO prt_gbe-mengk.
          ADD <ls_commitment>-gr_blocked       TO prt_gbe-wespb.
          ADD <ls_commitment>-transit_cc       TO prt_gbe-trasf.
          ADD <ls_commitment>-trspt_order      TO prt_gbe-bsabr.
          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

* fill lbe for generic article
* only if lgort is specified
        IF <ls_commitment>-lgort IS NOT INITIAL.

          READ TABLE prt_lbe WITH KEY matnr = <ls_commitment>-gen_matnr
                                      werks = <ls_commitment>-werks
                                      lgort = <ls_commitment>-lgort.

          IF sy-subrc = 0.

            ADD <ls_commitment>-on_order         TO prt_lbe-menge.
            ADD <ls_commitment>-on_order_consign TO prt_lbe-mengk.
*          ADD <ls_commitment>-gr_blocked       TO prt_lbe-wespb.
*          ADD <ls_commitment>-transit_cc       TO prt_lbe-trasf.
*          ADD <ls_commitment>-trspt_order      TO prt_lbe-bsabr.
            MODIFY prt_lbe INDEX sy-tabix.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_reservation IS NOT INITIAL.

    SORT pt_reservation BY matnr.

    LOOP AT pt_reservation ASSIGNING <ls_reservation>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_reservation>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_reservation>-bdmng TO prt_mbe-bdmng.
        ADD <ls_reservation>-bdmns TO prt_mbe-bdmns.
        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_reservation>-matnr
                                  werks = <ls_reservation>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_reservation>-bdmng TO prt_wbe-bdmng.
        ADD <ls_reservation>-bdmns TO prt_wbe-bdmns.
        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_reservation>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_reservation>-matnr
                                  bwgrp = pt_werks-bwgrp            BINARY SEARCH.

      IF sy-subrc = 0.

        ADD <ls_reservation>-bdmng TO prt_gbe-bdmng.
        ADD <ls_reservation>-bdmns TO prt_gbe-bdmns.
        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill lbe
      READ TABLE prt_lbe WITH KEY matnr = <ls_reservation>-matnr
                                  werks = <ls_reservation>-werks
                                  lgort = <ls_reservation>-lgort.

      IF sy-subrc = 0.

        ADD <ls_reservation>-bdmng TO prt_lbe-bdmng.
        ADD <ls_reservation>-bdmns TO prt_lbe-bdmns.
        MODIFY prt_lbe INDEX sy-tabix.

      ELSE.

        CLEAR ls_lbe.
        MOVE-CORRESPONDING <ls_reservation> TO ls_lbe.      "#EC ENHOK
        ls_lbe-satnr = <ls_reservation>-gen_matnr.
        INSERT ls_lbe INTO TABLE prt_lbe.

      ENDIF.


* fill item for generic article
      IF <ls_reservation> IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_reservation>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_reservation>-bdmng TO prt_mbe-bdmng.
          ADD <ls_reservation>-bdmns TO prt_mbe-bdmns.
          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_reservation>-gen_matnr
                                    werks = <ls_reservation>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_reservation>-bdmng TO prt_wbe-bdmng.
          ADD <ls_reservation>-bdmns TO prt_wbe-bdmns.
          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_reservation>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_reservation>-gen_matnr
                                    bwgrp = pt_werks-bwgrp            BINARY SEARCH.

        IF sy-subrc = 0.

          ADD <ls_reservation>-bdmng TO prt_gbe-bdmng.
          ADD <ls_reservation>-bdmns TO prt_gbe-bdmns.
          MODIFY prt_gbe INDEX sy-tabix.


        ENDIF.

* fill lbe for generic article
        READ TABLE prt_lbe WITH KEY matnr = <ls_reservation>-gen_matnr
                                    werks = <ls_reservation>-werks
                                    lgort = <ls_reservation>-lgort.

        IF sy-subrc = 0.

          ADD <ls_reservation>-bdmng TO prt_lbe-bdmng.
          ADD <ls_reservation>-bdmns TO prt_lbe-bdmns.
          MODIFY prt_lbe INDEX sy-tabix.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

  IF pt_sales_req IS NOT INITIAL.

    SORT pt_sales_req BY matnr.

    LOOP AT pt_sales_req ASSIGNING <ls_sales_req>.

*fill mbe
      READ TABLE prt_mbe WITH KEY matnr = <ls_sales_req>-matnr  BINARY SEARCH.

      IF sy-subrc = 0.

        IF <ls_sales_req>-vbtyp = 'A'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmna.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'B'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmnb.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'C'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmnc.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'E'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmne.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'G'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmng.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'I'.
          ADD <ls_sales_req>-omeng TO prt_mbe-vbmni.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'J'.
          ADD <ls_sales_req>-omeng TO prt_mbe-omeng.
        ENDIF.

        MODIFY prt_mbe INDEX sy-tabix.

      ENDIF.

* fill wbe
      READ TABLE prt_wbe WITH KEY matnr = <ls_sales_req>-matnr
                                  werks = <ls_sales_req>-werks  BINARY SEARCH.

      IF sy-subrc = 0.

        IF <ls_sales_req>-vbtyp = 'A'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmna.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'B'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmnb.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'C'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmnc.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'E'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmne.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'G'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmng.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'I'.
          ADD <ls_sales_req>-omeng TO prt_wbe-vbmni.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'J'.
          ADD <ls_sales_req>-omeng TO prt_wbe-omeng.
        ENDIF.

        MODIFY prt_wbe INDEX sy-tabix.

      ENDIF.

* fill gbe
      READ TABLE pt_werks WITH KEY werks = <ls_sales_req>-werks  BINARY SEARCH.

      READ TABLE prt_gbe WITH KEY matnr = <ls_sales_req>-matnr
                                  bwgrp = pt_werks-bwgrp         BINARY SEARCH.

      IF sy-subrc = 0.

        IF <ls_sales_req>-vbtyp = 'A'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmna.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'B'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmnb.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'C'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmnc.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'E'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmne.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'G'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmng.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'I'.
          ADD <ls_sales_req>-omeng TO prt_gbe-vbmni.
        ENDIF.

        IF <ls_sales_req>-vbtyp = 'J'.
          ADD <ls_sales_req>-omeng TO prt_gbe-omeng.
        ENDIF.

        MODIFY prt_gbe INDEX sy-tabix.

      ENDIF.

* fill item for generic article
      IF <ls_sales_order>-gen_matnr IS NOT INITIAL.

*fill mbe for generic article
        READ TABLE prt_mbe WITH KEY matnr = <ls_sales_req>-gen_matnr  BINARY SEARCH.

        IF sy-subrc = 0.

          IF <ls_sales_req>-vbtyp = 'A'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmna.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'B'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmnb.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'C'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmnc.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'E'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmne.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'G'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmng.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'I'.
            ADD <ls_sales_req>-omeng TO prt_mbe-vbmni.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'J'.
            ADD <ls_sales_req>-omeng TO prt_mbe-omeng.
          ENDIF.

          MODIFY prt_mbe INDEX sy-tabix.

        ENDIF.

* fill wbe for generic article
        READ TABLE prt_wbe WITH KEY matnr = <ls_sales_req>-gen_matnr
                                    werks = <ls_sales_req>-werks  BINARY SEARCH.

        IF sy-subrc = 0.

          IF <ls_sales_req>-vbtyp = 'A'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmna.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'B'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmnb.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'C'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmnc.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'E'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmne.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'G'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmng.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'I'.
            ADD <ls_sales_req>-omeng TO prt_wbe-vbmni.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'J'.
            ADD <ls_sales_req>-omeng TO prt_wbe-omeng.
          ENDIF.

          MODIFY prt_wbe INDEX sy-tabix.

        ENDIF.

* fill gbe for generic article
        READ TABLE pt_werks WITH KEY werks = <ls_sales_req>-werks  BINARY SEARCH.

        READ TABLE prt_gbe WITH KEY matnr = <ls_sales_req>-gen_matnr
                                    bwgrp = pt_werks-bwgrp         BINARY SEARCH.

        IF sy-subrc = 0.

          IF <ls_sales_req>-vbtyp = 'A'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmna.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'B'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmnb.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'C'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmnc.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'E'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmne.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'G'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmng.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'I'.
            ADD <ls_sales_req>-omeng TO prt_gbe-vbmni.
          ENDIF.

          IF <ls_sales_req>-vbtyp = 'J'.
            ADD <ls_sales_req>-omeng TO prt_gbe-omeng.
          ENDIF.

          MODIFY prt_gbe INDEX sy-tabix.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDFORM.                    " build_prt_tables
