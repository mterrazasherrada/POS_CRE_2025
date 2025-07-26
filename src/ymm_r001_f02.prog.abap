*-------------------------------------------------------------------
***INCLUDE RWBE1F02 .
*  Ermitteln und Ablegen der Bestandsdaten
*  (Verarbeitung analog RMMMBEFM)
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  BESTAENDE_ERMITTELN
*&---------------------------------------------------------------------*
* Ermitteln aller relevanten Bestände.
* Hierbei trifft man auf folgende möglichen Ausgangssituationen für die
* Bestandsermittlung:
* 1) mat_sel = 'einzelner SA'
*    a) merkm_sel = kein
*       i) anz_vb_merk = 2 (evtl. später auch mal 1)
*          -> alle Varianten bei Bestandsermittlung berücksichtigen
*    b) merkm_sel = merk1
*       i) anz_vb_merk = 2 (evtl. später auch mal 1)
*          -> alle Varianten mit Merk1 = 'selekt. Werte' und Merk2 =
*             'alle Werte' bei Bestandsermittlung berücksichtigen
*    c) merkm_sel = merk2
*       i) anz_vb_merk = 2 (evtl. später auch mal 1)
*          -> alle Varianten mit Merk2 = 'selekt. Werte' und Merk1 =
*             'alle Werte' bei Bestandsermittlung berücksichtigen
*    d) merkm_sel = merk1u2
*       i) anz_vb_merk = 2
*          -> alle Varianten mit Merk1 = 'selekt. Werte1' und Merk2 =
*             'selekt. Werte2' bei Bestandsermittlung berücksichtigen
* 2) mat_sel = 'einzelner normaler Art.'
*    merkm_sel = kein, anz_vb_merk = 0
*    -> nur normalen Art. bei Bestandsermittlung berücksichtigen
* 3) mat_sel = 'Art.liste'
*    a) Art.liste führt nach Variantenelemination zu einzelnem SA
*       -> Merkmalsdaten nachlesen -> Fall 1)
*    b) Art.liste enthält nach Variantenelemination noch mehrere Art.
*       -> alle Artikel u. alle Varianten zu SA's bei Bestandsermittlung
*          berücksichtigen
*          Achtung: beim Wechsel von der Grundliste zur Artikelliste
*                   auf die Grundliste zu einem SA, müssen Merkmals-
*                   daten nachgelesen werden und nach dem Rücksprung
*                   wieder gelöscht werden! (oder doch gleich ermitteln
*                   wg. Konsistenz zu Fällen 4b)-4d))
* 4) mat_sel = 'WG'
*    a) merkm_sel = kein, anz_vb_merk = beliebig
*       -> alle Artikel u. Varianten zu SA's bei Bestandsermittlung
*          berücksichtigen
*          Achtung: beim Wechsel von der Grundliste zur Artikelliste
*                   auf die Grundliste zu einem SA, müssen Merkmals-
*                   daten nachgelesen werden und nach dem Rücksprung
*                   wieder gelöscht werden! (oder doch gleich ermitteln
*                   wg. Konsistenz zu Fällen 4b)-4d))
*    b) merkm_sel = merk1
*       i) anz_vb_merk = 2 (evtl. später auch mal 1)
*          -> alle Varianten zu SA's mit Merk1 = 'selekt. Werte' und
*             Merk2 = 'alle Werte' bei Bestandsermittlung berücksicht.
*    c) merkm_sel = merk2
*       i) anz_vb_merk = 2 (evtl. später auch mal 1)
*          -> alle Varianten zu SA's mit Merk2 = 'selekt. Werte' und
*             Merk1 = 'alle Werte' bei Bestandsermittlung berücksicht.
*    d) merkm_sel = merk1u2
*       i) anz_vb_merk = 2
*          -> alle Varianten zu SA's mit Merk1 = 'selekt. Werte1' und
*             Merk2 = 'selekt. Werte2' bei Bestandsermittlung berücks.
*
* ==> Zusammenfassen der Fälle zu 2 Gruppen mit gleichem Ablauf:
* Gruppe 1:
*   Fälle 1a), 2), 3a), 3b), 4a)
*   -> ohne Betrachtung von Merkmalsdaten, wobei bei 3a), 3b) u. 4a)
*      Merkmalsdaten zum Sammelartikel nachgelesen werden müssen
* Gruppe 2:
*   Fälle 1b) - 1d), 4b) - 4d)
*   -> mit Betrachtung von Merkmalsdaten zu einem Sammelartikel/Waren-
*      gruppe
*----------------------------------------------------------------------*
FORM bestaende_ermitteln.

  PERFORM mat_sel_korrigieren.

  PERFORM init_bestands_anzeige.

*TGA/4.6 Erweiterungen Lot (START)
*GET RUN TIME FIELD RUN_TIME. "????Zeit auf 0 setzen -> nur für Tests
* PERFORM BESTANDSDATEN_LESEN.
*GET RUN TIME FIELD RUN_TIME. "????Zeit messen -> nur für Tests
  REFRESH: mbe, gbe, wbe, lbe, ebs, kbe, mps, obs, vbs, wbs, oeb, ek_vk.
  IF g_iltest =  'X'.

    PERFORM bestandsdaten_lesen_new TABLES t_matnr
                                         t_werks
                                         mbe gbe wbe lbe ebs kbe
                                         mps obs vbs wbs oeb ek_vk.


    ENHANCEMENT-POINT EHP_BESTAENDE_ERMITTELN_01 SPOTS ES_RWBEST01.

  ELSE.

    PERFORM bestandsdaten_lesen TABLES t_matnr
                                       t_werks
                                       mbe gbe wbe lbe ebs kbe
                                       mps obs vbs wbs oeb ek_vk
                                       cbe wbs_seg.

  ENDIF.
*RST Test class inventory_lookup-E
*TGA/4.6 Erweiterungen Lot (END)
*  additions for ALV-tree start tga >991009
*  PERFORM BESTAENDE_ANZEIGEN.     "delete, rest insert
  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
    IF p_kzalv IS NOT INITIAL.
      PERFORM show_stocks.
    ELSEIF p_kzvst0 IS INITIAL.
      IF rmmmb-vernu IS INITIAL.
        PERFORM check_vernu USING p_vernu p_vernut.
      ENDIF.
      PERFORM bestaende_anzeigen.
    ELSE.
*stocks with ALV-Tree
*-tabelle t_w_lbe wird hier mit werksbeständen versorgt, diese werks
*-bestände auf dem Lagerort werden für die spätere kumulation durch den
*- ALV benötigt ---- nur bei Anzeige auf lagerort level
      IF NOT p_kzlgo IS INITIAL.
        PERFORM werks_only.
      ENDIF.
      PERFORM mengeneinheiten_lesen TABLES t_matnr. " note 1511925
      PERFORM show_stocks.
    ENDIF.
  ELSE.
    IF p_kzvst0 IS INITIAL.
      IF rmmmb-vernu IS INITIAL.
        PERFORM check_vernu USING p_vernu p_vernut.
      ENDIF.
      PERFORM bestaende_anzeigen.
    ELSE.
*stocks with ALV-Tree
*-tabelle t_w_lbe wird hier mit werksbeständen versorgt, diese werks
*-bestände auf dem Lagerort werden für die spätere kumulation durch den
*- ALV benötigt ---- nur bei Anzeige auf lagerort level
      IF NOT p_kzlgo IS INITIAL.
        PERFORM werks_only.
      ENDIF.
      PERFORM mengeneinheiten_lesen TABLES t_matnr. " note 1511925
      PERFORM show_stocks.
    ENDIF.
  ENDIF.
*  additions for ALV-tree end tga >991009

ENDFORM.                               " BESTAENDE_ERMITTELN

*&---------------------------------------------------------------------*
*&      Form  MARC_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der Werksbestände in den interen Tabellen.              *
*    2) Falls das Material eine Variante ist, werden auch die Best.    *
*       für den zugehörenden Sammelartikel fortgeschrieben.            *
*    3) Zu jedem Werk die Lagerortbestände ermitteln und ablegen.      *
*----------------------------------------------------------------------*
FORM marc_bestaende TABLES pt_werks STRUCTURE t_werks.
  DATA: hindex LIKE sy-tabix.          "JH/08.01.98/4.0C

*  PERFORM marc_bestaende_kumulieren USING t_matnr-matnr. " TGA/4.6 Erw.
  PERFORM marc_bestaende_kumulieren  TABLES pt_werks
                                    USING prt_matnr-matnr. " TGA/4.6 Erw.

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
* IF t_matnr-attyp = attyp_var.                      " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.

  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr " TGA/4.6 Erw.
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*   PERFORM marc_bestaende_kumulieren USING t_matnr-satnr. " TGA/4.6 E
      PERFORM marc_bestaende_kumulieren TABLES pt_werks
                                        USING prt_matnr-satnr. " TGA/4.6 E
    ENDIF.
  ENDIF.

*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*---- Lesen und kumulieren aller Lagerortbestände zu einem Werk -------*
* SELECT * FROM  MARD
*        WHERE  MATNR = MARC-MATNR
*        AND    WERKS = MARC-WERKS.
*   PERFORM MARD_BESTAENDE.
* ENDSELECT.
*JH/08.01.98/4.0C Performanceoptimierung (Anfang)
* LOOP AT T_MARD WHERE MATNR = T_MARC-MATNR
*                  AND WERKS = T_MARC-WERKS.
*   PERFORM MARD_BESTAENDE.
* ENDLOOP.
  READ TABLE t_mard WITH KEY matnr = t_marc-matnr
                             werks = t_marc-werks
                    BINARY SEARCH.
  IF sy-subrc = 0.
    MOVE sy-tabix TO hindex.
    LOOP AT t_mard FROM hindex.
      IF t_mard-matnr NE t_marc-matnr
      OR t_mard-werks NE t_marc-werks.
        EXIT.
      ENDIF.
      PERFORM mard_bestaende.
    ENDLOOP.
  ENDIF.
*JH/08.01.98/4.0C Performanceoptimierung (Ende)
*#JHL 14.05.96 (Ende)

ENDFORM.                               " MARC_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MARC_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Werksbestände in den interen Tabellen               *
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM marc_bestaende_kumulieren TABLES pt_werks STRUCTURE t_werks
                               USING pi_matnr LIKE mara-matnr.

  DATA: x_matnr LIKE t_matnr.  "Workarea für Zwischen-Read bei Sammelart
  DATA: tabix_alt LIKE sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
  READ TABLE prt_mbe WITH KEY matnr = pi_matnr BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_marc-umlmc TO prt_mbe-umlmc.
    ADD t_marc-trame TO prt_mbe-trame.
    ADD t_marc-glgmg TO prt_mbe-glgmg. "JH/4.0A/28.07.97
    MODIFY prt_mbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_mbe.
    MOVE-CORRESPONDING t_marc TO prt_mbe.
    IF t_marc-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält T_MARC-MATNR die --*
*---- Variante und nicht den Sammelartikel -> MBE-MATNR umsetzen     --*
      MOVE pi_matnr TO prt_mbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Mandantenebene bestimmen -----*
      tabix_alt = sy-tabix.
      READ TABLE prt_matnr INTO x_matnr
                         WITH KEY matnr = pi_matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.
      MOVE x_matnr-lvorm TO prt_mbe-lvorm.
      sy-tabix = tabix_alt.
    ELSE.
      MOVE prt_matnr-lvorm TO prt_mbe-lvorm.
      MOVE prt_matnr-satnr TO prt_mbe-satnr. "wg. besserem Zugriffsverh.
      "Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_mbe INDEX sy-tabix.
  ENDIF.

*---- Nur wenn Werksbestandsdaten vorhanden sind werden diese für -----*
*---- die Basiswerksgruppen und das Werk fortgeschrieben          -----*
  CHECK NOT t_marc-werks IS INITIAL.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
* SELECT SINGLE * FROM  T001W
*        WHERE  WERKS = MARC-WERKS.
* IF SY-SUBRC NE 0.
*   CLEAR T001W.
* ENDIF.
*
* SELECT SINGLE * FROM  T001K
*        WHERE  BWKEY = T001W-BWKEY.
* IF SY-SUBRC NE 0.
*   CLEAR T001K.
* ENDIF.
*
* READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                         BUKRS = T001K-BUKRS   BINARY SEARCH.
* IF SY-SUBRC EQ 0.
*   ADD  MARC-UMLMC  TO BBE-UMLMC.
*   ADD  MARC-TRAME  TO BBE-TRAME.
*   MODIFY BBE INDEX SY-TABIX.
* ELSE.
*   CLEAR BBE.
*   MOVE-CORRESPONDING MARC TO BBE.
*   MOVE T001K-BUKRS        TO BBE-BUKRS.
*   IF MARC-MATNR <> PI_MATNR.
*---- Falls Sammelartikel behandelt werden, enthält MARC-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> BBE-MATNR umsetzen ----*
*     MOVE PI_MATNR TO BBE-MATNR.
*   ELSE.
*     MOVE T_MATNR-SATNR TO BBE-SATNR. "wg. besserem Zugriffsverh. bei
*                                      "Matrixdarstellung f. Varianten
*   ENDIF.
*   INSERT BBE INDEX SY-TABIX.
* ENDIF.
*#jhl 31.01.96 (Ende)

*#jhl 16.07.96 (Anfang) Lesen der Werkszusatzdaten für den Fall, daß
* keine Werksselektion vorliegt, vorgezogen!
*---- Zuordnung Werk zur Basiswerksgruppe ermitteln:              -----*
*---- Fall1: Es wurde eine Werksselektion durchgeführt ->         -----*
*----        T_WERKS enthält bereits die Zuordnungseinträge       -----*
*---- Fall2: Es sollen alle Werke berücksichtigt werden ->        -----*
*----        Zu jedem Werk die Zuordnung bestimmen und die Basis- -----*
*----        werksgruppe in T_BWGRP hinterlegen (falls neu)       -----*
* IF NOT WERK_SEL IS INITIAL.
  READ TABLE pt_werks WITH KEY werks = t_marc-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'T_WERKS'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ENDIF.
* ELSE.
*   READ TABLE T_WERKS WITH KEY WERKS = T_MARC-WERKS BINARY SEARCH.
*   IF SY-SUBRC NE 0.
*     CLEAR T_WERKS.
*---- Werksbezeichnung nachlesen für WBE-Versorgung weiter unten ------*
*     SELECT SINGLE * FROM  T001W
*            WHERE  WERKS = T_MARC-WERKS.
*     IF SY-SUBRC NE 0.
*       MESSAGE A036 WITH T_MARC-WERKS.
*    Keine Stammdaten zum Werk & gefunden!
*     ENDIF.
*     T_WERKS-WERKS = T001W-WERKS.
*     T_WERKS-WRKBZ = T001W-NAME1.
*     T_WERKS-VLFKZ = T001W-VLFKZ.
*
*---- Zum Werk die Basiswerksgruppe bestimmen -------------------------*
*     PERFORM BWGRP_ZUM_WERK.
*
*     APPEND T_WERKS.
*   ENDIF.
* ENDIF.
*#jhl 16.07.96 (Ende)

  READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                          bwgrp = pt_werks-bwgrp   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD  t_marc-umlmc  TO prt_gbe-umlmc.
    ADD  t_marc-trame  TO prt_gbe-trame.
    ADD  t_marc-glgmg  TO prt_gbe-glgmg.   "JH/4.0A/28.07.97
    MODIFY prt_gbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_gbe.
    MOVE-CORRESPONDING t_marc TO prt_gbe.
    MOVE t_werks-bwgrp        TO prt_gbe-bwgrp.
    IF t_marc-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält T_MARC-MATNR die --*
*---- Variante und nicht den Sammelartikel -> GBE-MATNR umsetzen     --*
      MOVE pi_matnr TO prt_gbe-matnr.
    ELSE.
      MOVE prt_matnr-satnr TO prt_gbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_gbe INDEX sy-tabix.
  ENDIF.

*---- Aufnahme in Werkstabelle ----------------------------------------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Werkszuordnung ex., -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = t_marc-werks   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD  t_marc-umlmc  TO prt_wbe-umlmc.
    ADD  t_marc-trame  TO prt_wbe-trame.
    ADD  t_marc-glgmg  TO prt_wbe-glgmg.   "JH/4.0A/28.07.97
    MODIFY prt_wbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_wbe.
    MOVE-CORRESPONDING t_marc TO prt_wbe.
    MOVE pt_werks-wrkbz       TO prt_wbe-name1.
    MOVE pt_werks-bwgrp       TO prt_wbe-bwgrp.
    IF t_marc-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MARC-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> WBE-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_wbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Werksebene bestimmen ---------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*     SELECT SINGLE * FROM MARC INTO *MARC
*            WHERE  MATNR = PI_MATNR
*            AND    WERKS = MARC-WERKS.
*     IF SY-SUBRC = 0.
*       MOVE *MARC-LVORM TO WBE-LVORM.
*     ELSE.
*       CLEAR WBE-LVORM.
*     ENDIF.
      tabix_alt = sy-tabix.
      READ TABLE t_marc INTO marc
                        WITH KEY matnr = pi_matnr
                                 werks = t_marc-werks
                        BINARY SEARCH.
      IF sy-subrc = 0.
        MOVE marc-lvorm TO prt_wbe-lvorm.
      ELSE.
        CLEAR prt_wbe-lvorm.
      ENDIF.
      sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
    ELSE.
      MOVE prt_matnr-satnr TO prt_wbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_wbe INDEX sy-tabix.
  ENDIF.
ENDFORM.                               " MARC_BESTAENDE_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  MARD_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der Lagerortbestände in den interen Tabellen.           *
*    2) Falls das Material eine Variante ist, werden auch die Best.    *
*       für den zugehörenden Sammelartikel fortgeschrieben.            *
*----------------------------------------------------------------------*
FORM mard_bestaende.
  DATA: hindex LIKE sy-tabix.

*  PERFORM mard_bestaende_kumulieren USING t_matnr-matnr. " TGA/4.6 Erw.
  PERFORM mard_bestaende_kumulieren USING prt_matnr-matnr. " TGA/4.6 Erw

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                     " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. L

  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*    PERFORM mard_bestaende_kumulieren USING t_matnr-satnr. " TGA/4.6 Er
      PERFORM mard_bestaende_kumulieren USING prt_matnr-satnr.  " TGA/4.6
    ENDIF.
  ENDIF.

  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
    READ TABLE t_mchb WITH KEY matnr = t_mard-matnr
                               werks = t_mard-werks
                               lgort = t_mard-lgort
                               BINARY SEARCH.
    IF sy-subrc = 0.
      MOVE sy-tabix TO hindex.
      LOOP AT t_mchb FROM hindex.
        IF t_mchb-matnr NE t_mard-matnr
        OR t_mchb-werks NE t_mard-werks
        OR t_mchb-lgort NE t_mard-lgort.
          EXIT.
        ENDIF.
        PERFORM mchb_bestaende.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.                               " MARD_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MARD_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Lagerortbestände in den interen Tabellen            *
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mard_bestaende_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Festhalten der Lagerortbestände ---------------------------------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher LGOrtzuordnung ex., -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                              werks = t_mard-werks
                              lgort = t_mard-lgort   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_mard-labst TO prt_lbe-labst.
    ADD t_mard-umlme TO prt_lbe-umlme.
    ADD t_mard-insme TO prt_lbe-insme.
    ADD t_mard-einme TO prt_lbe-einme.
    ADD t_mard-speme TO prt_lbe-speme.
    ADD t_mard-klabs TO prt_lbe-klabs.
    ADD t_mard-kinsm TO prt_lbe-kinsm.
    ADD t_mard-keinm TO prt_lbe-keinm.
    ADD t_mard-kspem TO prt_lbe-kspem.
    ADD t_mard-retme TO prt_lbe-retme.
    MODIFY prt_lbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_lbe.
    MOVE-CORRESPONDING t_mard TO prt_lbe.
    IF t_marc-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält T_MARC-MATNR die --*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen     --*
      MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*     SELECT SINGLE * FROM MARD INTO *MARD
*            WHERE  MATNR = PI_MATNR
*            AND    WERKS = MARD-WERKS
*            AND    LGORT = MARD-LGORT.
*     IF SY-SUBRC = 0.
*       MOVE *MARD-LVORM TO LBE-LVORM.
*     ELSE.
*       CLEAR LBE-LVORM.
*     ENDIF.
      tabix_alt = sy-tabix.
      READ TABLE t_mard INTO mard
                        WITH KEY matnr = pi_matnr
                                 werks = t_mard-werks
                                 lgort = t_mard-lgort
                        BINARY SEARCH.
      IF sy-subrc = 0.
        MOVE mard-lvorm TO prt_lbe-lvorm.
      ELSE.
        CLEAR prt_lbe-lvorm.
      ENDIF.
      sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
    ELSE.
      MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_lbe INDEX sy-tabix.
  ENDIF.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = t_mard-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_mard-labst TO prt_wbe-labst.
    ADD t_mard-umlme TO prt_wbe-umlme.
    ADD t_mard-insme TO prt_wbe-insme.
    ADD t_mard-einme TO prt_wbe-einme.
    ADD t_mard-speme TO prt_wbe-speme.
    ADD t_mard-klabs TO prt_wbe-klabs.
    ADD t_mard-kinsm TO prt_wbe-kinsm.
    ADD t_mard-keinm TO prt_wbe-keinm.
    ADD t_mard-kspem TO prt_wbe-kspem.
    ADD t_mard-retme TO prt_wbe-retme.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MARD-LABST TO BBE-LABST.
*     ADD MARD-UMLME TO BBE-UMLME.
*     ADD MARD-INSME TO BBE-INSME.
*     ADD MARD-EINME TO BBE-EINME.
*     ADD MARD-SPEME TO BBE-SPEME.
*     ADD MARD-KLABS TO BBE-KLABS.
*     ADD MARD-KINSM TO BBE-KINSM.
*     ADD MARD-KEINM TO BBE-KEINM.
*     ADD MARD-KSPEM TO BBE-KSPEM.
*     ADD MARD-RETME TO BBE-RETME.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD t_mard-labst TO prt_gbe-labst.
      ADD t_mard-umlme TO prt_gbe-umlme.
      ADD t_mard-insme TO prt_gbe-insme.
      ADD t_mard-einme TO prt_gbe-einme.
      ADD t_mard-speme TO prt_gbe-speme.
      ADD t_mard-klabs TO prt_gbe-klabs.
      ADD t_mard-kinsm TO prt_gbe-kinsm.
      ADD t_mard-keinm TO prt_gbe-keinm.
      ADD t_mard-kspem TO prt_gbe-kspem.
      ADD t_mard-retme TO prt_gbe-retme.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD t_mard-labst TO prt_mbe-labst.
        ADD t_mard-umlme TO prt_mbe-umlme.
        ADD t_mard-insme TO prt_mbe-insme.
        ADD t_mard-einme TO prt_mbe-einme.
        ADD t_mard-speme TO prt_mbe-speme.
        ADD t_mard-klabs TO prt_mbe-klabs.
        ADD t_mard-kinsm TO prt_mbe-kinsm.
        ADD t_mard-keinm TO prt_mbe-keinm.
        ADD t_mard-kspem TO prt_mbe-kspem.
        ADD t_mard-retme TO prt_mbe-retme.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " MARD_BESTAENDE_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  MAT_SEL_KORRIGIEREN
*&---------------------------------------------------------------------*
*       Nachlesen von Varianten zu Sammelartikeln und Löschen von Art.
*       <> Sammelartikel, falls der Einstieg über eine Warengruppe mit
*       Merkmalseinschränkungen erfolgte
*----------------------------------------------------------------------*
FORM mat_sel_korrigieren.

  DATA: BEGIN OF x_makt OCCURS 0.      "Liste der Materialkurztexte
          INCLUDE STRUCTURE makt.
  DATA: END   OF x_makt.

  DATA: anz_mat      LIKE sy-tabix.

  DATA: lv_t_mara_filled TYPE abap_bool.                  "note 2732723

