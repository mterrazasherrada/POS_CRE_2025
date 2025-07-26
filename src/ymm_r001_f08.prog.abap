*-------------------------------------------------------------------
***INCLUDE RWBE1F08 .
*  Darstellung der Variantenbestände in Matrixform
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  VARIANTEN_MATRIX
*&---------------------------------------------------------------------*
*       Anzeige der Bestandsdaten für alle vorhandenen Varianten zum   *
*       Sammelartikel.                                                 *
*       Die Organisationsebene und die Bestandsart, die in der Matrix  *
*       zur Anzeige kommt, wird abhängig von der Position des Cursors  *
*       innerhalb der Bestandsliste beim Aufruf der Variantenmatrix    *
*       ermittelt.                                                     *
*----------------------------------------------------------------------*
FORM varianten_matrix.

*---- Test, ob gültige Zeilen- und Spaltenposition vorliegt          --*
*---- Die Daten des HIDE-Bereiches wurden in die entsprechenden Var. --*
*---- ZLE-..., ZEILEN_KZ,... zurückgeschrieben                       --*
  IF ( zeilen_kz = man_zeile )
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* OR ( ZEILEN_KZ = BUK_ZEILE )
  OR ( zeilen_kz = wgr_zeile )
  OR ( zeilen_kz = wrk_zeile )
  OR ( zeilen_kz = lag_zeile ).
*---- Zeilenposition ist o.k. -----------------------------------------*
*---- Test, ob betroffenes Material ein Sammelartikel ist -------------*
    CLEAR t_matnr.
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF t_matnr-attyp NE attyp_sam.
      MESSAGE i027.
*    Variantenmatrix kann nur für Sammelartikel aufgerufen werden!
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
      CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
      CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
      EXIT.
    ENDIF.
  ELSE.
    MESSAGE i028.
*    Cursor bitte innerhalb einer Bestandszeile positionieren!
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
    CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
    CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
    EXIT.
  ENDIF.

*---- SY-CUCOL enthält die Spaltenposition+1, in der d. Cursor beim ---*
*---- Aufruf der Variantenmatrix stand                              ---*
  IF sy-cucol BETWEEN 28 AND 44.
*---- Cursor in Spalte1 -----------------------------------------------*
    spalten_pos = 1.
  ELSE.
    IF sy-cucol BETWEEN 46 AND 62.
*---- Cursor in Spalte2 -----------------------------------------------*
      spalten_pos = 2.
    ELSE.
      IF sy-cucol BETWEEN 64 AND 80.
*---- Cursor in Spalte3 -----------------------------------------------*
        spalten_pos = 3.
      ELSE.
        CLEAR spalten_pos.
        MESSAGE i029.
*    Cursor bitte innerhalb einer Bestandsspalte positionieren!
*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
        CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
        CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.
*---- Nach Meldung muß FORM-Routine verlassen werden ------------------*
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

*---- Aufsetzpunkt für einen Rücksprung aus der Bestandsübersicht der -*
*---- Einzelvariante in die Variantenmatrix retten                    -*
  MOVE-CORRESPONDING zle TO hide_alt.
  MOVE zeilen_kz TO hide_alt-zeilen_kz.
  MOVE bezei_kz  TO hide_alt-bezei_kz.
  MOVE sond_kz   TO hide_alt-sond_kz.

*---- Fensternr. der Grundliste des Sammelartikels merken für einen ---*
*---- Rücksprung aus der Bestandsübersicht der Einzelvariante       ---*
* Anmerkung: RMMMB-FENNR muß ebenfalls im HIDE-Bereich abgelegt werden,
* denn falls über die Aufrißfunktion in höhere Liststufen verzweigt
* wurde und dort andere Fensterausschnitte gewählt wurden, steht
* RMMMB-FENNR auf dem Wert für die höchste erreichte Liststufe. Geht
* man nun mit 'F3' zu den tieferliegenden Liststufen zurück, würde der
* Wert von RMMMB-FENNR auf dem letzten Wert stehenbleiben, was zu einer
* fehlerhaften Auswahl der Bestandsart führen würde!
  fennr_alt = rmmmb-fennr.

  PERFORM matrix_anzeigen.

ENDFORM.                               " VARIANTEN_MATRIX

*&---------------------------------------------------------------------*
*&      Form  MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM matrix_anzeigen.

  CLEAR: error_form.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR: MBE, BBE, WBE, LBE.
  CLEAR: mbe, gbe, wbe, lbe.

  PERFORM var_initialisierung.

  IF error_form IS INITIAL.

*---- Bezeichnung zum Sammelart. nachlesen wg. Darstellung in Dynpro --*
    READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.

    drilldown_level = varmatrix_level.

*---- Tabellen für die Anzeige der Varianten löschen ------------------*
    REFRESH: t_varart, t_varme.

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
  ENDIF.

*---- Hilfsfelder zum Auslesen des HIDE-Bereiches vor nächstem Lesen --*
*---- initialisieren                                                 --*
  CLEAR: zle, zeilen_kz, sond_kz, bezei_kz, kz_nsel.
  CLEAR: kz_kein_o, kz_kein_v, kz_kein_w.

ENDFORM.                               " MATRIX_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  VAR_INITIALISIERUNG
*&---------------------------------------------------------------------*
*       Initialisierung für die Matrixbestandsdarstellung.             *
*       Bestimmen des anzuzeigenden Bestandsfeldes inkl. des zuge-     *
*       hörigen Textes                                                 *
*       (analog zu FORM INITIALISIERUNG für Variantenmatrix)           *
*----------------------------------------------------------------------*
FORM var_initialisierung.

  CLEAR: sav_text_var, sav_fname_var.
  CLEAR: grund_anzeige.

  READ TABLE grund_anzeige WITH KEY fennr = rmmmb-fennr
                                    spanr = spalten_pos  BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE i030.
