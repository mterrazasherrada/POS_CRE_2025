*-------------------------------------------------------------------
***INCLUDE RWBE1F05 .
*  Verschieben der Spalten in der Grund- und Aufrißliste
*  (analog RMMMBEFL)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  E00_LISTE_RECHTS
*&---------------------------------------------------------------------*
*       Verschieben der Liste nach rechts, d.h. ausgeben der Bestands- *
*       daten des vorherigen Fensters -> Funktion 'Linke Spalten'      *
*----------------------------------------------------------------------*
FORM E00_LISTE_RECHTS.

  IF RMMMB-FENNR > START_FENNR.
    RMMMB-FENNR = RMMMB-FENNR - 1.

* JH/21.01.97/1.2B KPr1018362 (Anfang)
*---- Neue Fensternr. zwischenspeichern, weil durch die nachfolgenden -*
*---- READ LINE... die Variable RMMMB-FENNR mit dem alten Wert aus    -*
*---- HIDE-Bereich überschrieben wird                                 -*
*   SAVE_FENNR  = RMMMB-FENNR.
*   PERFORM INITIALISIERUNG.
*   PERFORM LISTE_SCHIEBEN.
    PERFORM LISTE_VERSCHIEBEN.
* JH/21.01.97/1.2B KPr1018362 (Ende)
  ELSE.
    MESSAGE S039.
  ENDIF.

ENDFORM.                    " E00_LISTE_RECHTS

*&---------------------------------------------------------------------*
*&      Form  E00_LISTE_LINKS
*&---------------------------------------------------------------------*
*       Verschieben der Liste nach links, d.h. ausgeben der Bestands-  *
*       daten zum nächsten Fenster -> Funktion 'Rechte Spalten'        *
*----------------------------------------------------------------------*
FORM E00_LISTE_LINKS.

  GRUND_ANZEIGE-FENNR = RMMMB-FENNR + 1.
  LOOP AT GRUND_ANZEIGE WHERE FENNR = GRUND_ANZEIGE-FENNR.
*---- Fenster ist vorhanden -------------------------------------------*
    RMMMB-FENNR = RMMMB-FENNR + 1.
* JH/21.01.97/1.2B KPr1018362 (Anfang)
*---- Neue Fensternr. zwischenspeichern, weil durch die nachfolgenden -*
*---- READ LINE... die Variable RMMMB-FENNR mit dem alten Wert aus    -*
*---- HIDE-Bereich überschrieben wird                                 -*
*   SAVE_FENNR  = RMMMB-FENNR.
*   PERFORM INITIALISIERUNG.
*   PERFORM LISTE_SCHIEBEN.
    PERFORM LISTE_VERSCHIEBEN.
* JH/21.01.97/1.2B KPr1018362 (Ende)
    EXIT.
  ENDLOOP.
  IF SY-SUBRC NE 0.
    MESSAGE S039.
  ENDIF.

ENDFORM.                    " E00_LISTE_LINKS

*&---------------------------------------------------------------------*
*&      Form  LISTE_SCHIEBEN
*&---------------------------------------------------------------------*
*       Modifizieren der Listzeilen im Loop. Es werden die Bestands-   *
*       felder des neuen Fensters ausgegeben. Die Überschriften werden *
*       entsprechend angepaßt                                          *
* JH/21.01.97/1.2B KPr1018362
* Coding wird nicht mehr benutzt, weil neuerdings beim Verschieben der
* Liste eine neue Liste erzeugt wird, damit F1-Hilfe für Bestandsfelder
* korrekt funktioniert
*----------------------------------------------------------------------*
FORM LISTE_SCHIEBEN.

  IZAEHL = 1.
  DO.
     CLEAR ZEILEN_KZ.
*---- Nachfolgendes READ LINE... überschreibt den neuen Wert in -------*
*---- RMMMB-FENNR mit altem Wert aus HIDE-Bereich -> SAVE_FENNR -------*
*---- enthält den alten Wert von RMMMB-FENNR -> zurückholen     -------*
     READ LINE IZAEHL.
     IF SY-SUBRC NE 0.
        EXIT.
     ENDIF.

     RMMMB-FENNR = SAVE_FENNR.

     CASE ZEILEN_KZ.