*---- Falls Einschränkungen bzgl. Merkmalswerten erfolgte, werden -----*
*---- die überflüssigen Merkmalswerte herausgelöscht              -----*
  IF NOT merkm_sel IS INITIAL.
    LOOP AT t_merkm_stat WHERE selek = 'X'.
      PERFORM delete_merkm_werte USING t_merkm_stat-atinn.
    ENDLOOP.
  ENDIF.
*#JHL 19.08.96 Einschränkung bzgl. Anzahl der var.bild. Merkm. aufgehob.
* IF ( MERKM_SEL = MERKM_1 )
* OR ( MERKM_SEL = MERKM_1U2 ).
*   READ TABLE T_MERKM INDEX 1.
*   IF SY-SUBRC NE 0.
*     MESSAGE A038 WITH 'T_MERKM'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*   ENDIF.
*
*   PERFORM DELETE_MERKM_WERTE USING T_MERKM-ATINN.
* ENDIF.
*
* IF ( MERKM_SEL = MERKM_2 )
* OR ( MERKM_SEL = MERKM_1U2 ).
*   READ TABLE T_MERKM INDEX 2.
*   IF SY-SUBRC NE 0.
*     MESSAGE A038 WITH 'T_MERKM'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
*   ENDIF.
*
*   PERFORM DELETE_MERKM_WERTE USING T_MERKM-ATINN.
* ENDIF.

*---- Falls unter den selektierten Materialien Sammelartikel vorh. ----*
*---- sind, müssen zu diesen alle relev. Varianten ermitt. werden  ----*
  korr_anz_sel_mat = 0.
  CLEAR gv_message_counter.                               "note 2687150

  SORT t_matnr BY matnr.                                  "note 2726544
  DELETE ADJACENT DUPLICATES FROM t_matnr COMPARING matnr."note 2726544
  anz_sel_mat = lines( t_matnr ).                                       " n_2749155
  t_matnr_hlp[] = t_matnr[].                                            " n_2749155

  CLEAR lv_t_mara_filled.                                 "note 2732723

*d LOOP AT t_matnr FROM 1 TO anz_sel_mat.  "nur bereits vorh. Einträge  " n_2749155
                                           "durchlaufen, nicht neu hin-
                                           "zukommende
  LOOP AT t_matnr.                                                      " n_2749155
    IF t_matnr-attyp = attyp_sam.
*---- Zum Sammelartikel alle betroffenen Varianten ermitteln ----------*

      IF lv_t_mara_filled IS INITIAL.                   "v note 2732723 " n_2749155
          REFRESH t_mara.

          SELECT * FROM  mara INTO TABLE t_mara
            FOR ALL ENTRIES IN t_matnr
            WHERE  satnr = t_matnr-matnr
            AND    attyp = attyp_var.
          SORT t_mara BY satnr.
          lv_t_mara_filled = 'X'.
        ENDIF.                                          "^ note 2732723

      IF merkm_sel IS INITIAL.
        PERFORM var_ohne_merkm_einschr.
      ELSE.
        PERFORM var_mit_merkm_einschr.
      ENDIF.
ENHANCEMENT-POINT RWBE1F02_03 SPOTS ES_RWBEST01 .

    ENDIF.
  ENDLOOP.

  t_matnr[] = t_matnr_hlp[].                                            " n_2749155

  IF gv_message_counter IS NOT INITIAL.                   "note 2687150
    MESSAGE i104 WITH gv_message_counter.                 "note 2687150
  ENDIF.                                                  "note 2687150

*---- Anzahl der selektierten plus der evtl. nachselektierten Mat. ----*
*---- inkl. etwaiger doppelter Varianteneinträge                   ----*
  DESCRIBE TABLE t_matnr LINES anz_mat.

"  SORT t_matnr BY matnr.                                  note 2726544
*---- Duplikate löschen, wenn z.B. Variante einzeln über Selektions- --*
*---- liste und über Nachlesen beim Sammelartikel reinläuft          --*
"  DELETE ADJACENT DUPLICATES FROM t_matnr COMPARING matnr.note 2726544

*---- Anzahl der selektierten plus der evtl. nachselektierten Mat. ----*
*---- ohne etwaige doppelte Varianteneinträge                      ----*
  DESCRIBE TABLE t_matnr LINES anz_mat_ges.

*---- Anzahl der selektierten Materialien wird um die Anzahl der  -----*
*---- einzeln selektierten Varianten verringert damit diese nicht -----*
*---- bei der Anzeige der Bestandsdaten zu einer Materialliste    -----*
*---- auftauchen können und verringert um die Anzahl evtl. ge-    -----*
*---- löschter Sammelartikel zu denen keine Variante mit paßender -----*
*---- Merkmalsbewertung gefunden wurde.                           -----*
*---- Sollten keine Materialien mehr übrigbleiben, muß eine ent-  -----*
*---- sprechende Meldung erfolgen                                 -----*
  anz_sel_mat = anz_sel_mat - anz_mat + anz_mat_ges - korr_anz_sel_mat.
  IF anz_sel_mat = 0.  "Kann nur bei Sammelartikeln auftreten
    IF NOT merkm_sel IS INITIAL.       "JH/16.10.96
      MESSAGE s041.
*    Zu diesen Merkmalsbewertungsdaten liegen keine Varianten vor
    ELSE.                              "JH/16.10.96
      MESSAGE s011.                    "JH/16.10.96
*   Zur angegebenen Materialselekt. konnten keine Materialien gefunden w
    ENDIF.                             "JH/16.10.96
    PERFORM neustart_fehler.
  ENDIF.

ENHANCEMENT-POINT RWBE1F02_G7 SPOTS ES_RWBEST01 .


*---- Materialkurztext zu allen vorliegenden Materialien ermitteln ----*
*---- und ablegen                                                  ----*
  SELECT * FROM makt INTO TABLE x_makt
         FOR ALL ENTRIES IN t_matnr
         WHERE  matnr = t_matnr-matnr
         AND    spras = sy-langu.

  LOOP AT x_makt.
    READ TABLE t_matnr WITH KEY matnr = x_makt-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    t_matnr-maktx = x_makt-maktx.
ENHANCEMENT-POINT RWBE1F02_G6 SPOTS ES_RWBEST01 .

    MODIFY t_matnr INDEX sy-tabix.
  ENDLOOP.

ENDFORM.                               " MAT_SEL_KORRIGIEREN

*&---------------------------------------------------------------------*
*&      Form  INIT_BESTANDS_ANZEIGE
*&---------------------------------------------------------------------*
*       Initialisierungen für die Anzeige der Bestandsdaten.
*       Falls sich die Materialselektionsliste auf einen einzelnen
*       Sammelartikel reduziert, müssen für diesen die Merkmalsdaten
*       nachgelesen werden
*----------------------------------------------------------------------*
FORM init_bestands_anzeige.

*---- Festlegen der Anzeigestufe für den Einstieg in die Darstellung --*
*---- der Bestandswerte                                              --*
  IF anz_sel_mat = 1.
*---- Anzeige aller Bestände eines einzelnen Artikels -----------------*
    drilldown_level = einzart_level.

*---- Falls eine Artikelleiste eingegeben wurde, und diese nur einen  -*
*---- Sammelartikel und dessen zugehörige Varianten enthält, wird aus -*
*---- der Artikelliste ein einzelner Sammelartikel, zu dem noch evtl. -*
*---- die Merkmalsdaten nachgelesen werden müssen.                    -*
*---- Evtl. wurden noch keine Merkmale gelesen, dann müssen alle     --*
*---- variantenbildenden Merkmale zum Sammelartikel gelesen werden.  --*
*---- Erfolgte der Einstieg über eine Warengruppe mit Einschränkung  --*
*---- bzgl. der Merkmalswerte und sind weitere variantenbildende     --*
*---- Merkmale auf einer tieferliegenden Ebene definiert, so müssen  --*
*---- die fehlenden Merkmale noch nachgelesen werden                 --*
    READ TABLE t_matnr WITH KEY attyp = attyp_sam.
    IF sy-subrc = 0.
      PERFORM merkmale_nachlesen.
    ENDIF.
  ELSE.
*---- Anzeige der Gesamtbestände für eine Liste von Artikeln ----------*
    drilldown_level = artlist_level.
  ENDIF.

*---- Startlevel merken für einen etwaigen Rücksprung von der Grund- --*
*---- liste zum Einzelartikel auf die Grundliste zu einer Art.liste  --*
  start_dd_level = drilldown_level.

*---- Defaultmäßig wird in der Bestandsliste zu der Artikelliste ------*
*---- die Bezeichnung des Artikels angezeigt                     ------*
  anzeige_art_l = anz_art_bez.

*---- Defaultmäßig wird in der Bestandsliste zum Einzelartikel oder  --*
*---- der Einzelvariante die Bezeichnung d. Basiswerksgrp. angezeigt --*
  anzeige_art_e = anz_art_bez.

*---- Nächste Umschaltungsmöglichkeit für die Anzeige des Artikel-/ ---*
*---- Werksgruppentextes setzen zur Übergabe an PF-STATUS           ---*
  REFRESH t_fcodes_e.
  MOVE anbe TO t_fcodes_e-fcode.
  APPEND t_fcodes_e.
  MOVE anbn TO t_fcodes_e-fcode.
  APPEND t_fcodes_e.
*TGA/4.6 Erweiterungen Lot (START)
* MOVE stru TO t_fcodes_e-fcode.
* APPEND t_fcodes_e.
*TGA/4.6 Erweiterungen Lot (END)
  MOVE anbe TO t_fcodes_l-fcode.
  APPEND t_fcodes_l.
  MOVE anbn TO t_fcodes_l-fcode.
  APPEND t_fcodes_l.

ENDFORM.                               " INIT_BESTANDS_ANZEIGE

*&---------------------------------------------------------------------*
*&      Form  MENGENEINHEITEN_LESEN
*&---------------------------------------------------------------------*
*       Die möglichen Mengeneinheiten zu den Artikeln ermitteln
*----------------------------------------------------------------------*
*FORM mengeneinheiten_lesen.
FORM mengeneinheiten_lesen TABLES pt_matnr STRUCTURE t_matnr.

  DATA: x_matnr LIKE t_matnr.  "Workarea für Zwischen-Read bei Sammelart

  REFRESH: t_pre03, x_meeinh, t_meeinh, t_metext.
  CLEAR:   t_pre03, x_meeinh, t_meeinh, t_metext.

*---- Prefetchstruktur belegen ----------------------------------------*
  MOVE pt_matnr-matnr TO t_pre03-matnr.
  APPEND t_pre03.
*#JHL 13.05.96 (Anfang) Keine abweichenden ME's bei Var. gg.über SA
* IF T_MATNR-ATTYP = ATTYP_SAM.
*---- (bei Sammelartikel auch die Varianten hinterlegen) --------------*
*   LOOP AT T_MATNR INTO X_MATNR WHERE SATNR = T_MATNR-MATNR.
*     MOVE X_MATNR-MATNR TO T_PRE03-MATNR.
*     APPEND T_PRE03.
*   ENDLOOP.
* ENDIF.
*#JHL 13.05.96 (Ende)

*---- Prefetch auf MARM ist notwendig, damit beim Function-Call von ---*
*---- 'MATERIAL_UNIT_FIND_30' alle möglichen ME's gefunden werden   ---*
  CALL FUNCTION 'MATERIAL_PRE_READ_MARM'
    TABLES
      ipre03 = t_pre03.

*---- Mögl. Mengeneinheiten zu den betroffenen Materialien ermitteln --*
*---- (d.h. alle angelegten (MARM) und alle definierten (T006), zu   --*
*---- denen eine Umrechnung hergeleitet werden kann)                 --*
  PERFORM me_zum_material USING pt_matnr.
  IF pt_matnr-attyp = attyp_sam.
    LOOP AT pt_matnr INTO x_matnr WHERE satnr = pt_matnr-matnr.
*#JHL 13.05.96 (Anfang) Keine abweichenden ME's bei Var. gg.über SA
*     PERFORM ME_ZUM_MATERIAL USING X_MATNR.
      LOOP AT t_meeinh WHERE matnr = pt_matnr-matnr.
        t_meeinh-matnr = x_matnr-matnr.
        APPEND t_meeinh.
      ENDLOOP.
*#JHL 13.05.96 (Ende)
    ENDLOOP.

    SORT t_meeinh BY matnr meinh.
  ENDIF.

ENDFORM.                               " MENGENEINHEITEN_LESEN


*&---------------------------------------------------------------------*
*&      Form  BESTANDSDATEN_LESEN
*&---------------------------------------------------------------------*
*       Lesen und Belegen der Bestandsdaten zu den vorliegenden Artikeln
*       For Retail on Hana (note 1876946) the following table acessed where
*       optimized:
*        - MARC, MARD, MABEW
*        - MKOL, MSKA, MSLB, MSKU
*----------------------------------------------------------------------*
*FORM BESTANDSDATEN_LESEN.
*TGA/4.6 Erweiterungen Lot (START)
FORM bestandsdaten_lesen TABLES pt_matnr STRUCTURE t_matnr
                                pt_werks STRUCTURE t_werks
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
                                pt_ek_vk STRUCTURE ek_vk
                                pt_cbe STRUCTURE cbe
                                pt_wbs_seg STRUCTURE wbs_seg.
*TGA/4.6 Erweiterungen Lot (END)

  CONSTANTS: lc_sql_limit TYPE i VALUE 10000.

  DATA: sy_tabix  LIKE sy-tabix,
        anz_werke LIKE sy-tfill,
        text_xxx(30),
        lr_db_opt_badi  TYPE REF TO rwbe_db_optimizations,
        lt_open_sto_qty TYPE if_rwbe_dbsys_opt=>tt_open_sto.
*       Table that stores only articles NE generic article
  DATA: BEGIN OF lt_matnr OCCURS 0.
          INCLUDE STRUCTURE t_matnr.
  DATA: END   OF lt_matnr.

*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* REFRESH: MBE, BBE, WBE, LBE, EBS, KBE, MPS, OBS, VBS, WBS, OEB, EK_VK.
*TGA/4.6 Erweiterungen Lot (START)
* REFRESH: MBE, GBE, WBE, LBE, EBS, KBE, MPS, OBS, VBS, WBS, OEB, EK_VK.
  prt_matnr[] = pt_matnr[].
  prt_matnr = pt_matnr.

  REFRESH: prt_mbe, prt_gbe, prt_wbe, prt_lbe, prt_ebs, prt_kbe,
           prt_mps, prt_obs, prt_vbs, prt_wbs, prt_oeb, prt_ek_vk,
           prt_cbe, prt_wbs_seg.

*TGA/4.6 Erweiterungen Lot (END)
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
      OTHERS     = 1.

  PERFORM prefetch_marc_mard_mbew TABLES pt_werks.
*-----TGA/4.6 Erw. >19990510
  IF nbwrk_done = no.
    PERFORM nachbearbeitung_werke.
    nbwrk_done = yes.
  ENDIF.
  DESCRIBE TABLE pt_werks LINES anz_werke.


*---- Bestandsdaten pro Material ermitteln und ablegen ----------------*
*  LOOP AT t_matnr WHERE attyp NE attyp_sam.     " TGA/4.6 Erw. Lot
  LOOP AT prt_matnr WHERE attyp NE attyp_sam.   " TGA/4.6 Erw. Lot
    sy_tabix = sy-tabix.

*---- 1) Einlesen aller Bestände aus Materialstammdatensegmenten ------*

*---- MARC- und MARD-Bestandsdaten lesen und ablegen         ----------*
*---- (inkl. fremdem Sonderbestand: Lieferantenkonsignation) ----------*
*    PERFORM stammdaten_bestaende.    "TGA/4.6 Erw. >19990510
    PERFORM stammdaten_bestaende TABLES pt_werks.

*---- MBEW-Bestandsdaten lesen und ablegen ----------------------------*
*---- (wertmäßiger Bestand)                ----------------------------*
    IF ( anz_werke > 0 ).
      PERFORM ek_vk_bestaende.
    ENDIF.

    IF  ( NOT p_kzlso IS INITIAL )
    AND ( anz_werke > 0 ).
**---- MSKA-Bestandsdaten lesen und ablegen   --------------------------*
**---- (fremder Sonderbestand: Kundenauftrag) --------------------------*
*      PERFORM kundenauftr_bestaende.

