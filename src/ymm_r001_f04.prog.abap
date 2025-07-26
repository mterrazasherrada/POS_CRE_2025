*-------------------------------------------------------------------
***INCLUDE RWBE1F04 .
*  Allgemeine Hilfsroutinen für die Listenanzeigen
*  (analog RMMMBEFG)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  GRUNDLISTEN_FELDER
*&---------------------------------------------------------------------*
*       Bestimmen der Anzeige-Felder der Grundliste/Aufrißliste zur    *
*       gewählten Anzeigeversion                                       *
*----------------------------------------------------------------------*
FORM grundlisten_felder.

  DATA: hfennr LIKE t136-fennr,     "//JH zu 1.2A1 (s.a. intPr 197005)
        hspanr LIKE t136-spanr.

  CLEAR   grund_anzeige.
  REFRESH grund_anzeige.
  CLEAR   r_fname.             "//JH zu 1.2A1 (s.a. intPr 197005)
  REFRESH r_fname.

  IF p_kzlon IS INITIAL.       "//JH zu 1.2A1 (s.a. intPr 197005)
*---- Falls das Kennzeichen 'Offene Bestände mitselektieren'       ----*
*---- nicht gesetzt ist, werden automatisch alle Bestandsspalten,  ----*
*---- die zur Anzeige von offenen Bestandsmengen dienen, aus der   ----*
*---- Listanzeige in der Grund- und Aufrißliste herausgenommen     ----*
*---- Anmerkung: Das Kennzeichen 'Sonderbestände mitselektieren    ----*
*---- braucht in der Grundliste nicht berücksichtigt zu werden,    ----*
*---- denn wenn keine Sonderbestände gelesen werden, werden auch   ----*
*---- automatisch keine Sonderbestandszeilen angezeigt.            ----*
    PERFORM fuelle_fname_range.
  ENDIF.

* SELECT * FROM T136 WHERE VERNU = RMMMB-VERNU.    "//JH zu 1.2A1
  SELECT * FROM t136 WHERE vernu =  rmmmb-vernu    "(s.a. intPr 197005)
                       AND fname IN r_fname.
    MOVE-CORRESPONDING t136 TO grund_anzeige.

    CLEAR t157b.
    SELECT SINGLE * FROM t157b
           WHERE spras = sy-langu
           AND   feldv = t136-fname.

    MOVE t157b-ftext TO grund_anzeige-text.
    APPEND grund_anzeige.
  ENDSELECT.

  SORT grund_anzeige ASCENDING BY fennr spanr.

  IF p_kzlon IS INITIAL.       "//JH zu 1.2A1 (s.a. intPr 197005)
*---- Falls nicht alle im Customizing hinterlegten Bestandsspalten ----*
*---- zur Anzeige kommen, müssen die Fenster- und Spaltennr. u.U.  ----*
*---- neu durchnumeriert werden                                    ----*
    hfennr = 1. hspanr = 1.
    LOOP AT grund_anzeige.
      IF grund_anzeige-fennr <> hfennr
      OR grund_anzeige-spanr <> hspanr.
        grund_anzeige-fennr = hfennr.
        grund_anzeige-spanr = hspanr.
        MODIFY grund_anzeige.
      ENDIF.
      hspanr = hspanr + 1.
      IF hspanr > 3.
        hspanr = 1.
        hfennr = hfennr + 1.
      ENDIF.
    ENDLOOP.
  ENDIF.

*---- Letzte Fensternr. hinterlegen (wg. Funktion 'Ganz nach rechts') -*
  DESCRIBE TABLE grund_anzeige LINES sy-tfill.
  READ TABLE grund_anzeige INDEX sy-tfill.
  ende_fennr = grund_anzeige-fennr.
*---TGA/Erweiterungen str.Art 140699 (start)
*----is LABST part of selechted stocks?, if not, no infos about
*----components in structured articles
  READ TABLE grund_anzeige  WITH KEY fname = 'LABST'.
  IF sy-subrc NE 0.
    MOVE stru TO t_fcodes_e-fcode.
    APPEND t_fcodes_e.
  ENDIF.
*---TGA/Erweiterungen str.Art  140699 (end)

ENDFORM.                               " GRUNDLISTEN_FELDER

*&---------------------------------------------------------------------*
*&      Form  INITIALISIERUNG
*&---------------------------------------------------------------------*
*       Initialisieren der Grundliste bzw. Aufrißliste der nächsten    *
*       Ebene.                                                         *
*       Bestimmen der anzuzeigenden Bestandsfelder inkl. der zuge-     *
*       hörigen Texte.                                                 *
*----------------------------------------------------------------------*
FORM initialisierung.

*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR  SAV-BUKRS.
*#jhl 01.02.96 NEW-PAGE b. Wechsel d. Basiswrk.grp. unterdrücken
* CLEAR  SAV-BWGRP.
  CLEAR: sav_text1,  sav_text2,  sav_text3.
  CLEAR: sav_fname1, sav_fname2, sav_fname3.
  izaehl = 1.
  LOOP AT grund_anzeige
         WHERE fennr = rmmmb-fennr.
    CASE izaehl.
      WHEN 1.
        izaehl = izaehl + 1.
        MOVE: grund_anzeige-text   TO sav_text1,
              grund_anzeige-fname  TO sav_fname1+4.
      WHEN 2.
        izaehl = izaehl + 1.
        MOVE: grund_anzeige-text   TO sav_text2,
              grund_anzeige-fname  TO sav_fname2+4.
      WHEN 3.
        izaehl = izaehl + 1.
        MOVE: grund_anzeige-text   TO sav_text3,
              grund_anzeige-fname  TO sav_fname3+4.
      WHEN OTHERS.
        EXIT.
    ENDCASE.
  ENDLOOP.

*---- Spaltenüberschriften rechtsbündig ausrichten --------------------*
  CLASS cl_scp_linebreak_util DEFINITION LOAD.             "note 1019175
  CALL METHOD cl_scp_linebreak_util=>get_visual_stringlength
    EXPORTING
      im_string               = sav_text1
    IMPORTING
      ex_pos_vis              = laenge
    EXCEPTIONS
      invalid_text_enviroment = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    laenge = strlen( sav_text1 ).
  ENDIF.
  izaehl = izaehl17 - laenge.
  IF izaehl GE 1.
    SHIFT sav_text1 BY izaehl PLACES RIGHT.
  ENDIF.

  CALL METHOD cl_scp_linebreak_util=>get_visual_stringlength
    EXPORTING
      im_string               = sav_text2
    IMPORTING
      ex_pos_vis              = laenge
    EXCEPTIONS
      invalid_text_enviroment = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    laenge = strlen( sav_text2 ).
  ENDIF.
  izaehl = izaehl17 - laenge.
  IF izaehl GE 1.                "s.o.
    SHIFT sav_text2 BY izaehl PLACES RIGHT.
  ENDIF.

  CALL METHOD cl_scp_linebreak_util=>get_visual_stringlength
    EXPORTING
      im_string               = sav_text3
    IMPORTING
      ex_pos_vis              = laenge
    EXCEPTIONS
      invalid_text_enviroment = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    laenge = strlen( sav_text3 ).
  ENDIF.
  izaehl = izaehl17 - laenge.
  IF izaehl GE 1.                "s.o.
    SHIFT sav_text3 BY izaehl PLACES RIGHT.
  ENDIF.

ENDFORM.                               " INITIALISIERUNG

*&---------------------------------------------------------------------*
*&      Form  ASSIGN_GRUNDLISTE
*&---------------------------------------------------------------------*
*       Zuweisung der Grundlistenfelder zu den Feldsymbolen <F1>,      *
*       <F2>, <F3>                                                     *
*----------------------------------------------------------------------*
FORM assign_grundliste.

  CLEAR: kzexi_f1, kzexi_f2, kzexi_f3.
  ASSIGN (sav_fname1) TO <f1>.
  IF sy-subrc NE 0.
    kzexi_f1 = x.
  ENDIF.
  ASSIGN (sav_fname2) TO <f2>.
  IF sy-subrc NE 0.
    kzexi_f2 = x.
  ENDIF.
  ASSIGN (sav_fname3) TO <f3>.
  IF sy-subrc NE 0.
    kzexi_f3 = x.
  ENDIF.