*---- Letze Zeile (Spacezeile - vorläufig wg. F1-Hilfe) ---------------*
          WHEN SPACE_ZEILE.
               MOVE: 'MBE-' TO SAV_FNAME1(4),
                     'MBE-' TO SAV_FNAME2(4),
                     'MBE-' TO SAV_FNAME3(4).
               PERFORM ZEILE_MODIFIZIEREN.    "Anzeigen aller Felder
               WRITE  SPACELINE TO SY-LISEL.  "Löschen der letzten Zeile
               MODIFY LINE IZAEHL.
*---- Summenzeile bei Artikelliste ------------------------------------*
          WHEN GES_ZEILE.
               MOVE: 'SMB-' TO SAV_FNAME1(4),
                     'SMB-' TO SAV_FNAME2(4),
                     'SMB-' TO SAV_FNAME3(4).
               PERFORM ZEILE_MODIFIZIEREN.
*---- Konzernzeile ----------------------------------------------------*
          WHEN MAN_ZEILE.
*---- Schieben in der Grundliste zu Artikellisten für Zeilen, die nur -*
*---- die Materialbezeichnung enthalen, unterdrücken                  -*
            IF BEZEI_KZ IS INITIAL.
              READ TABLE MBE WITH KEY MATNR = ZLE-MATNR BINARY SEARCH.
              IF SY-SUBRC NE 0.
                MESSAGE A038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
              ENDIF.

              MOVE: 'MBE-' TO SAV_FNAME1(4),
                    'MBE-' TO SAV_FNAME2(4),
                    'MBE-' TO SAV_FNAME3(4).
              PERFORM ZEILE_MODIFIZIEREN.
            ENDIF.
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Buchungskreiszeile ----------------------------------------------*
*         WHEN BUK_ZEILE.
*              LOOP AT  BBE   --> READ ... BINARY SEARCH ist besser
*                     WHERE MATNR = ZLE-MATNR
*                       AND BUKRS = ZLE-BUKRS.
*                MOVE: 'BBE-' TO SAV_FNAME1(4),
*                      'BBE-' TO SAV_FNAME2(4),
*                      'BBE-' TO SAV_FNAME3(4).
*                PERFORM ZEILE_MODIFIZIEREN.
*              ENDLOOP.
*#jhl 31.01.96 (Ende)
*---- Basiswerksgruppenzeile ------------------------------------------*
          WHEN WGR_ZEILE.
*---- Schieben in der Grund-/Aufrißliste für Werksgruppenzeilen, die --*
*---- nur die Werksgrupenbezeichnung enthalen, unterdrücken          --*
            IF BEZEI_KZ IS INITIAL.
              READ TABLE GBE WITH KEY MATNR = ZLE-MATNR
                                      BWGRP = ZLE-BWGRP  BINARY SEARCH.
              IF SY-SUBRC NE 0.
                MESSAGE A038 WITH 'GBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
              ENDIF.

              MOVE: 'GBE-' TO SAV_FNAME1(4),
                    'GBE-' TO SAV_FNAME2(4),
                    'GBE-' TO SAV_FNAME3(4).
              PERFORM ZEILE_MODIFIZIEREN.
            ENDIF.
*---- Werkszeile ------------------------------------------------------*
          WHEN WRK_ZEILE.
            IF NOT SY-LISEL IS INITIAL.
              CASE SOND_KZ.
                WHEN SPACE.
                  READ TABLE WBE WITH KEY MATNR = ZLE-MATNR
                                          WERKS = ZLE-WERKS
                                 BINARY SEARCH.
                  IF SY-SUBRC NE 0.
                    MESSAGE A038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
                  ENDIF.
                  MOVE: 'WBE-' TO SAV_FNAME1(4),
                        'WBE-' TO SAV_FNAME2(4),
                        'WBE-' TO SAV_FNAME3(4).
                  PERFORM ZEILE_MODIFIZIEREN.
                WHEN BEISTLIEF.
                  CLEAR SUM-LABST.
                  CLEAR SUM-INSME.
                  CLEAR SUM-SPEME.
                  CLEAR SUM-EINME.
                  LOOP AT  OBS
                        WHERE MATNR = ZLE-MATNR
                          AND WERKS = ZLE-WERKS .
                     SUM-LABST = SUM-LABST + OBS-LABST.
                     SUM-INSME = SUM-INSME + OBS-INSME.
                     SUM-EINME = SUM-EINME + OBS-EINME.
                     MOVE: 'SUM-' TO SAV_FNAME1(4),
                           'SUM-' TO SAV_FNAME2(4),
                           'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDLOOP.
