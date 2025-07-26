*-------------------------------------------------------------------
***INCLUDE RWBE1F03 .
*  Anzeige von Bestandsdaten in Grund- und Aufrißliste
*  (Verarbeitung analog RMMMBEFA)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  BESTAENDE_ANZEIGEN
*&---------------------------------------------------------------------*
*       Graphische Darstellung der Bestandsdaten in der Grundliste     *
*       für Einzelartikel oder für eine Liste von Artikeln             *
*----------------------------------------------------------------------*
FORM bestaende_anzeigen.
  DATA: sav_matnr LIKE mara-matnr.
  rmmmb-fennr = start_fennr.
*---- Felder lesen, die in der Grundliste zur Anzeige kommen sollen ---*
  PERFORM grundlisten_felder.

  IF start_dd_level = einzart_level.
*---- Einstieg über Einzelartikel -> T_MATNR versorgen ----------------*
*---- Falls ein einzelner Sammelartikel zur Anzeige kommen soll,   ----*
*---- enthält die Liste der selektierten Artikel T_MATNR neben dem ----*
*---- Sammelartikel auch die Varianten -> T_MATNR kann mehrere     ----*
*---- Einträge enthalten -> korrekten Eintrag ermitteln            ----*
    IF anz_mat_ges = 1.
*---- Fall 1) nur ein einziger normaler Artikel oder eine einzelne ----*
*----         Variante wurde selektiert                            ----*
      READ TABLE t_matnr INDEX 1.
    ELSE.
*---- Fall 2) Einzelner Sammelartikel wurde selektiert ----------------*
      READ TABLE t_matnr WITH KEY attyp = attyp_sam.
    ENDIF.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

*---- Mögliche Mengenheiten zum Einzelartikel ermitteln. Bei Sammel- --*
*---- artikeln auch die Mengeneinheiten zu den Varianten ermitteln.  --*
*GET RUN TIME FIELD RUN_TIME1. "????Zeit auf 0 setzen -> nur für Tests
*TGA/4.6 Erweiterungen Lot (START)
*   PERFORM MENGENEINHEITEN_LESEN.
    PERFORM mengeneinheiten_lesen TABLES t_matnr.
*TGA/4.6 Erweiterungen Lot (END)
*GET RUN TIME FIELD RUN_TIME2. "????Zeit auf 0 setzen -> nur für Tests

*---- Falls ein Programmneustart über die Funktion 'Neue Selektion' ---*
*---- stattgefunden hat kann es möglich sein, daß eine neue Mengen- ---*
*---- einheit eingegeben wurde, die auf Korrektheit geprüft werden  ---*
*---- muß                                                           ---*
    IF NOT p_meinh IS INITIAL.
      READ TABLE t_meeinh WITH KEY matnr = t_matnr-matnr
                                   meinh = p_meinh       BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE s057.
*    Die Anzeige erfolgt in der Basismengeneinheit
      ELSE.
*---- Prüfen ob P_MEINH eine AlternativME enthält ---------------------*
        IF p_meinh NE t_matnr-basme.
          meins_neu = p_meinh.
*---- Umrechnen der Mengenfelder --------------------------------------*
          PERFORM umrechnen USING t_matnr.
          IF NOT ( max_stock_value_reached IS INITIAL ).   "//KPr1142916
*---- Umrechnung hat zu einem Überlauf geführt -> Meldung ausgeben ----*
*---- und Bestandswerte wieder auf ursprüngliche ME zurückrechnen  ----*
            MESSAGE s109(mm).          "//KPr1142916
*    Umrechnung in d. ausgewählte Mengeneinheit würde zu einem Überlauf
            t_matnr-umrez_alt = umrez_neu.                 "//KPr1142916
            t_matnr-umren_alt = umren_neu.                 "//KPr1142916
            meins_neu = t_matnr-basme. "//KPr1142916
            PERFORM umrechnen USING t_matnr.               "//KPr1142916
          ENDIF.                       "//KPr1142916
*---- Neue Anzeigemengeneinheit und alten Umrechnungsfaktor ablegen ---*
          READ TABLE t_matnr WITH KEY matnr = t_matnr-matnr
                             BINARY SEARCH.     "Index für Eintrag lesen
          IF sy-subrc NE 0.
            MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
          ENDIF.
          t_matnr-meins     = meins_neu.
          t_matnr-umrez_alt = umrez_neu.
          t_matnr-umren_alt = umren_neu.
          MODIFY t_matnr INDEX sy-tabix.
        ENDIF.
      ENDIF.
    ENDIF.

*---- Falls kein Sammelartikel zur Anzeige kommt, sollte der Button ---*
*---- 'Variantenmatrix' inaktiviert werden                          ---*
    IF t_matnr-attyp <> attyp_sam.
      MOVE matx TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    ENDIF.
*TGA/4.6 Erweiterungen STRART (START)
    sav_matnr = t_matnr-matnr.
    PERFORM check_structured_article TABLES t_matnr.
    IF strart_exist = no.
      MOVE stru TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    ENDIF.
    READ TABLE t_matnr WITH KEY matnr = sav_matnr.
*TGA/4.6 Erweiterungen STRART (END)
  ENDIF.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering a correction
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0031 IF FOUND.
  ENDIF.
** end_EoP_adaptation

*---- Anzeige der Bestandsdaten in der Grundliste ---------------------*
  PERFORM e00_grund_liste.

