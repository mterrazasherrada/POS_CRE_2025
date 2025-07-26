*-------------------------------------------------------------------
***INCLUDE RWBE1F06 .
*  Behandlung der Funktionscodes
*  (analog RMMMBEFF)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  FCODE_HANDLING
*&---------------------------------------------------------------------*
*       Behandlung des Ereignisses AT-USER-COMMAND                     *
*----------------------------------------------------------------------*
FORM fcode_handling.

  CASE sy-ucomm.
    WHEN back_g.
      PERFORM rwbe_zurueck.
    WHEN abbr_g.
      PERFORM rwbe_zurueck.
    WHEN beenden.
      PERFORM rwbe_beenden.
    WHEN back_gv.
      PERFORM grundv_zurueck.
    WHEN abbr_gv.
      PERFORM grundv_zurueck.
    WHEN grund.
*#jhl 12.04.96 vorliegende Fensternr. soll erhalten bleiben
*     RMMMB-FENNR = START_FENNR.
      PERFORM e00_grund_liste.
    WHEN matx.
      PERFORM varianten_matrix.
    WHEN bama.
      PERFORM zurueck_var_matrix.
    WHEN vaar.
      PERFORM varianten_aufriss.
    WHEN anbe.
      PERFORM bezeichnung_anzeigen.
    WHEN annr.
      PERFORM nummer_anzeigen.
    WHEN anbn.
      PERFORM bezeich_num_anzeigen.
    WHEN neue_selektion.
      PERFORM neue_selektion.
* JH/27.10.98/4.6A (Anfang)
    WHEN refresh.
      PERFORM refresh.
* JH/27.10.98/4.6A (Ende)
    WHEN zul_me.                 "Popup mit zulässigen Mengeneinheiten
      PERFORM zul_mengeneinheiten.
    WHEN zlma.
      PERFORM zul_materialien.
    WHEN zlva.
      PERFORM zul_varianten.
    WHEN ekvk.
      PERFORM ek_vk_anzeigen.
    WHEN ason.
*---- Momentan nur Lieferantenkonsi-Preissegment anzeigen! ------------*
      PERFORM sonderbestands_transaktion.
    WHEN md04.
      PERFORM bedarfsliste.
    WHEN me2m.
      PERFORM bestellungen.
    WHEN mb24.
      PERFORM reservierungen.
    WHEN mb51.
      PERFORM materialbewegungen.
    WHEN ls26.
      PERFORM lvs_quants.
    WHEN mm43.
      PERFORM material_stammdaten.
    WHEN mmbe.
      PERFORM alte_bestandsuebersicht.
*TGA/4.6 Erweiterungen Lot (START)
    WHEN stru.
      PERFORM info_struct_art.
    WHEN equi.                                          "v note 2274587
      PERFORM equi_anzeigen.
    WHEN 'HULI'.
      PERFORM handling_unit.
    WHEN co21.
      PERFORM fertauftraege.                            "^ note 2274587
*TGA/4.6 Erweiterungen Lot (END)
*???WHEN MSC3.
*???? PERFORM CHARGEN_TRANSAKTION.
*???WHEN CO21.
*???? PERFORM FERTAUFTRAEGE.
*???WHEN CHCL.
*???? PERFORM CLASSIFICATION_CHARGEN.
*???WHEN EQUI.
*???? PERFORM EQUI_ANZEIGEN.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.                               " FCODE_HANDLING

*&---------------------------------------------------------------------*
*&      Form  RWBE_ZURUECK
*&---------------------------------------------------------------------*
*       Rückkehr von der Bestandsübersicht                             *
*----------------------------------------------------------------------*
FORM rwbe_zurueck.

* tga note 356164 / start
  IF kz_prozessiert = 'X'.
    LEAVE LIST-PROCESSING.
  ELSE.
* tga note 356164 / end
    IF start_dd_level = drilldown_level.
*---- Einstiegspunkt des Drilldown-Abstieges wieder erreicht -> Prg. --*
*---- wird verlassen                                                 --*
*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
* Version 1
* Bei Rücksprung auf Selektionsbild sind die vorherigen Eingaben weg,
* die nicht über SPA/GPA-Parameter gezogen werden
* -> Ursache: LEAVE TO TRANSACTION anstatt LEAVE SCREEN verwendet
*   IF ( SY-CALLD EQ SPACE )
*   OR ( NOT P_SUBMIT IS INITIAL ).
*---- Falls der Report nicht über CALL-TRANSACTION/SUBMIT aufgerufen --*
*---- wurde oder falls der Report sich bei einem Fehler selbst noch- --*
*---- mal aufgerufen hat, soll auf den Selektionsbildschirm zurück-  --*
*---- gesprungen werden, es sei denn man kommt aus der SE80          --*
*     IF SY-TCODE NE 'SE80'.
*       LEAVE TO TRANSACTION SY-TCODE.
*     ELSE.
*       LEAVE.
*     ENDIF.
*   ELSE.
*---- Ansonsten erfolgt Rücksprung zur aufrufenden Transaktion --------*
*     LEAVE.
*   ENDIF.
* Version 2 (auch nicht hundertprozentig)
*#  IF ( SY-CALLD EQ SPACE )
*#  OR ( NOT P_MCALL IS INITIAL ).
*#--- Aufruf aus Menü heraus
*#????Falls der Report ein zweites Mal aus dem Selektionsbild heraus
*#????gestartet wird, ist SY-CALLD plötzlich gesetzt! Basisfehler?
*#    IF P_RECALL = 'N'.
*#--- Programm wurde zuletzt über die Funktion 'Neue Selektion' gestart.
*#--- -> Selektionsdynpro wurde nicht durchlaufen -> LEAVE SCREEN würde
*#--- ins Bereichsmenü zurückführen
*#      LEAVE TO TRANSACTION SY-TCODE.   "Alte Eingaben sind weg,
*#                                       "insofern nicht im SPA/GPA-
*#                                       "Memory hinterlegt
*#    ELSE.
*#--- Programm wurde mit Durchlaufen des Selektionsbildes gestartet
*#--- -> Rücksprung in Selektionsbild, wobei die vorherigen Eingaben
*#---    bis auf etwaige Merkmalswerteeinschränkungen erhalten bleiben
*#      LEAVE SCREEN.
*#    ENDIF.
*#  ELSE.
*#--- Aufruf per CALL TRANSACTION oder SUBMIT (auch aus SE38 und SE80
*#--- heraus)
*#    IF ( SY-TCODE = 'SE38' )
*#    OR ( SY-TCODE = 'SE80' ).
*#--- Rücksprung ins Selektionsbild, wobei die vorherigen Eingaben
*#--- erhalten bleiben, es sei denn, es wurde die Fnk. 'Neue Selektion'
*#--- vorher aufgerufen, dann erfolgt ein Rücksprung zur SE38/SE80,
*#--- weil das Selektionsdynpro nicht durchlaufen wurde
*#      LEAVE SCREEN.
*#    ELSE.
*#      LEAVE.           "Rücksprung zur aufrufenden TA/Programm
*#    ENDIF.
*#  ENDIF.
* Version 3 (hoffentlich unproblematisch????)
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
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090
    ELSE.
*---- Wechsel von der Grundliste zum Einzelartikel zurück auf die -----*
*---- Grundliste zu der Artikelliste                              -----*
*#jhl 08.08.96 (Anfang) Popupbestätigung wird als störend empfunden
*   CALL FUNCTION 'POPUP_CONTINUE_YES_NO'
*        EXPORTING
*             DEFAULTOPTION = 'Y'
*             TITEL         = TEXT-037
*             TEXTLINE1     = TEXT-038
*             TEXTLINE2     = TEXT-039
*        IMPORTING
*             ANSWER        = POPUP_ANSWER.
*
*   IF POPUP_ANSWER = 'J'.
      drilldown_level = artlist_level.
*#jhl 12.04.96 vorliegende Fensternr. soll erhalten bleiben
*     RMMMB-FENNR = START_FENNR.
      PERFORM e00_grund_liste.
*   ENDIF.
*#jhl 08.08.96 (Ende)
    ENDIF.
  ENDIF.                                 " tga note 356164

ENDFORM.                               " RWBE_ZURUECK

*&---------------------------------------------------------------------*
*&      Form  RWBE_BEENDEN
*&---------------------------------------------------------------------*
*       Beenden der Bestandsübersicht in folgenden Fällen:             *
*       -  Aufruf als Transaktion aus beliebigem Menü                  *
*          ---> Rücksprung zum Menü mit LEAVE TO TRANSACTION '    '    *
*       - Aufruf aus anderer Transaktion per CALL TRANSACTION oder     *
*         SUBMIT
*         ---> Rücksprung dorthin mit LEAVE
*       - Aufruf aus ABAP-Einstiegsbild                                *
*          ---> Rücksprung dorthin mit SET SCREEN 0, LEAVE SCREEN      *
*----------------------------------------------------------------------*
FORM rwbe_beenden.

  IF sy-calld EQ space.
    IF sy-tcode NE 'SE38'.
      LEAVE TO TRANSACTION '    '.
    ELSE.
      SET SCREEN 0.
      LEAVE SCREEN.
    ENDIF.
  ELSE.
    LEAVE.
  ENDIF.

ENDFORM.                               " RWBE_BEENDEN

*&---------------------------------------------------------------------*
*&      Form  GRUNDV_ZURUECK
*&---------------------------------------------------------------------*
*       Rückkehr von der Grundliste der Einzelvariante auf die Grund-
*       liste zum Sammelartikel
*----------------------------------------------------------------------*
FORM grundv_zurueck.

*---- HIDE_ALT-MATNR zeigt auf den Sammelartikel -> T_MATNR für den   -*
*---- Sammelartikel neu lesen                                         -*
  READ TABLE t_matnr WITH KEY matnr = hide_alt-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  CLEAR sel_variante.
  drilldown_level = einzart_level.
  rmmmb-fennr = fennr_alt.
  PERFORM e00_grund_liste.

ENDFORM.                               " GRUNDV_ZURUECK

*&---------------------------------------------------------------------*
*&      Form  ZURUECK_VAR_MATRIX
*&---------------------------------------------------------------------*
*       Rückkehr von der Grundliste der Einzelvariante zur Varianten-
*       matrix
*----------------------------------------------------------------------*
FORM zurueck_var_matrix.

*#jhl 08.08.96 (Anfang) Popupbestätigung wird als störend empfunden
* CALL FUNCTION 'POPUP_CONTINUE_YES_NO'
*      EXPORTING
*           DEFAULTOPTION = 'Y'
*           TITEL         = TEXT-037
*           TEXTLINE1     = TEXT-040
*           TEXTLINE2     = TEXT-041
*      IMPORTING
*           ANSWER        = POPUP_ANSWER.
*
* IF POPUP_ANSWER = 'J'.
  CLEAR sel_variante.

*---- Alte Daten zur Cursorposition in der Bestandsliste des Sammel- --*
*---- artikels zurückholen, um in die Variantenmatrix einsteigen zu  --*
*---- können                                                         --*
  MOVE-CORRESPONDING hide_alt TO zle.
  MOVE hide_alt-zeilen_kz TO zeilen_kz.
  MOVE hide_alt-bezei_kz  TO bezei_kz.
  MOVE hide_alt-sond_kz   TO sond_kz.
  MOVE hide_alt-kz_kein_o TO kz_kein_o."????notwendig und sinnvoll?
  MOVE hide_alt-kz_kein_w TO kz_kein_w."????
  MOVE hide_alt-kz_kein_v TO kz_kein_v."????
  rmmmb-fennr = fennr_alt.

  PERFORM matrix_anzeigen.
* ENDIF.
*#jhl 08.08.96 (Ende)

ENDFORM.                               " ZURUECK_VAR_MATRIX

*&---------------------------------------------------------------------*
*&      Form  NEUE_SELEKTION
*&---------------------------------------------------------------------*
*       Neue Selektion abhängig von Drilldown-Level durchführen:
*       Fall 1: Darstellung der Bestandsliste zum Einzelartikel
*       -> neue Selektion führt zu komplett neuem Programmstart,
*          wobei der Selektionsbildschirm übersprungen wird
*       Fall 2: Darstellung der Bestandsliste zur Einzelvariante
*       -> neue Selektion kann sich nur auf eine andere Variante
*          zum gegebenen Sammelartikel beziehen
*----------------------------------------------------------------------*
FORM neue_selektion.

*---- Prüfen, ob gültige Zeile ausgewählt wurde -----------------------*
  IF kz_nsel IS INITIAL.
    MESSAGE i031.
*    Cursor bitte im Listenkopf positionieren
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
    EXIT.
  ENDIF.

*---- Einlesen der Zeile, in der sich die Materialnummer befindet -----*
  izaehl = sy-lilli + 1 - kz_nsel.
  READ LINE izaehl FIELD VALUE t_matnr-matnr INTO matnr_lisel.
  TRANSLATE matnr_lisel TO UPPER CASE.     "#EC TRANSLANG  JH/4.6A/TODO

*---- Einlesen der neuen Mengeneinheit --------------------------------*
* Anmerkung: SY-LILLI wird durch vorausgegangenes Read umgesetzt
  izaehl = sy-lilli + 1.               "ZeilenNr mit ME ermitteln
  READ LINE izaehl FIELD VALUE t_matnr-meins INTO meins_neu.
  TRANSLATE meins_neu TO UPPER CASE.       "#EC TRANSLANG  JH/4.6A/TODO
*---- Existenzprüfung zur neuen Mengeneinheit und Sprachumwandlung,  --*
*---- denn wenn die Pflegesprache bei den Materialstammdaten von der --*
*---- Anmeldesprache abweicht, wird die Mengeneinheit intern in der  --*
*---- Pflegesprache geführt und erst bei der Anzeige sprachabhängig  --*
*---- umgesetzt (teilweise automatisch)                              --*
  IF meins_neu NE t_matnr-meins.
    SELECT * FROM t006a
           WHERE spras = sy-langu
           AND   mseh3 = meins_neu.
    ENDSELECT.
    IF sy-subrc = 0.
      meins_neu = t006a-msehi.
    ELSE.
      MESSAGE i080 WITH sy-langu.
*    Eingegebene Mengeneinheit ist für Sprache & nicht vorhanden
      CLEAR kz_nsel.
      EXIT.
    ENDIF.
  ENDIF.