*    Cursor bitte innerhalb einer Spalte mit Bestandswerten posit.!
    error_form = 'X'.
  ELSE.
    MOVE: grund_anzeige-text   TO sav_text_var,
          grund_anzeige-fname  TO sav_fname_var+4.
  ENDIF.

ENDFORM.                               " VAR_INITIALISIERUNG

*&---------------------------------------------------------------------*
*&      Form  MANDT_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten der Varianten eines Sammelartikels in Form einer *
*       Matrix auf Mandantenebene darstellen                           *
*----------------------------------------------------------------------*
FORM mandt_matrix_anzeigen.

  DATA:   x_matnr LIKE t_matnr.  "Damit Inhalt in T_MATNR zum Sammelart.
                                       "nicht überschrieben wird

*---- Kopfdaten für das Matrix- und das Listdynpro zusammenstellen ----*
  PERFORM mandt_kopf_daten.

*---- Unter Umständen die Variantenmengen hinsichtlich einer neuen ME -*
*---- umrechnen                                                       -*
  PERFORM var_umrechnen.

  MOVE: 'MBE-' TO sav_fname_var(4).

  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
    READ TABLE mbe WITH KEY matnr = x_matnr-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      PERFORM var_assign_grundliste.
      PERFORM var_umschluesseln_zeile.
      PERFORM varmenge_ablegen USING x_matnr-matnr
                                     x_matnr-cuobf.
    ELSE.
      MESSAGE a038 WITH 'MBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDLOOP.

  PERFORM bestands_matrix_anzeigen.
*  additions for ALV-tree tga >991009
* in case of alv dont use 'returncode_auswerten'/additions for ALV-tree
  IF p_kzvst0 IS INITIAL.       "additions for ALV-tree
  PERFORM returncode_auswerten.
  ENDIF.                        "additions for ALV-tree
ENDFORM.                               " MANDT_MATRIX_ANZEIGEN

*#jhl 31.01.96 (Anfang) Buchungskreis durch Basiswerksgruppen ersetzt
*&---------------------------------------------------------------------*
*&      Form  BUKRS_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten der Varianten eines Sammelartikels in Form einer *
*       Matrix auf Buchungskreisebene darstellen                       *
*----------------------------------------------------------------------*
*FORM BUKRS_MATRIX_ANZEIGEN.
*
* CLEAR: D_ORGEBT, D_ORGEWT, D_ORGELT, D_BEARTT.
* D_BEARTT = SAV_TEXT_VAR.
* D_ORGEBT = TEXT-027.
*
* IF VARIANTEN_NEU = X.
*   MOVE: 'BBE-' TO SAV_FNAME_VAR(4).
*
*   LOOP AT BBE WHERE BUKRS = ZLE-BUKRS
*                 AND SATNR = ZLE-MATNR.
*     PERFORM VAR_ASSIGN_GRUNDLISTE.
*     PERFORM VAR_UMSCHLUESSELN_ZEILE.
*     PERFORM VARMENGE_ABLEGEN USING BBE-MATNR.
*   ENDLOOP.
* endif.
*
* PERFORM BESTANDS_MATRIX_ANZEIGEN.
* PERFORM RETURNCODE_AUSWERTEN.
*
*ENDFORM.                    " BUKRS_MATRIX_ANZEIGEN
*#jhl 31.01.96 (Ende)

*&---------------------------------------------------------------------*
*&      Form  BWGRP_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten der Varianten eines Sammelartikels in Form einer
*       Matrix auf Basiswerksgruppenebene darstellen
*----------------------------------------------------------------------*
FORM bwgrp_matrix_anzeigen.

  DATA:   x_matnr LIKE t_matnr.  "Damit Inhalt in T_MATNR zum Sammelart.
                                       "nicht überschrieben wird

*---- Kopfdaten für das Matrix- und das Listdynpro zusammenstellen ----*
  PERFORM bwgrp_kopf_daten.

*---- Unter Umständen die Variantenmengen hinsichtlich einer neuen ME -*
*---- umrechnen                                                       -*
  PERFORM var_umrechnen.

  MOVE: 'GBE-' TO sav_fname_var(4).

  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
    READ TABLE gbe WITH KEY matnr = x_matnr-matnr
                              bwgrp = zle-bwgrp     BINARY SEARCH.
    IF sy-subrc NE 0.
*---- Basiswerksgruppenbestand zu dieser Variante muß nicht unbedingt -*
*---- vorhanden sein -> trotzdem die Variante (mit Bestand = 0) aufn. -*
      CLEAR gbe.
    ENDIF.

    PERFORM var_assign_grundliste.
    PERFORM var_umschluesseln_zeile.
    PERFORM varmenge_ablegen USING x_matnr-matnr
                                   x_matnr-cuobf.
  ENDLOOP.
* correction tga161199/no stocks in matrix when dummy bwgrp start
  IF zle-bwgrp = dummy_bwgrp.
    zle-bwgrp = text-036.   " show only description of dummy bwgrp
  ENDIF.
* correction tga161199/no stocks in matrix when dummy bwgrp end.
  PERFORM bestands_matrix_anzeigen.
*  additions for ALV-tree tga >991009
* in case of alv dont use 'returncode_auswerten'/additions for ALV-tree
  IF p_kzvst0 IS INITIAL.       "additions for ALV-tree
  PERFORM returncode_auswerten.
  ENDIF.                        "additions for ALV-tree

ENDFORM.                               " BWGRP_MATRIX_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  WERKS_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten der Varianten eines Sammelartikels in Form einer *
*       Matrix auf Werksebene darstellen                               *
*----------------------------------------------------------------------*
FORM werks_matrix_anzeigen.

  DATA:   x_matnr LIKE t_matnr.  "Damit Inhalt in T_MATNR zum Sammelart.
                                       "nicht überschrieben wird

