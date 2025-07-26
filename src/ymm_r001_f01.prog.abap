*-------------------------------------------------------------------
***INCLUDE RWBE1F01 .
*  Hilfsroutinen zur Bearbeitung des Selektionsbildschirms
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_WKGRP_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für die Werksgruppe                      *
*----------------------------------------------------------------------*
*  -->  PI_WKGRP  Werksgruppe
*  <--  PE_WKGRPT Bezeichnung d. Werksgruppe
*----------------------------------------------------------------------*
FORM bezeichnung_wkgrp_lesen USING pi_wkgrp  TYPE wkgrh    "tga unicode
                                   pe_wkgrpt TYPE ANY.  " tga unicode

  CALL FUNCTION 'CLMA_CLASS_READ_INTERNAL'
       EXPORTING
            classname       = pi_wkgrp
            classtype       = wkgrp_klart
            language        = sy-langu
       IMPORTING
            classnumber     = wkgrp_clint
            description     = wkgrp_bez
       EXCEPTIONS
            class_not_found = 01.      " LANGUAGE =

  IF sy-subrc EQ 0.
    pe_wkgrpt = wkgrp_bez.
  ELSE.
    pe_wkgrpt = space.
    CLEAR wkgrp_clint.
  ENDIF.

ENDFORM.                               " BEZEICHNUNG_WKGRP_LESEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_VKORG_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für die VKOrg
*----------------------------------------------------------------------*
*  -->  PI_VKORG  VKOrg
*  <--  PE_VKORGT Bezeichnung d. VKOrg
*----------------------------------------------------------------------*
FORM bezeichnung_vkorg_lesen USING pi_vkorg  TYPE vkorg  "tga unicode
                                   pe_vkorgt TYPE any.   "tga unicode

  SELECT SINGLE * FROM tvkot WHERE spras EQ sy-langu
                             AND   vkorg EQ pi_vkorg.
  IF sy-subrc EQ 0.
    pe_vkorgt = tvkot-vtext.
  ELSE.
    pe_vkorgt = space.
  ENDIF.

ENDFORM.                               " BEZEICHNUNG_VKORG_LESEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_VTWEG_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für den Vertriebsweg
*----------------------------------------------------------------------*
*  -->  PI_VTWEG  Vertriebsweg
*  <--  PE_VTWEGT Bezeichnung d. Vertriebsweges
*----------------------------------------------------------------------*
FORM bezeichnung_vtweg_lesen USING pi_vtweg  TYPE VTWKU " tga unicode
                                   pe_vtwegt TYPE ANY.  " tga unicode

  SELECT SINGLE * FROM tvtwt WHERE spras EQ sy-langu
                             AND   vtweg EQ pi_vtweg.
  IF sy-subrc EQ 0.
    pe_vtwegt = tvtwt-vtext.
  ELSE.
    pe_vtwegt = space.
  ENDIF.

ENDFORM.                               " BEZEICHNUNG_VTWEG_LESEN

*&---------------------------------------------------------------------*
*&      Form  CHECK_MATKL
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für die Warengruppe                      *
*----------------------------------------------------------------------*
*  -->  PI_MATKL  Warengruppe
*  <--  PE_MATKLT Bezeichnung d. Warengruppe
*----------------------------------------------------------------------*
FORM check_matkl USING pi_matkl  TYPE wagrh  "tga unicode
                       pe_matklt TYPE ANY.   "tga unicode

  IF NOT pi_matkl IS INITIAL.
*---- Bezeichnung über Klassifikation ermitteln, da es sich bei der ---*
*---- Warengruppe um eine Basiswarengruppe oder eine Warengruppen-  ---*
*---- hierarchiestufe handeln kann.                                 ---*
    SELECT * FROM  klah
      WHERE  klart       = wghier_klart
        AND  class       = pi_matkl
        AND (   wwskz    = '0'         "nur WG-Hierarchiestufen
             OR wwskz    = '1' ).      "oder Basiswarengruppen
                                       "keine Merkmalsprofile (= '2')
      EXIT.
    ENDSELECT.

    IF sy-subrc NE 0.
      MESSAGE e016 WITH pi_matkl.
*    Die Warengruppe & ist nicht bekannt!
    ENDIF.

*---- Klassenbezeichung (1. Schlagwort) ermitteln ---------------------*
    SELECT SINGLE * FROM swor
      WHERE clint = klah-clint
      AND   spras = sy-langu
      AND   klpos = 1.

    IF sy-subrc EQ 0.
      pe_matklt = swor-kschl.
    ELSE.
      pe_matklt = space.
    ENDIF.
  ELSE.
    pe_matklt = space.
  ENDIF.

ENDFORM.                               " CHECK_MATKL

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_LIFNR_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für den Lieferanten                      *
*----------------------------------------------------------------------*
*  -->  PI_LIFNR  Lieferant
*  <--  PE_LIFNRT Bezeichnung d. Lieferanten
*----------------------------------------------------------------------*
FORM bezeichnung_lifnr_lesen USING pi_lifnr  TYPE lifnr  "tga unicode
                                   pe_lifnrt TYPE ANY.   "tga unicode

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering a correction
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL.
    DATA:
      ls_lfa1 TYPE lfa1.

    IF NOT pi_lifnr IS INITIAL.
      CALL FUNCTION 'LFA1_SINGLE_READ'
        EXPORTING
          lfa1_lifnr = pi_lifnr
        IMPORTING
          wlfa1      = ls_lfa1
        EXCEPTIONS
          OTHERS     = 1.
      IF NOT sy-subrc IS INITIAL.
        pe_lifnrt = space.
      ELSEIF ls_lfa1-cvp_xblck EQ abap_true.
        pe_lifnrt = space.
        MESSAGE e015(cvp_dp_ilm) WITH pi_lifnr.
      ELSE.
        pe_lifnrt = ls_lfa1-name1.
      ENDIF.
    ELSE.
      pe_lifnrt = space.
    ENDIF.
  ELSE.
** end_EoP_adaptation
    SELECT SINGLE * FROM lfa1 WHERE lifnr = pi_lifnr.
    IF sy-subrc EQ 0.
      pe_lifnrt = lfa1-name1.
    ELSE.
      pe_lifnrt = space.
    ENDIF.
  ENDIF.

ENDFORM.                               " BEZEICHNUNG_LIFNR_LESEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_LTSNR_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für das Lieferantenteilsortiment         *
*----------------------------------------------------------------------*
*  -->  PI_LIFNR  Lieferant
*       PI_LTSNR  Lieferantenteilsortiment
*  <--  PE_LTSNRT Bezeichnung d. Lieferantenteilsortiments
*----------------------------------------------------------------------*
FORM bezeichnung_ltsnr_lesen USING pi_lifnr  TYPE lifnr "tga unicode
                                   pi_ltsnr  TYPE ltsnr "tga unicode
                                   pe_ltsnrt TYPE ANY.  "tga unicode

  SELECT SINGLE * FROM wyt1t WHERE spras = sy-langu
                               AND lifnr = pi_lifnr
                               AND ltsnr = pi_ltsnr.
  IF sy-subrc EQ 0.
    pe_ltsnrt = wyt1t-ltsbz.
  ELSE.
    pe_ltsnrt = space.
  ENDIF.

ENDFORM.                               " BEZEICHNUNG_LTSNR_LESEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_PLGTP_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für den Preislagentyp                    *
*----------------------------------------------------------------------*
*  -->  PI_PLGTP  Preislagentyp
*  <--  PE_PLGTPT Bezeichnung d. Preislagentyps
*----------------------------------------------------------------------*
FORM bezeichnung_plgtp_lesen USING pi_plgtp  TYPE PLGTP " tga unicode
                                   pe_plgtpt TYPE ANY.  " tga unicode

  SELECT SINGLE * FROM twptt WHERE spras EQ sy-langu
                             AND   plgtp EQ pi_plgtp.
  IF sy-subrc EQ 0.
    pe_plgtpt = twptt-vtext.
  ELSE.
    pe_plgtpt = space.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_SAISON_LESEN
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für die Saison                           *
*----------------------------------------------------------------------*
*  -->  PI_SAISO  Saison
*  <--  PE_SAISOT Bezeichnung d. Saison
*----------------------------------------------------------------------*
FORM bezeichnung_saison_lesen USING pi_saiso  TYPE saiso " tga unicode
                                    pe_saisot TYPE ANY.  " tga unicode

  SELECT SINGLE * FROM t6wst WHERE spras EQ sy-langu
                             AND   saiso EQ pi_saiso.
  IF sy-subrc EQ 0.
    pe_saisot = t6wst-vtext.
  ELSE.
    pe_saisot = space.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CHECK_VERNU
*&---------------------------------------------------------------------*
*       Lesen der Bezeichnung für die Anzeigeversion
*----------------------------------------------------------------------*
*  -->  PI_VERNU  Anzeigeversion
*  <--  PE_VERNUT Bezeichnung d. Anzeigeversion
*----------------------------------------------------------------------*
FORM check_vernu USING pi_vernu  TYPE vernu "tga unicode
                       pe_vernut TYPE ANY.  "tga unicode

*---- Prüfen der Anzeigeversion ---------------------------------------*
*---- Existenztest erfolgt nicht über Tabelle T136A, wo die möglichen -*
*---- Anzeigeversionen abgelegt sind, sondern über Tabelle T136, wo   -*
*---- das Layout der (tatsächlichen) Anzeigeversion hinterlegt ist    -*
  SELECT * FROM t136
         WHERE vernu = pi_vernu.
*---- Version existiert, falls mind. 1 Eintrag zur Anzeigeversion -----*
*---- gefunden wird                                               -----*
    EXIT.
  ENDSELECT.

  IF sy-subrc NE 0.
    MESSAGE e009 WITH pi_vernu.
*    Für die Anzeigeversion & ist kein Listenlayout hinterlegt!
  ELSE.
    rmmmb-vernu = t136-vernu.
    SELECT SINGLE * FROM t136t WHERE spras EQ sy-langu
                               AND   vernu EQ pi_vernu.
    IF sy-subrc EQ 0.
      pe_vernut = t136t-verbz.
    ELSE.
      pe_vernut = space.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHECK_VERNU

*&---------------------------------------------------------------------*
*&      Form  CHECK_MAT_SEL
*&---------------------------------------------------------------------*
*       Überprüfen, ob entweder ein Material oder eine Warengruppe     *
*       eingegeben wurde.                                              *
*----------------------------------------------------------------------*
FORM check_mat_sel.
  IF NOT p_matkl IS INITIAL.
    ADD 1 TO check_counter.
    mat_sel = matkl_belegt.
  ENDIF.
  IF NOT s_matnr IS INITIAL.
    ADD 1 TO check_counter.
    mat_sel = matnr_belegt.
  ENDIF.

ENDFORM.                               " CHECK_MAT_SEL

*&---------------------------------------------------------------------*
*&      Form  CHECK_WERK_SEL
*&---------------------------------------------------------------------*
*       Prüfen, ob eine der zulässigen Werkselektionen vorliegt.       *
*       Einschränkungen hinsichtlich der Bestandsdaten auf Werksebene  *
*       sind nur für eine der drei nachfolg. Hierarchiestufen mögl.:   *
*       -  Werksgruppe                                                 *
*       -  VKOrganisation (evtl. in Verbindung mit Vertriebsweg)       *
*       -  Werk                                                        *
*----------------------------------------------------------------------*
FORM check_werk_sel.
  IF NOT p_wkgrp IS INITIAL.
    ADD 1 TO check_counter.
    werk_sel = wkgrp_belegt.
  ENDIF.
  IF NOT s_werks IS INITIAL.
    ADD 1 TO check_counter.
    werk_sel = werks_belegt.
  ENDIF.
  IF NOT p_vkorg IS INITIAL.
    ADD 1 TO check_counter.
    IF NOT p_vtweg IS INITIAL.
*---- VKOrg und Vertr.weg belegt --------------------------------------*
      werk_sel = vtrli_belegt.
    ELSE.
*---- VKOrg ohne Vertr.weg belegt -------------------------------------*
      werk_sel = vkorg_belegt.
    ENDIF.
  ELSE.
*---- Fehlerfälle: Vertr.weg ohne VKOrg belegt ------------------------*
    IF NOT p_vtweg IS INITIAL.
      IF check_counter = 0.
*---- Vertr.weg ohne VKOrg belegt und keine Werksselektion ------------*
        p_field = 'P_VTWEG'.
        MESSAGE s003.
*    Selektion eines Vertriebsweges nur in Verbindung mit VKOrg erlaubt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
        PERFORM neustart_fehler.
      ELSE.
*---- Vertr.weg ohne VKOrg belegt und weitere Werksselektion ----------*
        ADD 1 TO check_counter.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHECK_WERK_SEL

*&---------------------------------------------------------------------*
*&      Form  CHECK_LIEF_LTS
*&---------------------------------------------------------------------*
*       Prüfen, ob eine Korrekte Belegung des Lieferanten und des LTS
*       vorliegt
*----------------------------------------------------------------------*
FORM check_lief_lts.

*---- Wenn LTS belegt, dann muß auch Lieferant belegt sein ------------*
  IF  ( NOT p_ltsnr IS INITIAL )
  AND (     p_lifnr IS INITIAL ).
    p_field = 'P_LIFNR'.
    MESSAGE s060.
*   Bitte auch einen Lieferanten zum LTS eingeben
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Lieferant vorhanden und korrekt? --------------------------------*
  IF NOT p_lifnr IS INITIAL.
** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering a correction
    IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL.
      DATA:
        ls_lfa1 TYPE lfa1.

      CALL FUNCTION 'LFA1_SINGLE_READ'
        EXPORTING
          lfa1_lifnr = p_lifnr
        IMPORTING
          wlfa1      = ls_lfa1
        EXCEPTIONS
          OTHERS     = 1.
      IF NOT sy-subrc IS INITIAL.
        p_field = 'P_LIFNR'.
        MESSAGE s064 WITH p_lifnr.
*       Der Lieferant & ist nicht bekannt
*  ---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*  ---- daten gehen verloren)
        PERFORM neustart_fehler.
      ELSEIF ls_lfa1-cvp_xblck EQ abap_true.
        p_field = 'P_LIFNR'.
        MESSAGE s015(cvp_dp_ilm) WITH p_lifnr.
*       Vendor &1 is blocked; see long text
*  ---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*  ---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
    ELSE.
** end_EoP_adaptation
      SELECT SINGLE * FROM lfa1
             WHERE  lifnr = p_lifnr.
      IF  sy-subrc NE 0.
        p_field = 'P_LIFNR'.
        MESSAGE s064 WITH p_lifnr.
*      Der Lieferant & ist nicht bekannt
*  ---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*  ---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
    ENDIF.
  ENDIF.

*---- LTS zum Lieferanten vorhanden und korrekt? ----------------------*
  IF NOT p_ltsnr IS INITIAL.
    SELECT SINGLE * FROM wyt1
           WHERE  lifnr = p_lifnr
           AND    ltsnr = p_ltsnr.
    IF sy-subrc NE 0.
      p_field = 'P_LTSNR'.
      MESSAGE s065 WITH p_ltsnr p_lifnr.
*    Das LTS & zum Lieferanten & ist nicht vorhanden
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHECK_LIEF_LTS

*&---------------------------------------------------------------------*
*&      Form  GET_WERK_LISTE
*&---------------------------------------------------------------------*
*       Bestimmt die Werke, die aufgrund der Selektionskriterien er-   *
*       mittelt werden können.                                         *
*----------------------------------------------------------------------*
FORM get_werk_liste.

  REFRESH: t_bwgrp, t_werks.
  CLEAR:   t_bwgrp, t_werks.

*---- Dummy-Werksgruppe für Werke ohne Gruppenzuordnung aufnehmen -----*
  t_bwgrp-bwgrp = dummy_bwgrp.
  t_bwgrp-bwgbz = dummy_bwgbz.
  APPEND t_bwgrp.

*---- Abh. von der Art der Werksselektion, Liste der Werke erstellen --*
  CASE werk_sel.
    WHEN wkgrp_belegt.