ENDFORM.                               " BESTAENDE_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  MANDANT_ANZEIGEN
*&---------------------------------------------------------------------*
*       Konzernbestandsdaten anzeigen
*-----------------------------------------------------------------------
FORM mandant_anzeigen.

  MOVE: 'MBE-' TO sav_fname1(4),
        'MBE-' TO sav_fname2(4),
        'MBE-' TO sav_fname3(4),
        'MBE-' TO sav_fname0(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

  FORMAT COLOR COL_TOTAL INTENSIFIED.
  WRITE:  /   sy-vline NO-GAP,
              text-014,                "Klartext - Konzernsummen
          25   mbe-lvorm.              "Löschvormerkung Konzern
  PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
  zeilen_kz = man_zeile.
  zle-matnr = mbe-matnr.
  HIDE:  zeilen_kz,                    "Zeilenkennzeichen
         rmmmb-fennr,                  "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
         kz_list,                      "Aktuelle Liststufe
         zle-matnr.                    "Material
  ULINE.

ENDFORM.                               "MANDANT_ANZEIGEN

*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*&---------------------------------------------------------------------*
*&      Form  BUCHUNGSKREIS_ANZEIGEN
*&---------------------------------------------------------------------*
*      Buchungskreisbestandsdaten anzeigen
*-----------------------------------------------------------------------
*FORM BUCHUNGSKREIS_ANZEIGEN.
*
* CHECK RMMMB-KZBUK NE SPACE.
*
* SELECT SINGLE * FROM T001
*               WHERE BUKRS = BBE-BUKRS.
*
* IF SAV-BUKRS NE SPACE.
*    IF RMMMB-KZWER NE SPACE OR RMMMB-KZLGO NE SPACE OR
*       RMMMB-KZCHA NE SPACE OR RMMMB-KZSON NE SPACE.
*       NEW-PAGE.
*    ENDIF.
* ENDIF.
*
* MOVE: 'BBE-' TO SAV_FNAME1(4),
*       'BBE-' TO SAV_FNAME2(4),
*       'BBE-' TO SAV_FNAME3(4),
*       'BBE-' TO SAV_FNAME0(4).
* PERFORM ASSIGN_GRUNDLISTE.
* PERFORM UMSCHLUESSELN_ZEILE.
*
* FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
* WRITE:  / SY-VLINE,
*           02 BBE-BUKRS,             "Buchungskreis
*           T001-BUTXT(23).        "Buchungskreisbez. gekürzt
* PERFORM GRUND_ZEILE_WRITE.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
* ZEILEN_KZ = BUK_ZEILE.
* ZLE-MATNR = BBE-MATNR.
* ZLE-BUKRS = BBE-BUKRS.
* HIDE: ZEILEN_KZ,                      "Zeilenkennzeichen
*       RMMMB-FENNR,                   "Aktuelle Fensternummer
*       ZLE-MATNR,                      "Material
*       ZLE-BUKRS.                      "Buchungskreis
* ULINE.
*
* SAV-BUKRS = BBE-BUKRS.
*
*ENDFORM.                       "BUCHUNGSKREIS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  WERKSGRUPPE_ANZEIGEN
*&---------------------------------------------------------------------*
*       Basiswerksgruppenbestandsdaten anzeigen
*----------------------------------------------------------------------*
FORM werksgruppe_anzeigen.

  CHECK rmmmb-kzbwg NE space.

*---- Bezeichnung zur Basiswerksgruppe lesen --------------------------*
  READ TABLE t_bwgrp WITH KEY bwgrp = gbe-bwgrp BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_BWGRP'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

*#jhl 01.02.96 (Anfang) NEW-PAGE b. Wechsel d. Basiswrk.grp. unterdrück.
* IF SAV-BWGRP NE SPACE.
*    IF RMMMB-KZWER NE SPACE OR RMMMB-KZLGO NE SPACE OR
*       RMMMB-KZCHA NE SPACE OR RMMMB-KZSON NE SPACE.
*       NEW-PAGE.
*    ENDIF.
* ENDIF.
*#jhl 01.02.96 (Ende)

  MOVE: 'GBE-' TO sav_fname1(4),
        'GBE-' TO sav_fname2(4),
        'GBE-' TO sav_fname3(4),
        'GBE-' TO sav_fname0(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

  CASE anzeige_art_e.
    WHEN anz_art_bez.
      WRITE:  / sy-vline NO-GAP,
                t_bwgrp-bwgbz(24).     "Basiswerksgrp.bez. gekürzt
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = wgr_zeile.
      zle-matnr = gbe-matnr.
      zle-bwgrp = gbe-bwgrp.
      CLEAR bezei_kz.
      HIDE: zeilen_kz,                 "Zeilenkennzeichen
            rmmmb-fennr,               "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
            kz_list,                   "Aktuelle Liststufe
            zle-matnr,                 "Material
            zle-bwgrp,                 "Basiswerksgruppe
            bezei_kz.                  "Kz: Zeile enth. nur Bezeichnung
      ULINE.

    WHEN anz_art_nr.
      IF gbe-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
        WRITE:  / sy-vline NO-GAP,
                  t_bwgrp-bwgbz(24).   "Basiswerksgrp.bez. gekürzt
      ELSE.
        WRITE:  / sy-vline NO-GAP,
                  gbe-bwgrp.           "Basiswerksgruppe
      ENDIF.
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = wgr_zeile.
      zle-matnr = gbe-matnr.
      zle-bwgrp = gbe-bwgrp.
      CLEAR bezei_kz.
      HIDE: zeilen_kz,                 "Zeilenkennzeichen
            rmmmb-fennr,               "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
            kz_list,                   "Aktuelle Liststufe
            zle-matnr,                 "Material
            zle-bwgrp,                 "Basiswerksgruppe
            bezei_kz.                  "Kz: Zeile enth. nur Bezeichnung
      ULINE.

    WHEN anz_art_bun.
      IF gbe-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
        WRITE:  / sy-vline NO-GAP,
                  t_bwgrp-bwgbz(24).   "Basiswerksgrp.bez. gekürzt
      ELSE.
        WRITE:  / sy-vline NO-GAP,
                  gbe-bwgrp.           "Basiswerksgruppe
      ENDIF.
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = wgr_zeile.
      zle-matnr = gbe-matnr.
      zle-bwgrp = gbe-bwgrp.
      CLEAR bezei_kz.
      HIDE: zeilen_kz,                 "Zeilenkennzeichen
            rmmmb-fennr,               "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
            kz_list,                   "Aktuelle Liststufe
            zle-matnr,                 "Material
            zle-bwgrp,                 "Basiswerksgruppe
            bezei_kz.                  "Kz: Zeile enth. nur Bezeichnung
      IF gbe-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- keinen Text ausgeben bei zweizeiliger Darstellung            ----*
        WRITE:  / sy-vline,
                  space23.             "Basiswerksgrp.bez. gekürzt
      ELSE.
        WRITE: /  sy-vline,
                  t_bwgrp-bwgbz(22).   "Basiswerksgrp.bez. gekürzt
      ENDIF.
      WRITE: 26 sy-vline,
             27 space17,
             44 sy-vline,
             45 space17,
             62 sy-vline,
             63 space17,
             80 sy-vline.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = wgr_zeile.
      zle-matnr = gbe-matnr.
      zle-bwgrp = gbe-bwgrp.
      bezei_kz = x.
      HIDE: zeilen_kz,                 "Zeilenkennzeichen
            rmmmb-fennr,               "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
            kz_list,                   "Aktuelle Liststufe
            zle-matnr,                 "Material
            zle-bwgrp,                 "Basiswerksgruppe
            bezei_kz.                  "Kz: Zeile enth. nur Bezeichnung
      CLEAR bezei_kz.
      ULINE.
  ENDCASE.

*#jhl 01.02.96 NEW-PAGE b. Wechsel d. Basiswrk.grp. unterdrücken
* SAV-BWGRP = GBE-BWGRP.

ENDFORM.                               " WERKSGRUPPE_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  WERK_ANZEIGEN
*&---------------------------------------------------------------------*
*       Werksbestandsdaten anzeigen
*-----------------------------------------------------------------------
FORM werk_anzeigen.

  CHECK rmmmb-kzwer NE space.

  MOVE 'WBE-' TO sav_fname0(4).
  PERFORM nullbestand_pruefen.

*//JH 20.09.96 (Anfang) KPr 1209775
* Auch die Ebene Lagerort checken, weil sich evtl. beim Aufsummiern von
* neg. und pos. Lagerortmengen ein Nullbestandswert auf Werksebene
* ergeben könnte und damit die Werks- und Lagerortebene nicht angezeigt
* werden würden
  IF nullcheck IS INITIAL.
    MOVE 'LBE-' TO sav_fname0(4).
    LOOP AT lbe WHERE matnr = wbe-matnr
                  AND werks = wbe-werks.
      PERFORM nullbestand_pruefen.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.
*//JH 20.09.96 (Ende) KPr 1209775

  IF nullcheck IS INITIAL.
*---- Prüfen, ob Sonderbestände vorhanden sind, die nicht zum Werk ----*
*---- anzuzeigen sind, sondern auf Lagerortebene                   ----*
    PERFORM nullbestand_sond_wrk_lgo.
  ENDIF.

*---- Prüfen, ob Sonderbestände vorhanden sind, die zum Werk anzu- ----*
*---- zeigen sind                                                  ----*
  CLEAR: kz_kein_w, kz_kein_v, kz_kein_o.
  PERFORM nullbestand_sond_wrk.

  CHECK nullcheck NE 0.

  kz_werk = x.
  CLEAR sond_kz.

  MOVE: 'WBE-' TO sav_fname1(4),
        'WBE-' TO sav_fname2(4),
        'WBE-' TO sav_fname3(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

*  FORMAT COLOR COL_HEADING INTENSIFIED OFF.   "TGA/150699
  FORMAT COLOR COL_KEY INTENSIFIED.            "TGA/150699
  WRITE:  /  sy-vline,
             03 wbe-werks,             "Werk
                wbe-name1(16),         "Werksbezeichnung gekürzt.
             25 wbe-lvorm,             "Löschvormerkung Werk
             26 sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
  zeilen_kz = wrk_zeile.
  zle-matnr = wbe-matnr.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* ZLE-BUKRS = WBE-BUKRS.
  zle-bwgrp = wbe-bwgrp.
  zle-werks = wbe-werks.
  HIDE:          zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 zle-matnr,            "Zeilenmaterial
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                ZLE-BUKRS,             "Zeilenbuchungskreis
                 zle-bwgrp,            "Zeilenbasiswerksgruppe
                 zle-werks,            "Zeilenwerk
                 sond_kz,              "Sonderbestandskennzeichen
                 kz_kein_o,            "KZ keine L.Beist. vorhanden
                 kz_kein_w,            "KZ keine K.Konsi vorhanden
                 kz_kein_v.            "KZ keine K.Leergut vorhanden

ENDFORM.                               "WERK_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  LAGER_ANZEIGEN
*&---------------------------------------------------------------------*
*      Lagerortbestandsdaten anzeigen
*-----------------------------------------------------------------------
FORM lager_anzeigen.

  CHECK rmmmb-kzlgo NE space.

  MOVE 'LBE-' TO sav_fname0(4).
  PERFORM nullbestand_pruefen.

  IF nullcheck IS INITIAL.
*---- Prüfen, ob Sonderbestände vorhanden sind, die für den Lagerort --*
*---- anzuzeigen sind                                                --*
    PERFORM nullbestand_sond_lgo.
  ENDIF.

  CHECK nullcheck NE 0.

*---- Bestimmen der Lagerortbezeichnung -------------------------------
  t001l-lgobe = '?'.   " damit bei erfolglosem Lesen kein Zufallswert
                                       " angezeigt wird
  SELECT SINGLE * FROM t001l
                WHERE werks = lbe-werks
                AND   lgort = lbe-lgort.

  MOVE: 'LBE-' TO sav_fname1(4),
        'LBE-' TO sav_fname2(4),
        'LBE-' TO sav_fname3(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

  DETAIL.
*  FORMAT COLOR COL_HEADING INTENSIFIED OFF.     "TGA/150699
  FORMAT COLOR COL_KEY INTENSIFIED.               "TGA/150699
  WRITE:  / sy-vline,
            04 lbe-lgort,              "Lagerort
            t001l-lgobe(16),           "Lagerortbezeichnung (verkürzt)
            25 lbe-lvorm,              "Löschvormerkung Lagerort
            26 sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
  PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
  zeilen_kz = lag_zeile.
  zle-matnr = lbe-matnr.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* ZLE-BUKRS = WBE-BUKRS.
  zle-bwgrp = wbe-bwgrp.
  zle-werks = lbe-werks.
  zle-lgort = lbe-lgort.
  CLEAR sond_kz.
  HIDE:          zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 sond_kz,              "Sonderbestandsart
                 zle-matnr,            "Zeilenmaterial
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                ZLE-BUKRS,             "Zeilenbuchungskreis
                 zle-bwgrp,            "Zeilenbasiswerksgruppe
                 zle-werks,            "Zeilenwerk
                 zle-lgort,            "Zeilenlagerort
                 bezei_kz.             "Kz: Zeile enth. nur Bezeichnung

*---- Falls eine Lagerplatzbeschreibung vorhanden ist wird diese ------*
*---- auch ausgegeben                                            ------*
  IF NOT lbe-lgpbe IS INITIAL.
    zeilen_kz = lag_zeile.
    bezei_kz = x.
    FORMAT COLOR COL_HEADING INTENSIFIED OFF.
    WRITE:      /   sy-vline,
                    lbe-lgpbe UNDER t001l-lgobe,
                26  sy-vline.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:      27  space17,
                44  sy-vline,
                45  space17,
                62  sy-vline,
                63  space17,
                80  sy-vline.
    HIDE:        zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 sond_kz,              "Sonderbestandsart
                 zle-matnr,            "Zeilenmaterial
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                ZLE-BUKRS,             "Zeilenbuchungskreis
                 zle-bwgrp,            "Zeilenbasiswerksgruppe
                 zle-werks,            "Zeilenwerk
                 zle-lgort,            "Zeilenlagerort
                 bezei_kz.             "Kz: Zeile enth. nur Bezeichnung
    CLEAR bezei_kz.
  ENDIF.
ENDFORM.                               "LAGER_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  GRUND_ZEILE_WRITE
*&---------------------------------------------------------------------*
*       Ausgabe einer einzelnen Bestandszeile der Grund-/Aufrißliste
*----------------------------------------------------------------------*
FORM grund_zeile_write.

  WRITE   26   sy-vline.
  IF p_kzngc IS INITIAL.               "TGA/10.06.99/KZNGC
    WRITE 27(17) <d1>    .
  ELSE.                                "TGA/10.06.99/KZNGC
    WRITE 27(17) <d1>  UNIT t_matnr-meins  .  "TGA/10.06.99/KZNGC
  ENDIF.                               "TGA/10.06.99/KZNGC
  IF <d1> < 0.                         "Rot einfärben des Minus-Zeichens
    vz1 = minus.
    WRITE 43 vz1   COLOR COL_NEGATIVE.
  ENDIF.
  WRITE   44  sy-vline.
  IF p_kzngc IS INITIAL.               "TGA/10.06.99/KZNGC
    WRITE 45(17) <d2> .
  ELSE.                                "TGA/10.06.99/KZNGC
    WRITE 45(17) <d2>  UNIT t_matnr-meins.    "TGA/10.06.99/KZNGC
  ENDIF.                               "TGA/10.06.99/KZNGC
  IF <d2> < 0.                         "Rot einfärben des Minus-Zeichens
    vz2 = minus.
    WRITE 61 vz2   COLOR COL_NEGATIVE.
  ENDIF.
  WRITE   62  sy-vline.
  IF p_kzngc IS INITIAL.               "TGA/10.06.99/KZNGC
    WRITE 63(17) <d3> .
  ELSE.                                "TGA/10.06.99/KZNGC
    WRITE 63(17) <d3>  UNIT t_matnr-meins .   "TGA/10.06.99/KZNGC
  ENDIF.                               "TGA/10.06.99/KZNGC
  IF <d3> < 0.                         "Rot einfärben des Minus-Zeichens
    vz3 = minus.
    WRITE 79 vz3   COLOR COL_NEGATIVE.
  ENDIF.
  WRITE   80  sy-vline.

ENDFORM.                               " GRUND_ZEILE_WRITE

*&---------------------------------------------------------------------*
*&      Form  NULLBESTAND_PRUEFEN
*&---------------------------------------------------------------------*
*       Falls das Kennzeichen 'Keine Nullbestandszeilen' gesetzt ist,
*       wird für alle Grund-/Aufrißlistenfelder geprüft, ob für die
*       vorliegende Bestandsebene eine Nullbestandszeile vorliegt.
*-----------------------------------------------------------------------
FORM nullbestand_pruefen.

  nullcheck = 1.

  CHECK p_kznul NE space.

  CLEAR nullcheck.
* tga/46C start, material will not appear on artlist, if all of the
* grund_anzeige fields are zero and other stocks, which are only defined
* in the single list e.g special stocks have values <> 0
  IF drilldown_level = artlist_level.
   PERFORM EINZELANZEIGE_FELDER.
   LOOP AT einzel_anzeige.
     sav_fname0+4 = einzel_anzeige-bfnae.
     ASSIGN (sav_fname0)  TO <f0>.
     IF NOT <f0> IS INITIAL.
       nullcheck = '1'.                 "sonst Probl wg. neg.Best und
     ENDIF.                             "Überlauf
     IF nullcheck NE space.
      EXIT.
     ENDIF.
    ENDLOOP.
  ELSE.
* tga/46c end
  LOOP AT grund_anzeige.
    sav_fname0+4 = grund_anzeige-fname.
    ASSIGN (sav_fname0)  TO <f0>.
    IF NOT <f0> IS INITIAL.
*         NULLCHECK = NULLCHECK +  <F0> .
      nullcheck = '1'.                 "sonst Probl wg. neg.Best und
    ENDIF.                             "Überlauf
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.
  ENDIF.                                     "<<<tga/46C insert
ENDFORM.                               " NULLBESTAND_PRUEFEN

*&---------------------------------------------------------------------*
*&      Form  E00_GRUND_LISTE
*&---------------------------------------------------------------------*
*       Bestandsdaten in der Grundliste darstellen                     *
*----------------------------------------------------------------------*
FORM e00_grund_liste.

*---- Für die Anzeige der Grundliste immer mit Liststufe 0 beginnen ---*
  sy-lsind = 0.

  kz_list = grund_liste.
  CASE drilldown_level.
    WHEN artlist_level.
*---- CBI/WWW: Fürs Web ungeeignete FCodes deaktivieren
      IF NOT p_submit_info-www_active IS INITIAL.          " WWW
        APPEND LINES OF t_fcodes_www TO t_fcodes_l.        " WWW
      ENDIF.                           " WWW
      SET PF-STATUS pfstatus_grund_l EXCLUDING t_fcodes_l.
      SET TITLEBAR  'GRU' WITH text-025.
    WHEN einzart_level.
*---- CBI/WWW: Fürs Web ungeeignete FCodes deaktivieren
      IF NOT p_submit_info-www_active IS INITIAL.          " WWW
        APPEND LINES OF t_fcodes_www TO t_fcodes_e.        " WWW
      ENDIF.                           " WWW
      SET PF-STATUS pfstatus_grund_e EXCLUDING t_fcodes_e.
      SET TITLEBAR  'GRU' WITH text-026.
    WHEN einzvar_level.
*TGA/4.6 Erweiterungen STRART (START)
      PERFORM check_structured_article TABLES t_matnr.
      IF strart_exist = no.
        MOVE stru TO t_fcodes_e-fcode.
        APPEND t_fcodes_e.
      ENDIF.
*TGA/4.6 Erweiterungen STRART (END)
      SET PF-STATUS pfstatus_grund_v EXCLUDING t_fcodes_e.
      SET TITLEBAR  'GRU' WITH text-032.
  ENDCASE.

  rmmmb-kzbwg = p_kzbwg.
  rmmmb-kzwer = p_kzwer.
  rmmmb-kzlgo = p_kzlgo.
* RMMMB-KZCHA = KZCHA.  ????entfällt
  rmmmb-kzson = p_kzson.

  PERFORM e00_mandanten_liste.

* vorläufig zu Testzwecken (wg. F1-Hilfe):????notwendig
* ZEILEN_KZ = SPACE_ZEILE.
* MOVE: 'MBE-' TO SAV_FNAME1(4),
*       'MBE-' TO SAV_FNAME2(4),
*       'MBE-' TO SAV_FNAME3(4).
* PERFORM ASSIGN_GRUNDLISTE.
* PERFORM UMSCHLUESSELN_ZEILE.
* WRITE: /27   <D1>,                  "Bestand 1
*         44  SY-VLINE,
*         45   <D2>,                  "Bestand 2
*         62  SY-VLINE,
*         63   <D3>,                  "Bestand 3
*         80  SY-VLINE.
* HIDE ZEILEN_KZ.
* WRITE 1 SPACELINE.             "Löschen der soeben erzeugten Zeile
* CLEAR ZEILEN_KZ.

ENDFORM.                               " E00_GRUND_LISTE

*&---------------------------------------------------------------------*
*&      Form  E00_NAECHSTE_EBENE
*&---------------------------------------------------------------------*
*       Aufrißliste der nächsten Ebene.
*       Der Titel des Aufrißbildes wird in Abhängigkeit von der
*       gewählten Ebene gesetzt.
*----------------------------------------------------------------------*
FORM e00_naechste_ebene.

  CASE drilldown_level.
    WHEN einzart_level.
*---- CBI/WWW: Fürs Web ungeeignete FCodes deaktivieren
      IF NOT p_submit_info-www_active IS INITIAL.          " WWW
        APPEND LINES OF t_fcodes_www TO t_fcodes_e.        " WWW
      ENDIF.                           " WWW
      SET PF-STATUS pfstatus_naechst_e EXCLUDING t_fcodes_e.
      text_xxx = text-026.
    WHEN einzvar_level.
      SET PF-STATUS pfstatus_naechst_v.
      text_xxx = text-032.
  ENDCASE.

  CASE zeilen_kz.
    WHEN man_zeile.
      rmmmb-kzbwg = x.
      CLEAR rmmmb-kzwer.
      CLEAR rmmmb-kzlgo.
*????entf.  CLEAR RMMMB-KZCHA.
      CLEAR rmmmb-kzson.
      SET TITLEBAR 'NAE' WITH text-014 text_xxx.
      kz_list = man_zeile.
      PERFORM e00_mandanten_liste.
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*      WHEN BUK_ZEILE.
*           RMMMB-KZBUK = X.
*           RMMMB-KZWER = X.
*           CLEAR RMMMB-KZLGO.
*           CLEAR RMMMB-KZSON.
*           KZ_LIST = BUK_ZEILE.
*           SET TITLEBAR 'NAE' WITH TEXT-027???? TEXT_XXX.
*           PERFORM E00_BUCHUNGSKREIS_LISTE.
*#jhl 31.01.96 (Ende)
    WHEN wgr_zeile.
      rmmmb-kzbwg = x.
      rmmmb-kzwer = x.
      CLEAR rmmmb-kzlgo.
*????entf.  CLEAR RMMMB-KZCHA.
      CLEAR rmmmb-kzson.
      kz_list = wgr_zeile.
      SET TITLEBAR 'NAE' WITH text-027 text_xxx.
      PERFORM e00_werksgruppe_liste.
    WHEN wrk_zeile.
      IF sond_kz IS INITIAL.
        rmmmb-kzwer = x.
        rmmmb-kzlgo = x.
*????entf.  CLEAR RMMMB-KZCHA.
        CLEAR rmmmb-kzson.
        kz_list = wrk_zeile.
        SET TITLEBAR 'NAE' WITH text-028 text_xxx.
        PERFORM e00_werk_liste.
* Anmerkung: Da keine Chargen angezeigt werden, macht ein Aufriß für
* Sonderbestände auf Werksebene keinen Sinn mehr!
*        ELSE.
*           KZ_LIST = SOND_KZ.
*           RMMMB-KZSON = X.
**????entf. RMMMB-KZCHA = X.
*           READ TABLE WBE WITH KEY MATNR = ZLE-MATNR
*                                   WERKS = ZLE-WERKS   BINARY SEARCH.
*           IF SY-SUBRC NE 0.
*             MESSAGE A038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*           ENDIF.
*           PERFORM SONDERBESTAND_ANZEIGEN_WRK.
*           ULINE.
      ELSE.
        MESSAGE i045.
*    Für Sonderbestandszeilen ist ein Aufriß nicht möglich!
      ENDIF.
    WHEN lag_zeile.
      IF sond_kz IS INITIAL.
        rmmmb-kzlgo = x.
*????entf.  RMMMB-KZCHA = X.
        CLEAR rmmmb-kzson.
        kz_list = lag_zeile.
        SET TITLEBAR 'NAE' WITH text-029 text_xxx.
        PERFORM e00_lager_liste.
      ELSE.
        MESSAGE i045.
*    Für Sonderbestandszeilen ist ein Aufriß nicht möglich!
      ENDIF.
*????  WHEN CHA_ZEILE.
*entf.   IF sond_kz IS INITIAL.
*           RMMMB-KZSON = X.
*           KZ_LIST = CHA_ZEILE.
*           SET TITLEBAR  PFSTATUS_NAECHST WITH TEXT-015.
*           PERFORM E00_CHARGEN_LISTE.
*        ENDIF.
    WHEN OTHERS.
      MESSAGE i028.
*    Cursor bitte innerhalb einer Bestandszeile positionieren!
  ENDCASE.

ENDFORM.                               " E00_NAECHSTE_EBENE

*&---------------------------------------------------------------------*
*&      Form  E00_MANDANTEN_LISTE
*&---------------------------------------------------------------------*
*       Mandantenbestandsliste (für Grundliste und Aufriß Mandant)     *
*----------------------------------------------------------------------*
FORM e00_mandanten_liste.

*---- Auswahl der anzuzeigenden Artikel erfolgt abhängig von der ------*
*---- Drilldown-Stufe                                            ------*
  CLEAR: mbe.

  CASE drilldown_level.
    WHEN artlist_level.
      PERFORM initialisierung.
      PERFORM sum_mat_anzeigen.

    WHEN einzart_level.
*---- relevanter Artikel steht in T_MATNR-MATNR -----------------------*
*---- Mandantenbestände zum gefundenen Artikel holen ------------------*
      READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

      PERFORM initialisierung.
      PERFORM mgwls_anzeigen.

    WHEN varmatrix_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*
    WHEN einzvar_level.
*---- Relevanter Artikel steht in SEL_VARIANTE ------------------------*
*---- Mandantenbestände zur selektierten Variante holen ---------------*
      READ TABLE mbe WITH KEY matnr = sel_variante BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

      PERFORM initialisierung.
      PERFORM mgwls_anzeigen.

  ENDCASE.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " E00_MANDANTEN_LISTE

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*&---------------------------------------------------------------------*
*&      Form  E00_BUCHUNGSKREIS_LISTE
*&---------------------------------------------------------------------*
*       Buchungskreisbestandsliste (für Aufriß Buchungskreis)
*----------------------------------------------------------------------*
*FORM E00_BUCHUNGSKREIS_LISTE.
*
*---- Auswahl der anzuzeigenden Artikel erfolgt abhängig von der ------*
*---- Drilldown-Stufe                                            ------*
* CLEAR: BBE.
*
* PERFORM INITIALISIERUNG.
*
* IF ( DrillDOWN_LEVEL = EINZART_LEVEL )
* OR ( DrillDOWN_LEVEL = EINZVAR_LEVEL ).
*---- Buchungskreisbestände zum selektierten Artikel holen ------------*
*   LOOP AT BBE WHERE MATNR = ZLE-MATNR   ---> READ ... BINARY SEARCH
*                 AND BUKRS = ZLE-BUKRS.       reicht aus u. ist besser
*
*     PERFORM BUCHUNGSKREIS_ANZEIGEN.
*     CLEAR KZ_WERK.
*     PERFORM WLS_ANZEIGEN.
*     IF KZ_WERK = X.
*       ULINE.
*     ENDIF.
*   ENDLOOP.
* ENDIF.
*
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
* CLEAR: ZLE, ZEILEN_KZ, SOND_KZ, BEZEI_KZ, KZ_NSEL.
* CLEAR: KZ_KEIN_O, KZ_KEIN_V, KZ_KEIN_W.
*
*ENDFORM.                    " E00_BUCHUNGSKREIS_LISTE
*#jhl 31.01.96 (Ende)

*&---------------------------------------------------------------------*
*&      Form  E00_WERKSGRUPPE_LISTE
*&---------------------------------------------------------------------*
*       Basiswerksgruppenbestandsliste (für Aufriß Basiswerksgruppe)
*----------------------------------------------------------------------*
FORM e00_werksgruppe_liste.

*---- Auswahl der anzuzeigenden Artikel erfolgt abhängig von der ------*
*---- Drilldown-Stufe                                            ------*
  CLEAR: gbe.

  PERFORM initialisierung.

  IF ( drilldown_level = einzart_level )
  OR ( drilldown_level = einzvar_level ).
*---- Basiswerksgruppenbestände zum selektierten Artikel holen --------*
    READ TABLE gbe WITH KEY matnr = zle-matnr
                            bwgrp = zle-bwgrp  BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'GBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    PERFORM werksgruppe_anzeigen.
    CLEAR kz_werk.
    PERFORM wls_anzeigen.
    IF kz_werk = x.
      ULINE.
    ENDIF.
  ENDIF.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " E00_WERKSGRUPPE_LISTE

*&---------------------------------------------------------------------*
*&      Form  E00_WERK_LISTE
*&---------------------------------------------------------------------*
*       Werksbestandsliste (für Aufriß Werk)
*----------------------------------------------------------------------*
FORM e00_werk_liste.

*---- Auswahl der anzuzeigenden Artikel erfolgt abhängig von der ------*
*---- Drilldown-Stufe                                            ------*
  CLEAR: wbe.

  PERFORM initialisierung.

  IF ( drilldown_level = einzart_level )
  OR ( drilldown_level = einzvar_level ).
*---- Werksbestände zum selektierten Artikel holen --------------------*
    READ TABLE wbe WITH KEY matnr = zle-matnr
                            werks = zle-werks   BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    PERFORM werk_anzeigen.
    rmmmb-kzson = x.
    PERFORM sonderbestand_anzeigen_wrk.
    CLEAR rmmmb-kzson.
    PERFORM ls_anzeigen.
    ULINE.
  ENDIF.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " E00_WERK_LISTE

*&---------------------------------------------------------------------*
*&      Form  E00_LAGER_LISTE
*&---------------------------------------------------------------------*
*       Lagerortbestandsliste (für Aufriß Lagerort)
*----------------------------------------------------------------------*
FORM e00_lager_liste.

*---- Auswahl der anzuzeigenden Artikel erfolgt abhängig von der ------*
*---- Drilldown-Stufe                                            ------*
  CLEAR: lbe.

  PERFORM initialisierung.

  IF ( drilldown_level = einzart_level )
  OR ( drilldown_level = einzvar_level ).
*---- Lagerortbestände zum selektierten Artikel holen -----------------*
    READ TABLE lbe WITH KEY matnr = zle-matnr
                            werks = zle-werks
                            lgort = zle-lgort  BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'LBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    PERFORM lager_anzeigen.
    rmmmb-kzson = x.
    PERFORM sonderbestand_anzeigen_lgo.
    ULINE.
  ENDIF.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " E00_LAGER_LISTE

*&---------------------------------------------------------------------*
*&      Form  SUM_MAT_ANZEIGEN
*&---------------------------------------------------------------------*
*       Gesamtbestände pro Artikel und in Summe anzeigen.
*       Falls sich die Anzeigemengeneinheiten der angezeigten Artikel
*       unterscheiden, wird in der Summenzeile als Mengeneinheit '***'
*       angezeigt!
*----------------------------------------------------------------------*
FORM sum_mat_anzeigen.

  PERFORM summe_anzeigen.

*---- Nur normale Artikel, Sammelartikel und Varianten, zu denen ------*
*---- intern kein Sammelartikel ex., anzeigen                    ------*
  LOOP AT t_matnr.
    IF t_matnr-attyp NE attyp_var.
*---- Mandantenbestände zum gefundenen Artikel holen ------------------*
      READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.

      PERFORM material_anzeigen.
    ELSE.
*---- Test, ob zu der Variante ein Sammelartikel vorliegt -------------*
      READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr
                 BINARY SEARCH         "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc NE 0.
*---- Mandantenbestände zum gefundenen Artikel holen ------------------*
        READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
        IF sy-subrc NE 0.
          MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
        ENDIF.

        PERFORM material_anzeigen.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.                               " SUM_MAT_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  SUMME_ANZEIGEN
*&---------------------------------------------------------------------*
*       Summe über die Gesamtbestände aller Materialien der Liste
*       anzeigen
*----------------------------------------------------------------------*
FORM summe_anzeigen.

  CLEAR: smb, sum_meinh.

*---- Aus Performance-Gründen wird der Summenbestand nicht schon beim -*
*---- Lesen der Bestandsstammdaten aus der DB fortgeschrieben (so wie -*
*---- bei MBE, GBE, WBE und LBE), sondern bei Bedarf ermittelt        -*
*---- Außerdem kann sich die Anzeigemengeneinheit eines Materials     -*
*---- ändern, so daß das Aufsummieren sowieso neu erfolgen müßte.     -*
  LOOP AT mbe.
    IF mbe-satnr IS INITIAL.
      ADD-CORRESPONDING mbe TO smb.
      PERFORM check_gleiche_meinh.
    ELSE.
*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, darf keine Addition erfolgen                            ----*
      READ TABLE mbe WITH KEY matnr = mbe-satnr
                 BINARY SEARCH         "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc NE 0.
        ADD-CORRESPONDING mbe TO smb.
        PERFORM check_gleiche_meinh.
      ENDIF.
    ENDIF.
  ENDLOOP.

  MOVE: 'SMB-' TO sav_fname1(4),
        'SMB-' TO sav_fname2(4),
        'SMB-' TO sav_fname3(4),
        'SMB-' TO sav_fname0(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

  FORMAT COLOR COL_TOTAL INTENSIFIED.
  WRITE:  /   sy-vline NO-GAP,
          (20) text-034.               "Klartext - Summe Materalien
  IF keine_sum_meinh = x.
    WRITE 23 '***'.                  "Basismengeneinheit der Summezeile
  ELSE.
    WRITE 23 sum_meinh.              "Basismengeneinheit der Summezeile
*   T_MATNR-MEINS = SUM_MEINH.          " TGA/99.A/10.06.99 KZNGC
  ENDIF.

  PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
  zeilen_kz = ges_zeile.
  CLEAR zle-matnr.
  HIDE:  zeilen_kz,                    "Zeilenkennzeichen
         rmmmb-fennr,                  "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
         kz_list,                      "Aktuelle Liststufe
         zle-matnr.                    "Material
  ULINE.

ENDFORM.                               " SUMME_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  MATERIAL_ANZEIGEN
*&---------------------------------------------------------------------*
*       Gesamtbestände bei einer Liste von Materialen anzeigen
*----------------------------------------------------------------------*
FORM material_anzeigen.

  MOVE  'MBE-' TO sav_fname0(4).
  PERFORM nullbestand_pruefen.

  CHECK nullcheck NE 0.

  MOVE: 'MBE-' TO sav_fname1(4),
        'MBE-' TO sav_fname2(4),
        'MBE-' TO sav_fname3(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

  CASE anzeige_art_l.
    WHEN anz_art_bez.
      WRITE: /   sy-vline NO-GAP,
                 t_matnr-maktx(20),    "Materialbezeichn. (verkürzt)
             23  t_matnr-meins.        "Anzeigemengeneinheit
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:      zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 zle-matnr,            "Zeilenmaterial
                 bezei_kz.             "Kz: Zeile enth. nur Bezeichnung
      ULINE.
    WHEN anz_art_nr.
      WRITE:  /  sy-vline NO-GAP,
                 t_matnr-matnr,        "Materialnr.
             23  t_matnr-meins.        "Anzeigemengeneinheit
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Material
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      ULINE.
    WHEN anz_art_bun.
      WRITE:  /  sy-vline NO-GAP,
                 t_matnr-matnr,        "Materialnr.
             23  t_matnr-meins.        "Anzeigemengeneinheit
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Material
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      WRITE: /   sy-vline,
                 t_matnr-maktx(22),    "Materialbezeichn. (verkürzt)
             26  sy-vline.
      WRITE: 27  space17,
             44  sy-vline,
             45  space17,
             62  sy-vline,
             63  space17,
             80  sy-vline.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      bezei_kz = x.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Zeilenmaterial
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      CLEAR bezei_kz.
      ULINE.
  ENDCASE.

ENDFORM.                               " MATERIAL_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  AUFRISS_ARTLISTE
*&---------------------------------------------------------------------*
*       Für den auf der Grundliste zur Artikelliste ausgewählten Art.
*       wird die Grundliste zum Einzelartikel dargestellt
*----------------------------------------------------------------------*
FORM aufriss_artliste.
  DATA: sav_index LIKE sy-tabix.
*---- Cursorposition -> matnr ermitteln für zeilen_kz = man_zeile
  IF zeilen_kz NE man_zeile.
    MESSAGE i034.
*    Cursor bitte innerhalb einer Bestandszeile zum Material positionier
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
    EXIT.
  ENDIF.

*---- Artikeldaten zum selektierten Artikel lesen ---------------------*
  READ TABLE t_matnr WITH KEY matnr = zle-matnr.
  sav_index = sy-tabix.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  IF t_matnr-attyp = attyp_sam.
*---- Bei Sammelartikeln müssen evtl. noch Merkmalsdaten nachgelesen --*
*---- werden:                                                        --*
*---- Entweder wurden noch keine Merkmale gelesen, dann müssen alle  --*
*---- variantenbildenden Merkmale zum Sammelartikel gelesen werden.  --*
*---- Erfolgte der Einstieg über eine Warengruppe mit Einschränkung  --*
*---- bzgl. der Merkmalswerte und sind weitere variantenbildende     --*
*---- Merkmale auf einer tieferliegenden Ebene definiert, so müssen  --*
*---- die fehlenden Merkmale nachgelesen werden                      --*
    PERFORM merkmale_nachlesen.
*----
  ENDIF.

*---- Mögliche Mengenheiten zum Einzelartikel ermitteln. Bei Sammel- --*
*---- artikeln auch die Mengeneinheiten zu den Varianten ermitteln.  --*
*GET RUN TIME FIELD RUN_TIME1. "????Zeit auf 0 setzen -> nur für Tests
*TGA/4.6 Erweiterungen STRART (START)
* PERFORM MENGENEINHEITEN_LESEN
  PERFORM mengeneinheiten_lesen TABLES t_matnr.
*TGA/4.6 Erweiterungen STRART (END)
*GET RUN TIME FIELD RUN_TIME2. "????Zeit auf 0 setzen -> nur für Tests

*TGA/4.6 Erweiterungen STRAART (START)
*---- find out if article is used in structured articles
  PERFORM check_structured_article TABLES t_matnr.
  IF strart_exist = no.
    MOVE stru TO t_fcodes_e-fcode.
    APPEND t_fcodes_e.
  ELSE.
    DELETE t_fcodes_e WHERE  fcode = stru.
  ENDIF.
  READ TABLE t_matnr INDEX sav_index.
*TGA/4.6 Erweiterungen STRAART (END)
*---- Entscheiden, ob der Button 'Variantenmatrix' erscheinen darf ----*
*---- oder nicht                                                   ----*

  IF t_matnr-attyp <> attyp_sam.
*---- Bei Varianten und normalen Artikeln -> Button deaktivieren ------*
    READ TABLE t_fcodes_e WITH KEY fcode = matx.
    IF sy-subrc NE 0.
      MOVE matx TO t_fcodes_e-fcode.
      APPEND t_fcodes_e.
    ENDIF.
  ELSE.
*---- Bei Sammelartikel -> Button darf nicht deaktiviert werden -------*
    DELETE t_fcodes_e WHERE fcode = matx.
  ENDIF.

*---- Mandantenbestände zum gefundenen Artikel holen ------------------*
  READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  drilldown_level = einzart_level.

*---- Für die Anzeige der Grundliste immer mit Liststufe 0 beginnen ---*
  sy-lsind = 0.

  kz_list = grund_liste.
  CLEAR sy-ucomm.  "Damit Anzeige von Sonderbeständen funktioniert

  SET PF-STATUS pfstatus_grund_e EXCLUDING t_fcodes_e.
  SET TITLEBAR  'GRU' WITH text-026.
*#jhl 12.04.96 vorliegende Fensternr. soll erhalten bleiben
* RMMMB-FENNR = START_FENNR.
  rmmmb-kzbwg = p_kzbwg.
  rmmmb-kzwer = p_kzwer.
  rmmmb-kzlgo = p_kzlgo.
* RMMMB-KZCHA = KZCHA.  ????entfällt
  rmmmb-kzson = p_kzson.

  PERFORM initialisierung.
  PERFORM mgwls_anzeigen.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " AUFRISS_ARTLISTE

*&---------------------------------------------------------------------*
*&      Form  MGWLS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten zu 'M'andant, Basiswerks'G'ruppe, 'W'erk,
*       'L'agerort und 'S'onderbestand anzeigen
*----------------------------------------------------------------------*
FORM mgwls_anzeigen.

  PERFORM mandant_anzeigen.
  PERFORM gwls_anzeigen.


ENDFORM.                               " MGWLS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  GWLS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten zu Basiswerks'G'ruppe, 'W'erk, 'L'agerort und
*       'S'onderbestand anzeigen
*----------------------------------------------------------------------*
FORM gwls_anzeigen.

*---- Art der Darstellung der Bestandsdaten erfolgt abhängig von ------*
*---- der Drilldown-Stufe                                        ------*
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR: BBE.
  CLEAR: gbe.

  CASE drilldown_level.
    WHEN artlist_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzart_level.
*---- T_MATNR zeigt auf den anzuzeigenden Artikel ---------------------*
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Buchungskreis-Bestände zum gefundenen Artikel holen -------------*
*     LOOP AT BBE WHERE MATNR = T_MATNR-MATNR.
*       PERFORM BUCHUNGSKREIS_ANZEIGEN.
*       CLEAR KZ_WERK.
*       PERFORM WLCS_ANZEIGEN.
*       IF KZ_WERK = X.
*         ULINE.
*       ENDIF.
*     ENDLOOP.
*#jhl 31.01.96 (Ende)

*---- Basiswerksgruppen-Bestände zum gefundenen Artikel holen ---------*
      LOOP AT gbe WHERE matnr = t_matnr-matnr.
        PERFORM werksgruppe_anzeigen.
        CLEAR kz_werk.
        PERFORM wls_anzeigen.
        IF kz_werk = x.
          ULINE.
        ENDIF.
      ENDLOOP.

    WHEN varmatrix_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzvar_level.
*---- SEL_VARIANTE enthält die anzuzeigende Variante ------------------*
*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Buchungskreis-Bestände zum selektierten Artikel holen -----------*
*     LOOP AT BBE WHERE MATNR = SEL_VARIANTE.
*       PERFORM BUCHUNGSKREIS_ANZEIGEN.
*       CLEAR KZ_WERK.
*       PERFORM WLCS_ANZEIGEN.
*       IF KZ_WERK = X.
*         ULINE.
*       ENDIF.
*     ENDLOOP.
*#jhl 31.01.96 (Ende)

*---- Basiswerksgruppen-Bestände zum selektierten Artikel holen -------*
      LOOP AT gbe WHERE matnr = sel_variante.
        PERFORM werksgruppe_anzeigen.
        CLEAR kz_werk.
        PERFORM wls_anzeigen.
        IF kz_werk = x.
          ULINE.
        ENDIF.
      ENDLOOP.
  ENDCASE.

ENDFORM.                               " GWLS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  WLS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten zu 'W'erk, 'L'agerort und 'S'onderbestand anzeigen
*----------------------------------------------------------------------*
FORM wls_anzeigen.

*---- Art der Darstellung der Bestandsdaten erfolgt abhängig von ------*
*---- der Drilldown-Stufe                                        ------*
  CLEAR: wbe.

  CASE drilldown_level.
    WHEN artlist_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzart_level.
*---- T_MATNR zeigt auf den anzuzeigenden Artikel ---------------------*
*---- Werksbestände zum gefundenen Artikel holen ----------------------*
      LOOP AT wbe WHERE matnr = t_matnr-matnr
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                 AND   BUKRS = BBE-BUKRS.
                  AND   bwgrp = gbe-bwgrp.
        PERFORM werk_anzeigen.
        CHECK nullcheck NE 0.
        IF kz_werksond = x.
          PERFORM sonderbestand_anzeigen_wrk.
        ENDIF.
        PERFORM ls_anzeigen.
      ENDLOOP.

    WHEN varmatrix_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzvar_level.
*---- SEL_VARIANTE zeigt auf die anzuzeigende Variante ----------------*
*---- Werksbestände zum selektierten Artikel holen --------------------*
      LOOP AT wbe WHERE matnr = sel_variante
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                 AND   BUKRS = BBE-BUKRS.
                  AND   bwgrp = gbe-bwgrp.
        PERFORM werk_anzeigen.
        CHECK nullcheck NE 0.
        IF kz_werksond = x.
          PERFORM sonderbestand_anzeigen_wrk.
        ENDIF.
        PERFORM ls_anzeigen.
      ENDLOOP.
  ENDCASE.

ENDFORM.                               " WLS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  LS_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten zu 'L'agerort und 'S'onderbestand anzeigen
*----------------------------------------------------------------------*
FORM ls_anzeigen.

*---- Art der Darstellung der Bestandsdaten erfolgt abhängig von ------*
*---- der Drilldown-Stufe                                        ------*
  CLEAR: lbe.

  CASE drilldown_level.
    WHEN artlist_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzart_level.
*---- T_MATNR zeigt auf den anzuzeigenden Artikel ---------------------*
*---- Lagerbestände zum gefundenen Artikel holen ----------------------*
      LOOP AT lbe WHERE matnr = t_matnr-matnr
                  AND   werks = wbe-werks.
        PERFORM lager_anzeigen.
        CHECK nullcheck NE 0.
        PERFORM sonderbestand_anzeigen_lgo.
      ENDLOOP.

    WHEN varmatrix_level.
*---- Kann nicht auftreten -> wird über Prg.logik sichergestellt ------*

    WHEN einzvar_level.
*---- SEL_VARIANTE zeigt auf die selektierte Variante -----------------*
*---- Lagerbestände zum selektierten Artikel holen --------------------*
      LOOP AT lbe WHERE matnr = sel_variante
                  AND   werks = wbe-werks.
        PERFORM lager_anzeigen.
        CHECK nullcheck NE 0.
        PERFORM sonderbestand_anzeigen_lgo.
      ENDLOOP.
  ENDCASE.

ENDFORM.                               " LS_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  NULLBESTAND_SOND_WRK_LGO
*&---------------------------------------------------------------------*
*       Es wird geprüft, ob zum Werk ausgewählte Sonderbestände mit
*       Bestand ungleich Null für die Lagerortebene vorhanden sind.
*       Je Sonderbestandsart werden die einzelnen Sonderbestände nach
*       dem gleichen Verfahren wie die Werks-/Lgort-Bestände überprüft.
*       (hier nur Berücksichtigung von Sonderbestandsarten, die einem
*       Lagerort zugeordnet sind -> Lagerung fremder Sonderbestände)
*       Anmerkung:
*       Das Prüfen erfolgt nicht über die Bestandsfelder in WBE sondern
*       über die entsprechende interne Sonderbestandstabelle, weil nur
*       die vorhandenen 4 Bestandsarten bei der Prüfung berücksichtigt
*       werden dürfen, die später auch in der Anzeige erscheinen.
*----------------------------------------------------------------------*
FORM nullbestand_sond_wrk_lgo.

  CHECK p_kznul NE space.
  CHECK kz_sond_exist NE space.

*---- Lieferantenkonsignation prüfen ----------------------------------*
  MOVE 'KBE-' TO sav_fname0(4).
  LOOP AT kbe WHERE matnr =  wbe-matnr
                AND werks =  wbe-werks.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

*---- Kundenauftragsbestand prüfen ------------------------------------*
  CHECK nullcheck IS INITIAL.
  MOVE 'EBS-' TO sav_fname0(4).
  LOOP AT ebs WHERE matnr =  wbe-matnr
                AND werks =  wbe-werks.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

*---- Mehrwegtransportverpackungen prüfen -----------------------------*
  CHECK nullcheck IS INITIAL.
  MOVE 'MPS-' TO sav_fname0(4).
  LOOP AT mps WHERE matnr =  wbe-matnr
                AND werks =  wbe-werks.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

* Projektbestand prüfen ????uninteressant für Handel
* CHECK NULLCHECK IS INITIAL.
* MOVE 'PBE-' TO SAV_FNAME0(4).
* LOOP AT PBE where MATNR =  WBE-MATNR
*               and WERKS =  WBE-WERKS.
*    LOOP AT GRUND_ANZEIGE.
*       SAV_FNAME0+4 = GRUND_ANZEIGE-FNAME.
*       ASSIGN (SAV_FNAME0)  TO <F0>.
*       IF NOT <F0> IS INITIAL.
**        NULLCHECK = NULLCHECK +  <F0> . "ch/18.08.95 zu 3.0a
*         NULLCHECK = '1'.              . "sonst Probl wg. neg.Best und
*                                         "wg. Feldüberlauf
*       ENDIF.
*       IF NULLCHECK NE SPACE.
*         EXIT.
*       ENDIF.
*    ENDLOOP.
*    IF NULLCHECK NE SPACE.
*      EXIT.
*    ENDIF.
* ENDLOOP.

*>>> hier weitere Sonderbestandsarten anfügen

ENDFORM.                               " NULLBESTAND_SOND_WRK_LGO

*&---------------------------------------------------------------------*
*&      Form  NULLBESTAND_SOND_WRK
*&---------------------------------------------------------------------*
*       Es wird geprüft, ob zum Werk ausgewählte Sonderbestände mit
*       Bestand ungleich Null für die Werksebene vorhanden sind.
*       Je Sonderbestandsart werden die einzelnen Sonderbestände nach
*       dem gleichen Verfahren wie die Werks-/Lgort-Bestände überprüft.
*       (hier nur Berücksichtigung von Sonderbestandsarten, die nur
*       einem Werk zugeordnet sind -> eigene Sonderbestände extern
*       gelagert)
*       Anmerkung:
*       Das Prüfen erfolgt nicht über die Bestandsfelder in WBE sondern
*       über die entsprechende interne Sonderbestandstabelle, weil nur
*       die vorhandenen 3 Bestandsarten bei der Prüfung berücksichtigt
*       werden dürfen, die später auch in der Anzeige erscheinen.
*----------------------------------------------------------------------*
FORM nullbestand_sond_wrk.

*---- Prüfen, ob Kundenkonsi zum Werk vorhanden ist -------------------*
  kz_kein_w = x.
  MOVE 'WBS-' TO sav_fname0(4).
  LOOP AT wbs WHERE matnr =  wbe-matnr
                AND werks =  wbe-werks.
*---- Sonderbehandlung, falls Nullzeilen angezeigt werden sollen ------*
    IF p_kznul EQ space.
      CLEAR kz_kein_w.
      EXIT.
    ENDIF.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
        CLEAR kz_kein_w.
      ENDIF.
*     IF NULLCHECK NE SPACE.   ????wieso das            "K11K086584
*       EXIT.                                           "K11K086584
*     ENDIF.                                            "K11K086584
    ENDLOOP.
*   IF NULLCHECK NE SPACE.    ????wieso das           "K11K086584
*     EXIT.                                           "K11K086584
*   ENDIF.                                            "K11K086584
  ENDLOOP.

*---- Prüfen, ob Kundenleergut zum Werk vorhanden ist -----------------*
  kz_kein_v = x.
  MOVE 'VBS-' TO sav_fname0(4).
  LOOP AT vbs WHERE matnr =  wbe-matnr
                AND werks =  wbe-werks.
*---- Sonderbehandlung, falls Nullzeilen angezeigt werden sollen ------*
    IF p_kznul EQ space.
      CLEAR kz_kein_v.
      EXIT.
    ENDIF.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
        CLEAR kz_kein_v.
      ENDIF.
*     IF NULLCHECK NE SPACE.       ????                "K11K086584
*       EXIT.                                          "K11K086584
*     ENDIF.                                           "K11K086584
    ENDLOOP.
*   IF NULLCHECK NE SPACE.                             "K11K086584
*     EXIT.                                            "K11K086584
*   ENDIF.                                             "K11K086584
  ENDLOOP.

*---- Prüfen, ob Lieferantenbeistellungen zum Werk vorhanden ist ------*
  kz_kein_o = x.
  MOVE 'OBS-' TO sav_fname0(4).
  LOOP AT obs  WHERE matnr =  wbe-matnr
                 AND werks =  wbe-werks.
*---- Sonderbehandlung, falls Nullzeilen angezeigt werden sollen ------*
    IF p_kznul EQ space.
      CLEAR kz_kein_o.
      EXIT.
    ENDIF.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
        CLEAR kz_kein_o.
      ENDIF.
*     IF NULLCHECK NE SPACE.                            "K11K086584
*       EXIT.                                           "K11K086584
*     ENDIF.                                            "K11K086584
    ENDLOOP.
*   IF NULLCHECK NE SPACE.                              "K11K086584
*     EXIT.                                             "K11K086584
*   ENDIF.                                              "K11K086584
  ENDLOOP.

ENDFORM.                               " NULLBESTAND_SOND_WRK

*&---------------------------------------------------------------------*
*&      Form  NULLBESTAND_SOND_LGO
*&---------------------------------------------------------------------*
*       Es wird geprüft, ob zum LgOrt ausgewählte Sonderbestände mit
*       Bestand ungleich Null für die Lagerortebene vorhanden sind.
*       Je Sonderbestandsart werden die einzelnen Sonderbestände nach
*       dem gleichen Verfahren wie die Werks-/Lgort-Bestände überprüft.
*       (hier nur Berücksichtigung von Sonderbestandsarten, die einem
*       Lagerort zugeordnet sind -> Lagerung fremder Sonderbestände)
*       Anmerkung:
*       Das Prüfen erfolgt nicht über die Bestandsfelder in WBE sondern
*       über die entsprechende interne Sonderbestandstabelle, weil nur
*       die vorhandenen 4 Bestandsarten bei der Prüfung berücksichtigt
*       werden dürfen, die später auch in der Anzeige erscheinen.
*----------------------------------------------------------------------*
FORM nullbestand_sond_lgo.

  CHECK p_kznul NE space.
  CHECK kz_sond_exist NE space.

*---- Lieferantenkonsignation prüfen ----------------------------------*
  MOVE 'KBE-' TO sav_fname0(4).
  LOOP AT kbe WHERE matnr =  lbe-matnr
                AND werks =  lbe-werks
                AND lgort =  lbe-lgort.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

*---- Kundenauftragsbestand prüfen ------------------------------------*
  CHECK nullcheck IS INITIAL.
  MOVE 'EBS-' TO sav_fname0(4).
  LOOP AT ebs WHERE matnr =  lbe-matnr
                AND werks =  lbe-werks
                AND lgort =  lbe-lgort.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

*---- Mehrwegtransportverpackungen prüfen -----------------------------*
  CHECK nullcheck IS INITIAL.
  MOVE 'MPS-' TO sav_fname0(4).
  LOOP AT mps WHERE matnr =  lbe-matnr
                AND werks =  lbe-werks
                AND lgort =  lbe-lgort.
    LOOP AT grund_anzeige.
      sav_fname0+4 = grund_anzeige-fname.
      ASSIGN (sav_fname0)  TO <f0>.
      IF NOT <f0> IS INITIAL.
        nullcheck = '1'.
      ENDIF.
      IF nullcheck NE space.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

* Projektbestand prüfen ????uninteressant für Handel
* CHECK NULLCHECK IS INITIAL.
* MOVE 'PBE-' TO SAV_FNAME0(4).
* LOOP AT PBE where MATNR =  LBE-MATNR
*               and WERKS =  LBE-WERKS.
*               AND LGORT =  LBE-LGORT.
*    LOOP AT GRUND_ANZEIGE.
*       SAV_FNAME0+4 = GRUND_ANZEIGE-FNAME.
*       ASSIGN (SAV_FNAME0)  TO <F0>.
*       IF NOT <F0> IS INITIAL.
**        NULLCHECK = NULLCHECK +  <F0> . "ch/18.08.95 zu 3.0a
*         NULLCHECK = '1'.              . "sonst Probl wg. neg.Best und
*                                         "wg. Feldüberlauf
*       ENDIF.
*       IF NULLCHECK NE SPACE.
*         EXIT.
*       ENDIF.
*    ENDLOOP.
*    IF NULLCHECK NE SPACE.
*      EXIT.
*    ENDIF.
* ENDLOOP.

*>>> hier weitere Sonderbestandsarten anfügen

ENDFORM.                               " NULLBESTAND_SOND_LGO

*&---------------------------------------------------------------------*
*&      Form  SONDERBESTAND_ANZEIGEN_WRK
*&---------------------------------------------------------------------*
*       Anzeigen der Sonderbestände, die nicht einem Lagerort sondern
*       direkt einem Werk zugeordnet sind (eigene Bestände bei Lieferant
*       oder Kunde gelagert)
*----------------------------------------------------------------------*
FORM sonderbestand_anzeigen_wrk.

*---- Prüfen, ob lediglich der Aufriß zum Mandanten oder zur Basis- ---*
*---- werksgruppe angezeigt werden soll (in diesem Fall endet die   ---*
*---- folgende Prüfung negativ)                                     ---*
  CHECK NOT ( sy-ucomm = 'PF10' AND ( kz_list NE konsikunde AND
                                      kz_list NE lrgutkunde AND
                                      kz_list NE beistlief  AND
                                      kz_list NE wrk_zeile ) ).

*---- Anzeigen Lieferantenbeistellung ---------------------------------*
  IF beistlief IN s_sobkz AND
     NOT ( sy-ucomm = 'PF10' AND ( kz_list NE beistlief  AND
                                   kz_list NE wrk_zeile ) ).
*---- Prüfen, ob Lieferantenbeistellungen zum Werk anzuzeigen sind ----*
    IF kz_kein_o IS INITIAL.     "Falls L.beist. angezeigt werden soll
      PERFORM beistlief_anzeigen_wrk.
    ENDIF.
  ENDIF.

*---- Anzeigen Kundenkonsignation zum Werk ----------------------------*
  IF konsikunde IN s_sobkz AND
     NOT ( sy-ucomm = 'PF10' AND ( kz_list NE konsikunde AND
                                   kz_list NE wrk_zeile ) ).
*---- Prüfen, ob Kundenkonsignationsbestände zum Werk anzuzeigen sind -*
    IF kz_kein_w IS INITIAL.     "Falls K.Konsi angezeigt werden soll
      PERFORM konsikunde_anzeigen_wrk.
    ENDIF.
  ENDIF.

*---- Anzeigen Kundenleergut ------------------------------------------*
  IF lrgutkunde IN s_sobkz AND
     NOT ( sy-ucomm = 'PF10' AND ( kz_list NE lrgutkunde AND
                                   kz_list NE wrk_zeile ) ).
*---- Prüfen, ob Kundenleergutbestände zum Werk anzuzeigen sind -------*
    IF kz_kein_v IS INITIAL.     "Falls K.Leergut angezeigt werden soll
      PERFORM lrgutkunde_anzeigen_wrk.
    ENDIF.
  ENDIF.

ENDFORM.                               " SONDERBESTAND_ANZEIGEN_WRK

*&---------------------------------------------------------------------*
*&      Form  KONSIKUNDE_ANZEIGEN_WRK
*&---------------------------------------------------------------------*
*       Ausgeben der Kundenkonsibestände auf Werksebene.
*----------------------------------------------------------------------*
FORM konsikunde_anzeigen_wrk.

*---- Kumulieren der Kunden-Konsi-Bestände auf Werksebene -------------*
  CLEAR sum-labst.
  CLEAR sum-insme.
  CLEAR sum-speme.
  CLEAR sum-einme.
  LOOP AT wbs "????ein einfaches READ TABLE WBE müßte auch funktionieren
    WHERE matnr =  wbe-matnr "da in WBE die über den Kund. kummulierten
      AND werks =  wbe-werks.          "Bestandswerte stehen!?!
    sum-labst = sum-labst + wbs-labst.
    sum-insme = sum-insme + wbs-insme.
    sum-einme = sum-einme + wbs-einme.
  ENDLOOP.
  zeilen_kz = wrk_zeile.
  sond_kz = konsikunde.
  PERFORM sonderbestand_write_wrk.

ENDFORM.                               " KONSIKUNDE_ANZEIGEN_WRK

*&---------------------------------------------------------------------*
*&      Form  LRGUTKUNDE_ANZEIGEN_WRK
*&---------------------------------------------------------------------*
*       text                                                           *
*       Ausgeben der Kundenleergutbestände auf Werksebene.
*----------------------------------------------------------------------*
FORM lrgutkunde_anzeigen_wrk.

*---- Kumulieren der Kundenleergut-Bestände auf Werksebene ------------*
  CLEAR sum-labst.
  CLEAR sum-insme.
  CLEAR sum-speme.
  CLEAR sum-einme.
  LOOP AT vbs "????ein einfaches READ TABLE WBE müßte auch funktionieren
    WHERE matnr =  wbe-matnr "da in WBE die über den Kund. kummulierten
      AND werks =  wbe-werks.          "Bestandswerte stehen!?!
    sum-labst = sum-labst + vbs-labst.
    sum-insme = sum-insme + vbs-insme.
    sum-einme = sum-einme + vbs-einme.
  ENDLOOP.
  zeilen_kz = wrk_zeile.
  sond_kz = lrgutkunde.
  PERFORM sonderbestand_write_wrk.

ENDFORM.                               " LRGUTKUNDE_ANZEIGEN_WRK

*&---------------------------------------------------------------------*
*&      Form  BEISTLIEF_ANZEIGEN_WRK
*&---------------------------------------------------------------------*
*       Ausgeben der Lieferantenbeistellungsbestände auf Werksebene
*----------------------------------------------------------------------*
FORM beistlief_anzeigen_wrk.

*---- Kumulieren der Lieferantenbeistellungen auf Werksebene ----------*
  CLEAR sum-labst.
  CLEAR sum-insme.
  CLEAR sum-speme.
  CLEAR sum-einme.
  LOOP AT obs "????ein einfaches READ TABLE WBE müßte auch funktionieren
    WHERE matnr =  wbe-matnr  "da in WBE die über den Lief. kummulierten
      AND werks =  wbe-werks.          "Bestandswerte stehen!?!
    sum-labst = sum-labst + obs-labst.
    sum-insme = sum-insme + obs-insme.
    sum-einme = sum-einme + obs-einme.
  ENDLOOP.
  zeilen_kz = wrk_zeile.
  sond_kz = beistlief.
  PERFORM sonderbestand_write_wrk.

ENDFORM.                               " BEISTLIEF_ANZEIGEN_WRK

*&---------------------------------------------------------------------*
*&      Form  SONDERBESTAND_WRITE_WRK
*&---------------------------------------------------------------------*
*       Werkssonderbestandsdaten anzeigen
*----------------------------------------------------------------------*
FORM sonderbestand_write_wrk.

  MOVE: 'SUM-' TO sav_fname1(4),
        'SUM-' TO sav_fname2(4),
        'SUM-' TO sav_fname3(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

* FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  FORMAT COLOR COL_KEY INTENSIFIED OFF.
  WRITE / sy-vline.
  CASE sond_kz.
    WHEN beistlief.
      WRITE: 05    text-044.           "Klartext 'Lieferanten-Beist.'
    WHEN konsikunde.
      WRITE: 05    text-045.           "Klartext 'Kunden-Konsi.'
    WHEN lrgutkunde.
      WRITE: 05    text-046.           "Klartext 'Kunden-Leihgut'
  ENDCASE.
  WRITE: 26 sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED.
  PERFORM grund_zeile_write.

  zeilen_kz = wrk_zeile.
  zle-matnr = wbe-matnr.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* ZLE-BUKRS = WBE-BUKRS.
  zle-bwgrp = wbe-bwgrp.
  zle-werks = wbe-werks.
  HIDE:          zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 zle-matnr,            "Zeilenmaterial
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                ZLE-BUKRS,             "Zeilenbuchungskreis
                 zle-bwgrp,            "Zeilenbasiswerksgruppe
                 zle-werks,            "Zeilenwerk
                 sond_kz,              "Sonderbestandskennzeichen
                 kz_kein_o,            "KZ keine L.Beist. vorhanden
                 kz_kein_w,            "KZ keine K.Konsi vorhanden
                 kz_kein_v.            "KZ keine K.Leergut vorhanden
  CLEAR sond_kz.

ENDFORM.                               " SONDERBESTAND_WRITE_WRK

*&---------------------------------------------------------------------*
*&      Form  SONDERBESTAND_ANZEIGEN_LGO
*&---------------------------------------------------------------------*
*       Anzeigen der Sonderbestände, die einem Lagerort zugeordnet sind
*       (fremde Sonderbestände, die im eigenen Unternehmen gelagert
*       werden)
*----------------------------------------------------------------------*
FORM sonderbestand_anzeigen_lgo.

  CHECK rmmmb-kzson NE space.
  CHECK kz_sond_exist NE space.

  PERFORM konsilief_anzeigen_lgo.
  PERFORM mtverpack_anzeigen_lgo.
  PERFORM aufbskunde_anzeigen_lgo.
* PERFORM PRJBESTAND_ANZEIGEN_LGO.  "????uninteressant für Handel

*>>> hier weitere Sonderbestandsarten anfügen gemäß Selektionsbedingung

ENDFORM.                               " SONDERBESTAND_ANZEIGEN_LGO

*&---------------------------------------------------------------------*
*&      Form  KONSILIEF_ANZEIGEN_LGO
*&---------------------------------------------------------------------*
*       Ausgeben der Lieferantenkonsibestände auf Lagerortebene
*----------------------------------------------------------------------*
FORM konsilief_anzeigen_lgo.

*---- Prüfen, ob Lieferantenkonsi angezeigt werden soll ---------------*
  CHECK konsilief IN s_sobkz.

*---- Anzeigen Lieferantenkonsignation --------------------------------*
* LOOP ist total unötig, da auf KBE keine weiteren Zugriffe erfolgen
* und NULLBESTAND-Check sowieso noch läuft
* LOOP AT KBE                                               "JH/17.10.96
*   WHERE MATNR =  LBE-MATNR                                "JH/17.10.96
*   AND   WERKS =  LBE-WERKS                                "JH/17.10.96
*   AND   LGORT =  LBE-LGORT.                               "JH/17.10.96
* LOOP ist doch notwendig, weil ansonsten bei allen Lagerorten eine
* Nullbestandszeile für Lieferantenkonsi ausgegeben wird, sobald mind.
* ein LgOrt mit Lieferantenkonsi existiert -> dient dazu die Lagerorte
* ohne Lief.konsi auszufiltern! -> besser READ BINARY nehmen????
  LOOP AT kbe                          "JH/18.12.96
    WHERE matnr =  lbe-matnr           "JH/18.12.96
    AND   werks =  lbe-werks           "JH/18.12.96
    AND   lgort =  lbe-lgort.          "JH/18.12.96
    sum-labst = lbe-klabs.
    sum-insme = lbe-kinsm.
    sum-einme = lbe-keinm.
    sum-speme = lbe-kspem.
    sond_kz = konsilief.
    PERFORM sonderbestand_write_lgo.
    EXIT.                              "JH/18.12.96
  ENDLOOP.                             "JH/18.12.96
*   EXIT.                                                   "JH/17.10.96
* ENDLOOP.                                                  "JH/17.10.96

ENDFORM.                               " KONSILIEF_ANZEIGEN_LGO

*&---------------------------------------------------------------------*
*&      Form  AUFBSKUNDE_ANZEIGEN_LGO
*&---------------------------------------------------------------------*
*       Ausgeben der Kundenauftragsbestände auf Lagerortebene
*----------------------------------------------------------------------*
FORM aufbskunde_anzeigen_lgo.

*---- Prüfen, ob Kundenauftragsbestand angezeigt werden soll ----------*
  CHECK aufbskunde IN s_sobkz.

*---- Anzeigen Kundenauftragsbestand ----------------------------------*
  IF ( NOT lbe-kalab IS INITIAL ) OR ( NOT lbe-kains IS INITIAL ) OR
     ( NOT lbe-kaspe IS INITIAL ) OR ( NOT lbe-kaein IS INITIAL ).
    CLEAR sum.
    sum-labst = lbe-kalab.
    sum-insme = lbe-kains.
    sum-speme = lbe-kaspe.
    sum-einme = lbe-kaein.
    sond_kz = aufbskunde.
    PERFORM sonderbestand_write_lgo.
  ENDIF.

ENDFORM.                               " AUFBSKUNDE_ANZEIGEN_LGO

*&---------------------------------------------------------------------*
*&      Form  MTVERPACK_ANZEIGEN_LGO
*&---------------------------------------------------------------------*
*       Ausgeben der MTV-Bestände auf Lagerortebene
*----------------------------------------------------------------------*
FORM mtverpack_anzeigen_lgo.

*---- Prüfen, ob Mehrwegtransportverpackungen angezeigt werden sollen -*
  CHECK mtverpack IN s_sobkz.

*---- Anzeigen Mehrwegtransportverpackungen ---------------------------*
  IF ( NOT lbe-mlabs IS INITIAL ) OR ( NOT lbe-minsm IS INITIAL ) OR
     ( NOT lbe-meinm IS INITIAL ) OR ( NOT lbe-mspem IS INITIAL ).
    CLEAR sum.
    sum-labst = lbe-mlabs.
    sum-insme = lbe-minsm.
    sum-einme = lbe-meinm.
    sum-speme = lbe-mspem.
    sond_kz = mtverpack.
    PERFORM sonderbestand_write_lgo.
  ENDIF.

ENDFORM.                               " MTVERPACK_ANZEIGEN_LGO

*&---------------------------------------------------------------------*
*&      Form  SONDERBESTAND_WRITE_LGO
*&---------------------------------------------------------------------*
*       Lagerortsonderbestandsdaten anzeigen
*----------------------------------------------------------------------*
FORM sonderbestand_write_lgo.

  MOVE 'SUM-' TO sav_fname0(4).
  PERFORM nullbestand_pruefen.
  CHECK nullcheck NE 0.

  MOVE: 'SUM-' TO sav_fname1(4),
        'SUM-' TO sav_fname2(4),
        'SUM-' TO sav_fname3(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

* FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  FORMAT COLOR COL_KEY INTENSIFIED OFF.
  WRITE  / sy-vline.
  CASE sond_kz.
    WHEN konsilief.
      WRITE:  07    text-047.          "Klartext 'Lieferanten-Konsi.'
    WHEN aufbskunde.
      WRITE:  07    text-048.          "Klartext 'Kundenauftragsbestand'
    WHEN mtverpack.
      WRITE:  07    text-049.          "Klartext 'MTVerpackung'
*   WHEN PRJBESTAND.   ????uninteressant für Handel
*     WRITE:  07    TEXT-082.         "Klartext 'Projektbestand'
  ENDCASE.
  WRITE: 26 sy-vline.
  FORMAT COLOR COL_NORMAL INTENSIFIED.
  PERFORM grund_zeile_write.

  zeilen_kz = lag_zeile.
  zle-matnr = lbe-matnr.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* ZLE-BUKRS = WBE-BUKRS.
  zle-bwgrp = wbe-bwgrp.
  zle-werks = lbe-werks.
  zle-lgort = lbe-lgort.
  HIDE:          zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 zle-matnr,            "Zeilenmaterial
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*                ZLE-BUKRS,             "Zeilenbuchungskreis
                 zle-bwgrp,            "Zeilenbasiswerksgruppe
                 zle-werks,            "Zeilenwerk
                 zle-lgort,            "Zeilenlagerort
                 sond_kz.              "Sonderbestandskennzeichen
  CLEAR sond_kz.

ENDFORM.                               " SONDERBESTAND_WRITE_LGO

*&---------------------------------------------------------------------*
*&      Form  NULLBESTAND_PRUEFEN_EINZEL
*&---------------------------------------------------------------------*
*       Nullbestand bei Sonderbestandsanzeige in Einzelliste überprüfen
*----------------------------------------------------------------------*
FORM nullbestand_pruefen_einzel.

  nullcheck = 1.

  CHECK p_kznul NE space.

  CLEAR nullcheck.
  LOOP AT einzel_anzeige.
    sav_fname0+4 = einzel_anzeige-bfnae.
    ASSIGN (sav_fname0)  TO <f0>.
    IF NOT <f0> IS INITIAL.
      nullcheck = '1'.
    ENDIF.
    IF nullcheck NE space.
      EXIT.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " NULLBESTAND_PRUEFEN_EINZEL

*&---------------------------------------------------------------------*
*&      Form  CHECK_GLEICHE_MEINH
*&---------------------------------------------------------------------*
*       Überprüfen, ob alle selektierten Artikel in der gleichen Mengen-
*       einheit angezeigt werden. Falls dies nicht der Fall ist, kann
*       in der Summenzeile keine Mengeneinheit erscheinen.
*----------------------------------------------------------------------*
FORM check_gleiche_meinh.

  READ TABLE t_matnr WITH KEY matnr = mbe-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  IF sum_meinh IS INITIAL.
    sum_meinh = t_matnr-meins.
    CLEAR keine_sum_meinh.
  ELSE.
    IF sum_meinh <> t_matnr-meins.
      keine_sum_meinh = x.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHECK_GLEICHE_MEINH

*&---------------------------------------------------------------------*
*&      Form  VARIANTEN_AUFRISS
*&---------------------------------------------------------------------*
*       Anzeige der Aufrißliste mit den Varianten eines Sammelartikels
*       in der Anzeigestufe 'Artikelliste'
*----------------------------------------------------------------------*
FORM varianten_aufriss.

  IF zeilen_kz NE man_zeile.
    MESSAGE i034.
*    Cursor bitte innerhalb einer Bestandszeile zum Material positionier
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
    EXIT.
  ENDIF.

*---- Artikeldaten zum selektierten Artikel lesen ---------------------*
  READ TABLE t_matnr WITH KEY matnr = zle-matnr.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  IF t_matnr-attyp NE attyp_sam.
    MESSAGE i088.
*    Variantenaufriß kann nur für Sammelmaterialien aufgerufen werden
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
    EXIT.
  ENDIF.

  kz_list = man_zeile.
  SET TITLEBAR 'NAE' WITH text-014 text-069.
*---- CBI/WWW: Fürs Web ungeeignete FCodes deaktivieren
  IF NOT p_submit_info-www_active IS INITIAL.                  " WWW
    SET PF-STATUS pfstatus_naechst_l EXCLUDING t_fcodes_www.   " WWW
  ELSE.                                " WWW
    SET PF-STATUS pfstatus_naechst_l.
  ENDIF.                               " WWW

  PERFORM initialisierung.
  PERFORM sum_varianten_anzeigen.

ENDFORM.                               " VARIANTEN_AUFRISS

*&---------------------------------------------------------------------*
*&      Form  SUM_VARIANTEN_ANZEIGEN
*&---------------------------------------------------------------------*
*       text????                                                       *
*----------------------------------------------------------------------*
FORM sum_varianten_anzeigen.

*---- Gesamtbestand des Sammelartikels anzeigen -----------------------*
  PERFORM sum_sammelartikel_anzeigen.

*---- Gesamtbestand der zugeordneten Varianten anzeigen ---------------*
  LOOP AT t_matnr WHERE satnr = zle-matnr.
*---- Mandantenbestände zur Variante holen ----------------------------*
    READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    PERFORM variante_anzeigen.
  ENDLOOP.

ENDFORM.                               " SUM_VARIANTEN_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  SUM_SAMMELARTIKEL_ANZEIGEN
*&---------------------------------------------------------------------*
*       Gesamtbestand des Sammelartikels im Aufriß zu den Varianten
*       anzeigen
*----------------------------------------------------------------------*
FORM sum_sammelartikel_anzeigen.

*---- Mandantenbestände zum Sammelartikel holen -----------------------*
  READ TABLE mbe WITH KEY matnr = t_matnr-matnr BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.

  PERFORM material_anzeigen.

ENDFORM.                               " SUM_SAMMELARTIKEL_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  VARIANTE_ANZEIGEN
*&---------------------------------------------------------------------*
*       Gesamtbestände bei einer Liste von Materialen anzeigen
*----------------------------------------------------------------------*
FORM variante_anzeigen.

  MOVE: 'MBE-' TO sav_fname1(4),
        'MBE-' TO sav_fname2(4),
        'MBE-' TO sav_fname3(4),
        'MBE-' TO sav_fname0(4).
  PERFORM assign_grundliste.
  PERFORM umschluesseln_zeile.

*  FORMAT COLOR COL_HEADING INTENSIFIED OFF.    "TGA/150699
   FORMAT COLOR COL_KEY INTENSIFIED.            "TGA/150699

  CASE anzeige_art_l.
    WHEN anz_art_bez.
      WRITE: /   sy-vline NO-GAP,
                 t_matnr-maktx(20),    "Materialbezeichn. (verkürzt)
             23  t_matnr-meins.        "Anzeigemengeneinheit
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:      zeilen_kz,            "Zeilenkennzeichen
                 rmmmb-fennr,          "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
                 kz_list,              "Aktuelle Liststufe
                 zle-matnr,            "Zeilenmaterial
                 bezei_kz.             "Kz: Zeile enth. nur Bezeichnung
      ULINE.
    WHEN anz_art_nr.
      WRITE:  /  sy-vline NO-GAP,
                 t_matnr-matnr,        "Materialnr.
             23  t_matnr-meins.        "Anzeigemengeneinheit
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Material
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      ULINE.
    WHEN anz_art_bun.
      WRITE:  /  sy-vline NO-GAP,
                 t_matnr-matnr,        "Materialnr.
             23  t_matnr-meins.        "Anzeigemengeneinheit
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      PERFORM grund_zeile_write.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      CLEAR bezei_kz.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Material
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: /   sy-vline,
                 t_matnr-maktx(23),    "Materialbezeichn. (verkürzt)
             26  sy-vline.
      FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
      WRITE: 27  space17,
             44  sy-vline,
             45  space17,
             62  sy-vline,
             63  space17,
             80  sy-vline.
*---- Zuweisung an ZEILEN_KZ erst nach erfolgtem WRITE, ansonsten -----*
*---- kann durch Ausgabe des Seitenkopfes ZEILEN_KZ überschrieben -----*
*---- werden                                                      -----*
      zeilen_kz = man_zeile.
      zle-matnr = mbe-matnr.
      bezei_kz = x.
      HIDE:  zeilen_kz,                "Zeilenkennzeichen
             rmmmb-fennr,              "Aktuelle Fensternummer
* JH/21.01.97/1.2B KPr1018362
             kz_list,                  "Aktuelle Liststufe
             zle-matnr,                "Zeilenmaterial
             bezei_kz.                 "Kz: Zeile enth. nur Bezeichnung
      CLEAR bezei_kz.
      ULINE.
  ENDCASE.

ENDFORM.                               " VARIANTE_ANZEIGEN
*&---------------------------------------------------------------------*
*&      Form  check_structured_article
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_structured_article TABLES str_matnr STRUCTURE t_matnr.

data: ls_t134 TYPE t134. " note 1511925

*check if any structured article exists where matnr is a component

  strart_exist = no.

  IF str_matnr-attyp = attyp_sam.
* tga 19992311 start
*    LOOP AT str_matnr WHERE satnr = t_matnr-matnr   "delete
*                           AND disst <> space.      "delete
    LOOP AT str_matnr TRANSPORTING NO FIELDS WHERE satnr = t_matnr-matnr
                                             AND disst <> space.
* tga 19992311 end
* note 1511925
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

      IF sy-subrc = 0 AND ls_t134-wmakg <> '2'. "Mat type for empties not supported,note 1511925
        strart_exist = yes.
        EXIT.
      ENDIF.
    ENDLOOP.
  ELSE.
    IF NOT t_matnr-disst IS INITIAL AND
       NOT t_matnr-disst EQ 000.
* tga 19992311 end
* note 1511925
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
      check ls_t134-wmakg <> '2'. "Mat type for empties, note 1511925
      strart_exist = yes.
    ENDIF.
  ENDIF.

ENDFORM.                               " check_structured_article
