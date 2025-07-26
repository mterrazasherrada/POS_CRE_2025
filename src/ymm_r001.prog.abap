************************************************************************
*  Report  RWBEST01                                                    *
*                                                                      *
*  Bestandsübersicht für Sammelmaterialien                             *
************************************************************************
*                                                                      *
*  Mit der Bestandsübersicht erhält man einen Überblick über die       *
*  Bestände eines Materials über alle wichtigen Organisationsebenen    *
*  hinweg. Die Technik der Datenbeschaffung und der Bestandsanzeige    *
*  wurde vom Report RMMMBEST übernommen und hinsichtlich den Anfor-    *
*  derungen für eine Verarbeitung von Sammelmaterialien angepaßt.      *
*                                                                      *
************************************************************************
*  WWW   Carlo Bies  12.3.98  Anpassung für Web-Reporting              *
************************************************************************

INCLUDE YMM_R001_TOP.
*INCLUDE rwbe1top.                      "global Data

INCLUDE YMM_R001_F10.
*INCLUDE rwbe1f10.                       "eventhandling

INCLUDE YMM_R001_SEL.
*INCLUDE rwbe1sel.                       " selection screen

*----------------------------------------------------------------------*
INITIALIZATION.
*----------------------------------------------------------------------*

*---- CBI/WWW: Laufzeitinfo holen
*----          Feld www_active zeigt an, ob Report im Web läuft
  CALL FUNCTION 'RS_SUBMIT_INFO'
    IMPORTING
      p_submit_info = p_submit_info.
*  p_submit_info-www_active = 'X'.    " CBI/test!!!

*---- CBI/WWW: FCodes, die im Web z.Z. nicht funktionieren
  t_fcodes_www-fcode = 'PF05'.  APPEND t_fcodes_www.
  t_fcodes_www-fcode = 'NSEL'.  APPEND t_fcodes_www.
  t_fcodes_www-fcode = 'MATX'.  APPEND t_fcodes_www.
  t_fcodes_www-fcode = 'EKVK'.  APPEND t_fcodes_www.
*TGA/4.6 Erweiterungen STRART (START)
  t_fcodes_www-fcode = 'STRU'.  APPEND t_fcodes_www.
*TGA/4.6 Erweiterungen STRART (END)

*---- Text der Basiswerksgruppe für Werke ohne Gruppenzuordnung -------*
  dummy_bwgbz = text-035.

*---- Lesen der Benutzerstammdaten, um das Zeichen für die Dar-       -*
*---- stellung des Dezimalpunktes und des 1000er-Punktes zu ermitteln -*
  PERFORM lese_benutzerstamm.

*---- Aufbau der Schablone für die Anzeige der Mengen in der Matrix ---*
  PERFORM schablone_aufbauen.

*---- Subscreen für den Kopfbereich der Matrix festlegen --------------*
  incl_bild-program = 'RWBEST01'.
  incl_bild-screen  = '0300'.

* JH/19.12.96 1.2B (Anfang)
* Wenn sowohl der SPA/GPA-Parameter der Warengruppe als auch des
* Artikels gesetzt ist, wird der Parameter der Warengrp. zurückgesetzt,
* d.h. Artikel zieht stärker als Warengruppe, um die Datenselektion
* aus Performancegründen so klein wie möglich zu halten
* Anmerkung: wenn nicht einer der beiden Parameter zurückgesetzt wird,
* muß der Anwender dies auf dem Selektionbild selber machen, weil dann
* sowohl das Feld Warengruppe als auch das Feld Artikel belegt ist, aber
* nur eins von beiden belegt sein darf! -> unschön, wenn das Selektions-
* bild eigentlich dunkel durchlaufen werden soll
  DATA: matkl_test LIKE mara-matkl,
        matnr_test LIKE mara-matnr.

* ACC_B
  DATA: l_icon_enter_more   TYPE char5,
        l_icon_display_more TYPE char5.

  l_icon_enter_more   = '@1F\Q'.
  l_icon_display_more = '@1E\Q'.