*---- Zusammenstellen der Werke über die Werksgruppe ------------------*
      PERFORM werke_zur_werksgruppe.

    WHEN vkorg_belegt.
*---- Zusammenstellen der Werke über die VK-Organisation --------------*
      PERFORM werke_zur_vkorg.

    WHEN vtrli_belegt.
*---- Zusammenstellen der Werke über die Vertriebslinie ---------------*
      PERFORM werke_zur_vertrlinie.

    WHEN werks_belegt.
*---- Zusammenstellen der Werke über die Einzelwerkselektion ----------*
      PERFORM werke_zur_werkssel.

    WHEN OTHERS.
*---- Keine Einschränkung bzgl. Werk getroffen
  ENDCASE.

ENDFORM.                               " GET_WERK_LISTE

*&---------------------------------------------------------------------*
*&      Form  WERKE_ZUR_WERKSGRUPPE
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen Werksgruppe die Basiswerksgruppen und *
*       die zugehörenden Einzelwerke                                  *
*----------------------------------------------------------------------*
FORM werke_zur_werksgruppe.

*---- Ermittle die Basiswerksgruppen und die Werke zur Werksgruppe ----*
  CALL FUNCTION 'MGW4_BREAKDOWN_PLANT_HIERARCHY'
       EXPORTING
            im_wkgrp              = p_wkgrp
            im_klart              = wkgrp_klart
            im_wkgki              = wkgrp_clint
       IMPORTING
            ex_wgbez              = wkgrp_bez
       TABLES
            ex_bas_wkgrp          = t_bwgrp
            ex_werk_list          = t_werks
       EXCEPTIONS
            wkgrp_existiert_nicht = 1
            keine_werke_vorhanden = 2
            OTHERS                = 3.

  CASE sy-subrc.
    WHEN 0.
      IF p_wkgrpt IS INITIAL.
        p_wkgrpt = wkgrp_bez.
      ENDIF.
    WHEN 1.
      p_field = 'P_WKGRP'.
      MESSAGE s005 WITH p_wkgrp.
*    Die Werksgruppe & ist nicht bekannt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    WHEN 2.
      p_field = 'P_WKGRP'.
      MESSAGE s053 WITH p_wkgrp.
*    Keine Werke zur Werksgruppe & vorhanden
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
  ENDCASE.

ENDFORM.                               " WERKE_ZUR_WERKSGRUPPE

*&---------------------------------------------------------------------*
*&      Form  WERKE_ZUR_VKORG
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen VK-Organisation die betroffenen Werke
*       d.h. alle Werke, die über diese VKO beliefert werden
*----------------------------------------------------------------------*
FORM werke_zur_vkorg.

* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
  DATA: hknvv  LIKE knvv  OCCURS 0 WITH HEADER LINE.
  DATA: ht001w LIKE t001w OCCURS 0 WITH HEADER LINE.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

*---- Test, ob die VK-Organisation in den Stammdaten vorhanden ist ----*
  SELECT SINGLE * FROM  tvko
         WHERE  vkorg = p_vkorg.

  IF sy-subrc NE 0.
    p_field = 'P_VKORG'.
    MESSAGE s006 WITH p_vkorg.
*   Die Verkaufsorganisation & ist nicht bekannt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Liste der Werke ermitteln ---------------------------------------*
*#jhl 16.07.96 Fehler beim Lesen der Zuordnungen -> TVKWZ enthält die
* Vertriebslinien, über die ein Werk ausliefern kann!
* SELECT * FROM  TVKWZ
*   WHERE  VKORG = P_VKORG.
*
*   MOVE TVKWZ-WERKS TO H_WERKS-WERKS.
*   APPEND H_WERKS.
* ENDSELECT.
* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
* Bei rein numerischen Werksnummern werden für KNVV-KUNNR führende
* Nullen erzeugt, so daß bei einem MOVE die letzten wichtigen Stellen
* verlorengehen
* SELECT * FROM  KNVV
*   WHERE  VKORG = P_VKORG.
*
*   MOVE KNVV-KUNNR TO T_WERKS-WERKS.
*   APPEND T_WERKS.    "Werkzusatzdaten werden später ermittelt!
* ENDSELECT.
  SELECT * FROM knvv INTO TABLE hknvv "#EC CI_NOFIRST
    WHERE  vkorg = p_vkorg.

  IF sy-subrc = 0.
    SELECT * FROM t001w INTO TABLE ht001w
                        FOR ALL ENTRIES IN hknvv
                        WHERE kunnr = hknvv-kunnr.
  ENDIF.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

*---- Da nur über die VKOrg selektiert wurde, kann ein Werk mehrfach --*
*---- in der Liste vorkommen, falls für das Werk mehrere Vertr.wege  --*
*---- vorgesehen sind -> Duplikate müssen nicht explizit entfernt    --*
*---- werden, da das nachfolgende SELECT mit FOR ALL ENTRIES diese   --*
*---- automatisch bei der Ermittlung der Zusatzdaten wegoptimiert.   --*
  IF sy-subrc NE 0.
    p_field = 'P_VKORG'.
    MESSAGE s007 WITH p_vkorg.
*    Zur VK-Organisation & existieren keine Werkszuordnungen!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
  SORT ht001w BY werks.
  LOOP AT ht001w.
    t_werks-werks = ht001w-werks.
    APPEND t_werks.  "Werkzusatzdaten werden später ermittelt!
  ENDLOOP.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

ENDFORM.                               " WERKE_ZUR_VKORG

*&---------------------------------------------------------------------*
*&      Form  WERKE_ZUR_VERTRLINIE
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen Vertriebslinie die betroffenen Werke
*       d.h. alle Werke, die über diese Vertriebslinie beliefert werden
*----------------------------------------------------------------------*
FORM werke_zur_vertrlinie.

* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
  DATA: hknvv  LIKE knvv  OCCURS 0 WITH HEADER LINE.
  DATA: ht001w LIKE t001w OCCURS 0 WITH HEADER LINE.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

*---- Liste der Werke ermitteln ---------------------------------------*
*#jhl 16.07.96 Fehler beim Lesen der Zuordnungen -> TVKWZ enthält die
* Vertriebslinien, über die ein Werk ausliefern kann!           ????
* SELECT * FROM  TVKWZ
*   WHERE  VKORG = P_VKORG
*     AND  VTWEG = P_VTWEG.
*
*   MOVE TVKWZ-WERKS TO H_WERKS-WERKS.
*   APPEND H_WERKS.
* ENDSELECT.

*---- Test, ob die Kombination aus VK-Organisation und Vertriebsweg ---*
*---- in den Stammdaten vorhanden ist.                              ---*
*---- Evtl. wird die Vertriebslinie auf eine Referenzvertriebslinie ---*
*---- gemapped, um die Pflege der Kundendaten nur einmal machen zu  ---*
*---- müssen.                                                       ---*
  SELECT SINGLE * FROM  tvkov
         WHERE  vkorg = p_vkorg
           AND  vtweg = p_vtweg.

  IF sy-subrc NE 0.
    p_field = 'P_VKORG'.
    MESSAGE s024 WITH p_vkorg p_vtweg.
*    Die Vertriebslinie &, & ist nicht bekannt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
* Bei rein numerischen Werksnummern werden für KNVV-KUNNR führende
* Nullen erzeugt, so daß bei einem MOVE die letzten wichtigen Stellen
* verlorengehen
* SELECT * FROM  KNVV
*   WHERE  VKORG = P_VKORG
*     AND  VTWEG = TVKOV-VTWKU.
*
*   MOVE KNVV-KUNNR TO T_WERKS-WERKS.
*   APPEND T_WERKS.      "Werkzusatzdaten werden später ermittelt!
* ENDSELECT.
  SELECT * FROM knvv INTO TABLE hknvv "#EC CI_NOFIRST
    WHERE  vkorg = p_vkorg
      AND  vtweg = tvkov-vtwku.

  IF sy-subrc = 0.
    SELECT * FROM t001w INTO TABLE ht001w
                        FOR ALL ENTRIES IN hknvv
                        WHERE kunnr = hknvv-kunnr.
  ENDIF.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

  IF sy-subrc NE 0.
    p_field = 'P_VKORG'.
    MESSAGE s010 WITH p_vkorg p_vtweg.
*    Zur Vertriebslinie &, & existieren keine Werkszuordnungen!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

* JH/1.2B2/05.08.97/KPr100064514 (Anfang)
  SORT ht001w BY werks.
  LOOP AT ht001w.
    t_werks-werks = ht001w-werks.
    APPEND t_werks.  "Werkzusatzdaten werden später ermittelt!
  ENDLOOP.
* JH/1.2B2/05.08.97/KPr100064514 (Ende)

ENDFORM.                               " WERKE_ZUR_VERTRLINIE

*&---------------------------------------------------------------------*
*&      Form  WERKE_ZUR_WERKSSEL
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen Werksselektion die betroffenen Werke   *
*----------------------------------------------------------------------*
FORM werke_zur_werkssel.

  SELECT * FROM  t001w
    WHERE  werks IN s_werks.

    MOVE t001w-werks TO t_werks-werks.
    MOVE t001w-name1 TO t_werks-wrkbz.
    MOVE t001w-vlfkz TO t_werks-vlfkz.

*---- Zum Werk die Basiswerksgruppe bestimmen -------------------------*
*JH/17.08.98/4.5B/KPr1557931 (Anfang)
*   PERFORM BWGRP_ZUM_WERK.
    PERFORM bwgrp_zum_werk USING t001w-kunnr.
*JH/17.08.98/4.5B/KPr1557931 (Ende)

    APPEND t_werks.
  ENDSELECT.

  IF sy-subrc NE 0.
    p_field = 'S_WERKS-LOW'.
    MESSAGE s066.
*   Zur angegebenen Werksselektion konnten keine Werke gefunden werden
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Normalerweise ist die Tabelle sortiert, trotzdem auf Nummer -----*
*---- sicher gehen                                                -----*
  SORT t_werks BY werks.

ENDFORM.                               " WERKE_ZUR_WERKSSEL

*&---------------------------------------------------------------------*
*&      Form  WERK_ZUSATZDATEN
*&---------------------------------------------------------------------*
*       Lesen von Zusatzdaten zu einer Liste von Werken und Ablegen    *
*       der Werksinformation in der internen Werkstabelle              *
*----------------------------------------------------------------------*
*  -->  T_WLIST   Liste von Werksidentifikatoren
*----------------------------------------------------------------------*
FORM werk_zusatzdaten TABLES t_wlist STRUCTURE h_werks.

  REFRESH  t_werks.   "Bereits eingetragene Werke löschen (Tabelle schon
  CLEAR    t_werks.   "belegt, falls Werksselektion eingegeben wurde)
  REFRESH: t_t001w, t_t001k, t_t001.
  CLEAR:   t_t001w, t_t001k, t_t001.

*---- Werkstammdaten bestimmen ----------------------------------------*
  PERFORM lesen_t001w TABLES t_wlist.
*---- Bewertungskreisdaten bestimmen ----------------------------------*
  PERFORM lesen_t001k.
*---- Buchungskreisdaten bestimmen ------------------------------------*
  PERFORM lesen_t001.

*---- Werkzusatzdaten zusammenstellen und ablegen ---------------------*
*//JH 25.09.96 (Anfang) IntPr 211229
* Sicherstellen, daß bei gelöschten Werken, die Dateninkonsistenz
* festgestellt wird
* LOOP AT T_T001W.
  LOOP AT t_wlist.
*---- Test, daß zu allen übergebenen Werken ein entsprechender Stamm-
*---- satz gelesen werden konnte
    READ TABLE t_t001w WITH KEY werks = t_wlist-werks BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_T001W'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
*//JH 25.09.96 (Ende) IntPr 211229

    MOVE t_t001w-werks TO t_werks-werks.
    MOVE t_t001w-name1 TO t_werks-wrkbz.
    MOVE t_t001w-vlfkz TO t_werks-vlfkz.
*---- Zum Werk die Basiswerksgruppe bestimmen -------------------------*
*JH/17.08.98/4.5B/KPr1557931 (Anfang)
*   PERFORM BWGRP_ZUM_WERK.
    PERFORM bwgrp_zum_werk USING t_t001w-kunnr.
*JH/17.08.98/4.5B/KPr1557931 (Ende)
*---- Währung des Werkes bestimmen ------------------------------------*
    READ TABLE t_t001k WITH KEY bwkey = t_t001w-werks BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_T001K'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
    READ TABLE t_t001 WITH KEY bukrs = t_t001k-bukrs BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_T001'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
    MOVE t_t001-waers TO t_werks-waers.
    APPEND t_werks.
  ENDLOOP.

*---- Normalerweise ist die Tabelle sortiert, trotzdem auf Nummer -----*
*---- sicher gehen                                                -----*
  SORT t_werks BY werks.

ENDFORM.                               " WERK_ZUSATZDATEN

*&---------------------------------------------------------------------*
*&      Form  GET_MAT_LISTE
*&---------------------------------------------------------------------*
*       Bestimmt die Materialien, die aufgrund der Selektionskriterien *
*       ermittelt werden können.                                       *
*----------------------------------------------------------------------*
FORM get_mat_liste.

  REFRESH: t_mara, t_matnr.
  CLEAR:   t_mara, t_matnr.

*---- Filter-Rangetabellen für Material-Select belegen ----------------*
  PERFORM fuelle_range_tabs.

*---- Abh. von der Art der Materialselektion Liste der Materialien ----*
*---- erstellen.                                                   ----*
  CASE mat_sel.
    WHEN matnr_belegt.
*---- Zusammenstellen der Materialien über die Materialselektion ------*
*---- unter Berücksichtigung der Filterwerte                     ------*
      PERFORM mat_zur_matsel.

    WHEN matkl_belegt.
*---- Zusammenstellen der Materialien über die Warengruppe unter ------*
*---- Berücksichtigung der Filterwerte                           ------*
      PERFORM mat_zur_warengruppe.

    WHEN OTHERS.
*---- Keine Einschränkung bzgl. Material getroffen -> nicht möglich ---*
      p_field = 'P_MATKL'.
      MESSAGE s001.
*    Entweder ein Material oder eine Warengruppe eingeben!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
  ENDCASE.

*---- Evtl. erfolgt noch zusätzlich eine Einschränkung bzgl. Lief.   --*
*---- oder LTS -> alle nicht vom Lieferanten gelieferten Materialien --*
*---- aus der Materialselektionsliste entfernen                      --*
  IF NOT p_lifnr IS INITIAL.
    PERFORM lese_ek_info.
    PERFORM mat_entfernen.
  ENDIF.

*---- Ist die Liste der Materialen noch handhabbar? -------------------*
  IF NOT mat_sel IS INITIAL.
    DESCRIBE TABLE t_matnr LINES anz_sel_mat.

    IF anz_sel_mat = 0.
      p_field = 'P_MATKL'.
      MESSAGE s011.
*   Zur angegebenen Materialselekt. konnten keine Materialien gefunden w
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.

    IF anz_sel_mat > max_anz_mat.
      mess_text    = text-064.
      anz_mat_char = anz_sel_mat.
      SHIFT anz_mat_char RIGHT DELETING TRAILING space.
      REPLACE '&' WITH anz_mat_char INTO mess_text.

      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
                defaultoption = 'N'
                titel         = text-063
                textline1     = mess_text
                textline2     = text-065
           IMPORTING
                answer        = popup_answer.

      IF popup_answer <> 'J'.
*---- Selektionsbild neu prozessieren, um dem Benutzer die Mögl.keit --*
*---- zu geben eine Korrektur seiner Eingabe vorzunehmen             --*
        p_field = 'P_MATKL'.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " GET_MAT_LISTE

*&---------------------------------------------------------------------*
*&      Form  MAT_ZUR_MATSEL
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen Mat.selektion die betroffenen Mat.     *
*       unter Berücksichtigung der Filterwerte für die Materialien     *
*----------------------------------------------------------------------*
FORM mat_zur_matsel.

  SELECT * FROM  mara INTO TABLE t_mara
    WHERE  matnr IN s_matnr
      AND  saiso IN r_saiso
      AND  saisj IN r_saisj
      AND  plgtp IN r_plgtp
      AND  attyp IN r_attyp.

  IF sy-subrc NE 0.
    p_field = 'S_MATNR-LOW'.
    MESSAGE s011.