*//JH 25.09.96 (Anfang) IntPr 207685
* Bei Unterdrückung von führenden Nullen bei Materialien mit interner
* Nummernvergabe (-> TA OMSL), erfolgt die Konvertierung zu spät,
* so daß eigentl. identische Materialien nicht richtig erkannt werden
* IF MATNR_LISEL NE T_MATNR-MATNR.     "Falls neue Materialnummer
*---- Konvertieren der neuen Materialnummer ---------------------------*
*   CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*        EXPORTING
*             INPUT  = MATNR_LISEL
*        IMPORTING
*             OUTPUT = MATNR_NEU.
*---- Konvertieren der neuen Materialnummer ---------------------------*
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = matnr_lisel
    IMPORTING
      output = matnr_neu.

  IF matnr_neu NE t_matnr-matnr.       "Falls neue Materialnummer
*//JH 25.09.96 (Ende) IntPr 207685
    CASE drilldown_level.
      WHEN einzart_level.
        PERFORM neustart_neue_selekt.
      WHEN einzvar_level.
*---- Test, ob die eingegebene Variante in der zum Sammelartikel ------*
*---- ermittelten Variantenliste vorhanden ist                   ------*
*---- Sammelartikel steht in HIDE_ALT ---------------------------------*
        READ TABLE t_matnr WITH KEY matnr = matnr_neu
                           BINARY SEARCH
                           TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          MESSAGE i032 WITH hide_alt-matnr matnr_neu.
*    Zum Sammelartikel & liegt keine Variante & vor!
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
          CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
          CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
          EXIT.
        ENDIF.

        PERFORM anzeige_neue_var.
    ENDCASE.
  ELSE.    "Evtl. wurde nur eine andere Mengeneinheit angegeben
    IF meins_neu NE t_matnr-meins.
*---- Prüfen, ob MEINS_NEU für das aktuelle Material zulässig ist -----*
      READ TABLE t_meeinh WITH KEY matnr = t_matnr-matnr
                                   meinh = meins_neu     BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE i055.
*   Die eingegebene Mengeneinheit ist für das Material nicht zulässig
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
        CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
        CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
        EXIT.
      ENDIF.

*---- Umrechnen der Mengenfelder --------------------------------------*
      PERFORM umrechnen USING t_matnr.
      IF NOT max_stock_value_reached IS INITIAL.           "//KPr1142916
*---- Umrechnung hat zu einem Überlauf geführt -> Meldung ausgeben ----*
*---- und Bestandswerte wieder auf ursprüngliche ME zurückrechnen  ----*
        MESSAGE i109(mm).              "//KPr1142916
*    Umrechnung in d. ausgewählte Mengeneinheit würde zu einem Überlauf
        meins_alt = t_matnr-meins.     "//KPr1142916
        t_matnr-meins = meins_neu.     "//KPr1142916
        meins_neu = meins_alt.         "//KPr1142916
        t_matnr-umrez_alt = umrez_neu. "//KPr1142916
        t_matnr-umren_alt = umren_neu. "//KPr1142916
        PERFORM umrechnen USING t_matnr.                   "//KPr1142916
      ENDIF.                           "//KPr1142916
*---- Neue Anzeigemengeneinheit und alten Umrechnungsfaktor ablegen ---*
      READ TABLE t_matnr WITH KEY matnr = t_matnr-matnr
                         BINARY SEARCH."Index für Eintrag lesen
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.
      t_matnr-meins     = meins_neu.
      t_matnr-umrez_alt = umrez_neu.
      t_matnr-umren_alt = umren_neu.
      MODIFY t_matnr INDEX sy-tabix.

      PERFORM e00_grund_liste.         "Neu-Aufbau der Grundliste
    ELSE.
*---- Es wurde weder ein neues Material noch eine neue ME eingegeben --*
      MESSAGE s076.
*    Keine Neueingabe für Material oder Mengeneinheit erfolgt
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
      CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
      CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
    ENDIF.
  ENDIF.

ENDFORM.                               " NEUE_SELEKTION

*&---------------------------------------------------------------------*
*&      Form  ZUL_ME_ANZEIGEN
*&---------------------------------------------------------------------*
*       Prozessieren des Popups mit den zulässigen Mengeneinheiten
*----------------------------------------------------------------------*
FORM zul_me_anzeigen.

*---- Anzuzeigende Felder zusammenstellen -----------------------------*
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

*---- Anzuzeigende Werte zusammenstellen ------------------------------*
  CLEAR   t_values.
  REFRESH t_values.
  LOOP AT t_meeinh WHERE matnr = t_matnr-matnr.
    READ TABLE t_metext WITH KEY meinh = t_meeinh-meinh
                        BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_METEXT'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
    t_values-value = t_metext-meinh.
    APPEND t_values.
    t_values-value = t_metext-msehl.
    APPEND t_values.
  ENDLOOP.

*---- Dynpro für die Selektion einer neuen Mengeneinheit prozessieren -*
  CLEAR meins_neu.
  CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
    EXPORTING
      fieldname                 = 'T006A'
      tabname                   = 'MSEHI'
      titel                     = text-061
*     TITLE_IN_VALUES_LIST      = ' '
    IMPORTING
      select_value              = meins_neu
    TABLES
      fields                    = t_fields
      valuetab                  = t_values
    EXCEPTIONS
      field_not_in_ddic         = 1
      more_then_one_selectfield = 2
      no_selectfield            = 3
      OTHERS                    = 4.

  IF sy-subrc NE 0.
    MESSAGE a056.
*    Bei der Anzeige der zulässigen Mengeneinheiten ist ein Fehler aufge
  ENDIF.

ENDFORM.                               " ZUL_ME_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  SONDERBESTANDS_TRANSAKTION
*&---------------------------------------------------------------------*
*       Ansprung von Transaktionen zum Anzeigen weitergehender Sonder-
*       bestandsinformation
*----------------------------------------------------------------------*
FORM sonderbestands_transaktion.

* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
  DATA BEGIN OF bdcdata OCCURS 10.
          INCLUDE STRUCTURE bdcdata.
  DATA END OF bdcdata.
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)

  CASE sond_kz.
    WHEN konsilief.
      READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

*---- Aufruf der Transaktion nicht für Sammelartikel möglich ----------*
      IF t_matnr-attyp = attyp_sam.
        MESSAGE i052.
*   Lieferantenkonsi-Preissegment f. konfig. Material nicht anzeigbar
      ELSE.
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
*       Über TCURM-KONSI test, ob Konsipreispflege über MSK1 oder ME11
*       erfolgt (über direktes SELECT, da Tab. gepuffert)
        SELECT SINGLE * FROM tcurm.
        IF NOT tcurm-konsi IS INITIAL.
*         Neu Pflege über Einkaufsinfosätze (ME11)
*         -> EkOrg zum Lieferanten ermitteln, da Mußfeld im Einstiegs-
*            bild
          CLEAR lfm1.
          SELECT * FROM lfm1 WHERE lifnr = zle-lifnr.
          ENDSELECT.
          IF sy-dbcnt > 1.
*           Keine eindeutige EkOrg vorhanden -> Anwender muß diese
*           händisch im Einstiegsbild eingeben
            CLEAR lfm1-ekorg.
          ENDIF.
          PERFORM rette_spa_gpa.
          SET PARAMETER ID 'MAT' FIELD zle-matnr.
          SET PARAMETER ID 'WRK' FIELD zle-werks.
          SET PARAMETER ID 'LIF' FIELD zle-lifnr.
          SET PARAMETER ID 'EKO' FIELD lfm1-ekorg.
*         Das Kennzeichen 'Infotyp' (RM06I-KONSI) kann nicht per
*         SPA/GPA gesetzt werden -> über USING-Parameter versorgen
          bdcdata-program  = 'SAPMM06I'.
          bdcdata-dynpro   = '0100'.
          bdcdata-dynbegin = 'X'.
          APPEND bdcdata.
          CLEAR bdcdata.
          bdcdata-fnam     = 'RM06I-KONSI'.
          bdcdata-fval     = 'X'.
          APPEND bdcdata.
          CLEAR bdcdata.
          bdcdata-fnam     = 'RM06I-LOHNB'.
          bdcdata-fval     = ' '.
          APPEND bdcdata.
          CLEAR bdcdata.
          bdcdata-fnam     = 'RM06I-PIPEL'.
          bdcdata-fval     = ' '.
          APPEND bdcdata.
          CLEAR bdcdata.
          bdcdata-fnam     = 'RM06I-NORMB'.
          bdcdata-fval     = ' '.
          APPEND bdcdata.
          TRY.
            CALL TRANSACTION 'ME13'
              WITH AUTHORITY-CHECK                        "note 2418143
              USING bdcdata MODE 'A'.
          CATCH CX_SY_AUTHORIZATION_ERROR.              "v note 2418143
            MESSAGE E853(MG) WITH 'ME13'.
          ENDTRY.                                       "^ note 2418143
          PERFORM zuruecksetzen_spa_gpa.
        ELSE.
*         Alte Pflege über eigene Konsipreissegmente (MSK1)
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)
          PERFORM rette_spa_gpa.
          SET PARAMETER ID 'MAT' FIELD zle-matnr.
          SET PARAMETER ID 'WRK' FIELD zle-werks.
          SET PARAMETER ID 'LAG' FIELD zle-lgort.
*         SET PARAMETER ID 'CHA' FIELD ZLE-CHARG.   entfällt!
          SET PARAMETER ID 'LIF' FIELD zle-lifnr.
          TRY.
            CALL TRANSACTION 'MSK3'
              WITH AUTHORITY-CHECK                        "note 2241814
              AND SKIP FIRST SCREEN.
          CATCH CX_SY_AUTHORIZATION_ERROR.              "v note 2241814
            MESSAGE E853(MG) WITH 'MSK3'.
          ENDTRY.                                       "^ note 2241814
          PERFORM zuruecksetzen_spa_gpa.
        ENDIF.  "JH/4.0A/30.10.97 Int. Meld. 3484704
      ENDIF.
*>>> hier weitere Bestände ergänzen (-> weitere WHEN-Fälle)
  ENDCASE.

ENDFORM.                               " SONDERBESTANDS_TRANSAKTION

*&---------------------------------------------------------------------*
*&      Form  MATERIAL_STAMMDATEN
*&---------------------------------------------------------------------*
*       Anzeigen der Materialstammdaten
*----------------------------------------------------------------------*
FORM material_stammdaten.

  CASE zeilen_kz.
    WHEN man_zeile.
      PERFORM setze_spa_gpa.
      SET PARAMETER ID 'MXX' FIELD mm43_sicht_init.
      SET PARAMETER ID 'MAT' FIELD zle-matnr.
      SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
      SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      TRY.
        CALL TRANSACTION 'MM43'
          WITH AUTHORITY-CHECK                            "note 2418143
          AND SKIP FIRST SCREEN.
      CATCH CX_SY_AUTHORIZATION_ERROR.                  "v note 2418143
        MESSAGE E853(MG) WITH 'MM43'.
      ENDTRY.                                           "^ note 2418143
      PERFORM zuruecksetzen_spa_gpa.
*#jhl 31.01.96 (Anfang)
*#jhl Buchungskreis als Bestandsebene wird durch Ebene der Basiswerks-
*#jhl gruppen ersetzt
*   WHEN BUK_ZEILE.????überarbeiten falls notwendig
*       SET PARAMETER ID 'MAT' FIELD ZLE-MATNR.
*       SET PARAMETER ID 'BUK' FIELD ZLE-BUKRS.
*       CLEAR HWERKS.
*       CLEAR HLGORT.
*       SET PARAMETER ID 'WRK' FIELD HWERKS.
*       SET PARAMETER ID 'LAG' FIELD HLGORT.
*       SET PARAMETER ID 'MXX' FIELD MM03_START_SICHT.
*       CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
*#jhl 31.01.96 (Ende)
    WHEN wgr_zeile.
      PERFORM setze_spa_gpa.
      SET PARAMETER ID 'MXX' FIELD mm43_sicht_init.
      SET PARAMETER ID 'MAT' FIELD zle-matnr.
      SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
      SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      TRY.
        CALL TRANSACTION 'MM43'
          WITH AUTHORITY-CHECK                            "note 2418143
          AND SKIP FIRST SCREEN.
      CATCH CX_SY_AUTHORIZATION_ERROR.                  "v note 2418143
        MESSAGE E853(MG) WITH 'MM43'.
      ENDTRY.                                           "^ note 2418143
      PERFORM zuruecksetzen_spa_gpa.
    WHEN wrk_zeile.
      PERFORM setze_spa_gpa.
      READ TABLE t_werks WITH KEY werks = zle-werks BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_WERKS'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

*---- Liegt ein VZ oder eine Filiale vor? -----------------------------*
      IF t_werks-vlfkz = vlfkz_filiale.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_fil.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD zle-werks.    "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      ELSEIF t_werks-vlfkz = vlfkz_vz_zl.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_vz.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD zle-werks.    "Werk als VZ
      ELSE.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_init.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      ENDIF.
      TRY.
        CALL TRANSACTION 'MM43'
          WITH AUTHORITY-CHECK                            "note 2418143
          AND SKIP FIRST SCREEN.
      CATCH CX_SY_AUTHORIZATION_ERROR.                  "v note 2418143
        MESSAGE E853(MG) WITH 'MM43'.
      ENDTRY.                                           "^ note 2418143
      PERFORM zuruecksetzen_spa_gpa.
    WHEN lag_zeile.
      PERFORM setze_spa_gpa.
      READ TABLE t_werks WITH KEY werks = zle-werks BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_WERKS'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

*---- Liegt ein VZ oder eine Filiale vor? -----------------------------*
      IF t_werks-vlfkz = vlfkz_filiale.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_fil.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD zle-werks.    "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      ELSEIF t_werks-vlfkz = vlfkz_vz_zl.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_vz.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD zle-werks.    "Werk als VZ
      ELSE.
        SET PARAMETER ID 'MXX' FIELD mm43_sicht_init.
        SET PARAMETER ID 'MAT' FIELD zle-matnr.
        SET PARAMETER ID 'WRK' FIELD rmmw1-fiwrk.  "Werk als Filiale
        SET PARAMETER ID 'VZW' FIELD rmmw1-vzwrk.  "Werk als VZ
      ENDIF.
      TRY.
        CALL TRANSACTION 'MM43'
          WITH AUTHORITY-CHECK                            "note 2418143
          AND SKIP FIRST SCREEN.
      CATCH CX_SY_AUTHORIZATION_ERROR.                  "v note 2418143
        MESSAGE E853(MG) WITH 'MM43'.
      ENDTRY.                                           "^ note 2418143
      PERFORM zuruecksetzen_spa_gpa.
*   WHEN CHA_ZEILE.        entfällt????
*       SET PARAMETER ID 'MAT' FIELD ZLE-MATNR.
*       SET PARAMETER ID 'BUK' FIELD ZLE-BUKRS.
*       SET PARAMETER ID 'WRK' FIELD ZLE-WERKS.
*       SET PARAMETER ID 'LAG' FIELD ZLE-LGORT.
*       SET PARAMETER ID 'MXX' FIELD MM03_START_SICHT.
*       CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
      MESSAGE i028.
