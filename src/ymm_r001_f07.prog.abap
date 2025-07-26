*-------------------------------------------------------------------
***INCLUDE RWBE1F07 .
*  Anzeige von Bestandsdaten in Einzelliste
*  (analog RMMMBEFE)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  E00_EINZEL_LISTE
*&---------------------------------------------------------------------*
*       Einzelliste anzeigen (-> alle für die Einzelliste gepflegten   *
*       Bestandsarten zur ausgewählten Organisationsebene)             *
*----------------------------------------------------------------------*
FORM e00_einzel_liste.

*---- Die Daten des HIDE-Bereiches wurden in die entsprechenden Var. --*
*---- ZLE-..., zeilen_kz,... zurückgeschrieben                       --*
  kz_list = einzel_liste.
  IF  drilldown_level = artlist_level. " TGA/99.A/10.06.99 KZNGC
    READ TABLE t_matnr WITH KEY matnr = zle-matnr. "TGA/99.A/10.06.99
  ENDIF.                               " TGA/99.A/10.06.99 KZNGC
  CASE zeilen_kz.
    WHEN ges_zeile.
      PERFORM einzelanzeige_ges.
    WHEN man_zeile.
      PERFORM einzelanzeige_man.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*   WHEN BUK_ZEILE.
*      PERFORM EINZELANZEIGE_BUK.
    WHEN wgr_zeile.
      PERFORM einzelanzeige_wgr.
    WHEN wrk_zeile.
      IF sond_kz IS INITIAL.
        PERFORM einzelanzeige_wrk.
      ELSE.
        PERFORM einzelanzeige_wrk_sond.
      ENDIF.
    WHEN lag_zeile.
      IF sond_kz IS INITIAL.
        PERFORM einzelanzeige_lgo.
      ELSE.
        PERFORM einzelanzeige_lgo_sond.
      ENDIF.
    WHEN ch_zeile.
      IF sond_kz IS INITIAL.
        PERFORM einzelanzeige_ch.
      ELSE.
        PERFORM einzelanzeige_ch_sond.
      ENDIF.

*   WHEN CHA_ZEILE.     ????entfällt
*     IF sond_kz IS INITIAL.
*        PERFORM EINZELANZEIGE_CHA.
*     ELSE.
*       IF sond_kz = KONSILIEF  OR
*          sond_kz = AUFBSKUNDE OR
*          sond_kz = MTVERPACK  OR
*          sond_kz = PRJBESTAND.
*          PERFORM EINZELANZEIGE_SOND.        "Sonderbestände zum LgOrt
*       ELSE.
*          PERFORM EINZELANZEIGE_WRK_SOND.   "Sonderbestände zum Werk
*       ENDIF.
*     ENDIF.
    WHEN OTHERS.
      MESSAGE i028.
*    Cursor bitte innerhalb einer Bestandszeile positionieren!
  ENDCASE.
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " E00_EINZEL_LISTE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_FELDER
*&---------------------------------------------------------------------*
*       Bestimmen der Anzeige-Felder für die Einzelliste der jeweiligen
*       Organisationsebene.
*       In der Tabelle T136V sind je Bestandszeile und Sonderbestands-
*       kennzeichen die gewünschten Felder festgelegt.
*       Falls kein Eintrag in der Tabelle T136V vorhanden ist, werden
*       alle möglichen Felder der Einzelanzeige (T136E) ermittelt
*       (bspw. für die Organisationsebene 0 = Summe der Gesamtbestände
*       aller Materialien einer Liste).
*-----------------------------------------------------------------------
FORM einzelanzeige_felder.

  DATA: hspanr LIKE t136v-spanr.     "//JH zu 1.2A1 (s.a. intPr 197005)

  CLEAR   einzel_anzeige.
  REFRESH einzel_anzeige.
  CLEAR   r_fname.             "//JH zu 1.2A1 (s.a. intPr 197005)
  REFRESH r_fname.

  IF p_kzlon IS INITIAL        "//JH zu 1.2A1 (s.a. intPr 197005)
  OR p_kzlso IS INITIAL.
*---- Falls das Kennzeichen 'Offene Bestände mitselektieren' nicht ----*
*---- gesetzt ist, werden automatisch alle Bestandszeilen, die zur ----*
*---- Anzeige von offenen Bestandsmengen dienen, aus der List-     ----*
*---- anzeige in der Einzelliste herausgenommen.                   ----*
*---- Falls das Kennzeichen 'Sonderbestände mitselektieren' nicht  ----*
*---- gesetzt ist, werden automatisch alle Bestandszeilen, die zur ----*
*---- Anzeige von Sonderbeständen dienen, aus der Listanzeige in   ----*
*---- der Einzelliste herausgenommen.                              ----*
    PERFORM fuelle_fname_range.
  ENDIF.

  IF zeilen_kz = ges_zeile.
*---- Für die Summe der Gesamtbestände aller Materialien einer Liste --*
*---- sind keine Anzeigefelder hinterlegt -> es macht Sinn, die gl.  --*
*---- Felder wie für die Mandantenbestände zu nehmen                 --*
    MOVE man_zeile TO t136v-bestz.
  ELSE.
    MOVE zeilen_kz TO t136v-bestz.
  ENDIF.
  MOVE sond_kz   TO t136v-sobkz.

* SELECT * FROM T136V              "//JH zu 1.2A1 (s.a. intPr 197005)
*       WHERE BESTZ = T136V-BESTZ
*       AND   SOBKZ = T136V-SOBKZ.
  SELECT * FROM t136v
        WHERE bestz =  t136v-bestz
        AND   sobkz =  t136v-sobkz
        AND   bfnae IN r_fname.

* begin of insertion n_1790328
    CHECK t136v-bfnae NE 'WSB7O' AND
          t136v-bfnae NE 'WSB9O' AND
          t136v-bfnae NE 'WESB7' AND
          t136v-bfnae NE 'WESB9' AND
          t136v-bfnae NE 'WESBB' AND
          t136v-bfnae NE 'LBUML' AND
          t136v-bfnae NE 'KUUML' AND
          t136v-bfnae NE 'KASIT'.
* end of insertion n_1790328

    MOVE-CORRESPONDING t136v TO einzel_anzeige.

    CLEAR t157b.
    SELECT SINGLE * FROM t157b
          WHERE spras = sy-langu
          AND   feldv = t136v-bfnae.

    MOVE t157b-ftext TO einzel_anzeige-text.
    APPEND einzel_anzeige.
  ENDSELECT.

  IF sy-subrc NE 0.
*---- kein Eintrag in Tabelle T136V -----------------------------------*
    CLEAR einzel_anzeige-spanr.
*   SELECT * FROM T136E.                          "//JH zu 1.2A1
    SELECT * FROM t136e WHERE fname IN r_fname.   "(s.a. intPr 197005)

* begin of insertion n_1790328
      CHECK t136e-fname NE 'WSB7O' AND
            t136e-fname NE 'WSB9O' AND
            t136e-fname NE 'WESB7' AND
            t136e-fname NE 'WESB9' AND
            t136e-fname NE 'WESBB' AND
            t136e-fname NE 'LBUML' AND
            t136e-fname NE 'KUUML' AND
            t136e-fname NE 'KASIT'.
* end of insertion n_1790328

      einzel_anzeige-spanr = einzel_anzeige-spanr + 1.
      MOVE t136e-fname TO einzel_anzeige-bfnae.

      SELECT SINGLE * FROM t157b
          WHERE spras = sy-langu
          AND   feldv = t136e-fname.

      MOVE t157b-ftext TO einzel_anzeige-text.
      APPEND einzel_anzeige.
    ENDSELECT.
  ELSE.             "//JH zu 1.2A1 (s.a. intPr 197005)
*---- Eintrag in Tabelle T136V gefunden -------------------------------*
    SORT einzel_anzeige ASCENDING BY spanr.

    IF p_kzlon IS INITIAL
    OR p_kzlso IS INITIAL.
*---- Falls nicht alle im Customizing hinterlegten Bestandszeilen  ----*
*---- zur Anzeige kommen, müssen die Zeilennummern u.U. neu durch- ----*
*---- numeriert werden                                             ----*
      hspanr = 1.
      LOOP AT einzel_anzeige.
        IF einzel_anzeige-spanr <> hspanr.
          einzel_anzeige-spanr = hspanr.
          MODIFY einzel_anzeige.
        ENDIF.
        hspanr = hspanr + 1.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_FELDER