**---- MKOL-Bestandsdaten lesen und ablegen (1) ------------------------*
**---- (fremder Sonderbestand: Lieferantenkonsi ------------------------*
** Anmerkung: Lieferantenkonsi-Bestände werden sowohl in MARD als auch
** in MKOL unter der Sonderbestandsart 'K' abgelegt (-> traditionelle
** Gründe) -> Nachlesen aus MKOL zur Ablage in KBE
*      PERFORM liefkonsi_bestaende.

**---- MKOL-Bestandsdaten lesen und ablegen (2)        -----------------*
**---- (fremder Sonderbestand: Lieferantenleergut/-MTV -----------------*
*      PERFORM liefmtv_bestaende.

*---- MSPR-Bestandsdaten lesen und ablegen ----------------------------*
*---- (fremder Sonderbestand: Projekt      ----------------------------*
*   PERFORM MSPR_BESTAENDE.  ????uninteressant für Retail?

**---- MSLB-Bestandsdaten lesen und ablegen           ------------------*
**---- (eigener Sonderbestand: Lieferantenbeistellung ------------------*
*      PERFORM liefbeist_bestaende.

**---- MSKU-Bestandsdaten lesen und ablegen                         ----*
**---- (eigener Sonderbestand: Kundenkonsignation und Kundenleergut ----*
*      PERFORM kunden_bestaende.

*<<< hier weitere Sonderbestände einlesen
    ENDIF.

*---- 2) Einlesen aller Online-Bestandsdaten über Belegauswertungen ---*
*TGA/24.02.99***********************************************************
    IF  ( NOT p_kzlon IS INITIAL )
    AND ( anz_werke > 0 ).
      TRY.
          GET BADI lr_db_opt_badi FILTERS dbsys_type = cl_db_sys=>dbsys_type.
        CATCH cx_badi_not_implemented.

*-------- EKPO-Bestandsdaten lesen und ablegen    -------------------------*
*-------- (offene Bestellmenge/Konsibestellmenge) -------------------------*
          PERFORM offene_bestellungen.

*-------- EKUB-Bestandsdaten lesen und ablegen                    ---------*
*-------- (Abrufmenge der Umlagerungsbestellungen auf Werksebene) ---------*
          PERFORM offene_umlagerung.

      ENDTRY.

**---- TRASF-Bestandsdaten lesen und ablegen             ---------------*
**---- (Cross-Company-Umlagerungsbestand auf Werksebene) ---------------*
**---- (= Transitbestand bei buchungskreisübergreifenden Umlagerungen) -*
      IF ( lines( prt_matnr[] ) + lines( r_werks[] ) ) > lc_sql_limit.  " n_2387753
        PERFORM crosscomp_umlagerung.
      ENDIF.

*---- WESPB-Bestandsdaten lesen und ablegen ---------------------------*
*---- (WE-Sperrbestand auf Werksebene)      ---------------------------*
      PERFORM we_sperrbestand.

*---- RESB-Bestandsdaten lesen und ablegen                   ----------*
*---- (Reservierungen (geplante Abgänge) / geplante Zugänge) ----------*
      PERFORM ab_zu_reservierung.

*---- VBBE-Bestandsdaten lesen und ablegen ----------------------------*
*---- (Vertriebsbedarfe für Kunden)        ----------------------------*
      PERFORM vertriebs_bedarfe.
    ENDIF.

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
          OTHERS     = 1.
    ENDIF.

  ENDLOOP.



*---------------------------------------------------------------------------------------
*  Prefetch Logic for Retail on Hana Optimisations
*  stock commitments and special stock should be read for all material/plants once
*  must be executed after the loop because the FORM STAMMDATEN_BESTAEDE creates the records in MBE, GBE and WBE
*  therefore only after this FORM a call of the new colletion FORMS are possible.
*---------------------------------------------------------------------------------------

* Read Read Special Stocks - for all selected Material/Plants?
  IF  ( NOT p_kzlso IS INITIAL )
  AND ( anz_werke > 0 ).
*-- MSKA-Bestandsdaten lesen und ablegen   ----------------------------*
*-- (fremder Sonderbestand: Kundenauftrag) ----------------------------*
    PERFORM kundenauftr_bestaende_all.

*--- MKOL-Bestandsdaten lesen und ablegen (1) -------------------------*
*-- (fremder Sonderbestand: Lieferantenkonsi --------------------------*
*   Anmerkung: Lieferantenkonsi-Bestände werden sowohl in MARD als auch
*   in MKOL unter der Sonderbestandsart 'K' abgelegt (-> traditionelle
*   Gründe) -> Nachlesen aus MKOL zur Ablage in KBE
    PERFORM liefkonsi_bestaende_all.

*-- MKOL-Bestandsdaten lesen und ablegen (2)        -------------------*
*-- (fremder Sonderbestand: Lieferantenleergut/-MTV -------------------*
    PERFORM liefmtv_bestaende_all.

*-- MSLB-Bestandsdaten lesen und ablegen           --------------------*
*-- (eigener Sonderbestand: Lieferantenbeistellung --------------------*
    PERFORM liefbeist_bestaende_all.

*-- MSKU-Bestandsdaten lesen und ablegen                         ------*
*-- (eigener Sonderbestand: Kundenkonsignation und Kundenleergut ------*
    PERFORM kunden_bestaende_all.
  ENDIF.

* Read Stock Commitments - for all selected Material/Plants?
  IF  ( NOT p_kzlon IS INITIAL )
  AND ( anz_werke > 0 ).
    IF lr_db_opt_badi IS BOUND.

*     Read Stock Comitments not for articles of attyp EQ 01 (generic articles)
      lt_matnr[] = prt_matnr[].
      delete lt_matnr where attyp = attyp_sam.
*---- EKPO-Bestandsdaten lesen und ablegen    -------------------------*
*---- (offene Bestellmenge/Konsibestellmenge) -------------------------*
      CALL BADI lr_db_opt_badi->read_open_po_quantity
        EXPORTING
          it_matnr   = lt_matnr[]    " Table of Materials
          it_werks   = t_werks[]     " Table of Plant
        CHANGING
          ct_open_po = xtab[].

      PERFORM offene_bestellungen_all.

**---- EKUB-Bestandsdaten lesen und ablegen                    ---------*
**---- (Abrufmenge der Umlagerungsbestellungen auf Werksebene) ---------*
      CALL BADI lr_db_opt_badi->read_open_stk_transp_order_qty
        EXPORTING
          it_matnr        = lt_matnr[]    " Table of Materials
          it_werks        = t_werks[]     " Table of Plant
        CHANGING
          ct_open_sto_qty = lt_open_sto_qty[].

      PERFORM offene_umlagerung_all TABLES lt_open_sto_qty.
    ENDIF.

*-- TRASF-Bestandsdaten lesen und ablegen             -----------------*
*-- (Cross-Company-Umlagerungsbestand auf Werksebene) -----------------*
*-- (= Transitbestand bei buchungskreisübergreifenden Umlagerungen) ---*
    IF ( lines( prt_matnr[] ) + lines( r_werks[] ) ) <= lc_sql_limit.   " n_2387753
      PERFORM crosscomp_umlagerung_all.
    ENDIF.

  ENDIF.


*---------------------------------------------------------------------------------------
*  END OF Prefetch Logic for Retail on Hana Optimisations
*---------------------------------------------------------------------------------------

ENHANCEMENT-POINT RWBE1F02_G5 SPOTS ES_RWBEST01 .

*---- Die nicht sortiert abgelegten Tabellen sortieren ----------------*
  SORT ebs BY matnr werks lgort vbeln posnr.

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
  pt_cbe[]   = prt_cbe[].
  pt_wbs_seg[] = prt_wbs_seg[].
ENDFORM.                               " BESTANDSDATEN_LESEN

* (Form CROSSCOMP_UMLAGERUNG is replaced by CROSSCOMP_UMLAGERUNG_ALL)
* Still needed if a lot of materials/plants are selected                " n_2387753
*&---------------------------------------------------------------------*
*&      Form  CROSSCOMP_UMLAGERUNG
*&---------------------------------------------------------------------*
*       TRASF-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM crosscomp_umlagerung.

*--- Lesen und kumulieren der Cross-Company-Umlagerungsbestände -------*
* Anmerkung:
* Auch zum Sammelartikel können offene Bestelldaten vorliegen. Insgesamt
* können nur folgende beiden Konstellationen auftreten:
* 1) in der Bestellung werden nur die Varianten ohne Bezug zu einem
*    Sammelartikel erfaßt.
* 2) in der Bestellung wird der Sammelartikel und die Aufteilung der
*    Bestellmenge auf die Varianten erfaßt
* -> eine gesonderte Suche über den Sammelartikel entfällt somit, da es
*    nicht vorkommt, daß nur ein Sammelartikel in einer Bestellung auf-
*    taucht.

* New interface and functionality.                   24.01.1999, D026337

* CLEAR XTAB6. REFRESH XTAB6.
*  CALL FUNCTION 'MB_ADD_TRANSFER_QUANTITY'
*       EXPORTING
*            X_ELIKZ = SPACE
*            X_LOEKZ = SPACE
*            X_MATNR = T_MATNR-MATNR
*            X_MEINS = T_MATNR-BASME
*       TABLES
*            XTAB6   = XTAB6
*            XWERKS  = R_WERKS
*       EXCEPTIONS
*            OTHERS  = 1.

*  RANGES: xmatnr FOR t_matnr-matnr,        " TGA/4.6 Erw. Lot
  RANGES: xmatnr FOR prt_matnr-matnr,  " TGA/4.6 Erw. Lot
          xpstyp FOR ekpo-pstyp,
          xelikz FOR ekpo-elikz,
          xloekz FOR ekpo-loekz.
  REFRESH: xmatnr, xpstyp, xelikz, xloekz.
  xmatnr-sign   = xpstyp-sign   = xelikz-sign   = xloekz-sign   = 'I'.
  xmatnr-option = xpstyp-option = xelikz-option = xloekz-option = 'EQ'.
*  xmatnr-low = t_matnr-matnr. APPEND xmatnr.    " TGA/4.6 Erw. Lot
  xmatnr-low = prt_matnr-matnr. APPEND xmatnr.   " TGA/4.6 Erw. Lot
  xpstyp-low = '0'.           APPEND xpstyp.  " only cross company transit
  xelikz-low = ' '.           APPEND xelikz.
  xloekz-low = ' '.           APPEND xloekz.

  CALL FUNCTION 'MB_ADD_TRANSFER_QUANTITY'
    EXPORTING
      cumulate = 'X'
    TABLES
      xmatnr   = xmatnr
      xwerks   = r_werks
*     XRESWK   =
*     XSOBKZ   =
      xpstyp   = xpstyp
      xelikz   = xelikz
      xloekz   = xloekz
      xtab6    = xtab6.

  LOOP AT xtab6.
    PERFORM trasf_bestaende.
  ENDLOOP.

ENDFORM.                               " CROSSCOMP_UMLAGERUNG

*&---------------------------------------------------------------------*
*&      Form  VAR_MIT_MERKM_EINSCHR
*&---------------------------------------------------------------------*
*       Varianten mit Berücksichtigung der Einschränkung der Merkmals-
*       werte ermitteln
*----------------------------------------------------------------------*
FORM var_mit_merkm_einschr.
DATA: t_mara_hlp LIKE TABLE OF t_mara WITH HEADER LINE.                 " n_2749155
*d REFRESH t_mara.                                                      " n_2749155
*d SELECT * FROM mara INTO TABLE t_mara "Potentielle Varianten lesen
*d        WHERE  satnr = t_matnr-matnr
*d        AND    attyp = attyp_var.

  READ TABLE t_mara WITH KEY satnr = t_matnr-matnr                      " n_2749155
                             attyp = attyp_var
                             TRANSPORTING NO FIELDS
                             BINARY SEARCH.
  IF sy-subrc NE 0.
* Anlegen von SA's ohne Var. inzwischen erlaubt             "JH/16.10.96
*   MESSAGE A025 WITH T_MATNR-MATNR.                        "JH/16.10.96
*    MESSAGE i025 WITH t_matnr-matnr.   "JH/16.10.96      "note 2687150
*    Zum Sammelartikel & existieren keine Varianten!
    gv_message_counter = gv_message_counter + 1.          "note 2687150
  ELSE.                                "JH/16.10.96
    LOOP AT t_mara ASSIGNING FIELD-SYMBOL(<ls_mara>) FROM sy-tabix.     " n_2749155
      IF <ls_mara>-satnr NE t_matnr-matnr.
        EXIT.
      ENDIF.
      APPEND <ls_mara> TO t_mara_hlp.
    ENDLOOP.
*---- Merkmalsbewertungen zu den Varianten lesen ----------------------*
    PERFORM lese_var_bewertung TABLES t_mara_hlp.                       " n_2749155

*---- Alle Varianten, bei denen die Merkmalswerteeinschränkung nicht --*
*---- greift, aus der Trefferliste herauslöschen                     --*
    LOOP AT t_ausp.
      IF t_ausp-atwrt IS INITIAL.
*---- Test für numerischen Merkmalswert -------------------------------*
        READ TABLE t_bewert WITH KEY atinn = t_ausp-atinn
                                     atflv = t_ausp-atflv.
* Anmerkung: BINARY SEARCH nicht möglich, weil bzgl. ATZHL nicht ge-
*            testet werden kann (T_AUSP-ATZHL nicht belegt)
      ELSE.
*---- Test für nicht numerischen Merkmalswert -------------------------*
        READ TABLE t_bewert WITH KEY atinn = t_ausp-atinn
                                     atwrt = t_ausp-atwrt.
* Anmerkung: BINARY SEARCH nicht möglich, weil bzgl. ATZHL nicht ge-
*            testet werden kann (T_AUSP-ATZHL nicht belegt)
      ENDIF.
      IF sy-subrc NE 0.
* JH/03.08.98/4.5B/KPr51331 (Anfang)
*       Wenn nicht der angegebene Merkmalswert gefunden wird, prüfen,
*       ob zu diesem Merkmal überhaupt Werte vorhanden sind. Wenn keine
*       Werte vorhanden sind, muß es sich um ein Merkmal mit Referenz-
*       tabelle/Zugriffs-FB sein und es wurde keine Werteeinschränkung
*       vorgenommen.
*       DELETE T_MARA WHERE CUOBF = T_AUSP-OBJEK.
        READ TABLE t_bewert WITH KEY atinn = t_ausp-atinn BINARY SEARCH.
        IF sy-subrc = 0.
*         Merkmal hat Werte -> Artikel fliegt raus
          DELETE t_mara_hlp WHERE cuobf = t_ausp-objek.                 " n_2749155
        ELSE.
*         Merkmal hat keine Werte -> Artikel bleibt drin, weil keine
*         Merkmalswerteeinschränkung durchgeführt wurde
        ENDIF.
* JH/03.08.98/4.5B/KPr51331 (Ende)
      ENDIF.
    ENDLOOP.
  ENDIF.                               "JH/16.10.96

*---- Verbleibende Varianten übernehmen. Falls keine Varianten übrig- -*
*---- bleiben muß der Sammelartikel aus der Selektionsliste gelöscht  -*
*---- werden. Ist die Liste der selektierten Artikel am Ende leer,    -*
*---- muß eine Fehlermeldung erfolgen                                 -*
  DESCRIBE TABLE t_mara_hlp LINES sy-tfill.                             " n_2749155
  IF sy-tfill = 0.
*---- Zugeordneten Sammelartikel herauslöschen und Korrekturfaktor ----*
*---- für die Zählvariable ANZ_SEL_MAT erhöhen                     ----*
    READ TABLE t_matnr_hlp                              "v note 2726544 " n_2749155
      WITH KEY matnr = t_matnr-matnr
      TRANSPORTING NO FIELDS                                            " n_2749155
      BINARY SEARCH.
    IF sy-subrc EQ 0.
      DELETE t_matnr_hlp INDEX sy-tabix.                "^ note 2726544 " n_2749155
      korr_anz_sel_mat = korr_anz_sel_mat + 1.
    ENDIF.
  ELSE.
    LOOP AT t_mara_hlp ASSIGNING FIELD-SYMBOL(<ls_mara_hlp>).           " n_2749155
*     PERFORM mat_einfuegen USING t_mara.        "TGA/4.6 Erw. Lot
      PERFORM mat_einfuegen TABLES t_matnr_hlp       "TGA/4.6 Erw. Lot  " n_2749155
                            USING <ls_mara_hlp>.                        " n_2749155
    ENDLOOP.
  ENDIF.

ENDFORM.                               " VAR_MIT_MERKM_EINSCHR

*&---------------------------------------------------------------------*
*&      Form  VAR_OHNE_MERKM_EINSCHR
*&---------------------------------------------------------------------*
*       Varianten ohne Berücksichtigung der Einschränkung der Merkmals-
*       werte ermitteln
*----------------------------------------------------------------------*
FORM var_ohne_merkm_einschr.

"d  REFRESH t_mara.                                     "v note 2732723
"d  SELECT * FROM  mara  INTO TABLE t_mara
"d         WHERE  satnr = t_matnr-matnr
"d         AND    attyp = attyp_var.

  DATA: lv_matnr TYPE matnr.
  lv_matnr = t_matnr-matnr.

  READ TABLE t_mara WITH KEY satnr = lv_matnr
                             attyp = attyp_var
                             TRANSPORTING NO FIELDS                     " n_2749155
                             BINARY SEARCH.             "^ note 2732723
  IF sy-subrc NE 0.
* Anlegen von SA's ohne Var. inzwischen erlaubt             "JH/16.10.96
*   MESSAGE A025 WITH T_MATNR-MATNR.                        "JH/16.10.96
*    MESSAGE i025 WITH t_matnr-matnr.                     "note 2687150
*    Zum Sammelartikel & existieren keine Varianten!        "JH/16.10.96
    gv_message_counter = gv_message_counter + 1.          "note 2687150

*---- Falls keine Varianten vorhanden sind, muß der Sammelartikel aus
*---- der Selektionsliste gelöscht werden. Ist die Liste der selekt.
*---- Artikel am Ende leer muß eine Fehlermeldung erfolgen.
*---- Korrekturfaktor für die Zählvariable ANZ_SEL_MAT erhöhen.
    READ TABLE t_matnr_hlp                              "v note 2726544 " n_2749155
      WITH KEY matnr = t_matnr-matnr
      TRANSPORTING NO FIELDS                                            " n_2749155
      BINARY SEARCH.
    IF sy-subrc EQ 0.
      DELETE t_matnr_hlp INDEX sy-tabix.                "^ note 2726544 " n_2749155
      korr_anz_sel_mat = korr_anz_sel_mat + 1.              "JH/16.10.96
    ENDIF.
  ELSE.                                "JH/16.10.96
    LOOP AT t_mara FROM sy-tabix                        "v note 2732723
                   ASSIGNING FIELD-SYMBOL(<ls_mara>).                   " n_2749155
      IF <ls_mara>-satnr NE lv_matnr.                                   " n_2749155
        EXIT.
      ENDIF.                                            "^ note 2732723
*      PERFORM mat_einfuegen USING t_mara.           "TGA/4.6 Erw. Lot
      PERFORM mat_einfuegen TABLES t_matnr_hlp      "TGA/4.6 Erw. Lot   " n_2749155
                            USING <ls_mara>.        "TGA/4.6 Erw. Lot   " n_2749155
    ENDLOOP.
  ENDIF.

ENDFORM.                               " VAR_OHNE_MERKM_EINSCHR

*&---------------------------------------------------------------------*
*&      Form  DELETE_MERKM_WERTE
*&---------------------------------------------------------------------*
*       Herauslöschen nicht selektierter Merkmalswerte
*----------------------------------------------------------------------*
*  -->  PI_ATINN  Merkmal für das Werte selektiert wurden
*----------------------------------------------------------------------*
FORM delete_merkm_werte USING pi_atinn LIKE cawn-atinn.

  LOOP AT t_bewert WHERE atinn = pi_atinn.
    READ TABLE t_selbew WITH KEY atinn = t_bewert-atinn
                                 atwrt = t_bewert-atwrt.
* Anmerkung: BINARY SEARCH nicht möglich, weil bzgl. ATZHL nicht ge-
*            testet werden kann (T_SELBEW-ATZHL nicht belegt)

*---- Vergleichsart INCL -> T_MERKM_STAT-SLCODE = '1'
*---- -> Merkmalswert löschen, wenn nicht in T_SELBEW.
*---- Vergleichsart EXCL -> T_MERKM_STAT-SLCODE = '4' oder '3'
*---- -> Merkmalswert löschen, wenn in T_SELBEW.
    IF ( sy-subrc <> 0 AND t_merkm_stat-slcod = '1' )   "CHAR/NUM INCL
    OR ( sy-subrc =  0 AND t_merkm_stat-slcod = '4' )   "CHAR EXCL
    OR ( sy-subrc =  0 AND t_merkm_stat-slcod = '3' ).  "NUM  EXCL
      DELETE t_bewert.
    ENDIF.
  ENDLOOP.
* JH/03.08.98/4.5B/KPr51331 (Anfang)
* Bei Merkmalen mit Referenztab. oder mit Zugriffs-FB enthält die
* T_BEWERT keine Merkmalswert, wenn man sich auf WG-Ebene befindet
* -> T_BEWERT künstlich aufbauen auf Basis der T_SELBEW
  IF sy-subrc NE 0.
    LOOP AT t_selbew WHERE atinn = pi_atinn.
      CLEAR t_bewert.
      MOVE-CORRESPONDING t_selbew TO t_bewert.
      APPEND t_bewert.
    ENDLOOP.
    SORT t_bewert BY atinn atzhl.
  ENDIF.
* JH/03.08.98/4.5B/KPr51331 (Ende)

ENDFORM.                               " DELETE_MERKM_WERTE

*&---------------------------------------------------------------------*
*&      Form  STAMMDATEN_BESTAENDE
*&---------------------------------------------------------------------*
*       MARC- und MARD-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM stammdaten_bestaende TABLES pt_werks STRUCTURE t_werks.


*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*--- Lesen und kumulieren Werksbestände -------------------------------*
* IF WERK_SEL IS INITIAL.
*---- Falls keine Eingrenzung hinsichtlich der Werke erfolgte, darf ---*
*---- das MARC-Select nicht über den Zusatz FOR ALL ENTRIES IN...   ---*
*---- erfolgen, weil dann die WHERE-Bedingung keine Wirkung hat und ---*
*---- somit alle MARC-Sätze zurückgeliefert würden                  ---*
*   SELECT * FROM MARC WHERE MATNR = T_MATNR-MATNR.
*     PERFORM MARC_BESTAENDE.
*   ENDSELECT.
* ELSE.
*---- Treffermenge des SELECT's muß sortiert sein, damit später über --*
*---- BINARY-SEARCH intern gesucht werden kann -> ORDER BY...        --*
*   SELECT * FROM MARC FOR ALL ENTRIES IN T_WERKS
*          WHERE MATNR =  T_MATNR-MATNR
*          AND   WERKS =  T_WERKS-WERKS
*          ORDER BY PRIMARY KEY.
*     PERFORM MARC_BESTAENDE.
*   ENDSELECT.
* ENDIF.
*
* IF SY-SUBRC NE 0.
*---- Wenn keine Bestandsdaten vorhanden sind, muß zumindest ein ------*
*---- Bestandssatz mit Wert 0 auf Mandantenebene erzeugt werden  ------*
*   CLEAR MARC.
*   MOVE T_MATNR-MATNR TO MARC-MATNR.
*   PERFORM MARC_BESTAENDE_KUMULIEREN USING T_MATNR-MATNR.
*
*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, muß auch für den Sammelartikel ein Initialsatz angelegt ----*
*---- werden, falls noch nicht geschehen                           ----*
*   IF T_MATNR-ATTYP = ATTYP_VAR.
*     READ TABLE T_MATNR WITH KEY MATNR = T_MATNR-SATNR
*                BINARY SEARCH           "Werte der Variante nicht
*                TRANSPORTING NO FIELDS. "überschreiben!!
*     IF SY-SUBRC = 0.
*       PERFORM MARC_BESTAENDE_KUMULIEREN USING T_MATNR-SATNR.
*     ENDIF.
*   ENDIF.
* ENDIF.
*  LOOP AT t_marc WHERE matnr = t_matnr-matnr.    " TGA/4.6 Erw. Lot
* note 1138065
  DATA: hindex LIKE sy-tabix.
  READ TABLE t_marc WITH KEY matnr = prt_matnr-matnr
                    BINARY SEARCH.
  IF sy-subrc = 0.
    MOVE sy-tabix TO hindex.
    LOOP AT t_marc FROM hindex.
      IF t_marc-matnr NE prt_matnr-matnr.
        EXIT.
      ENDIF.
      PERFORM marc_bestaende TABLES pt_werks.
    ENDLOOP.
  ENDIF.

  IF sy-subrc NE 0.
*---- Wenn keine Bestandsdaten vorhanden sind, muß zumindest ein ------*
*---- Bestandssatz mit Wert 0 auf Mandantenebene erzeugt werden  ------*
    CLEAR t_marc.
*    MOVE t_matnr-matnr TO t_marc-matnr.              " TGA/4.6 Erw. Lot
*   PERFORM marc_bestaende_kumulieren USING t_matnr-matnr.   " TGA/4.6 E
    MOVE prt_matnr-matnr TO t_marc-matnr.              " TGA/4.6 Erw. Lot
    PERFORM marc_bestaende_kumulieren TABLES pt_werks
                                      USING prt_matnr-matnr.    " TGA/4.6

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, muß auch für den Sammelartikel ein Initialsatz angelegt ----*
*---- werden, falls noch nicht geschehen                           ----*
*   IF t_matnr-attyp = attyp_var.                     " TGA/4.6 Erw. Lot
*     READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.
    IF prt_matnr-attyp = attyp_var.    " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6
                 BINARY SEARCH         "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
*   PERFORM marc_bestaende_kumulieren USING t_matnr-satnr.   " TGA/4.6 E
        PERFORM marc_bestaende_kumulieren TABLES pt_werks
                                          USING prt_matnr-satnr.  " TGA/4.6
      ENDIF.
    ENDIF.
  ENDIF.
*#JHL 14.05.96 (Ende)

ENDFORM.                               " STAMMDATEN_BESTAENDE


*&---------------------------------------------------------------------*
*&      Form  KUNDENAUFTR_BESTAENDE_ALL
*&---------------------------------------------------------------------*
*       MSKA-Bestandsdaten lesen und ablegen
*
*       This Form routine contains the same logic as the exising FORM KUNDENAUFTR_BESTAENDE
*       but can be executed for a set of materials and plant
*      (Prefetch for Retail on HANA optimisation)
*----------------------------------------------------------------------*
FORM kundenauftr_bestaende_all.

  DATA: lt_mska     TYPE TABLE OF tt_mska,
        lt_mska_seg TYPE TABLE OF tt_mska_seg,
*       Hint for HANA
        lv_hint TYPE rsdu_hint.

  FIELD-SYMBOLS: <ls_mska>     TYPE tt_mska,
                 <ls_mska_seg> TYPE tt_mska_seg.


  IF p_chrg EQ 'X'.

ENHANCEMENT-SECTION RWBE1F02_G3 SPOTS ES_RWBEST01 .
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSKA' 2 CHANGING lv_hint.

      IF p_scat IS INITIAL.
*  -----Lesen und kumulieren Kundenauftrags-Bestände -------------------------*
        SELECT matnr werks lgort charg vbeln posnr kalab kains kaspe kaein sgt_scat
           FROM mska INTO TABLE lt_mska_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND   sobkz =  aufbskunde
              %_HINTS HDB lv_hint.
      ELSE.
*  -----Lesen und kumulieren Kundenauftrags-Bestände -------------------------*
      SELECT matnr werks lgort charg vbeln posnr kalab kains kaspe kaein sgt_scat
           FROM mska INTO TABLE lt_mska_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND   sobkz =  aufbskunde
               AND   sgt_scat = p_scat
              %_HINTS HDB lv_hint.
      ENDIF.
    CATCH cx_wrt_fae_hint_error.
      IF p_scat IS INITIAL.
      SELECT matnr werks lgort charg vbeln posnr kalab kains kaspe kaein sgt_scat
           FROM mska INTO TABLE lt_mska_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND   sobkz =  aufbskunde.
      ELSE.
        SELECT matnr werks lgort charg vbeln posnr kalab kains kaspe kaein sgt_scat
           FROM mska INTO TABLE lt_mska_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND   sobkz =  aufbskunde
               AND   sgt_scat = p_scat.
      ENDIF.
  ENDTRY.
END-ENHANCEMENT-SECTION.

  LOOP AT lt_mska_seg ASSIGNING <ls_mska_seg>.
    MOVE-CORRESPONDING <ls_mska_seg> TO mska.
    PERFORM mska_bestaende_kumulieren USING mska-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mska_seg>-matnr.
*    IF gv_tree EQ space.                                             " MK
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mska_bestaende_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
*    ENDIF.                                                           " MK
  ENDLOOP.

  ELSE.
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSKA' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Kundenauftrags-Bestände -------------------------*
      SELECT matnr werks lgort vbeln posnr kalab kains kaspe kaein
         FROM mska INTO TABLE lt_mska FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  aufbskunde
            %_HINTS HDB lv_hint.
    CATCH cx_wrt_fae_hint_error.
      SELECT matnr werks lgort vbeln posnr kalab kains kaspe kaein
         FROM mska INTO TABLE lt_mska FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  aufbskunde.
  ENDTRY.
  LOOP AT lt_mska ASSIGNING <ls_mska>.
    MOVE-CORRESPONDING <ls_mska> TO mska.
    PERFORM mska_bestaende_kumulieren USING mska-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mska>-matnr.
*    IF gv_tree EQ space.                                              " MK
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mska_bestaende_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
*    ENDIF.                                                            " MK
  ENDLOOP.
  ENDIF.

ENDFORM.   " KUNDENAUFTR_BESTAENDE_ALL


* ( This FORM is replaced by FORM KUNDENAUFTR_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  KUNDENAUFTR_BESTAENDE
**&---------------------------------------------------------------------*
**       MSKA-Bestandsdaten lesen und ablegen
**----------------------------------------------------------------------*
*FORM kundenauftr_bestaende.
*
**--- Lesen und kumulieren Kundenauftrags-Bestände ---------------------*
*  SELECT * FROM mska FOR ALL ENTRIES IN t_werks
**        WHERE matnr =  t_matnr-matnr        " TGA/4.6 Erw. Lot
*         WHERE matnr =  prt_matnr-matnr" TGA/4.6 Erw. Lot
*         AND   werks =  t_werks-werks
*         AND   sobkz =  aufbskunde.
*    PERFORM mska_bestaende.
*  ENDSELECT.
*
*ENDFORM.                               " KUNDENAUFTR_BESTAENDE

* ( This FORM is replaced by FORM KUNDENAUFTR_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  MSKA_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Kundenauftragsbestände in den interen Tabellen.     *
**    2) Falls das Material eine Variante ist, werden auch die Best.    *
**       für den zugehörenden Sammelartikel fortgeschrieben.            *
**----------------------------------------------------------------------*
*FORM mska_bestaende.
*
** PERFORM mska_bestaende_kumulieren USING t_matnr-matnr.    " TGA/4.6 Er
*  PERFORM mska_bestaende_kumulieren USING prt_matnr-matnr.    " TGA/4.6
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                  " TGA/4.6 Erw. Lot
**    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. L
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**      PERFORM mska_bestaende_kumulieren USING t_matnr-satnr.  " TGA/4.6
*      PERFORM mska_bestaende_kumulieren USING prt_matnr-satnr.  " TGA/4.6
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MSKA_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MSKA_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Kundenauftragsbestände in den internen Tabellen     *
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mska_bestaende_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = mska-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mska-kalab TO prt_wbe-kalab.
    ADD mska-kains TO prt_wbe-kains.
    ADD mska-kaspe TO prt_wbe-kaspe.
    ADD mska-kaein TO prt_wbe-kaein.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MSKA-KALAB TO BBE-KALAB.
*     ADD MSKA-KAINS TO BBE-KAINS.
*     ADD MSKA-KASPE TO BBE-KASPE.
*     ADD MSKA-KAEIN TO BBE-KAEIN.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD mska-kalab TO prt_gbe-kalab.
      ADD mska-kains TO prt_gbe-kains.
      ADD mska-kaspe TO prt_gbe-kaspe.
      ADD mska-kaein TO prt_gbe-kaein.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD mska-kalab TO prt_mbe-kalab.
        ADD mska-kains TO prt_mbe-kains.
        ADD mska-kaspe TO prt_mbe-kaspe.
        ADD mska-kaein TO prt_mbe-kaein.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Festhalten der Kundenauftragsbestände auf Lagerortebene ---------*
  READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                            werks = mska-werks
                            lgort = mska-lgort   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mska-kalab TO prt_lbe-kalab.
    ADD mska-kains TO prt_lbe-kains.
    ADD mska-kaspe TO prt_lbe-kaspe.
    ADD mska-kaein TO prt_lbe-kaein.
    MODIFY prt_lbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_lbe.
    MOVE-CORRESPONDING mska TO prt_lbe.
    IF mska-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MSKA-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*     SELECT SINGLE * FROM MARD INTO *MARD
*            WHERE  MATNR = PI_MATNR
*            AND    WERKS = MSKA-WERKS
*            AND    LGORT = MSKA-LGORT.
*     IF SY-SUBRC = 0.
*       MOVE *MARD-LVORM TO LBE-LVORM.
*     ELSE.
*       CLEAR LBE-LVORM.
*     ENDIF.
      tabix_alt = sy-tabix.
      READ TABLE t_mard INTO mard
                        WITH KEY matnr = pi_matnr
                                 werks = mska-werks
                                 lgort = mska-lgort
                        BINARY SEARCH.
      IF sy-subrc = 0.
        MOVE mard-lvorm TO prt_lbe-lvorm.
      ELSE.
        CLEAR prt_lbe-lvorm.
      ENDIF.
      sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
    ELSE.
      MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_lbe INDEX sy-tabix.
  ENDIF.

  IF p_chrg EQ 'X'.
    READ TABLE prt_cbe WITH KEY matnr = pi_matnr
                            werks = mska-werks
                            lgort = mska-lgort
                            charg = mska-charg
                            BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD mska-kalab TO prt_cbe-kalab.
      ADD mska-kains TO prt_cbe-kains.
      ADD mska-kaspe TO prt_cbe-kaspe.
      ADD mska-kaein TO prt_cbe-kaein.
      MODIFY prt_cbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_cbe.
      MOVE-CORRESPONDING mska TO prt_cbe.
      IF mska-matnr <> pi_matnr.
        MOVE pi_matnr TO prt_cbe-matnr.
        tabix_alt = sy-tabix.
        READ TABLE t_mard INTO mard
                          WITH KEY matnr = pi_matnr
                                 werks = mska-werks
                                 lgort = mska-lgort
                          BINARY SEARCH.
        IF sy-subrc = 0.
          MOVE mard-lvorm TO prt_cbe-lvorm.
        ELSE.
          CLEAR prt_cbe-lvorm.
        ENDIF.
        sy-tabix = tabix_alt.
      ELSE.
        MOVE prt_matnr-satnr TO prt_cbe-satnr.
      ENDIF.
      INSERT prt_cbe INDEX sy-tabix.
    ENDIF.
  ENDIF.

*---- Aufnehmen Kundenauftragsbestände in die Tabelle EBS -------------*
* ????Anmerkung:
* Falls irgendwann auch mal Sammelartikel im Vertriebsbeleg auftauchen,
* muß man sich überlegen, wie die Belegdaten zu den Varianten und dem
* Sammelartikel sinnvoll abgelegt werden können!
  CLEAR prt_ebs.
  MOVE-CORRESPONDING mska TO prt_ebs.
  MOVE mska-kalab    TO prt_ebs-labst.
  MOVE mska-kains    TO prt_ebs-insme.
  MOVE mska-kaspe    TO prt_ebs-speme.
  MOVE mska-kaein    TO prt_ebs-einme.
  IF mska-matnr <> pi_matnr.
*---- Für den Sammelartikel werden die Variantendaten beleggenau  -----*
*---- abgelegt, d.h. pro Variantesatz ein Sammelartikelsatz, auch -----*
*---- wenn das Werk und der Lagerort übereinstimmen wird nicht    -----*
*---- kummuliert, denn die Belegnr. oder Position wechseln auf    -----*
*---- jeden Fall.                                                 -----*
*---- Falls Sammelartikel behandelt werden, enthält MSKA-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> EBS-MATNR umsetzen   ----*
    MOVE pi_matnr TO prt_ebs-matnr.
  ELSE.
    MOVE prt_matnr-satnr TO prt_ebs-satnr.   "wg. besserem Zugriffsverh.
    "bei Matrixdarstellung f. Varianten
  ENDIF.
  APPEND prt_ebs.
  kz_sond_exist = x.

ENDFORM.                               " MSKA_BESTAENDE_KUMULIEREN




*&---------------------------------------------------------------------*
*&      Form  LIEFKONSI_BESTAENDE
*&---------------------------------------------------------------------*
*       MKOL-Bestandsdaten lesen und ablegen (1)
*       (kein Kummulieren in MBE, GBE, WBE, LBE, da diese Bestandsdaten
*       auch in MARD enthalten sind und somit schon beim Lesen aus MARD
*       berücksichtigt wurden).
*
*       This Form routine contains the same logic as the exising FORM LIEFKONSI_BESTAENDE
*       but can be executed for a set of materials and plant
*      (Prefetch for Retail on HANA optimisation)
*----------------------------------------------------------------------*
FORM liefkonsi_bestaende_all.
  DATA: lt_mkol TYPE TABLE OF tt_mkol,
        lt_mkol_seg TYPE TABLE OF tt_mkol_seg,
*       Hint for HANA
        lv_hint TYPE rsdu_hint.

  FIELD-SYMBOLS: <ls_mkol> TYPE tt_mkol,
                 <ls_mkol_seg> TYPE tt_mkol_seg.
*--------------------------------------------------------------------*
IF p_chrg EQ 'X'.
ENHANCEMENT-SECTION RWBE1F02_G8 SPOTS ES_RWBEST01 .
      TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MKOL' 2 CHANGING lv_hint.
      IF p_scat IS INITIAL .
*-----Lesen und kumulieren Lieferantenkonsi-Bestände ------------------------*
      SELECT matnr werks lgort charg lifnr slabs sinsm seinm sspem sgt_scat
         FROM mkol INTO TABLE lt_mkol_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief
            %_HINTS HDB lv_hint.
        ELSE.
*-----Lesen und kumulieren Lieferantenkonsi-Bestände ------------------------*
      SELECT matnr werks lgort charg lifnr slabs sinsm seinm sspem sgt_scat
         FROM mkol INTO TABLE lt_mkol_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief
             AND   sgt_scat  = p_scat
            %_HINTS HDB lv_hint.
        ENDIF.
    CATCH cx_wrt_fae_hint_error.
      IF p_scat IS INITIAL .
      SELECT matnr werks lgort charg lifnr slabs sinsm seinm sspem sgt_scat
         FROM mkol INTO TABLE lt_mkol_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief.
      ELSE.
             SELECT matnr werks lgort charg lifnr slabs sinsm seinm sspem sgt_scat
         FROM mkol INTO TABLE lt_mkol_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief
             AND   sgt_scat = p_scat .
      ENDIF.
  ENDTRY.
END-ENHANCEMENT-SECTION .

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_mkol_seg[]                                 IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0023 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_mkol_seg ASSIGNING <ls_mkol_seg>.
    MOVE-CORRESPONDING <ls_mkol_seg> TO mkol.
    PERFORM mkol_konsi_kumulieren USING mkol-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mkol_seg>-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mkol_konsi_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
  ENDLOOP.
*--------------------------------------------------------------------*
ELSE.
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MKOL' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Lieferantenkonsi-Bestände ------------------------*
      SELECT matnr werks lgort lifnr slabs sinsm seinm sspem
         FROM mkol INTO TABLE lt_mkol FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief
            %_HINTS HDB lv_hint.
    CATCH cx_wrt_fae_hint_error.
      SELECT matnr werks lgort lifnr slabs sinsm seinm sspem
         FROM mkol INTO TABLE lt_mkol FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  konsilief.
  ENDTRY.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_mkol[]                                     IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0024 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_mkol ASSIGNING <ls_mkol>.
    MOVE-CORRESPONDING <ls_mkol> TO mkol.
    PERFORM mkol_konsi_kumulieren USING mkol-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mkol>-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mkol_konsi_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDIF.

ENDFORM.                               " LIEFKONSI_BESTAENDE_ALL


* ( This FORM is replaced by FORM LIEFKONSI_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  LIEFKONSI_BESTAENDE
**&---------------------------------------------------------------------*
**       MKOL-Bestandsdaten lesen und ablegen (1)
**       (kein Kummulieren in MBE, GBE, WBE, LBE, da diese Bestandsdaten
**       auch in MARD enthalten sind und somit schon beim Lesen aus MARD
**       berücksichtigt wurden).
**----------------------------------------------------------------------*
*FORM liefkonsi_bestaende.
*
**--- Lesen und kumulieren Lieferantenkonsi-Bestände -------------------*
*  SELECT * FROM mkol FOR ALL ENTRIES IN t_werks
**         WHERE matnr =  t_matnr-matnr     " TGA/4.6 Erw. Lot
*         WHERE matnr =  prt_matnr-matnr" TGA/4.6 Erw. Lot
*         AND   werks =  t_werks-werks
*         AND   sobkz =  konsilief.
*    PERFORM mkol_konsi_bestaende.
*  ENDSELECT.
*
*ENDFORM.                               " LIEFKONSI_BESTAENDE

* ( This FORM is replaced by FORM LIEFKONSI_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  MKOL_KONSI_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Lieferantenkonsibestände in der interen Tabelle
**    2) Falls das Material eine Variante ist, werden auch die Best.
**       für den zugehörenden Sammelartikel fortgeschrieben.
**----------------------------------------------------------------------*
*FORM mkol_konsi_bestaende.
*
**  PERFORM mkol_konsi_kumulieren USING t_matnr-matnr.  " TGA/4.6 Erw. Lo
*  PERFORM mkol_konsi_kumulieren USING prt_matnr-matnr.  " TGA/4.6 Erw. L
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                      " TGA/4.6 Erw. Lot
**    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw.
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**     PERFORM mkol_konsi_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw
*      PERFORM mkol_konsi_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MKOL_KONSI_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MKOL_KONSI_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Lieferantenkonsibestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mkol_konsi_kumulieren USING pi_matnr LIKE mara-matnr.

DATA: tabix_alt TYPE sy-tabix.

*---- Aufnehmen Lieferantenkonsibestände in die Tabelle KBE -----------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Organ.zuordnung u.  -*
*---- Lief.zuordnung exist.                                           -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_kbe WITH KEY matnr = pi_matnr
                          werks = mkol-werks
                          lgort = mkol-lgort
                          lifnr = mkol-lifnr   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mkol-slabs TO prt_kbe-labst.
    ADD mkol-sinsm TO prt_kbe-insme.
    ADD mkol-seinm TO prt_kbe-einme.
    ADD mkol-sspem TO prt_kbe-speme.
    MODIFY prt_kbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_kbe.
    MOVE-CORRESPONDING mkol TO prt_kbe.
    MOVE mkol-slabs    TO prt_kbe-labst.
    MOVE mkol-sinsm    TO prt_kbe-insme.
    MOVE mkol-seinm    TO prt_kbe-einme.
    MOVE mkol-sspem    TO prt_kbe-speme.
    IF mkol-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MKOL-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> KBE-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_kbe-matnr.
*---- Löschkennzeichen d. Sammelart. nicht vorhanden -> CLEAR ---------*
      CLEAR prt_kbe-lvorm.
    ELSE.
      MOVE prt_matnr-satnr TO prt_kbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_kbe INDEX sy-tabix.
    kz_sond_exist = x.
  ENDIF.

*--------------------------------------------------------------------*
IF p_chrg EQ 'X'.
    READ TABLE prt_cbe WITH KEY matnr = pi_matnr
                                werks = mkol-werks
                                charg = mkol-charg BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ADD mkol-slabs  TO prt_cbe-klabs.
      ADD mkol-sinsm  TO prt_cbe-kinsm.
      ADD mkol-seinm  TO prt_cbe-keinm.
      ADD mkol-sspem  TO prt_cbe-kspem.
      MODIFY prt_cbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_cbe.
      MOVE-CORRESPONDING mkol TO prt_cbe.
      MOVE mkol-slabs  TO prt_cbe-klabs.
      MOVE mkol-sinsm  TO prt_cbe-kinsm.
      MOVE mkol-seinm  TO prt_cbe-keinm.
      MOVE mkol-sspem  TO prt_cbe-kspem.
      tabix_alt = sy-tabix.
      IF mkol-matnr <> pi_matnr.
        MOVE pi_matnr TO prt_cbe-matnr.
        READ TABLE t_mard INTO mard
                       WITH KEY matnr = pi_matnr
                                werks = mkol-werks
                                BINARY SEARCH.
        IF sy-subrc = 0.
          move mard-lvorm TO prt_cbe-lvorm.
        ELSE.
          CLEAR prt_cbe-lvorm.
        ENDIF.
          sy-tabix = tabix_alt.
      ELSE.
        READ TABLE prt_matnr INTO data(ls_matnr)
                             WITH KEY matnr = pi_matnr.
        if ls_matnr-satnr ne prt_matnr-satnr.
          MOVE ls_matnr-satnr TO prt_cbe-satnr.
        else.
          MOVE prt_matnr-satnr TO prt_cbe-satnr.
        endif.
        sy-tabix = tabix_alt.
      ENDIF.
      INSERT prt_cbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
*--------------------------------------------------------------------*
ENDFORM.                               " MKOL_KONSI_KUMULIEREN


*&---------------------------------------------------------------------*
*&      Form  LIEFMTV_BESTAENDE_ALL
*&---------------------------------------------------------------------*
*       MKOL-Bestandsdaten lesen und ablegen (2)
*       This Form routine contains the same logic as the exising FORM LIEFMTV_BESTAENDE
*       but can be executed for a set of materials and plant
*      (Prefetch for Retail on HANA optimisation)
*----------------------------------------------------------------------*
FORM liefmtv_bestaende_all.

  DATA: lt_mkol TYPE TABLE OF tt_mkol,
        ls_mkol TYPE tt_mkol,
*       Hint for HANA
        lv_hint TYPE rsdu_hint.
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MKOL' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Lieferanten-MTV-Bestände ------------------------*
      SELECT matnr werks lgort lifnr slabs sinsm seinm sspem
         FROM mkol INTO TABLE lt_mkol FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  mtverpack
            %_HINTS HDB lv_hint.
    CATCH cx_wrt_fae_hint_error.
      SELECT matnr werks lgort lifnr slabs sinsm seinm sspem
         FROM mkol INTO TABLE lt_mkol FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  mtverpack.
  ENDTRY.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_mkol[]                                     IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0029 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_mkol INTO ls_mkol.
    MOVE-CORRESPONDING ls_mkol TO mkol.
    PERFORM mkol_mtv_kumulieren USING mkol-matnr.   " TGA/4.6 Erw. Lo

    READ TABLE prt_matnr WITH KEY matnr = mkol-matnr.
*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr " TGA/4.6 Erw.
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mkol_mtv_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " LIEFMTV_BESTAENDE_ALL



* (Form LIEFMTV_BESTAENDE is replaced by LIEFMTV_BESTAENDE_ALL)
**&---------------------------------------------------------------------*
**&      Form  LIEFMTV_BESTAENDE
**&---------------------------------------------------------------------*
**       MKOL-Bestandsdaten lesen und ablegen (2)
**----------------------------------------------------------------------*
*FORM liefmtv_bestaende.
*
**--- Lesen und kumulieren Lieferanten-MTV-Bestände --------------------*
*  SELECT * FROM mkol FOR ALL ENTRIES IN t_werks
**         WHERE matnr =  t_matnr-matnr       " TGA/4.6 Erw. Lot
*          WHERE matnr =  prt_matnr-matnr     " TGA/4.6 Erw. Lot
*         AND   werks =  t_werks-werks
*         AND   sobkz =  mtverpack.
*    PERFORM mkol_mtv_bestaende.
*  ENDSELECT.
*
*ENDFORM.                               " LIEFMTV_BESTAENDE

* (Form MKOL_MTV_BESTAENDE is replaced by LIEFMTV_BESTAENDE_ALL)
**&---------------------------------------------------------------------*
**&      Form  MKOL_MTV_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Lieferanten-MTV-Bestände in den interen Tabellen
**    2) Falls das Material eine Variante ist, werden auch die Best.
**       für den zugehörenden Sammelartikel fortgeschrieben.
**----------------------------------------------------------------------*
*FORM mkol_mtv_bestaende.
*
**  PERFORM mkol_mtv_kumulieren USING t_matnr-matnr.   " TGA/4.6 Erw. Lot
*  PERFORM mkol_mtv_kumulieren USING prt_matnr-matnr.   " TGA/4.6 Erw. Lo
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                      " TGA/4.6 Erw. Lot
**    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr " TGA/4.6 Erw.
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**      PERFORM mkol_mtv_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw.
*      PERFORM mkol_mtv_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MKOL_MTV_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MKOL_MTV_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Lieferanten-MTV-Bestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mkol_mtv_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = mkol-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mkol-slabs TO prt_wbe-mlabs.
    ADD mkol-sinsm TO prt_wbe-minsm.
    ADD mkol-seinm TO prt_wbe-meinm.
    ADD mkol-sspem TO prt_wbe-mspem.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MKOL-SLABS TO BBE-MLABS.
*     ADD MKOL-SINSM TO BBE-MINSM.
*     ADD MKOL-SEINM TO BBE-MEINM.
*     ADD MKOL-SSPEM TO BBE-MSPEM.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD mkol-slabs TO prt_gbe-mlabs.
      ADD mkol-sinsm TO prt_gbe-minsm.
      ADD mkol-seinm TO prt_gbe-meinm.
      ADD mkol-sspem TO prt_gbe-mspem.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD mkol-slabs TO prt_mbe-mlabs.
        ADD mkol-sinsm TO prt_mbe-minsm.
        ADD mkol-seinm TO prt_mbe-meinm.
        ADD mkol-sspem TO prt_mbe-mspem.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Festhalten der Lieferanten-MTV-Bestände auf Lagerortebene -------*
  READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                              werks = mkol-werks
                              lgort = mkol-lgort   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mkol-slabs TO prt_lbe-mlabs.
    ADD mkol-sinsm TO prt_lbe-minsm.
    ADD mkol-seinm TO prt_lbe-meinm.
    ADD mkol-sspem TO prt_lbe-mspem.
    MODIFY prt_lbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_lbe.
    MOVE-CORRESPONDING mkol TO prt_lbe.
    MOVE mkol-slabs TO prt_lbe-mlabs.
    MOVE mkol-sinsm TO prt_lbe-minsm.
    MOVE mkol-seinm TO prt_lbe-meinm.
    MOVE mkol-sspem TO prt_lbe-mspem.
    IF mkol-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MKOL-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*     SELECT SINGLE * FROM MARD INTO *MARD
*            WHERE  MATNR = PI_MATNR
*            AND    WERKS = MKOL-WERKS
*            AND    LGORT = MKOL-LGORT.
*     IF SY-SUBRC = 0.
*       MOVE *MARD-LVORM TO LBE-LVORM.
*     ELSE.
*       CLEAR LBE-LVORM.
*     ENDIF.
      tabix_alt = sy-tabix.
      READ TABLE t_mard INTO mard
                        WITH KEY matnr = pi_matnr
                                 werks = mkol-werks
                                 lgort = mkol-lgort
                        BINARY SEARCH.
      IF sy-subrc = 0.
        MOVE mard-lvorm TO prt_lbe-lvorm.
      ELSE.
        CLEAR prt_lbe-lvorm.
      ENDIF.
      sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
    ELSE.
      MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_lbe INDEX sy-tabix.
  ENDIF.

*---- Aufnehmen Lieferanten-MTV-Bestände in die Tabelle MPS -----------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Organ.zuordnung u.  -*
*---- Lief.zuordnung exist.                                           -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_mps WITH KEY matnr = pi_matnr
                          werks = mkol-werks
                          lgort = mkol-lgort
                          lifnr = mkol-lifnr   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mkol-slabs TO prt_mps-labst.
    ADD mkol-sinsm TO prt_mps-insme.
    ADD mkol-seinm TO prt_mps-einme.
    ADD mkol-sspem TO prt_mps-speme.
    MODIFY prt_mps INDEX sy-tabix.
  ELSE.
    CLEAR prt_mps.
    MOVE-CORRESPONDING mkol TO prt_mps.
    MOVE mkol-slabs         TO prt_mps-labst.
    MOVE mkol-sinsm         TO prt_mps-insme.
    MOVE mkol-seinm         TO prt_mps-einme.
    MOVE mkol-sspem         TO prt_mps-speme.
    IF mkol-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MKOL-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> MPS-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_mps-matnr.
*---- Löschkennzeichen d. Sammelart. nicht vorhanden -> CLEAR ---------*
      CLEAR prt_mps-lvorm.
    ELSE.
      MOVE prt_matnr-satnr TO prt_mps-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_mps INDEX sy-tabix.
    kz_sond_exist = x.
  ENDIF.

ENDFORM.                               " MKOL_MTV_KUMULIEREN


*&---------------------------------------------------------------------*
*&      Form  LIEFBEIST_BESTAENDE_ALL
*&---------------------------------------------------------------------*
*       MSLB-Bestandsdaten lesen und ablegen
*
*       This Form routine contains the same logic as the exising FORM LIEFBEIST_BESTAENDE
*       but can be executed for a set of materials and plant
*      (Prefetch for Retail on HANA optimisation)
*----------------------------------------------------------------------*
FORM liefbeist_bestaende_all.

  DATA: lt_mslb TYPE TABLE OF tt_mslb,
        lt_mslb_seg TYPE TABLE OF tt_mslb_seg,
*       Hint for HANA
        lv_hint TYPE rsdu_hint.

  FIELD-SYMBOLS: <ls_mslb> TYPE tt_mslb,
                 <ls_mslb_seg> TYPE tt_mslb_seg.

if p_chrg = 'X'.

  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSLB' 2 CHANGING lv_hint.
      if p_scat is initial.
*-----Lesen und kumulieren Lieferantenbeistellbestände -------------------*
      SELECT matnr werks charg lifnr lblab lbins lbein sgt_scat
         FROM mslb INTO TABLE lt_mslb_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief
            %_HINTS HDB lv_hint.
      else.
*-----Lesen und kumulieren Lieferantenbeistellbestände -------------------*
      SELECT matnr werks charg lifnr lblab lbins lbein sgt_scat
         FROM mslb INTO TABLE lt_mslb_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief
             AND   sgt_scat = p_scat
            %_HINTS HDB lv_hint.
      endif.
    CATCH cx_wrt_fae_hint_error.
     if p_scat is initial.
      SELECT matnr werks charg lifnr lblab lbins lbein sgt_scat
         FROM mslb INTO TABLE lt_mslb_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief.
     else.
      SELECT matnr werks charg lifnr lblab lbins lbein sgt_scat
         FROM mslb INTO TABLE lt_mslb_seg FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief
             AND   sgt_scat = p_scat.
     endif.
  ENDTRY.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_mslb_seg[]                                 IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0025 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_mslb_seg ASSIGNING <ls_mslb_seg>.
    MOVE-CORRESPONDING <ls_mslb_seg> TO mslb.
    PERFORM mslb_kumulieren USING mslb-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mslb_seg>-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mslb_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
  ENDLOOP.

else.
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSLB' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Lieferantenbeistellbestände -------------------*
      SELECT matnr werks lifnr lblab lbins lbein
         FROM mslb INTO TABLE lt_mslb FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief
            %_HINTS HDB lv_hint.
      CATCH cx_wrt_fae_hint_error.
*-----Lesen und kumulieren Lieferantenbeistellbestände -------------------*
      SELECT matnr werks lifnr lblab lbins lbein
         FROM mslb INTO TABLE lt_mslb FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND   sobkz =  beistlief.
  ENDTRY.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_mslb[]                                     IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0026 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_mslb ASSIGNING <ls_mslb>.
    MOVE-CORRESPONDING <ls_mslb> TO mslb.
    PERFORM mslb_kumulieren USING mslb-matnr.
    READ TABLE prt_matnr WITH KEY matnr = <ls_mslb>-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM mslb_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
      ENDIF.
    ENDIF.
  ENDLOOP.
endif.

ENDFORM.                               " LIEFBEIST_BESTAENDE_ALL




* (Form LIEFBEIST_BESTAENDE is replaced by LIEFBEIST_BESTAENDE_ALL)
*&---------------------------------------------------------------------*
*&      Form  LIEFBEIST_BESTAENDE
*&---------------------------------------------------------------------*
*       MSLB-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
*FORM liefbeist_bestaende.
*
**--- Lesen und kumulieren Lieferantenbeistellbestände -----------------*
*  SELECT * FROM mslb FOR ALL ENTRIES IN t_werks
**         WHERE matnr =  t_matnr-matnr     " TGA/4.6 Erw. Lot
*         WHERE matnr =  prt_matnr-matnr" TGA/4.6 Erw. Lot
*         AND   werks =  t_werks-werks
*         AND   sobkz =  beistlief.
*    PERFORM mslb_bestaende.
*  ENDSELECT.
*
*ENDFORM.                               " LIEFBEIST_BESTAENDE

* (Form MSLB_BESTAENDE is replaced by LIEFBEIST_BESTAENDE_ALL)
**&---------------------------------------------------------------------*
**&      Form  MSLB_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Lieferantenbeistellbestände in den interen Tabellen
**    2) Falls das Material eine Variante ist, werden auch die Best.
**       für den zugehörenden Sammelartikel fortgeschrieben.
**----------------------------------------------------------------------*
*FORM mslb_bestaende.
*
**  PERFORM mslb_kumulieren USING t_matnr-matnr.   " TGA/4.6 Erw. Lot
*  PERFORM mslb_kumulieren USING prt_matnr-matnr.  " TGA/4.6 Erw. Lot
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                " TGA/4.6 Erw. Lot
**   READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. Lo
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr " TGA/4.6 Erw.
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**     PERFORM mslb_kumulieren USING t_matnr-satnr.    " TGA/4.6 Erw. Lot
*      PERFORM mslb_kumulieren USING prt_matnr-satnr. " TGA/4.6 Erw. Lot
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MSLB_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MSLB_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Lieferantenbeistellbestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mslb_kumulieren USING pi_matnr LIKE mara-matnr.

DATA: tabix_alt TYPE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = mslb-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mslb-lblab TO prt_wbe-lblab.
    ADD mslb-lbins TO prt_wbe-lbins.
    ADD mslb-lbein TO prt_wbe-lbein.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MSLB-LBLAB TO BBE-LBLAB.
*     ADD MSLB-LBINS TO BBE-LBINS.
*     ADD MSLB-LBEIN TO BBE-LBEIN.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD mslb-lblab TO prt_gbe-lblab.
      ADD mslb-lbins TO prt_gbe-lbins.
      ADD mslb-lbein TO prt_gbe-lbein.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD mslb-lblab TO prt_mbe-lblab.
        ADD mslb-lbins TO prt_mbe-lbins.
        ADD mslb-lbein TO prt_mbe-lbein.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

  IF p_chrg EQ 'X'.
    READ TABLE prt_cbe WITH KEY matnr = pi_matnr
                                werks = mslb-werks
                                charg = mslb-charg BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      ADD mslb-lblab  TO prt_cbe-lblab.
      ADD mslb-lbins  TO prt_cbe-lbins.
      ADD mslb-lbein  TO prt_cbe-lbein.
      MODIFY prt_cbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_cbe.
      MOVE-CORRESPONDING mslb TO prt_cbe.
      tabix_alt = sy-tabix.
      IF mslb-matnr <> pi_matnr.
        MOVE pi_matnr TO prt_cbe-matnr.
        READ TABLE t_mard INTO mard
                       WITH KEY matnr = pi_matnr
                                werks = mslb-werks
                                BINARY SEARCH.
        IF sy-subrc = 0.
          move mard-lvorm TO prt_cbe-lvorm.
        ELSE.
          CLEAR prt_cbe-lvorm.
        ENDIF.
          sy-tabix = tabix_alt.
      ELSE.
        READ TABLE prt_matnr INTO data(ls_matnr)
                             WITH KEY matnr = pi_matnr.
        if ls_matnr-satnr ne prt_matnr-satnr.
          MOVE ls_matnr-satnr TO prt_cbe-satnr.
        else.
          MOVE prt_matnr-satnr TO prt_cbe-satnr.
        endif.
        sy-tabix = tabix_alt.
      ENDIF.
      INSERT prt_cbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
*---- Aufnehmen Lieferantenbeistellbestände in die Tabelle OBS --------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Organ.zuordnung u.  -*
*---- Lief.zuordnung exist.                                           -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_obs WITH KEY matnr = pi_matnr
                          werks = mslb-werks
                          lifnr = mslb-lifnr
                          charg = mslb-charg BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD mslb-lblab TO prt_obs-labst.
    ADD mslb-lbins TO prt_obs-insme.
    ADD mslb-lbein TO prt_obs-einme.
    MODIFY prt_obs INDEX sy-tabix.
  ELSE.
    CLEAR prt_obs.
    MOVE-CORRESPONDING mslb TO prt_obs.
    MOVE mslb-lblab TO prt_obs-labst.
    MOVE mslb-lbins TO prt_obs-insme.
    MOVE mslb-lbein TO prt_obs-einme.
    IF mslb-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MSLB-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> OBS-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_obs-matnr.
    ELSE.
      MOVE prt_matnr-satnr TO prt_obs-satnr. "wg. besserem Zugriffsverh.
      "Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_obs INDEX sy-tabix.
  ENDIF.

ENDFORM.                               " MSLB_KUMULIEREN


*&---------------------------------------------------------------------*
*&      Form  KUNDEN_BESTAENDE_ALL
*&---------------------------------------------------------------------*
*       MSKU-Bestandsdaten lesen und ablegen
*
*       This Form routine contains the same logic as the exising FORM KUNDEN_BESTAENDE
*       but can be executed for a set of materials and plant
*      (Prefetch for Retail on HANA optimisation)
*----------------------------------------------------------------------*
FORM kunden_bestaende_all.

  DATA: lt_msku TYPE TABLE OF tt_msku,
        lt_msku_seg TYPE TABLE OF tt_msku_seg,
*       Hint for HANA
        lv_hint TYPE rsdu_hint.

  FIELD-SYMBOLS: <ls_msku>     TYPE tt_msku,
                 <ls_msku_seg> TYPE tt_msku_seg.

 IF p_chrg EQ 'X'.

ENHANCEMENT-SECTION RWBE1F02_G4 SPOTS ES_RWBEST01 .
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSKU' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Kundenantenkonsignation und -leergut ------------*
      IF p_scat IS INITIAL.
        SELECT matnr werks charg kunnr sobkz kulab kuins kuein sgt_scat
           FROM msku INTO TABLE lt_msku_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND ( sobkz = lrgutkunde OR sobkz = konsikunde )
               %_HINTS HDB lv_hint.
      ELSE.
        SELECT matnr werks charg kunnr sobkz kulab kuins kuein sgt_scat
           FROM msku INTO TABLE lt_msku_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND ( sobkz = lrgutkunde OR sobkz = konsikunde )
               AND   sgt_scat = p_scat
               %_HINTS HDB lv_hint.
      ENDIF.
    CATCH cx_wrt_fae_hint_error.
      IF p_scat IS INITIAL.
        SELECT matnr werks charg kunnr sobkz kulab kuins kuein sgt_scat
           FROM msku INTO TABLE lt_msku_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND ( sobkz = lrgutkunde OR sobkz = konsikunde ).
      ELSE.
        SELECT matnr werks charg kunnr sobkz kulab kuins kuein sgt_scat
           FROM msku INTO TABLE lt_msku_seg FOR ALL ENTRIES IN t_pre01
               WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
               AND   werks =  t_pre01-werks
               AND ( sobkz = lrgutkunde OR sobkz = konsikunde )
               AND  sgt_scat = p_scat.
      ENDIF.
  ENDTRY.
END-ENHANCEMENT-SECTION.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_msku_seg[]                                 IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0027 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_msku_seg ASSIGNING <ls_msku_seg>.
    MOVE-CORRESPONDING <ls_msku_seg> TO msku.
    CASE <ls_msku_seg>-sobkz.
      WHEN lrgutkunde.
        PERFORM msku_lrgut_kumulieren USING msku-matnr.
      WHEN konsikunde.
        PERFORM msku_konsi_kumulieren USING msku-matnr.
    ENDCASE.
    READ TABLE prt_matnr WITH KEY matnr = <ls_msku_seg>-matnr.
*   IF gv_tree EQ space.                                          " MK
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        CASE <ls_msku_seg>-sobkz.
          WHEN lrgutkunde.
            PERFORM msku_lrgut_kumulieren USING prt_matnr-satnr.
          WHEN konsikunde.
            PERFORM msku_konsi_kumulieren USING prt_matnr-satnr.
        ENDCASE.
      ENDIF.
    ENDIF.
*   ENDIF.                                                        " MK
  ENDLOOP.
 ELSE.
  TRY.
*     Hana Optimization
      PERFORM hana_hint TABLES t_pre01 USING 'MSKU' 2 CHANGING lv_hint.

*-----Lesen und kumulieren Kundenantenkonsignation und -leergut ------------*
      SELECT matnr werks kunnr sobkz kulab kuins kuein
         FROM msku INTO TABLE lt_msku FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND ( sobkz = lrgutkunde OR sobkz = konsikunde )
             %_HINTS HDB lv_hint.
    CATCH cx_wrt_fae_hint_error.
      SELECT matnr werks kunnr sobkz kulab kuins kuein
         FROM msku INTO TABLE lt_msku FOR ALL ENTRIES IN t_pre01
             WHERE matnr =  t_pre01-matnr" TGA/4.6 Erw. Lot
             AND   werks =  t_pre01-werks
             AND ( sobkz = lrgutkunde OR sobkz = konsikunde ).
  ENDTRY.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering
  IF NOT cl_vs_switch_check=>cmd_vmd_cvp_ilm_sfw_01( ) IS INITIAL AND
     NOT lt_msku[]                                     IS INITIAL.
    INCLUDE erp_cvp_mm_i3_c_trx0028 IF FOUND.
  ENDIF.
** end_EoP_adaptation

  LOOP AT lt_msku ASSIGNING <ls_msku>.
    MOVE-CORRESPONDING <ls_msku> TO msku.
    CASE <ls_msku>-sobkz.
      WHEN lrgutkunde.
        PERFORM msku_lrgut_kumulieren USING msku-matnr.
      WHEN konsikunde.
        PERFORM msku_konsi_kumulieren USING msku-matnr.
    ENDCASE.
    READ TABLE prt_matnr WITH KEY matnr = <ls_msku>-matnr.
    IF gv_tree EQ space.
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        CASE <ls_msku>-sobkz.
          WHEN lrgutkunde.
            PERFORM msku_lrgut_kumulieren USING prt_matnr-satnr.
          WHEN konsikunde.
            PERFORM msku_konsi_kumulieren USING prt_matnr-satnr.
        ENDCASE.
      ENDIF.
    ENDIF.
    ENDIF.
  ENDLOOP.
  ENDIF.

ENDFORM.                               " KUNDEN_BESTAENDE_ALL


* ( This FORM is replaced by FORM KUNDEN_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  KUNDEN_BESTAENDE
**&---------------------------------------------------------------------*
**       MSKU-Bestandsdaten lesen und ablegen
**----------------------------------------------------------------------*
*FORM kunden_bestaende.
*
**--- Lesen und kumulieren Kundenantenkonsignation und -leergut --------*
*  SELECT * FROM msku FOR ALL ENTRIES IN t_werks
**         WHERE matnr =  t_matnr-matnr    " TGA/4.6 Erw. Lot
*          WHERE matnr =  prt_matnr-matnr     " TGA/4.6 Erw. Lot
*         AND   werks =  t_werks-werks
*         AND ( sobkz = lrgutkunde OR sobkz = konsikunde ).
*    CASE msku-sobkz.
*      WHEN lrgutkunde.
*        PERFORM msku_lrgut_bestaende.
*      WHEN konsikunde.
*        PERFORM msku_konsi_bestaende.
*    ENDCASE.
*  ENDSELECT.
*
*ENDFORM.                               " KUNDEN_BESTAENDE

* ( This FORM is replaced by FORM KUNDEN_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  MSKU_LRGUT_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Kundenleergutbestände in den interen Tabellen
**    2) Falls das Material eine Variante ist, werden auch die Best.
**       für den zugehörenden Sammelartikel fortgeschrieben.
**----------------------------------------------------------------------*
*FORM msku_lrgut_bestaende.
*
**  PERFORM msku_lrgut_kumulieren USING t_matnr-matnr.   " TGA/4.6 Erw. L
*  PERFORM msku_lrgut_kumulieren USING prt_matnr-matnr. " TGA/4.6 Erw. Lo
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                  " TGA/4.6 Erw. Lot
**   READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. Lo
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr " TGA/4.6 Erw.
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**      PERFORM msku_lrgut_kumulieren USING t_matnr-satnr.  " TGA/4.6 Erw
*      PERFORM msku_lrgut_kumulieren USING prt_matnr-satnr. " TGA/4.6 Erw
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MSKU_LRGUT_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MSKU_LRGUT_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Kundenleergutbestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM msku_lrgut_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = msku-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD msku-kulab TO prt_wbe-kulav.
    ADD msku-kuins TO prt_wbe-kuinv.
    ADD msku-kuein TO prt_wbe-kueiv.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MSKU-KULAB TO BBE-KULAV.
*     ADD MSKU-KUINS TO BBE-KUINV.
*     ADD MSKU-KUEIN TO BBE-KUEIV.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD msku-kulab TO prt_gbe-kulav.
      ADD msku-kuins TO prt_gbe-kuinv.
      ADD msku-kuein TO prt_gbe-kueiv.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD msku-kulab TO prt_mbe-kulav.
        ADD msku-kuins TO prt_mbe-kuinv.
        ADD msku-kuein TO prt_mbe-kueiv.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Aufnehmen Kundenleergutbestände in die Tabelle VBS --------------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Organ.zuordnung u.  -*
*---- Kundenzuordnung exist.                                          -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_vbs WITH KEY matnr = pi_matnr
                          werks = msku-werks
                          kunnr = msku-kunnr   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD msku-kulab TO prt_vbs-labst.
    ADD msku-kuins TO prt_vbs-insme.
    ADD msku-kuein TO prt_vbs-einme.
    MODIFY prt_vbs INDEX sy-tabix.
  ELSE.
    CLEAR prt_vbs.
    MOVE-CORRESPONDING msku TO prt_vbs.
    MOVE msku-kulab TO prt_vbs-labst.
    MOVE msku-kuins TO prt_vbs-insme.
    MOVE msku-kuein TO prt_vbs-einme.
    IF msku-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MSKU-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> VBS-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_vbs-matnr.
    ELSE.
      MOVE prt_matnr-satnr TO prt_vbs-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_vbs INDEX sy-tabix.
  ENDIF.

ENDFORM.                               " MSKU_LRGUT_KUMULIEREN

* ( This FORM is replaced by FORM KUNDEN_BESTAENDE_ALL (Retail on Hana Optimization)
**&---------------------------------------------------------------------*
**&      Form  MSKU_KONSI_BESTAENDE
**&---------------------------------------------------------------------*
**    1) Merken der Kundenkonsibestände in den interen Tabellen
**    2) Falls das Material eine Variante ist, werden auch die Best.
**       für den zugehörenden Sammelartikel fortgeschrieben.
**----------------------------------------------------------------------*
*FORM msku_konsi_bestaende.
*
**  PERFORM msku_konsi_kumulieren USING t_matnr-matnr.  " TGA/4.6 Erw. Lo
*  PERFORM msku_konsi_kumulieren USING prt_matnr-matnr.   " TGA/4.6 Erw.
*
**---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
**---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
**---- höht werden                                                  ----*
**  IF t_matnr-attyp = attyp_var.                 " TGA/4.6 Erw. Lot
**    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.
*  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
*               BINARY SEARCH           "Werte der Variante nicht
*               TRANSPORTING NO FIELDS. "überschreiben!!
*    IF sy-subrc = 0.
**      PERFORM msku_konsi_kumulieren USING t_matnr-satnr.  " TGA/4.6 Erw
*      PERFORM msku_konsi_kumulieren USING prt_matnr-satnr.   " TGA/4.6 E
*    ENDIF.
*  ENDIF.
*
*ENDFORM.                               " MSKU_KONSI_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MSKU_KONSI_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Kundenkonsibestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM msku_konsi_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = msku-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD msku-kulab TO prt_wbe-kulaw.
    ADD msku-kuins TO prt_wbe-kuinw.
    ADD msku-kuein TO prt_wbe-kueiw.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD MSKU-KULAB TO BBE-KULAW.
*     ADD MSKU-KUINS TO BBE-KUINW.
*     ADD MSKU-KUEIN TO BBE-KUEIW.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD msku-kulab TO prt_gbe-kulaw.
      ADD msku-kuins TO prt_gbe-kuinw.
      ADD msku-kuein TO prt_gbe-kueiw.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD msku-kulab TO prt_mbe-kulaw.
        ADD msku-kuins TO prt_mbe-kuinw.
        ADD msku-kuein TO prt_mbe-kueiw.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

  IF p_chrg EQ 'X'.
    READ TABLE prt_wbs_seg WITH KEY matnr = pi_matnr
                               werks = msku-werks
                               charg = msku-charg
                               kunnr = msku-kunnr   BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD msku-kulab TO prt_wbs-labst.
      ADD msku-kuins TO prt_wbs-insme.
      ADD msku-kuein TO prt_wbs-einme.
      MODIFY prt_wbs_seg INDEX sy-tabix.
    ELSE.
      CLEAR prt_wbs_seg.
      MOVE-CORRESPONDING msku TO prt_wbs_seg.
      MOVE msku-kulab TO prt_wbs_seg-labst.
      MOVE msku-kuins TO prt_wbs_seg-insme.
      MOVE msku-kuein TO prt_wbs_seg-einme.
      IF msku-matnr <> pi_matnr.
*----   Falls Sammelartikel behandelt werden, enthält MSKU-MATNR die ----*
*----   Variante und nicht den Sammelartikel -> WBS-MATNR umsetzen   ----*
        MOVE pi_matnr TO prt_wbs_seg-matnr.
      ELSE.
        MOVE prt_matnr-satnr TO prt_wbs_seg-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
      ENDIF.
      INSERT prt_wbs_seg INDEX sy-tabix.
    ENDIF.
  ELSE.
*---- Aufnehmen Kundenkonsibestände in die Tabelle WBS ----------------*
*---- Anmerkung: in der normalen Bestandsübersicht (RMMMBEST) hat ein -*
*---- einfaches APPEND ausgereicht. Hier tritt jedoch der Fall auf,   -*
*---- daß Bestände zu zwei Varianten mit gleicher Organ.zuordnung u.  -*
*---- Kundenzuordnung exist.                                          -*
*---- Werden diese nun auch dem Sammelartikel hinzugerechnet, würde   -*
*---- dies bei einem APPEND zu zwei getrennten Datensätzen führen,    -*
*---- anstatt zu einem kumulierten Datensatz                          -*
*---- -> kein APPEND, sondern READ u. MODIFY/INSERT bei der Anlage    -*
  READ TABLE prt_wbs WITH KEY matnr = pi_matnr
                              werks = msku-werks
                              kunnr = msku-kunnr   BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD msku-kulab TO prt_wbs-labst.
    ADD msku-kuins TO prt_wbs-insme.
    ADD msku-kuein TO prt_wbs-einme.
    MODIFY prt_wbs INDEX sy-tabix.
  ELSE.
    CLEAR prt_wbs.
    MOVE-CORRESPONDING msku TO prt_wbs.
    MOVE msku-kulab TO prt_wbs-labst.
    MOVE msku-kuins TO prt_wbs-insme.
    MOVE msku-kuein TO prt_wbs-einme.
    IF msku-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält MSKU-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> WBS-MATNR umsetzen   ----*
      MOVE pi_matnr TO prt_wbs-matnr.
    ELSE.
      MOVE prt_matnr-satnr TO prt_wbs-satnr. "wg. besserem Zugriffsverh.
      "bei Matrixdarstellung f. Varianten
    ENDIF.
    INSERT prt_wbs INDEX sy-tabix.
  ENDIF.
  ENDIF.

ENDFORM.                               " MSKU_KONSI_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  OFFENE_BESTELLUNGEN
*&---------------------------------------------------------------------*
*       EKPO-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM offene_bestellungen.

*--- Lesen und kumulieren offene Bestellmenge/Konsibestellmenge -------*
* Anmerkung:
* Auch zum Sammelartikel können offene Bestelldaten vorliegen. Insgesamt
* können nur folgende beiden Konstellationen auftreten:
* 1) in der Bestellung werden nur die Varianten ohne Bezug zu einem
*    Sammelartikel erfaßt.
* 2) in der Bestellung wird der Sammelartikel und die Aufteilung der
*    Bestellmenge auf die Varianten erfaßt
* -> eine gesonderte Suche über den Sammelartikel entfällt somit, da es
*    nicht vorkommt, daß nur ein Sammelartikel in einer Bestellung auf-
*    taucht.
  CLEAR xtab. REFRESH xtab.
  CALL FUNCTION 'MB_ADD_PURCHASE_ORDER_QUANTITY'
    EXPORTING
*     x_matnr = t_matnr-matnr         " TGA/4.6 Erw. Lot
*     x_meins = t_matnr-basme         " TGA/4.6 Erw. Lot
      x_matnr = prt_matnr-matnr  " TGA/4.6 Erw. Lot
      x_meins = prt_matnr-basme  " TGA/4.6 Erw. Lot
      x_elikz = space
      x_loekz = space
    TABLES
      xtab    = xtab
      xwerks  = r_werks.
  LOOP AT xtab.
    PERFORM ekpo_bestaende.
* tga/46C additions for ALV-tree start tga >991009
*-tabelle t_w_lbe wird hier mit werksbeständen versorgt, diese werks
*-bestände auf dem Lagerort werden für die spätere kumulation durch den
*- ALV benötigt
    IF NOT p_kzlgo IS INITIAL AND NOT p_kzvst0 IS INITIAL
                              AND xtab-lgort IS INITIAL.
      READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-matnr
                                  werks = xtab-werks INTO s_w_lbe.
      IF sy-subrc = 0.
        s_w_lbe-menge = xtab-menge.
        s_w_lbe-mengk = xtab-mengk.
        MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                       TRANSPORTING menge mengk.
      ELSE.
        MOVE-CORRESPONDING xtab TO s_w_lbe.
        INSERT s_w_lbe INTO t_w_lbe INDEX 1.
      ENDIF.
      CLEAR s_w_lbe .
      IF prt_matnr-attyp = attyp_var.
        READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr
                BINARY SEARCH           "Werte der Variante nicht
                TRANSPORTING NO FIELDS. "überschreiben!!
        IF sy-subrc = 0.
          READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-satnr
                                      werks = xtab-werks INTO s_w_lbe.
          IF sy-subrc = 0.
            ADD xtab-menge TO s_w_lbe-menge.
            ADD xtab-mengk TO s_w_lbe-mengk.
            MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                                       TRANSPORTING menge mengk.
          ELSE.
            s_w_lbe-menge  =  xtab-menge.
            s_w_lbe-mengk  =  xtab-mengk.
            s_w_lbe-werks  =  xtab-werks.
            s_w_lbe-matnr  =  prt_matnr-satnr.
            INSERT s_w_lbe INTO t_w_lbe INDEX 1.
          ENDIF.
          CLEAR s_w_lbe.
        ENDIF.
      ENDIF.
    ENDIF.

*  additions for ALV-tree end tga >991009
  ENDLOOP.

ENDFORM.                               " OFFENE_BESTELLUNGEN

*&---------------------------------------------------------------------*
*&      Form  OFFENE_BESTELLUNGEN_ALL
*&---------------------------------------------------------------------*
*       Reading Open PO Stock quantity based on EKPO, EKET for a set of
*       material, plant. This FORM can be used to replace form routine
*       OFFENE_BESTELLUNGEN in case a valid implmentation of BADI
*       RWBE_DB_OPTIMIZATIONS was found.
*----------------------------------------------------------------------*
FORM offene_bestellungen_all.

  LOOP AT xtab.
    PERFORM ekpo_kumulieren USING xtab-matnr.

*   If article is a variant of a generic article, the stock of the generic
*   article needs to be adjusted as well
    READ TABLE prt_matnr WITH KEY matnr = xtab-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM ekpo_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. Lo
      ENDIF.
    ENDIF.

*   Stock on storage location level is needed for ALV cummulation
    IF NOT p_kzlgo IS INITIAL AND NOT p_kzvst0 IS INITIAL
                              AND xtab-lgort IS INITIAL.
      READ TABLE t_w_lbe WITH KEY matnr = xtab-matnr
                                  werks = xtab-werks INTO s_w_lbe.
      IF sy-subrc = 0.
        s_w_lbe-menge = xtab-menge.
        s_w_lbe-mengk = xtab-mengk.
        MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                       TRANSPORTING menge mengk.
      ELSE.
        MOVE-CORRESPONDING xtab TO s_w_lbe.
        INSERT s_w_lbe INTO t_w_lbe INDEX 1.
      ENDIF.
      CLEAR s_w_lbe .
*     should be correct because of the above read statement at prt_matnr using <ls_data>
      IF prt_matnr-attyp = attyp_var.
        READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr
                BINARY SEARCH
                TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-satnr
                                      werks = xtab-werks INTO s_w_lbe.
          IF sy-subrc = 0.
            ADD xtab-menge TO s_w_lbe-menge.
            ADD xtab-mengk TO s_w_lbe-mengk.
            MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                                       TRANSPORTING menge mengk.
          ELSE.
            s_w_lbe-menge  =  xtab-menge.
            s_w_lbe-mengk  =  xtab-mengk.
            s_w_lbe-werks  =  xtab-werks.
            s_w_lbe-matnr  =  prt_matnr-satnr.
            INSERT s_w_lbe INTO t_w_lbe INDEX 1.
          ENDIF.
          CLEAR s_w_lbe.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.


ENDFORM.                               " OFFENE_BESTELLUNGEN_ALL





*&---------------------------------------------------------------------*
*&      Form  EKPO_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der offenen Bestellbestände in den interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM ekpo_bestaende.

*  PERFORM ekpo_kumulieren USING t_matnr-matnr.     " TGA/4.6 Erw. Lot
  PERFORM ekpo_kumulieren USING prt_matnr-matnr.    " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM ekpo_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw. Lot
      PERFORM ekpo_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. Lo
    ENDIF.
  ENDIF.

ENDFORM.                               " EKPO_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  EKPO_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der offenen Bestellmenge in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM ekpo_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = xtab-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab-menge TO prt_wbe-menge.
    ADD xtab-mengk TO prt_wbe-mengk.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD   XTAB-MENGE  TO BBE-MENGE.
*     ADD   XTAB-MENGK  TO BBE-MENGK.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab-menge TO prt_gbe-menge.
      ADD xtab-mengk TO prt_gbe-mengk.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab-menge TO prt_mbe-menge.
        ADD xtab-mengk TO prt_mbe-mengk.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Update Lagerortsummen, falls Bestellpos. Lagerort qualifiziert --*
  IF NOT xtab-lgort IS INITIAL.
    READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                                werks = xtab-werks
                                lgort = xtab-lgort   BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab-menge TO prt_lbe-menge.
      ADD xtab-mengk TO prt_lbe-mengk.
      MODIFY prt_lbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_lbe.
      MOVE-CORRESPONDING xtab TO prt_lbe.
      IF xtab-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält XTAB-MATNR die ----*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen   ----*
        MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*       SELECT SINGLE * FROM MARD INTO *MARD
*              WHERE  MATNR = PI_MATNR
*              AND    WERKS = XTAB-WERKS
*              AND    LGORT = XTAB-LGORT.
*       IF SY-SUBRC = 0.
*         MOVE *MARD-LVORM TO LBE-LVORM.
*       ELSE.
*         CLEAR LBE-LVORM.
*       ENDIF.
        tabix_alt = sy-tabix.
        READ TABLE t_mard INTO mard
                          WITH KEY matnr = pi_matnr
                                   werks = xtab-werks
                                   lgort = xtab-lgort
                          BINARY SEARCH.
        IF sy-subrc = 0.
          MOVE mard-lvorm TO prt_lbe-lvorm.
        ELSE.
          CLEAR prt_lbe-lvorm.
        ENDIF.
        sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
      ELSE.
        MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsver
        "bei Matrixdarstellung f. Varianten
      ENDIF.
      INSERT prt_lbe INDEX sy-tabix.
    ENDIF.
  ENDIF.

ENDFORM.                               " EKPO_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  OFFENE_UMLAGERUNG
*&---------------------------------------------------------------------*
*       EKUB-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM offene_umlagerung.

*--- Lesen und kumulieren offene Umlagerbestellmenge ------------------*
* Anmerkung:
* Auch zum Sammelartikel können offene Bestelldaten vorliegen. Insgesamt
* können nur folgende beiden Konstellationen auftreten:
* 1) in der Bestellung werden nur die Varianten ohne Bezug zu einem
*    Sammelartikel erfaßt.
* 2) in der Bestellung wird der Sammelartikel und die Aufteilung der
*    Bestellmenge auf die Varianten erfaßt
* -> eine gesonderte Suche über den Sammelartikel entfällt somit, da es
*    nicht vorkommt, daß nur ein Sammelartikel in einer Bestellung auf-
*    taucht.
  CLEAR xtab5. REFRESH xtab5.
  CALL FUNCTION 'MATERIAL_QUANTITIES_ULBS'
    EXPORTING
*     matnr     = t_matnr-matnr      " TGA/4.6 Erw. Lot
      matnr     = prt_matnr-matnr " TGA/4.6 Erw. Lot
    TABLES
      abmng_tab = xtab5
      werks_tab = r_werks.
  LOOP AT xtab5.
    PERFORM ekub_bestaende.
  ENDLOOP.

ENDFORM.                               " OFFENE_UMLAGERUNG

*&---------------------------------------------------------------------*
*&      Form  OFFENE_UMLAGERUNG_ALL
*&---------------------------------------------------------------------*
*       Read Stock Information of open stock transport orders
*       This Form routine can be called for all selected material/plants at once
*       In Case of an valid implemention of BADI RWBE_DB_OPTIMIZATIONS exist this
*       FORM routine replaces the FORM OFFENE_UMLAGERUNG.
*----------------------------------------------------------------------*
FORM offene_umlagerung_all TABLES it_open_sto_qty TYPE if_rwbe_dbsys_opt=>tt_open_sto.

  FIELD-SYMBOLS: <ls_open_sto_qty> LIKE LINE OF it_open_sto_qty .

  LOOP AT it_open_sto_qty ASSIGNING <ls_open_sto_qty>.
    MOVE-CORRESPONDING <ls_open_sto_qty> TO xtab5.
    PERFORM ekub_kumulieren USING <ls_open_sto_qty>-matnr.

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
    READ TABLE prt_matnr WITH KEY matnr = <ls_open_sto_qty>-matnr.

    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
        PERFORM ekub_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. Lo
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.    "     Form  OFFENE_UMLAGERUNG_ALL



*&---------------------------------------------------------------------*
*&      Form  EKUB_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der offenen Umlag.best.bestände in den interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM ekub_bestaende.

*  PERFORM ekub_kumulieren USING t_matnr-matnr.     " TGA/4.6 Erw. Lot
  PERFORM ekub_kumulieren USING prt_matnr-matnr.     " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                 " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw.
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM ekub_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw. Lot
      PERFORM ekub_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. Lo
    ENDIF.
  ENDIF.

ENDFORM.                               " EKUB_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  EKUB_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der offenen Umlag.bestellmenge in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM ekub_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = xtab5-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab5-meng1 TO prt_wbe-bsabr.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD   XTAB5-MENG1  TO BBE-BSABR.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab5-meng1 TO prt_gbe-bsabr.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab5-meng1 TO prt_mbe-bsabr.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " EKUB_KUMULIEREN


*&---------------------------------------------------------------------*
*&      Form  CROSSCOMP_UMLAGERUNG All
*&---------------------------------------------------------------------*
*       This Form routine contains the same logic as the exising
*       FORM CROSSCOMP_UMLAGERUNG but can be executed for a set of materials and plant
*       (Prefetch for Retail on HANA optimisation)
*       In general: Form routine reads cross company transfer stock
*----------------------------------------------------------------------*
FORM crosscomp_umlagerung_all.

  RANGES: xmatnr FOR prt_matnr-matnr,  " TGA/4.6 Erw. Lot
          xpstyp FOR ekpo-pstyp,
          xelikz FOR ekpo-elikz,
          xloekz FOR ekpo-loekz.
  REFRESH: xmatnr, xpstyp, xelikz, xloekz.
  FIELD-SYMBOLS: <ls_xtab6> LIKE LINE OF xtab6.

* Build up a material range table and use this for the function module call
  LOOP AT prt_matnr.
    xmatnr-sign   = xpstyp-sign   = xelikz-sign   = xloekz-sign   = 'I'.
    xmatnr-option = xpstyp-option = xelikz-option = xloekz-option = 'EQ'.
    xmatnr-low = prt_matnr-matnr.
    APPEND xmatnr.   " TGA/4.6 Erw. Lot
  ENDLOOP.

  xpstyp-low = '0'.           APPEND xpstyp.  " only cross company transit
  xelikz-low = ' '.           APPEND xelikz.
  xloekz-low = ' '.           APPEND xloekz.

  CALL FUNCTION 'MB_ADD_TRANSFER_QUANTITY'
    EXPORTING
      cumulate = 'X'
    TABLES
      xmatnr   = xmatnr
      xwerks   = r_werks
*     XRESWK   =
*     XSOBKZ   =
      xpstyp   = xpstyp
      xelikz   = xelikz
      xloekz   = xloekz
      xtab6    = xtab6.

  LOOP AT xtab6 ASSIGNING <ls_xtab6>.
    xtab6 = <ls_xtab6>.
    PERFORM trasf_kumulieren USING xtab6-matnr.  " TGA/4.6 Erw. Lot

    READ TABLE prt_matnr WITH KEY matnr = <ls_xtab6>-matnr.
*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
    IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
      READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
                 BINARY SEARCH           "Werte der Variante nicht
                 TRANSPORTING NO FIELDS. "überschreiben!!
      IF sy-subrc = 0.
*      PERFORM trasf_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw. Lo
        PERFORM trasf_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. L
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.  " CROSSCOMP_UMLAGERUNG_ALL

* (Form TRANS_BESTAENDE is integrated in new form CROSSCOMP_UMLAGERUNG_ALL)
* Still needed if a lot of materials/plants are selected                " n_2387753
*&---------------------------------------------------------------------*
*&      Form  TRASF_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der offenen Cross-Company-Umlag.bestellbestände in den
*       interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM trasf_bestaende.

*  PERFORM trasf_kumulieren USING t_matnr-matnr.   " TGA/4.6 Erw. Lot
  PERFORM trasf_kumulieren USING prt_matnr-matnr.  " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                   " TGA/4.6 Erw. Lot
*    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 E
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM trasf_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw. Lo
      PERFORM trasf_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. L
    ENDIF.
  ENDIF.

ENDFORM.                               " TRASF_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  TRASF_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der offenen Cross-Company-Umlagerungsbestellmenge in den
*       internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM trasf_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = xtab6-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab6-menge TO prt_wbe-trasf.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD   XTAB6-MENGE  TO BBE-TRASF.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab6-menge TO prt_gbe-trasf.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab6-menge TO prt_mbe-trasf.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " TRASF_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  WE_SPERRBESTAND
*&---------------------------------------------------------------------*
*       WESPB-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM we_sperrbestand.

*--- Lesen und kumulieren WE-Sperrbestand -----------------------------*
* Anmerkung:
* Auch zum Sammelartikel können offene Bestelldaten vorliegen. Insgesamt
* können nur folgende beiden Konstellationen auftreten:
* 1) in der Bestellung werden nur die Varianten ohne Bezug zu einem
*    Sammelartikel erfaßt.
* 2) in der Bestellung wird der Sammelartikel und die Aufteilung der
*    Bestellmenge auf die Varianten erfaßt
* -> eine gesonderte Suche über den Sammelartikel entfällt somit, da es
*    nicht vorkommt, daß nur ein Sammelartikel in einer Bestellung auf-
*    taucht.
  CLEAR xtab2. REFRESH xtab2.
  CALL FUNCTION 'MB_SELECT_GR_BLOCKED_STOCK'
    EXPORTING