*---- Kopfdaten für das Matrix- und das Listdynpro zusammenstellen ----*
  PERFORM werks_kopf_daten.

*---- Unter Umständen die Variantenmengen hinsichtlich einer neuen ME -*
*---- umrechnen                                                       -*
  PERFORM var_umrechnen.

*---- Unterscheidung, ob normale Werkzeile oder Sonderbestandszeile ---*
  IF sond_kz IS INITIAL.
    MOVE: 'WBE-' TO sav_fname_var(4).
  ELSE.
    MOVE: 'SUM-' TO sav_fname_var(4).
  ENDIF.

  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
*---- Unterscheidung, ob normale Werkzeile oder Sonderbestandszeile ---*
    CASE sond_kz.
      WHEN space.
        CLEAR wbe.
        READ TABLE wbe WITH KEY matnr = x_matnr-matnr
                                werks = zle-werks     BINARY SEARCH.
      WHEN beistlief.
*---- Kumulieren der Lieferantenbeistellungen auf Werksebene ----------*
        CLEAR sum.
        LOOP AT obs
          WHERE matnr =  x_matnr-matnr
            AND werks =  zle-werks.
          sum-labst = sum-labst + obs-labst.
          sum-insme = sum-insme + obs-insme.
          sum-einme = sum-einme + obs-einme.
        ENDLOOP.
      WHEN konsikunde.
*---- Kumulieren der Kundenkonsi-Bestände auf Werksebene -------------*
        CLEAR sum.
        LOOP AT wbs
          WHERE matnr =  x_matnr-matnr
            AND werks =  zle-werks.
          sum-labst = sum-labst + wbs-labst.
          sum-insme = sum-insme + wbs-insme.
          sum-einme = sum-einme + wbs-einme.
        ENDLOOP.
      WHEN lrgutkunde.
*---- Kumulieren der Kundenleergut-Bestände auf Werksebene ------------*
        CLEAR sum.
        LOOP AT vbs
          WHERE matnr =  x_matnr-matnr
            AND werks =  zle-werks.
          sum-labst = sum-labst + vbs-labst.
          sum-insme = sum-insme + vbs-insme.
          sum-einme = sum-einme + vbs-einme.
        ENDLOOP.
    ENDCASE.

*---- Werks-/Sonderbest. zu dieser Variante muß nicht unbedingt vorh. -*
*---- sein -> trotzdem die Variante (mit Bestand = 0) aufnehmen       -*
    PERFORM var_assign_grundliste.
    PERFORM var_umschluesseln_zeile.
    PERFORM varmenge_ablegen USING x_matnr-matnr
                                   x_matnr-cuobf.
  ENDLOOP.

  PERFORM bestands_matrix_anzeigen.
*  additions for ALV-tree tga >991009
* in case of alv dont use 'returncode_auswerten'/additions for ALV-tree
  IF p_kzvst0 IS INITIAL.       "additions for ALV-tree
  PERFORM returncode_auswerten.
  ENDIF.                        "additions for ALV-tree

ENDFORM.                               " WERKS_MATRIX_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  LGORT_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Bestandsdaten der Varianten eines Sammelartikels in Form einer *
*       Matrix auf Lagerortebene darstellen                            *
*----------------------------------------------------------------------*
FORM lgort_matrix_anzeigen.

  DATA:   x_matnr LIKE t_matnr.  "Damit Inhalt in T_MATNR zum Sammelart.
                                       "nicht überschrieben wird

*---- Kopfdaten für das Matrix- und das Listdynpro zusammenstellen ----*
  PERFORM lgort_kopf_daten.

*---- Unter Umständen die Variantenmengen hinsichtlich einer neuen ME -*
*---- umrechnen                                                       -*
  PERFORM var_umrechnen.

*---- Unterscheidung, ob normale Lagerortzeile oder Sonderbest.zeile --*
  IF sond_kz IS INITIAL.
    MOVE: 'LBE-' TO sav_fname_var(4).
  ELSE.
    MOVE: 'SUM-' TO sav_fname_var(4).
  ENDIF.

  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
    CLEAR lbe.
    READ TABLE lbe WITH KEY matnr = x_matnr-matnr
                            werks = zle-werks
                            lgort = zle-lgort     BINARY SEARCH.

*---- Unterscheidung, ob normale Lagerortzeile oder Sonderbest.zeile --*
    CASE sond_kz.
      WHEN aufbskunde.
        CLEAR sum.
        sum-labst = lbe-kalab.
        sum-insme = lbe-kains.
        sum-speme = lbe-kaspe.
        sum-einme = lbe-kaein.
      WHEN konsilief.
        CLEAR sum.
        sum-labst = lbe-klabs.
        sum-insme = lbe-kinsm.
        sum-einme = lbe-keinm.
        sum-speme = lbe-kspem.
      WHEN mtverpack.
        CLEAR sum.
        sum-labst = lbe-mlabs.
        sum-insme = lbe-minsm.
        sum-einme = lbe-meinm.
        sum-speme = lbe-mspem.
    ENDCASE.

*---- LgOrt-/Sonderbest. zu dieser Variante muß nicht unbedingt vorh. -*
*---- sein -> trotzdem die Variante (mit Bestand = 0) aufnehmen       -*
    PERFORM var_assign_grundliste.
    PERFORM var_umschluesseln_zeile.
    PERFORM varmenge_ablegen USING x_matnr-matnr
                                   x_matnr-cuobf.
  ENDLOOP.

  PERFORM bestands_matrix_anzeigen.
*  additions for ALV-tree tga >991009
* in case of alv dont use 'returncode_auswerten'/additions for ALV-tree
  IF p_kzvst0 IS INITIAL.       "additions for ALV-tree
  PERFORM returncode_auswerten.
  ENDIF.                        "additions for ALV-tree