*&---------------------------------------------------------------------*
*&      Form  EINZEL_ZEILE_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe einer Einzel-Zeile der Einzelliste
*----------------------------------------------------------------------*
FORM einzel_zeile_write.

  DATA: wa_einzelanz_mbwl LIKE LINE OF gt_einzelanz_mbwl.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:  /1  sy-vline,
             2  einzel_anzeige-text.     "Klartext - Bestandsfeld
    WRITE:  19  sy-vline.
    IF p_kzngc IS INITIAL.               "TGA/19.03.99/KZNGC
      WRITE 20(18) <d0>.                 "Bestand
    ELSE.                                "TGA/19.03.99/KZNGC
      WRITE 20(18) <d0> UNIT t_matnr-meins.  "TGA/19.03.99/KZNGC
    ENDIF.                               "TGA/19.03.99/KZNGC
    IF <d0> < 0.                         "Minus-Zeichen rot einfärben
      WRITE 37 minus COLOR COL_NEGATIVE.
    ENDIF.
    WRITE   38  sy-vline.
    FORMAT COLOR OFF.
    WRITE  39 space42.
  ELSE.
* Bestandsart und -text für M/B/W/L/C schreiben
    WRITE einzel_anzeige-text TO wa_einzelanz_mbwl-bstartxt.
    IF p_kzngc IS INITIAL.
      WRITE <d0> TO wa_einzelanz_mbwl-bstndtxt.
    ELSE.
      WRITE <d0> UNIT t_matnr-meins TO wa_einzelanz_mbwl-bstndtxt.
    ENDIF.

    APPEND wa_einzelanz_mbwl TO gt_einzelanz_mbwl.
  ENDIF.
ENDFORM.                               " EINZEL_ZEILE_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZEL_ZEILE_SOND_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe einer Einzel-Zeile der Einzelanzeige bei Sonderbeständen
*----------------------------------------------------------------------*
FORM einzel_zeile_sond_write.

* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:  /1  sy-vline,
             6  einzel_anzeige-text.     "Klartext - Bestandsfeld
    IF p_kzngc IS INITIAL.               "TGA/19.03.99/KZNGC
      WRITE:  24(18)  <d0>.              "Bestand
    ELSE.                                "TGA/19.03.99/KZNGC
      WRITE:  24(18)  <d0>  UNIT t_matnr-meins.    "TGA/19.03.99/KZNGC
    ENDIF.                               "TGA/19.03.99/KZNGC
    IF <d0> < 0.                         "Minus-Zeichen rot einfärben
      WRITE 41 minus COLOR COL_NEGATIVE.
    ENDIF.
    WRITE   42  sy-vline.
    FORMAT COLOR OFF.
    WRITE  43 space38.
  ELSE.
    CASE sond_kz.

      WHEN beistlief.
        WRITE einzel_anzeige-text TO wa_einzelanz_lief-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_lief-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_lief-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_lief TO gt_einzelanz_lief.

      WHEN konsikunde.
        WRITE einzel_anzeige-text TO wa_einzelanz_kd-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_kd-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_kd-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_kd TO gt_einzelanz_kd.          "#EC ENHOK

      WHEN lrgutkunde.
        WRITE einzel_anzeige-text TO wa_einzelanz_kd-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_kd-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_kd-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_kd TO gt_einzelanz_kd.          "#EC ENHOK

      WHEN aufbskunde.
        WRITE einzel_anzeige-text TO wa_einzelanz_auf-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_auf-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_auf-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_auf TO gt_einzelanz_auf.        "#EC ENHOK

      WHEN konsilief.
        WRITE einzel_anzeige-text TO wa_einzelanz_lief-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_lief-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_lief-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_lief TO gt_einzelanz_lief.      "#EC ENHOK

      WHEN mtverpack.
        WRITE einzel_anzeige-text TO wa_einzelanz_lief-bstartxt.
        IF p_kzngc IS INITIAL.
          WRITE <d0> TO wa_einzelanz_lief-bstndtxt.
        ELSE.
          WRITE <d0>  UNIT t_matnr-meins TO wa_einzelanz_lief-bstndtxt.
        ENDIF.
        APPEND wa_einzelanz_lief TO gt_einzelanz_lief.      "#EC ENHOK
    ENDCASE.
  ENDIF.
ENDFORM.                               " EINZEL_ZEILE_SOND_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_MAN
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Konzern                                      *
*----------------------------------------------------------------------*
FORM einzelanzeige_man.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
* SET PF-STATUS pfstatus_eman.  "<<<tga, pf status on pbo for conc. dynp
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-014 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-014 text-032.
*    WHEN artlist_level.
*      SET TITLEBAR 'EIN' WITH text-014 text-025.
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100  STARTING AT 40 04
                     ENDING   AT 77 19 .
  ELSE.
    PERFORM show_single_detail.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_MAN

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_MAN_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zum Konzern ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_man_write.
  DATA: lv_labst1 TYPE f VALUE '0.0000000000000000E+00',
        lv_satnr  TYPE c.
*---- Mandantenbestandsdaten für ausgewähltes Material beschaffen -----*
  READ TABLE mbe WITH KEY matnr = zle-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    IF gv_tree EQ x.
      READ TABLE mbe WITH KEY satnr = zle-matnr.
      IF sy-subrc NE 0.
         MESSAGE a038 WITH 'MBE'.
      ELSE.
        lv_satnr = x.
      ENDIF.
    ELSE.
      MESSAGE a038 WITH 'MBE'.
*      Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDIF.
  IF gv_tree  EQ x  AND
     lv_satnr EQ x.
    LOOP AT einzel_anzeige.
      CLEAR lv_labst1.
      LOOP AT mbe WHERE satnr    = zle-matnr.
        MOVE 'MBE-'               TO sav_fname0(4).
        MOVE einzel_anzeige-bfnae TO sav_fname0+4.
        ASSIGN (sav_fname0) TO <f0>.

        lv_labst1 = lv_labst1 + <f0>.
      ENDLOOP.
        IF lv_labst1 IS NOT INITIAL.
          <f0> = lv_labst1.
        ENDIF.
*   Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*            des Popups sondern die Größe der Hauptliste zieht
      RESERVE izaehl_eman LINES.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_write.
    ENDLOOP.
  ELSE.
    LOOP AT einzel_anzeige.
      MOVE 'MBE-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
*   Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*            des Popups sondern die Größe der Hauptliste zieht
      RESERVE izaehl_eman LINES.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_write.
    ENDLOOP.
  ENDIF.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_MAN_WRITE

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_BUK
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Buchungskreis
*----------------------------------------------------------------------*
*FORM EINZELANZEIGE_BUK.
*
* SET PF-STATUS PFSTATUS_EMAN.
* CASE DrillDOWN_LEVEL.
*   WHEN EINZART_LEVEL.
*     SET TITLEBAR 'EIN' WITH TEXT-027 TEXT-026.
*   WHEN EINZVAR_LEVEL.
*     SET TITLEBAR 'EIN' WITH TEXT-027 TEXT-032.
*   WHEN ARTLIST_LEVEL.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
* ENDCASE.
*
* CALL SCREEN 100 STARTING AT 40 04
*                 ENDING   AT 77 19.
*
*ENDFORM.                    " EINZELANZEIGE_BUK

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_BUK_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zum Buchungskreis ausgeben
*----------------------------------------------------------------------*
*FORM EINZELANZEIGE_BUK_WRITE.
*
*---- Buchungskreisbestandsdaten für ausgewähltes Material beschaffen -*
* READ TABLE BBE WITH KEY MATNR = ZLE-MATNR
*                         BUKRS = ZLE-BUKRS  BINARY SEARCH.
* IF SY-SUBRC NE 0.
*   MESSAGE A038 WITH 'BBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
* ENDIF.
*
* LOOP AT EINZEL_ANZEIGE.
*   MOVE 'BBE-'               TO SAV_FNAME0(4).
*   MOVE EINZEL_ANZEIGE-BFNAE TO SAV_FNAME0+4.
*   ASSIGN (SAV_FNAME0) TO <F0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
*   RESERVE IZAEHL_EMAN LINES.
*   PERFORM UMSCHLUESSELN_EINZELBESTAND.
*   PERFORM EINZEL_ZEILE_WRITE.
* ENDLOOP.
* WRITE / STRICH38.
*
*ENDFORM.                    " EINZELANZEIGE_BUK_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_WGR
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Basiswerksgruppe
*----------------------------------------------------------------------*
FORM einzelanzeige_wgr.

* tga/46C move pf status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-027 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-027 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf status/set titlebar in pbo for concerning dynpro end
*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 40 04
                    ENDING   AT 77 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_WGR

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_WGR_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zur Basiswerksgruppe ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_wgr_write.