*     x_matnr = t_matnr-matnr            " TGA/4.6 Erw. Lot
*     x_meins = t_matnr-basme            " TGA/4.6 Erw. Lot
      x_matnr = prt_matnr-matnr  " TGA/4.6 Erw. Lot
      x_meins = prt_matnr-basme  " TGA/4.6 Erw. Lot
    TABLES
      xtab2   = xtab2
      xwerks  = r_werks.
*Momentan enthält der Baustein noch einen Fehler, denn die interne
*Tabelle EKPOTAB wird nicht gelöscht, so daß sie sich bei Mehrfachauf-
*rufen sukzessive aufbaut und zuviele Einträge zurückgeliefert werden
*-> Behelfslösung: Löschen aller Einträge <> T_MATNR-MATNR
*Anmerkung: Fehler von mir am 16.10.96 im KIR behoben!
*DELETE XTAB2 WHERE MATNR <> T_MATNR-MATNR.                 "JH/16.10.96
  LOOP AT xtab2 WHERE wesbs <> 0.
*---- Nur Belege berücksichtigen, die auch einen WE-Sperrbestand <> 0 -*
*---- aufweisen                                                       -*
    PERFORM wespb_bestaende.
  ENDLOOP.

ENDFORM.                               " WE_SPERRBESTAND