*    Cursor bitte innerhalb einer Bestandszeile positionieren
  ENDCASE.

ENDFORM.                               " MATERIAL_STAMMDATEN
*&---------------------------------------------------------------------*
*&      Form  ZUL_MATERIALIEN
*&---------------------------------------------------------------------*
*       Popupfenster mit den vorhandenen Materialien anzeigen (inkl.
*       Matchcodeunterstützung)
*----------------------------------------------------------------------*
FORM zul_materialien.

  PERFORM zul_mat_anzeigen.

  IF NOT matnr_neu IS INITIAL.
*---- Es wurde ein Material ausgewählt -> Programmneustart, wobei die -*
*---- vorliegende Anzeigemengeneinheit erhalten bleibt                -*
    meins_neu = t_matnr-meins.
    PERFORM neustart_neue_selekt.
  ENDIF.

ENDFORM.                               " ZUL_MATERIALIEN

*&---------------------------------------------------------------------*
*&      Form  NEUSTART_NEUE_SELEKT
*&---------------------------------------------------------------------*
*       Programmneustart, weil ein neues Material für die Anzeige ge-
*       wählt wurde
*----------------------------------------------------------------------*
FORM neustart_neue_selekt.

*---- Aufruf der Bestandsanzeige mit neuer Materialnummer und unver- --*
*---- änderten sonstigen Selektionskriterien, wobei eine unter Um-   --*
*---- ständen belegte Warengruppeneingabe gelöscht werden muß        --*
  CLEAR   p_matkl.
  CLEAR   s_matnr.
  REFRESH s_matnr.
  s_matnr-sign(1)   = 'I'.
  s_matnr-option(2) = 'EQ'.
  s_matnr-low       = matnr_neu.
  APPEND s_matnr.
  SET PARAMETER ID vnr FIELD p_vernu.

*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
*---- Falls der Programmaufruf aus einem Bereichsmenü heraus erfolgte,
*---- Kennz. setzen, weil SY-CALLD nach Programmneustart nicht mehr
*---- initial ist
  IF sy-calld IS INITIAL AND p_mcall IS INITIAL.
    p_mcall = x.
  ENDIF.
  p_recall = 'N'.                      "wg. Neue Selektion
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090

  SUBMIT rwbest01
     WITH p_wkgrp =  p_wkgrp
     WITH p_vkorg =  p_vkorg
     WITH p_vtweg =  p_vtweg
     WITH s_werks IN s_werks
     WITH p_matkl =  p_matkl
     WITH s_matnr IN s_matnr
     WITH p_plgtp =  p_plgtp
     WITH p_lifnr =  p_lifnr
     WITH p_ltsnr =  p_ltsnr
     WITH p_saiso =  p_saiso
     WITH p_saisj =  p_saisj
     WITH p_kzlso =  p_kzlso
     WITH p_kzlon =  p_kzlon
     WITH p_kzngc =  p_kzngc           " TGA/10.06.99 KZNGC
     WITH s_sobkz IN s_sobkz
     WITH p_vernu =  p_vernu
     WITH p_kznul =  p_kznul
     WITH p_kzbwg =  p_kzbwg
     WITH p_kzwer =  p_kzwer
     WITH p_kzlgo =  p_kzlgo
     WITH p_kzson =  p_kzson
     WITH p_meinh =  meins_neu
     WITH p_field =  p_field
*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
*    WITH P_SUBMIT = X.
     WITH p_recall = p_recall
*RST Test class inventory_lookup-B
*     WITH p_mcall  = p_mcall.
**//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090
     WITH p_mcall  = p_mcall
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090
     WITH p_iltest = g_iltest.
*RST Test class inventory_lookup-E

ENDFORM.                               " NEUSTART_NEUE_SELEKT

*&---------------------------------------------------------------------*
*&      Form  ZUL_VARIANTEN
*&---------------------------------------------------------------------*
*       Popupfenster mit den zulässigen Varianten anzeigen und Auswahl
*       einer neuen Variante unterstützen
*----------------------------------------------------------------------*
FORM zul_varianten.

  PERFORM zul_var_anzeigen.

*---- Es wurde eine Variante eingegeben -> Liste neu darstellen, ------*
*---- wobei die vorliegende Anzeigemengeneinheit erhalten bleibt ------*
  IF NOT matnr_neu IS INITIAL.
    meins_neu = t_matnr-meins.
    PERFORM anzeige_neue_var.
  ENDIF.

ENDFORM.                               " ZUL_VARIANTEN

*&---------------------------------------------------------------------*
*&      Form  ANZEIGE_NEUE_VAR
*&---------------------------------------------------------------------*
*       Anzeige der Grundliste für eine neu gewählte Variante
*----------------------------------------------------------------------*
FORM anzeige_neue_var.

  DATA  tabix_alt LIKE sy-tabix.       "Index retten für MODIFY

*---- Prüfen, ob MEINS_NEU für das aktuelle Material zulässig ist -----*
  READ TABLE t_meeinh WITH KEY matnr = matnr_neu
                               meinh = meins_neu BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE i055.
*   Die eingegebene Mengeneinheit ist für das Material nicht zulässig
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
    EXIT.
  ENDIF.

*---- Materialdaten zum neuen Material lesen --------------------------*
  READ TABLE t_matnr WITH KEY matnr = matnr_neu BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.
  tabix_alt = sy-tabix.

*---- Grundsätzlich immer die Mengen neu umrechnen für das neue    ----*
*---- Material, weil evtl. auch eine neue Mengeneinheit eingegeben ----*
*---- wurde                                                        ----*
  PERFORM umrechnen USING t_matnr.
*---- Neue Anzeigemengeneinheit und alten Umrechnungsfaktor ablegen ---*
  t_matnr-meins     = meins_neu.
  t_matnr-umrez_alt = umrez_neu.
  t_matnr-umren_alt = umren_neu.
  MODIFY t_matnr INDEX tabix_alt.

  sel_variante = matnr_neu.
*#jhl 12.04.96 vorliegende Fensternr. soll erhalten bleiben
* RMMMB-FENNR = START_FENNR.
  PERFORM e00_grund_liste.

ENDFORM.                               " ANZEIGE_NEUE_VAR

*&---------------------------------------------------------------------*
*&      Form  BEDARFSLISTE
*&---------------------------------------------------------------------*
*       Aktuelle Bedarfs-/Bestandsliste zum Material und Werk
*----------------------------------------------------------------------*
FORM bedarfsliste.

  IF zeilen_kz EQ wrk_zeile OR
     zeilen_kz EQ lag_zeile.
*????OR ZEILEN-KZ EQ CHA_ZEILE.    entfällt!
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nicht möglich ----------*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i067.
*   Bedarfs-Bestandsliste für Sammelmaterial nicht aufrufbar
    ELSE.
      PERFORM rette_spa_gpa.
      SET PARAMETER ID 'MAT' FIELD zle-matnr.
      SET PARAMETER ID 'WRK' FIELD zle-werks.
      TRY.
        CALL TRANSACTION 'MD04'
          WITH AUTHORITY-CHECK                            "note 2418143
          AND SKIP FIRST SCREEN.
      CATCH CX_SY_AUTHORIZATION_ERROR.                  "v note 2418143
        MESSAGE E853(MG) WITH 'MD04'.
      ENDTRY.                                           "^ note 2418143
      PERFORM zuruecksetzen_spa_gpa.
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.

ENDFORM.                               " BEDARFSLISTE

*&---------------------------------------------------------------------*
*&      Form  ZUL_MENGENEINHEITEN
*&---------------------------------------------------------------------*
*       Popupfenster mit den zulässigen Mengeneinheiten anzeigen und
*       Auswahl einer neuen Mengeneinheit unterstützen
*----------------------------------------------------------------------*
FORM zul_mengeneinheiten.

*  tga / acc retail
  IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
    PERFORM zul_me_anzeigen.
  ELSE.
    PERFORM show_uom_allowed CHANGING meins_neu.
  ENDIF.

  IF NOT meins_neu IS INITIAL.
* JH/12.12.96 zu 1.2B (Anfang)
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
* JH/12.12.96 zu 1.2B (Ende)

*---- Es wurde eine Mengeneinheit selektiert -> Umrechnen der Mengen- -*
*---- felder in den internen Bestandstabellen                         -*
    PERFORM umrechnen USING t_matnr.
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

    PERFORM e00_grund_liste.
  ENDIF.

ENDFORM.                               " ZUL_MENGENEINHEITEN

*&---------------------------------------------------------------------*
*&      Form  ZUL_MAT_ANZEIGEN
*&---------------------------------------------------------------------*
*       Prozessieren des Popups mit den zulässigen Materialien
*       (inkl. Matchcodeunterstützung)
*----------------------------------------------------------------------*
FORM zul_mat_anzeigen.

* JH/14.10.98/99.A (Anfang)
* FB F4_MACO ab 99.A nicht mehr verfügbar, ersetzt durch FB
* F4IF_FIELD_VALUE_REQUEST
*
* CLEAR MATNR_NEU.
* CALL FUNCTION 'F4_MACO'
*      EXPORTING
*           MCONAME        = 'MAT1'
**          SELSTR         = ' '
**          STARTING_X     = 1
**          STARTING_Y     = 1
*      IMPORTING
*           RETURN_VALUE   = MATNR_NEU
*      EXCEPTIONS
*           USER_CANCEL    = 1
*           NO_DATA_FOUND  = 2
*           UNKNOWN_ID     = 3
*           INTERNAL_ERROR = 4
*           OTHERS         = 5.
*
* IF SY-SUBRC > 2.
*   MESSAGE A058.
**  Bei der Anzeige der möglichen Materialien ist ein Fehler aufgetreten
* ENDIF.

  DATA: f4_sel_tab LIKE ddshretval OCCURS 0 WITH HEADER LINE.

  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      tabname           = space
      fieldname         = space
      searchhelp        = 'MAT1'
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
      matnr_neu = f4_sel_tab-fieldval.
    ENDIF.
  ELSEIF sy-subrc = 4.
*---- Kein Treffer bei der Selektion oder keine Auswahl durchgeführt --*
*---- -> nix ändern                                                  --*
  ELSE.
    MESSAGE a058.
*   Bei der Anzeige der möglichen Materialien ist ein Fehler aufgetreten
  ENDIF.
* JH/14.10.98/99.A (Ende)

ENDFORM.                               " ZUL_MAT_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  ZUL_VAR_ANZEIGEN
*&---------------------------------------------------------------------*
*       Prozessieren des Popups mit den zulässigen Varianten
*----------------------------------------------------------------------*
FORM zul_var_anzeigen.

  DATA: x_matnr LIKE t_matnr.  "Eigener Kopfbereich, damit alte Daten
  "im Kopfbereich v. T_MATNR nicht über-
  "schrieben werden
  DATA: BEGIN OF fields OCCURS 3.      " Anzuzeigende Felder
          INCLUDE STRUCTURE help_value.
  DATA: END OF fields.

  DATA: BEGIN OF valuetab OCCURS 50,   " Anzuzeigende Werte
          value LIKE shvalue-low_value,
        END OF valuetab.

*---- Anzuzeigende Felder zusammenstellen -----------------------------*
  CLEAR   fields.
  REFRESH fields.
  fields-tabname    = 'MARA'.
  fields-fieldname  = 'MATNR'.
  fields-selectflag = 'X'.
  APPEND fields.
  fields-tabname    = 'MAKT'.
  fields-fieldname  = 'MAKTX'.
  fields-selectflag = ' '.
  APPEND fields.

*---- Anzuzeigende Werte zusammenstellen ------------------------------*
  CLEAR   valuetab.
  REFRESH valuetab.
  LOOP AT t_matnr INTO x_matnr WHERE satnr = hide_alt-matnr.
    valuetab-value = x_matnr-matnr.
    APPEND valuetab.
    valuetab-value = x_matnr-maktx.
    APPEND valuetab.
  ENDLOOP.

*---- Dynpro für die Selektion einer neuen Variante prozessieren ------*
  CLEAR matnr_neu.
  CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
    EXPORTING
      fieldname                 = 'MARA'
      tabname                   = 'MATNR'
      titel                     = text-062
*     TITLE_IN_VALUES_LIST      = ' '
    IMPORTING
      select_value              = matnr_neu
    TABLES
      fields                    = fields
      valuetab                  = valuetab
    EXCEPTIONS
      field_not_in_ddic         = 1
      more_then_one_selectfield = 2
      no_selectfield            = 3
      OTHERS                    = 4.

  IF sy-subrc NE 0.
    MESSAGE a059.
*    Bei der Anzeige der möglichen Varianten ist ein Fehler aufgetreten
  ENDIF.

ENDFORM.                               " ZUL_VAR_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  BESTELLUNGEN
*&---------------------------------------------------------------------*
*       Liste der offenen Bestellungen zum Material und Werk
*----------------------------------------------------------------------*
FORM bestellungen.

  IF zeilen_kz EQ wrk_zeile OR
     zeilen_kz EQ lag_zeile.
*????OR ZEILEN-KZ EQ CHA_ZEILE.    entfällt!
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nur bedingt möglich ----*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i069.
*   Offene Bestellungen für Sammelmaterial nur bedingt möglich
    ENDIF.

    SUBMIT rm06em00
      WITH em_matnr EQ zle-matnr
      WITH em_werks EQ zle-werks
      AND RETURN.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.

ENDFORM.                               " BESTELLUNGEN

*&---------------------------------------------------------------------*
*&      Form  RESERVIERUNGEN
*&---------------------------------------------------------------------*
*       Liste der Reservierungen zum Material und Werk
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM reservierungen.

  IF zeilen_kz EQ wrk_zeile OR
     zeilen_kz EQ lag_zeile.
*????OR ZEILEN-KZ EQ CHA_ZEILE.    entfällt!
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nicht möglich ----------*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i070.
*   Reservierungen für Sammelmaterial nicht aufrufbar
    ELSE.
      SUBMIT rm07rmat
        WITH rm_matnr EQ zle-matnr
        WITH rm_werks EQ zle-werks
* JH/22.09.97/4.0A Parameter nicht mehr vorhanden
*       WITH XSELK    EQ 'X'        "Lagerort/Charge mit angezeigt
        AND RETURN.
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.