*   Zur angegebenen Materialselekt. konnten keine Materialien gefunden w
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.
ENHANCEMENT-POINT RWBEST01_012 SPOTS ES_RWBEST01 .

  LOOP AT t_mara.
*TGA/4.6 Erweiterungen Lot (START)
*    PERFORM MAT_EINFUEGEN USING T_MARA.
    PERFORM mat_einfuegen TABLES t_matnr
                          using t_mara.
*TGA/4.6 Erweiterungen Lot (END)
  ENDLOOP.
ENDFORM.                               " MAT_ZUR_MATSEL

*&---------------------------------------------------------------------*
*&      Form  MAT_ZUR_WARENGRUPPE
*&---------------------------------------------------------------------*
*       Ermittelt zur gegebenen Warengruppe die betroffenen Materalien *
*       unter Berücksichtigung der Filterwerte für die Materialien     *
*----------------------------------------------------------------------*
FORM mat_zur_warengruppe.

  DATA: BEGIN OF x_wghier OCCURS 0.    "Struktur der Warengruppenhier.
          INCLUDE STRUCTURE ghcl.
  DATA: END OF x_wghier.

  DATA: BEGIN OF x_index OCCURS 0,  "Dummy (nur für Funktionbaust.-Call)
          index        LIKE sy-tabix,  "Index
          ugkla(1)     TYPE c,         "KZ untergeordnete Klasse
        END   OF x_index.

  DATA: BEGIN OF x_matkl OCCURS 0,
          matkl LIKE t023-matkl,
        END   OF x_matkl.

* JH/20.03.98/4.0C  Optimierung wg. Ersetzung von FB
* CTMS_STRUCTURE_CLASSES durch CLHI_STRUCTURE_CLASSES
  DATA: x_klah LIKE klah OCCURS 0 WITH HEADER LINE.

  DATA: anz_wghier LIKE sy-tabix.

*---- Alle untergeordneten Warengruppenhierarchiestufen ermitteln -----*
* Neuer Aufruf über CLHI_... Baustein PK/40C. 18.03.98
  CALL FUNCTION 'CLHI_STRUCTURE_CLASSES'
       EXPORTING
            i_klart              = wghier_klart
            i_class              = p_matkl
            i_bup                = ' '
            i_tdwn               = 'X'
            i_batch              = 'X'
*         I_OBJECT             = ' '
*         I_OBJ_ID             = ' '
*         I_ENQUEUE            = ' '
*         I_GRAPHIC            = ' '
*         I_HEREDITABLE        = ' '
            i_including_text     = 'X'
            i_language           = sy-langu
            i_no_classification  = 'X'
            i_view               = 'K'
*         I_DATE               = SY-DATUM
*         I_CHANGE_NUMBER      = ' '
            i_no_objects         = 'X'
            i_sort_by_class      = ' '
*         I_EXCLUDE_CLINT      =
*         I_CALLED_BY_CLASSIFY = ' '
            i_structured_list    = ' '
       TABLES
            daten                = x_wghier
*         INDEX                =
*         EXP_KLAH             =            "JH/20.03.98/4.0C
            exp_klah             = x_klah     "JH/20.03.98/4.0C
       EXCEPTIONS
            class_not_valid      = 1
            classtype_not_valid  = 2
            OTHERS               = 3.

* ersetzt durch obigen Baustein CLHI_...
* CALL FUNCTION 'CTMS_STRUCTURE_CLASSES'
*      EXPORTING
*           ART               = WGHIER_KLART
*           CLASS             = P_MATKL
*           BATCH_FUNCTION    = 'X'
*           BOTTOM_UP         = ' '
*           LANGUAGE          = SY-LANGU
*           NO_CLASSIFICATION = 'X'
*           TOP_DOWN          = 'X'
*           VIEW              = 'K'
*      TABLES
*           DATEN             = X_WGHIER
*           INDEX             = X_INDEX.



  DESCRIBE TABLE x_wghier LINES anz_wghier.
  IF anz_wghier = 0.
    p_field = 'P_MATKL'.
    MESSAGE s040 WITH p_matkl.
*    Zur Warengruppe & konnten keine Klassiafikationsdaten ermittelt wer
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

*---- Herausfiltern der echten Basiswarengruppen ----------------------*
* JH/20.03.98/4.0C (Anfang)
* SELECT * FROM T023 FOR ALL ENTRIES IN X_WGHIER
*                    WHERE MATKL = X_WGHIER-CLAS2(9).
*   MOVE T023-MATKL TO X_MATKL-MATKL.
*   APPEND X_MATKL.
* ENDSELECT.
  LOOP AT x_klah WHERE wwskz = '1'.
    MOVE x_klah-class TO x_matkl-matkl.
    APPEND x_matkl.
  ENDLOOP.
* JH/20.03.98/4.0C (Ende)

  IF sy-subrc NE 0.
    p_field = 'P_MATKL'.
    MESSAGE s026 WITH p_matkl.
*    Zur übergeordneten Warengruppe & existieren keine Basiswarengruppen
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

  IF NOT merkm_sel IS INITIAL.
*---- Falls der Einstieg über eine Warengruppe erfolgte und zu dieser -*
*---- Einschränkungen bzgl. der zu berücksichtigenden Merkmalswerte   -*
*---- getroffen wurden, werden nur Sammelartikel in der Material-     -*
*---- selektionsliste berücksichtigt                                  -*
    SELECT * FROM  mara INTO TABLE t_mara
                        FOR ALL ENTRIES IN x_matkl
      WHERE  matkl = x_matkl-matkl
        AND  saiso IN r_saiso
        AND  saisj IN r_saisj
        AND  plgtp IN r_plgtp
        AND  attyp = attyp_sam.

    IF sy-subrc NE 0.
      p_field = 'P_MATKL'.
      MESSAGE s033 WITH p_matkl.
*    Zur Warengruppe & konnten keine konfig. Materialien ermittelt werde
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
  ELSE.
*---- Die Artikel zu allen ermittelten Basiswarengruppen lesen       --*
*---- (Reihenfolge der Art. in der Ergebnisliste noch nicht wichtig) --*
    SELECT * FROM  mara INTO TABLE t_mara
                        FOR ALL ENTRIES IN x_matkl
      WHERE  matkl = x_matkl-matkl
        AND  saiso IN r_saiso
        AND  saisj IN r_saisj
        AND  plgtp IN r_plgtp
        AND  attyp IN r_attyp.

    IF sy-subrc NE 0.
      p_field = 'P_MATKL'.
      MESSAGE s011.
*   Zur angegebenen Materialselekt. konnten keine Materialien gefunden w
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
  ENDIF.
ENHANCEMENT-POINT RWBEST01_013 SPOTS ES_RWBEST01 .

  LOOP AT t_mara.
*    PERFORM mat_einfuegen USING t_mara.         "TGA/4.6 Erw. Lot
    PERFORM mat_einfuegen  tables t_matnr        "TGA/4.6 Erw. Lot
                           USING t_mara.         "TGA/4.6 Erw. Lot
  ENDLOOP.

ENDFORM.                               " MAT_ZUR_WARENGRUPPE

*&---------------------------------------------------------------------*
*&      Form  FUELLE_RANGE_TABS
*&---------------------------------------------------------------------*
*    1) Belegen der Rangetabellen für die Materialfilter-Selektions-
*       kriterien für das allgemeine SELECT
*    2) Belegen der Rangetabelle für die selektierten Werke für das
*       spätere Lesen von Belegdaten
*----------------------------------------------------------------------*
FORM fuelle_range_tabs.

  REFRESH: r_saiso, r_saisj, r_plgtp, r_attyp.
  CLEAR:   r_saiso, r_saisj, r_plgtp, r_attyp.

  IF NOT p_saiso IS INITIAL.
    r_saiso-option = 'EQ'.
    r_saiso-sign   = 'I'.
    r_saiso-low    = p_saiso.
    APPEND r_saiso.
  ENDIF.

  IF NOT p_saisj IS INITIAL.
    r_saisj-option = 'EQ'.
    r_saisj-sign   = 'I'.
    r_saisj-low    = p_saisj.
    APPEND r_saisj.
  ENDIF.

  IF NOT p_plgtp IS INITIAL.
    r_plgtp-option = 'EQ'.
    r_plgtp-sign   = 'I'.
    r_plgtp-low    = p_plgtp.
    APPEND r_plgtp.
  ENDIF.

*---- Nicht operative Artikel ausschließen ----------------------------*
  r_attyp-option = 'EQ'.
  r_attyp-sign   = 'E'.
  r_attyp-low    = attyp_wgwa.
  APPEND r_attyp.
  r_attyp-low    = attyp_wghw.
  APPEND r_attyp.
  r_attyp-low    = attyp_wert.
  APPEND r_attyp.
  r_attyp-low    = attyp_wgva.
  APPEND r_attyp.

ENDFORM.                               " FUELLE_RANGE_TABS

*&---------------------------------------------------------------------*
*&      Form  MERKMALE_ZU_MAT
*&---------------------------------------------------------------------*
*       Zum Sammelartikel werden die relevanten Merkmale inkl. deren   *
*       zulässige Merkmalswerte ermittelt                              *
*----------------------------------------------------------------------*
FORM merkmale_zu_mat.

*---- Test, daß die Materialselektion nur einen einzelnen Sammelart. --*
*---- liefert                                                        --*
  PERFORM check_mat_input.

* Note 216336
  DATA: WG_CLASS LIKE KLAH-CLASS.
  WG_CLASS = MARA-MATKL.
  CALL FUNCTION 'C026_SET_UPPER_CLASS_FOR_CP'
       EXPORTING
            UPPER_CLASS = WG_CLASS
            I_OBJECT    = MARA-MATNR
       EXCEPTIONS
            OTHERS      = 1.

  IF s_matnr-low NE satnr_alt.
*---- Sammelartikel hat sich geändert -> Merkmalsdaten auf jeden Fall -*
*---- neu lesen                                                       -*
* JH/02.07.98/4.0C (Anfang)
*   PERFORM LESE_VB_MERKMALE USING S_MATNR-LOW ' '.
    PERFORM lese_vb_merkmale USING s_matnr-low ' ' 'X' mara-matkl.
* JH/02.07.98/4.0C (Ende)
    satnr_alt = s_matnr-low.
  ELSE.
*---- Sammelartikel ist gleichgebl. -> kein Neulesen der Merkmalsdaten *
*---- außer wenn ein neuer Sammelartikel eingegeben wurde und dann     *
*---- RETURN gedrückt wurde oder wenn hier ein Fehler aufgetreten ist  *
    IF anz_vb_merkm = 0.
* JH/02.07.98/4.0C (Anfang)
*     PERFORM LESE_VB_MERKMALE USING S_MATNR-LOW ' '.
      PERFORM lese_vb_merkmale USING s_matnr-low ' ' 'X' mara-matkl.
* JH/02.07.98/4.0C (Ende)
    ENDIF.
  ENDIF.
  CLEAR matkl_alt.

ENDFORM.                               " MERKMALE_ZU_MAT

*&---------------------------------------------------------------------*
*&      Form  MERKMALE_ZU_WG
*&---------------------------------------------------------------------*
*       Zur Warengruppe werden die relevanten Merkmale inkl. deren     *
*       zulässige Merkmalswerte ermittelt                              *
*----------------------------------------------------------------------*
FORM merkmale_zu_wg.

  IF p_matkl NE matkl_alt.
*---- Warengruppe hat sich geändert -> Merkmalsdaten auf jeden Fall ---*
*---- neu lesen                                                     ---*
* JH/02.07.98/4.0C (Anfang)
*   PERFORM LESE_VB_MERKMALE USING P_MATKL ' '.
    PERFORM lese_vb_merkmale USING p_matkl ' ' space space.
* JH/02.07.98/4.0C (Ende)
    matkl_alt = p_matkl.
  ELSE.
*---- Warengruppe ist gleichgebl. -> kein Neulesen der Merkmalsdaten  -*
*---- außer wenn eine neue Warengruppe eingegeben wurde und dann      -*
*---- RETURN gedrückt wurde oder wenn hier ein Fehler aufgetreten ist -*
    IF anz_vb_merkm = 0.
* JH/02.07.98/4.0C (Anfang)
*     PERFORM LESE_VB_MERKMALE USING P_MATKL ' '.
      PERFORM lese_vb_merkmale USING p_matkl ' ' space space.
* JH/02.07.98/4.0C (Ende)
    ENDIF.
  ENDIF.
  CLEAR satnr_alt.

ENDFORM.                               " MERKMALE_ZU_WG

*&---------------------------------------------------------------------*
*&      Form  CHECK_MAT_INPUT
*&---------------------------------------------------------------------*
*       Test, daß die Materialselektion nur einen einzelnen Sammelart. *
*       liefert                                                        *
*----------------------------------------------------------------------*
FORM check_mat_input.

*---- Existenztest ----------------------------------------------------*
  SELECT * FROM  mara UP TO 2 ROWS
    WHERE  matnr IN s_matnr.
  ENDSELECT.

  IF sy-subrc NE 0.
    CLEAR sy-ucomm.                    "F-Code 'MERK' löschen
    SET CURSOR FIELD 'S_MATNR-LOW'.
    MESSAGE e011.
*   Zur angegebenen Materialselekt. konnten keine Materialien gefunden w
  ENDIF.

*---- SY-DBCNT enthält die Anzahl der gefundenen Treffer --------------*
  IF ( sy-dbcnt > 1 )
  OR ( mara-attyp NE attyp_sam ).
    CLEAR sy-ucomm.                    "F-Code 'MERK' löschen
    SET CURSOR FIELD 'S_MATNR-LOW'.
    MESSAGE e014.
*    Merkmalsauswahl nur für einzelnen Sammelartikel möglich!
  ENDIF.

*---- Test, ob zu dem Sammelartikel ein entsprechender Klassenbezug ---*
*---- existiert                                                     ---*
  CALL FUNCTION 'CLMA_CLASS_EXIST'
       EXPORTING
            class                 = s_matnr-low
  "         CLASSIFY_ACTIVITY     = ' '
  "         CLASSNUMBER           = ' '
            classtype             = wghier_klart
            date                  = sy-datum
  "         DESCRIPTION_ONLY      = ' '
            language              = sy-langu
  "         MODE                  = ' '
            no_description        = 'X'
       IMPORTING
  "         CLASS_DESCRIPTION     = SATNR_BEZ    "JH/16.10.96 Bereitet
  "         CLASS_LANGUAGE        =     "Probleme bei Mehrsprachigkeit
                                       "         NOT_VALID             =
                                       "         NO_ACTIVE_STATUS      =
                                       "         NO_AUTHORITY_CLASSIFY =
                                       "         NO_AUTHORITY_MAINTAIN =
                                       "         NO_AUTHORITY_SELECT   =
  "         RET_CODE              = RET_CODE     "JH/16.10.96
            xklah                 = klah
       EXCEPTIONS
            no_valid_sign         = 01.

  IF ( sy-subrc NE 0 ).
* OR ( RET_CODE > 0 ).              "JH/16.10.96
    CLEAR sy-ucomm.                    "F-Code 'MERK' löschen
    SET CURSOR FIELD 'S_MATNR-LOW'.
    MESSAGE e015 WITH s_matnr-low.
*    Zum Sammelartikel & fehlt der Bezug zur Klassifikation!
  ENDIF.

* JH/16.10.96
* Bezeichnung zum Sammelartikel über MAKT ermitteln und nicht über die
* in der Klassifizierung hinterlegte Bezeichnung, denn diese weicht
* erstens von der Artikelbezeichnung im Materialstamm ab und ist auch
* nur für die Sprache, in der die Neuanlage erfolgte, definiert!
  SELECT SINGLE * FROM  makt
         WHERE  matnr = s_matnr-low
         AND    spras = sy-langu.
  IF sy-subrc = 0.
    satnr_bez = makt-maktx.
  ELSE.
    CLEAR satnr_bez.
  ENDIF.