*---- Basiswerksgruppebestandsdaten f. ausgewähltes Mat. beschaffen ---*
  READ TABLE gbe WITH KEY matnr = zle-matnr
                          bwgrp = zle-bwgrp  BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'GBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  LOOP AT einzel_anzeige.
    MOVE 'GBE-'               TO sav_fname0(4).
    MOVE einzel_anzeige-bfnae TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
    RESERVE izaehl_eman LINES.
    PERFORM umschluesseln_einzelbestand.
    PERFORM einzel_zeile_write.
  ENDLOOP.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_WGR_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_WRK
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Werk
*----------------------------------------------------------------------*
FORM einzelanzeige_wrk.
* tga/46C pf status / set titlebar in pbo for concerning dynpro start
*  SET PF-STATUS pfstatus_eman.
*  CASE drilldown_level.
*    WHEN einzart_level.
*     SET TITLEBAR 'EIN' WITH text-028 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-028 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C pf status / set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 40 04
                    ENDING   AT 77 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_WRK

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_WRK_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zum Werk ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_wrk_write.

*---- Werksbestandsdaten für ausgewähltes Material beschaffen ---------*
  READ TABLE wbe WITH KEY matnr = zle-matnr
                          werks = zle-werks
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                         BUKRS = ZLE-BUKRS  BINARY SEARCH.
* Anmerkung: Selektion bzgl. BUKRS ist eigentlich nicht notwendig, weil
* Werke mandantenweit eindeutig sind und so das gleiche Werk nie in zwei
* unterschiedlichen BUKRS's auftauchen kann
                          bwgrp = zle-bwgrp  BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  LOOP AT einzel_anzeige.
    MOVE 'WBE-'               TO sav_fname0(4).
    MOVE einzel_anzeige-bfnae TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
    RESERVE izaehl_eman LINES.
    PERFORM umschluesseln_einzelbestand.
    PERFORM einzel_zeile_write.
  ENDLOOP.

* tga / acc retail
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_WRK_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_LGO
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Lagerort
*----------------------------------------------------------------------*
FORM einzelanzeige_lgo.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
* SET PF-STATUS pfstatus_eman.
* CASE drilldown_level.
*   WHEN einzart_level.
*     SET TITLEBAR 'EIN' WITH text-029 text-026.
*   WHEN einzvar_level.
*     SET TITLEBAR 'EIN' WITH text-029 text-032.
*   WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
* ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
*  tga / acc retail
*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 40 04
                    ENDING   AT 77 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_LGO

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_LGO_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zum Lagerort ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_lgo_write.

*---- Lagerortbestandsdaten für ausgewähltes Material beschaffen ------*
  READ TABLE lbe WITH KEY matnr = zle-matnr
                          werks = zle-werks
                          lgort = zle-lgort  BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'LBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  LOOP AT einzel_anzeige.
* Retrofit SDP Bw, keine Anzeige in RWBE
    IF einzel_anzeige-bfnae = 'BSABR'.
      CONTINUE.
    ENDIF.
    MOVE 'LBE-'               TO sav_fname0(4).
    MOVE einzel_anzeige-bfnae TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
    RESERVE izaehl_eman LINES.
    PERFORM umschluesseln_einzelbestand.
    PERFORM einzel_zeile_write.
  ENDLOOP.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_LGO_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_GES
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Summe der Gesamtbestände aller Artikel einer
*       Liste
*----------------------------------------------------------------------*
FORM einzelanzeige_ges.

*  SET PF-STATUS pfstatus_eman.  "<<<tga, pf status on pbo for conc.dyn
*---- Summenbestand ist nur bei DrillDOWN_LEVEL = ARTLIST_LEVEL mögl. -*
*---- -> Fallunterscheidung kann entfallen                            -*
  SET TITLEBAR 'EIN' WITH text-014 text-025.

*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 40 04
                    ENDING   AT 77 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_GES

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_GES_WRITE
*&---------------------------------------------------------------------*
*       Einzelliste zur Summe der Gesamtbestände aller Artikel einer
*       Liste ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_ges_write.

  LOOP AT einzel_anzeige.
    MOVE 'SMB-'               TO sav_fname0(4).
    MOVE einzel_anzeige-bfnae TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
    RESERVE izaehl_eman LINES.
    PERFORM umschluesseln_einzelbestand.
    PERFORM einzel_zeile_write.
  ENDLOOP.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_GES_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_WRK_SOND
*&---------------------------------------------------------------------*
*       Einzelanzeige von Sonderbestand der nur dem Werk zugeordnet ist
*----------------------------------------------------------------------*
FORM einzelanzeige_wrk_sond.

* SET PF-STATUS pfstatus_eman.  "<<<tga, pf status on pbo for conc. dynp

  CASE sond_kz.
    WHEN konsikunde.
      PERFORM einzelanzeige_konsikunde.
    WHEN lrgutkunde.
      PERFORM einzelanzeige_lrgutkunde.
    WHEN beistlief.
      PERFORM einzelanzeige_beistlief.
*>>> hier später weitere Sonderbestände ergänzen
  ENDCASE.

ENDFORM.                               " EINZELANZEIGE_WRK_SOND

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_KONSIKUNDE
*&---------------------------------------------------------------------*
*       Einzelanzeige des Kundenkonsigantionsbestandes pro Kunde
*----------------------------------------------------------------------*
FORM einzelanzeige_konsikunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-045 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-045 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_KONSIKUNDE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_KONSIKUNDE_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Kundenkonsignation ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_konsikunde_write.

  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
* CASE ZEILEN-KZ.    ????entfällt wegen s.u.
*   WHEN WRK_ZEILE.
  LOOP AT wbs
       WHERE matnr =  zle-matnr
         AND werks =  zle-werks.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'WBS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM kunde_write USING wbs-kunnr.
    kntab-kunnr = wbs-kunnr.
    PERFORM kname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'WBS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
*   tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.
*   WHEN CHA_ZEILE.  ????entfällt
*     LOOP AT WBS
*          WHERE WERKS =  ZLE-WERKS
*          AND   CHARG =  ZLE-CHARG.
*       RESERVE IZAEHL LINES.
*       PERFORM KUNDE_WRITE USING WBS-KUNNR.
*       KNTAB-KUNNR = WBS-KUNNR.
*       PERFORM KNAME_WRITE.
*       DETAIL.
*       LOOP AT EINZEL_ANZEIGE.
*         MOVE 'WBS-'               TO SAV_FNAME0(4).
*         MOVE EINZEL_ANZEIGE-BFNAE TO SAV_FNAME0+4.
*         ASSIGN (SAV_FNAME0) TO <F0>.
*         PERFORM UMSCHLUESSELN_EINZELBESTAND.
*         PERFORM EINZEL_ZEILE_SOND_WRITE.
*       ENDLOOP.
*       WRITE: / STRICH42 COLOR OFF, 43 SPACE38 COLOR OFF.
*     ENDLOOP.
* ENDCASE.

ENDFORM.                               " EINZELANZEIGE_KONSIKUNDE_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_BEISTLIEF
*&---------------------------------------------------------------------*
*       Einzelanzeige des Lieferantenbeistellbestandes pro Lieferant
*----------------------------------------------------------------------*
FORM einzelanzeige_beistlief.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-044 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-044 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_BEISTLIEF

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_BEISTLIEF_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Lieferantenbeistellung ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_beistlief_write.

  REFRESH obc.
  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
* CASE ZEILEN_KZ.   ????entfällt wegen s.u.
*   WHEN WRK_ZEILE.
if zle-charg is initial and
   zle-sgt_scat is not initial.

LOOP AT obs
       WHERE matnr =  zle-matnr
       AND   werks =  zle-werks
       AND   sgt_scat = zle-sgt_scat.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'OBS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM lief_write USING obs-lifnr.
    lftab-lifnr = obs-lifnr.
    PERFORM lname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'OBS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.

elseif zle-charg is not initial.

  LOOP AT obs
       WHERE matnr =  zle-matnr
       AND   werks =  zle-werks
       AND   charg = zle-charg.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'OBS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM lief_write USING obs-lifnr.
    lftab-lifnr = obs-lifnr.
    PERFORM lname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'OBS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.

 else.

LOOP AT obs.
  READ TABLE obc WITH KEY matnr = obs-matnr
                          werks = obs-werks
                          lifnr = obs-lifnr BINARY SEARCH.
  IF sy-subrc eq 0.
    add obs-labst to obc-labst.
    add obs-insme to obc-insme.
    add obs-einme to obc-einme.
    modify obc INDEX sy-tabix.
  ELSE.
    clear obc.
    move-corresponding obs to obc.
    insert obc index sy-tabix.
  ENDIF.
ENDLOOP.
LOOP AT obc
       WHERE matnr =  zle-matnr
       AND   werks =  zle-werks.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'OBC-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM lief_write USING obc-lifnr.
    lftab-lifnr = obc-lifnr.
    PERFORM lname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'OBC-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.