* ACC_E

  GET PARAMETER ID 'MAT' FIELD matnr_test.
  GET PARAMETER ID 'MKL' FIELD matkl_test.
  IF  ( NOT matkl_test IS INITIAL )
  AND ( NOT matnr_test IS INITIAL ).
*---- Material zurücksetzen, wenn Warengruppe auch vorgegeben wird ----*
    CLEAR matkl_test.
    SET PARAMETER ID 'MKL' FIELD matkl_test.
  ENDIF.
* JH/19.12.96 1.2B (Ende)
* parameter ID for version of overview 'X' -> ALV Tree tga 19991125
  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
    p_kzvst0 = 'X'.
  ELSE.
    DATA lc_param TYPE c.
    GET PARAMETER ID vst0 FIELD lc_param.
    IF lc_param IS NOT INITIAL.
      p_kzvst0 =  'X'.
    ELSE.
       p_kzvstc = 'X'.
       CLEAR p_kzvst0.
    ENDIF.
  ENDIF.

*ENHANCEMENT-POINT RWBE1ST01_G2 SPOTS ES_RWBEST01 .

* parameter ID for version of overview 'X' -> ALV Tree tga 19991125
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
  IF sy-dynnr EQ '1000'.  " for main dynpro, not subscreens
    SET TITLEBAR 'SEL'.

* note 584400 / wrong value when using selection variant / start
*  GET PARAMETER ID VNR FIELD P_VERNU.
*  IF P_VERNU IS INITIAL.   "kann passieren nach 'Neue Selektion' ????
*    P_VERNU = DEF_VERNU.                    "stimmt das?
*  ENDIF.
    IF p_vernu IS INITIAL.
      GET PARAMETER ID vnr FIELD p_vernu.
    ENDIF.

    SELECT * FROM t136 WHERE vernu = p_vernu.
      EXIT.
    ENDSELECT.

    IF sy-subrc NE 0.
      p_vernu = def_vernu.
    ENDIF.
* note 584400 / wrong value when using selection variant / start

*---- Icon auf dem Button Merkmale farblich verschieden darstellen ----*
*---- je nachdem, ob einschränkende Merkmalswerte hinterlegt sind  ----*
*---- oder nicht                                                   ----*
* ACC_B
    IF merkm_sel IS INITIAL.
*      button_t = icon_enter_more.
      button_t = l_icon_enter_more.                         "  '@1F@'
    ELSE.
*     button_t = icon_display_more.
      button_t = l_icon_display_more.                       "  '@1E@'
    ENDIF.
*   button_t+4 = text-006.
    button_t+5 = text-006.

    CONCATENATE button_t '@' text-006 INTO button_t.
* ACC_E

*---- Im Fehlerfall zum Zeitpunkt START-OF-SELECTION wird über die ----*
*---- Routine NEUSTART_FEHLER das Selektionsbild neu prozessiert.  ----*
*---- P_FIELD enthält das Feld wo der Cursor stehen soll           ----*
    IF NOT p_field IS INITIAL.
      SET CURSOR FIELD p_field.
      CLEAR p_field.
    ENDIF.
  ELSE.
    sel_cri =  text-108.  "tab strip text
    dis_list = text-109.  "tab strip text

* tga / accessibility
    CASE sav_ok.
      WHEN 'DIS_LIST'.
        IF sy-dynnr = 1020.
          SET CURSOR FIELD 'S_SOBKZ-LOW'.
          CLEAR sav_ok.
        ENDIF.
      WHEN 'SEL_CRI'.
        IF sy-dynnr = 1010.
          SET CURSOR FIELD 'P_LIFNR'.
          CLEAR sav_ok.
        ENDIF.
    ENDCASE.