ENDFORM.                               " CHECK_MAT_INPUT

*&---------------------------------------------------------------------*
*&      Form  LESE_MERKMALE
*&---------------------------------------------------------------------*
*       Alle direkten und geerbten Merkmale für Sammelartikel/Waren-
*       gruppe ermitteln
*----------------------------------------------------------------------*
*  -->  PI_CLASS   Klassenname (ext. Klassennr.)
*       PI_STOSEL Funktion wird zum Zeitpunkt START-OF-SELECTION aufge-
*                 rufen (-> anderes Message-Handling notwendig)
*----------------------------------------------------------------------*
FORM lese_merkmale USING  pi_class  LIKE klah-class
* JH/02.07.98/4.0C (Anfang)
*                         PI_STOSEL TYPE C.
                          pi_stosel TYPE c
                          pi_sa_merkm TYPE c
                          pi_matkl    LIKE mara-matkl.
* JH/02.07.98/4.0C (Ende)

  DATA: BEGIN OF x_klvmerk OCCURS 0.   "Liste der direkten und geerbten
          INCLUDE STRUCTURE klvmerk.   "Merkmale (inkl. Bezeichnung)
  DATA: END   OF x_klvmerk.

* JH/02.07.98/4.0C (Anfang)
* Falls Merkmale zu einem Sammelartikel gesucht werden, muß der FB
* C026_SET_UPPER_CLASS_FOR_CP zum Setzen der BasisWG aufgerufen werden
  IF NOT pi_sa_merkm IS INITIAL.
    hmatkl = pi_matkl.
    CALL FUNCTION 'C026_SET_UPPER_CLASS_FOR_CP'
         EXPORTING
              upper_class = hmatkl.
  ENDIF.
* JH/02.07.98/4.0C (Ende)

*---- Alle direkten und geerbten Merkmale (inkl. Bezeichnungen) zur ---*
*---- Klasse (= Sammelartikel oder Warengruppe) lesen               ---*
  CALL FUNCTION 'CLME_FEATURES_OF_CLASS_ALL'
       EXPORTING
            class           = pi_class
            classtype       = wghier_klart
            language        = sy-langu
            key_date        = sy-datum
       TABLES
            tfeatures       = x_klvmerk
       EXCEPTIONS
            class_not_found = 1
            no_authority    = 2
            OTHERS          = 3.

  CASE sy-subrc.
    WHEN 1.
      IF pi_stosel IS INITIAL.
        MESSAGE e017 WITH pi_class.
*    Die Klasse & ist nicht bekannt!
      ELSE.
        MESSAGE s017 WITH pi_class.
*    Die Klasse & ist nicht bekannt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
    WHEN 2.
      IF pi_stosel IS INITIAL.
        MESSAGE e018 WITH pi_class.
*    Sie haben keine Berechtigung zum Lesen der Klasse &!
      ELSE.
        MESSAGE s018 WITH pi_class.
*    Sie haben keine Berechtigung zum Lesen der Klasse &!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
    WHEN 3.
      IF pi_stosel IS INITIAL.
        MESSAGE e017 WITH pi_class.
*    Die Klasse & ist nicht bekannt!
      ELSE.
        MESSAGE s017 WITH pi_class.
*    Die Klasse & ist nicht bekannt!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
        PERFORM neustart_fehler.
      ENDIF.
  ENDCASE.

*---- Test, ob überhaupt Merkmale gefunden wurden ---------------------*
  DESCRIBE TABLE x_klvmerk LINES sy-tfill.
  IF sy-tfill = 0.
    IF pi_stosel IS INITIAL.
      MESSAGE e043 WITH pi_class.
*   Keine Merkmale zur Klasse & gefunden!
    ELSE.
      MESSAGE s043 WITH pi_class.
*   Keine Merkmale zur Klasse & gefunden!
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
  ENDIF.

  CLEAR: t_merkm.
  SORT x_klvmerk BY atinn.

*---- Potentielle Merkmale übernehmen ---------------------------------*
  LOOP AT x_klvmerk.
    MOVE-CORRESPONDING x_klvmerk TO t_merkm.
    APPEND t_merkm.
  ENDLOOP.

ENDFORM.                               " LESE_MERKMALE

*&---------------------------------------------------------------------*
*&      Form  LESE_BEWERTUNGEN
*&---------------------------------------------------------------------*
*       Zum den variantenbildenden Merkmalen die Bewertungen und deren
*       Bezeichnungen lesen
*----------------------------------------------------------------------*
*    -> PI_STOSEL Funktion wird zum Zeitpunkt START-OF-SELECTION aufge-
*                 rufen (-> anderes Message-Handling notwendig)
*----------------------------------------------------------------------*
FORM lese_bewertungen USING pi_stosel TYPE c.

* JH/03.08.98/4.5B/KPr51331 (Anfang)
  DATA x_cabn LIKE cabn OCCURS 0 WITH HEADER LINE.
* JH/03.08.98/4.5B/KPr51331 (Ende)

  CALL FUNCTION 'CTMS_DDB_HAS_VALUES_INTERNAL'
*    EXPORTING
*         ASSIGNED_VALUES       = ' '
*         ALLOWED_VALUES        = 'X'
*         VALID_VALUES          = ' '
*         INCONSISTENT_VALUES   = ' '
*         FIRST_ASSIGNED_VALUE  = ' '
*         DEFAULT_VALUES        = ' '
*         LANGUAGE              = SY-LANGU
*         DOCUMENT_INFO         = ' '
*         INHERITED_AS_ASSIGNED = 'X'
       TABLES
            imp_characteristics   = t_merkm
            exp_values            = t_bewert
       EXCEPTIONS
            not_found             = 1
            OTHERS                = 2.

* JH/03.08.98/4.5B/KPr51331 (Anfang)
* Auch Merkmale, die auf eine Referenztabelle verweisen oder die einen
* Zugriffsbaustein für die Wertermittlung nutzen, berücksichtigen.
* Diese Merkmalsbewertungen werden nicht vom FB
* CTMS_DDB_HAS_VALUES_INTERNAL zurückgeliefert, weil auf Ebene der WG
* keine Werte vorhanden sind, denn die Wertzuordnung erfolgt erst auf
* Ebene des SA
* -> altes Coding auskommentiert
* IF SY-SUBRC NE 0.
*   IF PI_STOSEL IS INITIAL.
*     MESSAGE E042.
**  Keine Bewertungsdaten für die Variantenmerkmale gefunden
*   ELSE.
*     MESSAGE S042.
**  Keine Bewertungsdaten für die Variantenmerkmale gefunden
**--- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
**--- daten gehen verloren)
*     PERFORM NEUSTART_FEHLER.
*   ENDIF.
* ENDIF.
*
* SORT T_BEWERT BY ATINN ATZHL.
*
* -> neues Coding!
  SORT t_bewert BY atinn atzhl.

  LOOP AT t_merkm.
*   Kontrolle, zu welchen Merkmalen keine Werte zurückgeliefert wurden
    READ TABLE t_bewert WITH KEY atinn = t_merkm-atinn BINARY SEARCH.
    IF sy-subrc NE 0.
*     Kein Merkmalswert gefunden -> prüfen, ob das Merkmal mit einer
*     Referenztab. oder einem Zugriffs-FB arbeitet
      CALL FUNCTION 'CLSE_SELECT_CABN_VIA_NAME'
           EXPORTING
                characteristic               = t_merkm-atnam
*          IMPORTING
*               AMBIGUOUS_OBJ_CHARACTERISTIC =
           TABLES
                t_cabn                       = x_cabn
           EXCEPTIONS
                no_entry_found               = 1
                OTHERS                       = 2.
      SORT x_cabn BY atinn adzhl.
      READ TABLE x_cabn WITH KEY atinn = t_merkm-atinn.
      IF sy-subrc = 0.
        IF  ( x_cabn-atprt IS INITIAL )
        AND ( x_cabn-atprf IS INITIAL ).
*         Keine Referenztabelle und kein Werte-FB -> Fehler!
          IF sy-subrc NE 0.
            IF pi_stosel IS INITIAL.
              MESSAGE e042.
*   Keine Bewertungsdaten für die Variantenmerkmale gefunden
            ELSE.
              MESSAGE s042.
*   Keine Bewertungsdaten für die Variantenmerkmale gefunden
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
              PERFORM neustart_fehler.
            ENDIF.
          ELSE.
*           Referenztabelle oder Werte-FB liegt vor -> fehlende
*           Bewertungsdaten werden später nachgelesen
          ENDIF.
        ENDIF.
      ELSE.
*       Fehler beim Lesen der Merkmalsdaten (sollte nie auftreten)!
        IF sy-subrc NE 0.
          IF pi_stosel IS INITIAL.
            MESSAGE e042.
*   Keine Bewertungsdaten für die Variantenmerkmale gefunden
          ELSE.
            MESSAGE s042.
*   Keine Bewertungsdaten für die Variantenmerkmale gefunden
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
            PERFORM neustart_fehler.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
* JH/03.08.98/4.5B/KPr51331 (Ende)

*#jhl 10.06.96 (Anfang)
*#jhl 10.06.96 Nachfolgender Programmteil wurde durch vorangegangenen
*#jhl 10.06.96 Funktionsbausteinaufruf ersetzt
* DATA: BEGIN OF X_CAWN OCCURS 20.     "Bewertungen
*         INCLUDE STRUCTURE CAWN.
* DATA: END   OF X_CAWN.
*
* DATA: BEGIN OF X_CAWNT OCCURS 20.    "Bewertungsbezeichnungen
*         INCLUDE STRUCTURE CAWNT.
* DATA: END   OF X_CAWNT.
*
* TABLES: CABN.                       "Merkmal-Daten
*
* CLEAR T_BEWERT.
*
* LOOP AT T_MERKM.
*   CALL FUNCTION 'CTAP_CHARACT_READ_COMPLETE'
*        EXPORTING
* "           CHARACT            =
*             INTERNAL_NUMBER    = T_MERKM-ATINN
*             KEY_DATE           = SY-DATUM
*             LANGUAGE           = SY-LANGU
*             F_WITH_DESCRIPTION = ' '
*             F_WITH_VALUES      = 'X'
*             F_WITH_CLASSTYPES  = ' '
*        IMPORTING
*             S_CABN             = CABN
*        TABLES
* "           E_CABNT            =
*             E_CAWN             = X_CAWN
*             E_CAWNT            = X_CAWNT
* "           E_TCME             =
*        EXCEPTIONS
*             CHARACT_NOT_FOUND  = 01.
*
*   IF SY-SUBRC NE 0.
*     MESSAGE E022 WITH T_MERKM-ATINN.
*    Merkmal & nicht vorhanden -> Merkmalsbewertung nicht möglich!
*   ENDIF.
*
*Fehler im Baustein!
*Falls Baustein mehrfach aufgerufen wird, enthält int. Tab. TE_CABN
*mehrere Einträge, aber in S_CABN wird nur der mit INDEX 1 gelesene
*Eintrag zurückgeliefert -> fehlerhaft -> int. Tab. müßte gelöscht
*werden -> solange Fehler nicht behoben, wird mit Notlösung gearbeitet
*SELECT        * FROM  CABN
*       WHERE  ATINN       = T_MERKM-ATINN.
*  EXIT.
*ENDSELECT.
*
*---- Leider werden die Merkmalswerte manchmal falsch sortiert  -------*
*---- geliefert (und zwar bei ungerader Anzahl v. Merkm.werten) -------*
*   SORT X_CAWN BY ATINN ATZHL.
*
*   LOOP AT X_CAWN.
*     MOVE-CORRESPONDING X_CAWN  TO T_BEWERT.
*     READ TABLE X_CAWNT WITH KEY ATINN = X_CAWN-ATINN
*                                 ATZHL = X_CAWN-ATZHL
*                                 SPRAS = SY-LANGU
*                                 ADZHL = X_CAWN-ADZHL.
*     IF SY-SUBRC = 0.
*       MOVE X_CAWNT-ATWTB TO T_BEWERT-ATWTB.
*     ELSE.
*       CLEAR T_BEWERT-ATWTB.
*     ENDIF.
*
*---- Falls der Merkmalswert numerisch ist muß eine Umkonvertierung ---*
*---- erfolgen                                                      ---*
*     IF  ( T_BEWERT-ATWRT IS INITIAL )
*     AND ( T_BEWERT-ATWTB IS INITIAL ).
*       CALL FUNCTION 'CTCV_PREPARE_VALUES_TO_DISPLAY'
*            EXPORTING
**                ALIGN                  = 'NO'
**                CONDENSE               = 'NO'
**                DECIMALPOINT           = ' '
**                SHIFT                  = 'LEFT'
**                SINGLE                 = 'NO'
**                STRING_WITHOUT_OPERAND = 'NO'
**                STRING_WITHOUT_UNIT    = 'NO'
**                STRING_WITH_BASEUNIT   = 'NO'
*                 STRUCTURE_CABN         = CABN
*                 STRUCTURE_CAWN         = X_CAWN
**                WITHOUT_EDIT_MASK      = ' '
*            IMPORTING
**                OPERAND1               =
**                OPERAND2               =
*                 STRING                 = T_BEWERT-ATWRT
**                STRING1                = T_BEWERT-ATWRT
**                STRING2                =
**                UNIT                   =
**                UNIT2                  =
*            EXCEPTIONS
*                 OVERFLOW               = 1
*                 OTHERS                 = 2.
*
*       IF SY-SUBRC NE 0.
*         MESSAGE A051.
*    Fehler bei der Konvertierung eines numerischen Merkmalswertes!
*       ENDIF.
*---- Zur Sicherheit sowohl Merkmalswert als auch -bezeichnung belegen *
*       T_BEWERT-ATWTB = T_BEWERT-ATWRT.
*     ELSE.
*       IF T_BEWERT-ATWRT IS INITIAL.
*         T_BEWERT-ATWRT = T_BEWERT-ATWTB.
*       ELSE.
*         IF T_BEWERT-ATWTB IS INITIAL.
*           T_BEWERT-ATWTB = T_BEWERT-ATWRT.
*         ENDIF.
*       ENDIF.
*     ENDIF.
*     APPEND T_BEWERT.
*   ENDLOOP.
* ENDLOOP.
*#jhl 10.06.96 (Ende)

ENDFORM.                               " LESE_BEWERTUNGEN

*&---------------------------------------------------------------------*
*&      Form  RESET_MERKMALE
*&---------------------------------------------------------------------*
*       Zurücksetzen von Daten zur Merkmalswerteselektion              *
*----------------------------------------------------------------------*
FORM reset_merkmale.

  REFRESH: t_merkm, t_merkm_stat, t_bewert, t_selbew.
  CLEAR:   anz_vb_merkm, merkm_sel.

ENDFORM.                               " RESET_MERKMALE

*&---------------------------------------------------------------------*
*&      Form  CHECK_SELBEW
*&---------------------------------------------------------------------*
*       Festhalten, für welche Merkmale Einschränkungen eingeg. wurden
*----------------------------------------------------------------------*
FORM check_selbew.

  CLEAR merkm_sel.
  LOOP AT t_merkm_stat.
    READ TABLE t_selbew WITH KEY atinn = t_merkm_stat-atinn
                        BINARY SEARCH.
*---- Folgende 4 Arten von Einträgen kann T_SELBEW enthalten:
*---- 1) ATCOD = '0': kein Merkmalswert eingegeben (unabh. von der
*----                 Vergleichsart) -> Merkmal nicht berücksichtigen
*---- 2) ATCOD = '1': Merkmalswert wurde eingegeben
*----    a) SLCOD = '1': Vergleichgsart INCL
*----    b) SLCOD = '4': Vergleichgsart EXCL bei Merkmalen v. Typ CHAR
*----    c) SLCOD = '3': Vergleichgsart EXCL bei Merkmalen v. Typ NUM
*---- Anmerkung:????
*---- Momentan wird bei CHAR-Merkmalen die Stringsuche noch nicht
*---- unterstützt (SLCOD = '2' -> INCL, SLCOD = '5' -> EXCL)
    IF  ( sy-subrc = 0 ) AND ( t_selbew-atcod = '1' ).