*&---------------------------------------------------------------------*
*&      Form  WESPB_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der WE-Sperrbestände in den interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM wespb_bestaende.

*  PERFORM wespb_kumulieren USING t_matnr-matnr.      " TGA/4.6 Erw. Lot
  PERFORM wespb_kumulieren USING prt_matnr-matnr.     " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                      " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. L
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lo
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM wespb_kumulieren USING t_matnr-satnr.  " TGA/4.6 Erw. Lot
      PERFORM wespb_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. L
    ENDIF.
  ENDIF.

ENDFORM.                               " WESPB_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  WESPB_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der WE-Sperrbestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM wespb_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = xtab2-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab2-wesbs TO prt_wbe-wespb.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD   XTAB2-WESBS  TO BBE-WESPB.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab2-wesbs TO prt_gbe-wespb.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab2-wesbs TO prt_mbe-wespb.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                               " WESPB_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  NEUSTART_FEHLER
*&---------------------------------------------------------------------*
*       Programmneustart, um eine Fehlermeldung auszugeben und wieder
*       auf dem Selektionsbildschirm zu landen
*----------------------------------------------------------------------*
FORM neustart_fehler.
  DATA: message_text(200).             " CBI/WWW

*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
*---- Falls der Programmaufruf aus einem Bereichsmenü heraus erfolgte,
*---- Kennz. setzen, weil SY-CALLD nach Programmneustart nicht mehr
*---- initial ist
  IF sy-calld IS INITIAL AND p_mcall IS INITIAL.
    p_mcall = x.
  ENDIF.
  p_recall = 'E'.                      "wg. Error
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090