*ENHANCEMENT-POINT EHP_AT_SEL_SCREEN_OUTPUT_01 SPOTS ES_RWBEST01.

  ENDIF.

  LOOP AT SCREEN.
    IF   screen-name   EQ 'P_KZSEA'
      OR screen-group1 EQ 'FSH'.
        screen-active = 0.
        MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_off.
    LOOP AT SCREEN.
      IF screen-name   EQ 'P_SCAT'
      OR screen-group1 EQ 'PGR'
      OR screen-group1 EQ 'G1'
      OR screen-name   EQ 'P_CHRG'
      OR screen-name   EQ 'P_KZSEG'
      OR screen-name   EQ 'P_KZCHA'
      OR screen-name   EQ 'P_KZSEA'
      OR screen-name   EQ 'P_KZALV'.
        screen-input = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    IF p_chrg IS INITIAL.
      LOOP AT SCREEN.
        IF screen-name EQ 'P_KZSEG'
        OR screen-name EQ 'P_KZCHA'
        OR screen-name EQ 'P_KZSEA'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ELSE.
      LOOP AT SCREEN.
        IF screen-name EQ 'P_KZSEG'
        OR screen-name EQ 'P_KZCHA'.
          screen-invisible = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

*ENHANCEMENT-POINT RWBE1ST01_G1 SPOTS ES_RWBEST01 .

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_matkl.
*----------------------------------------------------------------------*

*---- Manuelle F4-Hilfe für Warengruppe -------------------------------*
  PERFORM matkl_auswaehlen.

*---- Beim Aufruf der F4-Werthilfe bei Werksgruppen soll immer die ----*
*---- korrekte Klassenart vorgeblendet werden.                     ----*
*---- (SET/GET-Parameter kann durch F4-Hilfe zur Warengruppe ver-  ----*
*---- ändert werden -> zurücksetzen)                               ----*
  SET PARAMETER ID 'KAR' FIELD wkgrp_klart.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_wkgrp.
*----------------------------------------------------------------------*

*---- Manuelle F4-Hilfe für Werksgruppen ------------------------------*
  PERFORM wkgrp_auswaehlen.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_matkl.
*----------------------------------------------------------------------*

*---- Existenz der Warengruppe überprüfen und Bezeichnung zur Waren- --*
*---- gruppe lesen                                                   --*
  IF p_matkl NE matkl_alt.
    PERFORM check_matkl USING p_matkl p_matklt.
*   MATKL_ALT = P_MATKL wird erst später durchgeführt!
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_lifnr.
*----------------------------------------------------------------------*

*---- Bezeichnung zum Lieferanten lesen -------------------------------*
  IF p_lifnr NE lifnr_alt.
    PERFORM bezeichnung_lifnr_lesen USING p_lifnr p_lifnrt.
    lifnr_alt = p_lifnr.
  ENDIF.

*----------------------------------------------------------------------*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_LTSNR.
*----------------------------------------------------------------------*
*???? -> läßt sich mit der vorh. Ablauflogik nicht sauber abbilden!!!!
*---- F4-Hilfe zum Lieferantenteilsortiment -> hierzu ex. Fnk.baust.  -*
* REFRESH T_WYT1T. CLEAR T_WYT1T.              im Lief.stamm (->WY06)
*
*---- Test, ob LIFNR belegt ist ---------------------------------------*
* IF P_LIFNR IS INITIAL.
*---- Zu allen Lieferanten alle LTS vorblenden ------------------------*
*   PERFORM LIEF_LTS_ANZEIGEN.
* ELSE.
*---- Alle LTS des Lieferanten vorblenden -----------------------------*
*   PERFORM LTS_ANZEIGEN.
* ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_ltsnr.
*----------------------------------------------------------------------*

*---- Bezeichnung zum Lieferantenteilsortiment lesen ------------------*
  IF p_ltsnr NE ltsnr_alt.
    PERFORM bezeichnung_ltsnr_lesen USING p_lifnr p_ltsnr p_ltsnrt.
    ltsnr_alt = p_ltsnr.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_saiso.
*----------------------------------------------------------------------*

*---- Bezeichnung zum Saisontyp lesen ---------------------------------*
  IF p_saiso NE saiso_alt.
    PERFORM bezeichnung_saison_lesen USING p_saiso p_saisot.
    saiso_alt = p_saiso.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_plgtp.
*----------------------------------------------------------------------*

*---- Bezeichnung zum Preislagentyp lesen -----------------------------*
  IF p_plgtp NE plgtp_alt.
    PERFORM bezeichnung_plgtp_lesen USING p_plgtp p_plgtpt.
    plgtp_alt = p_plgtp.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_wkgrp.