*---- Für Merkmal existiert Merkmalswerteeinschränkung ----------------*
      t_merkm_stat-selek = 'X'.
      t_merkm_stat-slcod = t_selbew-slcod.
      merkm_sel          = 'X'.
    ELSE.
*---- Für Merkmal existiert keine Merkmalswerteeinschränkung ----------*
      CLEAR t_merkm_stat-selek.
      CLEAR t_merkm_stat-slcod.
    ENDIF.
    MODIFY t_merkm_stat.
  ENDLOOP.
*#JHL 19.08.96 Einschränkung bzgl. Anzahl der var.bild. Merkm. aufgehob.
*  LOOP AT T_SELBEW.
*   IF T_SELBEW-ATINN NE ATINN_ALT.
*     COUNTER = COUNTER + 1.
*     MOVE T_SELBEW-ATINN TO ATINN_ALT.
*   ENDIF.
* ENDLOOP.
*
* CASE COUNTER.
*   WHEN 0.
*---- Alle Merkmalswerte beider Merkmale bei der Variantenauswahl -----*
*---- berücksichtigen                                             -----*
*     MERKM_SEL = MERKM_KEIN.
*   WHEN 1.
*---- Entscheiden, ob Merkmal1 oder Merkmal2 bewertet wurde -----------*
*     READ TABLE T_MERKM WITH KEY ATINN = ATINN_ALT BINARY SEARCH.
*     IF SY-SUBRC NE 0.
*       MESSAGE A038 WITH 'T_MERKM'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*     ENDIF.
*     IF SY-TABIX = 1.
*---- Alle Merkmalswerte von Merkmal2 und nur die selektierten Merk- --*
*---- malswerte von Merkmal1 bei der Variantenauswahl berücksicht.   --*
*       MERKM_SEL = MERKM_1.
*     ELSE.
*---- Alle Merkmalswerte von Merkmal1 und nur die selektierten Merk- --*
*---- malswerte von Merkmal2 bei der Variantenauswahl berücksicht.   --*
*       MERKM_SEL = MERKM_2.
*     ENDIF.
*   WHEN 2.
*---- Nur die selektierten Merkmalswerte von Merkmal1 und Merkmal2 ----*
*---- bei der Variantenauswahl berücksichtigen                     ----*
*     MERKM_SEL = MERKM_1U2.
*   WHEN OTHERS.
*     MERKM_SEL = MERKM_KEIN.
*     MESSAGE E019.
*    Selektion von Werten ist nur bei maximal 2 Merkmalen erlaubt!
* ENDCASE.
ENDFORM.                               " CHECK_SELBEW

*&---------------------------------------------------------------------*
*&      Form  MAT_EINFUEGEN
*&---------------------------------------------------------------------*
*       Einfügen von Materialdaten in int. Selektionstabelle T_MATNR   *
*       und Ermitteln der notwendigen Materialtexte                    *
*----------------------------------------------------------------------*
*  -->  PI_MARA   Materialstammsatz
*----------------------------------------------------------------------*
*FORM mat_einfuegen USING  pi_mara  STRUCTURE mara. "TGA/4.6 Erw. Lot
FORM mat_einfuegen TABLES p_t_matnr STRUCTURE t_matnr
                   USING  pi_mara  STRUCTURE mara.

  DATA: x_matnr LIKE t_matnr.  "Eigener Kopfbereich, damit alte Daten
  "im Kopfbereich v. T_MATNR nicht über-
                                       "schrieben werden müssen

*---- Materialstammdaten übergeben ------------------------------------*
  MOVE-CORRESPONDING pi_mara       TO x_matnr.
  MOVE               pi_mara-meins TO x_matnr-basme.

*---- Alten Umrechnungsfaktor initialisieren --------------------------*
  x_matnr-umrez_alt = 1.
  x_matnr-umren_alt = 1.

*#jhl 25.01.96 Materialart als Information entfällt
*---- Bezeichnung der Materialart ermitteln, falls sie sich gegen- ----*
*---- über dem letzten Zugriff geändert hat, und übergeben         ----*
* IF MARA-MTART NE MTART_ALT.
*   SELECT SINGLE * FROM T134T
*          WHERE  SPRAS = SY-LANGU
*          AND    MTART = MARA-MTART.
*
*   MOVE T134T-MTBEZ TO X_MATNR-MTBEZ.
*   MOVE T134T-MTBEZ TO MTBEZ_ALT.
*   MOVE MARA-MTART  TO MTART_ALT.
* ELSE.
*   MOVE MTBEZ_ALT TO X_MATNR-MTBEZ.
* ENDIF.

* APPEND x_matnr TO t_matnr.        "TGA/4.6 Erweiterungen Lot
  READ TABLE p_t_matnr                                  "v note 2726544
    WITH KEY matnr = x_matnr-matnr
    BINARY SEARCH.
  IF sy-subrc NE 0.
    INSERT x_matnr INTO p_t_matnr INDEX sy-tabix.
  ENDIF.                                                "^ note 2726544
ENDFORM.                               " MAT_EINFUEGEN

*&---------------------------------------------------------------------*
*&      Form  SHOW_MERKMALE
*&---------------------------------------------------------------------*
*       Darstellung des Dynpros zur Merkmalsselektion                  *
*----------------------------------------------------------------------*
FORM show_merkmale.

  DATA: BEGIN OF x_merkm OCCURS 0,  "Anzuzeigende Merkmale für Selektion
          atinn LIKE klmerk-atinn,     " Interne Merkmalsnr.
          atino LIKE klmerk-atinn,     " Dummyfeld
          sicht LIKE ksml-abtei,       " Dummyfeld
          dinkb LIKE ksml-dinkb,       " Dummyfeld
        END   OF x_merkm.

  DATA: BEGIN OF x_header,             "Header f. Merkm.selekt.-Dynpro
          report LIKE syst-repid VALUE 'RWBEST01',
          dynnr  LIKE syst-dynnr VALUE '0200',
        END   OF x_header.

  DATA: BEGIN OF x_erbmerk OCCURS 1,   "Dummy für Function-Call
          vatere  LIKE      klah-class,
          sohne   LIKE      klah-class.
          INCLUDE STRUCTURE comw.
  DATA: END   OF x_erbmerk.

  DATA: BEGIN OF x_ghcl OCCURS 1.      "Dummy für Function-Call
          INCLUDE STRUCTURE ghcl.
  DATA: END OF x_ghcl.

*---- Variantenbildende Merkmale übergeben ----------------------------*
  LOOP AT t_merkm.
    x_merkm-atinn = t_merkm-atinn.
    APPEND x_merkm.
  ENDLOOP.

*---- Titel für Dynpro zur Merkmalswerteselektion setzen --------------*
* tga/46C  doesn't work with new selection sreen
* SET TITLEBAR 'MER'.

*---- Daten für die Anzeige im Kopfbereich des Dynpros bereitstellen --*
  CASE mat_sel.
    WHEN matnr_belegt.
      MOVE text-013  TO d_fdtxt.
      MOVE satnr_bez TO d_fdbez.
    WHEN matkl_belegt.
      MOVE text-008 TO d_fdtxt.
      MOVE p_matklt TO d_fdbez.
  ENDCASE.

*---- Dynpro zur Merkmalsselektion aufrufen ---------------------------*
  CALL FUNCTION 'CTMS_ENTER_VALUES'
     EXPORTING
          ident                    = 'KL'       "Klassifikation
          include_header           = x_header   "Kopfbildbaustein
          mode                     = 'S'        "'S'elektionsmodus
          pf_status                = 'MRKM'     "Beim Einstieg nur Merk-
                                       "male ohne Werte anzeig.
*tga/46C new titlebar
*         titlebar                 = ' '        "Eigenen Titel anzeigen
          titlebar                 = 'CLA'      "standard titlebar
          single_value             = ' '        "Mehrere Werte eingebbar
          no_f11                   = 'X'        "Sichern nicht notwendig
          language                 = sy-langu
          key_date                 = sy-datum
          hierarchy_allowed        = ' '        "Nur Anzeige der über-
                                       "gebenen Merkmale
     IMPORTING
          return                   = ret_comm
     TABLES
          selection                = t_selbew   "selekt. Merkmalswerte
          mtable                   = x_merkm    "anzuzeigende Merkmale
          new_multiple_classes     = x_ghcl     "keine Verarbeitung
          passing_value            = x_erbmerk  "keine Verarbeitung
     EXCEPTIONS
          no_characteristics       = 01
          internal_error           = 02.

  CASE sy-subrc.
    WHEN 01.
      IF mat_sel = matnr_belegt.
        MESSAGE e020 WITH s_matnr-low.
*    Keine Merkmale zur Klasse & gefunden!
      ELSE.
        MESSAGE e020 WITH p_matkl.
*    Keine Merkmale zur Klasse & gefunden!
      ENDIF.
    WHEN 02.
      IF mat_sel = matnr_belegt.
        MESSAGE e021 WITH s_matnr-low.
*    Interner Fehler bei der Ermittlung der Merkmalsdaten zur Klasse &!
      ELSE.
        MESSAGE e021 WITH p_matkl.
*    Interner Fehler bei der Ermittlung der Merkmalsdaten zur Klasse &!
      ENDIF.
  ENDCASE.

  CASE ret_comm.
    WHEN 'GOON'.                                            "F8
*---- Festhalten zu welchen Merkmalen Werte selektiert wurden ---------*
      PERFORM check_selbew.
    WHEN 'BACK'.                                            "F3
*---- Festhalten zu welchen Merkmalen Werte selektiert wurden ---------*
      PERFORM check_selbew.
    WHEN 'ENDE'.                                            "F15
      PERFORM rwbe_beenden.
    WHEN 'EOT' .                                            "F12
*---- Zurücksetzen etwaig selektierter Merkmalswerte ------------------*
      REFRESH t_selbew.
      LOOP AT t_merkm_stat.
        CLEAR t_merkm_stat-selek.
        CLEAR t_merkm_stat-slcod.
        MODIFY t_merkm_stat.
      ENDLOOP.
      CLEAR merkm_sel.
  ENDCASE.

ENDFORM.                               " SHOW_MERKMALE

*&---------------------------------------------------------------------*
*&      Form  VAR_BILDENDE_MERKM
*&---------------------------------------------------------------------*
*       Aus der Menge der gefundenen Merkmale die variantenbildenden
*       Merkmale herausfiltern.
*----------------------------------------------------------------------*
*  -->  PI_CLASS  Klassenname (ext. Klassennr.)
*       PI_STOSEL Funktion wird zum Zeitpunkt START-OF-SELECTION aufge-
*                 rufen (-> anderes Message-Handling notwendig)
*----------------------------------------------------------------------*
FORM var_bildende_merkm USING pi_class  LIKE klah-class
                              pi_stosel TYPE c.

  DATA: BEGIN OF x_ghcl OCCURS 0.      "Struktur der Klassenhierarchie
          INCLUDE STRUCTURE ghcl.
  DATA: END   OF x_ghcl.

  DATA: BEGIN OF x_index OCCURS 0,  "Dummy (nur für Funktionbaust.-Call)
          index      LIKE sy-tabix,    "Index
          ugkla      TYPE c,           "Kz. untergeordnete Klasse
        END   OF x_index.

  DATA: BEGIN OF x_ksml OCCURS 0.      "Zuordnung Merkmal zu Klasse
          INCLUDE STRUCTURE ksml.
  DATA: END   OF x_ksml.
* Kennzeichen Merkmalsrelevanz tga/100699 (start)
 data: begin of h_ksml occurs 0.     "help table for getting duplcate
         include structure ksml.     "entries for the same characterist
 data: end   of h_ksml.
 data: h_ksml_imerk like ksml-imerk.
*-Kennzeichen Merkmalsrelevanz tga/100699 (end)
*-Neuer Aufruf über CLHI_... Baustein PK/40C. 18.03.98
  CALL FUNCTION 'CLHI_STRUCTURE_CLASSES'
       EXPORTING
            i_klart              = wghier_klart
            i_class              = pi_class
            i_bup                = 'X'
            i_tdwn               = ' '
            i_batch              = 'X'
*         I_OBJECT             = ' '
*         I_OBJ_ID             = ' '
*         I_ENQUEUE            = ' '
*         I_GRAPHIC            = ' '
*         I_HEREDITABLE        = ' '
*         I_INCLUDING_TEXT     = 'X'
            i_language           = sy-langu
            i_no_classification  = 'X'
            i_view               = 'K'
*         I_DATE               = SY-DATUM
*         I_CHANGE_NUMBER      = ' '
            i_no_objects         = 'X'
            i_sort_by_class      = ' '
*         I_EXCLUDE_CLINT      =
*         I_CALLED_BY_CLASSIFY = ' '
            i_structured_list    = ' '
       TABLES
            daten                = x_ghcl
*         INDEX                =
*         EXP_KLAH             =
       EXCEPTIONS
            class_not_valid      = 1
            classtype_not_valid  = 2
            OTHERS               = 3.

* ERSETZT DURCH OBIGEN CLHI_.. AUFRUF PK/18.03.98
*---- Klassenhierarchie zum Sammelartikel/Einstiegswarengruppe lesen --*
*  CALL FUNCTION 'CTMS_STRUCTURE_CLASSES'
*       EXPORTING
*            ART               = WGHIER_KLART
*            CLASS             = PI_CLASS
*            BATCH_FUNCTION    = 'X'
*            BOTTOM_UP         = 'X'
*            LANGUAGE          = SY-LANGU
*            NO_CLASSIFICATION = 'X'
*            TOP_DOWN          = ' '
*            VIEW              = 'K'
*            KEY_DATE          = SY-DATUM
*       TABLES
*            DATEN             = X_GHCL
*            INDEX             = X_INDEX.   "ohne Weiterverarbeitung

*---- Die gelieferten Hierarchieknoten als potentielle Klassen mit ----*
*---- Merkmalszuordnung ablegen                                    ----*
  LOOP AT x_ghcl.
    x_ksml-clint = x_ghcl-clin1.
    APPEND x_ksml.
  ENDLOOP.

*---- Zu den hinterlegten Klassen die zugeordneten Merkmale lesen.   --*
*---- Das Kennzeichen X_KSML-RELEV gibt an ob das Merkmal varianten- --*
*---- bildend ist. Falls ein Merkmal mehreren Klassen der Hierarchie --*
*---- zugeordnet ist, kann es vorkommen, daß das Kennzeichen unter-  --*
*---- schiedlich gesetzt ist -> testen, ob bei mindestens einem Vor- --*
*---- kommen der Wert 'variantenbildend' vorliegt                    --*
  CALL FUNCTION 'CLSE_SELECT_KSML'
       EXPORTING
            key_date       = sy-datum
       TABLES
            imp_exp_ksml   = x_ksml
       EXCEPTIONS
            no_entry_found = 01.

  IF sy-subrc NE 0.
    IF pi_stosel IS INITIAL.
      MESSAGE e013.
    ELSE.
      MESSAGE s013.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
*   Keine Merkmale zu den Klassen der Warengruppenhierarchie gefunden!
  ENDIF.

*---- Testen, welche Merkmale variantenbildend sind und Herauslöschen -*
*---- der restlichen Merkmale
* Kennzeichen Merkmalsrelevanz tga/100699 (start)
* LOOP AT x_ksml WHERE relev NE '2'.
*---- Test, ob zu dem gleichen Merkmal doch noch ein Eintrag mit    ---*
*---- X_KSML-RELEV = '2' vorliegt, denn dann darf das Merkmal nicht ---*
*---- gelöscht werden!                                              ---*
*   READ TABLE x_ksml WITH KEY imerk = x_ksml-imerk
*                              relev = '2'
*                              TRANSPORTING NO FIELDS.
*   IF sy-subrc NE 0.
*     DELETE t_merkm WHERE atinn = x_ksml-imerk.
*   ENDIF.
* ENDLOOP.

* remove all irrelevant characteristics
  DELETE x_ksml where relev < 2.
  loop at t_merkm.
    read table x_ksml with key imerk = t_merkm-atinn.
    IF sy-subrc <> 0.
     delete t_merkm.
    endif.
  endloop.