*---- Verschieben evtl. auch für Nullbestandszeilen -------------------*
                  IF SY-SUBRC NE 0.
                    CLEAR OBS.
                    OBS-MATNR = ZLE-MATNR.
                    OBS-WERKS = ZLE-WERKS.
                    MOVE: 'SUM-' TO SAV_FNAME1(4),
                          'SUM-' TO SAV_FNAME2(4),
                          'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDIF.
                WHEN KONSIKUNDE.
                  CLEAR SUM-LABST.
                  CLEAR SUM-INSME.
                  CLEAR SUM-SPEME.
                  CLEAR SUM-EINME.
                  LOOP AT  WBS
                        WHERE MATNR = ZLE-MATNR
                          AND WERKS = ZLE-WERKS .
                     SUM-LABST = SUM-LABST + WBS-LABST.
                     SUM-INSME = SUM-INSME + WBS-INSME.
                     SUM-EINME = SUM-EINME + WBS-EINME.
                     MOVE: 'SUM-' TO SAV_FNAME1(4),
                           'SUM-' TO SAV_FNAME2(4),
                           'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDLOOP.
*---- Verschieben evtl. auch für Nullbestandszeilen -------------------*
                  IF SY-SUBRC NE 0.
                    CLEAR WBS.
                    WBS-MATNR = ZLE-MATNR.
                    WBS-WERKS = ZLE-WERKS.
                    MOVE: 'SUM-' TO SAV_FNAME1(4),
                          'SUM-' TO SAV_FNAME2(4),
                          'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDIF.
                WHEN LRGUTKUNDE.
                  CLEAR SUM-LABST.
                  CLEAR SUM-INSME.
                  CLEAR SUM-SPEME.
                  CLEAR SUM-EINME.
                  LOOP AT  VBS
                        WHERE MATNR = ZLE-MATNR
                          AND WERKS = ZLE-WERKS .
                     SUM-LABST = SUM-LABST + VBS-LABST.
                     SUM-INSME = SUM-INSME + VBS-INSME.
                     SUM-EINME = SUM-EINME + VBS-EINME.
                     MOVE: 'SUM-' TO SAV_FNAME1(4),
                           'SUM-' TO SAV_FNAME2(4),
                           'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDLOOP.
*---- Verschieben evtl. auch für Nullbestandszeilen -------------------*
                  IF SY-SUBRC NE 0.
                    CLEAR VBS.
                    VBS-MATNR = ZLE-MATNR.
                    VBS-WERKS = ZLE-WERKS.
                    MOVE: 'SUM-' TO SAV_FNAME1(4),
                          'SUM-' TO SAV_FNAME2(4),
                          'SUM-' TO SAV_FNAME3(4).
                    PERFORM ZEILE_MODIFIZIEREN.
                  ENDIF.
              ENDCASE.
            ENDIF.

*---- Lagerortzeile ---------------------------------------------------*
          WHEN LAG_ZEILE.
            IF ( NOT SY-LISEL IS INITIAL ).
             IF ( BEZEI_KZ IS INITIAL ) OR
                ( NOT SOND_KZ IS INITIAL ).
              READ TABLE LBE WITH KEY MATNR = ZLE-MATNR
                                      WERKS = ZLE-WERKS
                                      LGORT = ZLE-LGORT BINARY SEARCH.
              IF SY-SUBRC NE 0.
                MESSAGE A038 WITH 'LBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
              ENDIF.
              CASE SOND_KZ.
                WHEN SPACE.
                  MOVE: 'LBE-' TO SAV_FNAME1(4),
                        'LBE-' TO SAV_FNAME2(4),
                        'LBE-' TO SAV_FNAME3(4).
                  PERFORM ZEILE_MODIFIZIEREN.
                WHEN AUFBSKUNDE.
                  SUM-LABST = LBE-KALAB.
                  SUM-INSME = LBE-KAINS.
                  SUM-SPEME = LBE-KASPE.
                  SUM-EINME = LBE-KAEIN.
                  MOVE: 'SUM-' TO SAV_FNAME1(4),
                        'SUM-' TO SAV_FNAME2(4),
                        'SUM-' TO SAV_FNAME3(4).
                  PERFORM ZEILE_MODIFIZIEREN.
                WHEN KONSILIEF.
                  SUM-LABST = LBE-KLABS.
                  SUM-INSME = LBE-KINSM.
                  SUM-EINME = LBE-KEINM.
                  SUM-SPEME = LBE-KSPEM.
                  MOVE: 'SUM-' TO SAV_FNAME1(4),
                        'SUM-' TO SAV_FNAME2(4),
                        'SUM-' TO SAV_FNAME3(4).
                  PERFORM ZEILE_MODIFIZIEREN.
                WHEN MTVERPACK.
                  SUM-LABST = LBE-MLABS.
                  SUM-INSME = LBE-MINSM.
                  SUM-EINME = LBE-MEINM.
                  SUM-SPEME = LBE-MSPEM.
                  MOVE: 'SUM-' TO SAV_FNAME1(4),
                        'SUM-' TO SAV_FNAME2(4),
                        'SUM-' TO SAV_FNAME3(4).
                  PERFORM ZEILE_MODIFIZIEREN.