*---- CBI/WWW 16.11.98: Falls Report im Web läuft, nur Meldung ausgeben
  IF p_submit_info-www_active IS INITIAL.                   "WWW

*---- Neustart des Programms, wobei die vorher erzeugte Success- ------*
*---- meldung auf dem neu prozessierten Selektionsbildschirm er- ------*
*---- scheint                                                    ------*
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
             WITH s_sobkz IN s_sobkz
             WITH p_vernu =  p_vernu
             WITH p_kznul =  p_kznul
             WITH p_kzbwg =  p_kzbwg
             WITH p_kzwer =  p_kzwer
             WITH p_kzlgo =  p_kzlgo
             WITH p_kzson =  p_kzson
             WITH p_meinh =  p_meinh
             WITH p_field =  p_field
*//JH 19.09.96 zu 1.2A1 (Anfang) -> Int.Pr. 208090
*          WITH P_SUBMIT = X
             WITH p_recall = p_recall
             WITH p_mcall  = p_mcall
             WITH p_iltest = g_iltest
*//JH 19.09.96 zu 1.2A1 (Ende) -> Int.Pr. 208090
             VIA SELECTION-SCREEN.
*---- CBI/WWW begin 16.11.98: Meldungstext ermitteln, ausgeben, finito
*!!!! klappt leider nicht beim interaktiven Web-Reporting, da STOP
*!!!! das Web-Reporting mit abschießt!
  ELSE.
*   SET PF-STATUS 'leer'.   "JH/29.04.98 auskomm. wg. SLIN
    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = sy-msgid
        msgnr               = sy-msgno
        msgv1               = sy-msgv1
        msgv2               = sy-msgv2
        msgv3               = sy-msgv3
        msgv4               = sy-msgv4
      IMPORTING
        message_text_output = message_text.
    WRITE: / message_text.
    STOP.
  ENDIF.
*---- CBI/WWW end

ENDFORM.                               " NEUSTART_FEHLER

*&---------------------------------------------------------------------*
*&      Form  AB_ZU_RESERVIERUNG
*&---------------------------------------------------------------------*
*       RESB-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM ab_zu_reservierung.

*--- Lesen und kumulieren geplanter Zu- und Abgängsmengen -------------*

*---- Es werden nur wirkliche Reservierungen (im Sinne der Bestands-/ -*
*---- Bedarfsliste) ermittelt. Hierzu werden dem folgenden FB die     -*
*---- relevanten Beadarfsarten 'abhängige Reservierung' und 'manuelle -*
*---- Reservierung' mitgegeben.                                       -*
  REFRESH r_bdart.
  CLEAR   r_bdart.
  r_bdart-sign   = 'I'.
  r_bdart-option = 'EQ'.
  r_bdart-low    = arbed.
  APPEND r_bdart.
  r_bdart-low    = mtres.
  APPEND r_bdart.

  CLEAR xtab1. REFRESH xtab1.
  CALL FUNCTION 'MB_ADD_RESERVATION_QUANTITIES'
    EXPORTING
*     x_matnr = t_matnr-matnr           " TGA/4.6 Erw. Lot
      x_matnr = prt_matnr-matnr  " TGA/4.6 Erw. Lot
      x_xloek = space
      x_kzear = space
    TABLES
      xtab1   = xtab1
      xwerks  = r_werks
      xbdart  = r_bdart.
  LOOP AT xtab1.
    PERFORM resb_bestaende.
* TGA/46C additions for ALV-tree start tga >991009
*-tabelle t_w_lbe wird hier mit werksbeständen versorgt, diese werks
*-bestände auf dem Lagerort werden für die spätere kumulation durch den
*- ALV benötigt
    IF NOT p_kzlgo IS INITIAL AND NOT p_kzvst0 IS INITIAL
                              AND xtab1-lgort IS INITIAL.
      READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-matnr
                                  werks = xtab1-werks INTO s_w_lbe.
      IF sy-subrc = 0.
        ADD xtab1-bdmng TO s_w_lbe-bdmng.
        ADD xtab1-bdmns TO s_w_lbe-bdmns.
        MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                       TRANSPORTING bdmng bdmns.
      ELSE.
        MOVE-CORRESPONDING xtab1 TO s_w_lbe.
        INSERT s_w_lbe INTO t_w_lbe INDEX 1.
      ENDIF.
*    ENDIF.
      CLEAR s_w_lbe .
      IF prt_matnr-attyp = attyp_var.
        READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr
                BINARY SEARCH           "Werte der Variante nicht
                TRANSPORTING NO FIELDS. "überschreiben!!
        IF sy-subrc = 0.
          READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-satnr
                                     werks = xtab1-werks INTO s_w_lbe.
          IF sy-subrc = 0.
            ADD xtab1-bdmng TO s_w_lbe-bdmng.
            ADD xtab1-bdmns TO s_w_lbe-bdmns.
            MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                                       TRANSPORTING bdmng bdmns.
          ELSE.
            s_w_lbe-bdmng  =  xtab1-bdmng.
            s_w_lbe-bdmns  =  xtab1-bdmns.
            s_w_lbe-werks  =  xtab1-werks.
            s_w_lbe-matnr  =  prt_matnr-satnr.
            INSERT s_w_lbe INTO t_w_lbe INDEX 1.
          ENDIF.
          CLEAR s_w_lbe.
        ENDIF.
      ENDIF.
    ENDIF.

*  additions for ALV-tree end tga >991009
  ENDLOOP.

ENDFORM.                               " AB_ZU_RESERVIERUNG

*&---------------------------------------------------------------------*
*&      Form  RESB_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der Reservierungen in den interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM resb_bestaende.

*  PERFORM resb_kumulieren USING t_matnr-matnr.      " TGA/4.6 Erw. Lot
  PERFORM resb_kumulieren USING prt_matnr-matnr.     " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                      " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. L
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM resb_kumulieren USING t_matnr-satnr.   " TGA/4.6 Erw. Lot
      PERFORM resb_kumulieren USING prt_matnr-satnr.   " TGA/4.6 Erw. Lo
    ENDIF.
  ENDIF.

ENDFORM.                               " RESB_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  RESB_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Zu- und Abgangsreservierungen in den internen Tab.
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM resb_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                              werks = xtab1-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab1-bdmng TO prt_wbe-bdmng.
    ADD xtab1-bdmns TO prt_wbe-bdmns.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD  XTAB1-BDMNG  TO BBE-BDMNG.
*     ADD  XTAB1-BDMNS  TO BBE-BDMNS.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                                bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab1-bdmng TO prt_gbe-bdmng.
      ADD xtab1-bdmns TO prt_gbe-bdmns.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab1-bdmng TO prt_mbe-bdmng.
        ADD xtab1-bdmns TO prt_mbe-bdmns.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Update Lagerortsummen, falls Reservierung Lagerort qualifiziert -*
  IF NOT xtab1-lgort IS INITIAL.
    READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                            werks = xtab1-werks
                            lgort = xtab1-lgort   BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab1-bdmng TO prt_lbe-bdmng.
      ADD xtab1-bdmns TO prt_lbe-bdmns.
      MODIFY prt_lbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_lbe.
      MOVE-CORRESPONDING xtab1 TO prt_lbe.
      IF xtab1-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält XTAB1-MATNR die ---*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen    ---*
        MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*       SELECT SINGLE * FROM MARD INTO *MARD