endif.
*   WHEN CHA_ZEILE.    ????entfällt
*     LOOP AT OBS
*          WHERE WERKS =  ZLE-WERKS
*          AND   CHARG =  ZLE-CHARG.
*       RESERVE IZAEHL LINES.
*       PERFORM LIEF_WRITE USING OBS-LIFNR.
*       LFTAB-LIFNR = OBS-LIFNR.
*       PERFORM LNAME_WRITE.
*       DETAIL.
*       LOOP AT EINZEL_ANZEIGE.
*         MOVE 'OBS-'               TO SAV_FNAME0(4).
*         MOVE EINZEL_ANZEIGE-BFNAE TO SAV_FNAME0+4.
*         ASSIGN (SAV_FNAME0) TO <F0>.
*         PERFORM UMSCHLUESSELN_EINZELBESTAND.
*         PERFORM EINZEL_ZEILE_SOND_WRITE.
*       ENDLOOP.
*     WRITE: / STRICH42 COLOR OFF, 43 SPACE38 COLOR OFF.
*     ENDLOOP.
* ENDCASE.

ENDFORM.                               " EINZELANZEIGE_BEISTLIEF_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_LRGUTKUNDE
*&---------------------------------------------------------------------*
*       Einzelanzeige des Kundenleergutbestandes pro Kunde
*----------------------------------------------------------------------*
FORM einzelanzeige_lrgutkunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-046 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-046 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_LRGUTKUNDE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_LRGUTKUNDE_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Kundenleergut ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_lrgutkunde_write.

  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
* CASE ZEILEN-KZ.    ????entfällt wegen s.u.
*   WHEN WRK_ZEILE.
  LOOP AT vbs
       WHERE matnr =  zle-matnr
         AND werks =  zle-werks.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'VBS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM kunde_write USING vbs-kunnr.
    kntab-kunnr = vbs-kunnr.
    PERFORM kname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'VBS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
    WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
  ENDLOOP.
*   WHEN CHA_ZEILE.    ????entfällt
*     LOOP AT VBS
*          WHERE WERKS =  ZLE-WERKS
*          AND   CHARG =  ZLE-CHARG.
*       RESERVE IZAEHL LINES.
*       PERFORM KUNDE_WRITE USING VBS-KUNNR.
*       KNTAB-KUNNR = VBS-KUNNR.
*       PERFORM KNAME_WRITE.
*       DETAIL.
*       LOOP AT EINZEL_ANZEIGE.
*         MOVE 'VBS-'               TO SAV_FNAME0(4).
*         MOVE EINZEL_ANZEIGE-BFNAE TO SAV_FNAME0+4.
*         ASSIGN (SAV_FNAME0) TO <F0>.
*         PERFORM UMSCHLUESSELN_EINZELBESTAND.
*         PERFORM EINZEL_ZEILE_SOND_WRITE.
*       ENDLOOP.
*       WRITE: / STRICH42 COLOR OFF, 43 SPACE38 COLOR OFF.
*     ENDLOOP.
* ENDCASE.

ENDFORM.                               " EINZELANZEIGE_LRGUTKUNDE_WRITE

*&---------------------------------------------------------------------*
*&      Form  LIEF_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe des Lieferanten in der Einzelbestandsliste
*----------------------------------------------------------------------*
*  -->  LIFNR     Nummer des Lieferanten
*----------------------------------------------------------------------*
FORM lief_write USING lifnr LIKE lfa1-lifnr.

* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    WRITE: /01 sy-vline,
             2 text-053 NO-GAP           "Klartext Lieferant
                COLOR COL_GROUP INTENSIFIED,
               space14
                COLOR COL_GROUP INTENSIFIED,
            16 lifnr NO-GAP              "Lieferant
                COLOR COL_GROUP INTENSIFIED OFF,
               space16
                COLOR COL_GROUP INTENSIFIED OFF,
            42 sy-vline,
            43 space38 COLOR OFF.
  ELSE.
    WRITE lifnr TO wa_einzelanz_lief-lifnr.
  ENDIF.
ENDFORM.                               " LIEF_WRITE

*&---------------------------------------------------------------------*
*&      Form  LNAME_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe des Lieferantennamens in der Einzelbestandsliste
*----------------------------------------------------------------------*
FORM lname_write.

  READ TABLE lftab WITH KEY lifnr = lftab-lifnr BINARY SEARCH.
  htabix = sy-tabix.
  IF sy-subrc NE 0.
    PERFORM lname_lesen.               "Liest LFA1 und ergänzt LFTAB
  ENDIF.
  IF lftab-name1 NE space.
*   tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: /1 sy-vline,
              2 lftab-name1 COLOR COL_GROUP INTENSIFIED OFF NO-GAP,
                space5 COLOR COL_GROUP INTENSIFIED OFF,
             42 sy-vline,
             43 space38 COLOR OFF.
    ELSE.
      WRITE lftab-name1 TO wa_einzelanz_lief-liefe.
    ENDIF.
  ENDIF.


ENDFORM.                               " LNAME_WRITE

*&---------------------------------------------------------------------*
*&      Form  LNAME_LESEN
*&---------------------------------------------------------------------*
*       Lesen des Lieferantennamens zu LFTAB-LIFNR
*----------------------------------------------------------------------*
FORM lname_lesen.

  CLEAR lftab-name1.
  SELECT SINGLE * FROM lfa1
         WHERE lifnr = lftab-lifnr.
  IF sy-subrc = 0.
    lftab-name1 = lfa1-name1.
  ENDIF.
  INSERT lftab INDEX htabix.

ENDFORM.                               " LNAME_LESEN

*&---------------------------------------------------------------------*
*&      Form  KUNDE_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe des Kunden in der Einzelbestandsliste
*----------------------------------------------------------------------*
*  -->  KUNNR     Nummer des Kunden
*----------------------------------------------------------------------*
FORM kunde_write USING kunnr LIKE kna1-kunnr.

* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE: /01 sy-vline,
              2 text-054 NO-GAP           "Klartext Kunde
                 COLOR COL_GROUP INTENSIFIED,
                space14
                 COLOR COL_GROUP INTENSIFIED,
             16 kunnr NO-GAP              "Lieferant
                 COLOR COL_GROUP INTENSIFIED OFF,
                space16
                 COLOR COL_GROUP INTENSIFIED OFF,
             42 sy-vline,
             43 space38 COLOR OFF.
  ELSE.
    WRITE kunnr TO wa_einzelanz_kd-kdnna.
  ENDIF.

ENDFORM.                               " KUNDE_WRITE

*&---------------------------------------------------------------------*
*&      Form  KNAME_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe des Kundennamens in der Einzelbestandsliste
*----------------------------------------------------------------------*
FORM kname_write.

  READ TABLE kntab WITH KEY kunnr = kntab-kunnr BINARY SEARCH.
  htabix = sy-tabix.
  IF sy-subrc NE 0.
    PERFORM kname_lesen.               "Liest KNA1 und ergänzt KNTAB
  ENDIF.
  IF kntab-name1 NE space.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: /1 sy-vline,
              2 kntab-name1 COLOR COL_GROUP INTENSIFIED OFF NO-GAP,
                space5 COLOR COL_GROUP INTENSIFIED OFF,
             42 sy-vline,
             43 space38 COLOR OFF.
    ELSE.
      WRITE kntab-name1 TO wa_einzelanz_kd-name1.
    ENDIF.
  ENDIF.


ENDFORM.                               " KNAME_WRITE

*&---------------------------------------------------------------------*
*&      Form  KNAME_LESEN
*&---------------------------------------------------------------------*
*       Lesen des Kundennamens zu KNTAB-KUNNR
*----------------------------------------------------------------------*
FORM kname_lesen.

  CLEAR kntab-name1.
  SELECT SINGLE * FROM kna1
         WHERE kunnr = kntab-kunnr.
  IF sy-subrc = 0.
    kntab-name1 = kna1-name1.
  ENDIF.
  INSERT kntab INDEX htabix.

ENDFORM.                               " KNAME_LESEN

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_LGO_SOND
*&---------------------------------------------------------------------*
*       Einzelanzeige v. Sonderbestand d. dem Lagerort zugeordnet ist
*----------------------------------------------------------------------*
FORM einzelanzeige_lgo_sond.

  CASE sond_kz.
    WHEN konsilief.
* Anmerkung: hier wird ein abweichender Status gesetzt, weil zusätzlich
* von d. Konsi-Einzelliste in d. Konsipreissegment verzweigt werden kann
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro
*     SET PF-STATUS pfstatus_eson.
      PERFORM einzelanzeige_konsilief.
    WHEN aufbskunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro
*     SET PF-STATUS pfstatus_eman.
      PERFORM einzelanzeige_aufbskunde.
    WHEN mtverpack.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro
*     SET PF-STATUS pfstatus_eman.
      PERFORM einzelanzeige_mtverpack.
*   WHEN PRJBESTAND.     ????uninteressant für Handel
*     SET PF-STATUS PFSTATUS_EMAN.
*     PERFORM EINZELANZEIGE_PRJBESTAND.
*>>> hier später weitere Sonderbestände ergänzen
    WHEN beistlief.
      PERFORM einzelanzeige_beistlief.
  ENDCASE.

ENDFORM.                               " EINZELANZEIGE_LGO_SOND

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_KONSILIEF
*&---------------------------------------------------------------------*
*       Einzelanzeige des Lieferantenkonsibestandes pro Lieferant
*----------------------------------------------------------------------*
FORM einzelanzeige_konsilief.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-047 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-047 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_KONSILIEF

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_KONSILIEF_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Lieferantenkonsignation ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_konsilief_write.

  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
  LOOP AT kbe
           WHERE matnr =  zle-matnr
             AND werks =  zle-werks
             AND lgort =  zle-lgort.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'KBE-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM lief_write USING kbe-lifnr.
    zle-matnr = kbe-matnr.
    zle-lifnr = kbe-lifnr.
    zle-werks = kbe-werks.
    zle-lgort = kbe-lgort.
    HIDE zle-lifnr.
    HIDE sond_kz.
    HIDE zle-matnr.
    HIDE zle-werks.
    HIDE zle-lgort.
    lftab-lifnr = kbe-lifnr.
    PERFORM lname_write.
    HIDE zle-lifnr.
    HIDE sond_kz.
    HIDE zle-matnr.
    HIDE zle-werks.
    HIDE zle-lgort.
*   DETAIL.   "????muß das nicht hier auch hin?
    LOOP AT einzel_anzeige.
      MOVE 'KBE-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
      HIDE zle-lifnr.
      HIDE sond_kz.
      HIDE zle-matnr.
      HIDE zle-werks.
      HIDE zle-lgort.
    ENDLOOP.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " EINZELANZEIGE_KONSILIEF_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_AUFBSKUNDE
*&---------------------------------------------------------------------*
*       Einzelanzeige des Kundenauftragsbestandes pro Beleg u. Position
*----------------------------------------------------------------------*
FORM einzelanzeige_aufbskunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-048 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-048 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.
ENDFORM.                               " EINZELANZEIGE_AUFBSKUNDE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_AUFBSKUNDE_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zum Kundenauftragsbestand ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_aufbskunde_write.

  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
  LOOP AT ebs
           WHERE matnr =  zle-matnr
             AND werks =  zle-werks
             AND lgort =  zle-lgort.
*---- Prüfung Nullbestand in Einzelliste ------------------------------*
    MOVE 'EBS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
* tga / acc retail todo
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

      WRITE: /01 sy-vline,
              02 text-055                "Klartext Beleg
                   COLOR COL_GROUP INTENSIFIED NO-GAP,
                 space5 COLOR COL_GROUP INTENSIFIED,
              08 ebs-vbeln               "Beleg
                   COLOR COL_GROUP INTENSIFIED OFF NO-GAP,
                 space5 COLOR COL_GROUP INTENSIFIED OFF,
              20 text-056                "Klartext Position
                   COLOR COL_GROUP INTENSIFIED NO-GAP,
                 space5 COLOR COL_GROUP INTENSIFIED,
              30 ebs-posnr               "Position
                   COLOR COL_GROUP INTENSIFIED OFF NO-GAP,
                 space16 COLOR COL_GROUP INTENSIFIED OFF,
              42 sy-vline,
              43 space38 COLOR OFF.
    ELSE.
      WRITE ebs-vbeln TO wa_einzelanz_auf-belegnumr.
      WRITE ebs-posnr TO wa_einzelanz_auf-posnr.
    ENDIF.
    zle-vbeln = ebs-vbeln.
    zle-posnr = ebs-posnr.
*   ZLE-ETENR = EBS-ETENR.
    zle-matnr = ebs-matnr.
    zle-werks = ebs-werks.
    zle-lgort = ebs-lgort.
    HIDE zle-vbeln.
    HIDE zle-posnr.
*   HIDE ZLE-ETENR.
    HIDE sond_kz.
    HIDE zle-matnr.
    HIDE zle-werks.
    HIDE zle-lgort.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'EBS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
      HIDE zle-vbeln.
      HIDE zle-posnr.
      HIDE sond_kz.
      HIDE zle-matnr.
      HIDE zle-werks.
      HIDE zle-lgort.
    ENDLOOP.
*    tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " EINZELANZEIGE_AUFBSKUNDE_WRITE

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_MTVERPACK
*&---------------------------------------------------------------------*
*       Einzelanzeige des Lieferanten-MTV-Bestandes pro Lieferant
*----------------------------------------------------------------------*
FORM einzelanzeige_mtverpack.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*  CASE drilldown_level.
*    WHEN einzart_level.
*      SET TITLEBAR 'EIN' WITH text-049 text-026.
*    WHEN einzvar_level.
*      SET TITLEBAR 'EIN' WITH text-049 text-032.
*    WHEN artlist_level.
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*  ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    CALL SCREEN 100 STARTING AT 37 04
                    ENDING   AT 78 19.
  ELSE.
    PERFORM show_single_detail.

    PERFORM show_single_special_grid.
  ENDIF.

ENDFORM.                               " EINZELANZEIGE_MTVERPACK

*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_MTVERPACK_WRITE
*&---------------------------------------------------------------------*
*       Einzelanzeige zur Lieferanten-MTV ausgeben
*----------------------------------------------------------------------*
FORM einzelanzeige_mtverpack_write.

  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
  LOOP AT mps
           WHERE matnr =  zle-matnr
             AND werks =  zle-werks
             AND lgort =  zle-lgort.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'MPS-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM lief_write USING mps-lifnr.
    zle-lifnr = mps-lifnr.
    zle-matnr = mps-matnr.
    zle-werks = mps-werks.
    zle-lgort = mps-lgort.
    HIDE zle-lifnr.
    HIDE sond_kz.
    HIDE zle-matnr.
    HIDE zle-werks.
    HIDE zle-lgort.
    lftab-lifnr = mps-lifnr.
    PERFORM lname_write.
    HIDE zle-lifnr.
    HIDE sond_kz.
    HIDE zle-matnr.
    HIDE zle-werks.
    HIDE zle-lgort.
    FORMAT INTENSIFIED OFF.
    LOOP AT einzel_anzeige.
      MOVE 'MPS-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
      HIDE zle-lifnr.
      HIDE sond_kz.
      HIDE zle-matnr.
      HIDE zle-werks.
      HIDE zle-lgort.
    ENDLOOP.
    WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
  ENDLOOP.

ENDFORM.                               " EINZELANZEIGE_MTVERPACK_WRITE

*&---------------------------------------------------------------------*
*&      Form  EK_VK_WRK
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zum Werk
*----------------------------------------------------------------------*
FORM ek_vk_wrk.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
* SET PF-STATUS pfstatus_eman.
* CASE drilldown_level.
*   WHEN einzart_level.
*     SET TITLEBAR 'WER' WITH text-028 text-026.
*   WHEN einzvar_level.
*     SET TITLEBAR 'WER' WITH text-028 text-032.
*   WHEN artlist_level.                "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
* ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 400 STARTING AT 40 04
                    ENDING   AT 81 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.
ENDFORM.                               " EK_VK_WRK

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ANZEIGE_WRK_WRITE
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zum Werk anzeigen                          *
*----------------------------------------------------------------------*
FORM ek_vk_anzeige_wrk_write.

  REFRESH ekvk_sum.
  CLEAR   ekvk_sum.

*---- Bewertete Bestandsmenge lesen -----------------------------------*
  READ TABLE wbe WITH KEY matnr = zle-matnr
                          werks = zle-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  PERFORM wertm_bestaende_kumulieren.

  PERFORM ek_vk_zeilen_write.

* tga / acc retail
  IF NOT cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    PERFORM show_single_stnd_grid.
  ENDIF.


ENDFORM.                               " EK_VK_ANZEIGE_WRK_WRITE

*&---------------------------------------------------------------------*
*&      Form  EK_VK_WGR
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zur Basiswerksgruppe
*----------------------------------------------------------------------*
FORM ek_vk_wgr.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
* SET PF-STATUS pfstatus_eman.
* CASE drilldown_level.
*   WHEN einzart_level.
*     SET TITLEBAR 'WER' WITH text-027 text-026.
*   WHEN einzvar_level.
*     SET TITLEBAR 'WER' WITH text-027 text-032.
*   WHEN artlist_level.                "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
* ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end