ENDFORM.                               " RESERVIERUNGEN
*&---------------------------------------------------------------------*
*&      Form  MATERIALBEWEGUNGEN
*&---------------------------------------------------------------------*
*       Liste der Materialbewegungen zum Material
*       Je nach gewählter Bestandszeile werden die Bewegungen zum Werk
*       oder zum Lagerort angezeigt.
*----------------------------------------------------------------------*
FORM materialbewegungen.

  DATA:ls_zle LIKE t_zle,
        lt_charg TYPE RANGE OF mchb-charg,
        ls_charg LIKE LINE OF lt_charg.

  IF zeilen_kz EQ wrk_zeile OR
     zeilen_kz EQ lag_zeile OR
     zeilen_kz EQ ch_zeile.

    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nicht möglich ----------*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i071.
*   Materialbewegungen für Sammelmaterial nicht aufrufbar
    ELSE.
* tga / note 412974 / start
*      CLEAR hbwart.
*      CLEAR hlifnr.
*      CASE zeilen_kz.
*        WHEN wrk_zeile.
*          PERFORM rette_spa_gpa.
*          SET PARAMETER ID 'MAT' FIELD zle-matnr.
*          SET PARAMETER ID 'WRK' FIELD zle-werks.
*          SET PARAMETER ID 'BWA' FIELD hbwart.
*          SET PARAMETER ID 'LIF' FIELD hlifnr.
*          CLEAR hlgort.
*          CLEAR hcharg.
*          SET PARAMETER ID 'LAG' FIELD hlgort.
*          SET PARAMETER ID 'CHA' FIELD hcharg.
*          CALL TRANSACTION 'MB51' AND SKIP FIRST SCREEN.
*          PERFORM zuruecksetzen_spa_gpa.
*        WHEN lag_zeile.
*          PERFORM rette_spa_gpa.
*          SET PARAMETER ID 'MAT' FIELD zle-matnr.
*          SET PARAMETER ID 'WRK' FIELD zle-werks.
*          SET PARAMETER ID 'BWA' FIELD hbwart.
*          SET PARAMETER ID 'LIF' FIELD hlifnr.
*          SET PARAMETER ID 'LAG' FIELD zle-lgort.
*          CLEAR hcharg.
*          SET PARAMETER ID 'CHA' FIELD hcharg.
*          CALL TRANSACTION 'MB51' AND SKIP FIRST SCREEN.
*          PERFORM zuruecksetzen_spa_gpa.
**       WHEN CHA_ZEILE.   ????entfällt!
**           SET PARAMETER ID 'MAT' FIELD MKOPF-MATNR.
**           SET PARAMETER ID 'WRK' FIELD ZLE-WERKS.
**           SET PARAMETER ID 'BWA' FIELD HBWART.
**           SET PARAMETER ID 'LIF' FIELD HLIFNR.
**           SET PARAMETER ID 'LAG' FIELD ZLE-LGORT.
**           SET PARAMETER ID 'CHA' FIELD ZLE-CHARG.
**           CALL TRANSACTION 'MB51' AND SKIP FIRST SCREEN.
*      ENDCASE.
      CASE zeilen_kz.
        WHEN wrk_zeile.
          SUBMIT rm07docs
              WITH matnr = zle-matnr
              WITH werks = zle-werks
              AND RETURN.

        WHEN lag_zeile.
          SUBMIT rm07docs
             WITH matnr = zle-matnr
             WITH werks = zle-werks
             WITH lgort = zle-lgort
             AND RETURN.

        WHEN ch_zeile.
          IF zle-charg IS NOT INITIAL.

          SUBMIT rm07docs
             WITH matnr = zle-matnr
             WITH werks = zle-werks
             WITH lgort = zle-lgort
             WITH charg = zle-charg
             AND RETURN.

          ELSEIF zle-sgt_scat IS NOT INITIAL AND
                 zle-charg    IS INITIAL .

            LOOP AT t_zle INTO ls_zle WHERE sgt_scat = zle-sgt_scat.
               MOVE : 'I'          TO ls_charg-sign,
                      'EQ'         TO ls_charg-option,
                      ls_zle-charg TO ls_charg-low.

               APPEND  ls_charg       TO  lt_charg.
            ENDLOOP.
          SORT lt_charg BY low.
          DELETE ADJACENT DUPLICATES FROM lt_charg COMPARING low.
          SUBMIT rm07docs
             WITH matnr = zle-matnr
             WITH werks = zle-werks
             WITH lgort = zle-lgort
             WITH charg IN lt_charg[]
             AND RETURN.
          ENDIF.

      ENDCASE.
* tga / note 412974 / end
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.

ENDFORM.                               " MATERIALBEWEGUNGEN

*&---------------------------------------------------------------------*
*&      Form  LVS_QUANTS
*&---------------------------------------------------------------------*
*       Anzeigen der LVS-Quants zum Material, Werk und Lagerort
*----------------------------------------------------------------------*
FORM lvs_quants.

  IF zeilen_kz EQ lag_zeile.
*????OR ZEILEN-KZ EQ CHA_ZEILE.    entfällt!
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nicht möglich ----------*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i072.
*   LVS-Bestände für Sammelmaterial nicht aufrufbar
    ELSE.
      PERFORM rette_spa_gpa.
      SET PARAMETER ID 'MAT' FIELD zle-matnr.
      SET PARAMETER ID 'WRK' FIELD zle-werks.
* JH/13.05.98/4.0C (Anfang)
* Änderung i.A. von Joachim Epp
* Die Lagerverwaltung kann pro Lagernummer nun auf einem externen
* System erfolgen -> Anzeige der LVS-Bestandsdaten ist in diesem Fall
* nicht mehr möglich
*     SELECT SINGLE * FROM T320
*          WHERE WERKS = ZLE-WERKS
*          AND   LGORT = ZLE-LGORT
*          AND   OBEST = SPACE.
*     IF SY-SUBRC EQ 0.
*       SET PARAMETER ID 'LGN' FIELD T320-LGNUM.
*       CALL TRANSACTION 'LS26' AND SKIP FIRST SCREEN.
*     ELSE.
*       MESSAGE I074.
**  Zum ausgewählten Werk und Lagerort ist kein LVS-Lager vorhanden
*     ENDIF.
      CALL FUNCTION 'L_LGORT_LGNUM_CHECK'
        EXPORTING
          i_werks                       = zle-werks
          i_lgort                       = zle-lgort
          i_lgdat                       = 'X'
        IMPORTING
          e_t320                        = t320
          e_t340d                       = t340d
        EXCEPTIONS
          lgnum_or_lgort_obligatory     = 1
          lgort_not_determined          = 2
          lgnum_or_lgort_wrong          = 3
          entry_not_in_t320             = 4
          werks_lgnum_not_valid         = 5
          standard_lgort_not_determined = 6
          lgnum_data_does_not_exist     = 7
          lgnum_text_does_not_exist     = 8
          OTHERS                        = 9.
      IF sy-subrc <> 0
      OR t320-obest <> space.
        MESSAGE i074.
*   Zum ausgewählten Werk und Lagerort ist kein LVS-Lager vorhanden
      ELSE.
        IF t340d-decsy IS INITIAL.
          SET PARAMETER ID 'LGN' FIELD t320-lgnum.
          TRY.
            CALL TRANSACTION 'LS26'
              WITH AUTHORITY-CHECK                        "note 2418143
              AND SKIP FIRST SCREEN.
          CATCH CX_SY_AUTHORIZATION_ERROR.              "v note 2418143
            MESSAGE E853(MG) WITH 'LS26'.
          ENDTRY.                                       "^ note 2418143
        ELSE.
          MESSAGE i090.
*   Lagerverwaltung für diese Lagernummer erfolgt auf einem externen Sys
        ENDIF.
      ENDIF.
* JH/13.05.98/4.0C (Ende)
      PERFORM zuruecksetzen_spa_gpa.
    ENDIF.
  ELSE.
    MESSAGE i073.
*   Wählen Sie eine Lagerortbestandszeile aus
  ENDIF.

ENDFORM.                               " LVS_QUANTS

*&---------------------------------------------------------------------*
*&      Form  SETZE_SPA_GPA
*&---------------------------------------------------------------------*
*       Setzen der vorhandenen SPA/GPA-Parameter für die Anzeige der
*       Artikelstammdaten
*----------------------------------------------------------------------*
FORM setze_spa_gpa.

  PERFORM rette_spa_gpa.

*---- Nicht relevante Parameter-ID's zurücksetzen ---------------------*
  CLEAR rmmw1.
  SET PARAMETER ID 'MTA' FIELD rmmw1-mtart.  "Materialart
  SET PARAMETER ID 'MKL' FIELD rmmw1-matkl.  "Warengruppe
  SET PARAMETER ID 'MTY' FIELD rmmw1-attyp.  "Artikeltyp
  SET PARAMETER ID 'EKO' FIELD rmmw1-ekorg.  "EKOrg
  SET PARAMETER ID 'RMA' FIELD rmmw1-rmatn.  "Vorlagematerial
  SET PARAMETER ID 'LIF' FIELD rmmw1-lifnr.  "Lieferant
  SET PARAMETER ID 'LTS' FIELD rmmw1-ltsnr.  "Lief.teilsort.
  SET PARAMETER ID 'VKO' FIELD rmmw1-vkorg.  "VKOrg
  SET PARAMETER ID 'VTW' FIELD rmmw1-vtweg.  "Vertiebsweg

ENDFORM.                               " SETZE_SPA_GPA

*&---------------------------------------------------------------------*
*&      Form  ZURUECKSETZEN_SPA_GPA
*&---------------------------------------------------------------------*
*       Zurücksetzen der geretteten SPA/GPA-Parameter
*----------------------------------------------------------------------*
FORM zuruecksetzen_spa_gpa.

  SET PARAMETER ID 'MAT' FIELD matnr_spa_gpa.  "Material
  SET PARAMETER ID 'MKL' FIELD matkl_spa_gpa.  "Warengruppe
  SET PARAMETER ID 'WRK' FIELD werks_spa_gpa.  "Werk
  SET PARAMETER ID 'LIF' FIELD lifnr_spa_gpa.  "Lieferant
  SET PARAMETER ID 'LTS' FIELD ltsnr_spa_gpa.  "Lief.teilsort.
  SET PARAMETER ID 'VKO' FIELD vkorg_spa_gpa.  "VKOrg
  SET PARAMETER ID 'VTW' FIELD vtweg_spa_gpa.  "Vertiebsweg
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
  SET PARAMETER ID 'EKO' FIELD ekorg_spa_gpa.  "Einkaufsorganisation
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)

ENDFORM.                               " ZURUECKSETZEN_SPA_GPA

*&---------------------------------------------------------------------*
*&      Form  ALTE_BESTANDSUEBERSICHT
*&---------------------------------------------------------------------*
*       Aufruf der alten Bestandsübersicht zur Anzeige der Bestandsdaten
*       auf Buchungskreisebene anstatt Basiswerksebene und Anzeige von
*       Chargenbestandsdaten (für Sammelartikel nicht möglich!)
*----------------------------------------------------------------------*
FORM alte_bestandsuebersicht.

  DATA: x_kzcha LIKE rmmmb-kzcha.

  IF ( zeilen_kz EQ man_zeile ) OR
     ( zeilen_kz EQ wgr_zeile ) OR
     ( zeilen_kz EQ wrk_zeile ) OR
     ( zeilen_kz EQ lag_zeile ).
*????OR ZEILEN-KZ EQ CHA_ZEILE.    entfällt!
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Aufruf der Transaktion für Sammelartikel nicht möglich ----------*
    IF t_matnr-attyp = attyp_sam.
      MESSAGE i078.
*    Bestandsübersicht BUKRS/CHARGE für Sammelmaterial nicht aufrufbar
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
      CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
      CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
      EXIT.
    ENDIF.

*---- Falls alle Anzeigeebenen bis zum Lagerort angekreuzt sind, wird -*
*---- auch die Ebene 'Chargen' angekreuzt                             -*
    IF NOT p_kzlgo IS INITIAL.
      x_kzcha = x.
    ENDIF.
*   tga acc retail ehp5
*    SUBMIT rmmmbest
    SUBMIT rmmmbestn
      WITH ms_matnr =  zle-matnr
      WITH ms_werks IN s_werks
      WITH kzlso    =  p_kzlso
      WITH kzlon    =  p_kzlon
*     WITH p_kzngc =  p_kzngc          " TGA/10.06.99 KZNGC
      WITH kzngc    =  p_kzngc          " TGA/30.09.99 KZNGC/TODO result
      WITH sobkz    IN s_sobkz
      WITH vernu    =  p_vernu
      WITH kznul    =  p_kznul
      WITH kzbuk    =  p_kzbwg
      WITH kzwer    =  p_kzwer
      WITH kzlgo    =  p_kzlgo
      WITH kzson    =  p_kzson
      WITH kzcha    =  x_kzcha
      WITH meinh    =  p_meinh
      AND RETURN.
  ELSE.
    MESSAGE i028.
*   Cursor bitte innerhalb einer Bestandszeile positionieren
  ENDIF.

ENDFORM.                               " ALTE_BESTANDSUEBERSICHT

*&---------------------------------------------------------------------*
*&      Form  RETTE_SPA_GPA
*&---------------------------------------------------------------------*
*       Retten der ursprünglichen SPA/GPA-Werte der relevanten Param.
*       (falls nämlich der Report mit einem SA gestartet wurde, aber
*       der Aufruf des externen Programms für eine Variante erfolgt,
*       würde beim Verlassen des Reports die Variante auf dem
*       Selektionsbildschirm erscheinen anstatt dem urspr. SA
*----------------------------------------------------------------------*
FORM rette_spa_gpa.

  GET PARAMETER ID 'MAT' FIELD matnr_spa_gpa.  "Material
  GET PARAMETER ID 'MKL' FIELD matkl_spa_gpa.  "Warengruppe
  GET PARAMETER ID 'WRK' FIELD werks_spa_gpa.  "Werk
  GET PARAMETER ID 'LIF' FIELD lifnr_spa_gpa.  "Lieferant
  GET PARAMETER ID 'LTS' FIELD ltsnr_spa_gpa.  "Lief.teilsort.
  GET PARAMETER ID 'VKO' FIELD vkorg_spa_gpa.  "VKOrg
  GET PARAMETER ID 'VTW' FIELD vtweg_spa_gpa.  "Vertiebsweg
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
  GET PARAMETER ID 'EKO' FIELD ekorg_spa_gpa.  "Einkaufsorganisation
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)

ENDFORM.                               " RETTE_SPA_GPA

*&---------------------------------------------------------------------*
*&      Form  EK_VK_ANZEIGEN
*&---------------------------------------------------------------------*
*       Anzeige der EK/VK-Bestandswerte zur ausgewählten Org.ebene
*----------------------------------------------------------------------*
FORM ek_vk_anzeigen.