* Kennzeichen Merkmalsrelevanz tga/100699 (end)
  DESCRIBE TABLE t_merkm LINES anz_vb_merkm.

*#JHL 19.08.96 Einschränkung bzgl. Anzahl der var.bild. Merkm. aufgehob.
  IF anz_vb_merkm = 0.
    IF pi_stosel IS INITIAL.
      MESSAGE e023 WITH pi_class.
*    Zur Klasse & konnten keine variantenbildenden Merkmale ermittelt we
    ELSE.
      MESSAGE s023 WITH pi_class.
*    Zur Klasse & konnten keine variantenbildenden Merkmale ermittelt we
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.
  ELSE.
*---- Mindestens 1 variantenbildendes Merkmal gefunden.           -----*
*---- Falls der Einstieg über eine höhere Warengruppenhierarchie- -----*
*---- stufe mit Merkmalswerteeinschränkung erfolgt ist, kann es   -----*
*---- möglich sein, daß auf tieferliegenden Stufe noch weitere    -----*
*---- variantenbildende Merkmale definiert sind. Diese werden zum -----*
*---- Zeitpunkt, wo der entsprechende Sammelartikel zur Anzeige   -----*
*---- kommt, nachgelesen.                                         -----*
    CLEAR t_merkm_stat.
    LOOP AT t_merkm.
      t_merkm_stat-atinn = t_merkm-atinn.
      APPEND t_merkm_stat.
    ENDLOOP.
  ENDIF.
* CASE ANZ_VB_MERKM.
*   WHEN 0.
*     IF PI_STOSEL IS INITIAL.
*       MESSAGE E023 WITH PI_CLASS.
*    Zur Klasse & konnten keine variantenbildenden Merkmale ermittelt we
*     ELSE.
*       MESSAGE S023 WITH PI_CLASS.
*    Zur Klasse & konnten keine variantenbildenden Merkmale ermittelt we
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
*       PERFORM NEUSTART_FEHLER.
*     ENDIF.
*   WHEN 1.
*---- Entweder wurde ein Sammelartikel eingegeben, zu dem nur ein -----*
*---- variantenbildendes Merkmal gefunden werden konnte -> Dar-   -----*
*---- stellung d. Bestandsdaten aufgeteilt nach Varianten erfolgt -----*
*---- einzeilig.                                                  -----*
*---- Oder der Einstieg erfolgte über eine Warengruppe mit Merk-  -----*
*---- malswerteienschränkung wobei nur 1 var.bild. Merkm. ge-     -----*
*---- funden wurde, so daß für den Sammelartikel evtl. noch ein   -----*
*---- var.bild. Merkmal nachgelesen werden muß                    -----*
*   WHEN 2.
*---- Die Darstellung der Bestandsdaten aufgeteilt nach Varianten -----*
*---- erfolgt in Matrixform                                       -----*
*   WHEN OTHERS.
*     IF PI_STOSEL IS INITIAL.
*       MESSAGE E035 WITH PI_CLASS.
*     ELSE.
*       MESSAGE S035 WITH PI_CLASS.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
*       PERFORM NEUSTART_FEHLER.
*     ENDIF.
*    Zur Klasse & wurden mehr als 2 variantenbildende Merkmale ermittelt
* ENDCASE.

ENDFORM.                               " VAR_BILDENDE_MERKM

*&---------------------------------------------------------------------*
*&      Form  LESE_MERKMALE_TEST
*&---------------------------------------------------------------------*
*       Alle direkten und geerbten Merkmale mit zugehörenden Merkmals-
*       werten für Sammelartikel/Warengruppe ermitteln und anzeigen
*       Anmerkung: Funktion dient nur zu Testzwecken, um alle Merkmale
*       im Selektionsdynpro sichtbar zu machen. Ansonsten kommen nur
*       die beiden variantenbildenden Merkmale zur Anzeige!
*----------------------------------------------------------------------*
*  -->  PI_CLASS   Klassenname (ext. Klassennr.)
*----------------------------------------------------------------------*
FORM lese_merkmale_test USING  pi_class  LIKE klah-class.

  DATA: BEGIN OF x_klmerk OCCURS 0.   "dir. Merkmale (inkl. Bezeichnung)
          INCLUDE STRUCTURE klmerk.
  DATA: END   OF x_klmerk.

  DATA: BEGIN OF x_klvmerk OCCURS 0.  "geerbte Merkmale (inkl. Bezeich.)
          INCLUDE STRUCTURE klvmerk.
  DATA: END   OF x_klvmerk.

*---- Alle direkten und geerbten Merkmale (inkl. Bezeichnungen) zur ---*
*---- Klasse (= Sammelartikel oder Warengruppe) lesen               ---*
*---- (Anm.: die Funkt. CLASS_READ_CHARACT_ALL, die beides liefert, ---*
*---- kann leider nicht verwendet werden, weil die Information, ob  ---*
*---- es sich bei dem Merkm. um ein direktes od. vererbtes handelt, ---*
*---- nicht zurückgeliefert wird, diese aber noch gebraucht wird)   ---*

*   CALL FUNCTION 'CLASS_READ_CHARACT'            "direkte Merkmale
*        EXPORTING
*             CLASSNAME       = PI_CLASS
*             CLASSTYPE       = WGHIER_KLART
*             LANGUAGE        = SY-LANGU
*             KEY_DATE        = SY-DATUM
*        TABLES
*             E_CHARACT       = X_KLMERK
*        EXCEPTIONS
*             CLASS_NOT_FOUND = 01
*             NO_AUTHORITY    = 02.

  CASE sy-subrc.
    WHEN 01.
      MESSAGE e017 WITH pi_class.
*    Die Klasse & ist nicht bekannt!
    WHEN 02.
      MESSAGE e018 WITH pi_class.
*    Sie haben keine Berechtigung zum Lesen der Klasse &!
  ENDCASE.

*   CALL FUNCTION 'CLASS_READ_CHARACT_INH'        "geerbte Merkmale
*        EXPORTING
*             CLASSNAME       = PI_CLASS
*             CLASSTYPE       = WGHIER_KLART
*             LANGUAGE        = SY-LANGU
*             KEY_DATE        = SY-DATUM
*        TABLES
*             E_CHARACT       = X_KLVMERK
*        EXCEPTIONS
*             CLASS_NOT_FOUND = 01
*             NO_AUTHORITY    = 02.

*---- Abfrage der Exceptions kann entfallen, da diese schon beim ------*
*---- Aufruf von 'CLASS_READ_CHARACT' überprüft werden           ------*

  CLEAR: t_merkm, t_dirmerk.

*---- Zu den direkten Merkmalen die Bewertungen und Bewertungs- -------*
*---- bezeichnungen lesen                                       -------*
  LOOP AT x_klmerk.
    MOVE-CORRESPONDING x_klmerk TO t_merkm.
    APPEND t_merkm.
    MOVE-CORRESPONDING x_klmerk TO t_dirmerk.
    APPEND t_dirmerk.
  ENDLOOP.

*---- Zu den geerebten Merkmalen die Bewertungen und Bewertungs- ------*
*---- bezeichnungen lesen                                        ------*
  LOOP AT x_klvmerk.
    MOVE-CORRESPONDING x_klvmerk TO t_merkm.
    APPEND t_merkm.
  ENDLOOP.

*---- Anzeige des Selektionsdynpros für die Merkmalswerte -------------*
  DATA: BEGIN OF x_header,             "Header f. Merkm.selekt.-Dynpro
          report LIKE syst-repid VALUE 'RWBEST01',
          dynnr  LIKE syst-dynnr VALUE '0200',
        END   OF x_header.

  DATA: BEGIN OF x_como.
          INCLUDE STRUCTURE ctms_01.   "Komm.struktur fürs Klassensyst.
  DATA: END   OF x_como.

  DATA: BEGIN OF x_erbmerk OCCURS 1,   "Dummy für Function-Call
          vatere  LIKE      klah-class,
          sohne   LIKE      klah-class.
          INCLUDE STRUCTURE comw.
  DATA: END   OF x_erbmerk.

  DATA: BEGIN OF x_ghcl OCCURS 1.      "Dummy für Function-Call
          INCLUDE STRUCTURE ghcl.
  DATA: END OF x_ghcl.

*---- Dynpro zur Merkmalsselektion aufrufen ---------------------------*
  CLEAR x_como.
  x_como-klart = wghier_klart.

  CASE mat_sel.
    WHEN matnr_belegt.
      x_como-class = s_matnr-low.
      MOVE text-013  TO d_fdtxt.
      MOVE satnr_bez TO d_fdbez.
    WHEN matkl_belegt.
      x_como-class = p_matkl.
      MOVE text-008 TO d_fdtxt.
      MOVE p_matklt TO d_fdbez.
  ENDCASE.

*---- Titel für Dynpro zur Merkmalswerteselektion setzen --------------*
  SET TITLEBAR 'MER'.

  CALL FUNCTION 'CTMS_ENTER_VALUES'
     EXPORTING
          ident                    = 'KL'       "Klassifikation
          include_header           = x_header   "Kopfbildbaustein
          mode                     = ' '        "kein 'S'elektionsmodus
          object                   = x_como     "Sammelart./Warengruppe
          pf_status                = 'MRKM'     "Beim Einstieg nur Merk-
                                       "male ohne Werte anzeig.
          titlebar                 = ' '        "Eigenen Titel anzeigen
          single_value             = ' '        "Mehrere Werte eingebbar
          no_f11                   = 'X'        "Sichern nicht notwendig
          language                 = sy-langu
          key_date                 = sy-datum
     IMPORTING
          return                   = ret_comm
     TABLES
          selection                = t_selbew
          mtable                   = t_dirmerk
          new_multiple_classes     = x_ghcl     "keine Verarbeitung
          passing_value            = x_erbmerk  "keine Verarbeitung
     EXCEPTIONS
          no_characteristics       = 01
          internal_error           = 02.
ENDFORM.                               " LESE_MERKMALE_TEST

*&---------------------------------------------------------------------*
*&      Form  SELECT_MERKMALE
*&---------------------------------------------------------------------*
*       Zur Warengruppe oder einem Sammelartikel werden d. varianten-
*       bildenden Merkmale inkl. deren zulässige Merkmalswerte ermitt.
*       und zur Anzeige gebracht, um Einschränkungen bzgl. der Merkm.-
*       werte durchführen zu können
*----------------------------------------------------------------------*
FORM select_merkmale.

  CASE mat_sel.
    WHEN matnr_belegt.
      PERFORM merkmale_zu_mat.
    WHEN matkl_belegt.
      PERFORM merkmale_zu_wg.
    WHEN OTHERS.
*---- Keine Einschränkung bzgl. Material getroffen -> nicht möglich ---*
      SET CURSOR FIELD 'P_MATKL'.
      MESSAGE e001.
*    Entweder ein Material oder eine Warengruppe eingeben!
  ENDCASE.

*---- Selektionsdynpro für Merkmalswerteeinschränkung prozessieren ----*
  PERFORM show_merkmale.

ENDFORM.                               " SELECT_MERKMALE

*&---------------------------------------------------------------------*
*&      Form  LESE_VB_MERKMALE
*&---------------------------------------------------------------------*
*       Alle variantenbildenden Merkmale für den Sammelartikel oder die
*       Warengruppe/Warengruppenhierarchiestufe inkl. der Bewertungen
*       lesen
*----------------------------------------------------------------------*
*  -->  PI_CLASS  Klassenname (ext. Klassennummer)
*       PI_STOSEL Funktion wird zum Zeitpunkt START-OF-SELECTION aufge-
*                 rufen (-> anderes Message-Handling notwendig)
*----------------------------------------------------------------------*
FORM lese_vb_merkmale USING pi_class  LIKE klah-class
* JH/02.07.98/4.0C (Anfang)
*                           PI_STOSEL TYPE C.
                            pi_stosel TYPE c
                            pi_sa_merkm TYPE c
                            pi_matkl    LIKE mara-matkl.
* JH/02.07.98/4.0C (Ende)

  PERFORM reset_merkmale.
*---- Alle direkten und geerbten Merkmale lesen -----------------------*
* JH/02.07.98/4.0C (Anfang)
* PERFORM LESE_MERKMALE USING PI_CLASS PI_STOSEL.
  PERFORM lese_merkmale USING pi_class pi_stosel pi_sa_merkm pi_matkl.
* JH/02.07.98/4.0C (Ende)
*---- Herausfiltern der variantenbildenden Merkmale -------------------*
  PERFORM var_bildende_merkm USING pi_class pi_stosel.
*---- Merkmalsbewertungen zu den variantenbildenden Merkmalen lesen ---*
  PERFORM lese_bewertungen USING pi_stosel.

ENDFORM.                               " LESE_VB_MERKMALE

*&---------------------------------------------------------------------*
*&      Form  BWGRP_ZUM_WERK
*&---------------------------------------------------------------------*
*       Zum Werk die Basiswerksgruppe ermitteln. Falls keine Zuordnung
*       vorliegt, erfolgt die Zuordnung zur Dummygruppe 'Werke ohne
*       Gruppenzuordung'.
*----------------------------------------------------------------------*
*JH/17.08.98/4.5B/KPr1557931 (Anfang)
*FORM BWGRP_ZUM_WERK.
FORM bwgrp_zum_werk USING kunnr LIKE t001w-kunnr.
*JH/17.08.98/4.5B/KPr1557931 (Ende)

*---- Alle Zuordnungen des Werkes zu Basiswerksgruppen lesen ----------*
*---- Bei Verwendung der Klassenart '035' wird sichergestellt, daß ----*
*---- jedes Werk nur maximal einer Basiswerksgruppe zugeorndet ist ----*
*---- Wird für die Werksgruppierung die Klassenart '030' verwendet ----*
*---- kann es zu Mehrfachzuordnungen kommen, wobei dann einfach    ----*
*---- der erste Zuordnungssatz genommen wird                       ----*
  CLEAR werks_object.
*JH/17.08.98/4.5B/KPr1557931 (Anfang)
* WERKS_OBJECT = T_WERKS-WERKS.
  werks_object = kunnr.
*JH/17.08.98/4.5B/KPr1557931 (Ende)

  CALL FUNCTION 'CLAP_DDB_GET_CLASSIFICATION'
       EXPORTING
            object                 = werks_object
            obtab                  = werks_obtab
            classtype              = wkgrp_klart
            read_only              = 'X'
            called_from_api        = ' '
       IMPORTING
            error_statu            = ret_code
       TABLES
            allocations            = h_bwgrp
       EXCEPTIONS
            no_allocation          = 1
            set_aennr              = 2
            change_nr_not_exist    = 3
            date_in_past           = 4
            error_class            = 5
            error_date_restriction = 6
            error_status           = 7
            OTHERS                 = 8.

  DESCRIBE TABLE h_bwgrp LINES sy-tfill.
  IF ( sy-subrc NE 0 )
  OR ( ret_code NE 0 ).
    t_werks-bwgrp = dummy_bwgrp.
  ELSE.
*---- Der erste gefundene Eintrag wird genommen -----------------------*
    READ TABLE h_bwgrp INDEX 1.
    t_werks-bwgrp = h_bwgrp-class.
    READ TABLE t_bwgrp WITH KEY bwgrp = t_werks-bwgrp BINARY SEARCH.
    IF sy-subrc NE 0.
      t_bwgrp-bwgrp = h_bwgrp-class.
      t_bwgrp-bwgbz = h_bwgrp-kltxt.
      INSERT t_bwgrp INDEX sy-tabix.
    ENDIF.
  ENDIF.

ENDFORM.                               " BWGRP_ZUM_WERK

*&---------------------------------------------------------------------*
*&      Form  SOBKZ_EINLESEN
*&---------------------------------------------------------------------*
*       Prüfen, ob nur Sonderbestände zum Werk anzuzeigen sind und somit
*       nicht automatisch das Kennzeichen zum Anzeigen der Lagerort-
*       bestände gesetzt werden muß.
*----------------------------------------------------------------------*
FORM sobkz_einlesen.

  kz_nur_werksond = x.
  CLEAR kz_werksond.
  SELECT * FROM t148k
         WHERE unbkz IN s_sobkz.