*              WHERE  MATNR = PI_MATNR
*              AND    WERKS = XTAB1-WERKS
*              AND    LGORT = XTAB1-LGORT.
*       IF SY-SUBRC = 0.
*         MOVE *MARD-LVORM TO LBE-LVORM.
*       ELSE.
*         CLEAR LBE-LVORM.
*       ENDIF.
        tabix_alt = sy-tabix.
        READ TABLE t_mard INTO mard
                          WITH KEY matnr = pi_matnr
                                   werks = xtab1-werks
                                   lgort = xtab1-lgort
                          BINARY SEARCH.
        IF sy-subrc = 0.
          MOVE mard-lvorm TO prt_lbe-lvorm.
        ELSE.
          CLEAR prt_lbe-lvorm.
        ENDIF.
        sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
      ELSE.
        MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsver
        " bei Matrixdarstellung f. Varianten
      ENDIF.
      INSERT prt_lbe INDEX sy-tabix.
    ENDIF.
  ENDIF.

ENDFORM.                               " RESB_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  VERTRIEBS_BEDARFE
*&---------------------------------------------------------------------*
*       VBBE-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM vertriebs_bedarfe.

*--- Lesen und kumulieren Vertriebsbedarfsmengen ----------------------*
* Anmerkung: ????
* Wenn die Bedarfsart zum entsprechenden Vertriebsbedarf (Anfrage,
* Angebot, Auftrag, Lieferplan, Kontrakt, ...) im Customizing nicht als
* bedarfsrelevant gekennzeichnet ist, findet auch keine Fortschreibung
* der Daten von VBAP in VBBE/VBBS statt, so daß keine Vertriebsbedarfs-
* daten angezeigt werden können
  CLEAR xtab4. REFRESH xtab4.
  CALL FUNCTION 'MB_SELECT_SD_SCHEDULED_STOCK'
    EXPORTING
*     x_matnr = t_matnr-matnr            " TGA/4.6 Erw. Lot
      x_matnr = prt_matnr-matnr  " TGA/4.6 Erw. Lot
    TABLES
      xtab4   = xtab4
      xwerks  = r_werks.
  LOOP AT xtab4.
    PERFORM vbbe_bestaende.
*  additions for ALV-tree start tga >991009
*-tabelle t_w_lbe wird hier mit werksbeständen versorgt, diese werks
*-bestände auf dem Lagerort werden für die spätere kumulation durch den
*- ALV benötigt
    IF NOT p_kzlgo IS INITIAL AND NOT p_kzvst0 IS INITIAL
                      AND xtab4-lgort IS INITIAL. "<<<insert note 0207599
*                    AND xtab1-lgort IS INITIAL. "<<<delete note 0207599
      READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-matnr
                                  werks = xtab4-werks INTO s_w_lbe.
      IF sy-subrc = 0.
        MOVE xtab4-vbmna TO s_w_lbe-vbmna.
        MOVE xtab4-vbmnb TO s_w_lbe-vbmnb.
        MOVE xtab4-vbmnc TO s_w_lbe-vbmnc.
        MOVE xtab4-vbmne TO s_w_lbe-vbmne.
        MOVE xtab4-vbmng TO s_w_lbe-vbmng.
        MOVE xtab4-vbmni TO s_w_lbe-vbmni.
        MOVE xtab4-omeng TO s_w_lbe-omeng.
        MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
               TRANSPORTING vbmna vbmnb vbmnc vbmne vbmng vbmni omeng.
      ELSE.
        MOVE-CORRESPONDING xtab4 TO s_w_lbe.
        INSERT s_w_lbe INTO t_w_lbe INDEX 1.
      ENDIF.
*    ENDIF.
      CLEAR s_w_lbe .
      IF prt_matnr-attyp = attyp_var.
        READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr
                BINARY SEARCH           "Werte der Variante nicht
                TRANSPORTING NO FIELDS. "überschreiben!!
        IF sy-subrc = 0.
          READ TABLE t_w_lbe WITH KEY matnr = prt_matnr-satnr
* tga note 356164
                                      werks = xtab4-werks INTO s_w_lbe.
*                                  werks = xtab1-werks into s_w_lbe.
          IF sy-subrc = 0.
            ADD xtab4-vbmna TO s_w_lbe-vbmna.
            ADD xtab4-vbmnb TO s_w_lbe-vbmnb.
            ADD xtab4-vbmnc TO s_w_lbe-vbmnc.
            ADD xtab4-vbmne TO s_w_lbe-vbmne.
            ADD xtab4-vbmng TO s_w_lbe-vbmng.
            ADD xtab4-vbmni TO s_w_lbe-vbmni.
            ADD xtab4-omeng TO s_w_lbe-omeng.
            MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
                   TRANSPORTING vbmna vbmnb vbmnc vbmne vbmng vbmni omeng.
          ELSE.
            MOVE xtab4-vbmna TO s_w_lbe-vbmna.
            MOVE xtab4-vbmnb TO s_w_lbe-vbmnb.
            MOVE xtab4-vbmnc TO s_w_lbe-vbmnc.
            MOVE xtab4-vbmne TO s_w_lbe-vbmne.
            MOVE xtab4-vbmng TO s_w_lbe-vbmng.
            MOVE xtab4-vbmni TO s_w_lbe-vbmni.
            MOVE xtab4-omeng TO s_w_lbe-omeng.
* tga note 356164
            MOVE prt_matnr-satnr TO s_w_lbe-matnr.
*       move xtab4-matnr to s_w_lbe-matnr.
            MOVE xtab4-werks TO s_w_lbe-werks.
            INSERT s_w_lbe INTO t_w_lbe INDEX 1.
          ENDIF.
          CLEAR s_w_lbe.
        ENDIF.
      ENDIF.
    ENDIF.
*  additions for ALV-tree end tga >991009
  ENDLOOP.

ENDFORM.                               " VERTRIEBS_BEDARFE

*&---------------------------------------------------------------------*
*&      Form  VBBE_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der Vertriebsbedarfe in den interen Tabellen
*    2) Falls das Material eine Variante ist, werden auch die Best.
*       für den zugehörenden Sammelartikel fortgeschrieben.
*----------------------------------------------------------------------*
FORM vbbe_bestaende.

*  PERFORM vbbe_kumulieren USING t_matnr-matnr.    " TGA/4.6 Erw. Lot
  PERFORM vbbe_kumulieren USING prt_matnr-matnr.   " TGA/4.6 Erw. Lot

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
*  IF t_matnr-attyp = attyp_var.                   " TGA/4.6 Erw. Lot
*    READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr  " TGA/4.6 Erw. L
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr  " TGA/4.6 Erw
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*      PERFORM vbbe_kumulieren USING t_matnr-satnr.  " TGA/4.6 Erw. Lot
      PERFORM vbbe_kumulieren USING prt_matnr-satnr.  " TGA/4.6 Erw. Lot
    ENDIF.
  ENDIF.

ENDFORM.                               " VBBE_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  VBBE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der Vertriebsbedarfe in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM vbbe_kumulieren USING pi_matnr LIKE mara-matnr.

  DATA: tabix_alt LIKE sy-tabix.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                              werks = xtab4-werks  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD xtab4-vbmna TO prt_wbe-vbmna.
    ADD xtab4-vbmnb TO prt_wbe-vbmnb.
    ADD xtab4-vbmnc TO prt_wbe-vbmnc.
    ADD xtab4-vbmne TO prt_wbe-vbmne.
    ADD xtab4-vbmng TO prt_wbe-vbmng.
    ADD xtab4-vbmni TO prt_wbe-vbmni.
    ADD xtab4-omeng TO prt_wbe-omeng.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD  XTAB4-VBMNA TO  BBE-VBMNA.
*     ADD  XTAB4-VBMNB TO  BBE-VBMNB.
*     ADD  XTAB4-VBMNC TO  BBE-VBMNC.
*     ADD  XTAB4-VBMNE TO  BBE-VBMNE.
*     ADD  XTAB4-VBMNG TO  BBE-VBMNG.
*     ADD  XTAB4-VBMNI TO  BBE-VBMNI.
*     ADD  XTAB4-OMENG TO  BBE-OMENG.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                                bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab4-vbmna TO prt_gbe-vbmna.
      ADD xtab4-vbmnb TO prt_gbe-vbmnb.
      ADD xtab4-vbmnc TO prt_gbe-vbmnc.
      ADD xtab4-vbmne TO prt_gbe-vbmne.
      ADD xtab4-vbmng TO prt_gbe-vbmng.
      ADD xtab4-vbmni TO prt_gbe-vbmni.
      ADD xtab4-omeng TO prt_gbe-omeng.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD xtab4-vbmna TO prt_mbe-vbmna.
        ADD xtab4-vbmnb TO prt_mbe-vbmnb.
        ADD xtab4-vbmnc TO prt_mbe-vbmnc.
        ADD xtab4-vbmne TO prt_mbe-vbmne.
        ADD xtab4-vbmng TO prt_mbe-vbmng.
        ADD xtab4-vbmni TO prt_mbe-vbmni.
        ADD xtab4-omeng TO prt_mbe-omeng.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Update Lagerortsummen, falls Vertr.bedarf Lagerort qualifiziert -*
  IF NOT xtab4-lgort IS INITIAL.
    READ TABLE prt_lbe WITH KEY matnr = pi_matnr
                                werks = xtab4-werks
                                lgort = xtab4-lgort   BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD xtab4-vbmna TO prt_lbe-vbmna.
      ADD xtab4-vbmnb TO prt_lbe-vbmnb.
      ADD xtab4-vbmnc TO prt_lbe-vbmnc.
      ADD xtab4-vbmne TO prt_lbe-vbmne.
      ADD xtab4-vbmng TO prt_lbe-vbmng.
      ADD xtab4-vbmni TO prt_lbe-vbmni.
      ADD xtab4-omeng TO prt_lbe-omeng.
      MODIFY prt_lbe INDEX sy-tabix.
    ELSE.
      CLEAR prt_lbe.
      MOVE-CORRESPONDING xtab4 TO prt_lbe.
      IF xtab4-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält XTAB1-MATNR die ---*
*---- Variante und nicht den Sammelartikel -> LBE-MATNR umsetzen    ---*
        MOVE pi_matnr TO prt_lbe-matnr.
*---- Löschkennzeichen d. Sammelart. auf Lagerortebene bestimmen ------*
*#JHL 14.05.96 (Anfang) Aus Performancegründen ersetzt durch Prefetching
*       SELECT SINGLE * FROM MARD INTO *MARD
*              WHERE  MATNR = PI_MATNR
*              AND    WERKS = XTAB4-WERKS
*              AND    LGORT = XTAB4-LGORT.
*       IF SY-SUBRC = 0.
*         MOVE *MARD-LVORM TO LBE-LVORM.
*       ELSE.
*         CLEAR LBE-LVORM.
*       ENDIF.
        tabix_alt = sy-tabix.
        READ TABLE t_mard INTO mard
                          WITH KEY matnr = pi_matnr
                                   werks = xtab4-werks
                                   lgort = xtab4-lgort
                          BINARY SEARCH.
        IF sy-subrc = 0.
          MOVE mard-lvorm TO prt_lbe-lvorm.
        ELSE.
          CLEAR prt_lbe-lvorm.
        ENDIF.
        sy-tabix = tabix_alt.
*#JHL 14.05.96 (Ende)
      ELSE.
        MOVE prt_matnr-satnr TO prt_lbe-satnr. "wg. besserem Zugriffsver
        " bei Matrixdarstellung f. Varianten
      ENDIF.
      INSERT prt_lbe INDEX sy-tabix.
    ENDIF.
  ENDIF.

ENDFORM.                               " VBBE_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  ME_ZUM_MATERIAL
*&---------------------------------------------------------------------*
*       Mögliche Mengeneinheiten zu einem Material bestimmen u. ablegen
*----------------------------------------------------------------------*
*  -->  PI_MATNR   Materialsatz
*----------------------------------------------------------------------*
FORM me_zum_material USING pi_matnr STRUCTURE t_matnr.

  CALL FUNCTION 'MATERIAL_UNIT_FIND_30'
    EXPORTING
      kzall              = 'X'
      matnr              = pi_matnr-matnr
      meins              = pi_matnr-basme
    TABLES
      rmmme1_itab        = x_meeinh
    EXCEPTIONS
      material_not_found = 01.

  LOOP AT x_meeinh.
    MOVE               pi_matnr-matnr TO t_meeinh-matnr.
    MOVE-CORRESPONDING x_meeinh       TO t_meeinh.
    APPEND t_meeinh.

    READ TABLE t_metext WITH KEY meinh = t_meeinh-meinh
                        BINARY SEARCH.
    IF sy-subrc NE 0.
*---- Texte zu den Mengeneinheiten bestimmen --------------------------*
      CLEAR t006a.
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = x_meeinh-meinh
          language       = sy-langu
        IMPORTING
          long_text      = t006a-msehl
        EXCEPTIONS
          unit_not_found = 01.

      t_metext-meinh = x_meeinh-meinh.
      t_metext-msehl = t006a-msehl.
      APPEND t_metext.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " ME_ZUM_MATERIAL

*&---------------------------------------------------------------------*
*&      Form  LESE_VAR_BEWERTUNG
*&---------------------------------------------------------------------*
*       Bewertungsdaten zu den übergebenen Varianten ermitteln         *
*----------------------------------------------------------------------*
*  -->  PI_VARNR  Liste der Varianten
*----------------------------------------------------------------------*
FORM lese_var_bewertung TABLES pi_varnr STRUCTURE mara.

  RANGES: x_atinn FOR ausp-atinn, "Liste der variantenbildenden Merkmale
          x_objek FOR kssk-objek.      "Liste der relevanten Varianten

  DATA: x_merkm LIKE t_merkm.          "Damit alter Eintrag von T_MERKM
  "nicht überschrieben wird

*---- Liste der zu berücksichtigenden Merkmale zusammenstellen --------*
  x_atinn-sign   = 'I'.
  x_atinn-option = 'EQ'.
  LOOP AT t_merkm INTO x_merkm.
    x_atinn-low = x_merkm-atinn.
    APPEND x_atinn.
  ENDLOOP.

*---- Liste der zu berücksichtigenden Varianten zusammenstellen -------*
  x_objek-sign   = 'I'.
  x_objek-option = 'EQ'.
  LOOP AT pi_varnr.
    x_objek-low = pi_varnr-cuobf.
    APPEND x_objek.
  ENDLOOP.

  REFRESH t_ausp.

*---- Bewertungen zu den relevanten Merkmalen für alle potentiellen ---*
*---- Varianten lesen                                               ---*
  CALL FUNCTION 'CLSE_SELECT_AUSP'
    EXPORTING
      klart                     = wghier_klart
      mafid                     = 'O'
      key_date                  = sy-datum
    TABLES
      in_objek                  = x_objek
      in_atinn                  = x_atinn
      t_ausp                    = t_ausp
    EXCEPTIONS
      no_entry_found            = 1
      parameters_not_sufficient = 2
      OTHERS                    = 3.

  IF sy-subrc NE 0.
    MESSAGE a042.
*    Keine Bewertungsdaten für die Variantenmerkmale gefunden!
  ENDIF.

ENDFORM.                               " LESE_VAR_BEWERTUNG


*&---------------------------------------------------------------------*
*&      Form  HANA_HINT
*&---------------------------------------------------------------------*
*       This Form Routine creates a HANA DB hint used for the optimization
*       of the FAE (FOR ALL ENTRIES) statement, for details please refer to
*       OSS note 1662726.
*
*       Parameters:  IV_TABL_NAM - contains the table name for which the db hint is created
*                    IV_LINE     - contains the number of lines of the FAE table
*                    RV_HINT     - returns the generated HANA DB hint
*----------------------------------------------------------------------*
FORM hana_hint TABLES   it_fae_tab   TYPE STANDARD TABLE
               USING    iv_tabl_nam  TYPE tabname16
                        iv_num_field TYPE i

               CHANGING rv_hint TYPE rsdu_hint
               RAISING  cx_wrt_fae_hint_error.

* Create a Hint for HANA DB using the importing values
  DATA: lr_hint    TYPE REF TO cl_wrt_reuse_fae_hint.
  FIELD-SYMBOLS: <lt_fae_tab> TYPE data.

  ASSIGN it_fae_tab[] TO <lt_fae_tab>.
  lr_hint = cl_wrt_reuse_fae_hint=>get_instance( ).

  TRY.
      CALL METHOD lr_hint->get_hint_for_table
        EXPORTING
          iv_db_table_name = iv_tabl_nam
          iv_no_fae_fields = iv_num_field
          it_fae_table     = <lt_fae_tab>
        RECEIVING
          rv_hint          = rv_hint.
    CATCH cx_wrt_fae_hint_error.
      RAISE EXCEPTION TYPE cx_wrt_fae_hint_error.
  ENDTRY.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  PREFETCH_MARC_MARD_MBEW
*&---------------------------------------------------------------------*
*       Alle in Frage kommenden MARC-, MARD- und MBEW-Sätze vorab lesen
*----------------------------------------------------------------------*
FORM prefetch_marc_mard_mbew TABLES pt_werks STRUCTURE t_werks.

  REFRESH: t_pre01, t_pre03, t_pre17, t_marc, t_mard, t_mbew.
  DATA: lv_hint  TYPE rsdu_hint.

*---- Prefetch für MARC -----------------------------------------------*
*------TGA/Erweiterungen Lot
* IF werk_sel IS INITIAL.          "delete
  READ TABLE t_werks INDEX 1.
  IF sy-subrc NE 0.
*------TGA/Erweiterungen Lot
*---- Über alle vorliegenden Materialien ------------------------------*
*   LOOP AT t_matnr.                   " TGA/4.6 Erw. Lot
*     t_pre03-matnr = t_matnr-matnr.   " TGA/4.6 Erw. Lot
    LOOP AT prt_matnr.                 " TGA/4.6 Erw. Lot
      t_pre03-matnr = prt_matnr-matnr. " TGA/4.6 Erw. Lot
      APPEND t_pre03.
    ENDLOOP.

ENHANCEMENT-SECTION RWBE1F02_01 SPOTS ES_RWBEST01 .
*    Hana Optimization
    SELECT matnr werks umlmc trame glgmg FROM marc INTO CORRESPONDING FIELDS OF TABLE t_marc
*    SELECT * FROM marc INTO TABLE t_marc
                      FOR ALL ENTRIES IN t_pre03
          WHERE matnr = t_pre03-matnr.
END-ENHANCEMENT-SECTION.
  ELSE.
*---- Über alle vorliegenden Material-Werk-Kombinationen --------------*
*    LOOP AT t_matnr.                         " TGA/4.6 Erw. Lot
*     t_pre01-matnr = t_matnr-matnr.         " TGA/4.6 Erw. Lot
    LOOP AT prt_matnr.                 " TGA/4.6 Erw. Lot
      t_pre01-matnr = prt_matnr-matnr. " TGA/4.6 Erw. Lot
      LOOP AT pt_werks.
        t_pre01-werks = pt_werks-werks.
        APPEND t_pre01.
      ENDLOOP.
    ENDLOOP.

ENHANCEMENT-SECTION RWBE1F02_02 SPOTS ES_RWBEST01 .
    TRY.
*        Hana Optimization
        PERFORM hana_hint TABLES t_pre01 USING 'MARC' 2 CHANGING lv_hint.
*   old: SELECT * FROM marc INTO TABLE t_marc
        SELECT matnr werks umlmc trame glgmg FROM marc INTO CORRESPONDING FIELDS OF TABLE t_marc
                              FOR ALL ENTRIES IN t_pre01
                  WHERE matnr = t_pre01-matnr
                    AND werks = t_pre01-werks
               %_HINTS HDB lv_hint.
      CATCH cx_wrt_fae_hint_error.
        SELECT matnr werks umlmc trame glgmg FROM marc INTO CORRESPONDING FIELDS OF TABLE t_marc
                              FOR ALL ENTRIES IN t_pre01
                  WHERE matnr = t_pre01-matnr
                    AND werks = t_pre01-werks.
    ENDTRY.
END-ENHANCEMENT-SECTION.
  ENDIF.

  IF sy-subrc = 0.
*---- Ergebnismenge ist absteigend sortiert -> umsortieren ------------*
    SORT t_marc ASCENDING BY matnr werks.

*---- Prefetch für MARD -----------------------------------------------*
    REFRESH t_pre01. "weil evtl. schon bei MARC-Prefetch benutzt

    LOOP AT t_marc.
      t_pre01-matnr = t_marc-matnr.
      t_pre01-werks = t_marc-werks.
      APPEND t_pre01.
    ENDLOOP.

    TRY.
*       Hana Optimization
        PERFORM hana_hint TABLES t_pre01 USING 'MARD' 2 CHANGING lv_hint.
*   old: SELECT * FROM mard INTO TABLE t_mard
        SELECT matnr werks lgort labst umlme insme einme speme klabs kinsm keinm kspem retme FROM mard INTO CORRESPONDING FIELDS OF TABLE t_mard
                              FOR ALL ENTRIES IN t_pre01
                  WHERE matnr = t_pre01-matnr
                    AND werks = t_pre01-werks
               %_HINTS HDB lv_hint.
      CATCH cx_wrt_fae_hint_error.
        SELECT matnr werks lgort labst umlme insme einme speme klabs kinsm keinm kspem retme FROM mard INTO CORRESPONDING FIELDS OF TABLE t_mard
                              FOR ALL ENTRIES IN t_pre01
                  WHERE matnr = t_pre01-matnr
                    AND werks = t_pre01-werks.
    ENDTRY.
*---- Ergebnismenge ist absteigend sortiert -> umsortieren ------------*
    SORT t_mard ASCENDING BY matnr werks lgort.

*---- Prefetch für MBEW -----------------------------------------------*
*---- Test, ob Bewertungskreis = Werk gilt, ansonsten sind keine ------*
*---- wertmäßigen Bestandswerte möglich                          ------*
    SELECT SINGLE * FROM tcurm.
    IF tcurm-bwkrs_cus NE bwkrs_werk.
      MESSAGE i081.
*    Keine Anzeige der wertmäßigen Bestandsdaten möglich
    ELSE.
      LOOP AT t_marc.
        t_pre17-matnr = t_marc-matnr.
        t_pre17-bwkey = t_marc-werks.
        APPEND t_pre17.
      ENDLOOP.

      TRY.
*          Hana Optimization
          PERFORM hana_hint TABLES t_pre17 USING 'MBEW' 2 CHANGING lv_hint.
*      SELECT * FROM mbew INTO TABLE t_mbew
          SELECT matnr bwkey lbkum salk3 vksal FROM mbew INTO CORRESPONDING FIELDS OF TABLE t_mbew
                               FOR ALL ENTRIES IN t_pre17
                   WHERE matnr = t_pre17-matnr
                     AND bwkey = t_pre17-bwkey
                     AND bwtar = space      "nur Summensätze berücksichtigen!
                 %_HINTS HDB lv_hint.
        CATCH cx_wrt_fae_hint_error.
          SELECT matnr bwkey lbkum salk3 vksal FROM mbew INTO CORRESPONDING FIELDS OF TABLE t_mbew
                               FOR ALL ENTRIES IN t_pre17
                   WHERE matnr = t_pre17-matnr
                     AND bwkey = t_pre17-bwkey
                     AND bwtar = space.      "nur Summensätze berücksichtigen!
      ENDTRY.
*---- Ergebnismenge ist absteigend sortiert -> umsortieren ------------*
      SORT t_mbew ASCENDING BY matnr bwkey bwtar.
    ENDIF.
  ENDIF.


ENHANCEMENT-SECTION RWBE1F02_G1 SPOTS ES_RWBEST01 .
  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
    IF NOT p_scat IS INITIAL.
      TRY .