*               WHEN PRJBESTAND.
*                 LOOP AT  LBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT.
*                   SUM-LABST = LBE-PRLAB.
*                   SUM-INSME = LBE-PRINS.
*                   SUM-SPEME = LBE-PRSPE.
*                   SUM-EINME = LBE-PREIN.
*                   MOVE: 'SUM-' TO SAV_FNAME1(4),
*                         'SUM-' TO SAV_FNAME2(4),
*                         'SUM-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                 ENDLOOP.
              ENDCASE.
             ENDIF.
            ENDIF.
*-------- Chargenzeile  ------------------------------------------------
*entfällt WHEN CHA_ZEILE.
*????       IF NOT SY-LISEL IS INITIAL.
*             CASE sond_kz.
*               WHEN SPACE.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT
*                       AND   CHARG = ZLE-CHARG.
*                   MOVE: 'CBE-' TO SAV_FNAME1(4),
*                         'CBE-' TO SAV_FNAME2(4),
*                         'CBE-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN BEISTLIEF.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   CHARG = ZLE-CHARG
*                       AND   SOBKZ = BEISTLIEF.
*                  MOVE: 'CBE-' TO SAV_FNAME1(4),
*                        'CBE-' TO SAV_FNAME2(4),
*                        'CBE-' TO SAV_FNAME3(4).
*                  PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN AUFBSKUNDE.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT
*                       AND   CHARG = ZLE-CHARG.
*                   SUM-LABST = CBE-KALAB.
*                   SUM-INSME = CBE-KAINS.
*                   SUM-SPEME = CBE-KASPE.
*                   SUM-EINME = CBE-KAEIN.
*                   MOVE: 'SUM-' TO SAV_FNAME1(4),
*                         'SUM-' TO SAV_FNAME2(4),
*                         'SUM-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN KONSILIEF.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT
*                       AND   CHARG = ZLE-CHARG.
*                   SUM-LABST = CBE-KLABS.
*                   SUM-INSME = CBE-KINSM.
*                   SUM-EINME = CBE-KEINM.
*                   SUM-SPEME = CBE-KSPEM.
*                   MOVE: 'SUM-' TO SAV_FNAME1(4),
*                         'SUM-' TO SAV_FNAME2(4),
*                         'SUM-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN KONSIKUNDE.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   CHARG = ZLE-CHARG
*                       AND   SOBKZ = KONSIKUNDE.
*                  MOVE: 'CBE-' TO SAV_FNAME1(4),
*                        'CBE-' TO SAV_FNAME2(4),
*                        'CBE-' TO SAV_FNAME3(4).
*                  PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN LRGUTKUNDE.
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   CHARG = ZLE-CHARG
*                       AND   SOBKZ = LRGUTKUNDE.
*                  MOVE: 'CBE-' TO SAV_FNAME1(4),
*                        'CBE-' TO SAV_FNAME2(4),
*                        'CBE-' TO SAV_FNAME3(4).
*                  PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN PRJBESTAND.                          "neu zu 3.0
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT
*                       AND   CHARG = ZLE-CHARG.
*                   SUM-LABST = CBE-PRLAB.
*                   SUM-INSME = CBE-PRINS.
*                   SUM-SPEME = CBE-PRSPE.
*                   SUM-EINME = CBE-PREIN.
*                   MOVE: 'SUM-' TO SAV_FNAME1(4),
*                         'SUM-' TO SAV_FNAME2(4),
*                         'SUM-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*               WHEN MTVERPACK.                           "neu zu 3.0
*                LOOP AT  CBE
*                       WHERE WERKS = ZLE-WERKS
*                       AND   LGORT = ZLE-LGORT
*                       AND   CHARG = ZLE-CHARG.
*                   SUM-LABST = CBE-MLABS.
*                   SUM-INSME = CBE-MINSM.
*                   SUM-EINME = CBE-MEINM.
*                   SUM-SPEME = CBE-MSPEM.
*                   MOVE: 'SUM-' TO SAV_FNAME1(4),
*                         'SUM-' TO SAV_FNAME2(4),
*                         'SUM-' TO SAV_FNAME3(4).
*                   PERFORM ZEILE_MODIFIZIEREN.
*                ENDLOOP.
*             ENDCASE.
*           ENDIF.
*---- Überschriftenzeile ----------------------------------------------*
          WHEN UEB_ZEILE.
               PERFORM UEBERSCHRIFT_MODIFIZIEREN.
          WHEN STRICH_ZEILE.
               PERFORM STRICHZEILE_MODIFIZIEREN.
     ENDCASE.
     IZAEHL = IZAEHL + 1.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
     CLEAR: ZLE, ZEILEN_KZ, SOND_KZ, BEZEI_KZ, KZ_NSEL.
     CLEAR: KZ_KEIN_O, KZ_KEIN_V, KZ_KEIN_W.
  ENDDO.