*---- Die Daten des HIDE-Bereiches wurden in die entsprechenden Var. --*
*---- ZLE-..., zeilen_kz,... zurückgeschrieben                       --*
  kz_list = ek_vk_liste.

  CASE zeilen_kz.
    WHEN ges_zeile.
*????  PERFORM EK_VK_GES.
    WHEN man_zeile.
      PERFORM ek_vk_man.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*   WHEN BUK_ZEILE.
*      PERFORM Ek_vk_BUK.
    WHEN wgr_zeile.
      PERFORM ek_vk_wgr.
    WHEN wrk_zeile.
      IF sond_kz IS INITIAL.
        PERFORM ek_vk_wrk.
      ELSE.
        MESSAGE i087.
*   Die Anzeige von EK/VK-Bestandswerten ist für Sonderbestände nicht mö
      ENDIF.
    WHEN OTHERS.
      MESSAGE i086.
*   Wählen Sie eine Bestandszeile von der Ebene 'Werk' aus aufwärts
  ENDCASE.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " EK_VK_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICHNUNG_ANZEIGEN
*&---------------------------------------------------------------------*
*       Umschalten der Anzeige:
*       Bezeichnung für den Artikel (Grundliste in Anzeigestufe 'Art.-
*       liste') bzw. Bezeichnung für die Basisbetriebsgruppe (Grundliste
*       in Anzeigestufe 'Artikel' oder 'Einzelvariante') anzeigen
*----------------------------------------------------------------------*
FORM bezeichnung_anzeigen.

  CASE drilldown_level.
    WHEN einzart_level.
      anzeige_art_e = anz_art_bez.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE anbe TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE anbn TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN einzvar_level.
      anzeige_art_e = anz_art_bez.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE anbe TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE anbn TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN artlist_level.
      anzeige_art_l = anz_art_bez.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      REFRESH t_fcodes_l.
      MOVE anbe TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
      MOVE anbn TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
  ENDCASE.

  PERFORM e00_grund_liste.

ENDFORM.                               " BEZEICHNUNG_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  NUMMER_ANZEIGEN
*&---------------------------------------------------------------------*
*       Umschalten der Anzeige:
*       Nummer für den Artikel (Grundliste in Anzeigestufe 'Artikel-
*       liste') bzw. Nummer für die Basisbetriebsgruppe (Grundliste
*       in Anzeigestufe 'Artikel' oder 'Einzelvariante') anzeigen
*----------------------------------------------------------------------*
FORM nummer_anzeigen.

  CASE drilldown_level.
    WHEN einzart_level.
      anzeige_art_e = anz_art_nr.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE annr TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE anbe TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN einzvar_level.
      anzeige_art_e = anz_art_nr.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE annr TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE anbe TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN artlist_level.
      anzeige_art_l = anz_art_nr.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      REFRESH t_fcodes_l.
      MOVE annr TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
      MOVE anbe TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
  ENDCASE.

  PERFORM e00_grund_liste.

ENDFORM.                               " NUMMER_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  BEZEICH_NUM_ANZEIGEN
*&---------------------------------------------------------------------*
*       Umschalten der Anzeige:
*       Bezeichnung und Nummer für den Artikel (Grundliste in Anzeige-
*       stufe 'Artikelliste') bzw. Bezeichnung und Nummer für die Basis-
*       betriebsgruppe (Grundliste in Anzeigestufe 'Artikel' oder
*       'Einzelvariante') anzeigen
*----------------------------------------------------------------------*
FORM bezeich_num_anzeigen.

  CASE drilldown_level.
    WHEN einzart_level.
      anzeige_art_e = anz_art_bun.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE anbn TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE annr TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN einzvar_level.
      anzeige_art_e = anz_art_bun.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      DELETE t_fcodes_e WHERE fcode = annr
                           OR fcode = anbe
                           OR fcode = anbn.
      MOVE anbn TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
      MOVE annr TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    WHEN artlist_level.
      anzeige_art_l = anz_art_bun.
*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
      REFRESH t_fcodes_l.
      MOVE anbn TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
      MOVE annr TO t_fcodes_l-fcode.
      APPEND t_fcodes_l.
  ENDCASE.

  PERFORM e00_grund_liste.

ENDFORM.                               " BEZEICH_NUM_ANZEIGEN

*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
*&---------------------------------------------------------------------*
*&      Form  NEUSTART_F3
*&---------------------------------------------------------------------*
*       Programmneustart, nach Ausführen der Funktion 'F3' (Zurück)
*       -> alte Eingaben bleiben damit erhalten
*----------------------------------------------------------------------*
FORM neustart_f3.

*---- Falls der Programmaufruf aus einem Bereichsmenü heraus erfolgte,
*---- Kennz. setzen, weil SY-CALLD nach Programmneustart nicht mehr
*---- initial ist
  IF sy-calld IS INITIAL AND p_mcall IS INITIAL.
    p_mcall = x.
  ENDIF.
  p_recall = 'Z'.                      "wg. Zurück (F3)

  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
ENHANCEMENT-SECTION RWBE1F06_G2 SPOTS ES_RWBEST01 .
*---- Neustart des Programms, mit Übergabe der alten Eingabewerte     -*
*---- (Ausnahme: etwaige Merkmalswerteeinschränkungen gehen verloren) -*
  SUBMIT rwbest01
           WITH p_wkgrp =  p_wkgrp
           WITH p_vkorg =  p_vkorg
           WITH p_vtweg =  p_vtweg
           WITH s_werks IN s_werks
           WITH p_matkl =  p_matkl
           WITH s_matnr IN s_matnr
           WITH p_plgtp =  p_plgtp
           WITH p_lifnr =  p_lifnr
           WITH p_ltsnr =  p_ltsnr
           WITH p_saiso =  p_saiso
           WITH p_saisj =  p_saisj
           WITH p_kzlso =  p_kzlso
           WITH p_kzlon =  p_kzlon
           WITH p_kzngc =  p_kzngc     " TGA/10.06.99 KZNGC
           WITH p_kzvst0 =  p_kzvst0     " TGA/25.11.99 ALV Tree
           WITH p_kzvstc =  p_kzvstc     " TGA/25.11.99 ALV Tree
           WITH s_sobkz IN s_sobkz
           WITH p_vernu =  p_vernu
           WITH p_kznul =  p_kznul
           WITH p_kzbwg =  p_kzbwg
           WITH p_kzwer =  p_kzwer
           WITH p_kzlgo =  p_kzlgo
           WITH p_kzson =  p_kzson
           WITH p_chrg  =  p_chrg
           WITH p_kzcha =  p_kzcha
           WITH p_kzseg =  p_kzseg
           WITH p_meinh =  p_meinh
           WITH p_field =  p_field
           WITH p_recall = p_recall
           WITH p_mcall  = p_mcall
           WITH p_iltest = g_iltest
           VIA SELECTION-SCREEN.
END-ENHANCEMENT-SECTION.
  ELSE.
*---- Neustart des Programms, mit Übergabe der alten Eingabewerte     -*
*---- (Ausnahme: etwaige Merkmalswerteeinschränkungen gehen verloren) -*
  SUBMIT rwbest01
           WITH p_wkgrp =  p_wkgrp
           WITH p_vkorg =  p_vkorg
           WITH p_vtweg =  p_vtweg
           WITH s_werks IN s_werks
           WITH p_matkl =  p_matkl
           WITH s_matnr IN s_matnr
           WITH p_plgtp =  p_plgtp
           WITH p_lifnr =  p_lifnr
           WITH p_ltsnr =  p_ltsnr
           WITH p_saiso =  p_saiso
           WITH p_saisj =  p_saisj
           WITH p_kzlso =  p_kzlso
           WITH p_kzlon =  p_kzlon
           WITH p_kzngc =  p_kzngc     " TGA/10.06.99 KZNGC
           WITH p_kzvst0 =  p_kzvst0     " TGA/25.11.99 ALV Tree
           WITH p_kzvstc =  p_kzvstc     " TGA/25.11.99 ALV Tree
           WITH s_sobkz IN s_sobkz
           WITH p_vernu =  p_vernu
           WITH p_kznul =  p_kznul
           WITH p_kzbwg =  p_kzbwg
           WITH p_kzwer =  p_kzwer
           WITH p_kzlgo =  p_kzlgo
           WITH p_kzson =  p_kzson
           WITH p_meinh =  p_meinh
           WITH p_field =  p_field
           WITH p_recall = p_recall
           WITH p_mcall  = p_mcall
           WITH p_iltest = g_iltest
           VIA SELECTION-SCREEN.
  ENDIF.
ENDFORM.                               " NEUSTART_F3
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090

* JH/27.10.98/4.6A (Anfang)
*&---------------------------------------------------------------------*
*&      Form  REFRESH
*&---------------------------------------------------------------------*
*       Neues Lesen der Bestandsdaten für den angzeigten Artikel
*       und die angezeigte Mengeneinheit.
*       Wenn der Artikel in einer Alternativ-ME angezeigt wurde, müssen
*       die neu gelesenen Bestandsdaten, die dann in der BASME
*       vorliegen, in die Alternativ-ME umgerechnet werden.
*       Vor dem Nachlesen müssen erst die Bestände aus allen
*       internen Bestandstabellen herausgelöscht werden.
*       Wenn eine Variante oder ein SA angezeigt wird, erfolgt der
*       Refresh für den SA und alle dazugehörenden Varianten.
*----------------------------------------------------------------------*
FORM refresh.

  DATA: ht_matnr  LIKE t_matnr OCCURS 0 WITH HEADER LINE.
  DATA: sav_matnr LIKE t_matnr.
  DATA: hsatnr    LIKE mara-satnr.     "Sammelartikelnr.
  DATA: hmatnr    LIKE mara-matnr.     "Aktuelle Artikelnr.

* Zum Retten der bereinigten Bestandstabellen
* Lokale Bestandstabellen die durch den Refresh gefüllt werden
  DATA: h_mbe     LIKE mbe OCCURS 0 WITH HEADER LINE,
        h_gbe     LIKE gbe OCCURS 0 WITH HEADER LINE,
        h_wbe     LIKE wbe OCCURS 0 WITH HEADER LINE,
        h_lbe     LIKE lbe OCCURS 0 WITH HEADER LINE,
        h_ebs     LIKE ebs OCCURS 0 WITH HEADER LINE,
        h_kbe     LIKE kbe OCCURS 0 WITH HEADER LINE,
        h_mps     LIKE mps OCCURS 0 WITH HEADER LINE,
        h_obs     LIKE obs OCCURS 0 WITH HEADER LINE,
        h_vbs     LIKE vbs OCCURS 0 WITH HEADER LINE,
        h_wbs     LIKE wbs OCCURS 0 WITH HEADER LINE,
        h_oeb     LIKE oeb OCCURS 0 WITH HEADER LINE,
        h_ek_vk   LIKE ek_vk OCCURS 0 WITH HEADER LINE,
        h_cbe     LIKE cbe  OCCURS 0 WITH HEADER LINE,
        h_wbs_seg LIKE wbs_seg OCCURS 0 WITH HEADER LINE.

ENHANCEMENT-POINT RWBE1F06_G1 SPOTS ES_RWBEST01 .

* Tabelleninhalt T_MATNR retten, weil fürs selektive Lesen der
* Bestandsdaten nur die relevanten Artikel in T_MATNR belassen werden.
* Workarea T_MATNR retten, um später T_MATNR wieder mit dem aktuellen
* Stand zu versorgen, weil Workarea T_MATNR durch das Lesen der
* Bestandsdaten überschrieben wird.
*  ht_matnr[] = t_matnr[].
*  ht_matnr = t_matnr.
*  hmatnr     = t_matnr-matnr.
*TGA/4.6 Erweiterungen Lot (START)**************************************
* Logik geändert, nur die vom Refresh betroffenen DAten  werden
* aus den Bestandstabellen gelöscht, danach der aktuelle Bestand
* für die relevanten ermittelt und anschließend an die
* bestehenden angehängt
  sav_matnr   = t_matnr.               "Workarea T_MATNR retten
*TGA/4.6 Erweiterungen Lot (END)****************************************
* Liste der Artikel aufbauen, für die ein Neulesen der Bestandsdaten
* notwendig ist (bei DRILLDOWN_LEVEL = ARTLIST_LEVEL sind alle Artikel
* relevant -> kein explizites Löschen und Retten der internen Bestands-
* tabellen notwendig).
  IF drilldown_level = einzart_level
  OR drilldown_level = einzvar_level.
*   Anzeigestufe 'Artikel' oder 'Variante'
*TGA/4.6 Erweiterungen Lot (START)**************************************
*   REFRESH t_matnr.                         "start delete
*
*   IF ht_matnr-attyp = attyp_sam
*   or ht_matnr-attyp = attyp_var.
*     Bei SA oder Variante den SA und alle Varianten aufnehmen
*     IF ht_matnr-attyp = attyp_sam.
*       hsatnr = ht_matnr-matnr.
*     ELSE.
*       hsatnr = ht_matnr-satnr.
*     ENDIF.
*     Sammelartikel aufnehmen
*     READ TABLE ht_matnr WITH KEY matnr = hsatnr BINARY SEARCH.
*     IF sy-subrc ne 0.
*       MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*     ENDIF.
*     APPEND ht_matnr TO t_matnr.
*     LOOP AT ht_matnr WHERE satnr = hsatnr.
*       Variante übernehmen
*       APPEND ht_matnr TO t_matnr.
*     ENDLOOP.
*   ELSE.
*     Einzelartikel oder Variante ohne Bezug zum SA aufnehmen
*     APPEND ht_matnr TO t_matnr.
*   ENDIF.
*   SORT t_matnr BY matnr.
*
*   Bestehende Bestandsdaten für alle betroffenen Artikel löschen
*   LOOP AT t_matnr.
*     PERFORM bestandsdaten_loeschen USING t_matnr-matnr.
*   ENDLOOP.
*
*   Bereinigte Bestandstabellen retten
*    h_mbe[] = mbe[].
*   h_gbe[] = gbe[].
*   h_wbe[] = wbe[].
*   h_lbe[] = lbe[].
*   h_ebs[] = ebs[].
*   h_kbe[] = kbe[].
*   h_mps[] = mps[].
*   h_obs[] = obs[].
*   h_vbs[] = vbs[].
*   h_wbs[] = wbs[].
*   h_oeb[] = oeb[].
*   h_ek_vk[] = ek_vk[].                    "end delete
*************ab hier neue Verarbeitung entspr. neuer Logik**************
    REFRESH ht_matnr.

    IF t_matnr-attyp = attyp_sam
    OR t_matnr-attyp = attyp_var.