*       Hana Optimization
        PERFORM hana_hint TABLES t_mard USING 'MCHB' 3 CHANGING lv_hint.
        SELECT matnr werks lgort charg lvorm clabs cumlm cinsm ceinm cspem cretm sgt_scat
                           FROM mchb INTO
                           CORRESPONDING FIELDS OF TABLE t_mchb
                           FOR ALL ENTRIES IN t_mard
                           WHERE matnr = t_mard-matnr
                           AND   werks = t_mard-werks
                           AND   lgort = t_mard-lgort
                           AND   sgt_scat EQ p_scat
                         %_HINTS HDB lv_hint.
        CATCH cx_wrt_fae_hint_error.
        SELECT matnr werks lgort charg lvorm clabs cumlm cinsm ceinm cspem cretm sgt_scat
                           FROM mchb INTO
                           CORRESPONDING FIELDS OF TABLE t_mchb
                           FOR ALL ENTRIES IN t_mard
                           WHERE matnr = t_mard-matnr
                           AND   werks = t_mard-werks
                           AND   lgort = t_mard-lgort
                           AND   sgt_scat EQ p_scat.
      ENDTRY.
      ELSE.
        TRY .
*       Hana Optimization
          PERFORM hana_hint TABLES t_mard USING 'MCHB' 3 CHANGING lv_hint.
          SELECT matnr werks lgort charg lvorm clabs cumlm cinsm ceinm cspem cretm sgt_scat
                             FROM mchb INTO
                             CORRESPONDING FIELDS OF TABLE t_mchb
                             FOR ALL ENTRIES IN t_mard
                             WHERE matnr = t_mard-matnr
                             AND   werks = t_mard-werks
                             AND   lgort = t_mard-lgort
                           %_HINTS HDB lv_hint.
          CATCH cx_wrt_fae_hint_error.
          SELECT matnr werks lgort charg lvorm clabs cumlm cinsm ceinm cspem cretm sgt_scat
                             FROM mchb INTO
                             CORRESPONDING FIELDS OF TABLE t_mchb
                             FOR ALL ENTRIES IN t_mard
                             WHERE matnr = t_mard-matnr
                             AND   werks = t_mard-werks
                             AND   lgort = t_mard-lgort.
        ENDTRY.
      ENDIF.
    SORT t_mchb ASCENDING BY matnr werks lgort charg.

    SELECT matnr sgt_csgr
           sgt_rel
           FROM mara
           INTO CORRESPONDING FIELDS OF TABLE t_mara1
           FOR ALL ENTRIES IN prt_matnr
           WHERE matnr EQ prt_matnr-matnr.
    IF sy-subrc EQ 0.
      SORT t_mara1 BY matnr.
    ENDIF.
  ENDIF.
END-ENHANCEMENT-SECTION.

ENDFORM.                               " PREFETCH_MARC_MARD_MBEW


*&---------------------------------------------------------------------*
*&      Form  EK_VK_BESTAENDE
*&---------------------------------------------------------------------*
*       MBEW-Bestandsdaten lesen und ablegen
*----------------------------------------------------------------------*
FORM ek_vk_bestaende.

*  LOOP AT t_mbew WHERE matnr = t_matnr-matnr.     " TGA/4.6 Erw. Lot
* note 1138065
  DATA: hindex LIKE sy-tabix.
  READ TABLE t_mbew WITH KEY matnr = prt_matnr-matnr
                    BINARY SEARCH.
  IF sy-subrc = 0.
    MOVE sy-tabix TO hindex.
    LOOP AT t_mbew FROM hindex.
      IF t_mbew-matnr NE prt_matnr-matnr.
        EXIT.
      ENDIF.
      PERFORM mbew_bestaende.
    ENDLOOP.
  ENDIF.

ENDFORM.                               " EK_VK_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MBEW_BESTAENDE
*&---------------------------------------------------------------------*
*    1) Merken der EK/VK-Bestände in den interen Tabellen.             *
*    2) Falls das Material eine Variante ist, werden auch die Best.    *
*       für den zugehörenden Sammelartikel fortgeschrieben.            *
*----------------------------------------------------------------------*
FORM mbew_bestaende.

*????Berechtigungen bei VKP-Kalkulation laufen für EK- bzw. VK-Preise
*????über die Objekte W_VKPR_VKO bzw. M_EINF_EKO d.h. über die Ver-
*????triebsschienen- bzw. Einkaufsorg.zugehörigkeit->wie hier vorgehen?
*---- Test, ob der Anwender die Anzeigeberechtigung zu diesem Werk ----*
*---- besitzt. Wenn nicht, werden die Bestandsdaten nicht berücks. ----*
* AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
*                 ID 'ACTVT' FIELD '03'
*                 ID 'WERKS' FIELD T_MARC-WERKS.
* CHECK SY-SUBRC = 0.

*  PERFORM mbew_bestaende_kumulieren USING t_matnr-matnr.  " TGA/4.6 Erw
  PERFORM mbew_bestaende_kumulieren USING prt_matnr-matnr.    " TGA/4.6

*---- Falls der Artikel eine Variante mit zugeordnetem Sammelart.  ----*
*---- ist, müssen auch die Bestandsdaten für den Sammelartikel er- ----*
*---- höht werden                                                  ----*
* IF t_matnr-attyp = attyp_var.                 " TGA/4.6 Erw. Lot
*   READ TABLE t_matnr WITH KEY matnr = t_matnr-satnr   " TGA/4.6 Erw. L
  IF prt_matnr-attyp = attyp_var.      " TGA/4.6 Erw. Lot
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr   " TGA/4.6 Er
               BINARY SEARCH           "Werte der Variante nicht
               TRANSPORTING NO FIELDS. "überschreiben!!
    IF sy-subrc = 0.
*     PERFORM mbew_bestaende_kumulieren USING t_matnr-satnr.  " TGA/4.6
      PERFORM mbew_bestaende_kumulieren USING prt_matnr-satnr.  " TGA/4.6
    ENDIF.
  ENDIF.

ENDFORM.                               " MBEW_BESTAENDE

*&---------------------------------------------------------------------*
*&      Form  MBEW_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Merken der EK/VK-Bestände in den internen Tabellen
*----------------------------------------------------------------------*
*  -->  PI_MATNR  Materialnummer
*----------------------------------------------------------------------*
FORM mbew_bestaende_kumulieren USING pi_matnr LIKE mara-matnr.

*---- Update Werksummen -----------------------------------------------*
  READ TABLE prt_wbe WITH KEY matnr = pi_matnr
                          werks = t_mbew-bwkey  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_mbew-lbkum TO prt_wbe-lbkum.
    MODIFY prt_wbe INDEX sy-tabix.

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*---- Update Buchungskreissummen --------------------------------------*
*   READ TABLE BBE WITH KEY MATNR = PI_MATNR
*                           BUKRS = WBE-BUKRS  BINARY SEARCH.
*   IF SY-SUBRC EQ 0.
*     ADD T_MBEW-LBKUM TO BBE-LBKUM.
*     MODIFY BBE INDEX SY-TABIX.
*#jhl 31.01.96 (Ende)

*---- Update Basiswerksgruppensummen ----------------------------------*
    READ TABLE prt_gbe WITH KEY matnr = pi_matnr
                            bwgrp = prt_wbe-bwgrp  BINARY SEARCH.
    IF sy-subrc EQ 0.
      ADD t_mbew-lbkum TO prt_gbe-lbkum.
      MODIFY prt_gbe INDEX sy-tabix.

*---- Update Mandantensummen ------------------------------------------*
      READ TABLE prt_mbe WITH KEY matnr = pi_matnr  BINARY SEARCH.
      IF sy-subrc EQ 0.
        ADD t_mbew-lbkum TO prt_mbe-lbkum.
        MODIFY prt_mbe INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Wertmäßiger Bestand wird in einer Zusatztabelle nach Währungen --*
*---- und Werken getrennt hinterlegt. Das Kummulieren für höhere     --*
*---- Bestandsebenen erfolgt erst bei der Anzeige im Popupfenster    --*
  READ TABLE prt_ek_vk WITH KEY matnr = pi_matnr
                            werks = t_mbew-bwkey  BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_mbew-salk3 TO prt_ek_vk-ekwer.
    ADD t_mbew-vksal TO prt_ek_vk-vkwer.
    MODIFY prt_ek_vk INDEX sy-tabix.
  ELSE.
    CLEAR prt_ek_vk.
    MOVE t_mbew-matnr  TO prt_ek_vk-matnr.
    MOVE t_mbew-bwkey  TO prt_ek_vk-werks.
    MOVE t_mbew-salk3  TO prt_ek_vk-ekwer.
    MOVE t_mbew-vksal  TO prt_ek_vk-vkwer.
    IF t_mbew-matnr <> pi_matnr.
*---- Falls Sammelartikel behandelt werden, enthält T_MBEW-MATNR die --*
*---- Variante und nicht den Sammelartikel -> EK_VK-MATNR umsetzen   --*
      MOVE pi_matnr TO prt_ek_vk-matnr.
    ENDIF.
    INSERT prt_ek_vk INDEX sy-tabix.
  ENDIF.

ENDFORM.                               " MBEW_BESTAENDE_KUMULIEREN

*&---------------------------------------------------------------------*
*&      Form  NACHBEARBEITUNG_WERKE
*&---------------------------------------------------------------------*
*       Durch das Lesen der MARC-Daten ergibt sich die tatsächliche
*       Liste der zu berücksichtigenden Werke.
*       Für diese Werke wird überprüft, ob der Anwender die notwendige
*       Anzeigebereichtigung besitzt. Falls nicht, werden das Werk und
*       die zugeordneten Bestandsdaten gelöscht. Damit wird ebenfalls
*       sichergestellt, daß Sonderbestände und offene Bestände nur für
*       die authorisierten Werke ermittelt werden, so daß beim Lesen
*       dieser Bestände keine weitere Berechtigungsprüfung erfolgen muß.
*       Für die verbleibenden Werke werden die fehlenden Zusatzdaten
*       nachgelesen.
*----------------------------------------------------------------------*
FORM nachbearbeitung_werke.

*---- H_WERKS enthält die Werke, für die noch Zusatzdaten nachgelesen -*
*---- werden müssen (bei einer Werksselektion über eine Werksgruppe   -*
*---- liegen die Zusatzdaten schon vor).
*---- R_WERKS enthält die Werke, mit denen die Funktionsbausteine   ---*
*---- aufgerufen werden, die die Onlinebestandsdaten zurückliefern. ---*
  REFRESH: h_werks, r_werks.
  CLEAR:   h_werks, r_werks.
  r_werks-option = 'EQ'.
  r_werks-sign   = 'I'.

  LOOP AT t_marc.
    IF werk_sel = wkgrp_belegt.
      PERFORM nachbearbeitung_wkgrp.
    ELSE.
      PERFORM nachbearbeitung_sonstige.
    ENDIF.
  ENDLOOP.

  IF sy-subrc NE 0.
*---- Falls keine Werksbestände vorliegen, sicherstellen, daß keine ---*
*---- sonstigen Bestände ermittelt werden                           ---*
    REFRESH t_werks.
  ENDIF.
  IF werk_sel NE wkgrp_belegt.
*---- Zusatzdazen zu den gefundenen Werken nachlesen ------------------*
    DESCRIBE TABLE h_werks LINES sy-tfill.
    IF sy-tfill > 0.
      PERFORM werk_zusatzdaten TABLES h_werks.
    ENDIF.
  ENDIF.

ENDFORM.                               " NACHBEARBEITUNG_WERKE

*&---------------------------------------------------------------------*
*&      Form  NACHBEARBEITUNG_SONSTIGE
*&---------------------------------------------------------------------*
*       Nachbearbeitung zu den gefundenen Werken für die Fälle, daß
*       eine Werksselektion über eine VKOrg., eine Vertriebslinie oder
*       einzelne Werke erfolgte oder, daß keine Werksselektion erfolgte
*----------------------------------------------------------------------*
FORM nachbearbeitung_sonstige.

*---- Jedes Werk aus T_MARC nur einmal berücksichtigen ----------------*
  READ TABLE h_werks WITH KEY werks = t_marc-werks BINARY SEARCH.
  IF sy-subrc NE 0.
*---- Test, ob der Anwender die Anzeigeberechtigung zu diesem Werk ----*
*---- besitzt. Wenn nicht, werden die Bestandsdaten nicht berücks. ----*
    AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
                    ID 'ACTVT' FIELD '03'
                    ID 'WERKS' FIELD t_marc-werks.
    IF sy-subrc = 0.
      h_werks-werks = t_marc-werks.
      INSERT h_werks INDEX sy-tabix.
      IF NOT p_kzlon IS INITIAL.
*---- Werk-Rangetabelle für die Ermittlung der Online-Bestände   ------*
*---- zusammenstellen (die Tabelle enthält die gleichen Einträge ------*
*---- wie H_WERKS -> Index in SY-TABIX kann auch hier für ein    ------*
*---- sortiertes INSERT verwendet werden, ohne ein READ auf die  ------*
*---- Tabelle R_WERKS machen zu müssen!                          ------*
        r_werks-low = t_marc-werks.
        INSERT r_werks INDEX sy-tabix.
      ENDIF.
    ELSE.
*---- Keine Anzeigeberechtigung für das Werk vorhanden ----------------*
*---- Alle Bestandseinträge zu dem Werk löschen (es können pro Werk  --*
*---- mehrere vorliegen, wenn mit einer Artikelliste gestartet wurde --*
*---- oder wenn Sammelartikel mit den zugeordneten Varianten vorl.)  --*
      DELETE t_marc WHERE werks = t_marc-werks.
      DELETE t_mard WHERE werks = t_marc-werks.
      DELETE t_mbew WHERE bwkey = t_marc-werks.
      MESSAGE s324(mm).                                   "note 3066393
    ENDIF.
  ENDIF.

ENDFORM.                               " NACHBEARBEITUNG_SONSTIGE

*&---------------------------------------------------------------------*
*&      Form  NACHBEARBEITUNG_WKGRP
*&---------------------------------------------------------------------*
*       Nachbearbeitung zu den gefundenen Werken für die Fälle, daß
*       eine Werksselektion über die Werksgruppe erfolgte
*----------------------------------------------------------------------*
FORM nachbearbeitung_wkgrp.

*---- H_WERKS wird nur lokal verwendet, um sicherzustellen, daß -------*
*---- jedes Werk nur einmal bearbeitet wird                     -------*

*---- Jedes Werk aus T_MARC nur einmal berücksichtigen ----------------*
  READ TABLE h_werks WITH KEY werks = t_marc-werks BINARY SEARCH.
  IF sy-subrc NE 0.
*---- Test, ob der Anwender die Anzeigeberechtigung zu diesem Werk ----*
*---- besitzt. Wenn nicht, werden die Bestandsdaten nicht berücks. ----*
    AUTHORITY-CHECK OBJECT 'M_MATE_WRK'
                    ID 'ACTVT' FIELD '03'
                    ID 'WERKS' FIELD t_marc-werks.
    IF sy-subrc = 0.
      h_werks-werks = t_marc-werks.
      INSERT h_werks INDEX sy-tabix.
      IF NOT p_kzlon IS INITIAL.
*---- Werk-Rangetabelle für die Ermittlung der Online-Bestände   ------*
*---- zusammenstellen (die Tabelle enthält die gleichen Einträge ------*
*---- wie H_WERKS -> Index in SY-TABIX kann auch hier für ein    ------*
*---- sortiertes INSERT verwendet werden, ohne ein READ auf die  ------*
*---- Tabelle R_WERKS machen zu müssen!                          ------*
        r_werks-low = t_marc-werks.
        INSERT r_werks INDEX sy-tabix.
      ENDIF.
    ELSE.
*---- Keine Anzeigeberechtigung für das Werk vorhanden ----------------*
*---- Alle Bestandseinträge zu dem Werk löschen (es können pro Werk  --*
*---- mehrere vorliegen, wenn mit einer Artikelliste gestartet wurde --*
*---- oder wenn Sammelartikel mit den zugeordneten Varianten vorl.)  --*
      DELETE t_marc WHERE werks = t_marc-werks.
      DELETE t_mard WHERE werks = t_marc-werks.
      DELETE t_mbew WHERE bwkey = t_marc-werks.
*---- Werk auch aus T_WERKS herausnehmen ------------------------------*
      DELETE t_werks WHERE werks = t_marc-werks.
      MESSAGE s324(mm).                                   "note 3066393
    ENDIF.
  ENDIF.

ENDFORM.                               " NACHBEARBEITUNG_WKGRP

*&---------------------------------------------------------------------*
*&      Form  MERKMALE_NACHLESEN
*&---------------------------------------------------------------------*
*       Lesen aller Merkmale eines Sammelartikels unter Berücksichtigung
*       einer zuvor durchgeführten Merkmalswerteeinschränkung
*----------------------------------------------------------------------*
FORM merkmale_nachlesen.

* Note 216336
  DATA: wg_class LIKE klah-class.
  wg_class = t_matnr-matkl.
  CALL FUNCTION 'C026_SET_UPPER_CLASS_FOR_CP'
    EXPORTING
      upper_class = wg_class
      i_object    = t_matnr-matnr
    EXCEPTIONS
      OTHERS      = 1.

  IF merkm_sel IS INITIAL.
*---- Merkmalsdaten neu lesen (ohne Einschränkung) --------------------*
* JH/02.07.98/4.0C (Anfang)
*   PERFORM LESE_VB_MERKMALE USING T_MATNR-MATNR ' '.
    PERFORM lese_vb_merkmale USING t_matnr-matnr ' ' 'X' t_matnr-matkl.
* JH/02.07.98/4.0C (Ende)
  ELSE.
*---- Gewisse Merkmalsdaten wurden schon aufgrund einer Merkmals- -----*
*---- werteeinschränkung gelesen.                                 -----*
*---- T_SELBEW enthält die Merkmalseinschränkungen -> nicht löschen ---*
    REFRESH: t_merkm, t_merkm_stat, t_bewert.
    CLEAR:   anz_vb_merkm.

*---- Alle direkten und geerbten Merkmale lesen -----------------------*
* JH/02.07.98/4.0C (Anfang)
*   PERFORM LESE_MERKMALE USING T_MATNR-MATNR ' '.
    PERFORM lese_merkmale USING t_matnr-matnr ' ' 'X' t_matnr-matkl.
* JH/02.07.98/4.0C (Ende)
*---- Herausfiltern der variantenbildenden Merkmale -------------------*
    PERFORM var_bildende_merkm USING t_matnr-matnr ' '.
*---- Merkmalsbewertungen zu den variantenbildenden Merkmalen lesen ---*
    PERFORM lese_bewertungen USING ' '.

*---- Die Einschränkungen bzgl. Merkmalswerten wieder übernehmen ------*
    PERFORM check_selbew.

*---- Da Einschränkungen bzgl. Merkmalswerten vorliegt, müssen die ----*
*---- überflüssigen Merkmalswerte herausgelöscht werden            ----*
    LOOP AT t_merkm_stat WHERE selek = 'X'.
      PERFORM delete_merkm_werte USING t_merkm_stat-atinn.
    ENDLOOP.
  ENDIF.

ENDFORM.                               " MERKMALE_NACHLESEN
*&---------------------------------------------------------------------*
*&      Form  werks_only
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM werks_only.

  LOOP AT wbe.                                            "note 2119899
    READ TABLE t_w_lbe INTO s_w_lbe WITH KEY matnr = wbe-matnr
                                             werks = wbe-werks.
    IF sy-subrc = 0.
      s_w_lbe-umlmc  =  wbe-umlmc.
      s_w_lbe-trame  =  wbe-trame.
      s_w_lbe-glgmg  =  wbe-glgmg.
      s_w_lbe-bsabr  =  wbe-bsabr.
      s_w_lbe-trasf  =  wbe-trasf.
      s_w_lbe-wespb  =  wbe-wespb.
      MODIFY t_w_lbe FROM s_w_lbe INDEX sy-tabix
             TRANSPORTING umlmc trame glgmg bsabr trasf wespb.

    ELSE.
      IF wbe-umlmc NE space OR                          "v note 2119899
         wbe-trame NE space OR
         wbe-glgmg NE space OR
         wbe-bsabr NE space OR
         wbe-trasf NE space OR
         wbe-wespb NE space.                            "^ note 2119899
        s_w_lbe-matnr  =  wbe-matnr.
        s_w_lbe-werks  =  wbe-werks.
        s_w_lbe-umlmc  =  wbe-umlmc.
        s_w_lbe-trame  =  wbe-trame.
        s_w_lbe-glgmg  =  wbe-glgmg.
        s_w_lbe-bsabr  =  wbe-bsabr.
        s_w_lbe-trasf  =  wbe-trasf.
        s_w_lbe-wespb  =  wbe-wespb.
        INSERT s_w_lbe INTO t_w_lbe INDEX 1.
      ENDIF.                                              "note 2119899
    ENDIF.
    CLEAR s_w_lbe.
  ENDLOOP.
  IF NOT t_w_lbe IS INITIAL.
    SORT t_w_lbe BY matnr werks.
  ENDIF.

ENDFORM.                    " werks_only
*&---------------------------------------------------------------------*
*&      Form  MCHB_BESTAENDE
*&---------------------------------------------------------------------*
*       fill CBE
*----------------------------------------------------------------------*
FORM mchb_bestaende .

  PERFORM mchb_bestaende_kumulieren USING prt_matnr-matnr.

*IF gv_tree IS INITIAL.                                         " MK
  IF prt_matnr-attyp = attyp_var.
    READ TABLE prt_matnr WITH KEY matnr = prt_matnr-satnr
               BINARY SEARCH
               TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      PERFORM mchb_bestaende_kumulieren USING prt_matnr-satnr.
    ENDIF.
  ENDIF.
*ENDIF.                                                         " MK
ENDFORM.                    " MCHB_BESTAENDE
*&---------------------------------------------------------------------*
*&      Form  MCHB_BESTAENDE_KUMULIEREN
*&---------------------------------------------------------------------*
*       Fill CBE
*----------------------------------------------------------------------*
*       -->PI_MATNR  Article number
*----------------------------------------------------------------------*
FORM mchb_bestaende_kumulieren  USING pi_matnr LIKE mara-matnr.

  cbe_key-matnr = pi_matnr.
  cbe_key-werks = t_mchb-werks.
  cbe_key-lgort = t_mchb-lgort.
  cbe_key-charg = t_mchb-charg.
  READ TABLE prt_cbe WITH KEY cbe_key BINARY SEARCH.
  IF sy-subrc EQ 0.
    ADD t_mchb-clabs  TO cbe-labst.
    ADD t_mchb-cumlm  TO cbe-umlme.
    ADD t_mchb-cinsm  TO cbe-insme.
    ADD t_mchb-ceinm  TO cbe-einme.
    ADD t_mchb-cspem  TO cbe-speme.
    ADD t_mchb-cretm  TO cbe-retme.
    MODIFY cbe INDEX sy-tabix.
  ELSE.
    CLEAR prt_cbe.
    MOVE-CORRESPONDING t_mchb TO prt_cbe.
    IF t_marc-matnr <> pi_matnr.
      MOVE pi_matnr TO prt_cbe-matnr.
      htabix = sy-tabix.
      READ TABLE t_mchb INTO mchb
                        WITH KEY cbe_key
                        BINARY SEARCH.
      IF sy-subrc EQ 0.
        MOVE mchb-lvorm TO prt_cbe-lvorm.
      ELSE.
        CLEAR prt_cbe-lvorm.
      ENDIF.
      sy-tabix = htabix.
    ELSE.
      MOVE prt_matnr-satnr TO prt_cbe-satnr.
    ENDIF.
    MOVE t_mchb-clabs  TO prt_cbe-labst.
    MOVE t_mchb-cumlm  TO prt_cbe-umlme.
    MOVE t_mchb-cinsm  TO prt_cbe-insme.
    MOVE t_mchb-ceinm  TO prt_cbe-einme.
    MOVE t_mchb-cspem  TO prt_cbe-speme.
    MOVE t_mchb-cretm  TO prt_cbe-retme.
    INSERT prt_cbe INDEX sy-tabix.
  ENDIF.

ENHANCEMENT-POINT RWBE1F02_G2 SPOTS ES_RWBEST01 .

ENDFORM.                    " MCHB_BESTAENDE_KUMULIEREN