ENDFORM.                               " ASSIGN_GRUNDLISTE

*&---------------------------------------------------------------------*
*&      Form  UMSCHLUESSELN_ZEILE
*&---------------------------------------------------------------------*
*       Die Felder einer Zeile der Grund- bzw. Aufrißliste werden vom
*       Feldnamen der jeweiligen internen Tabelle auf den entsprechenden
*       Datenbank-Feldnamen umgeschlüsselt.
*       Hierzu werden SAV_FNAME1/2/3 umgeschlüsselt und den Feldsymbolen
*       <D1>/<D2>/<D3> zugewiesen.
*       (wegen F1-Hilfe-Unterstützung und Datentyprückkonvertierung)
*----------------------------------------------------------------------*
FORM umschluesseln_zeile.

  IF kzexi_f1 IS INITIAL.              "Falls <F1>-Feld existriert
    intab_name = sav_fname1.
    PERFORM umschluesseln.
    ASSIGN (dbtab_name) TO <d1>.
    IF sy-subrc = 0.
      <d1> = <f1>.
    ELSE.
      CLEAR <d1>.
    ENDIF.
  ELSE.
    ASSIGN (dummy) TO <d1>.      "<D1>-Feld ist ein nicht ex. Dummy-Feld
  ENDIF.
  IF kzexi_f2 IS INITIAL.
    intab_name = sav_fname2.
    PERFORM umschluesseln.
    ASSIGN (dbtab_name) TO <d2>.
    IF sy-subrc = 0.
      <d2> = <f2>.
    ELSE.
      CLEAR <d2>.
    ENDIF.
  ELSE.
    ASSIGN (dummy) TO <d2>.
  ENDIF.
  IF kzexi_f3 IS INITIAL.
    intab_name = sav_fname3.
    PERFORM umschluesseln.
    ASSIGN (dbtab_name) TO <d3>.
    IF sy-subrc = 0.
      <d3> = <f3>.
    ELSE.
      CLEAR <d3>.
    ENDIF.
  ELSE.
    ASSIGN (dummy) TO <d3>.
  ENDIF.
ENDFORM.                               " UMSCHLUESSELN_ZEILE

*&---------------------------------------------------------------------*
*&      Form  UMSCHLUESSELN
*&---------------------------------------------------------------------*
*       Umschlüsseln des Feldnamens einer int. Tabelle (->INTAB_NAME)
*       in den entsprechenden DB-Feldnamen (->DBTAB_NAME).
*----------------------------------------------------------------------*
FORM umschluesseln.

* Ermitteln des entspr. Feldnamens der DB-Tabelle
  CASE intab_name+4.
    WHEN 'LABST'.
      CASE sond_kz.
        WHEN konsilief.
          dbtab_name = 'MKOL-SLABS'.
        WHEN aufbskunde.
          dbtab_name = 'MSKA-KALAB'.
        WHEN beistlief.
          dbtab_name = 'MSLB-LBLAB'.
        WHEN konsikunde.
          dbtab_name = 'MSKU-KULAB'.
        WHEN lrgutkunde.
          dbtab_name = 'MSKU-KULAB'.
        WHEN mtverpack.                                     "neu zu 3.0
          dbtab_name = 'MKOL-SLABS'.
        WHEN prjbestand.                                    "neu zu 3.0
          dbtab_name = 'MSPR-PRLAB'.
        WHEN OTHERS.
          dbtab_name = 'MARD-LABST'.
      ENDCASE.
    WHEN 'UMLME'.
      dbtab_name = 'MARD-UMLME'.
    WHEN 'INSME'.
      CASE sond_kz.
        WHEN konsilief.
          dbtab_name = 'MKOL-SINSM'.
        WHEN aufbskunde.
          dbtab_name = 'MSKA-KAINS'.
        WHEN beistlief.
          dbtab_name = 'MSLB-LBINS'.
        WHEN konsikunde.
          dbtab_name = 'MSKU-KUINS'.
        WHEN lrgutkunde.
          dbtab_name = 'MSKU-KUINS'.
        WHEN mtverpack.                                     "neu zu 3.0
          dbtab_name = 'MKOL-SINSM'.
        WHEN prjbestand.                                    "neu zu 3.0
          dbtab_name = 'MSPR-PRINS'.
        WHEN OTHERS.
          dbtab_name = 'MARD-INSME'.
      ENDCASE.
    WHEN 'EINME'.
      CASE sond_kz.
        WHEN konsilief.
          dbtab_name = 'MKOL-SEINM'.
        WHEN mtverpack.
          dbtab_name = 'MKOL-SEINM'.                        "neu zu 3.0
        WHEN prjbestand.
          dbtab_name = 'MSPR-PREIN'.                        "neu zu 3.0
        WHEN beistlief.
          dbtab_name = 'MSLB-LBEIN'.                        "neu zu 3.0
        WHEN konsikunde.
          dbtab_name = 'MSKU-KUEIN'.                        "neu zu 3.0
        WHEN lrgutkunde.
          dbtab_name = 'MSKU-KUEIN'.                        "neu zu 3.0
        WHEN aufbskunde.
          dbtab_name = 'MSKA-KAEIN'.                        "neu zu 3.0
        WHEN OTHERS.
          dbtab_name = 'MARD-EINME'.
      ENDCASE.
    WHEN 'SPEME'.
      CASE sond_kz.
        WHEN konsilief.
          dbtab_name = 'MKOL-SSPEM'.
        WHEN aufbskunde.
          dbtab_name = 'MSKA-KASPE'.
        WHEN mtverpack.                                     "neu zu 3.0
          dbtab_name = 'MKOL-SSPEM'.
        WHEN prjbestand.                                    "neu zu 3.0
          dbtab_name = 'MSPR-PRSPE'.
        WHEN OTHERS.
          dbtab_name = 'MARD-SPEME'.
      ENDCASE.
    WHEN 'RETME'.
      dbtab_name = 'MARD-RETME'.
    WHEN 'UMLMC'.
      dbtab_name = 'MARC-UMLMC'.
    WHEN 'TRAME'.
      dbtab_name = 'MARC-TRAME'.
    WHEN 'WESPB'.
      dbtab_name = 'EKBE-WESBS'.
    WHEN 'VBMNA'.
      dbtab_name = 'RMMMB-VBMNA'.
    WHEN 'VBMNB'.
      dbtab_name = 'RMMMB-VBMNB'.
    WHEN 'VBMNC'.
      dbtab_name = 'RMMMB-VBMNC'.
    WHEN 'VBMNE'.
      dbtab_name = 'RMMMB-VBMNE'.
    WHEN 'VBMNG'.
      dbtab_name = 'RMMMB-VBMNG'.
    WHEN 'VBMNI'.
      dbtab_name = 'RMMMB-VBMNI'.
    WHEN 'OMENG'.
      dbtab_name = 'RMMMB-OMENG'.
    WHEN 'MENGE'.
      dbtab_name = 'RMMMB-MENGE'.      "?
    WHEN 'MENGK'.
      dbtab_name = 'RMMMB-MENGK'.      "?
    WHEN 'BDMNG'.
      dbtab_name = 'RMMMB-BDMNG'.      "?
    WHEN 'BDMNS'.
      dbtab_name = 'RMMMB-BDMNS'.      "?
    WHEN 'BSABR'.
      dbtab_name = 'RMMMB-BSABR'.
    WHEN 'FAMNG'.
      dbtab_name = 'RMMMB-FAMNG'.
    WHEN 'KLABS'.
      dbtab_name = 'MKOL-SLABS'.
    WHEN 'KINSM'.
      dbtab_name = 'MKOL-SINSM'.
    WHEN 'KEINM'.
      dbtab_name = 'MKOL-SEINM'.
    WHEN 'KSPEM'.
      dbtab_name = 'MARD-SPEME'.
    WHEN 'CALAB'.
      dbtab_name = 'MSCA-CALAB'.
    WHEN 'CAINS'.
      dbtab_name = 'MSCA-CAINS'.
    WHEN 'KALAB'.
      dbtab_name = 'MSKA-KALAB'.
    WHEN 'KAINS'.
      dbtab_name = 'MSKA-KAINS'.
    WHEN 'KASPE'.
      dbtab_name = 'MSKA-KASPE'.
    WHEN 'KAEIN'.
      dbtab_name = 'MSKA-KAEIN'.
    WHEN 'KULAV'.
      dbtab_name = 'MSKU-KULAB'.
    WHEN 'KUINV'.
      dbtab_name = 'MSKU-KUINS'.
    WHEN 'KUEIV'.
      dbtab_name = 'MSKU-KUEIN'.
    WHEN 'KULAW'.
      dbtab_name = 'MSKU-KULAB'.
    WHEN 'KUINW'.
      dbtab_name = 'MSKU-KUINS'.
    WHEN 'KUEIW'.
      dbtab_name = 'MSKU-KUEIN'.
    WHEN 'LBLAB'.
      dbtab_name = 'MSLB-LBLAB'.
    WHEN 'LBINS'.
      dbtab_name = 'MSLB-LBINS'.
    WHEN 'LBEIN'.
      dbtab_name = 'MSLB-LBEIN'.
    WHEN 'MLABS'.
      dbtab_name = 'MKOL-SLABS'.
    WHEN 'MINSM'.
      dbtab_name = 'MKOL-SINSM'.
    WHEN 'MEINM'.
      dbtab_name = 'MKOL-SEINM'.
    WHEN 'MSPEM'.
      dbtab_name = 'MKOL-SSPEM'.
    WHEN 'PRLAB'.
      dbtab_name = 'MSPR-PRLAB'.
    WHEN 'PRINS'.
      dbtab_name = 'MSPR-PRINS'.
    WHEN 'PRSPE'.
      dbtab_name = 'MSPR-PRSPE'.
    WHEN 'PREIN'.
      dbtab_name = 'MSPR-PREIN'.
    WHEN 'TRASF'.
      dbtab_name = 'RMMMB-TRASF'.
    WHEN 'LBKUM'.
      dbtab_name = 'MBEW-LBKUM'.