ENDFORM.                               " LGORT_MATRIX_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  VARMENGE_ABLEGEN
*&---------------------------------------------------------------------*
*       Die ermittelte Bestandsmenge der Variante wird für die Anzeige
*       in der Matrix in einer internen Tabelle hinterlegt
*----------------------------------------------------------------------*
*    -> PI_MATNR  Variantennummer
*       PI_CUOBF  Interne Objektnr. f. Variantenkonfiguration
*----------------------------------------------------------------------*
FORM varmenge_ablegen USING pi_matnr LIKE mara-matnr
                            pi_cuobf LIKE mara-cuobf.

  CLEAR: t_varart, t_varme.

*---- Anzuzeigende Variante mit Bestandswert ablegen ------------------*
  MOVE pi_matnr TO t_varart-matnr.
  MOVE pi_cuobf TO t_varart-cuobj.
  MOVE 'A'      TO t_varart-knsta.     "Knoten nur für Anzeige
  APPEND t_varart.

* Anmerkung: Bestandswert muß durch Faktor '1000' geteilt werden, weil
* die Bestandsdatenfelder vom Typ P mit 7 Vorkomma- und 3 Nachkomma-
* stellen sind. Jedoch ist im Report die Festpunktarithmetik ausge-
* schaltet, so daß intern der Wert um die Anzahl der Nachkommastellen
* zu groß ist -> bei Übergabe an Matrix korrigieren
  t_varme-cuobj = pi_cuobf.
  t_varme-mode  = '1'.
  t_varme-fwert = <d_var> / 1000.
  t_varme-wtsta = 'A'.                 "Wert des Modus nur für Anzeige
  APPEND t_varme.

* Artikelmatrix hinzfügen
    DATA: l_matnr TYPE mara-matnr.
    CLEAR: l_matnr, t_varme.
    t_varme-cuobj = t_varart-cuobj.
    t_varme-mode  = 'A'.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = t_varart-matnr
      IMPORTING
        output = l_matnr.
    t_varme-cwert = l_matnr.
    t_varme-wtsta = 'A'.
    APPEND t_varme.


ENDFORM.                               " VARMENGE_ABLEGEN

*&---------------------------------------------------------------------*
*&      Form  BESTANDS_MATRIX_ANZEIGEN
*&---------------------------------------------------------------------*
*       Aufruf des Funktionsbausteins zur Darstellung der Varianten-
*       bestandsdaten in Matrixform
*----------------------------------------------------------------------*
FORM bestands_matrix_anzeigen.

  DATA: t_char      LIKE mtrx_char OCCURS 0 WITH HEADER LINE,
        t_val       LIKE mtrx_vali OCCURS 0 WITH HEADER LINE,
        lwa_pre_cbe TYPE sgt_pre_cbe,
        lwa_pre_lbe TYPE sgt_pre_lbe,
        lwa_pre_wbe TYPE sgt_pre_wbe,
        lt_pre_cbe  TYPE sgt_t_pre_cbe,
        lt_pre_lbe  TYPE sgt_t_pre_lbe,
        lt_pre_wbe  TYPE sgt_t_pre_wbe,
        sgt_matnr   TYPE sgt_t_matnr,
        sgt_ind     TYPE sgt_ind,
        sgt_mara    TYPE mara_tt.


*---- Merkmalsdaten in entsprechenden Strukturen bereitstellen --------*
  LOOP AT t_merkm.
    MOVE-CORRESPONDING t_merkm TO t_char.
    APPEND t_char.
  ENDLOOP.
*  LOOP AT t_bewert.
*    MOVE-CORRESPONDING t_bewert TO t_val.
*    APPEND t_val.
*  ENDLOOP.
* Note 568408 matrix compression
CALL FUNCTION 'SATNR_VARI_CHARACTERISTICS'
  EXPORTING
    i_matnr                    = t_matnr-matnr
    matrix_call                = 'X'
  TABLES
    mtrx_vali                  = t_val
  EXCEPTIONS
   wrong_call                 = 1
   mara_not_exist             = 2
   classification_error       = 3
   OTHERS                     = 4
          .
IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

* Reduce compressed values from restrictions
IF NOT merkm_sel IS INITIAL.
LOOP AT t_merkm_stat WHERE selek = 'X'.
 LOOP AT t_val WHERE atinn = t_merkm_stat-atinn.
  IF NOT t_val-atwrt IS INITIAL.
   READ TABLE t_bewert WITH KEY atinn = t_val-atinn
                                atwrt = t_val-atwrt.
  ELSE." check numeric values
   READ TABLE t_bewert WITH KEY atinn = t_val-atinn
                                atflv = t_val-atflv.
  ENDIF.
  IF sy-subrc <> 0.
    DELETE t_val.
  ENDIF.
 ENDLOOP.
ENDLOOP.
ENDIF.

*---- Anzeigemodi festlegen -------------------------------------------*
  PERFORM anzeige_modus.

  IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on
  AND gv_tree IS INITIAL.