*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    CALL SCREEN 400 STARTING AT 40 04
                    ENDING   AT 81 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.

ENDFORM.                               " EK_VK_WGR

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ANZEIGE_WGR_WRITE
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zur Basiswerksgruppe                       *
*----------------------------------------------------------------------*
FORM ek_vk_anzeige_wgr_write.

  REFRESH ekvk_sum.
  CLEAR   ekvk_sum.

*---- Mengen- und wertmäßige Bestandswerte aller Werke zu der vor- ----*
*---- liegenden Basiswerkgruppe pro Währung kummulieren            ----*
  LOOP AT wbe WHERE matnr = zle-matnr
                AND bwgrp = zle-bwgrp.
    PERFORM wertm_bestaende_kumulieren.
  ENDLOOP.

  PERFORM ek_vk_zeilen_write.

* tga / acc retail
  IF NOT cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    PERFORM show_single_stnd_grid.
  ENDIF.


ENDFORM.                               " EK_VK_ANZEIGE_WGR_WRITE

*&---------------------------------------------------------------------*
*&      Form  EK_VK_MAN
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zum Gesamtunternehmen
*----------------------------------------------------------------------*
FORM ek_vk_man.

*---- Test, ob überhaupt Bestandsdaten auf Werksebene vorhanden sind --*
  DESCRIBE TABLE wbe LINES sy-tfill.
  IF sy-tfill = 0.
*---- Keine Anzeige von EK/VK-Bestandswerten möglich ------------------*
    MESSAGE i089.
*    Keine EK-/VK-Bestandswerte vorhanden
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
  ELSE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro start
*   SET PF-STATUS pfstatus_eman.
*   CASE drilldown_level.
*     WHEN einzart_level.
*       SET TITLEBAR 'WER' WITH text-014 text-026.
*     WHEN einzvar_level.
*       SET TITLEBAR 'WER' WITH text-014 text-032.
*     WHEN artlist_level.              "????doch möglich?
*---- Fall nicht möglich, da bei diesem Level nur Bestände auf  -------*
*---- Konzernebene zur Anzeige kommen und keine tieferliegenden -------*
*   ENDCASE.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro end
*  tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      CALL SCREEN 400 STARTING AT 40 04
                      ENDING   AT 81 19.
    ELSE.
      PERFORM show_single_detail.
    ENDIF.
  ENDIF.

ENDFORM.                               " EK_VK_MAN

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ANZEIGE_MAN_WRITE
*&---------------------------------------------------------------------*
*       EK/VK-Bestandswerte zum Gesamtunternehmen                      *
*----------------------------------------------------------------------*
FORM ek_vk_anzeige_man_write.

  REFRESH ekvk_sum.
  CLEAR   ekvk_sum.

*---- Mengen- und wertmäßige Bestandswerte aller Werke des Unter- -----*
*---- nehmens pro Währung kummulieren                             -----*
*---- (es ist sichergestellt, daß mind. 1 Eintrag in WBE exist.)  -----*
  IF gv_tree EQ x.
    READ TABLE wbe WITH KEY matnr = zle-matnr.
    IF sy-subrc = 0.
      LOOP AT wbe WHERE matnr = zle-matnr.
        PERFORM wertm_bestaende_kumulieren.
      ENDLOOP.
    ELSE.
      READ TABLE wbe WITH KEY satnr = zle-matnr.
      IF sy-subrc = 0.
        LOOP AT wbe WHERE satnr = zle-matnr.
          PERFORM wertm_bestaende_kumulieren.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ELSE.
      LOOP AT wbe WHERE matnr = zle-matnr.
        PERFORM wertm_bestaende_kumulieren.
      ENDLOOP.
  ENDIF.
  PERFORM ek_vk_zeilen_write.

* tga / acc retail
  IF NOT cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    PERFORM show_single_stnd_grid.
  ENDIF.



ENDFORM.                               " EK_VK_ANZEIGE_MAN_WRITE

*&---------------------------------------------------------------------*
*&      Form  WERTM_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Wertmäßiger Bestand pro Währung aufsummieren
*----------------------------------------------------------------------*
FORM wertm_bestaende_kumulieren.

*---- Währung lesen ---------------------------------------------------*
  READ TABLE t_werks WITH KEY wbe-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_WERKS'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

*---- EK/VK-Bestandsdaten lesen ---------------------------------------*
  READ TABLE ek_vk WITH KEY matnr = wbe-matnr
                            werks = wbe-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'EK_VK'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

*---- Bestandsdaten kummulieren ---------------------------------------*
  READ TABLE ekvk_sum WITH KEY waers = t_werks-waers BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD wbe-lbkum   TO ekvk_sum-lbkum.
    ADD ek_vk-ekwer TO ekvk_sum-ekwer.
    ADD ek_vk-vkwer TO ekvk_sum-vkwer.
    MODIFY ekvk_sum INDEX sy-tabix.
  ELSE.
    CLEAR ekvk_sum.
    MOVE t_werks-waers TO ekvk_sum-waers.
    MOVE wbe-lbkum     TO ekvk_sum-lbkum.
    MOVE ek_vk-ekwer   TO ekvk_sum-ekwer.
    MOVE ek_vk-vkwer   TO ekvk_sum-vkwer.
    INSERT ekvk_sum INDEX sy-tabix.
  ENDIF.

ENDFORM.                               " WERTM_BESTAENDE_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ANZEIGE_FELDER
*&---------------------------------------------------------------------*
*       Bestimmen der Anzeige-Felder für die EK/VK-Bestandsliste
*----------------------------------------------------------------------*
FORM ek_vk_anzeige_felder.

  SELECT SINGLE * FROM  t157b
         WHERE  spras = sy-langu
         AND    feldv = 'LBKUM'.
  IF sy-subrc = 0.
    mefeld = t157b-ftext.
  ELSE.
    mefeld = '?????????????????'.
  ENDIF.

  SELECT SINGLE * FROM  t157b
         WHERE  spras = sy-langu
         AND    feldv = 'SALK3'.
  IF sy-subrc = 0.
    ekfeld = t157b-ftext.
  ELSE.
    ekfeld = '?????????????????'.
  ENDIF.

  SELECT SINGLE * FROM  t157b
         WHERE  spras = sy-langu
         AND    feldv = 'VKSAL'.
  IF sy-subrc = 0.
    vkfeld = t157b-ftext.
  ELSE.
    vkfeld = '?????????????????'.
  ENDIF.

ENDFORM.                               " EK_VK_ANZEIGE_FELDER

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ZEILEN_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe aller Zeilen der EK/VK-Bestandszeilen
*----------------------------------------------------------------------*
FORM ek_vk_zeilen_write.
*  tga acc retail
  DATA: wa_einzelanz_mbwl LIKE LINE OF gt_einzelanz_mbwl,
        lh_htxt_quan(14)  TYPE c,
        lh_htxt_unit(5)   TYPE c.

*----- Mengeneinheit lesen --------------------------------------------*
  READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    IF gv_tree EQ x.
      READ TABLE t_matnr WITH KEY satnr = zle-matnr.
      IF sy-subrc NE 0.
         MESSAGE a038 WITH 'T_MATNR'.
      ENDIF.
    ELSE.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDIF.

  MOVE 'EKVK_SUM-LBKUM'  TO sav_fname0.

* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.

    LOOP AT ekvk_sum.
*---- Prüfung Nullbestand für EK/VK-Bestandsliste ---------------------*
*   MOVE 'KBE-' TO SAV_FNAME0(4).        ????evtl. noch Prüfung auf
*   PERFORM NULLBESTAND_PRUEFEN_EINZEL.      Nullbestand einbauen
*   CHECK NULLCHECK NE 0.

*---- Bewerteten Bestand ausgeben -------------------------------------*
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      RESERVE izaehl_eman LINES.
      WRITE:  /1  sy-vline,
               2  mefeld.                "Klartext - Bestandsfeld
      WRITE:  19  sy-vline.
      IF p_kzngc IS INITIAL.             "TGA/22.03.99/KZNGC
        WRITE:  20(18)  <d0>,            "Bestand
                38      t_matnr-meins.   "Mengeneinheit
      ELSE.                              "TGA/22.03.99/KZNGC
        WRITE:  20(18)  <d0>  UNIT t_matnr-meins,   "TGA/22.03.99/KZNGC
                38      t_matnr-meins.   "TGA/22.03.99/KZNGC
      ENDIF.                             "TGA/22.03.99/KZNGC
      IF <d0> < 0.                       "Minus-Zeichen rot einfärben
        WRITE 37 minus COLOR COL_NEGATIVE.
      ENDIF.
      WRITE   42  sy-vline.
      FORMAT COLOR OFF.
      WRITE  43 space38.