*     Bei SA oder Variante den SA und alle Varianten aufnehmen
      IF t_matnr-attyp = attyp_sam.
        hsatnr = t_matnr-matnr.
      ELSE.
        hsatnr = t_matnr-satnr.
      ENDIF.
*     Sammelartikel aufnehmen
      READ TABLE t_matnr WITH KEY matnr = hsatnr BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Nur wenn Variante mit Bezug zum Sammelartikel vorliegt, auch
*       den Sammelartikel aufnehmen. Erfolgte der Einstieg über eine
*       einzelne Variante, ist der Sammelartikel nicht im Zugriff.
        APPEND t_matnr TO ht_matnr.
        LOOP AT t_matnr WHERE satnr = hsatnr.
*       Variante übernehmen
          APPEND t_matnr TO ht_matnr.
        ENDLOOP.
      ELSE.
*-----Einzelne Variante (ohne SA-Bezug) aufnehmen
        APPEND t_matnr TO ht_matnr.
      ENDIF.
    ELSE.
*     Einzelartikel oder Variante ohne Bezug zum SA aufnehmen
      APPEND t_matnr TO ht_matnr.
    ENDIF.
    SORT ht_matnr BY matnr.

*   Bestehende Bestandsdaten für alle betroffenen Artikel löschen
    LOOP AT ht_matnr.
      PERFORM bestandsdaten_loeschen USING ht_matnr-matnr.
    ENDLOOP.
******brauchen wir wohl nicht mehr**************************
*   Bereinigte Bestandstabellen retten
*   h_mbe[] = mbe[].
*   h_gbe[] = gbe[].
*   h_wbe[] = wbe[].
*   h_lbe[] = lbe[].
*   h_ebs[] = ebs[].
*   h_kbe[] = kbe[].
*   h_mps[] = mps[].
*   h_obs[] = obs[].
*   h_vbs[] = vbs[].
*   h_wbs[] = wbs[].
*   h_oeb[] = oeb[].
*   h_ek_vk[] = ek_vk[].
    REFRESH: h_mbe, h_gbe, h_wbe, h_lbe, h_ebs, h_kbe,
            h_mps, h_obs, h_vbs, h_wbs, h_oeb, h_ek_vk,
            h_cbe, h_wbs_seg.

    PERFORM bestandsdaten_lesen TABLES ht_matnr
                                  t_werks
                                  h_mbe h_gbe h_wbe h_lbe h_ebs h_kbe
                                  h_mps h_obs h_vbs h_wbs h_oeb h_ek_vk
                                  h_cbe h_wbs_seg.

  ELSE.
* komplett neu einlesen
    REFRESH: mbe, gbe, wbe, lbe, ebs, kbe,
             mps, obs, vbs, wbs, oeb, ek_vk,
             cbe, wbs_seg.
    PERFORM bestandsdaten_lesen TABLES t_matnr
                                       t_werks
                                    mbe gbe wbe lbe ebs kbe
                                    mps obs vbs wbs oeb ek_vk
                                    cbe wbs_seg.
* füllen wg. möglicher späterer Umrechnung der Mengeneinheiten
    ht_matnr[] = t_matnr[].
*TGA/4.6 Erweiterungen Lot (END)
  ENDIF.

*TGA/4.6 Erweiterungen Lot (START)
* Bestandsdaten für alle betroffenen Artikel neu Lesen
* PERFORM BESTANDSDATEN_LESEN.
*TGA/4.6 Erweiterungen Lot (END)
  IF drilldown_level = einzart_level
  OR drilldown_level = einzvar_level.
*   Gerettete Bestände wieder anfügen
    APPEND LINES OF h_mbe TO mbe.
    SORT mbe BY matnr.
    APPEND LINES OF h_gbe TO gbe.
    SORT gbe BY matnr bwgrp.
    APPEND LINES OF h_wbe TO wbe.
    SORT wbe BY matnr werks.
    APPEND LINES OF h_lbe TO lbe.
    SORT lbe BY matnr werks lgort.
    APPEND LINES OF h_ek_vk TO ek_vk.
    SORT ek_vk BY matnr werks.
    APPEND LINES OF h_ebs TO ebs.
    SORT ebs BY matnr werks lgort vbeln posnr.
    APPEND LINES OF h_kbe TO kbe.
    SORT kbe BY matnr werks lgort lifnr.
    APPEND LINES OF h_mps TO mps.
    SORT mps BY matnr werks lgort lifnr.
    APPEND LINES OF h_obs TO obs.
    SORT obs BY matnr werks lifnr.
    APPEND LINES OF h_wbs TO wbs.
    SORT wbs BY matnr werks kunnr.
    APPEND LINES OF h_vbs TO vbs.
    SORT vbs BY matnr werks kunnr.
    APPEND LINES OF h_oeb TO oeb.
    SORT oeb BY matnr werks lifnr vbeln posnr.
    IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
      APPEND LINES OF h_cbe TO cbe.
      SORT cbe BY matnr bwgrp werks lgort sgt_scat charg.

      APPEND LINES OF h_wbs_seg TO wbs_seg.
      SORT wbs_seg BY matnr werks charg kunnr.
    ENDIF.
  ENDIF.

* Die Mengen aller Artikel umrechnen, deren Anzeigemengeneinh. von der
* Basismengeneinheit abweicht, weil die neu gelesenen Bestandswerte
* in BASME vorliegen.

  LOOP AT ht_matnr.
    CHECK ht_matnr-meins <> t_matnr-basme.

*   In der Anzeigestufe 'Artikelliste' sind die ME i.d.R. noch nicht
*   bekannt -> zur Sicherheit nochmal nachlesen für die Umrechnung
    IF drilldown_level = artlist_level.
      PERFORM mengeneinheiten_lesen TABLES ht_matnr. "TGA/4.6 Erw Lot
    ENDIF.

*   Umrechnungsfaktoren zur Basis-ME setzen
    meins_neu         = ht_matnr-meins.
    ht_matnr-umrez_alt = 1.
    ht_matnr-umren_alt = 1.

*   Umrechnen der Mengenfelder
    PERFORM umrechnen USING ht_matnr.
    IF NOT max_stock_value_reached IS INITIAL.
*     Umrechnung hat zu einem Überlauf geführt -> Meldung ausgeben
*     und Bestandswerte wieder auf BASME umrechnen
      MESSAGE i109(mm).
*    Umrechnung in d. ausgewählte Mengeneinheit würde zu einem Überlauf
      ht_matnr-umrez_alt = umrez_neu.
      ht_matnr-umren_alt = umren_neu.
      meins_neu         = ht_matnr-basme.
      PERFORM umrechnen USING ht_matnr.
*     Anzeigemengeneinheit auf BASME zurücksetzen inkl. der Umrechn.-
*     faktoren (in der orignalen T_MATNR)
      READ TABLE t_matnr WITH KEY matnr = ht_matnr-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        t_matnr-meins     = ht_matnr-basme.
        t_matnr-umrez_alt = 1.
        t_matnr-umren_alt = 1.
        MODIFY t_matnr INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDLOOP.
*TGA/4.6 Erweiterungen Lot (START)
* T_MATNR sollte noch ok sein
* T_MATNR wiederherstellen
*  t_matnr[] = ht_matnr[].
*  READ TABLE t_matnr WITH KEY matnr = hmatnr BINARY SEARCH.
*  IF sy-subrc ne 0.
*    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*  ENDIF.
*tga************ Workarea t_matnr wiederherstellen *********************
  t_matnr = sav_matnr.
  REFRESH: ht_matnr.
  CLEAR: ht_matnr.
*TGA/4.6 Erweiterungen Lot (END)
  PERFORM e00_grund_liste.

ENDFORM.                               " REFRESH
*&---------------------------------------------------------------------*
*&      Form  BESTANDSDATEN_LOESCHEN
*&---------------------------------------------------------------------*
*       Bestandsdaten für den betroffenen Artikel aus allen internen
*       Bestandstabellen rauslöschen
*----------------------------------------------------------------------*
FORM bestandsdaten_loeschen USING pi_matnr LIKE mara-matnr.

  DATA: htabix LIKE sy-tabix.

  READ TABLE mbe WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    DELETE mbe INDEX sy-tabix.
  ENDIF.

* Bestandswerte auf Basiswerksgruppenebene löschen
  READ TABLE gbe WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT gbe FROM htabix.                            "#EC CI_NOORDER
      IF gbe-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE gbe.
    ENDLOOP.
  ENDIF.

* Bestandswerte auf Werksebene löschen
  READ TABLE wbe WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT wbe FROM htabix.                            "#EC CI_NOORDER
      IF wbe-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE wbe.
    ENDLOOP.
  ENDIF.

* Bestandswerte auf Lagerortebene löschen
  READ TABLE lbe WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT lbe FROM htabix.                            "#EC CI_NOORDER
      IF lbe-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE lbe.
    ENDLOOP.
  ENDIF.

* Bestandswerte auf Chargenebene löschen ????entfällt
* READ TABLE CBE WITH KEY MATNR = PI_MATNR BINARY SEARCH.
* IF SY-SUBRC = 0.
*   HTABIX = SY-TABIX.
*   LOOP AT CBE FROM HTABIX.
*     IF CBE-MATNR <> PI_MATNR.
*       EXIT.
*     ENDIF.
*     DELETE CBE.
*   ENDLOOP.
* ENDIF.

* Lieferantenkonsi-Bestände löschen
  READ TABLE kbe WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT kbe FROM htabix.                            "#EC CI_NOORDER
      IF kbe-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE kbe.
    ENDLOOP.
  ENDIF.

* Kundenauftrags-Bestände löschen
  READ TABLE ebs WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT ebs FROM htabix.                            "#EC CI_NOORDER
      IF ebs-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE ebs.
    ENDLOOP.
  ENDIF.

* Lieferanten-MTV-Bestände löschen
  READ TABLE mps WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT mps FROM htabix.                            "#EC CI_NOORDER
      IF mps-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE mps.
    ENDLOOP.
  ENDIF.

* Lieferantenbeistellungs-Bestände löschen
  READ TABLE obs WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT obs FROM htabix.                            "#EC CI_NOORDER
      IF obs-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE obs.
    ENDLOOP.
  ENDIF.

* Projektbestände löschen ????uninteressant für Handel
* READ TABLE PBE WITH KEY MATNR = PI_MATNR BINARY SEARCH.
* IF SY-SUBRC = 0.
*   HTABIX = SY-TABIX.
*   LOOP AT PBE FROM HTABIX.
*     IF PBE-MATNR <> PI_MATNR.
*       EXIT.
*     ENDIF.
*     DELETE PBE.
*   ENDLOOP.
* ENDIF.

* Kundenleergut-Bestände löschen
  READ TABLE vbs WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT vbs FROM htabix.                            "#EC CI_NOORDER
      IF vbs-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE vbs.
    ENDLOOP.
  ENDIF.

* Kundenkonsi-Bestände löschen
  READ TABLE wbs WITH KEY matnr = pi_matnr BINARY SEARCH."#EC CI_SORTED
  IF sy-subrc = 0.
    htabix = sy-tabix.
    LOOP AT wbs FROM htabix.                            "#EC CI_NOORDER
      IF wbs-matnr <> pi_matnr.
        EXIT.
      ENDIF.
      DELETE wbs.
    ENDLOOP.
  ENDIF.

*>>> hier evtl. weitere Sonderbestände einfügen

ENDFORM.                               " BESTANDSDATEN_LOESHEN
* JH/27.10.98/4.6A (Ende)
*&---------------------------------------------------------------------*
*&      Form  info_struct_art
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM info_struct_art.

  DATA: ht_matnr  LIKE t_matnr OCCURS 0 WITH HEADER LINE.
  DATA: ht_t_comp_struc  LIKE t_comp_struc OCCURS 0 WITH HEADER LINE.
* Local stock tables for structured articles
  DATA: h_wbe LIKE wbe OCCURS 0 WITH HEADER LINE,
        h_lbe LIKE lbe OCCURS 0 WITH HEADER LINE.
  CLEAR: h_wbe, h_lbe, sbe.
  REFRESH: h_wbe, h_lbe, sbe, cum_comp.
  DATA: comp_stock_found VALUE no,
        comp_ass_found VALUE no.

  DATA: ls_t134 TYPE t134.
*---Listkennzeichen für Liste
  kz_list = strart_liste.
  READ TABLE t_matnr WITH KEY matnr = zle-matnr.
* Material type for empties not supported, note 1511925
     CALL FUNCTION 'T134_SINGLE_READ'
        EXPORTING
*         KZRFB            = ' '
          T134_MTART       = t_matnr-mtart
       IMPORTING
         WT134            = ls_t134
       EXCEPTIONS
         NOT_FOUND        = 1
         OTHERS           = 2
                .
      IF SY-SUBRC <> 0.
         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
  IF ls_t134-wmakg = '2'. "Material type for empties
    MESSAGE i102.
    RETURN.
  ENDIF.

  IF zeilen_kz EQ wrk_zeile OR zeilen_kz EQ lag_zeile.
*--find structured articles
    PERFORM find_strart TABLES t_comp_struc
                        USING comp_ass_found.
*--- any assignments found  ?
    IF comp_ass_found EQ no.
      MESSAGE i095.
      CHECK comp_ass_found = yes.    " exit
    ENDIF.

*--find out stocks of stuctured articles
    PERFORM stocks_of_strart TABLES ht_matnr h_wbe h_lbe
                                     ht_t_comp_struc
                             USING comp_stock_found.
*--- any stocks found  ?
    IF comp_stock_found EQ no.
      MESSAGE i093.
      CHECK comp_stock_found = yes.    " exit
    ENDIF.
*--filling cbe with stocks of components
*--stocks of components =  quant str.art * quant. comp in str.art
    PERFORM stocks_of_components TABLES ht_matnr
                                 ht_t_comp_struc
*                                h_mbe h_gbe
                                 h_wbe h_lbe sbe.
*                                h_ebs h_kbe
*                                h_mps h_obs h_vbs h_wbs h_oeb h_ek_vk.
*----show results
*   tga / acc retail
    IF cl_retail_switch_check=>isr_appl_usability_sfws( ) IS INITIAL.
      PERFORM show_comp_stock.
    ELSE.
      PERFORM show_comp_stock_grid.
    ENDIF.
  ELSE.
    MESSAGE i094.
  ENDIF.

ENDFORM.                               " info_struct_art
*&---------------------------------------------------------------------*
*&      Form  find_strart
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM find_strart TABLES p_t_comp_struc STRUCTURE t_comp_struc
                 USING comp_ass_found  TYPE c.     "tga unicode

  CLEAR: t_comp_struc.
  REFRESH: t_comp_struc.

  IF t_matnr-attyp = attyp_sam.