* JH/4.0A/28.07.97 Neues Bestandsfeld
    WHEN 'GLGMG'.
      dbtab_name = 'MARC-GLGMG'.
*<<< hier später weitere Sonderbestandsfelder eintragen!
    WHEN OTHERS.
      dbtab_name = intab_name.
      "dürfte eigentlich nicht auftreten
      "Achtung: DBTAB_NAME hat den Typ in diesem Fall den Typ F
      "und wird in der Anzeige entsprechend aufbereitet!
  ENDCASE.

ENDFORM.                               " UMSCHLUESSELN

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF
*&---------------------------------------------------------------------*
*       Aufbereitung des Seitenkopfes für Grund- und Aufrißliste bei
*       Bestandsdaten zu einzelnen Artikeln u. Artikellisten
*----------------------------------------------------------------------*
FORM seitenkopf.

  CASE drilldown_level.
    WHEN einzart_level.
      PERFORM seitenkopf_e.
    WHEN einzvar_level.
      PERFORM seitenkopf_v.
    WHEN artlist_level.
      PERFORM seitenkopf_l.
  ENDCASE.

ENDFORM.                               " SEITENKOPF

*&---------------------------------------------------------------------*
*&      Form  VAR_ASSIGN_GRUNDLISTE
*&---------------------------------------------------------------------*
*       Zuweisung des Bestandsfeldes zum Feldsymbol <F_VAR> für die    *
*       entsprechende Variante                                         *
*       (analog zu FORM ASSIGN_GRUNDLISTE für Variantenmatrix)
*----------------------------------------------------------------------*
FORM var_assign_grundliste.

  CLEAR: kzexi_f_var.
  ASSIGN (sav_fname_var) TO <f_var>.
  IF sy-subrc NE 0.
    kzexi_f_var = x.
  ENDIF.

ENDFORM.                               " VAR_ASSIGN_GRUNDLISTE

*&---------------------------------------------------------------------*
*&      Form  VAR_UMSCHLUESSELN_ZEILE
*&---------------------------------------------------------------------*
*       Die Felder auf der Variantenmatrix werden vom Feldnamen der
*       jeweiligen internen Tabelle auf den entsprechenden Datenbank-
*       Feldnamen umgeschlüsselt.
*       Hierzu wird SAV_FNAME_VAR umgeschlüsselt und dem Feldsymbol
*       <D_VAR> zugewiesen.
*       (wegen F1-Hilfe-Unterstützung und Datentyprückkonvertierung)
*       (analog zu FORM UMSCHLUESSELN_ZEILE bei Grund-/Aufrißliste)
*----------------------------------------------------------------------*
FORM var_umschluesseln_zeile.

  IF kzexi_f_var IS INITIAL.           "Falls <F_VAR>-Feld existiert
    intab_name = sav_fname_var.
    PERFORM umschluesseln.
    ASSIGN (dbtab_name) TO <d_var>.
    IF sy-subrc = 0.
      <d_var> = <f_var>.
    ELSE.
      CLEAR <d_var>.
    ENDIF.
  ELSE.
    ASSIGN (dummy) TO <d_var>."<D_VAR>-Feld ist ein nicht ex. Dummy-Feld
  ENDIF.

ENDFORM.                               " VAR_UMSCHLUESSELN_ZEILE

*&---------------------------------------------------------------------*
*&      Form  UMSCHLUESSELN_EINZELBESTAND
*&---------------------------------------------------------------------*
*       Jedes Feld der Einzelbestandsliste wird vom Feldnamen der
*       jeweiligen internen Tabelle auf den entsprechenden Datenbank-
*       Feldnamen umgeschlüsselt.
*       Hierzu wird SAV_FNAME0 umgeschlüsselt und dem Feldsymbol <D0>
*       zugewiesen.
*       (wegen F1-Hilfe-Unterstützung und Datentyprückkonvertierung)
*----------------------------------------------------------------------*
FORM umschluesseln_einzelbestand.
* Das folgende Coding wurde wg. falscher Anzeige bei F1 ausgesternt
* INTAB_NAME = SAV_FNAME0.
* PERFORM UMSCHLUESSELN.
* ASSIGN (DBTAB_NAME) TO <D0>.
* <D0> = <F0>.

* JH/21.01.97/1.2B KPr1018362 (Anfang)
* Vorläufiges Coding, um F1-Hilfe zu deaktivieren und um die Bestands-
* felder linksbündig anzuordnen.
* DBTAB_NAME = 'EZ_BESTAND'.
* ASSIGN (DBTAB_NAME) TO <D0>.
* <D0> = <F0>.
* Obiges Coding kann nun verwendet werden, weil der DDIC-Bezug bei einem
* WRITE für ASSIGN-Var. ab Rel. 3.0 erhalten bleibt
  intab_name = sav_fname0.
  PERFORM umschluesseln.
  ASSIGN (dbtab_name) TO <d0>.
  <d0> = <f0>.
* JH/21.01.97/1.2B KPr1018362 (Ende)

ENDFORM.                               " UMSCHLUESSELN_EINZELBESTAND

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_EINZEL_LISTE
*&---------------------------------------------------------------------*
*       Aufbereitung des Seitenkopfes für die Einzelliste bei
*       Bestandsdaten zu einzelnen Artikeln u. Artikellisten
*----------------------------------------------------------------------*
FORM seitenkopf_einzel_liste.

  CASE drilldown_level.
    WHEN einzart_level.
      PERFORM seitenkopf_einzel_e.
    WHEN einzvar_level.
      PERFORM seitenkopf_einzel_e.
    WHEN artlist_level.
      PERFORM seitenkopf_einzel_l.
  ENDCASE.

  SKIP 1.