ENHANCEMENT-SECTION RWBE1F08_G1 SPOTS ES_RWBEST01 .
* Unicode error
  LOOP AT cbe.
    MOVE-CORRESPONDING cbe TO lwa_pre_cbe.
    APPEND lwa_pre_cbe TO lt_pre_cbe.
    CLEAR lwa_pre_cbe.
  ENDLOOP.

  LOOP AT lbe.
    MOVE-CORRESPONDING lbe TO lwa_pre_lbe.
    APPEND lwa_pre_lbe TO lt_pre_lbe.
    CLEAR lwa_pre_lbe.
  ENDLOOP.

  LOOP AT wbe.
    MOVE-CORRESPONDING wbe TO lwa_pre_wbe.
    APPEND lwa_pre_wbe TO lt_pre_wbe.
    CLEAR lwa_pre_wbe.
  ENDLOOP.
  sgt_matnr[] = t_matnr[].
  sgt_mara[]  = t_mara1[].

  IF p_chrg EQ 'X'.
   IF p_kzcha IS NOT INITIAL .
    sgt_ind-kzcha = 'X'.
    sgt_ind-kzchrg = 'X'.
   ELSEIF p_kzseg IS NOT INITIAL.
    sgt_ind-kzseg = 'X'.
    sgt_ind-kzchrg = 'X'.
   ENDIF.
  ELSEIF p_kzlgo IS NOT INITIAL.
    sgt_ind-kzlgo = 'X'.
  ENDIF.

  CALL FUNCTION 'SGT_SET_MATRIX_DATA'
    EXPORTING
      cbe           = lt_pre_cbe
      lbe           = lt_pre_lbe
      wbe           = lt_pre_wbe
      t_matnr       = sgt_matnr
      sgt_ind       = sgt_ind
      t_mara        = sgt_mara
          .
END-ENHANCEMENT-SECTION.
  ENDIF.

  CALL FUNCTION 'WMMA_MATRIX_SHELL_BE'
       EXPORTING
            object              = t_matnr-matnr "Sammelartikel
            class_type          = wghier_klart  "Klassenart
            include_header      = incl_bild     "Subscreen f. Kopfber.
                                       "(nur für Matrixscreen)
            start_mode          = '1'  "mit 1. Modus starten
            titel               = text-059      "Titel im Matrixscreen
            nodelist_titel      = text-059      "Titel im Listscreen
* JH/06.05.98/4.0C Schnittstellenparameter wurde geändert (Anfang)
*           BUTTON              = TEXT-070      "Text bei Zusatzbutton
            button_01           = text-070      "Text bei Zusatzbutton
                                       "(nur für Listscreen)
* JH/06.05.98/4.0C Schnittstellenparameter wurde geändert (Ende)
            xy_change_posi      = 'X'  "Merkmale drehbar
            check_exit          = 'X'  "Exitcheck durchführen
       IMPORTING
            return_functioncode = ret_comm
       TABLES
            var_art             = t_varart      "Varianten
            var_wsel            = t_varme       "Anzuzeigende Mengen
            vb_char             = t_char        "Merkmale
            vb_val              = t_val"Merkmalswerte
            modes               = t_modes       "Anzeigemodi
            list_header         = t_listh       "Header f. Listmodus
       EXCEPTIONS
            mode_error          = 1
            inputdata_error     = 2
            OTHERS              = 3.
  CASE sy-subrc.
    WHEN 1.
      MESSAGE a048.
*    Unerlaubter Aufrufmodus bei der Matrixdarstellung!
    WHEN 2.
      MESSAGE a049.
*    Unvollständige Eingabeparameter beim Aufruf der Matrixdarstellung!
    WHEN 3.
*     MESSAGE A050.        "delete tga/250399/4.6A
      CLEAR:  ret_comm.                "insert tga/250399/4.6A
      MESSAGE i091.                    "tga /250399/4.6A A050 -> I091
*    Interner Fehler beim Aufruf der Matrixdarstellung!
  ENDCASE.

ENDFORM.                               " BESTANDS_MATRIX_ANZEIGEN

*&---------------------------------------------------------------------*
*&      Form  RETURNCODE_AUSWERTEN
*&---------------------------------------------------------------------*
*       Returncode-Auswertung:
*       Falls der Code '#GGV' zurückgeliefert wird, muß die letzte
*       Position des Cursors in der Matrix ermittelt werden. Diese
*       verweist auf die Variante, die in der Grundliste zur Einzel-
*       variante zur Anzeige kommen soll
*----------------------------------------------------------------------*
FORM returncode_auswerten.

  IF ( ret_comm = gogv )               "Button im Kopf des Matrixdynpros
* JH/02.07.98/4.0C (Anfang)
* Umstellung in der Matrixanzeige nachziehen
* OR ( RET_COMM = '#SON' ). "Button in Drucktastenleiste der Listanzeige
  OR ( ret_comm = '#SN1' ). "Button in Drucktastenleiste der Listanzeige
* JH/02.07.98/4.0C (Ende)
*---- Markierte Variante ermitteln ------------------------------------*
    READ TABLE t_varart WITH KEY knsta = '#'.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_VARART'.
*   Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle &
    ENDIF.

*---- In die Grundliste zur Einzelvariante springen -------------------*
    sel_variante = t_varart-matnr.
    drilldown_level = einzvar_level.
*#jhl 12.04.96 vorliegende Fensternr. soll erhalten bleiben
*   RMMMB-FENNR = START_FENNR.
    PERFORM e00_grund_liste.
  ELSE.
    IF ret_comm = 'ENDE'.              " bei 'F15'
*---- Programm beenden ------------------------------------------------*
      PERFORM rwbe_beenden.
    ELSE.                              " bei 'F3', 'F8' oder 'F12'
*---- In die Grundliste zum Sammelartikel zurückspringen --------------*
*---- ZLE-MATNR zeigt auf den Sammelartikel -> T_MATNR für Sammel- ----*
*---- artikel neu lesen                                            ----*
      READ TABLE t_matnr WITH KEY matnr = zle-matnr BINARY SEARCH.
      IF sy-subrc NE 0.
        MESSAGE a038 WITH 'T_MATNR'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
      ENDIF.
      drilldown_level = einzart_level.
      rmmmb-fennr = fennr_alt.
      PERFORM e00_grund_liste.
    ENDIF.
  ENDIF.

ENDFORM.                               " RETURNCODE_AUSWERTEN