*--fill t_comp_struc with components and quantities of components
*--in structured article
    LOOP AT t_matnr WHERE satnr = zle-matnr.
      PERFORM fill_t_compstruc TABLES p_t_comp_struc
                               USING t_matnr-matnr  comp_ass_found.
    ENDLOOP.
  ELSE.
*--fill t_comp_struc with components and quantities of components
    PERFORM fill_t_compstruc TABLES p_t_comp_struc
                             USING zle-matnr  comp_ass_found.
  ENDIF.
ENDFORM.                               " find_strart
*&---------------------------------------------------------------------*
*&      Form  fill_t_compstruc
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_T_MATNR_MATNR  text
*----------------------------------------------------------------------*
FORM fill_t_compstruc TABLES p_t_comp_struc STRUCTURE t_comp_struc
                      USING    pi_matnr       TYPE matnr  "tga unicode
                               comp_ass_found TYPE c.     "tga unicode

  DATA: BEGIN OF ht_comp_struc OCCURS 0.
          INCLUDE STRUCTURE rmgw2wu.
  DATA: END   OF ht_comp_struc.

  CLEAR: ht_comp_struc.
  REFRESH: ht_comp_struc.

  CALL FUNCTION 'MGW0_WHERE_USED_COMPONENTS'
    EXPORTING
      mgw0_matnr          = pi_matnr
*     MGW0_DATUV          = SY-DATUM
*     MGW0_DATUB          = '99991231'
*     MGW0_STLAN          = ' '
*     MGW0_WERKS          = ' '
*     MGW0_POSTP          = ' '
    TABLES
      structured_articles = ht_comp_struc.
*
  READ TABLE ht_comp_struc INDEX 1.
  IF sy-subrc = 0.
    LOOP AT ht_comp_struc.
      t_comp_struc-comp_matnr = pi_matnr.
      MOVE-CORRESPONDING ht_comp_struc TO p_t_comp_struc.
      APPEND p_t_comp_struc.
    ENDLOOP.
    comp_ass_found = yes.
* tga \ 4.6C Correction -> comp_ass_found can be set to NO if
* in prepack are less variants then variants of generic material exist
* comp_ass_found is predefined as NO
* ELSE.
*   comp_ass_found = NO.
  ENDIF.
ENDFORM.                               " fill_t_compstruc
*&---------------------------------------------------------------------*
*&      Form  stocks_of_strart
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM stocks_of_strart TABLES ht_matnr        STRUCTURE t_matnr
                             h_wbe           STRUCTURE wbe
                             h_lbe           STRUCTURE lbe
                             ht_t_comp_struc STRUCTURE t_comp_struc
                      USING comp_stock_found TYPE c.  "tga unicode

  DATA: h_t_comp_struc LIKE t_comp_struc OCCURS 0 WITH HEADER LINE,
        h_t_werks LIKE t_werks OCCURS 0 WITH HEADER LINE.
  DATA: h_satnr    LIKE mara-satnr,    "Sammelartikelnr.
        h_matnr    LIKE mara-matnr.    "Aktuelle Artikelnr.
  DATA: BEGIN OF sav_comp_struc OCCURS 0,
              ne_basme.                "stock not in basic mat unit
          INCLUDE STRUCTURE t_comp_struc.
  DATA: END  OF sav_comp_struc.
  DATA: BEGIN OF x_makt OCCURS 0.      "Liste der Materialkurztexte
          INCLUDE STRUCTURE makt.
  DATA: END   OF x_makt.
  DATA: l_count TYPE i.

* Local stock tables for structured articles, only as dummy ???
  DATA:  h_mbe LIKE mbe OCCURS 0 WITH HEADER LINE,
         h_gbe LIKE gbe OCCURS 0 WITH HEADER LINE,
*        h_wbe LIKE wbe OCCURS 0 WITH HEADER LINE,
*        h_lbe LIKE lbe OCCURS 0 WITH HEADER LINE,
         h_ebs LIKE ebs OCCURS 0 WITH HEADER LINE,
         h_kbe LIKE kbe OCCURS 0 WITH HEADER LINE,
         h_mps LIKE mps OCCURS 0 WITH HEADER LINE,
         h_obs LIKE obs OCCURS 0 WITH HEADER LINE,
         h_vbs LIKE vbs OCCURS 0 WITH HEADER LINE,
         h_wbs LIKE wbs OCCURS 0 WITH HEADER LINE,
         h_oeb LIKE oeb OCCURS 0 WITH HEADER LINE,
         h_ek_vk LIKE ek_vk OCCURS 0 WITH HEADER LINE,
         h_cbe LIKE cbe OCCURS 0 WITH HEADER LINE,
         h_wbs_seg LIKE wbs_seg OCCURS 0 WITH HEADER LINE.

  CLEAR: h_matnr.
  CLEAR: t_mara.
  REFRESH: t_mara.
*----fill h_t_werks with the one site
  READ TABLE t_werks WITH KEY werks = zle-werks.
  h_t_werks = t_werks.
  APPEND h_t_werks.

  ht_t_comp_struc[] = t_comp_struc[].
*--- ht t_comp_struc only 1 entry per structured article
  SORT ht_t_comp_struc BY matnr.
  DELETE ADJACENT DUPLICATES FROM ht_t_comp_struc COMPARING matnr.
*-- save h_t_comp_struc for later test if any stocks are found
  h_t_comp_struc[] = ht_t_comp_struc[].
*--- prepare t_mara to get ht_matnr, structured articles could
*--- be selected before
  LOOP AT ht_t_comp_struc.
    READ TABLE t_matnr WITH KEY matnr = ht_t_comp_struc-matnr.
    IF sy-subrc = 0.
*check if basme is still used as display unit
*---hier könnte man u.U. noch den Attyp der schon selektierten
*---Komponenten ermitteln und weitergeben
      IF t_matnr-basme NE t_matnr-meins.
        MOVE 'X' TO sav_comp_struc-ne_basme.
      ENDIF.
      MOVE-CORRESPONDING ht_t_comp_struc TO sav_comp_struc.
      APPEND sav_comp_struc.
      DELETE ht_t_comp_struc.
    ENDIF.
  ENDLOOP.
  DESCRIBE TABLE ht_t_comp_struc LINES l_count.
  IF l_count GT 0.
*----articles which are not selected via selection screen
    SELECT * FROM  mara INTO TABLE t_mara
                         FOR ALL ENTRIES IN ht_t_comp_struc
                         WHERE matnr EQ ht_t_comp_struc-matnr.
    IF sy-subrc = 0.
*----fill ht_matnr
      LOOP AT t_mara.
        PERFORM mat_einfuegen TABLES ht_matnr
                               USING t_mara.
      ENDLOOP.
*---hier könnte man u.U. noch den Attyp der neu selektierten
*---Komponenten ermitteln und weitergeben
* ht_matnr needs still article description ??
      SELECT * FROM makt INTO TABLE x_makt
            FOR ALL ENTRIES IN ht_matnr
            WHERE  matnr = ht_matnr-matnr
            AND    spras = sy-langu.
*----description zo ht_matnr
      LOOP AT x_makt.
        READ TABLE ht_matnr WITH KEY matnr = x_makt-matnr.
        IF sy-subrc NE 0.
          MESSAGE a038 WITH 'T_MATNR'.
*   Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabell
        ENDIF.
        ht_matnr-maktx = x_makt-maktx.
        MODIFY ht_matnr INDEX sy-tabix.
      ENDLOOP.
*----read stocks of selected components of struct materials
      PERFORM bestandsdaten_lesen TABLES ht_matnr
                                  h_t_werks
                                  h_mbe h_gbe h_wbe h_lbe h_ebs h_kbe
                                  h_mps h_obs h_vbs h_wbs h_oeb h_ek_vk
                                  h_cbe h_wbs_seg.
    ENDIF.
  ENDIF.
*---fill up h_wbe/h_lbe with known wbe/lbe values
  READ TABLE sav_comp_struc INDEX 1.
  IF sy-subrc = 0.
    LOOP AT sav_comp_struc.
      PERFORM fill_h_stocks TABLES h_wbe h_lbe
                            USING sav_comp_struc-matnr
                                  sav_comp_struc-ne_basme.
    ENDLOOP.
  ENDIF.
*---is there any stock found ??
  LOOP AT h_t_comp_struc.
    CASE zeilen_kz.
      WHEN wrk_zeile.
        READ TABLE h_wbe WITH KEY matnr = h_t_comp_struc-matnr
                                  werks = zle-werks.
        IF sy-subrc = 0.
          IF  NOT h_wbe-labst IS INITIAL.
            comp_stock_found = yes.
            EXIT.
          ENDIF.
        ENDIF.
      WHEN lag_zeile.
        READ TABLE h_lbe WITH KEY matnr = h_t_comp_struc-matnr
                                  werks = zle-werks
                                  lgort = zle-lgort.
        IF sy-subrc = 0.
          IF NOT h_lbe-labst IS INITIAL.
            comp_stock_found = yes.
            EXIT.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDLOOP.
ENDFORM.                               " stocks_of_strart
*&---------------------------------------------------------------------*
*&      Form  stocks_of_components
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HT_MATNR  text
*      -->P_H_MBE  text
*      -->P_H_GBE  text
*      -->P_H_WBE  text
*      -->P_H_LBE  text
*      -->P_H_EBS  text
*      -->P_H_KBE  text
*      -->P_H_MPS  text
*      -->P_H_OBS  text
*      -->P_H_VBS  text
*      -->P_H_WBS  text
*      -->P_H_OEB  text
*      -->P_H_EK_VK  text
*----------------------------------------------------------------------*
FORM stocks_of_components TABLES
                          p_ht_matnr      STRUCTURE t_matnr
                          ht_t_comp_struc STRUCTURE t_comp_struc
*                         P_H_MBE         STRUCTURE H_MBE
*                         P_H_GBE         STRUCTURE H_GBE
                          p_h_wbe         STRUCTURE wbe
                          p_h_lbe         STRUCTURE lbe
                          p_sbe           STRUCTURE sbe.
*                         P_H_EBS         STRUCTURE H_EBS
*                         P_H_KBE         STRUCTURE H_KBE
*                         P_H_MPS         STRUCTURE H_MPS
*                         P_H_OBS         STRUCTURE H_OBS
*                         P_H_VBS         STRUCTURE H_VBS
*                         P_H_WBS         STRUCTURE H_WBS
*                         P_H_OEB         STRUCTURE H_OEB
*                         P_H_EK_VK       STRUCTURE H_EK_VK.
*----fill CBE with component quantity and labst                --------*
*----of found struct. articles                                 --------*
  PERFORM count_stocks TABLES p_ht_matnr
                              p_h_wbe p_h_lbe p_sbe .
*----take care of units of measure of component
  READ TABLE t_matnr WITH KEY matnr = zle-matnr.
  IF t_matnr-meins NE t_matnr-basme AND t_matnr-meins NE space.
    umrez_neu = t_matnr-umrez_alt.
    umren_neu = t_matnr-umren_alt.
*----findout umrez_alt and umren_alt                 -------------------
    PERFORM mengeneinheiten_lesen TABLES t_matnr.
    READ TABLE t_meeinh WITH KEY matnr = t_matnr-matnr
                                 meinh = t_matnr-basme BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MEEINH'.
*----Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabel
    ENDIF.
    umren_alt = t_meeinh-umren.
    umrez_alt = t_meeinh-umrez.
    PERFORM umrechnen_compmng.
*tga /46C correction  ->update values of variants. ->19991124 start
    IF t_matnr-attyp = attyp_sam.
      PERFORM var_umrechnen.
    ENDIF.
*tga /46C correction  ->update values of variants. ->19991124 end
  ENDIF.
*---add up sum of components for each article(variant)
  LOOP AT sbe.
*   READ TABLE cum_comp WITH KEY sbe-comp_matnr.
    READ TABLE cum_comp WITH KEY comp_matnr = sbe-comp_matnr.
* 19991130 TGA erw syntaxprüfung
    IF sy-subrc EQ 0.
      cum_comp-labst = cum_comp-labst + sbe-labst.
      MODIFY TABLE cum_comp.
    ELSE.
      MOVE sbe-comp_matnr TO cum_comp-comp_matnr.
      MOVE sbe-labst TO cum_comp-labst.
      APPEND cum_comp.
    ENDIF.
  ENDLOOP.
ENDFORM.                               " stocks_of_components

*&---------------------------------------------------------------------*
*&      Form  count_stocks
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM count_stocks TABLES p_ht_matnr STRUCTURE t_matnr
                         p_h_wbe STRUCTURE wbe
                         p_h_lbe STRUCTURE lbe
                         p_sbe   STRUCTURE sbe.

*--errechnen des werks_stock der Variante aus
*--werks-stock des struc-art X Komponenten menge im struc-art (KMPMG)
  LOOP AT  t_comp_struc.
    IF zeilen_kz = wrk_zeile.
      READ TABLE p_h_wbe WITH KEY matnr = t_comp_struc-matnr
                                  werks = zle-werks.
      IF sy-subrc EQ 0 AND NOT p_h_wbe-labst IS INITIAL.
* Internal message: 1734031 2009
      READ TABLE t_meeinh WITH KEY matnr = t_comp_struc-comp_matnr
                                   meinh = t_comp_struc-kmpme.
        p_sbe-comp_matnr = t_comp_struc-comp_matnr.
        p_sbe-stru_matnr = t_comp_struc-matnr.
*        p_sbe-labst      = p_h_wbe-labst * t_comp_struc-kmpmg. " Internal message: 1734031 2009
                p_sbe-labst = p_h_wbe-labst * t_comp_struc-kmpmg
                              * t_meeinh-umrez / t_meeinh-umren. " Internal message: 1734031 2009
        p_sbe-labst      = p_sbe-labst / 1000. "Festpunktarith. aus
        APPEND p_sbe.
      ENDIF.
    ELSEIF zeilen_kz = lag_zeile.
      READ TABLE p_h_lbe WITH KEY  matnr = t_comp_struc-matnr
                                   werks = zle-werks
                                   lgort = zle-lgort.
      IF sy-subrc = 0 AND NOT p_h_lbe-labst IS INITIAL.
* Internal message: 1734031 2009
      READ TABLE t_meeinh WITH KEY matnr = t_comp_struc-comp_matnr
                                   meinh = t_comp_struc-kmpme.
        p_sbe-comp_matnr = t_comp_struc-comp_matnr.
        p_sbe-stru_matnr = t_comp_struc-matnr.