*   ? Evtl. eleganter programmieren ?
*<<< Hier später evtl. weitere Sonderbestandstabellen berücksichtigen,
*    die LGORT nicht im Key haben.
    IF t148k-tbnam NE 'MSKU' AND       "Falls es sich um einen Sonder-
       t148k-tbnam NE 'MSLB' AND       "bestand handelt, der nicht zum
       t148k-tbnam NE 'MSCA' AND       "Werk geführt wird.
       t148k-tbnam NE 'MSCP' AND
       t148k-tbnam NE 'MSCS' AND
       t148k-tbnam NE 'MSCB'.
      CLEAR kz_nur_werksond.
    ELSE.
      kz_werksond = x.       "auf die Anzeige von Werkssonderbeständen
    ENDIF.                             "wird Wert gelegt!
  ENDSELECT.

ENDFORM.                               " SOBKZ_EINLESEN

*&---------------------------------------------------------------------*
*&      Form  SELEKTIONSEBENEN
*&---------------------------------------------------------------------*
*       Test, ob eine Erweiterung der Anzeigenebenen notwendig wird,
*       weil die angekreuzten Anzeigeebenen in Verbindung mit einer
*       Sonderbestandskennzeichen-Selektion keinen Sinn machen
*       Anmerkung:
*       P_KZSON steuert nur die Anzeige von Sonderbeständen auf Lager-
*       ortebene. Sonderbestand auf Werksebene wird immer angezeigt,
*       insofern die Werksebene angekreuzt ist, es sei denn es wurde in
*       S_SOBKZ eine Einschränkung auf Lagerortbestandsdaten hinterlegt.
*       Falls P_KZSON gesetzt ist müssen zumindest auch P_KZBWG und
*       P_KZWER gesetzt sein. Zusätzlich muß P_KZLGO gesetzt sein, wenn
*       über S_SOBKZ keine Einschränkung auf reine Werkssonderbestände
*       durchgeführt wurde.
*----------------------------------------------------------------------*
FORM selektionsebenen.

  CLEAR kz_w047.
  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_off.
    CLEAR: p_chrg,p_kzcha.
  ELSE.
    IF p_chrg EQ 'X'.
       p_kzlgo = 'X'.
    ENDIF.
  ENDIF.
  IF NOT p_kzson IS INITIAL.
    IF p_kzbwg IS INITIAL OR p_kzwer IS INITIAL.
*---- Fehler: Anzeigeebene 'Sonderbestand' ohne Anzeigeebene 'Werk' ---*
*----         oder 'Basiswerksgruppe'                               ---*
      MESSAGE w047.
      kz_w047 = x.
      p_kzbwg = x.
      p_kzwer = x.
    ENDIF.
    IF kz_nur_werksond IS INITIAL.
*---- P_KZLGO wird nicht autom. gesetzt, wenn keine Sonderbestände ----*
*---- zum Lagerort angezeigt werden sollen                         ----*
      IF p_kzlgo IS INITIAL.
        IF kz_w047 IS INITIAL.
*---- Fehler: Anzeigeebene 'Sonderbestand' ohne Anzeigeebene 'Lager- --*
*----         ort' obwohl Sonderbestände auf Lagerortebene gewünscht --*
*----         werden                                                 --*
          MESSAGE w047.
        ENDIF.
        p_kzlgo = x.
      ENDIF.
    ENDIF.
  ELSE.
    IF NOT p_chrg IS INITIAL.
      IF p_kzbwg  IS INITIAL
      OR p_kzwer  IS INITIAL
      OR p_kzlgo  IS INITIAL.
        MESSAGE w047.
        p_kzbwg = x.
        p_kzwer = x.
        p_kzlgo = x.
        IF p_kzseg IS INITIAL.
          p_kzcha = x.
        ENDIF.
ENHANCEMENT-POINT RWBE1F01_01 SPOTS ES_RWBEST01 .

      ENDIF.
    ELSEIF NOT p_kzlgo IS INITIAL.
      IF p_kzbwg IS INITIAL OR p_kzwer IS INITIAL.
*---- Fehler: nur Anzeigeebenen 'Lagerort' und 'Werk' oder 'Lagerort' -*
*----         und 'Basiswerksgruppe' oder nur 'Lagerort' angekreuzt   -*
        MESSAGE w047.
        p_kzbwg = x.
        p_kzwer = x.
      ENDIF.
    ELSE.
      IF NOT p_kzwer IS INITIAL.
        IF p_kzbwg IS INITIAL.
*---- Fehler: nur Anzeigeebene 'Werk' angekreuzt ----------------------*
          MESSAGE w047.
          p_kzbwg = x.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENHANCEMENT-SECTION RWBE1F01_G1 SPOTS ES_RWBEST01 .
  IF  p_scat IS NOT INITIAL.
    p_chrg  =  x.
    IF  p_kzcha IS INITIAL
    AND p_kzseg IS INITIAL.
      p_kzcha =  x.
    ENDIF.
    p_kzlgo =  x.
  ENDIF.
END-ENHANCEMENT-SECTION.

  GET PARAMETER ID 'WGEN_VAR' FIELD gv_parva.
  IF gv_parva EQ x.
    gv_tree = x.
  ENDIF.

  IF gv_tree EQ x.
    IF p_kzvstc EQ x AND
       p_chrg IS NOT INITIAL.
      MESSAGE e040(SGT_01).
    ENDIF.
  ENDIF.
ENDFORM.                               " SELEKTIONSEBENEN

*&---------------------------------------------------------------------*
*&      Form  LESE_BENUTZERSTAMM
*&---------------------------------------------------------------------*
*       Ermittelt Dezimalkomma und 1000er-Punkt aus Benutzerstamm zum
*       Aufbau der Anzeigeschablone für die Mengendarstellung in der
*       Matrix
*----------------------------------------------------------------------*
FORM lese_benutzerstamm.

  CALL FUNCTION 'CLSE_SELECT_USR01'
       EXPORTING
            username     = sy-uname
       IMPORTING
            decimal_sign = komma.
  CASE komma.
    WHEN ','.
      punkt = '.'.
    WHEN '.'.
      punkt = ','.
  ENDCASE.

ENDFORM.                               " LESE_BENUTZERSTAMM

*&---------------------------------------------------------------------*
*&      Form  SCHABLONE_AUFBAUEN
*&---------------------------------------------------------------------*
*       Aufbau der Schablone für die Anzeige der Mengen in der Matrix
*----------------------------------------------------------------------*
FORM schablone_aufbauen.

  schablone+3(1)  = punkt.
  schablone+7(1)  = punkt.
  schablone+11(1) = komma.

ENDFORM.                               " SCHABLONE_AUFBAUEN

*&---------------------------------------------------------------------*
*&      Form  LIEF_LTS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Mögliche Lieferantenteilsortimente zu allen Lieferanten vor-
*       blenden
*----------------------------------------------------------------------*
*FORM LIEF_LTS_ANZEIGEN. -> kann entfallen????
*
* SELECT * FROM WYT1T INTO TABLE T_WYT1T
*                     WHERE SPRAS = SY-LANGU
*                     ORDER BY LTSNR LIFNR.
*
*---- Anzuzeigende Felder zusammenstellen -----------------------------*
* CLEAR   T_FIELDS.
* REFRESH T_FIELDS.
* T_FIELDS-TABNAME    = 'WYT1'.  T_FIELDS-FIELDNAME  = 'LTSNR'.
* T_FIELDS-SELECTFLAG = 'X'.     APPEND T_FIELDS.
* T_FIELDS-TABNAME    = 'WYT1T'. T_FIELDS-FIELDNAME  = 'LTSBZ'.
* T_FIELDS-SELECTFLAG = ' '.     APPEND T_FIELDS.
* T_FIELDS-TABNAME    = 'WYT1'.  T_FIELDS-FIELDNAME  = 'LIFNR'.
* T_FIELDS-SELECTFLAG = ' '.     APPEND T_FIELDS.
*
*---- Anzuzeigende Werte zusammenstellen ------------------------------*
* CLEAR   T_VALUES.
* REFRESH T_VALUES.
* LOOP AT T_WYT1T.
*   T_VALUES-VALUE = T_WYT1T-LTSNR. APPEND T_VALUES.
*   T_VALUES-VALUE = T_WYT1T-LTSBZ. APPEND T_VALUES.
*   T_VALUES-VALUE = T_WYT1T-LIFNR. APPEND T_VALUES.
* ENDLOOP.
*
* DATA: BEGIN OF SEL_VALUES OCCURS 3.
*         INCLUDE STRUCTURE HELP_VTAB.
* DATA: END   OF SEL_VALUES.
*
*---- Eingabemöglichkeiten anzeigen -----------------------------------*
* CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE_EXT'
*      EXPORTING
*           FIELDNAME                     = 'LTSNR'
*           TABNAME                       = 'WYT1'
*      IMPORTING
*           INDEX                         = SY-TABIX
*           SELECT_VALUE                  = P_LTSNR
*      TABLES
*           FIELDS                        = T_FIELDS
*           SELECT_VALUES                 = SEL_VALUES
*           VALUETAB                      = T_VALUES.
*
* IF NOT P_LTSNR IS INITIAL.
*   READ TABLE SEL_VALUES WITH KEY TABNAME   = 'WYT1'
*                                  FIELDNAME = 'LIFNR'.
*   IF SY-SUBRC NE 0.
*     MESSAGE A038 WITH 'SEL_VALUES'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*   ENDIF.
*
*   P_LIFNR = SEL_VALUES-VALUE.
* ENDIF.
*
*ENDFORM.                    " LIEF_LTS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  LTS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Mögliche Lieferantenteilsortimente als Eingabehilfe vorblenden
*----------------------------------------------------------------------*
*FORM LTS_ANZEIGEN. -> kann entfallen????
*
* SELECT * FROM WYT1T INTO TABLE T_WYT1T
*                     WHERE SPRAS = SY-LANGU
*                       AND LIFNR = P_LIFNR.
*
*---- Anzuzeigende Felder zusammenstellen -----------------------------*
* CLEAR   T_FIELDS.
* REFRESH T_FIELDS.
* T_FIELDS-TABNAME    = 'WYT1'.  T_FIELDS-FIELDNAME  = 'LTSNR'.
* T_FIELDS-SELECTFLAG = 'X'.     APPEND T_FIELDS.
* T_FIELDS-TABNAME    = 'WYT1T'. T_FIELDS-FIELDNAME  = 'LTSBZ'.
* T_FIELDS-SELECTFLAG = ' '.     APPEND T_FIELDS.
*
*---- Anzuzeigende Werte zusammenstellen ------------------------------*
* CLEAR   T_VALUES.
* REFRESH T_VALUES.
* LOOP AT T_WYT1T.
*   T_VALUES-VALUE = T_WYT1T-LTSNR. APPEND T_VALUES.
*   T_VALUES-VALUE = T_WYT1T-LTSBZ. APPEND T_VALUES.
* ENDLOOP.
*
*---- Eingabemöglichkeiten anzeigen -----------------------------------*
* CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
*      EXPORTING
*           FIELDNAME                     = 'LTSNR'
*           TABNAME                       = 'WYT1'
*      IMPORTING
*           SELECT_VALUE                  = P_LTSNR
*      TABLES
*           FIELDS                        = T_FIELDS
*           VALUETAB                      = T_VALUES.
*
*ENDFORM.                    " LTS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  LESE_EK_INFO
*&---------------------------------------------------------------------*
*       Liest zum Lieferanten bzw. zum Lieferanten und dem LTS die vor-
*       liegenden Einkaufsinfosätze, um die vom Lieferant lieferbaren
*       Materialien zusammenzustellen
*----------------------------------------------------------------------*
FORM lese_ek_info.

  DATA: ltskz LIKE lfa1-ltsna.

*---- LTS beim Lesen berücksichtigen? ---------------------------------*
  IF p_ltsnr IS INITIAL.
    CLEAR ltskz.
  ELSE.
    ltskz = x.
  ENDIF.

  REFRESH t_liefmat.

*---- Einkaufsinfosätze ermitteln -------------------------------------*
  CALL FUNCTION 'VENDOR_MASTER_DATA_SELECT_03'
       EXPORTING
            pi_ltskz  = ltskz
            pi_lifnr  = p_lifnr
            pi_ltsnr  = p_ltsnr
            pi_cvp_behavior = '4'                         "note 2269110
       TABLES
            pe_t_eina = t_liefmat
       EXCEPTIONS
            not_found = 1
            OTHERS    = 2.

  CASE sy-subrc.
    WHEN 1.
      p_field = 'P_LIFNR'.
      IF p_ltsnr IS INITIAL.
        MESSAGE s061.
*    Zum eingegebenen Lieferanten sind keine Einkaufsinfosatzdaten vorha
      ELSE.
        MESSAGE s062.
*    Zum eingegebenen LTS des Lief. sind keine Einkaufsinfosatzdaten vor
      ENDIF.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    WHEN 2.
      p_field = 'P_LIFNR'.
      MESSAGE s063.
*    Fehler beim Lesen der Einkaufsinfosatzdaten des Lieferanten/LTS
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
  ENDCASE.

  SORT t_liefmat BY matnr lifnr ltsnr.

ENDFORM.                               " LESE_EK_INFO

*&---------------------------------------------------------------------*
*&      Form  MAT_ENTFERNEN
*&---------------------------------------------------------------------*
*       Alle Materialien, für die keine EK-Infosatz zum gegebenen
*       Lieferanten/LTS vorliegt, aus der Materialselektionsmenge
*       entfernen
*----------------------------------------------------------------------*
FORM mat_entfernen.

  LOOP AT t_matnr.
    IF p_ltsnr IS INITIAL.
      READ TABLE t_liefmat WITH KEY matnr = t_matnr-matnr
                                    lifnr = p_lifnr
                           TRANSPORTING NO FIELDS
                           BINARY SEARCH.
    ELSE.
      READ TABLE t_liefmat WITH KEY matnr = t_matnr-matnr
                                    lifnr = p_lifnr
                                    ltsnr = p_ltsnr
                           TRANSPORTING NO FIELDS
                           BINARY SEARCH.
    ENDIF.

    IF sy-subrc NE 0.
* JH/24.11.97/1.2B3 (Anfang)
* Bei Varianten bei fehlendem Einkaufsinfosatz auch den Einkaufsinfos.
* des Sammelartikels testen
      IF t_matnr-attyp = attyp_var.
        IF p_ltsnr IS INITIAL.
          READ TABLE t_liefmat WITH KEY matnr = t_matnr-satnr
                                        lifnr = p_lifnr
                               TRANSPORTING NO FIELDS
                               BINARY SEARCH.
        ELSE.
          READ TABLE t_liefmat WITH KEY matnr = t_matnr-satnr
                                        lifnr = p_lifnr
                                        ltsnr = p_ltsnr
                               TRANSPORTING NO FIELDS
                               BINARY SEARCH.
        ENDIF.
        IF sy-subrc NE 0.
          DELETE t_matnr.
        ENDIF.
      ELSE.
* JH/24.11.97/1.2B3 (Ende)
        DELETE t_matnr.
      ENDIF.                           "JH/24.11.97/1.2B3
    ENDIF.
  ENDLOOP.

ENDFORM.                               " MAT_ENTFERNEN