*----------------------------------------------------------------------*

  IF p_wkgrp NE wkgrp_alt.
*---- Ermitteln der Klassenart über die die Gruppierung von Werken  ---*
*---- erfolgen soll. Falls mehrere Klassenarten vorliegen, wird ein ---*
*---- Popup zur Auswahl prozessiert                                 ---*
    PERFORM wkgrp_klart_lesen.

*---- Bezeichnung zur Werksgruppe lesen -------------------------------*
    PERFORM bezeichnung_wkgrp_lesen USING p_wkgrp p_wkgrpt.
    wkgrp_alt = p_wkgrp.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_vkorg.
*----------------------------------------------------------------------*

*---- Bezeichnung zur VKOrg lesen -------------------------------------*
  IF p_vkorg NE vkorg_alt.
    PERFORM bezeichnung_vkorg_lesen USING p_vkorg p_vkorgt.
    vkorg_alt = p_vkorg.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_vtweg.
*----------------------------------------------------------------------*

*---- Bezeichnung zum Vertriebsweg lesen ------------------------------*
  IF p_vtweg NE vtweg_alt.
    PERFORM bezeichnung_vtweg_lesen USING p_vtweg p_vtwegt.
    vtweg_alt = p_vtweg.
  ENDIF.

*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_vernu.
*----------------------------------------------------------------------*

*---- Existenz der Anzeigeversion überprüfen und Bezeichnung zur ------*
*---- Anzeigeversion lesen                                       ------*
* JH/12.03.98/4.0C (Anfang)
* IF P_VERNU NE VERNU_ALT.
  IF p_vernu NE vernu_alt
  OR p_vernu IS INITIAL.
* JH/12.03.98/4.0C (Ende)
    PERFORM check_vernu USING p_vernu p_vernut.
    vernu_alt = p_vernu.
  ENDIF.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON p_chrg.
*----------------------------------------------------------------------*
  IF   p_chrg IS INITIAL
  AND  p_scat IS NOT INITIAL.
    MESSAGE w039(SGT_01).
    p_chrg = x.
  ENDIF.

*=> OSS-Note 2488806
*=> Should be reset when we are at Classic List!
  GET PARAMETER ID 'WGEN_VAR' FIELD gv_parva.
  IF gv_parva EQ x.
    gv_tree = x.
  ENDIF.
  IF gv_tree EQ x.
    IF      p_kzvstc EQ x
    AND NOT p_chrg   IS INITIAL.
      MESSAGE w040(SGT_01).
      CLEAR p_chrg.
    ENDIF.
  ENDIF.
*=> OSS-Note 2488806
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_alvvar.
*----------------------------------------------------------------------*
* popup F4 help to select a layout
  DATA: g_exit TYPE c.
  CLEAR ls_variant.
  MOVE sy-repid TO ls_variant-report.

  CALL FUNCTION 'LVC_VARIANT_F4'
    EXPORTING
      is_variant = ls_variant
      i_save     = x_save
    IMPORTING
      e_exit     = g_exit
      es_variant = ls_variant
    EXCEPTIONS
      not_found  = 1
      OTHERS     = 2.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    IF g_exit NE 'X'.
* set name of layout on selection screen
      p_alvvar    = ls_variant-variant.
    ENDIF.
  ENDIF.
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
* tga /  batch doesn't end
  STATICS: sav_comm  LIKE sy-ucomm.

*---- Ermitteln KZ_NUR_WERKSOND ---------------------------------------*
  PERFORM sobkz_einlesen.

*---- Selektionsebenen auswerten --------------------------------------*
  PERFORM selektionsebenen.
*---- Material oder WArengruppe eingegeben? ---------------------------*
  CLEAR check_counter.
  CLEAR mat_sel.

  PERFORM check_mat_sel.
*tga/46C otherwise, back from characteristics only possible in two steps
* IF sy-ucomm = 'MERK'.                               "<<<delete
  IF ( sy-dynnr = '1010' AND sy-ucomm = 'MERK' ) OR   "<<<insert
     ( sy-dynnr = '1020' AND sy-ucomm = 'MERK' ).     "<<<insert