*&---------------------------------------------------------------------*
*&      Form  VAR_UMRECHNEN
*&---------------------------------------------------------------------*
*       Falls der Sammelartikel eine neue Mengeneinheit aufweist, müssen
*       die Mengen aller zugordneten Varianten umgerechnet werden,
*       insofern alle Varianten diese alternative ME besitzen.
*       Falls nicht alle Varianten diese alternative ME besitzen, wird
*       eine Meldung ausgegeben, daß für den Sammelartikel eine andere
*       ME zu wählen ist, bevor in die Matrix verzweigt werden kann.
*----------------------------------------------------------------------*
FORM var_umrechnen.

  DATA  me_check_ok(1).          "Übereinstimmende ME's bei allen Var.
  DATA  tabix_alt LIKE sy-tabix.       "Index retten für MODIFY
  DATA  x_matnr LIKE t_matnr.    "Damit Inhalt in T_MATNR zum Sammelart.
                                       "nicht überschrieben wird

*---- Test, ob die alternative ME des Sammelartikels für alle Var. ----*
*---- definiert ist                                                ----*
  me_check_ok = x.
  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
    READ TABLE t_meeinh WITH KEY matnr = x_matnr-matnr
                                 meinh = t_matnr-meins
                        BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR me_check_ok.
      EXIT.                            "LOOP beim ersten Verstoß beenden
    ENDIF.
  ENDLOOP.

  IF me_check_ok IS INITIAL.
*---- Umgesetzte Anzeigestufe wieder zurücksetzen ---------------------*
    drilldown_level = einzart_level.
    MESSAGE e054.
*    Bitte andere Mengeneinheit für das Sammelmaterial wählen
  ENDIF.

*---- Die Mengen aller Varianten umrechnen, deren Anzeigemengeneinh. --*
*---- von der des Sammelartikels abweicht                            --*
  LOOP AT t_matnr INTO x_matnr WHERE satnr = zle-matnr.
    IF x_matnr-meins <> t_matnr-meins.
      meins_neu = t_matnr-meins.
      tabix_alt = sy-tabix.

*---- Es wurde eine Mengeneinheit selektiert -> Umrechnen der Mengen- -*
*---- felder in den internen Bestandstabellen                         -*
      PERFORM umrechnen USING x_matnr.

*---- Neue Anzeigemengeneinheit und alten Umrechnungsfaktor ablegen ---*
      x_matnr-meins     = meins_neu.
      x_matnr-umrez_alt = umrez_neu.
      x_matnr-umren_alt = umren_neu.
      MODIFY t_matnr INDEX tabix_alt FROM x_matnr.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " VAR_UMRECHNEN

*&---------------------------------------------------------------------*
*&      Form  ANZEIGE_MODUS
*&---------------------------------------------------------------------*
*       Anzeigemodi für Matrixdarstellung festlegen
*----------------------------------------------------------------------*
FORM anzeige_modus.

  REFRESH t_modes.
*---- Modus1: Anzeige der Bestandsmengen auf dem Matrixdynpro ---------*
  CLEAR t_modes.
  t_modes-mode      = '1'.             " Beliebige Kennung für Modus
  t_modes-modtyp    = 'N'.             " num. Modus (Menge, Länge, ...)
  t_modes-mdsta     = 'A'.             " kompletter Modus nur Anzeige
  t_modes-kztxt     = text-071.        " Titel für Modus im Listenumfeld
  t_modes-title     = text-060.        " Titel für Modus im Dynproumfeld
  t_modes-template  = schablone.      " Anzeigeschablone f. Mengenfelder
  t_modes-sum_posi  = 'X'.             " Summenzeile/-spalte anzeigen
  t_modes-tmpl_posi = ' '.            " Verändern d. Schablone in Matrix
                                       " nicht erlauben
*JH/20.08.98/4.5B/Hinweis114315 (Anfang)
  t_modes-ri_bound  = 'X'.             " Werte rechtsbündig
                                       " (Nicht gesetztes Kennzeichen
                                       " hat nur Auswirkungen, wenn
                                       " Schablone verkleinert wird)
  t_modes-tmpl_posi = 'X'.             " Schablone änderbar
  t_modes-clwt_posi = 'X'.             " Spaltenbreite änderbar
*JH/20.08.98/4.5B/Hinweis114315 (Ende)
  t_modes-meins     = t_matnr-meins.   " Anzeigemengeneinheit
  APPEND t_modes.
*---- Modus2: Anzeige der Bestandsmengen in Listenform ----------------*
  CLEAR t_modes.
  t_modes-mode      = '2'.             " Beliebige Kennung für Modus
  t_modes-modtyp    = 'L'.             " Listmodus
  t_modes-mdsta     = 'A'.             " kompletter Modus nur Anzeige
  t_modes-kztxt     = text-073.        " Titel für Modus im Listenumfeld
  t_modes-title     = text-072.        " Titel für Modus im Dynproumfeld
  t_modes-tmpl_posi = ' '.            " Verändern d. Schablone in Matrix
                                       " nicht erlauben
  t_modes-meins     = t_matnr-meins.   " Anzeigemengeneinheit
* JH/02.07.98/4.0C (Anfang)
* Umstellung in der Matrixanzeige nachziehen
  t_modes-sn1_act   = 'X'.             " Button1 aktiv
* JH/02.07.98/4.0C (Ende)
  APPEND t_modes.

* Variantennummern in 2. Screeen
  READ TABLE t_modes WITH KEY mode = 'A' TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    CLEAR t_modes.
    t_modes-mode       = 'A'.
    t_modes-modtyp     = 'C'.
    t_modes-mdsta      = 'A'.
    t_modes-kztxt      = 'Varianten zum Sammelartikel'(069).
    t_modes-title      = 'Varianten zum Sammelartikel'(069).
    t_modes-template   = '__________________'.
    APPEND t_modes.
  ENDIF.


ENDFORM.                               " ANZEIGE_MODUS