*--- TEXT-030 = 'Bestand' rechtsbündig ausrichten -------------
  sav_text1 = text-030.
  CLASS cl_scp_linebreak_util DEFINITION LOAD.             "note 1019175
  CALL METHOD cl_scp_linebreak_util=>get_visual_stringlength
    EXPORTING
      im_string               = sav_text1
    IMPORTING
      ex_pos_vis              = laenge
    EXCEPTIONS
      invalid_text_enviroment = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    laenge = strlen( sav_text1 ).
  ENDIF.
  izaehl = izaehl17 - laenge.
  IF izaehl GE 1.
    SHIFT sav_text1 BY izaehl PLACES RIGHT.
  ENDIF.

  IF sond_kz IS INITIAL.
    WRITE  /  strich38.
    FORMAT COLOR COL_HEADING INTENSIFIED INVERSE OFF.
    WRITE: /1 sy-vline,
            2 text-031,
           19 sy-vline,
           20 sav_text1,
           38 sy-vline.
    FORMAT COLOR OFF.
    WRITE  39 space42.
    WRITE  /  strich38.
    FORMAT COLOR OFF.
    WRITE  39 space42.
  ELSE.
    WRITE  /  strich42.
    FORMAT COLOR COL_HEADING INTENSIFIED INVERSE OFF.
    WRITE: /1 sy-vline,
            6 text-031,
           24 sav_text1,
           42 sy-vline.
    FORMAT COLOR OFF.
    WRITE  43 space38.
    WRITE  /  strich42.
    FORMAT COLOR OFF.
    WRITE  43 space38.
  ENDIF.

ENDFORM.                               " SEITENKOPF_EINZEL_LISTE

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_E
*&---------------------------------------------------------------------*
*       Seitenkopf bei Grund-/Aufrißliste für Einzelartikel
*----------------------------------------------------------------------*
FORM seitenkopf_e.

  READ TABLE t_matnr WITH KEY matnr = mbe-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  kz_nsel = 1.                         "1. Zeile des Seitenkopfs
  WRITE:  text-007                     "Klartext - Material
            COLOR COL_HEADING INVERSE.

  WRITE:  19 t_matnr-matnr             "Materialnummer
            COLOR COL_BACKGROUND INTENSIFIED OFF INPUT.

  WRITE:  38 t_matnr-maktx             "Kurztext
            COLOR COL_BACKGROUND INTENSIFIED OFF.
  HIDE kz_nsel.

*#jhl 25.01.96 Materialart als Information entfällt
* KZ_NSEL = X.                          "X. Zeile des Seitenkopfs
* WRITE:  / TEXT-015                    "Klartext - Materialart
*           COLOR COL_HEADING INVERSE,
*         19 T_MATNR-MTART              "Materialart
*           COLOR COL_BACKGROUND INTENSIFIED OFF,
*         38 T134T-MTBEZ                "Materialart-Bezeichnung
*           COLOR COL_BACKGROUND INTENSIFIED OFF.
* HIDE KZ_NSEL.

  kz_nsel = 2.                         "2. Zeile des Seitenkopfs
  WRITE:  / text-016                   "Klartext - Mengeneinheit
            COLOR COL_HEADING INVERSE.

  WRITE:  19 t_matnr-meins             "Mengeneinheit.
            COLOR COL_BACKGROUND INTENSIFIED OFF INPUT.

  WRITE:    38 text-017                "Klartext - Basismengeneinheit
              COLOR COL_HEADING INVERSE,

            61 t_matnr-basme           "Basismengeneinheit
              COLOR COL_BACKGROUND INTENSIFIED OFF.
  HIDE kz_nsel.

  kz_nsel = 3.                         "3. Zeile des Seitenkopfs
  WRITE / space.
  HIDE kz_nsel.
  SKIP.

  kz_nsel = 4.                         "4. Zeile des Seitenkopfs
  zeilen_kz = strich_zeile.
  WRITE: /01  sy-uline.
  HIDE: kz_nsel,
        zeilen_kz.

*????nur für tests (Ausgabe der Laufzeit für Bestandsermittlung)
* WRITE: 65(10) RUN_TIME USING EDIT MASK 'RR______,___' NO-GAP, ' ms '.

  kz_nsel = 5.                         "5. Zeile des Seitenkopfs
  FORMAT COLOR COL_HEADING.
  WRITE / sy-vline NO-GAP.
  CASE kz_list.
    WHEN grund_liste.
      WRITE: text-018.                 "Ueberschrift
    WHEN man_zeile.
      WRITE: text-057.                 "Ueberschrift
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*      WHEN BUK_ZEILE.
*           WRITE: TEXT-019.            "Ueberschrift
    WHEN wgr_zeile.
      WRITE: text-019.                 "Ueberschrift
    WHEN wrk_zeile.
      WRITE: text-020.                 "Ueberschrift
    WHEN lag_zeile.
      WRITE: text-021.                 "Ueberschrift
*????  WHEN CHA_ZEILE.
*entfällt   WRITE: TEXT-009.            "Ueberschrift
    WHEN beistlief.
      WRITE: text-022.                 "Ueberschrift
    WHEN konsikunde.
      WRITE: text-023.                 "Ueberschrift
    WHEN lrgutkunde.
      WRITE: text-024.                 "Ueberschrift
  ENDCASE.
  zeilen_kz = ueb_zeile.
  WRITE:     26  sy-vline,
             27  sav_text1,            "Klartext Bestand 1
             44  sy-vline.
  IF NOT sav_text2 IS INITIAL.
    WRITE:     45  sav_text2.          "Klartext Bestand 2
    IF NOT sav_text3 IS INITIAL.
      WRITE:     63  sav_text3.        "Klartext Bestand 3
    ENDIF.
  ENDIF.
  WRITE: 62 sy-vline, 80 sy-vline.
  HIDE:          zeilen_kz,
                 kz_nsel.
  FORMAT COLOR OFF.

  kz_nsel = 6.                         "6. Zeile des Seitenkopfs
  zeilen_kz = strich_zeile.
  WRITE:  /01  sy-uline.
  HIDE:          zeilen_kz,
                 kz_nsel.
  CLEAR kz_nsel.