*        p_sbe-labst      = p_h_lbe-labst * t_comp_struc-kmpmg. " Internal message: 1734031 2009
                p_sbe-labst = p_h_lbe-labst * t_comp_struc-kmpmg
                              * t_meeinh-umrez / t_meeinh-umren. " Internal message: 1734031 2009
        p_sbe-labst      = p_sbe-labst / 1000. "Festpunktarith. aus
        APPEND p_sbe.
      ENDIF.
    ENDIF.
    CLEAR: p_h_wbe.
  ENDLOOP.
ENDFORM.                               " count_stocks
*&---------------------------------------------------------------------*
*&      Form  show_comp_stock
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_comp_stock.
* SET titlebar 'COM'.
* SET PF-STATUS pfstatus_eman.

  CALL SCREEN 500 STARTING AT 40 04
                   ENDING   AT 101 27.

ENDFORM.                               " show_comp_stock

*&---------------------------------------------------------------------*
*&      Form  umrechnen_compmng
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM umrechnen_compmng.
*umren, umrez versorgen
  LOOP AT sbe.

    CATCH SYSTEM-EXCEPTIONS
       arithmetic_errors = 1
       OTHERS = 99.
      sbe-labst = sbe-labst * umren_neu * umrez_alt /
                             ( umrez_neu * umren_alt ).

    ENDCATCH.
    IF NOT sy-subrc IS INITIAL.
      max_stock_value_reached = x.
    ELSE.
      MODIFY sbe.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " umrechnen_compmng
*&---------------------------------------------------------------------*
*&      Form  fill_h_stocks
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_h_stocks TABLES h_wbe STRUCTURE wbe
                          h_lbe STRUCTURE lbe
                   USING sav_comp_struc_matnr TYPE matnr  "tga unicode
                          sav_comp_struc_ne_basme TYPE c. "tga unicode
  DATA:  h_umrez_neu   LIKE sy-tabix,
         h_umren_neu   LIKE sy-tabix,
         h_umrez_alt   LIKE sy-tabix,
         h_umren_alt   LIKE sy-tabix.
  DATA:  sav_t_meeinh LIKE t_meeinh OCCURS 0 WITH HEADER LINE,
         sav_t_metext LIKE t_metext OCCURS 0 WITH HEADER LINE.
  CASE zeilen_kz.
    WHEN wrk_zeile.
      READ TABLE wbe WITH KEY matnr =  sav_comp_struc_matnr
                              werks = zle-werks.
      MOVE-CORRESPONDING wbe TO h_wbe.
      APPEND h_wbe.
      IF  sav_comp_struc_ne_basme = 'X'.
*-----save t_meeinh, t_metext of article, for which search is started
        sav_t_meeinh[] = t_meeinh[].
        sav_t_metext[] = t_metext[].
        READ TABLE t_matnr WITH KEY matnr = sav_comp_struc_matnr.
        h_umren_alt = t_matnr-umren_alt.
        h_umrez_alt = t_matnr-umrez_alt.
        PERFORM mengeneinheiten_lesen TABLES t_matnr.
        READ TABLE t_meeinh WITH KEY  matnr = sav_comp_struc_matnr
                                      meinh = t_matnr-basme.
        h_umrez_neu = t_meeinh-umrez.
        h_umren_neu = t_meeinh-umren.
        PERFORM pre_umrechnen TABLES h_wbe h_lbe
                              USING  h_umrez_neu  h_umren_neu
                                     h_umrez_alt  h_umren_alt.
        t_meeinh[] =  sav_t_meeinh[].
        t_metext[] =  sav_t_metext[].
      ENDIF.
    WHEN lag_zeile.
      READ TABLE lbe WITH KEY matnr =  sav_comp_struc_matnr
                              werks = zle-werks
                              lgort = zle-lgort.
      MOVE-CORRESPONDING lbe TO h_lbe.
      APPEND h_lbe.
      IF  sav_comp_struc_ne_basme = 'X'.
        sav_t_meeinh[] = t_meeinh[].
        sav_t_metext[] = t_metext[].
        READ TABLE t_matnr WITH KEY matnr = sav_comp_struc_matnr.
        h_umren_alt = t_matnr-umren_alt.
        h_umrez_alt = t_matnr-umrez_alt.
        PERFORM mengeneinheiten_lesen TABLES t_matnr.
        READ TABLE t_meeinh WITH KEY  matnr = sav_comp_struc_matnr
                                      meinh = t_matnr-basme.
        h_umrez_neu = t_meeinh-umrez.
        h_umren_neu = t_meeinh-umren.
        PERFORM pre_umrechnen TABLES h_wbe h_lbe
                              USING  h_umrez_neu  h_umren_neu
                                     h_umrez_alt  h_umren_alt.
        t_meeinh[] =  sav_t_meeinh[].
        t_metext[] =  sav_t_metext[].
      ENDIF.
  ENDCASE.

ENDFORM.                               " fill_h_stocks
*&---------------------------------------------------------------------*
*&      Form  pre_umrechnen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_H_WBE  text
*      -->P_H_UMREZ_NEU  text
*      -->P_H_UMREN_NEU  text
*      -->P_H_UMREN_ALT  text
*      -->P_H_UMREN_ALT  text
*----------------------------------------------------------------------*
FORM pre_umrechnen TABLES   p_wbe STRUCTURE  wbe
                            p_lbe STRUCTURE  lbe
                   USING    p_h_umrez_neu LIKE sy-tabix
                            p_h_umren_neu LIKE sy-tabix
                            p_h_umrez_alt LIKE sy-tabix
                            p_h_umren_alt LIKE sy-tabix.
  CASE zeilen_kz.
    WHEN wrk_zeile.
      LOOP AT p_wbe.
        p_wbe-labst = p_wbe-labst * p_h_umren_neu * p_h_umrez_alt /
                               ( p_h_umrez_neu * p_h_umren_alt ).
        MODIFY p_wbe.
      ENDLOOP.
    WHEN lag_zeile.
      LOOP AT p_lbe.
        p_lbe-labst = p_lbe-labst * p_h_umren_neu * p_h_umrez_alt /
                               ( p_h_umrez_neu * p_h_umren_alt ).
        MODIFY p_lbe.
      ENDLOOP.
  ENDCASE.

ENDFORM.                               " pre_umrechnen
*&---------------------------------------------------------------------*
*&      Form  equi_anzeigen
*&---------------------------------------------------------------------*
FORM equi_anzeigen.
  RANGES: equi_lgort FOR mard-lgort.
  RANGES: equi_sond  FOR eqbs-sobkz.

  IF  zeilen_kz EQ wrk_zeile OR
      zeilen_kz EQ lag_zeile OR
      zeilen_kz EQ ch_zeile.

    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    IF t_matnr-attyp NE attyp_sam AND     "generic article
       t_matnr-attyp NE '10' AND          "set
       t_matnr-attyp NE '11' AND          "prepack
       t_matnr-attyp NE '12'.             "display
      IF zeilen_kz EQ wrk_zeile.
        IF sond_kz = space.
          SUBMIT riequi21
            WITH matnr EQ zle-matnr
            WITH werk  EQ zle-werks
            AND RETURN.
        ELSE.
          REFRESH equi_lgort.
          equi_lgort-low    = space.
          equi_lgort-high   = space.
          equi_lgort-sign   = 'I'.
          equi_lgort-option = 'EQ'.
          APPEND  equi_lgort.
          REFRESH equi_sond.
          equi_sond-sign   = 'I'.
          equi_sond-option = 'EQ'.
          equi_sond-low     = sond_kz.
          APPEND  equi_sond.
          SUBMIT riequi21
            WITH matnr EQ zle-matnr
            WITH werk  EQ zle-werks
            WITH lager IN equi_lgort
            WITH sobkz IN equi_sond
            AND RETURN.
        ENDIF.
      ELSEIF zeilen_kz EQ lag_zeile.
        IF sond_kz NE space.
          REFRESH equi_sond.
          equi_sond-sign   = 'I'.
          equi_sond-option = 'EQ'.
          equi_sond-low     = sond_kz.
          APPEND  equi_sond.
          SUBMIT riequi21
              WITH matnr EQ zle-matnr
              WITH werk  EQ zle-werks
              WITH lager EQ zle-lgort
              WITH sobkz IN equi_sond
              AND RETURN.
        ELSE.
          SUBMIT riequi21
              WITH matnr EQ zle-matnr
              WITH werk  EQ zle-werks
              WITH lager EQ zle-lgort
              AND RETURN.
        ENDIF.
      ELSEIF zeilen_kz EQ ch_zeile .
        IF sond_kz NE space.
          REFRESH equi_sond.
          equi_sond-sign   = 'I'.
          equi_sond-option = 'EQ'.
          equi_sond-low     = sond_kz.
          APPEND  equi_sond.
          SUBMIT riequi21
              WITH matnr EQ zle-matnr
              WITH werk  EQ zle-werks
              WITH lager EQ zle-lgort
              WITH b_charge EQ zle-charg
              WITH charge EQ zle-charg
              WITH sobkz IN equi_sond
              AND RETURN.
        ELSE.
          SUBMIT riequi21
              WITH matnr  EQ zle-matnr
              WITH werk   EQ zle-werks
              WITH lager  EQ zle-lgort
              WITH b_charge EQ zle-charg
              WITH charge EQ zle-charg
              AND RETURN.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE i103.
* Diese Funktion ist nicht für Sammel- bzw. strukturierte Artikel aufrufbar
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  handling_unit
*&---------------------------------------------------------------------*
FORM handling_unit.
  DATA: ct_seloptions TYPE  rsparams OCCURS 0,
        cs_seloptions TYPE  rsparams,
        list_modus    TYPE  huli_modus.

  DATA: lf_mem_id LIKE indx-srtfd VALUE 'RHUHELP',
        lf_okflag, lhier, nodis TYPE i.

  RANGES: selvpobj FOR vekp-vpobj,
          selpackv FOR vekp-packvorschr,
          selobkey FOR vekp-vpobjkey.

  EXPORT                                                "initialization
    selopts FROM ct_seloptions
    lhier
    selpackv
    selvpobj
    nodis
    lf_okflag
    selobkey
  TO MEMORY ID lf_mem_id.

  lf_okflag = 'X'.
  lhier = 'X'.

  IF  zeilen_kz EQ wrk_zeile OR
      zeilen_kz EQ lag_zeile OR
      zeilen_kz EQ ch_zeile.

    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    IF t_matnr-attyp NE attyp_sam AND     "generic article
       t_matnr-attyp NE '10' AND          "set
       t_matnr-attyp NE '11' AND          "prepack
       t_matnr-attyp NE '12'.             "display

*   Materialnummer
      cs_seloptions-selname   = 'SELMATNR'.
      cs_seloptions-kind   = 'S'.
      cs_seloptions-sign   = 'I'.
      cs_seloptions-option = 'EQ'.
      cs_seloptions-low    = zle-matnr.
      APPEND cs_seloptions TO ct_seloptions.

*   Werk
      IF NOT zle-werks IS INITIAL.
        cs_seloptions-selname   = 'SELWERK'.
        cs_seloptions-kind   = 'S'.
        cs_seloptions-sign   = 'I'.
        cs_seloptions-option = 'EQ'.
        cs_seloptions-low    = zle-werks.
        APPEND cs_seloptions TO ct_seloptions.
      ENDIF.

*   Lagerort
      IF NOT zle-lgort IS INITIAL AND
         ( zeilen_kz EQ lag_zeile OR
           zeilen_kz EQ ch_zeile ).
        cs_seloptions-selname   = 'SELLGORT'.
        cs_seloptions-kind   = 'S'.
        cs_seloptions-sign   = 'I'.
        cs_seloptions-option = 'EQ'.
        cs_seloptions-low    = zle-lgort.
        APPEND cs_seloptions TO ct_seloptions.
      ENDIF.

*   Charge
      IF NOT zle-charg IS INITIAL AND
         zeilen_kz EQ ch_zeile.
        cs_seloptions-selname   = 'SELCHARG'.
        cs_seloptions-kind   = 'S'.
        cs_seloptions-sign   = 'I'.
        cs_seloptions-option = 'EQ'.
        cs_seloptions-low    = zle-charg.
        APPEND cs_seloptions TO ct_seloptions.
      ENDIF.

*   show Top HUs
      CLEAR cs_seloptions.
      cs_seloptions-selname   = 'LHIER'.
      cs_seloptions-kind   = 'P'.
      cs_seloptions-low    = 'X'.
      APPEND cs_seloptions TO ct_seloptions.

*   select only GR-posted HUs
      CLEAR cs_seloptions.
      cs_seloptions-selname   = 'SELSSTAT'.
      cs_seloptions-kind   = 'S'.
      cs_seloptions-sign   = 'I'.
      cs_seloptions-option = 'EQ'.
      cs_seloptions-low    = 'LGER'.
      APPEND cs_seloptions TO ct_seloptions.

      list_modus-mod_histry = 'X'.
      EXPORT
        selopts FROM ct_seloptions
        lhier
        selpackv
        selvpobj
        nodis
        lf_okflag
        selobkey
      TO MEMORY ID lf_mem_id.

      CALL FUNCTION 'HUMO_HU_MONITOR_SHOW'
        EXPORTING
          show_selscreen   = space
          list_modus       = list_modus
        TABLES
          ct_seloptions    = ct_seloptions
        EXCEPTIONS
          no_entries_found = 1
          exit_desired     = 2
          OTHERS           = 3.
*   sy-subrc = 2 can only come with show_selscreen = 'X'
      CASE sy-subrc.
        WHEN 1 OR 3.
          CLEAR ok_code.
          MESSAGE e103(vhu01).
        WHEN 2.
      ENDCASE.
    ELSE.
      MESSAGE i103.
* Diese Funktion ist nicht für Sammel- bzw. strukturierte Artikel aufrufbar
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  fertauftraege
*&---------------------------------------------------------------------*
FORM fertauftraege.
  IF  zeilen_kz EQ wrk_zeile OR
      zeilen_kz EQ lag_zeile OR
      zeilen_kz EQ ch_zeile.
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    IF t_matnr-attyp NE attyp_sam AND     "generic article
       t_matnr-attyp NE '10' AND          "set
       t_matnr-attyp NE '11' AND          "prepack
       t_matnr-attyp NE '12'.             "display
      SUBMIT ppio_entry USING SELECTION-SET 'SAP&COOIS'
        WITH s_matnr EQ zle-matnr
        WITH s_pwerk EQ zle-werks
        AND RETURN.
    ELSE.
      MESSAGE i103.
* Diese Funktion ist nicht für Sammel- bzw. strukturierte Artikel aufrufbar
    ENDIF.
  ELSE.
    MESSAGE i068.
*   Wählen Sie eine Bestandszeile ab der Ebene Werk abwärts aus
  ENDIF.
ENDFORM.