*&---------------------------------------------------------------------*
*&      Form  MANDT_KOPF_DATEN
*&---------------------------------------------------------------------*
*       Kopfdaten für das Matrixdynpro und das Listdynpro zusammen-
*       stellen
*----------------------------------------------------------------------*
FORM mandt_kopf_daten.

*---- Kopfdaten für Matrixdynpro --------------------------------------*
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR: D_ORGEBT, D_ORGEWT, D_ORGELT, D_BEARTT, D_SOBET.
  CLEAR: d_orgegt, d_orgewt, d_orgelt, d_beartt, d_sobet.
  CLEAR: t_bwgrp-bwgbz, t001w-name1, t001l-lgobe.
  d_beartt = sav_text_var.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* D_ORGEBT = TEXT-014.
  d_orgegt = text-014.

*---- Kopfdaten für Listdynpro ----------------------------------------*
  REFRESH t_listh.
*---- 1. Zeile
  CLEAR t_listh.
  t_listh-line    = text-013.
  t_listh-line+21 = zle-matnr.
ENHANCEMENT-SECTION     MANDT_KOPF_DATEN_01 SPOTS ES_RWBEST01.
  t_listh-line+40 = t_matnr-maktx.
END-ENHANCEMENT-SECTION.
  APPEND t_listh.
*---- 2. Zeile
  CLEAR t_listh.
  t_listh-line    = text-016.
  t_listh-line+21 = t_matnr-meins.
  APPEND t_listh.
*---- 3. Zeile
  CLEAR t_listh.
  t_listh-line    = text-031.
  t_listh-line+21 = sav_text_var.
  APPEND t_listh.
*---- 4. Zeile
  CLEAR t_listh.
  t_listh-line    = text-074.
  APPEND t_listh.
*---- 5. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-014.
  APPEND t_listh.

ENDFORM.                               " MANDT_KOPF_DATEN

*&---------------------------------------------------------------------*
*&      Form  BWGRP_KOPF_DATEN
*&---------------------------------------------------------------------*
*       Kopfdaten für das Matrixdynpro und das Listdynpro zusammen-
*       stellen
*----------------------------------------------------------------------*
FORM bwgrp_kopf_daten.

*---- Kopfdaten für Matrixdynpro --------------------------------------*
  CLEAR: d_orgegt, d_orgewt, d_orgelt, d_beartt, d_sobet.
  CLEAR: t_bwgrp-bwgbz, t001w-name1, t001l-lgobe.
  d_beartt = sav_text_var.
  d_orgegt = text-027.

  IF zle-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
    zle-bwgrp = text-036.
  ELSE.
*---- Bezeichn. zur Basiswerksgruppe lesen (Anzeige in Matrixdynpro) --*
    READ TABLE t_bwgrp WITH KEY bwgrp = zle-bwgrp BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_BWGRP'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDIF.

*---- Kopfdaten für Listdynpro ----------------------------------------*
  REFRESH t_listh.
*---- 1. Zeile
  CLEAR t_listh.
  t_listh-line    = text-013.
  t_listh-line+21 = zle-matnr.
ENHANCEMENT-SECTION     MANDT_KOPF_DATEN_02 SPOTS ES_RWBEST01.
  t_listh-line+40 = t_matnr-maktx.
END-ENHANCEMENT-SECTION.
  APPEND t_listh.
*---- 2. Zeile
  CLEAR t_listh.
  t_listh-line    = text-016.
  t_listh-line+21 = t_matnr-meins.
  APPEND t_listh.
*---- 3. Zeile
  CLEAR t_listh.
  t_listh-line    = text-031.
  t_listh-line+21 = sav_text_var.
  APPEND t_listh.
*---- 4. Zeile
  CLEAR t_listh.
  t_listh-line    = text-074.
  APPEND t_listh.
*---- 5. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-027.
  t_listh-line+21 = zle-bwgrp.
  t_listh-line+40 = t_bwgrp-bwgbz.
  APPEND t_listh.
* correction tga161199/no stocks in matrix when dummy bwgrp
IF zle-bwgrp = text-036.
  zle-bwgrp = dummy_bwgrp.
ENDIF.
ENDFORM.                               " BWGRP_KOPF_DATEN

*&---------------------------------------------------------------------*
*&      Form  WERKS_KOPF_DATEN
*&---------------------------------------------------------------------*
*       Kopfdaten für das Matrixdynpro und das Listdynpro zusammen-
*       stellen
*----------------------------------------------------------------------*
FORM werks_kopf_daten.

*---- Kopfdaten für Matrixdynpro --------------------------------------*
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR: D_ORGEBT, D_ORGEWT, D_ORGELT, D_BEARTT, D_SOBET.
  CLEAR: d_orgegt, d_orgewt, d_orgelt, d_beartt, d_sobet.
  CLEAR: t_bwgrp-bwgbz, t001w-name1, t001l-lgobe.
  d_beartt = sav_text_var.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* D_ORGEBT = TEXT-027.
  d_orgegt = text-027.
  d_orgewt = text-028.

  IF zle-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
    zle-bwgrp = text-036.
  ELSE.
*---- Bezeichn. zur Basiswerksgruppe lesen (Anzeige in Matrixdynpro) --*
    READ TABLE t_bwgrp WITH KEY bwgrp = zle-bwgrp BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_BWGRP'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDIF.

*---- Bezeichnung zum Werk lesen (Anzeige in Matrixdynpro) ------------*
  READ TABLE wbe WITH KEY matnr = zle-matnr
                          werks = zle-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ELSE.                      "übergeben, damit durch nachfolg. LOOP über
    t001w-name1 = wbe-name1. "WBE nicht evtl. SPACE in WBE-NAME1 steht
  ENDIF.