*&---------------------------------------------------------------------*
*&      Form  WKGRP_AUSWAEHLEN
*&---------------------------------------------------------------------*
*       Auswahl einer Werksgruppe über Matchcodesuche (-> manuelle F4-
*       Hilfe, weil evtl. noch eine Auswahl bzgl. der Klassenart er-
*       folgen muß
*----------------------------------------------------------------------*
FORM wkgrp_auswaehlen.

*---- Klassenart für Gruppierung von Werken bestimmen -----------------*
  PERFORM wkgrp_klart_lesen.

*---- Matchcodeauswahlmöglichkeit aufrufen ----------------------------*
*//JH 23.09.96 (Anfang)
* Aufruf der Mehrfachselek. durch Aufruf der Einfachselek. ersetzt
* DATA: BEGIN OF F4_SEL_TAB OCCURS 10.
*        INCLUDE STRUCTURE F4MCHLP4.  "Zurückgelieferte Selektionswerte
* DATA: END   OF F4_SEL_TAB.
*
* CALL FUNCTION 'F4_MACO_MULTI_RECORDS'
*      EXPORTING
*           MCONAME              = 'BETK'
**          SELSTR               = ' '
**          STARTING_X           = 1
**          STARTING_Y           = 1
*      TABLES
*           RECORD_TAB           = F4_SEL_TAB
*      EXCEPTIONS
*           USER_CANCEL          = 1
*           NO_DATA_FOUND        = 2
*           NO_VALUES_SELECTED   = 3
*           UNKNOWN_ID           = 4
*           RETURN_FIELD_MISSING = 5
*           INTERNAL_ERROR       = 6
*           OTHERS               = 7.
*
* IF SY-SUBRC = 0.
*---- Falls mehrere Einträge selektiert wurden, wird nur der erste ----*
*---- zurückgeliefert                                              ----*
*   READ TABLE F4_SEL_TAB INDEX 1.
*   P_WKGRP = F4_SEL_TAB-FIELDVAL.
* ELSEIF SY-SUBRC BETWEEN 1 AND 3.
*---- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
*---- -> nix ändern                                                  --*
* ELSE.
*   MESSAGE A046.
**   Bei der Anzeige der möglichen Werksgruppen ist ein Fehler aufgetret
* ENDIF.

* JH/14.10.98/99.A (Anfang)
* FB F4_MACO ab 99.A nicht mehr verfügbar, ersetzt durch FB
* F4IF_FIELD_VALUE_REQUEST
*
* DATA SEL_VALUE LIKE F4MCHLP4-FIELDVAL. "Zurückgelieferter Selekt.wert
*
* CALL FUNCTION 'F4_MACO'
*      EXPORTING
*           MCONAME        = 'BETK'
**          SELSTR         = ' '
**          STARTING_X     = 1
**          STARTING_Y     = 1
*      IMPORTING
*           RETURN_VALUE   = SEL_VALUE
*      EXCEPTIONS
*           USER_CANCEL    = 1
*           NO_DATA_FOUND  = 2
*           UNKNOWN_ID     = 3
*           INTERNAL_ERROR = 4
*           OTHERS         = 5.
*
* IF SY-SUBRC = 0.
**--- Ausgewähltem Wert übergeben -------------------------------------*
*   P_WKGRP = SEL_VALUE.
* ELSEIF SY-SUBRC BETWEEN 1 AND 2.
**--- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
**--- -> nix ändern                                                  --*
* ELSE.
*   MESSAGE A046.
**   Bei der Anzeige der möglichen Werksgruppen ist ein Fehler aufgetret
* ENDIF.
  DATA: f4_sel_tab LIKE ddshretval OCCURS 0 WITH HEADER LINE.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
       EXPORTING
            tabname           = space
            fieldname         = space
            searchhelp        = 'BETK'
            multiple_choice   = ' '
            display           = ' '
       TABLES
            return_tab        = f4_sel_tab
       EXCEPTIONS
            field_not_found   = 1
            no_help_for_field = 2
            inconsistent_help = 3
            no_values_found   = 4
            OTHERS            = 5.

  IF sy-subrc = 0.
*---- Ausgewähltem Wert übergeben -------------------------------------*
    READ TABLE f4_sel_tab INDEX 1.
    IF sy-subrc = 0.
      p_wkgrp = f4_sel_tab-fieldval.
    ENDIF.
  ELSEIF sy-subrc = 4.
*---- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
*---- -> nix ändern                                                  --*
  ELSE.
    MESSAGE a046.
*    Bei der Anzeige der möglichen Werksgruppen ist ein Fehler aufgetret
  ENDIF.
* JH/14.10.98/99.A (Ende)
*//JH 23.09.96 (Ende)

ENDFORM.                               " WKGRP_AUSWAEHLEN

*&---------------------------------------------------------------------*
*&      Form  WKGRP_KLART_LESEN
*&---------------------------------------------------------------------*
*       Bestimme die Klassenart zur geg. Applikationsklasse über die
*       die Gruppierung von Werken erfolgt.
*       Falls für die Werksgruppierungen mehrere Klassenarten zur Ver-
*       fügung stehen, muß vom Anwender eine Auswahl getroffen werden.
*----------------------------------------------------------------------*
FORM wkgrp_klart_lesen.

*---- Klassenart zur Gruppierung von Werken lesen/auswählen, falls ----*
*---- noch nicht geschehen                                         ----*
  IF wkgrp_klart IS INITIAL.
    CALL FUNCTION 'WR20_SELECT_CLASSTYPE'
         EXPORTING
              i_bgapp            = appl_klasse
              i_popup            = 'X'
         IMPORTING
              o_klart            = wkgrp_klart
         EXCEPTIONS
              invalid_parameters = 1
              no_entries_found   = 2
              one_entry_found    = 3
              more_entries_found = 4
              user_abbort        = 5
              OTHERS             = 6.

    IF ( sy-subrc = 1 ) OR ( sy-subrc = 2 ) OR ( sy-subrc = 6 ).
      CLEAR wkgrp_klart.
      MESSAGE a004.
*    Für die Bestandsübersicht ist keine Werksklassenart gepflegt!
    ELSEIF sy-subrc = 5.
      CLEAR wkgrp_klart.
      p_field = 'P_WKGRP'.
      MESSAGE s079.
*    Sie müssen eine Klassenart für die Gruppierung von Werken auswählen
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
      PERFORM neustart_fehler.
    ENDIF.

*---- Beim Aufruf der F4-Werthilfe bei Werksgruppen soll die entspr. --*
*---- Klassenart vorgeblendet werden.                                --*
    SET PARAMETER ID 'KAR' FIELD wkgrp_klart.
  ENDIF.

ENDFORM.                               " WKGRP_KLART_LESEN

*&---------------------------------------------------------------------*
*&      Form  MATKL_AUSWAEHLEN
*&---------------------------------------------------------------------*
*       Auswahl einer Warengruppe über Matchcodesuche (-> manuelle F4-
*       Hilfe, weil danach noch SET/GET-Parameter für 'KAR' zurück-
*       gesetzt werden muß
*----------------------------------------------------------------------*
FORM matkl_auswaehlen.

*---- Matchcodeauswahlmöglichkeit aufrufen ----------------------------*
*//JH 23.09.96 (Anfang)
* Aufruf der Mehrfachselek. durch Aufruf der Einfachselek. ersetzt
* DATA: BEGIN OF F4_SEL_TAB OCCURS 10.
*        INCLUDE STRUCTURE F4MCHLP4.  "Zurückgelieferte Selektionswerte
* DATA: END   OF F4_SEL_TAB.
*
* CALL FUNCTION 'F4_MACO_MULTI_RECORDS'
*      EXPORTING
*           MCONAME              = 'WWG1'
**          SELSTR               = ' '
**          STARTING_X           = 1
**          STARTING_Y           = 1
*      TABLES
*           RECORD_TAB           = F4_SEL_TAB
*      EXCEPTIONS
*           USER_CANCEL          = 1
*           NO_DATA_FOUND        = 2
*           NO_VALUES_SELECTED   = 3
*           UNKNOWN_ID           = 4
*           RETURN_FIELD_MISSING = 5
*           INTERNAL_ERROR       = 6
*           OTHERS               = 7.
*
* IF SY-SUBRC = 0.
*---- Falls mehrere Einträge selektiert wurden, wird nur der erste ----*
*---- zurückgeliefert                                              ----*
*   READ TABLE F4_SEL_TAB INDEX 1.
*   P_MATKL = F4_SEL_TAB-FIELDVAL.
* ELSEIF SY-SUBRC BETWEEN 1 AND 3.
*---- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
*---- -> nix ändern                                                  --*
* ELSE.
*   MESSAGE A077.
**   Bei der Anzeige der möglichen Warengruppen ist ein Fehler aufgetret
* ENDIF.

* JH/14.10.98/99.A (Anfang)
* FB F4_MACO ab 99.A nicht mehr verfügbar, ersetzt durch FB
* F4IF_FIELD_VALUE_REQUEST
*
* DATA SEL_VALUE LIKE F4MCHLP4-FIELDVAL. "Zurückgelieferter Selekt.wert
*
* CALL FUNCTION 'F4_MACO'
*      EXPORTING
*           MCONAME        = 'WWG1'
**          SELSTR         = ' '
**          STARTING_X     = 1
**          STARTING_Y     = 1
*      IMPORTING
*           RETURN_VALUE   = SEL_VALUE
*      EXCEPTIONS
*           USER_CANCEL    = 1
*           NO_DATA_FOUND  = 2
*           UNKNOWN_ID     = 3
*           INTERNAL_ERROR = 4
*           OTHERS         = 5.
*
* IF SY-SUBRC = 0.
**--- Ausgewähltem Wert übergeben -------------------------------------*
*   P_MATKL = SEL_VALUE.
* ELSEIF SY-SUBRC BETWEEN 1 AND 2.
**--- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
**--- -> nix ändern                                                  --*
* ELSE.
*   MESSAGE A077.
**   Bei der Anzeige der möglichen Warengruppen ist ein Fehler aufgetret
* ENDIF.
  DATA: f4_sel_tab LIKE ddshretval OCCURS 0 WITH HEADER LINE.

* Reset des Parameters das Warengruppensuchhilfe selbst definiert * * *
* Hinweis BKE/433663
  SET PARAMETER ID 'KAR' FIELD SPACE.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
       EXPORTING
            tabname           = space
            fieldname         = space
            searchhelp        = 'WWG1'
            multiple_choice   = ' '
            display           = ' '
       TABLES
            return_tab        = f4_sel_tab
       EXCEPTIONS
            field_not_found   = 1
            no_help_for_field = 2
            inconsistent_help = 3
            no_values_found   = 4
            OTHERS            = 5.

  IF sy-subrc = 0.
*---- Ausgewähltem Wert übergeben -------------------------------------*
    READ TABLE f4_sel_tab INDEX 1.
    IF sy-subrc = 0.
      p_matkl = f4_sel_tab-fieldval.
    ENDIF.
  ELSEIF sy-subrc = 4.
*---- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
*---- -> nix ändern                                                  --*
  ELSE.
    MESSAGE a077.
*    Bei der Anzeige der möglichen Warengruppen ist ein Fehler aufgetret
  ENDIF.
* JH/14.10.98/99.A (Ende)
*//JH 23.09.96 (Ende)

ENDFORM.                               " MATKL_AUSWAEHLEN

*&---------------------------------------------------------------------*
*&      Form  LESEN_T001W
*&---------------------------------------------------------------------*
*       Werkstammdaten bestimmen
*----------------------------------------------------------------------*
*  -->  T_WLIST   Liste von Werksidentifikatoren
*----------------------------------------------------------------------*
FORM lesen_t001w TABLES t_wlist STRUCTURE h_werks.

  SELECT * FROM  t001w  INTO TABLE t_t001w
                        FOR ALL ENTRIES IN t_wlist
      WHERE  werks = t_wlist-werks.

  IF sy-subrc NE 0.
    CASE werk_sel.
      WHEN vtrli_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s008 WITH text-009.
*    Keine Stammdaten zu den Werken der angegebenen & gefunden!
      WHEN vkorg_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s008 WITH text-010.
*    Keine Stammdaten zu den Werken der angegebenen & gefunden!
      WHEN werks_belegt.
        p_field = 'S_WERKS-LOW'.
        MESSAGE s036.
*   Keine Stammdaten zu den selektierten Werken gefunden
      WHEN OTHERS.                     "keine Eingabe bei Werksselektion
        p_field = 'P_WKGRP'.
        MESSAGE s036.
*   Keine Stammdaten zu den selektierten Werken gefunden
    ENDCASE.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

  SORT t_t001w ASCENDING BY werks.

ENDFORM.                               " LESEN_T001W

*&---------------------------------------------------------------------*
*&      Form  LESEN_T001K
*&---------------------------------------------------------------------*
*       Bewertungskreisdaten bestimmen
*----------------------------------------------------------------------*
FORM lesen_t001k.

  SELECT * FROM  t001k  INTO TABLE t_t001k
                        FOR ALL ENTRIES IN t_t001w
      WHERE  bwkey = t_t001w-bwkey.

  IF sy-subrc NE 0.
    CASE werk_sel.
      WHEN vtrli_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s082 WITH text-009.
*   Keine Bewertungskreisdaten zu den Werken der angegebenen & gefunden
      WHEN vkorg_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s082 WITH text-010.
*   Keine Bewertungskreisdaten zu den Werken der angegebenen & gefunden
      WHEN werks_belegt.
        p_field = 'S_WERKS-LOW'.
        MESSAGE s083.
*   Keine Bewertungskreisdaten zu den selektierten Werken gefunden
      WHEN OTHERS.                     "keine Eingabe bei Werksselektion
        p_field = 'P_WKGRP'.
        MESSAGE s083.
*   Keine Bewertungskreisdaten zu den selektierten Werken gefunden
    ENDCASE.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

  SORT t_t001k ASCENDING BY bwkey.

ENDFORM.                               " LESEN_T001K

*&---------------------------------------------------------------------*
*&      Form  LESEN_T001
*&---------------------------------------------------------------------*
*       Buchungskreisdaten bestimmen
*----------------------------------------------------------------------*
FORM lesen_t001.

  SELECT * FROM  t001  INTO TABLE t_t001
                        FOR ALL ENTRIES IN t_t001k
      WHERE  bukrs = t_t001k-bukrs.

  IF sy-subrc NE 0.
    CASE werk_sel.
      WHEN vtrli_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s084 WITH text-009.
*   Keine Buchungskreisdaten zu den Werken der angegebenen & gefunden
      WHEN vkorg_belegt.
        p_field = 'P_VKORG'.
        MESSAGE s084 WITH text-010.
*   Keine Buchungskreisdaten zu den Werken der angegebenen & gefunden
      WHEN werks_belegt.
        p_field = 'S_WERKS-LOW'.
        MESSAGE s085.
*   Keine Buchungskreisdaten zu den selektierten Werken gefunden
      WHEN OTHERS.                     "keine Eingabe bei Werksselektion
        p_field = 'P_WKGRP'.
        MESSAGE s085.
*   Keine Buchungskreisdaten zu den selektierten Werken gefunden
    ENDCASE.
*---- Selektionsbild neu prozessieren (bereits selektierte Merkmals- --*
*---- daten gehen verloren)
    PERFORM neustart_fehler.
  ENDIF.

  SORT t_t001 ASCENDING BY bukrs.

ENDFORM.                               " LESEN_T001
*&---------------------------------------------------------------------*
*&      Form  PARAM_ALV_CHK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM param_alv_chk.
*----chek ALV Tree and P-kzngc ?---------------------------------------*
  IF NOT p_kzngc IS INITIAL .
        message i099.
     clear p_kzngc.
  ENDIF.
  IF p_kzbwg IS INITIAL OR p_kzwer IS INITIAL.
     message i100.
    p_kzbwg = 'X'.
    p_kzwer = 'X'.
   ENDIF.
*-check params with ALVTRee  // tga 11.11.99 end

ENDFORM.                    " PARAM_ALV_CHK

*&---------------------------------------------------------------------*
*&      Form  LAYOUT_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM LAYOUT_CHECK.
 MOVE sy-repid TO ls_variant-report.
 IF NOT p_alvvar IS INITIAL.
  MOVE p_alvvar TO ls_variant-variant.

  CALL FUNCTION 'LVC_VARIANT_EXISTENCE_CHECK'
    EXPORTING
      I_SAVE              = 'A'
    CHANGING
      CS_VARIANT          = ls_variant
   EXCEPTIONS
      WRONG_INPUT         = 1
      NOT_FOUND           = 2
      PROGRAM_ERROR       = 3
      OTHERS              = 4.
  IF SY-SUBRC <> 0.
   MESSAGE e101.
  ENDIF.
 ENDIF.

ENDFORM.                    " LAYOUT_CHECK