*---- EK-Bestandswert ausgeben ----------------------------------------*
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      WRITE:  /1  sy-vline,
               2  ekfeld.                "Klartext - EK-Wertfeld
      WRITE:  19  sy-vline.
      WRITE:  20(17)  ekvk_sum-ekwer     "EK-Bestandswert
                      CURRENCY ekvk_sum-waers,
              38      ekvk_sum-waers.    "Währung
      IF ekvk_sum-ekwer < 0.             "Minus-Zeichen rot einfärben
        WRITE 36 minus COLOR COL_NEGATIVE.
      ENDIF.
      WRITE   42  sy-vline.
      FORMAT COLOR OFF.
      WRITE  43 space38.
*---- VK-Bestandswert ausgeben ----------------------------------------*
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      WRITE:  /1  sy-vline,
               2  vkfeld.                "Klartext - VK-Wertfeld
      WRITE:  19  sy-vline.
      WRITE:  20(17)  ekvk_sum-vkwer     "VK-Bestandswert
                      CURRENCY ekvk_sum-waers,
              38      ekvk_sum-waers.    "Währung
      IF ekvk_sum-vkwer < 0.             "Minus-Zeichen rot einfärben
        WRITE 36 minus COLOR COL_NEGATIVE.
      ENDIF.
      WRITE   42  sy-vline.
      FORMAT COLOR OFF.
      WRITE  43 space38.

      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.

* HIDE ZLE-MATNR. "????Hiding evtl. notwendig, falls Folgefunktion mal
* HIDE ZLE-WERKS. "????möglich wird (z.B. Sprung in Kalkulation, ...)
    ENDLOOP.
  ELSE.
    LOOP AT ekvk_sum.

*---bewerteten Bestand ausgeben -------------------------------------*
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      RESERVE izaehl_eman LINES.
      WRITE  mefeld TO wa_einzelanz_mbwl-bstartxt. " stock field
      IF p_kzngc IS INITIAL.
        WRITE <d0>          TO lh_htxt_quan.   "stock
        WRITE t_matnr-meins TO lh_htxt_unit.   "unit
        CONCATENATE lh_htxt_quan lh_htxt_unit INTO
                    wa_einzelanz_mbwl-bstndtxt SEPARATED BY space.
      ELSE.
        WRITE <d0> UNIT t_matnr-meins TO lh_htxt_quan.   "stock
        WRITE t_matnr-meins           TO lh_htxt_unit.   "unit
        CONCATENATE lh_htxt_quan lh_htxt_unit INTO
                    wa_einzelanz_mbwl-bstndtxt SEPARATED BY space.
      ENDIF.

      APPEND wa_einzelanz_mbwl TO gt_einzelanz_mbwl.
*---- EK-Bestandswert ausgeben ----------------------------------------*
      WRITE ekfeld TO wa_einzelanz_mbwl-bstartxt. " stock field
      WRITE ekvk_sum-ekwer      TO lh_htxt_quan CURRENCY ekvk_sum-waers.
      WRITE ekvk_sum-waers      TO lh_htxt_unit.   "unit
      CONCATENATE lh_htxt_quan lh_htxt_unit INTO
                  wa_einzelanz_mbwl-bstndtxt SEPARATED BY space.
*    IF ekvk_sum-ekwer < 0.             "Minus-Zeichen rot einfärben
*      WRITE 36 minus COLOR COL_NEGATIVE.
*    ENDIF.
      APPEND wa_einzelanz_mbwl TO gt_einzelanz_mbwl.
*---- VK-Bestandswert ausgeben ----------------------------------------*
      WRITE vkfeld TO wa_einzelanz_mbwl-bstartxt. " stock field
      WRITE ekvk_sum-vkwer      TO lh_htxt_quan CURRENCY ekvk_sum-waers.
      WRITE ekvk_sum-waers      TO lh_htxt_unit.   "unit
      CONCATENATE lh_htxt_quan lh_htxt_unit INTO
                  wa_einzelanz_mbwl-bstndtxt SEPARATED BY space.

      APPEND wa_einzelanz_mbwl TO gt_einzelanz_mbwl.
    ENDLOOP.
  ENDIF.
ENDFORM.                               " EK_VK_ZEILEN_WRITE
*&---------------------------------------------------------------------*
*&      Form  write_stock_of_strart
*&---------------------------------------------------------------------*
*       Ausgabe aller Zeilen der Komponentenbestände
*----------------------------------------------------------------------*
FORM write_stock_of_strart.
  DATA: sav_zeilen_kz LIKE zeilen_kz.
  CLEAR: str_labst.

  sav_zeilen_kz = zeilen_kz.
  WRITE: / strich60 COLOR OFF, 61 space38 COLOR OFF.
  FORMAT COLOR COL_HEADING.
  WRITE:  /1  sy-vline,
           2  text-007, space14.       "Klartext -Material
  WRITE:  37  sy-vline,
          48  text-030.
  WRITE   60  sy-vline.
  FORMAT COLOR OFF.
  WRITE  61 space38.

  LOOP AT sbe.
    AT NEW comp_matnr.
      WRITE: / strich60 COLOR OFF, 61 space38 COLOR OFF.

      CLEAR: com_labst.
      CASE sav_zeilen_kz.
        WHEN wrk_zeile.
          CLEAR wbe.                      "TGA/46C insert
          READ TABLE wbe WITH KEY matnr =  sbe-comp_matnr
                                  werks = zle-werks.
          READ TABLE cum_comp WITH KEY comp_matnr = sbe-comp_matnr.
          com_labst = cum_comp-labst + wbe-labst.
        WHEN lag_zeile.
          CLEAR lbe.                       "TGA/46C insert
          READ TABLE lbe WITH KEY matnr = sbe-comp_matnr
                                  werks = zle-werks
                                  lgort = zle-lgort.
          READ TABLE cum_comp WITH KEY comp_matnr = sbe-comp_matnr.
          com_labst = cum_comp-labst + lbe-labst.
      ENDCASE.
*1--- display stock of components gesamt-------------------------------*
*----zeile gesamtbesand komponenete -----------------------------------*
      FORMAT COLOR COL_TOTAL INTENSIFIED.
      WRITE:  /1  sy-vline,
               2  sbe-comp_matnr.
      WRITE:  37  sy-vline.
      MOVE 'COM_LABST' TO sav_fname0.
      PERFORM write_comp_line.
*    IF <D0> < 0.           "Minus-Zeichen rot einfärben
*      WRITE 37 MINUS COLOR COL_NEGATIVE.
*    ENDIF.
      WRITE   60  sy-vline.
      FORMAT COLOR OFF.
      WRITE  61 space38.
*-- nicht gebunden verf über struct. article---------------------------*
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      WRITE:  /1  sy-vline,
              2  text-075.             " 'direkt verfügbar'
      WRITE:  37  sy-vline.
      CASE sav_zeilen_kz.
        WHEN wrk_zeile.
          MOVE 'WBE-LABST' TO sav_fname0.
          PERFORM write_comp_line.
        WHEN lag_zeile.
          MOVE 'LBE-LABST' TO sav_fname0.
          PERFORM write_comp_line.
      ENDCASE.
*    IF EKVK_SUM-EKWER < 0.           "Minus-Zeichen rot einfärben
*      WRITE 36 MINUS COLOR COL_NEGATIVE.
*    ENDIF.
      WRITE   60  sy-vline.
      FORMAT COLOR OFF.
      WRITE  61 space38.
*--- gebunden gesamt----------- ---------------------------------------*
      FORMAT COLOR COL_TOTAL.
      WRITE:  /1  sy-vline,
               2  text-076,            "verfügbar über
*    IF EKVK_SUM-VKWER < 0.           "Minus-Zeichen rot einfärben
*      WRITE 36 MINUS COLOR COL_NEGATIVE.
*    ENDIF.
*      WRITE   55  sy-vline.
*      FORMAT COLOR OFF.
*     WRITE  56 space38.
*      WRITE:  /1  sy-vline,
                 text-079.            "'strukt. Material
      WRITE:  37  sy-vline.

      str_labst = cum_comp-labst.
      MOVE 'STR_LABST' TO sav_fname0.
      PERFORM write_comp_line.         "menge gebunden gesamt
*      WRITE:  32  sy-vline.
      WRITE:  60  sy-vline.
    ENDAT.
*----components aof struct materials
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:  /1  sy-vline,
             3  sbe-stru_matnr.        "MAtnr Stru Art
    WRITE:  37  sy-vline.
    MOVE 'SBE-LABST' TO sav_fname0.
    PERFORM write_comp_line.