*---- Pushbutton 'Merkmale' wurde gedrückt -> Dynpro zur Merkmals- ----*
*---- selektion prozessieren, falls der selektierte Artikel oder   ----*
*---- die selektierte Warengruppe eine entsprechende Klassifiz.    ----*
*---- besitzen.                                                    ----*

*---- Test auf korrekte Belegung der Eingabefelder für die Mat.sel. ---*
*---- Genau eines der Felder 'Material' o. 'Warengruppe' ist belegt ---*
    IF check_counter <> 1.
      CASE mat_sel.
        WHEN matnr_belegt.
          SET CURSOR FIELD 'S_MATNR-LOW'.
        WHEN matkl_belegt.
          SET CURSOR FIELD 'P_MATKL'.
        WHEN OTHERS.
          SET CURSOR FIELD 'P_MATKL'.
      ENDCASE.
      MESSAGE e001.
*   Bitte ein Material oder eine Warengruppe eingeben!
    ENDIF.

    PERFORM select_merkmale.
  ELSE.
*---- Falls der Anwender die Eingabe der Materialselektion ändert -----*
*---- (Wechsel von Artikel auf Warengruppe oder umgekehrt) müssen -----*
*---- evtl. schon gelesene Merkmalsdaten zurückgesetzt werden.    -----*
    IF check_counter <> 1.
*---- Keine Eingabe für die Materialselektion oder sowohl Material ----*
*---- als auch Warengruppe eingegeben                              ----*
      PERFORM reset_merkmale.
      CLEAR matkl_alt.
      CLEAR satnr_alt.
    ELSE.
      IF mat_sel = matnr_belegt.
*---- Materialselektion über Material/Materialliste -------------------*
        IF s_matnr-low NE satnr_alt.
*---- Artikel hat sich geändert -> Merkmalsdaten zurücksetzen ---------*
          PERFORM reset_merkmale.
          satnr_alt = s_matnr-low.
        ENDIF.
        CLEAR matkl_alt.
      ELSE.
*---- Materialselektion über Warengruppe ------------------------------*
        IF p_matkl NE matkl_alt.
*---- Warengruppe hat sich geändert -> Merkmalsdaten zurücksetzen -----*
          PERFORM reset_merkmale.
          matkl_alt = p_matkl.
        ENDIF.
        CLEAR satnr_alt.
      ENDIF.
    ENDIF.
  ENDIF.
* tga / batch doesn't end
  IF NOT sy-ucomm IS INITIAL AND NOT sy-ucomm = 'SJOB'.
    CLEAR sav_comm.
  ENDIF.
  IF sy-ucomm = 'SJOB' OR sav_comm = 'SJOB'.
    IF NOT sy-ucomm IS INITIAL.
      sav_comm  = sy-ucomm.
    ENDIF.
*---- Test auf korrekte Belegung der Eingabefelder für die Mat.sel. ---*
*---- Genau eines der Felder 'Material' o. 'Warengruppe' ist belegt ---*
    CLEAR check_counter.
    CLEAR mat_sel.
*-check params with ALVTRee  // tga 11.11.99 start
    PERFORM check_mat_sel.

    IF check_counter <> 1.
      MESSAGE e001.
*   Bitte ein Material oder eine Warengruppe eingeben!
    ENDIF.

*---- Wenn LTS belegt, dann muß auch Lieferant belegt sein ------------
    IF  ( NOT p_ltsnr IS INITIAL ) AND
        (     p_lifnr IS INITIAL ).
      MESSAGE e060.
*   Bitte auch einen Lieferanten zum LTS eingeben
    ENDIF.

*---- Test auf korrekte Belegung de*r Eingabefelder für die Werkssel
*---- Höchstens das Feld 'Werksgruppe' oder die Felder 'VKOrg' und
*---- 'Vertriebsweg' oder das Feld 'Werk' dürfen belegt sein.
    CLEAR check_counter.
    CLEAR werk_sel.

    PERFORM check_werk_sel.

    IF check_counter > 1.
      MESSAGE e002.
    ENDIF.