* READ LINE 1 OF CURRENT PAGE."????notwendig wg. Überschrift (Listkopf)

ENDFORM.                    " LISTE_SCHIEBEN

*&---------------------------------------------------------------------*
*&      Form  ZEILE_MODIFIZIEREN
*&---------------------------------------------------------------------*
*       Modifizieren der einzelnen Listzeile                           *
* JH/21.01.97/1.2B KPr1018362
* Coding wird nicht mehr benutzt, weil neuerdings beim Verschieben der
* Liste eine neue Liste erzeugt wird, damit F1-Hilfe für Bestandsfelder
* korrekt funktioniert
*----------------------------------------------------------------------*
FORM ZEILE_MODIFIZIEREN.

  PERFORM ASSIGN_GRUNDLISTE.
  PERFORM UMSCHLUESSELN_ZEILE.

* Ermittelnd der Vorzeichen der Bestandswerte und der daraus
* resultierenden Hintergrundfarbe des Vorzeichens.
  CLEAR: VZ1, VZ2, VZ3.
  IF <D1> < 0. VZ1 = MINUS. ENDIF.
  IF <D2> < 0. VZ2 = MINUS. ENDIF.
  IF <D3> < 0. VZ3 = MINUS. ENDIF.

  WRITE: <D1>  TO SY-LISEL+26(17),  "unklar ist, warum hier nicht
         VZ1   TO SY-LISEL+42(1),
         <D2>  TO SY-LISEL+44(17),  "wie bei Überschrift positioniert
         VZ2   TO SY-LISEL+60(1),
         <D3>  TO SY-LISEL+62(17),  "werden muß
         VZ3   TO SY-LISEL+78(1).