*    IF EKVK_SUM-VKWER < 0.           "Minus-Zeichen rot einfärben
*      WRITE 36 MINUS COLOR COL_NEGATIVE.
*    ENDIF.
    WRITE   60  sy-vline.
    FORMAT COLOR OFF.
    WRITE  61 space38.
*    ENDIF.
  ENDLOOP.
  WRITE: / strich60 COLOR OFF, 61 space38 COLOR OFF.

ENDFORM.                               " write_stock_of_strart
*&---------------------------------------------------------------------*
*&      Form  write_comp_line
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_comp_line.

  ASSIGN (sav_fname0) TO <f0>.
  PERFORM umschluesseln_einzelbestand.
*  tga /  acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
*  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    IF p_kzngc IS INITIAL.                     "TGA/19.03.99/KZNGC
*  WRITE 38(18) <D1>    .                   "TGA/46C delete
      WRITE 38(18) <d0>    .                    "TGA/46C insert
    ELSE.                                       "TGA/19.03.99/KZNGC
*  WRITE 38(18) <D1>  UNIT T_MATNR-MEINS  . "TGA/46C delete
      WRITE 38(18) <d0>  UNIT t_matnr-meins  .  "TGA/46C insert
    ENDIF.
  ELSE.
    IF p_kzngc IS INITIAL.
      WRITE  <d0>  TO wa_comp_mat_stock-s_bstndtxt.
    ELSE.
      WRITE <d0>  UNIT t_matnr-meins TO wa_comp_mat_stock-s_bstndtxt.
    ENDIF.
  ENDIF.
ENDFORM.                               " write_comp_line
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_CH_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_ch_write .
  DATA lv_labst1 TYPE f VALUE '0.0000000000000000E+00'.

  IF zle-charg    IS INITIAL AND
     zle-sgt_scat IS NOT INITIAL.
    IF p_kzseg IS NOT INITIAL.
     READ TABLE cbe WITH KEY matnr    = zle-matnr
                             werks    = zle-werks
                             lgort    = zle-lgort
                             sgt_scat = zle-sgt_scat.
    ENDIF.
ENHANCEMENT-POINT RWBE1F07_01 SPOTS ES_RWBEST01 .

  ELSEIF zle-charg IS INITIAL AND
         zle-sgt_scat IS INITIAL.
    IF p_kzseg IS NOT INITIAL.
      READ TABLE cbe WITH KEY matnr = zle-matnr
                              werks = zle-werks
                              lgort = zle-lgort
                              sgt_scat = space.
    ENDIF.
  ELSE.
    READ TABLE cbe WITH KEY matnr = zle-matnr
                            werks = zle-werks
                            lgort = zle-lgort
                            charg = zle-charg.
  ENDIF.

  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'CBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.
  IF zle-charg    IS INITIAL AND
     zle-sgt_scat IS NOT INITIAL.
    IF p_kzseg IS NOT INITIAL.
      LOOP AT einzel_anzeige.
        CLEAR lv_labst1.
        LOOP AT cbe WHERE matnr    = zle-matnr
                    AND   werks    = zle-werks
                    AND   lgort    = zle-lgort
                    AND   sgt_scat = zle-sgt_scat.

          MOVE 'CBE-'               TO sav_fname0(4).
          MOVE einzel_anzeige-bfnae TO sav_fname0+4.
          ASSIGN (sav_fname0) TO <f0>.

          lv_labst1 = lv_labst1 + <f0>.
        ENDLOOP.
        IF lv_labst1 IS NOT INITIAL.
          <f0> = lv_labst1.
        ENDIF.
*   Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*            des Popups sondern die Größe der Hauptliste zieht
        RESERVE izaehl_eman LINES.
        PERFORM umschluesseln_einzelbestand.
        PERFORM einzel_zeile_write.
      ENDLOOP.
    ENDIF.
ENHANCEMENT-POINT RWBE1F07_02 SPOTS ES_RWBEST01 .

  ELSEIF zle-charg IS INITIAL AND
         zle-sgt_scat IS INITIAL.
    IF p_kzseg IS NOT INITIAL.
      LOOP AT einzel_anzeige.
        CLEAR lv_labst1.
        LOOP AT cbe WHERE matnr    = zle-matnr
                    AND   werks    = zle-werks
                    AND   lgort    = zle-lgort
                    AND   sgt_scat = space.

          MOVE 'CBE-'               TO sav_fname0(4).
          MOVE einzel_anzeige-bfnae TO sav_fname0+4.
          ASSIGN (sav_fname0) TO <f0>.

          lv_labst1 = lv_labst1 + <f0>.
        ENDLOOP.
        IF lv_labst1 IS NOT INITIAL.
          <f0> = lv_labst1.
        ENDIF.
*   Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*            des Popups sondern die Größe der Hauptliste zieht
        RESERVE izaehl_eman LINES.
        PERFORM umschluesseln_einzelbestand.
        PERFORM einzel_zeile_write.
      ENDLOOP.
    ENDIF.
  ELSE.
    LOOP AT einzel_anzeige.
      MOVE 'CBE-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
      RESERVE izaehl_eman LINES.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_write.
    ENDLOOP.
  ENDIF.
* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.

ENDFORM.                    " EINZELANZEIGE_CH_WRITE
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_KONSIKUNDE_CHARG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_konsikunde_charg .
  CLEAR izaehl.
  DESCRIBE TABLE einzel_anzeige LINES izaehl.

  izaehl = izaehl + 2.
*--- Aktuell wird als Zeilenzahl für das Window immer die der
*--- Hauptliste unterstellt also 20 statt 16 - deswegen werden
*--- zusätzlich 4 Zeilen reserviert.
  izaehl = izaehl + 4.
* CASE ZEILEN-KZ.    ????entfällt wegen s.u.
*   WHEN WRK_ZEILE.
  LOOP AT wbs_seg
       WHERE matnr =  zle-matnr
         AND werks =  zle-werks
         AND charg = zle-charg.
*---- Prüfung Nullbestand für Einzelliste -----------------------------*
    MOVE 'WBS_SEG-' TO sav_fname0(4).
    PERFORM nullbestand_pruefen_einzel.
    CHECK nullcheck NE 0.
    RESERVE izaehl LINES.
    PERFORM kunde_write USING wbs-kunnr.
    kntab-kunnr = wbs-kunnr.
    PERFORM kname_write.
    DETAIL.
    LOOP AT einzel_anzeige.
      MOVE 'WBS_SEG-'               TO sav_fname0(4).
      MOVE einzel_anzeige-bfnae TO sav_fname0+4.
      ASSIGN (sav_fname0) TO <f0>.
      PERFORM umschluesseln_einzelbestand.
      PERFORM einzel_zeile_sond_write.
    ENDLOOP.
*   tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      WRITE: / strich42 COLOR OFF, 43 space38 COLOR OFF.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " EINZELANZEIGE_KONSIKUNDE_CHARG
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_SAT_WRITE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_sat_write .
*---- Mandantenbestandsdaten für ausgewähltes Material beschaffen -----*
  READ TABLE mbe WITH KEY matnr = zle-satnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  LOOP AT einzel_anzeige.
    MOVE 'MBE-'               TO sav_fname0(4).
    MOVE einzel_anzeige-bfnae TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
* Achtung: Reserve Lines notwendig vor Write, da nicht die Größe
*          des Popups sondern die Größe der Hauptliste zieht
    RESERVE izaehl_eman LINES.
    PERFORM umschluesseln_einzelbestand.
    PERFORM einzel_zeile_write.
  ENDLOOP.

* tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    WRITE / strich38.
  ELSE.
    PERFORM show_single_stnd_grid.
  ENDIF.
ENDFORM.                    " EINZELANZEIGE_SAT_WRITE
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_CH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_ch .
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100 STARTING AT 40 04
                    ENDING   AT 77 19.
  ELSE.
    PERFORM show_single_detail.
  ENDIF.
ENDFORM.                    " EINZELANZEIGE_CH
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_CH_SOND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_ch_sond .
  CASE sond_kz.
    WHEN konsikunde.
      PERFORM einzelanzeige_konsikunde.

    WHEN aufbskunde.
* tga/46C move pf-status/set titlebar in pbo for concerning dynpro
*     SET PF-STATUS pfstatus_eman.
      PERFORM einzelanzeige_aufbskunde.

    WHEN beistlief.
      PERFORM einzelanzeige_beistlief.
  ENDCASE.
ENDFORM.                    " EINZELANZEIGE_CH_SOND
*&---------------------------------------------------------------------*
*&      Form  EINZELANZEIGE_SAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM einzelanzeige_sat .
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    CALL SCREEN 100  STARTING AT 40 04
                     ENDING   AT 77 19 .
  ELSE.
    PERFORM show_single_detail.
  ENDIF.
ENDFORM.                    " EINZELANZEIGE_SAT