* if here, everything is ok
    CLEAR sav_comm.
  ENDIF.  " sy-ucom = 'SJOB'
  IF NOT  p_kzvst0 IS INITIAL.
    PERFORM param_alv_chk.
    PERFORM layout_check.
  ENDIF.

* tga / Accessibility
  sav_ok = sy-ucomm.

*----------------------------------------------------------------------*
START-OF-SELECTION.   "= END-OF-SELECTION, weil keine log. DB verw. wird
*----------------------------------------------------------------------*

*---- Test auf korrekte Belegung der Eingabefelder für die Mat.sel. ---*
*---- Genau eines der Felder 'Material' o. 'Warengruppe' ist belegt ---*
  CLEAR check_counter.
  CLEAR mat_sel.

  PERFORM check_mat_sel.

  IF check_counter <> 1.
    CASE mat_sel.
      WHEN matnr_belegt.
        p_field = 'S_MATNR-LOW'.
      WHEN matkl_belegt.
        p_field = 'P_MATKL'.
      WHEN OTHERS.
        p_field = 'P_MATKL'.
    ENDCASE.

    MESSAGE s001.
*   Bitte ein Material oder eine Warengruppe eingeben!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Test auf korrekte Belegung der Eingabefelder Lieferant u. LTS ---*
  PERFORM check_lief_lts.

*---- Test auf korrekte Belegung der Eingabefelder für die Werkssel. --*
*---- Höchstens das Feld 'Werksgruppe' oder die Felder 'VKOrg' und   --*
*---- 'Vertriebsweg' oder das Feld 'Werk' dürfen belegt sein.        --*
  CLEAR check_counter.
  CLEAR werk_sel.

  PERFORM check_werk_sel.

  IF check_counter > 1.
    IF check_counter = 3.
*---- Fehler: Alle Werksselektionsfelder belegt -----------------------*
      p_field = 'P_WKGRP'.
    ELSE.
*---- Fehler: zwei Werksselektionsfelder belegt -----------------------*
      CASE werk_sel.
        WHEN wkgrp_belegt.
          p_field = 'P_WKGRP'.
        WHEN vkorg_belegt.
          p_field = 'P_VKORG'.
        WHEN vtrli_belegt.
          p_field = 'P_VKORG'.
        WHEN werks_belegt.
          p_field = 'S_WERKS-LOW'.
        WHEN OTHERS.
          p_field = 'P_WKGRP'.
      ENDCASE.
    ENDIF.
    MESSAGE s002.
*   Fehler bei der Einschränkung der Bestandsdaten auf Werksebene!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Falls keine Werksgruppe eingegeben wurde muß noch die Klassen- --*
*---- art ermittelt werden, über die die Gruppierung von Werken er-  --*
*---- folgen soll. Falls mehrere Klassenarten vorliegen, wird ein    --*
*---- Popup zur Auswahl prozessiert.                                 --*
  PERFORM wkgrp_klart_lesen.

*---- Liste der Werke bestimmen, die sich aufgrund der Werksselektion -*
*---- ergeben.                                                        -*
  PERFORM get_werk_liste.

*---- Liste der Materialien bestimmen, die sich aufgrund der Mat.- ----*
*---- selektion ergeben                                            ----*
  PERFORM get_mat_liste.

*---- Einlesen und Anzeigen der Bestandsdaten -------------------------*
  PERFORM bestaende_ermitteln.

*----------------------------------------------------------------------*
TOP-OF-PAGE.
*----------------------------------------------------------------------*

  CASE kz_list.
    WHEN einzel_liste.
      PERFORM seitenkopf_einzel_liste.
    WHEN ek_vk_liste.
      PERFORM seitenkopf_ek_vk_liste.
*TGA/4.6 Erweiterungen Struct.art(START)170599
    WHEN strart_liste.
      PERFORM seitenkopf_strart_liste.
*TGA/4.6 Erweiterungen Struct.art(START)170599
    WHEN OTHERS.
      PERFORM seitenkopf.
  ENDCASE.