*---- Fensternummer im HIDE-Bereich aktualisieren ---------------------*
  MODIFY LINE IZAEHL FIELD VALUE RMMMB-FENNR FROM RMMMB-FENNR.

  IF VZ1 = MINUS.
    MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_NEGATIVE.
  ELSE.
    IF ZEILEN_KZ = GES_ZEILE.
      MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_TOTAL
                                              INTENSIFIED.
    ELSE.
      IF ZEILEN_KZ = MAN_ZEILE.
        IF DRILLDOWN_LEVEL = ARTLIST_LEVEL.
          MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_TOTAL
                                                  INTENSIFIED.
        ENDIF.
      ELSE.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*       IF ZEILEN_KZ = BUK_ZEILE.
        IF ZEILEN_KZ = WGR_ZEILE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ1 COLOR COL_NORMAL
                                               INTENSIFIED OFF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  IF VZ2 = MINUS.
    MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_NEGATIVE.
  ELSE.
    IF ZEILEN_KZ = GES_ZEILE.
      MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_TOTAL
                                              INTENSIFIED.
    ELSE.
      IF ZEILEN_KZ = MAN_ZEILE.
        IF DRILLDOWN_LEVEL = ARTLIST_LEVEL.
          MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_TOTAL
                                                  INTENSIFIED.
        ENDIF.
      ELSE.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*       IF ZEILEN_KZ = BUK_ZEILE.
        IF ZEILEN_KZ = WGR_ZEILE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ2 COLOR COL_NORMAL
                                               INTENSIFIED OFF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  IF VZ3 = MINUS.
    MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_NEGATIVE.
  ELSE.
    IF ZEILEN_KZ = GES_ZEILE.
      MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_TOTAL
                                              INTENSIFIED.
    ELSE.
      IF ZEILEN_KZ = MAN_ZEILE.
        IF DRILLDOWN_LEVEL = ARTLIST_LEVEL.
          MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_TOTAL
                                                  INTENSIFIED.
        ENDIF.
      ELSE.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*       IF ZEILEN_KZ = BUK_ZEILE.
        IF ZEILEN_KZ = WGR_ZEILE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_TOTAL
                                              INTENSIFIED OFF.
        ELSE.
          MODIFY LINE IZAEHL FIELD FORMAT VZ3 COLOR COL_NORMAL
                                               INTENSIFIED OFF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " ZEILE_MODIFIZIEREN

*&---------------------------------------------------------------------*
*&      Form  UEBERSCHRIFT_MODIFIZIEREN
*&---------------------------------------------------------------------*
*       Ueberschrift modifizieren                                      *
* JH/21.01.97/1.2B KPr1018362
* Coding wird nicht mehr benutzt, weil neuerdings beim Verschieben der
* Liste eine neue Liste erzeugt wird, damit F1-Hilfe für Bestandsfelder
* korrekt funktioniert
*----------------------------------------------------------------------*
FORM UEBERSCHRIFT_MODIFIZIEREN.

  WRITE: SAV_TEXT1 TO SY-LISEL+26(17),   "Klartext Bestand 1
         SAV_TEXT2 TO SY-LISEL+44(17),   "Klartext Bestand 2
         SAV_TEXT3 TO SY-LISEL+62(17).   "Klartext Bestand 3
  MODIFY LINE IZAEHL.

ENDFORM.                    " UEBERSCHRIFT_MODIFIZIEREN
*&---------------------------------------------------------------------*
*&      Form  STRICHZEILE_MODIFIZIEREN
*&---------------------------------------------------------------------*
*       Strichzeile modifizieren                                       *
* JH/21.01.97/1.2B KPr1018362
* Coding wird nicht mehr benutzt, weil neuerdings beim Verschieben der
* Liste eine neue Liste erzeugt wird, damit F1-Hilfe für Bestandsfelder
* korrekt funktioniert
*----------------------------------------------------------------------*
FORM STRICHZEILE_MODIFIZIEREN.

  WRITE:     STRICH TO SY-LISEL+25(17).  "Unterstrich Bestand 1
  IF  SAV_TEXT2 IS INITIAL. "????letztes Fenster enthält nur 1 Spalte
*   WRITE:   LEER   TO SY-LISEL+43(17).  "Unterstrich Bestand 2 entfernt
  ELSE.
    WRITE:   STRICH TO SY-LISEL+43(17).  "Unterstrich Bestand 2
  ENDIF.
  IF SAV_TEXT3 IS INITIAL. "????letztes Fenster enthält nur 2 Spalten
*   WRITE: LEER   TO SY-LISEL+61(17).    "Unterstrich Bestand 3 entfernt
  ELSE.
    WRITE: STRICH TO SY-LISEL+61(17).    "Unterstrich Bestand 3
  ENDIF.
  MODIFY LINE IZAEHL.

ENDFORM.                    " STRICHZEILE_MODIFIZIEREN

*&---------------------------------------------------------------------*
*&      Form  E00_ERSTES_FENSTER
*&---------------------------------------------------------------------*
*       Anzeige der Bestandsspalten des ersten Anzeigefensters
*----------------------------------------------------------------------*
FORM E00_ERSTES_FENSTER.

  RMMMB-FENNR = 1.
* JH/21.01.97/1.2B KPr1018362 (Anfang)
*---- Neue Fensternr. zwischenspeichern, weil durch die nachfolgenden -*
*---- READ LINE... die Variable RMMMB-FENNR mit dem alten Wert aus    -*
*---- HIDE-Bereich überschrieben wird                                 -*
* SAVE_FENNR  = RMMMB-FENNR.
* PERFORM INITIALISIERUNG.
* PERFORM LISTE_SCHIEBEN.
  PERFORM LISTE_VERSCHIEBEN.