*????nur für tests (Ausgabe der Laufzeit fürs Lesen der ME's)
* RUN_TIMED = RUN_TIME2 - RUN_TIME1.
* WRITE: 65(10) RUN_TIMED USING EDIT MASK 'RR______,___' NO-GAP, ' ms '.

ENDFORM.                               " SEITENKOPF_E

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_V
*&---------------------------------------------------------------------*
*       Seitenkopf bei Grund-/Aufrißliste für Einzelvariante
*----------------------------------------------------------------------*
FORM seitenkopf_v.

  READ TABLE t_matnr WITH KEY matnr = mbe-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  kz_nsel = 1.                         "1. Zeile des Seitenkopfs
  WRITE:  text-007                     "Klartext - Material
            COLOR COL_HEADING INVERSE.

  WRITE:  19 t_matnr-matnr             "Materialnummer
            COLOR COL_BACKGROUND INTENSIFIED OFF INPUT.

  WRITE:  38 t_matnr-maktx             "Kurztext
            COLOR COL_BACKGROUND INTENSIFIED OFF.
  HIDE kz_nsel.

*#jhl 25.01.96 Materialart als Information entfällt
* KZ_NSEL = X.                          "X. Zeile des Seitenkopfs
* WRITE:  / TEXT-015                    "Klartext - Materialart
*           COLOR COL_HEADING INVERSE,
*         19 T_MATNR-MTART              "Materialart
*           COLOR COL_BACKGROUND INTENSIFIED OFF,
*         38 T134T-MTBEZ                "Materialart-Bezeichnung
*           COLOR COL_BACKGROUND INTENSIFIED OFF.
* HIDE KZ_NSEL.

  kz_nsel = 2.                         "2. Zeile des Seitenkopfs
  WRITE:  / text-016                   "Klartext - Mengeneinheit
            COLOR COL_HEADING INVERSE.

  WRITE:  19 t_matnr-meins             "Mengeneinheit.
            COLOR COL_BACKGROUND INTENSIFIED OFF INPUT.

  WRITE:    38 text-017                "Klartext - Basismengeneinheit
              COLOR COL_HEADING INVERSE,

            61 t_matnr-basme           "Basismengeneinheit
              COLOR COL_BACKGROUND INTENSIFIED OFF.
  HIDE kz_nsel.

  LOOP AT t_merkm.
    kz_nsel = kz_nsel + 1.
    IF sy-tabix = 1.
      WRITE:  / text-006               "Klartext - Merkmale
                COLOR COL_HEADING INVERSE.
    ELSE.
      WRITE:  / space.
    ENDIF.

    PERFORM var_bewertung.

    WRITE:    19 t_merkm-atbez         "Merkmal
                 COLOR COL_BACKGROUND INTENSIFIED OFF.

    WRITE:    51 t_bewert-atwtb        "Merkmalswertbezeichnung
                 COLOR COL_BACKGROUND INTENSIFIED OFF.
    HIDE kz_nsel.
  ENDLOOP.

  kz_nsel = kz_nsel + 1.
  WRITE / space.
  HIDE kz_nsel.
  SKIP.

  kz_nsel = kz_nsel + 1.
  zeilen_kz = strich_zeile.
  WRITE: /01  sy-uline.
  HIDE: kz_nsel,
        zeilen_kz.

  kz_nsel = kz_nsel + 1.
  FORMAT COLOR COL_HEADING.
  WRITE / sy-vline NO-GAP.
  CASE kz_list.
    WHEN grund_liste.
      WRITE: text-018.                 "Ueberschrift
    WHEN man_zeile.
      WRITE: text-057.                 "Ueberschrift
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*      WHEN BUK_ZEILE.
*           WRITE: TEXT-019.            "Ueberschrift
    WHEN wgr_zeile.
      WRITE: text-019.                 "Ueberschrift
    WHEN wrk_zeile.
      WRITE: text-020.                 "Ueberschrift
    WHEN lag_zeile.
      WRITE: text-021.                 "Ueberschrift
*????  WHEN CHA_ZEILE.
*entfällt   WRITE: TEXT-009.            "Ueberschrift
    WHEN beistlief.
      WRITE: text-022.                 "Ueberschrift
    WHEN konsikunde.
      WRITE: text-023.                 "Ueberschrift
    WHEN lrgutkunde.
      WRITE: text-024.                 "Ueberschrift
  ENDCASE.
  zeilen_kz = ueb_zeile.
  WRITE:     26  sy-vline,
             27  sav_text1,            "Klartext Bestand 1
             44  sy-vline.
  IF NOT sav_text2 IS INITIAL.
    WRITE:     45  sav_text2.          "Klartext Bestand 2
    IF NOT sav_text3 IS INITIAL.
      WRITE:     63  sav_text3.        "Klartext Bestand 3
    ENDIF.
  ENDIF.
  WRITE: 62 sy-vline, 80 sy-vline.
  HIDE:          zeilen_kz,
                 kz_nsel.
  FORMAT COLOR OFF.

  kz_nsel = kz_nsel + 1.
  zeilen_kz = strich_zeile.
  WRITE:  /01  sy-uline.
  HIDE:          zeilen_kz,
                 kz_nsel.
  CLEAR kz_nsel.

ENDFORM.                               " SEITENKOPF_V

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_L
*&---------------------------------------------------------------------*
*       Seitenkopf bei Grundliste für Artikelliste
*----------------------------------------------------------------------*
FORM seitenkopf_l.

  kz_nsel = 1.                         "1. Zeile des Seitenkopfs
  zeilen_kz = strich_zeile.
  WRITE: /01  sy-uline.
  HIDE: kz_nsel,
        zeilen_kz.
*????nur für tests (Ausgabe der Laufzeit für Bestandsermittlung)
* WRITE: 65(10) RUN_TIME USING EDIT MASK 'RR______,___' NO-GAP, ' ms '.

  kz_nsel = 2.                         "2. Zeile des Seitenkopfs
  FORMAT COLOR COL_HEADING.
  WRITE / sy-vline NO-GAP.
  WRITE: text-033.                     "Ueberschrift
  zeilen_kz = ueb_zeile.
  WRITE:     26  sy-vline,
             27  sav_text1,            "Klartext Bestand 1
             44  sy-vline.
  IF NOT sav_text2 IS INITIAL.
    WRITE:     45  sav_text2.          "Klartext Bestand 2
    IF NOT sav_text3 IS INITIAL.
      WRITE:     63  sav_text3.        "Klartext Bestand 3
    ENDIF.
  ENDIF.
  WRITE: 62 sy-vline, 80 sy-vline.
  HIDE:          zeilen_kz,
                 kz_nsel.
  FORMAT COLOR OFF.

  kz_nsel = 3.                         "3. Zeile des Seitenkopfs
  zeilen_kz = strich_zeile.
  WRITE:  /01  sy-uline.
  HIDE:  zeilen_kz,
         kz_nsel.
  CLEAR kz_nsel.

ENDFORM.                               " SEITENKOPF_L

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_EINZEL_E
*&---------------------------------------------------------------------*
*       Seitenkopf bei Einzeliste für Einzelartikel
*----------------------------------------------------------------------*
FORM seitenkopf_einzel_e.

  FORMAT COLOR COL_HEADING INVERSE.
  CASE zeilen_kz.
    WHEN man_zeile.
      WRITE: /10  text-030,            "Klartext 'Bestand'
                  text-014.            "Klartext 'Gesamt'.
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*      WHEN BUK_ZEILE.
*           WRITE: /05 TEXT-030,   "Klartext 'Bestand'
*                      TEXT-027,   "Klartext 'Buchungskreis'
*                      BBE-BUKRS   "Buchungskreis
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*#jhl 31.01.96 (Ende)
    WHEN wgr_zeile.
      IF gbe-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
        READ TABLE t_bwgrp WITH KEY bwgrp = gbe-bwgrp BINARY SEARCH.
        IF sy-subrc NE 0.
          MESSAGE a038 WITH 'GBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
        ENDIF.
        WRITE: /05 text-030,           "Klartext 'Bestand'
                   text-027,           "Klartext 'Basiswerksgruppe'
               /07 t_bwgrp-bwgbz       "Basiswerksgrp.bez. gekürzt
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ELSE.
        WRITE: /05 text-030,           "Klartext 'Bestand'
                   text-027,           "Klartext 'Basiswerksgruppe'
               /07 gbe-bwgrp           "Basiswerksgruppe
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ENDIF.
    WHEN wrk_zeile.
      IF sond_kz IS INITIAL.
        WRITE: /10 text-030,           "Klartext 'Bestand'
                   text-028,           "Klartext Werk
                   wbe-werks           "Werk
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ELSE.
        PERFORM  seitenkopf_sonderbestand.
      ENDIF.
    WHEN lag_zeile.
      IF sond_kz IS INITIAL.
        WRITE: /02 text-030,           "Klartext 'Bestand'
                   text-028,           "Klartext 'Werk'
                   lbe-werks           "Werk
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                   text-029,           "Klartext 'Lagerort'
                   lbe-lgort           "Lagerort
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
               /   lbe-lgpbe UNDER text-029    "Lagerplatz
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ELSE.
        PERFORM  seitenkopf_sonderbestand.
      ENDIF.
*????  WHEN CHA_ZEILE.   entfällt!
*        IF sond_kz IS INITIAL.
*           WRITE: /05 TEXT-010,   "Klartext 'Bestand'
*                   15 TEXT-015,   "KLartext Charge
*                      CBE-CHARG   "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
*                  /05 TEXT-013,   "Klartext Werk
*                      CBE-WERKS   "Werk
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
*                      TEXT-014,   "KLartext Lagerort
*                      CBE-LGORT   "Lagerort
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*        ELSE.
*           PERFORM  SEITENKOPF_SONDERBESTAND.
*        ENDIF.
      WHEN CH_ZEILE.
        IF sond_kz IS INITIAL.
           WRITE: /05 TEXT-030,   "Klartext 'Bestand'
                   15 TEXT-015,   "KLartext Charge
                      CBE-CHARG   "Charge
                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                  /05 TEXT-028,   "Klartext Werk
                      CBE-WERKS   "Werk
                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                      TEXT-029,   "KLartext Lagerort
                      CBE-LGORT   "Lagerort
                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
        ELSE.
           PERFORM  SEITENKOPF_SONDERBESTAND.
        ENDIF.
  ENDCASE.

ENDFORM.                               " SEITENKOPF_EINZEL_E

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_EINZEL_L
*&---------------------------------------------------------------------*
*       Seitenkopf bei Einzelliste für Artikelliste
*----------------------------------------------------------------------*
FORM seitenkopf_einzel_l.

  CASE zeilen_kz.
    WHEN ges_zeile.
      WRITE: /5  text-030,             "Klartext 'Bestand'
                 text-034.             "Klartext 'Summe aller Mat.'
    WHEN man_zeile.
*---- Materialbezeichnung lesen ---------------------------------------*
      READ TABLE t_matnr WITH KEY matnr = mbe-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

      WRITE: /3  text-030,             "Klartext 'Bestand'
                 text-007,             "Klartext 'Material'
             /5  mbe-matnr             "Material
                 COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
             /5  t_matnr-maktx         "Materialbezeichnung
                 COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.

  ENDCASE.

ENDFORM.                               " SEITENKOPF_EINZEL_L

*&---------------------------------------------------------------------*
*&      Form  UMRECHNEN
*&---------------------------------------------------------------------*
*       Umrechnen der Mengen in den Bestandsfeldern in eine alternative
*       Mengeneinheit für ein Material
*----------------------------------------------------------------------*
*    -> PI_MATNR  Materialsatz
*----------------------------------------------------------------------*
FORM umrechnen USING pi_matnr STRUCTURE t_matnr.

*---- Einlesen aller Mengenfelder (falls noch nicht geschehen) --------*
  DESCRIBE TABLE t_mefeld LINES izaehl.
  IF izaehl < 1.
*---- Einlesen der Felder der Grundliste ------------------------------*
    LOOP AT grund_anzeige.
*---- Evtl. kommt ein Feld mehrmals in der Bestandsübersicht vor ------*
      READ TABLE t_mefeld WITH KEY fname = grund_anzeige-fname
                          BINARY SEARCH.
      IF sy-subrc NE 0.
        t_mefeld-fname = grund_anzeige-fname.
        INSERT t_mefeld INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

*---- Einlesen der zulässigen Felder für Einzellisten -----------------*
    SELECT * FROM t136e.
      READ TABLE t_mefeld WITH KEY fname = t136e-fname BINARY SEARCH.
      IF sy-subrc NE 0.
        t_mefeld-fname = t136e-fname.
        INSERT t_mefeld INDEX sy-tabix.
      ENDIF.
    ENDSELECT.

*//JH 09.09.96: IntPr 195672
*---- Sicherstellen, daß LBKUM auf jeden Fall umgerechnet wird, auch
*---- wenn das Feld weder in der Grund- noch in der Einzelliste per
*---- Customizing angezeigt wird. Ansonsten erfolgt fehlerhafte Anzeige
*---- des bewerteten Bestandes im EK/VK-Popup, wenn eine alternative ME
*---- gewählt wurde
    READ TABLE t_mefeld WITH KEY fname = 'LBKUM' BINARY SEARCH.
    IF sy-subrc NE 0.
      t_mefeld-fname = 'LBKUM'.
      INSERT t_mefeld INDEX sy-tabix.
    ENDIF.
  ENDIF.

*---- Kennzeichen für Werteüberlauf zurücksetzen ----------------------*
  CLEAR max_stock_value_reached.       "//KPr1142916

*---- Ermitteln der alten Umrechnungsfaktoren -------------------------*
  umrez_alt = pi_matnr-umrez_alt.
  umren_alt = pi_matnr-umren_alt.

*---- Ermitteln von UMREZ_NEU und UMREN_NEU ---------------------------*
  READ TABLE t_meeinh WITH KEY matnr = pi_matnr-matnr
                               meinh = meins_neu     BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MEEINH'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.
  umren_neu = t_meeinh-umren.
  umrez_neu = t_meeinh-umrez.

*---- Ermitteln der neuen Bestandswerte auf Mandantenebene ------------*
  MOVE 'MBE-' TO sav_fname0(4).
  LOOP AT mbe WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY mbe.
  ENDLOOP.

*#jhl 31.01.96 (Anfang)
*#jhl Buchungskreis als Bestandsebene wird durch Ebene der Basiswerks-
*#jhl gruppen ersetzt
*---- Ermitteln der neuen Bestandswerte auf Buchungskreisebene --------*
* MOVE 'BBE-' TO SAV_FNAME0(4).
* LOOP AT BBE WHERE MATNR = pi_matnr-MATNR.
*   PERFORM UMRECHNEN_MENGENFELDER.
*   MODIFY BBE.
* ENDLOOP.
*---- Ermitteln der neuen Bestandswerte auf Basiswerksgruppenebene ----*
  MOVE 'GBE-' TO sav_fname0(4).
  LOOP AT gbe WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY gbe.
  ENDLOOP.
*#jhl 31.01.96 (Ende)

*---- Ermitteln der neuen Bestandswerte auf Werksebene ----------------*
  MOVE 'WBE-' TO sav_fname0(4).
  LOOP AT wbe WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY wbe.
  ENDLOOP.

*---- Ermitteln der neuen Bestandswerte auf Lagerortebene -------------*
  MOVE 'LBE-' TO sav_fname0(4).
  LOOP AT lbe WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY lbe.
  ENDLOOP.

* Ermitteln der neuen Bestandswerte auf Chargenebene ????entfällt
* MOVE 'CBE-' TO SAV_FNAME0(4).
* LOOP AT CBE.
*   PERFORM UMRECHNEN_MENGENFELDER.
*   MODIFY CBE.
* ENDLOOP.

*---- Ermitteln der neuen Lieferantenkonsi-Bestände -------------------*
  MOVE 'KBE-' TO sav_fname0(4).
  LOOP AT kbe WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY kbe.
  ENDLOOP.

*---- Ermitteln der neuen Kundenauftrags-Bestände ---------------------*
  MOVE 'EBS-' TO sav_fname0(4).
  LOOP AT ebs WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY ebs.
  ENDLOOP.

*---- Ermitteln der neuen Lieferanten-MTV-Bestände --------------------*
  MOVE 'MPS-' TO sav_fname0(4).
  LOOP AT mps WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY mps.
  ENDLOOP.

*---- Ermitteln der neuen Lieferantenbeistellungs-Bestände ------------*
  MOVE 'OBS-' TO sav_fname0(4).
  LOOP AT obs WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY obs.
  ENDLOOP.

*????uninteressant für Handel
* Ermitteln der neuen Projektbestände
* MOVE 'PBE-' TO SAV_FNAME0(4).
* LOOP AT PBE WHERE MATNR = pi_matnr-MATNR.
*   PERFORM UMRECHNEN_MENGENFELDER.
*   MODIFY PBE.
* ENDLOOP.

*---- Ermitteln der neuen Kundenleergut-Bestände ----------------------*
  MOVE 'VBS-' TO sav_fname0(4).
  LOOP AT vbs WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY vbs.
  ENDLOOP.

*--- Ermitteln der neuen Kundenkonsi-Bestände -------------------------*
  MOVE 'WBS-' TO sav_fname0(4).
  LOOP AT wbs WHERE matnr = pi_matnr-matnr.
    PERFORM umrechnen_mengenfelder.
    MODIFY wbs.
  ENDLOOP.

*>>> hier evtl. weitere Sonderbestände einfügen

ENDFORM.                               " UMRECHNEN

*&---------------------------------------------------------------------*
*&      Form  UMRECHNEN_MENGENFELDER
*&---------------------------------------------------------------------*
*       Umrechnen der Mengen in den Bestandsfeldern in eine alternative
*       Mengeneinheit pro Organisationsebene für alle Bestandsfelder
*----------------------------------------------------------------------*
FORM umrechnen_mengenfelder.

DATA: l_quan_overflow_check TYPE labst.

  LOOP AT t_mefeld.
    MOVE t_mefeld-fname TO sav_fname0+4.
    ASSIGN (sav_fname0) TO <f0>.
    IF sy-subrc = 0.     "Falls ASSIGN-Zuweisung erfolgreich war.
      CATCH SYSTEM-EXCEPTIONS
             arithmetic_errors = 1
             OTHERS = 99.

        <f0> = <f0> * umren_neu * umrez_alt / ( umrez_neu * umren_alt ).
        l_quan_overflow_check = <f0>.
      ENDCATCH.
      IF NOT sy-subrc IS INITIAL.
*      IF <f0> >= max_stock_value.      "//KPr 1142916
* Die Umrechnung von großen Bestandswerten auf eine, im metrischen Sinne
* kleinere Einheit, kann zu einem Wert führen, der nicht mehr in den
* Feldern <D1>, <D2>, <D3>, die auf einen Datentyp P(7) verweisen,
* dargestellt werden können
* -> Meldung ausgeben und auf ursprüngliche Mengeneinheit zurückgehen
        max_stock_value_reached = x.   "//KPr 1142916
      ENDIF.                           "//KPR 1142916
    ENDIF.
  ENDLOOP.

ENDFORM.                               " UMRECHNEN_MENGENFELDER

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_SONDERBESTAND
*&---------------------------------------------------------------------*
*       Aufbereitung des Seitenkopfes für die Sonderbestandsfenster
*       in der Einzeliste für Einzelartikel
*----------------------------------------------------------------------*
FORM seitenkopf_sonderbestand.

  CASE sond_kz.
    WHEN aufbskunde.
      WRITE: /01  text-050,            "Klartext 'Kundenauftragsbestand'
             /01  text-028,            "Klartext Werk
                  ebs-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                  text-029,            "Klartext Lagerort
                  ebs-lgort            "Lagerort
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*entf.  IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   EBS-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
    WHEN konsilief.
      WRITE: /01  text-030,            "Klartext 'Bestand'
                  text-051,            "Klartext Konsilief
             /01  text-028,            "Klartext Werk
                  kbe-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                  text-029,            "Klartext Lagerort
                  kbe-lgort            "Lagerort
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*entf.  IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   KBE-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
    WHEN mtverpack.
      WRITE: /01  text-030,            "Klartext 'Bestand'
                  text-052,       "Klartext Mehrwegtransportverpackung
             /01  text-028,            "Klartext Werk
                  mps-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
                  text-029,            "Klartext Lagerort
                  mps-lgort            "Lagerort
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*entf.  IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   MPS-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
*   WHEN PRJBESTAND.  ????uninteressant für Handel?
*       WRITE: /01  TEXT-082,       "Klartext 'Projektbestand'
*              /01  TEXT-013,       "Klartext Werk
*                   PBE-WERKS       "Werk
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF,
*                   TEXT-014,       "Klartext Lagerort
*                   PBE-LGORT       "Lagerort
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   PBE-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
    WHEN beistlief.
      WRITE: /01  text-030,            "Klartext 'Bestand'
                  text-058,            "Klartext Lieferantenbeistellung
             /01  text-028,            "Klartext Werk
                  zle-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*entf.  IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   ZLE-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
    WHEN konsikunde.
      WRITE: /01  text-030,            "Klartext 'Bestand'
                  text-045,            "Klartext Kundenkonsignation
             /01  text-028,            "Klartext Werk
                  zle-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*entf.  IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   ZLE-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.
    WHEN lrgutkunde.
      WRITE: /01  text-030,            "Klartext 'Bestand'
                  text-046,            "Klartext Kundenleihgut
             /01  text-028,            "Klartext Werk
                  zle-werks            "Werk
                     COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       IF ZEILEN-KZ = CHA_ZEILE.
*         WRITE:    TEXT-015,       "Klartext Charge
*                   ZLE-CHARG       "Charge
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*       ENDIF.

*>>> hier weitere Bestände ergänzen
  ENDCASE.

ENDFORM.                               " SEITENKOPF_SONDERBESTAND

*&---------------------------------------------------------------------*
*&      Form  VAR_BEWERTUNG
*&---------------------------------------------------------------------*
*       Ermitteln der Bewertungsdaten eines Merkmals zu einer Varianten
*       -> T_MATNR  enthält die Variante
*          T_MERKM  enthält Merkmal der Variante
*       <- T_BEWERT liefert die Merkmalsbewertung der Variante
*----------------------------------------------------------------------*
FORM var_bewertung.

  DATA: x_matnr LIKE t_matnr.  "Damit Inhalt in T_MATNR zur aktuellen
  "Variante nicht überschrieben wird

  DATA: BEGIN OF x_varnr OCCURS 0.     "Potentielle Varianten
          INCLUDE STRUCTURE mara.
  DATA: END   OF x_varnr.

  READ TABLE t_ausp WITH KEY objek = t_matnr-cuobf
                             atinn = t_merkm-atinn.
  IF sy-subrc NE 0.
*---- Entweder ist die Tabelle noch leer oder enthält andere Var.- ----*
*---- bewertungsdaten.
*---- Falls der Einstieg über eine Warengruppe mit Merkmalswerte-  ----*
*---- einschränkung erfolgte und die Anzeigestufe 'Einzelvariante' ----*
*---- vorliegt, müssen die Bewertungsdaten auch nachgelesen werden ----*
*---- weil der Sammelartikel zwischenzeitlich gewechselt werden    ----*
*---- kann.                                                        ----*
*---- Varianten zum Sammelartikel zusammenstellen ---------------------*
    LOOP AT t_matnr INTO x_matnr WHERE satnr = hide_alt-matnr.
      MOVE-CORRESPONDING x_matnr TO x_varnr.
      APPEND x_varnr.
    ENDLOOP.

*---- Bewertungsdaten einmal für alle Varianten lesen und speichern ---*
    PERFORM lese_var_bewertung TABLES x_varnr.

    READ TABLE t_ausp WITH KEY objek = t_matnr-cuobf
                               atinn = t_merkm-atinn.
  ENDIF.

  IF t_ausp-atwrt IS INITIAL.
*---- Bei numerischem Merkmalswert ------------------------------------*
    READ TABLE t_bewert WITH KEY atinn = t_ausp-atinn
                                 atflv = t_ausp-atflv.
  ELSE.
*---- Bei nicht numerischem Merkmalswert ------------------------------*
    READ TABLE t_bewert WITH KEY atinn = t_ausp-atinn
                                 atwrt = t_ausp-atwrt.
  ENDIF.

ENDFORM.                               " VAR_BEWERTUNG

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_EK_VK_LISTE
*&---------------------------------------------------------------------*
*       Aufbereitung des Seitenkopfes für die EK/VK-Bestandsliste
*       Bestandsdaten zu einzelnen Artikeln u. Artikellisten????
*----------------------------------------------------------------------*
FORM seitenkopf_ek_vk_liste.

  CASE drilldown_level.
    WHEN einzart_level.
      PERFORM seitenkopf_ek_vk_e.
    WHEN einzvar_level.
      PERFORM seitenkopf_ek_vk_e.
    WHEN artlist_level.
*???? PERFORM SEITENKOPF_EINZEL_L.
  ENDCASE.

  SKIP 1.
*--- TEXT-030 = 'Bestand' rechtsbündig ausrichten -------------
  sav_text1 = text-030.
  CLASS cl_scp_linebreak_util DEFINITION LOAD.             "note 1019175
  CALL METHOD cl_scp_linebreak_util=>get_visual_stringlength
    EXPORTING
      im_string               = sav_text1
    IMPORTING
      ex_pos_vis              = laenge
    EXCEPTIONS
      invalid_text_enviroment = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    laenge = strlen( sav_text1 ).
  ENDIF.
  izaehl = izaehl17 - laenge.
  IF izaehl GE 1.
    SHIFT sav_text1 BY izaehl PLACES RIGHT.
  ENDIF.

  WRITE  /  strich42.
  FORMAT COLOR COL_HEADING INTENSIFIED INVERSE OFF.
  WRITE: /1 sy-vline,
          2 text-031,
         19 sy-vline,
         20 sav_text1,
         42 sy-vline.
  FORMAT COLOR OFF.
  WRITE  43 space38.
  WRITE  /  strich42.
  FORMAT COLOR OFF.
  WRITE  43 space38.

ENDFORM.                               " SEITENKOPF_EK_VK_LISTE

*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_EK_VK_E
*&---------------------------------------------------------------------*
*       Seitenkopf bei EK/VK-Bestandsliste für Einzelartikel
*----------------------------------------------------------------------*
FORM seitenkopf_ek_vk_e.

  FORMAT COLOR COL_HEADING INVERSE.
  CASE zeilen_kz.
    WHEN man_zeile.
      WRITE: /01  text-068,            "Klartext 'Wertmäßiger Bestand'
                  text-014.            "Klartext 'Gesamt'.
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*      WHEN BUK_ZEILE.
*           WRITE: /05 TEXT-030,   "Klartext 'Bestand'
*                      TEXT-027,   "Klartext 'Buchungskreis'
*                      BBE-BUKRS   "Buchungskreis
*                      COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
*#jhl 31.01.96 (Ende)
    WHEN wgr_zeile.
      IF wbe-bwgrp = dummy_bwgrp.      "mit WBE testen, weil GBE nicht
        "gelesen wird
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
        READ TABLE t_bwgrp WITH KEY bwgrp = wbe-bwgrp BINARY SEARCH.
        IF sy-subrc NE 0.
          MESSAGE a038 WITH 'T_BWGRP'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
        ENDIF.
        WRITE: /01 text-068,           "Klartext 'Wertmäßiger Bestand'
                   text-027,           "Klartext 'Basiswerksgruppe'
               /03 t_bwgrp-bwgbz       "Basiswerksgrp.bez. gekürzt
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ELSE.
        WRITE: /01 text-068,           "Klartext 'Wertmäßiger Bestand'
                   text-027,           "Klartext 'Basiswerksgruppe'
               /03 wbe-bwgrp           "Basiswerksgruppe
                   COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      ENDIF.
    WHEN wrk_zeile.
      WRITE: /01 text-068,             "Klartext 'Wertmäßiger Bestand'
                 text-028,             "Klartext Werk
                 wbe-werks             "Werk
                 COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
  ENDCASE.

ENDFORM.                               " SEITENKOPF_EK_VK_E

*&---------------------------------------------------------------------*
*&      Form  FUELLE_FNAME_RANGE
*&---------------------------------------------------------------------*
*       Zusammenstellen der Felder, die trotz Customizingvorgabe nicht
*       angezeigt werden sollen
*       JH zu 1.2A1 (s.a. intPr 197005)
*----------------------------------------------------------------------*
FORM fuelle_fname_range.

  r_fname-sign   = 'E'.
  r_fname-option = 'EQ'.

  IF p_kzlon IS INITIAL.
    r_fname-low    = 'MENGE'. APPEND r_fname.
    r_fname-low    = 'MENGK'. APPEND r_fname.
    r_fname-low    = 'BSABR'. APPEND r_fname.
    r_fname-low    = 'TRASF'. APPEND r_fname.
    r_fname-low    = 'WESPB'. APPEND r_fname.
    r_fname-low    = 'BDMNS'. APPEND r_fname.
    r_fname-low    = 'BDMNG'. APPEND r_fname.
    r_fname-low    = 'VBMNA'. APPEND r_fname.
    r_fname-low    = 'VBMNB'. APPEND r_fname.
    r_fname-low    = 'VBMNC'. APPEND r_fname.
    r_fname-low    = 'VBMNE'. APPEND r_fname.
    r_fname-low    = 'VBMNG'. APPEND r_fname.
    r_fname-low    = 'VBMNI'. APPEND r_fname.
    r_fname-low    = 'OMENG'. APPEND r_fname.
    r_fname-low    = 'FAMNG'. APPEND r_fname.
  ENDIF.
  IF p_kzlso IS INITIAL.
    r_fname-low    = 'KLABS'. APPEND r_fname.
    r_fname-low    = 'KINSM'. APPEND r_fname.
    r_fname-low    = 'KEINM'. APPEND r_fname.
    r_fname-low    = 'KSPEM'. APPEND r_fname.
    r_fname-low    = 'CALAB'. APPEND r_fname.
    r_fname-low    = 'CAINS'. APPEND r_fname.
    r_fname-low    = 'KALAB'. APPEND r_fname.
    r_fname-low    = 'KAINS'. APPEND r_fname.
    r_fname-low    = 'KASPE'. APPEND r_fname.
    r_fname-low    = 'KAEIN'. APPEND r_fname.
    r_fname-low    = 'KULAV'. APPEND r_fname.
    r_fname-low    = 'KUINV'. APPEND r_fname.
    r_fname-low    = 'KUEIV'. APPEND r_fname.
    r_fname-low    = 'KULAW'. APPEND r_fname.
    r_fname-low    = 'KUINW'. APPEND r_fname.
    r_fname-low    = 'KUEIW'. APPEND r_fname.
    r_fname-low    = 'LBLAB'. APPEND r_fname.
    r_fname-low    = 'LBINS'. APPEND r_fname.
    r_fname-low    = 'LBEIN'. APPEND r_fname.
    r_fname-low    = 'MLABS'. APPEND r_fname.
    r_fname-low    = 'MINSM'. APPEND r_fname.
    r_fname-low    = 'MEINM'. APPEND r_fname.
    r_fname-low    = 'MSPEM'. APPEND r_fname.
    r_fname-low    = 'PRLAB'. APPEND r_fname.
    r_fname-low    = 'PRINS'. APPEND r_fname.
    r_fname-low    = 'PRSPE'. APPEND r_fname.
    r_fname-low    = 'PREIN'. APPEND r_fname.
  ENDIF.

ENDFORM.                               " FUELLE_FNAME_RANGE
*&---------------------------------------------------------------------*
*&      Form  SEITENKOPF_STRART_LISTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM seitenkopf_strart_liste.
  DATA:  head_text(15) TYPE c.
  READ TABLE grund_anzeige  WITH KEY fname = 'LABST'.
  head_text = grund_anzeige-text.
*additions for ALV Tree TGA 19991130
  IF NOT p_kzvst0 IS INITIAL.
    READ TABLE t_t157b INTO s_t157b WITH KEY feldv = 'LABST'.
    IF sy-subrc = 0.
      head_text = s_t157b-ftext.
    ENDIF.
  ENDIF.
*additions for ALV Tree TGA 19991130
  FORMAT COLOR COL_HEADING INVERSE.
  CASE zeilen_kz.
    WHEN wrk_zeile.
      WRITE: /01 text-030,             "Klartext 'Bestand'
               '(', head_text, ')',
                  text-078,  "Klartext 'incl. strukt. Materialien'
             /01  text-028,' ', zle-werks
             COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
    WHEN lag_zeile.
      WRITE: /01 text-030,             "Klartext 'Verfügbarer Bestand'
               '(', head_text, ')',
                 text-078,    "Klartext 'incl. strukt. Materialien'
             /01 text-028, '      ', zle-werks
             COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
      FORMAT COLOR COL_HEADING INVERSE.
      WRITE:    /02 text-029, ' ', zle-lgort
                COLOR COL_BACKGROUND INTENSIFIED OFF INVERSE OFF.
  ENDCASE.

ENDFORM.                               " SEITENKOPF_STRART_LISTE