*---- Sonderbestandsart -----------------------------------------------*
  CASE sond_kz.
    WHEN beistlief.
      d_sobet = text-044.
    WHEN konsikunde.
      d_sobet = text-045.
    WHEN lrgutkunde.
      d_sobet = text-046.
  ENDCASE.

*---- Kopfdaten für Listdynpro ----------------------------------------*
  REFRESH t_listh.
*---- 1. Zeile
  CLEAR t_listh.
  t_listh-line    = text-013.
  t_listh-line+21 = zle-matnr.
ENHANCEMENT-SECTION     MANDT_KOPF_DATEN_03 SPOTS ES_RWBEST01.
  t_listh-line+40 = t_matnr-maktx.
END-ENHANCEMENT-SECTION.
  APPEND t_listh.
*---- 2. Zeile
  CLEAR t_listh.
  t_listh-line    = text-016.
  t_listh-line+21 = t_matnr-meins.
  APPEND t_listh.
*---- 3. Zeile
  CLEAR t_listh.
  t_listh-line    = text-031.
  t_listh-line+21 = sav_text_var.
  t_listh-line+40 = d_sobet.
  APPEND t_listh.
*---- 4. Zeile
  CLEAR t_listh.
  t_listh-line    = text-074.
  APPEND t_listh.
*---- 5. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-027.
  t_listh-line+21 = zle-bwgrp.
  t_listh-line+40 = t_bwgrp-bwgbz.
  APPEND t_listh.
*---- 6. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-028.
  t_listh-line+21 = zle-werks.
  t_listh-line+40 = t001w-name1.
  APPEND t_listh.

ENDFORM.                               " WERKS_KOPF_DATEN

*&---------------------------------------------------------------------*
*&      Form  LGORT_KOPF_DATEN
*&---------------------------------------------------------------------*
*       Kopfdaten für das Matrixdynpro und das Listdynpro zusammen-
*       stellen
*----------------------------------------------------------------------*
FORM lgort_kopf_daten.

*---- Kopfdaten für Matrixdynpro --------------------------------------*
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* CLEAR: D_ORGEBT, D_ORGEWT, D_ORGELT, D_BEARTT, D_SOBET.
  CLEAR: d_orgegt, d_orgewt, d_orgelt, d_beartt, d_sobet.
  CLEAR: t_bwgrp-bwgbz, t001w-name1, t001l-lgobe.
  d_beartt = sav_text_var.
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
* D_ORGEBT = TEXT-027.
  d_orgegt = text-027.
  d_orgewt = text-028.
  d_orgelt = text-029.

  IF zle-bwgrp = dummy_bwgrp.
*---- Bei der Basiswerksgruppe für die Werke ohne Gruppenzuordnung ----*
*---- immer nur die Bezeichnung ausgeben                           ----*
    zle-bwgrp = text-036.
  ELSE.
*---- Bezeichn. zur Basiswerksgruppe lesen (Anzeige in Matrixdynpro) --*
    READ TABLE t_bwgrp WITH KEY bwgrp = zle-bwgrp BINARY SEARCH.
    IF sy-subrc NE 0.
      MESSAGE a038 WITH 'T_BWGRP'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
    ENDIF.
  ENDIF.

*---- Bezeichnung zum Werk lesen (Anzeige in Matrixdynpro) ------------*
  READ TABLE wbe WITH KEY matnr = zle-matnr
                          werks = zle-werks BINARY SEARCH.
  IF sy-subrc NE 0.
    MESSAGE a038 WITH 'WBE'.
*    Schwerer Fehler: kein Treffer beim Zugriff auf die interne Tabelle
  ELSE.
    t001w-name1 = wbe-name1.
  ENDIF.

*---- Bezeichnung zum Lagerort lesen (Anzeige in Matrixdynpro) --------*
  t001l-lgobe = '?'.   " damit bei erfolglosem Lesen kein Zufallswert
                                       " angezeigt wird
  SELECT SINGLE * FROM t001l
                WHERE werks = zle-werks
                AND   lgort = zle-lgort.

*---- Sonderbestandsart -----------------------------------------------*
  CASE sond_kz.
    WHEN aufbskunde.
      d_sobet = text-048.
    WHEN konsilief.
      d_sobet = text-047.
    WHEN mtverpack.
      d_sobet = text-049.
  ENDCASE.

*---- Kopfdaten für Listdynpro ----------------------------------------*
  REFRESH t_listh.
*---- 1. Zeile
  CLEAR t_listh.
  t_listh-line    = text-013.
  t_listh-line+21 = zle-matnr.
ENHANCEMENT-SECTION     MANDT_KOPF_DATEN_04 SPOTS ES_RWBEST01.
  t_listh-line+40 = t_matnr-maktx.
END-ENHANCEMENT-SECTION.
  APPEND t_listh.
*---- 2. Zeile
  CLEAR t_listh.
  t_listh-line    = text-016.
  t_listh-line+21 = t_matnr-meins.
  APPEND t_listh.
*---- 3. Zeile
  CLEAR t_listh.
  t_listh-line    = text-031.
  t_listh-line+21 = sav_text_var.
  t_listh-line+40 = d_sobet.
  APPEND t_listh.
*---- 4. Zeile
  CLEAR t_listh.
  t_listh-line    = text-074.
  APPEND t_listh.
*---- 5. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-027.
  t_listh-line+21 = zle-bwgrp.
  t_listh-line+40 = t_bwgrp-bwgbz.
  APPEND t_listh.
*---- 6. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-028.
  t_listh-line+21 = zle-werks.
  t_listh-line+40 = t001w-name1.
  APPEND t_listh.
*---- 7. Zeile
  CLEAR t_listh.
  t_listh-line+1  = text-029.
  t_listh-line+21 = zle-lgort.
  t_listh-line+40 = t001l-lgobe.
  APPEND t_listh.

ENDFORM.                               " LGORT_KOPF_DATEN