*----------------------------------------------------------------------*
TOP-OF-PAGE DURING LINE-SELECTION.
*----------------------------------------------------------------------*
*test

  CASE kz_list.
    WHEN einzel_liste.
*---- Proforma: Fall wird eigentlich nie durchlaufen, weil in der -----*
*---- Einzelliste keine Aufrisse erzeugt werden                   -----*
      PERFORM seitenkopf_einzel_liste.
    WHEN ek_vk_liste.
*---- Proforma: Fall wird eigentlich nie durchlaufen, weil in der -----*
*---- Einzelliste keine Aufrisse erzeugt werden                   -----*
      PERFORM seitenkopf_ek_vk_liste.
*TGA/4.6 Erweiterungen Struct.art(START)170599
    WHEN strart_liste.
      PERFORM seitenkopf_strart_liste.
*TGA/4.6 Erweiterungen Struct.art(START)170599
    WHEN OTHERS.
      PERFORM seitenkopf.
  ENDCASE.

*----------------------------------------------------------------------*
* Pf-Tasten-Steuerung
*----------------------------------------------------------------------*
AT LINE-SELECTION.
*---- SY-CUCOL enthält die Spaltenposition+1, in der d. Cursor beim ---*
*---- Ausführen des Doppelklicks stand                              ---*
  IF sy-cucol < 28.
*---- Cursor steht in Bezeichnungsspalte ------------------------------*
    CASE drilldown_level.
      WHEN artlist_level.
        PERFORM aufriss_artliste.
      WHEN OTHERS.
*---- Umsetzen des Funktionscodes von 'PICK' auf 'PF10', damit An- ----*
*---- zeige von Werkssonderbeständen korrekt erfolgt               ----*
        sy-ucomm = 'PF10'.
        PERFORM e00_naechste_ebene.
    ENDCASE.
  ELSE.
*---- Cursor steht in einer der Bestandsspalten -----------------------*
    PERFORM e00_einzel_liste.
  ENDIF.

AT PF5.
  PERFORM e00_einzel_liste.

AT PF7.
  PERFORM e00_liste_rechts.

AT PF8.
  PERFORM e00_liste_links.

AT PF6.
  PERFORM e00_erstes_fenster.

AT PF9.
  PERFORM e00_letztes_fenster.

AT PF10.
  CASE drilldown_level.
    WHEN artlist_level.
      PERFORM aufriss_artliste.
    WHEN OTHERS.
      PERFORM e00_naechste_ebene.
  ENDCASE.

AT USER-COMMAND.
  PERFORM fcode_handling.

*----------------------------------------------------------------------*
* INCLUDE-Dateien                                                      *
*----------------------------------------------------------------------*
INCLUDE YMM_R001_O01.
*  INCLUDE rwbe1o01.
*INCLUDE RWBE1O01.                    " PBO-Modules

INCLUDE YMM_R001_F01.
*  INCLUDE rwbe1f01.
*INCLUDE RWBE1F01.                    " FORM-Routines

INCLUDE YMM_R001_F02.
*  INCLUDE rwbe1f02.
*INCLUDE RWBE1F02.

INCLUDE YMM_R001_F03.
*  INCLUDE rwbe1f03.
*INCLUDE RWBE1F03.

INCLUDE YMM_R001_F04.
*  INCLUDE rwbe1f04.
*INCLUDE RWBE1F04.

INCLUDE YMM_R001_F05.
*  INCLUDE rwbe1f05.
*INCLUDE RWBE1F05.

INCLUDE YMM_R001_F06.
*  INCLUDE rwbe1f06.
*INCLUDE RWBE1F06.

INCLUDE YMM_R001_F07.
*  INCLUDE rwbe1f07.
*INCLUDE RWBE1F07.

INCLUDE YMM_R001_F08.
*  INCLUDE rwbe1f08.
*INCLUDE RWBE1F08.

INCLUDE YMM_R001_F09.
*  INCLUDE rwbe1f09.

*INCLUDE RWBE1F10.

INCLUDE YMM_R001_F12.
*  INCLUDE rwbe1f12.

INCLUDE YMM_R001_F11.
*INCLUDE RWBE1F11.