* JH/21.01.97/1.2B KPr1018362 (Ende)

ENDFORM.                    " E00_ERSTES_FENSTER

*&---------------------------------------------------------------------*
*&      Form  E00_LETZTES_FENSTER
*&---------------------------------------------------------------------*
*       Anzeige der Bestandsspalten des letzten Anzeigefensters
*----------------------------------------------------------------------*
FORM E00_LETZTES_FENSTER.

  RMMMB-FENNR = ENDE_FENNR.
* JH/21.01.97/1.2B KPr1018362 (Anfang)
*---- Neue Fensternr. zwischenspeichern, weil durch die nachfolgenden -*
*---- READ LINE... die Variable RMMMB-FENNR mit dem alten Wert aus    -*
*---- HIDE-Bereich überschrieben wird                                 -*
* SAVE_FENNR  = RMMMB-FENNR.
* PERFORM INITIALISIERUNG.
* PERFORM LISTE_SCHIEBEN.
  PERFORM LISTE_VERSCHIEBEN.
* JH/21.01.97/1.2B KPr1018362 (Ende)

ENDFORM.                    " E00_LETZTES_FENSTER

*&---------------------------------------------------------------------*
*&      Form  LISTE_VERSCHIEBEN
*&---------------------------------------------------------------------*
*       Ausgabe der Liste mit den neu anzuzeigenden Bestandsarten
*       bei Blätterfunktion (Links/Rechts)
*       JH/21.01.97/1.2B KPr1018362
*----------------------------------------------------------------------*
FORM LISTE_VERSCHIEBEN.

* Neue Fensternr. zwischenspeichern, weil durch die nachfolgenden
* READ LINE... die Variable RMMMB-FENNR mit dem alten Wert aus
* HIDE-Bereich überschrieben wird
  SAVE_FENNR  = RMMMB-FENNR.

* Aufsetzzeile bestimmen (erste Bestandszeile)
* Dies ist notwendig, denn wenn z.B. über 'F3' zu einer vorherigen
* Liststufe zurückgesprungen wird, sind die alten Aufsetzdaten weg
  IZAEHL = 1.
  DO.
     CLEAR ZEILEN_KZ.
     READ LINE IZAEHL.
     IF SY-SUBRC NE 0.
        EXIT.
     ENDIF.
     IF ( ZEILEN_KZ = MAN_ZEILE )
     OR ( ZEILEN_KZ = WGR_ZEILE )
     OR ( ZEILEN_KZ = WRK_ZEILE )
     OR ( ZEILEN_KZ = LAG_ZEILE ).
       EXIT. "Aufsetzzeile gefunden -> HIDE-Variablen enthalten
             "entsprechende Aufsetzwerte
     ENDIF.
     IZAEHL = IZAEHL + 1.
  ENDDO.

* Gerettete FENNR zurückholen
  RMMMB-FENNR = SAVE_FENNR.

* Unterscheidung, ob Verschieben in Grund- oder Aufrißliste erfolgt
  IF KZ_LIST = GRUND_LISTE.
     PERFORM E00_GRUND_LISTE.
  ELSE.
*   Unterscheidung bzgl. der Anzeigestufe beim Aufriß
    IF DRILLDOWN_LEVEL = ARTLIST_LEVEL.
      PERFORM VARIANTEN_AUFRISS.
    ELSE.
*     Umsetzen des Funktionscodes von 'PF07' bzw. 'PF08' auf 'PF10',
*     damit Anzeige von Werkssonderbeständen korrekt erfolgt
      SY-UCOMM = 'PF10'.
      PERFORM E00_NAECHSTE_EBENE.
    ENDIF.
  ENDIF.

* Neue Liste genauso positionieren wie die alte positioniert war
  SCROLL LIST INDEX SY-LSIND TO: PAGE   SY-CPAGE
                                 LINE   SY-STARO,
                                 COLUMN SY-STACO.

* Liststufe manuell zurücksetzen, damit neue Liste die alte Liste
* ersetzt
  SY-LSIND = SY-LSIND - 1.

ENDFORM.                    " LISTE_VERSCHIEBEN
