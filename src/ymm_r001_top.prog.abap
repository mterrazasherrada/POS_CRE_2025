*&---------------------------------------------------------------------*
*& Include RWBE1TOP                         Report RWBEST01            *
*& Datendeklarationen                                                  *
*&---------------------------------------------------------------------*

REPORT rwbest01 MESSAGE-ID mr NO STANDARD PAGE HEADING LINE-SIZE 80.
ENHANCEMENT-POINT RWBE1TOP_G4 SPOTS ES_RWBEST01 STATIC.
ENHANCEMENT-POINT RWBE1TOP_G5 SPOTS ES_RWBEST01.
ENHANCEMENT-POINT RWBE1TOP_G6 SPOTS ES_RWBEST01 STATIC.
ENHANCEMENT-POINT RWBE1TOP_G7 SPOTS ES_RWBEST01.

INCLUDE <icon>.                        " Ikonenliste

*----------------------------------------------------------------------*
*  Datenfelder
*----------------------------------------------------------------------*

DATA:
*---- Retten der eingegebenen Selektionswerte f. Lesen v. Bezeichn. ---*
      wkgrp_alt LIKE klah-class,       " Werksgruppe der letzten Eingabe
      vkorg_alt LIKE tvko-vkorg,       " VKOrg der letzten Eingabe
      vtweg_alt LIKE tvtw-vtweg,       " Vertr.weg der letzten Eingabe
      matkl_alt LIKE klah-class,       " Warengruppe der letzten Eingabe
      satnr_alt LIKE mara-satnr,      " Sammelartikel d. letzten Eingabe
      lifnr_alt LIKE lfa1-lifnr,       " Lieferant der letzten Eingabe
      ltsnr_alt LIKE wyt1-ltsnr,       " LTS der letzten Eingabe
      plgtp_alt LIKE mara-plgtp,      " Preislagentyp d. letzten Eingabe
      saiso_alt LIKE mara-saiso,       " Saison der letzten Eingabe
      vernu_alt LIKE t136-vernu,       " Anz.version d. letzten Eingabe
*#jhl 25.01.96 Materialart als Information entfällt
*     MTART_ALT LIKE MARA-MTART,      " Materialart d. letzten SELECT
*     MTBEZ_ALT LIKE T134T-MTBEZ,     " Mat.artbezeichn. d. l. SELECT
*---- Kontrolle der korrekten Eingabefelderbelegung -------------------*
      check_counter TYPE i,            " Zähler für Eingabekontrolle
      mat_sel(2),                      " Belegtes Feld f. Materialebene
      werk_sel(2),                     " Belegtes Feld f. Werksebene
      merkm_sel(1),                    " Merkm.werteselekt. liegt vor
      anz_vb_merkm LIKE sy-tabix,      " Anzahl variantenbild. Merkm.
*---- Behandlung von Werksgruppierungen -------------------------------*
      wkgrp_klart  LIKE klah-klart,    " Klassenart für Werksgruppen
      wkgrp_clint  LIKE klah-clint,    " Interne Klassennr. f. Werksgr.
      wkgrp_bez    LIKE swor-kschl,    " Bezeichnung für Werksgruppe
      werks_object LIKE kssk-objek,    " Werk einer Werksgruppe
      dummy_bwgrp  LIKE rwbwg-bwgrp    " Basiswerksgruppe für Werke ohne
        VALUE 'ZZZZZZZZZZZZZZZZZZ',    " Gruppenzuordnung -> 'Z...Z'
                                       " damit der Eintrag als letzter
                                       " der Liste erscheint!
      dummy_bwgbz  LIKE rwbwg-bwgbz,   " BasisWrkGrpText für Werke ohne
                                       " Gruppenzuord. (text-035)
*---- Daten für das Dynpro im Kopfbereich der Merkmalswerteselektion --*
      satnr_bez   LIKE swor-kschl,     "Bezeichnung des Sammelartikels
      d_fdtxt(17) TYPE c,              "Führender Feldtext (WG/SA)
      d_fdbez     LIKE swor-kschl,     "Bezeichnung zum Feldwert (WG/SA)
*---- Daten für das Dynpro im Kopfbereich der Variantenmatrix ---------*
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*     D_ORGEBT(18) TYPE C,            "Text 'Buchungskreis'
      d_orgegt(18) TYPE c,             "Text 'Basiswerksgruppe'
      d_orgewt(18) TYPE c,             "Text 'Werk'
      d_orgelt(18) TYPE c,             "Text 'Lagerort'
      d_beartt(18) TYPE c,             "Bezeichn. der Bestandsart
      d_sobet(20)  TYPE c,             "Bezeichn. für Sonderbestand
*---- Daten zur Steuerung der Anzeige der Bestandsdaten ---------------*
      komma(1) TYPE c,                 " Zeichen für die Darstellung des
                                       " Dezimalkommas
      punkt(1) TYPE c,                 " Zeichen für die Darstellung des
                                       " 1000er-Punktes
      schablone(15) TYPE c            " Anzeigeschablone f. Matrixmengen
          VALUE '___*___*___*___',     " wobei '*' entsprechend durch
                                       " '.' bzw. ',' ersetzt werden muß
      drilldown_level(1),              " aktuelle Drilldown-Stufe
                                       " (Anzeige Modus)
      start_dd_level(1),               " Drilldown-Stufe beim Start
      anzeige_art_l(2),                " Anzeigeart für den Artikel bei
                                       " der Grundliste zu einer Liste
                                       " von Artikeln
      anzeige_art_e(2),                " Anzeigeart für die Basiswerks-
                                      " gruppe in der Grund- und Aufriß-
                                      " liste zum Einzelartikel oder der
                                       " Einzelvariante
      text_xxx(80),                    " Titeltext bei Aufrißliste
                                       " (Einzelart. u. Einzelvar.)
      popup_answer(1),                 " Ergebnis der Popup-Abfrage
      mess_text(35),                   " Text in Bestätigungs-Popup
      anz_mat_char(5),                 " Konvertierung ANZ_SEL_MAT
      anz_sel_mat      LIKE sy-tabix,  " Anzahl selektierter Mat.
      anz_mat_ges      LIKE sy-tabix,  " Anzahl aller Materialien
                                       " (selekt. plus nachselekt.)
      korr_anz_sel_mat LIKE sy-tabix, " Korrekturwert f. Anz. d. selekt.
                                       " Materialien
      progr_indic      LIKE sy-tabix,  " Faktor für Progress-Indicator
      prozent          LIKE sy-tabix,  " Prozentsatz f. Progr.-Indicator
      bas_proz         LIKE sy-tabix,  " Basisprozentsatz f. Progr.-Ind.
      sel_variante LIKE mara-matnr,    " in der Matrix ausgewählte Var.
                                       " für Var.einzelbestandsübersicht
      spalten_pos  LIKE t136-spanr,   " Spaltenposition in Bestandsliste
                                       " des Einzelartikels, für die die
                                       " Variantenmatrix aufgerufen wird
      fennr_alt    LIKE t136-fennr,    " Fensternr. in Bestandsliste des
                                       " Sammelart. (für Rücksprung)
      start_fennr  LIKE t136-fennr     " Start-Fenster der Grundlisten
        VALUE '01',
      ende_fennr   LIKE t136-fennr,    " letztes Fenster d. Grundliste
      save_fennr   LIKE t136-fennr,    " Zwischenspeicher b. Verschieben
                                       " der Liste
      sum_meinh LIKE mara-meins,       " Angezeigte ME in d. Summenzeile
                                       " zur Artikelliste (f. Test)
      keine_sum_meinh(1),             " KZ, ob Mengenein. in Summenzeile
                                       " z. Art.liste angezeigbar ist
*TGA/4.6 Erweiterungen Lot (START)
      com_labst TYPE f,               " gesamtmenge Strukt-Artikel +
                                       "frei verf. aus Sammelartikel
      str_labst TYPE f,               " gesamtmenge Strukt-Artikel
*TGA/4.6 Erweiterungen Lot (END)
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*     SAV-BUKRS    LIKE T001-BUKRS,   "NEW-PAGE bei neuem Buchungskreis
*#jhl 01.02.96 NEW-PAGE b. Wechsel d. Basiswrk.grp. unterdrücken
*     SAV-BWGRP    LIKE RWBWG-BWGRP,  "NEW-PAGE bei neuer Basiswerksgrp
      sav_text1    LIKE t157b-ftext,   "Spalte1: Text f. Bestandsart1
      sav_text2    LIKE t157b-ftext,   "Spalte2: Text f. Bestandsart2
      sav_text3    LIKE t157b-ftext,   "Spalte3: Text f. Bestandsart3
      mefeld       LIKE t157b-ftext,   "Text f. bewerteter Bestand
      ekfeld       LIKE t157b-ftext,   "Text f. EK-Bestandswert
      vkfeld       LIKE t157b-ftext,   "Text f. VK-Bestandswert
      sav_text_var LIKE t157b-ftext,   "Text d. Bestandsart für die
                                       "Variantenmatrix
      sav_fname0(34) TYPE c,           "Hilfsfeld Anzeige-Feldname
                                       "Für Nullzeilen-Check und Best.-
                                       "anzeige in der Einzelliste
      sav_fname1    LIKE sav_fname0,   "Hilfsfeld Anzeige-Feldname 1
                                       "Spalte1: Menge Bestandsart1
      sav_fname2    LIKE sav_fname0,   "Hilfsfeld Anzeige-Feldname 2
                                       "Spalte2: Menge Bestandsart2
      sav_fname3    LIKE sav_fname0,   "Hilfsfeld Anzeige-Feldname 3
                                       "Spalte3: Menge Bestandsart3
      sav_fname_var LIKE sav_fname0,   "Anzeige-Feldname für die
                                       "Variantenmatrix
      intab_name LIKE sav_fname0,      "Feldname einer interenen Tab.
      dbtab_name LIKE sav_fname0,      "Feldname einer Datenbank-Tab.
      kzexi_f0        TYPE c,          "Kennzeichen, ob <F0> exist.
                                       "' ' = ex., 'X' = ex. nicht!
      kzexi_f1        TYPE c,          "Kennzeichen, ob <F1> exist.
      kzexi_f2        TYPE c,          "Kennzeichen, ob <F2> exist.
      kzexi_f3        TYPE c,          "Kennzeichen, ob <F3> exist.
      kzexi_f_var     TYPE c,          "Kennzeichen, ob <F_VAR> ex.
      ez_bestand LIKE mard-labst,     "Bestandsfeld auf Einzelliste (für
                                      "Umschlüsselung) -> dynam. Verwend
      vz1,                             "Vorzeichen zu <D1>
      vz2,                             "Vorzeichen zu <D2>
      vz3,                             "Vorzeichen zu <D3>
      max_stock_value_reached(1) TYPE c,  "KZ für Bestandswertüberlauf
                                       "                //KPr 1142916
      max_stock_value TYPE f           "Max. Wert, der noch angezeigt
        VALUE '9.9999999999995E12',    "werden kann     //KPr 1142916
      meins_alt   LIKE mara-meins,     "ME fürs Zurückrechnen
                                       "                //KPr 1142916
      kz_list         TYPE c,          "Listenart
      laenge     LIKE sy-index,        "Hilfsfeld
      izaehl     LIKE sy-index,        "Hilfsfeld
      izaehl17   LIKE sy-index VALUE 17,
      izaehl_eman LIKE sy-index VALUE 5, "Restzeilen Einzelfenster EMAN
      kz_sond_exist   TYPE c,         "Kz. LgOrt-Sonderbestand existiert
      kz_werksond     TYPE c,          "Kz. S.Bestände zum Werk vorh.
      kz_nur_werksond TYPE c,          "Kz. nur S.Bestände zum Werk
      kz_kein_o       TYPE c,          "Kz. keine L.Beist anzeigen
      kz_kein_w       TYPE c,          "Kz. keine K.Konsi anzeigen
      kz_kein_v       TYPE c,          "Kz. kein K.Leergut anzeigen
      kz_w047         TYPE c,          "Kz W047 wurde bereits prozes.
      kz_nsel         LIKE sy-tabix,   "Zeilennr. d. Seitenkopfes (HIDE)
      kz_werk         TYPE c,          "Kz. WBE-Eintrag zur BWGRP ex.
      hwerks         LIKE marc-werks,  "Hilfsfeld Werk
      hlgort         LIKE mard-lgort,  "Hilfsfeld Lagerort
      hcharg         LIKE mchb-charg,  "Hilfsfeld Charge
      hbwart         LIKE mseg-bwart,  "Hilfsfeld Bewegungsart
      hlifnr         LIKE mseg-lifnr,  "Hilfsfeld Lieferant
* JH/02.07.98/4.0C (Anfang)
      hmatkl         LIKE klah-class,  "Hilfsfeld Warengruppenklasse
* JH/02.07.98/4.0C (Ende)
      matnr_lisel LIKE mara-matnr,     "MatNr aus selektierter Zeile
      matnr_neu   LIKE mara-matnr,     "sel. MatNr nach Konvertierung
      meins_neu   LIKE mara-meins,     "sel. ME nach Konvertierung
      umrez_alt   LIKE sy-tabix,       "UMREZ zur bisherigen ME
      umren_alt   LIKE sy-tabix,       "UMREN zur bisherigen ME
      umrez_neu   LIKE sy-tabix,       "UMREZ zur neuen ME
      umren_neu   LIKE sy-tabix,       "UMREN zur neuen ME
      kz_prozessiert,                  "Kz Dynpro wurde prozessiert
      nullcheck  TYPE p,               "Feld fuer Nullpruefung
*TGA/4.6 Erweiterungen Lot (START)
      strart_exist TYPE c VALUE 'N',   "structured article exist
      nbwrk_done TYPE c VALUE 'N',     "Nachbearb.Werke gelaufen?
*----TGA/4.6 Erweiterungen Lot (END)
*---- Daten für den HIDE-Bereich --------------------------------------*
      zeilen_kz(1),                    " Zeilenkennzeichen
      bezei_kz(1),                     " Zeile enthält nur Bezeichn.
                                       " z.B. für Lagerplatzbezeichn.
      sond_kz        LIKE t148-sobkz,  " Sonderbestandskennzeichen
*---- Retten alter SPA/GPA-Parameterwerte -----------------------------*
      matnr_spa_gpa LIKE mara-matnr,   " Materialnummer
      matkl_spa_gpa LIKE klah-class,   " Warengruppe
      werks_spa_gpa LIKE marc-werks,   " Werk
      lifnr_spa_gpa LIKE lfa1-lifnr,   " Lieferant
      ltsnr_spa_gpa LIKE wyt1t-ltsnr,  " Lief.teilsortiment
      vkorg_spa_gpa LIKE tvkwz-vkorg,  " Verkaufsorganisation
      vtweg_spa_gpa LIKE tvkwz-vtweg,  " Vertriebsweg
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
      ekorg_spa_gpa LIKE lfm1-ekorg,   "Einkaufsorganisation
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)
*---- Sonstiges -------------------------------------------------------*
      ret_code    LIKE sy-subrc,       " Return-Fehlercode
      ret_comm    LIKE sy-ucomm,       " Return-Usercommand
      htabix      LIKE sy-tabix,       " Hilfsfeld f. Lief.-/Kunden-
                                       " Insert in int. Tabelle
      error_form(1),                   " Abbruch nach Fehler in unter-
                                       " geordneter FORM-Routine
      dummy(10)     TYPE c VALUE 'DUMMY_FELD',
      dummy_feld(17),                  " dynam. Verwendung
      spaceline(80) TYPE c,
      space5(5)     TYPE c,
      space14(14)   TYPE c,
      space16(16)   TYPE c,
      space17(17)   TYPE c,
      space23(23)   TYPE c,
      space38(38)   TYPE c,
      space42(42)   TYPE c,
      space44(44)   TYPE c,
      space55(60)   TYPE c,
      text3(3)      TYPE c,
      text30(30)    TYPE c.
DATA  run_time  TYPE i.                "????Laufzeittest
DATA  run_time1 TYPE i.                "????Laufzeittest
DATA  run_time2 TYPE i.                "????Laufzeittest
DATA  run_timed TYPE i.                "????Laufzeittest

DATA  gv_message_counter TYPE i VALUE 0."MR025/MR104      "note 2687150

*RST Test class inventory_lookup-B
DATA g_iltest TYPE c.
*RST Test class inventory_lookup-E

*----------------------------------------------------------------------*
*  Konstanten                                                          *
*----------------------------------------------------------------------*

CONSTANTS:

*---- Abfrage --------------------------------------------------------*
      yes               VALUE 'Y',
      no                VALUE 'N',

*---- Defaults --------------------------------------------------------*
      def_vernu LIKE t136-vernu        " Vorschlagsanzeigeversion
                VALUE '01',
*---- Feldauswahlwerte zu MAT_SEL -------------------------------------*
      matnr_belegt(2) VALUE 'MN', " Eingabefeld 'Material' ist belegt
      matkl_belegt(2) VALUE 'MK', " Eingabefeld 'Warengruppe' belegt
*---- Feldauswahlwerte zu WERK_SEL ------------------------------------*
      wkgrp_belegt(2) VALUE 'WG', " Eingabefeld 'Werksgruppe' belegt
      vkorg_belegt(2) VALUE 'VO', " Eingabefeld 'VKorg' ohne 'Vertr.weg'
                                       " belegt
      vtrli_belegt(2) VALUE 'VL', " Eingabefelder 'VKorg' u. 'Vertr.weg'
                                       " (= Vertr.linie) belegt
      werks_belegt(2) VALUE 'WK',      " Eingabefeld 'Werk' belegt
*---- Maximalwerte für noch sinnvoll darstellbare Listumfänge ---------*
      max_anz_mat TYPE i VALUE 50, " Max. Anz. darstellbarer Materialien
*---- Applikationsklasse für Werksgruppen in der Bestandsübersicht ----*
      appl_klasse LIKE twrf16-bgapp VALUE '04', "geä. Kabuth 5.9.96
*---- Interne Klassenart für die Abbildung von Warengruppenhier. ------*
      wghier_klart LIKE klah-klart VALUE '026',
*---- Tabelle über die Werke klassifiziert werden ---------------------*
      werks_obtab  LIKE tclt-obtab VALUE 'BETR',
*---- Relevante Artikeltypen ------------------------------------------*
      attyp_sam    LIKE mara-attyp VALUE '01',   " Sammelartikel
      attyp_var    LIKE mara-attyp VALUE '02',   " Variante
      attyp_wgwa   LIKE mara-attyp VALUE '20',   " Warengrp.-Wertartikel
      attyp_wghw   LIKE mara-attyp VALUE '21',   " Warengrp.-Hier.werta.
      attyp_wert   LIKE mara-attyp VALUE '22',   " Wertartikel
      attyp_wgva   LIKE mara-attyp VALUE '30',   " Warengrp.-Vorlageart.
*???? ATTYP_EINZ   LIKE MARA-ATTYP VALUE '00',   " Einzelartikel
*???? attyp_einz   like mara-attyp value '10',   " VK-Set
*???? attyp_einz   like mara-attyp value '11',   " Lot
*???? attyp_einz   like mara-attyp value '12',   " Display
*---- Relevante Betriebstypen -----------------------------------------*
      vlfkz_filiale LIKE t001w-vlfkz VALUE 'A',  " Filiale
      vlfkz_vz_zl   LIKE t001w-vlfkz VALUE 'B',  " Verteilzentr./Zentr.-
                                       " lager
*---- Bewertungskreisebene --------------------------------------------*
      bwkrs_werk LIKE tcurm-bwkrs_cus VALUE '1', " Bewertungskreis=Werk
*---- Feldauswahlwerte zu DRILLDOWN_LEVEL -----------------------------*
      artlist_level   VALUE '1', "Stufe1: Liste von Artikeln anzeigen
      einzart_level   VALUE '2', "Stufe2: Einzelnen Artikel anzeigen
                                 "(norm. Art., Sammelart. oder Variante
                                 "ohne intern vorhandenen Sammelart.)
      varmatrix_level VALUE '3', "Stufe3: Varianten in Matrix anzeigen
      einzvar_level   VALUE '4', "Stufe4: Einzelne Variante anzeigen
                                       "nach Darstellung in Stufe3
*---- Feldauswahlwerte zu ANZEIGE_ART_L/ANZEIGE_ART_E -----------------*
      anz_art_bez(2)  VALUE 'BE',      " Bezeichnung anzeigen
      anz_art_nr(2)   VALUE 'NR',      " Nummer anzeigen
      anz_art_bun(2)  VALUE 'BN',      " Bezeichn. und Nr. anzeigen
*---- Definitionen Bestandszeilenarten/Listarten ----------------------*
*---- Feldauswahlwerte zu KZ_LIST/ZEILEN_KZ      ----------------------*
      ueb_zeile         TYPE c VALUE 'U',
      grund_liste       TYPE c VALUE 'G',
      einzel_liste      TYPE c VALUE 'E',
      ek_vk_liste       TYPE c VALUE 'W',
*TGA/4.6 Erweiterungen Lot (START)
      strart_liste       TYPE c VALUE 'S',   "structured article exist
*TGA/4.6 Erweiterungen Lot (END)
      ges_zeile         TYPE c VALUE '0',
      man_zeile         TYPE c VALUE '1',
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*     BUK_ZEILE         TYPE C VALUE '2',
      wgr_zeile         TYPE c VALUE '2',
      wrk_zeile         TYPE c VALUE '3',
      lag_zeile         TYPE c VALUE '4',
      ch_zeile          TYPE c VALUE '5',
*     CHA_ZEILE         TYPE C VALUE '5', "????nicht notwendig
*     ME_LISTE          TYPE C VALUE '9', "????    -"-
      space_zeile       TYPE c VALUE 'S',   "vorl. wg. F1-Hilfe????
*---- Sonderbestandsarten ---------------------------------------------*
      aufbskunde        TYPE c VALUE 'E',  "Kundenauftragsbestand
      konsilief         TYPE c VALUE 'K',  "Lieferantenkonsignation
      beistlief         TYPE c VALUE 'O',  "Beistellung vom Lieferanten
      lrgutkunde        TYPE c VALUE 'V',  "Leergut beim Kunden
      konsikunde        TYPE c VALUE 'W',  "Kundenkonsignation
      prjbestand        TYPE c VALUE 'Q',  "Projektbestand
      mtverpack         TYPE c VALUE 'M',  "Mehrwegtransportverpackung
*<<< hier später weitere Sonderbestandsarten ergänzen
*---- Funktions-Codes -------------------------------------------------*
*     Zurück (F3) in der Grundliste f. Einzelartikel u. Art.liste
      back_g         LIKE sy-ucomm VALUE 'BABA',
*     Zurück (F3) in der Grundliste f. Einzelvarianten
      back_gv        LIKE sy-ucomm VALUE 'BAGV',
*     Zurück (F3) in der Aufrißliste f. Einzelartikel u. Einzelvarianten
   "  BACK           -> v. Listprozessor behandelt
*     Abbrechen (F12) in der Grundliste f. Einzelartikel u. Art.liste
      abbr_g         LIKE sy-ucomm VALUE 'ABBR',
*     Abbrechen (F12) in der Grundliste f. Einzelvarianten
      abbr_gv        LIKE sy-ucomm VALUE 'ABGV',
*     Abbrechen (F12) in der Aufrißliste f. Einzelart. u. Einzelvar.
   "  RW             -> v. Listprozessor behandelt
*     Beenden (F15) in Grund- und Aufrißlisten und in der Matrix
*     Ersetzt %EX das vom Listprozessor abgehandelt würde
      beenden        LIKE sy-ucomm VALUE 'ENDE',
*     Aufrißliste für die Varianten eines Sammelartikels
      vaar           LIKE sy-ucomm VALUE 'VAAR',
*     Grundliste aus Aufrißliste aufrufen f. Einzelart. u. Einzelvar.
      grund          LIKE sy-ucomm VALUE 'GRUN',
*     Variantenmatrix aus Grund-/Aufrißliste f. Einzelart. aufrufen
      matx           LIKE sy-ucomm VALUE 'MATX',
*     Zurück z. Variantenmatrix aus Grund-/Aufrißliste f. Einzelvar.
      bama           LIKE sy-ucomm VALUE 'BAMA',
*     Von Variantenmatrix zur Grundliste der Einzelvariante
      gogv           LIKE sy-ucomm VALUE '#GGV',
*     Anzeige der Bezeichnung für Artikel/Basiswerksgruppen
      anbe           LIKE sy-ucomm VALUE 'ANBE',
*     Anzeige der Nummer für Artikel/Basiswerksgruppen
      annr           LIKE sy-ucomm VALUE 'ANNR',
*     Anzeige der Nummer und Bezeichnung für Artikel/Basiswerksgruppen
      anbn           LIKE sy-ucomm VALUE 'ANBN',
*     Neue Selektion für Einzelartikel oder Einzelvariante
      neue_selektion LIKE sy-ucomm VALUE 'NSEL',
* JH/27.10.98/4.6A (Anfang)
*     Aufrischen für Artikel in der Anzeigestufe EINZART_LEVEL
      refresh        LIKE sy-ucomm VALUE 'REFR',
* JH/27.10.98/4.6A (Ende)
*     Selektion eines neuen Materials (mit Matchcodeunterstützung)
      zlma           LIKE sy-ucomm VALUE 'ZLMA',    "Zul. Materialien
*     Selektion einer neuen Variante
      zlva           LIKE sy-ucomm VALUE 'ZLVA',    "Zul. Varianten
*     Anzeige der EK/VK-Bestandswerte
      ekvk           LIKE sy-ucomm VALUE 'EKVK',
*     Anzeige des Lieferantenkonsi-Preissegmentes
      ason           LIKE sy-ucomm VALUE 'ASON',
*     Vertriebsbedarfe
      md04           LIKE sy-ucomm VALUE 'MD04',
*     Bestellungen
      me2m           LIKE sy-ucomm VALUE 'ME2M',
*     Reservierungen
      mb24           LIKE sy-ucomm VALUE 'MB24',
*     Materialbewegungen
      mb51           LIKE sy-ucomm VALUE 'MB51',
*     Alte Bestandsübersicht (Anzeige Buchungskreis und Charge)
      mmbe           LIKE sy-ucomm VALUE 'MMBE',
*     Material anzeigen
      mm43           LIKE sy-ucomm VALUE 'MM43',
*     LVS-Quants
      ls26           LIKE sy-ucomm VALUE 'LS26',
*     Fertigungsaufträge
      co21           LIKE sy-ucomm VALUE 'CO21',
*     Zulässige Mengeneinheiten
      zul_me         LIKE sy-ucomm VALUE 'ZLME',
*     Equipments anzeigen
      equi           LIKE sy-ucomm VALUE 'EQUI',
*TGA/4.6 Erweiterungen Lot (START)
*     show information concerning structured articles
      stru           LIKE sy-ucomm VALUE 'STRU',
*TGA/4.6 Erweiterungen Lot (END)
*---- Definitionen PF-STATUS ------------------------------------------*
      pfstatus_grund_l   LIKE sy-pfkey VALUE 'GRUNDL',   "Grundliste für
                                       "Artikelliste
      pfstatus_grund_e   LIKE sy-pfkey VALUE 'GRUNDE',   "Grundliste für
                                       "Einzelartikel
      pfstatus_grund_v   LIKE sy-pfkey VALUE 'GRUNDV',   "Grundliste für
                                       "Einzelvariante
      pfstatus_naechst_l LIKE sy-pfkey VALUE 'NAECHSTL', "Aufrißliste f.
                                       "Artikelliste
      pfstatus_naechst_e LIKE sy-pfkey VALUE 'NAECHSTE', "Aufrißliste f.
                                       "Einzelartikel
      pfstatus_naechst_v LIKE sy-pfkey VALUE 'NAECHSTV', "Aufrißliste f.
                                       "Einzelvariante
      pfstatus_eman      LIKE sy-pfkey VALUE 'EMAN',     "Einzelliste
      pfstatus_eson      LIKE sy-pfkey VALUE 'ESON',     "Einzelliste f.
                                       "Lief.konsi
*???? PFSTATUS_ECHA    LIKE SY-PFKEY VALUE 'ECHA',    "Einzelliste Charg
*???? PFSTATUS_MD04    LIKE SY-PFKEY VALUE 'MD04',    "Bedarfsliste
*???? PFSTATUS_ME2M    LIKE SY-PFKEY VALUE 'ME2M',    "Bestellungen
*???? PFSTATUS_MB24    LIKE SY-PFKEY VALUE 'MB24',    "Reservierungen
*???? PFSTATUS_MB51    LIKE SY-PFKEY VALUE 'MB51',    "Mat.Bewegungen
*???? PFSTATUS_MM03    LIKE SY-PFKEY VALUE 'MM03',    "Material anzeigen
*???? PFSTATUS_MSC3    LIKE SY-PFKEY VALUE 'MSC3'.    "Charge anzeigen
*---- Definition Bedarfsarten -----------------------------------------*
      arbed LIKE resb-bdart  VALUE 'AR',  " abhängige Reservierungen
      mtres LIKE resb-bdart  VALUE 'MR',  " manuelle Reservierungen
*---- Sichten der integr. Artikelpflege für Materialanzeige -----------*
*     '02' Grunddaten/Klassifizierung
*     '1'  Listung
*     '5'  Logistik VZ/ZL
*     '6'  Logistik Filiale
*     '7'  POS-Daten
      mm43_sicht_init LIKE rmmw3-aktvsta_rt VALUE '021567',
      mm43_sicht_fil  LIKE rmmw3-aktvsta_rt VALUE '02167', "bei VZ
      mm43_sicht_vz   LIKE rmmw3-aktvsta_rt VALUE '02157', "bei Filiale
*---- Sonstiges -------------------------------------------------------*
      x LIKE sy-marky          VALUE 'X',
      minus        TYPE c VALUE '-',
      strich_zeile TYPE c VALUE 'T',
      strich(17)   TYPE c VALUE '-----------------',
      strich25(25) TYPE c VALUE '-------------------------',
      strich36(36) TYPE c VALUE '------------------------------------',
      strich38(38) TYPE c VALUE
       '--------------------------------------',
      strich42(42) TYPE c VALUE
       '------------------------------------------',
      strich60(60) TYPE c VALUE
       '------------------------------------------------------------',
      strich44(44) TYPE c VALUE
       '--------------------------------------------',
      strich62(62) TYPE c VALUE
       '--------------------------------------------------------------',
*     LEER(17)     TYPE C VALUE '                 ', nicht verwendet!!!
      vnr(3)       TYPE c VALUE 'VNR', "Param-Id für VorschlVers
*tga additions for alv tree
      vst0(4)      TYPE c VALUE 'VST0'. "Param-Id für VorschlVers

*----------------------------------------------------------------------*
*  Feld-Symbole
*----------------------------------------------------------------------*
FIELD-SYMBOLS:
*---- Verweis auf Mengenfelder der internen Bestandstabellen ----------*
               <f0>, <f1>, <f2>, <f3>, <f_var>,
*---- Verweis auf Mengenfelder der Datenbankbestandsfelder ------------*
               <d0>, <d1>, <d2>, <d3>, <d_var>.

*----------------------------------------------------------------------*
*  Rangetabellen
*----------------------------------------------------------------------*

RANGES:
        r_saiso FOR mara-saiso,        " Saison für Material-Select
        r_saisj FOR mara-saisj,        " Saisonjahr für Material-Select
        r_plgtp FOR mara-plgtp,       " Preislagentyp f. Material-Select
        r_attyp FOR mara-attyp,        " Nicht operative Materialien
        r_werks FOR marc-werks,       " Werke für Online-Bestandsermitt.
        r_bdart FOR resb-bdart,       " Für die Reservierungen relevante
                                       " Bedarfsarten
        r_fname FOR t136-fname.        " Felder, die nicht angezeigt
" werden sollen
" //JH zu 1.2A1 (s. intPr 197005)

*----------------------------------------------------------------------*
*  Transparente Tabellen
*----------------------------------------------------------------------*

TABLES: mara,    " Materialdaten auf Mandantenebene
        marc,                          " Materialdaten auf Werksebene
        mard,                          " Materialdaten auf Lagerortebene
        mbew,                          " Materialbewertungsdaten
        makt,                          " Materialkurztexte
*#jhl 25.01.96 Materialart als Information entfällt
*       T134T,   " Texte zur Materialart
        mska,                          " Kundenauftragsbestand
        mkol,                          " Lieferantenkonsignationbestand
                 " Lieferanten-Mehrwegtransportverpackungsbestand
* JH/21.01.97/1.2B KPr1018362 -> Tabelle MSPR aufgenommen
* Notwendig wegen F1-Hilfe in Listen, damit DDIC-Bezug bekannt ist
        mspr,                          " Projektbestand
        msku,                          " Kundenleihgutbestand
                                       " Kundenkonsignationbestand
        mslb,                          " Lieferantenbeistellungsbestand
*       MSCA,    " Kundenauftragsbestand beim Lieferanten????notwendig
*<<<    hier später weitere Bestandstabellen ergänzen
        t001,                          " Buchungskreise
        t001k,                         " Bewertungkreise
        t001w,                         " Werke
        t001l,                         " Lagerorte
        t023,                          " Basiswarengruppen
*#jhl 16.07.96 Fehler beim Lesen der Zuordnungen -> TVKWZ enthält die
* Vertriebslinien, über die ein Werk ausliefern kann!
*       TVKWZ,   " Zuordnung Vertriebslinie-Werk
        knvv,    " Vertriebslinien über die Werk beliefert werden kann
        tvko,                          " Verkaufsorganisation
        tvkot,                         " VKOrg-Bezeichnung
        tvkov,   " Vertriebswege einer Verkaufsorganisation (inkl.
                 " Mapping bei Referenzvertriebsweg)
        tvtwt,                         " Vertriebswegbezeichnung
*       T023T,   " Warengruppenbezeichnung????
        tcurm,   " Customizing Konfiguration MM (Bewertungskreisebene)
        kna1,                          " Kundendaten auf Mandantenebene
        lfa1,    " Lieferantendaten auf Mandantenebene
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Anfang)
        lfm1,    " Lieferantendaten auf EkOrg-Ebene
* JH/4.0A/30.10.97 Int. Meld. 3484704 (Ende)
        wyt1,                          " Lieferantenteilsortiment
        wyt1t,   " Bezeichnung f. Lieferantenteilsortiment
        eina,                          " Einkaufsinfosatz
        klah,                          " Klassenkopf Daten
        swor,    " Warengruppenbezeichnung (über Klassifizierung)
        twptt,                         " Preislagenbezeichnung
        t6wst,                         " Saisonbezeichnung
        t006a,                         " Texte zu Mengeneinheiten
        t320,    " Lagernummer zu Lagerort eines Werkes
        t340d,                         "JH/13.05.98/4.0C
        t136,    " Listenlayout für die Grund- und Aufrißliste
        t136t,                         " Anzeigeversionsbezeichnung
        t136e,   " Mögl. Bestandsfelder f. d. Anzeige in d. Einzelliste
        t136v,   " Bestandsfelder pro OrgEbene für die Einzellistenanz.
        t157b,                         " Text zu den Bestandsfeldern
        t148k,                         " Sonderbestände Sicht MM_BD
        rmmmb,   " Ein-/Ausgabefelder für Bestandsübersicht
        rmmw1,   " Materialstammpflege - Einstiegsparameter Retail
        ekbe,                          " WE-Sperrbestand
        incl_bild, " Subscreen, der in Matrix als Kopf dargestellt wird
        mchb.
*???? werden nicht benötigt!
*       EKPO,                             "Bestellposition
*       RESB,                             "Reservierungsposition
*       VBBE,                             "Bestände des Vertriebs
*       T148,                             "Sonderbestände

*----------------------------------------------------------------------*
*  Interne Tabellen
*----------------------------------------------------------------------*

*---- Liste der Basiswarengruppen innerhalb d. Werksgruppenhierarchie -*
DATA: BEGIN OF t_bwgrp OCCURS 0.
        INCLUDE STRUCTURE rwbwg.
DATA: END   OF t_bwgrp.

*---- Liste der Basiswarengruppen zu einem Werk -----------------------*
DATA: BEGIN OF h_bwgrp OCCURS 0.
        INCLUDE STRUCTURE api_kssk.
DATA: END   OF h_bwgrp.

*---- Liste der selektierten Werke ------------------------------------*
DATA: BEGIN OF t_werks OCCURS 0.
        INCLUDE STRUCTURE rwwkh.
DATA: END   OF t_werks.

*---- Liste der Werke für die Zusatzdaten gelesen werden müssen -------*
DATA: BEGIN OF h_werks OCCURS 0,
        werks LIKE marc-werks,
      END   OF h_werks.

*---- Werksstammdaten -------------------------------------------------*
DATA: BEGIN OF t_t001w OCCURS 0.
        INCLUDE STRUCTURE t001w.
DATA: END   OF t_t001w.

*---- Liste der Bewertungskreise zu den Werken ------------------------*
DATA: BEGIN OF t_t001k OCCURS 0.
        INCLUDE STRUCTURE t001k.
DATA: END   OF t_t001k.

*---- Liste der Buchungskreise zu den Bewertungskreisen ---------------*
DATA: BEGIN OF t_t001 OCCURS 0.
        INCLUDE STRUCTURE t001.
DATA: END   OF t_t001.

*---- Liste der selektierten Materialien ------------------------------*
DATA: BEGIN OF t_matnr OCCURS 0,
        matnr LIKE mara-matnr,         "Materialnummer
*#jhl 25.01.96 Materialart als Information entfällt
*       MTART LIKE MARA-MTART,       "Materialart
        meins LIKE rmmme1-meinh,       "Mengeneinheit der Anzeige
        basme LIKE mara-meins,         "Basis-Mengeneinheit
        lvorm LIKE mara-lvorm,         "Löschvormerkung
        matkl LIKE mara-matkl,         "Basiswarengruppe
        saiso LIKE mara-saiso,         "Saisonkennzeichen
        saisj LIKE mara-saisj,         "Saisonjahr
        plgtp LIKE mara-plgtp,         "Preislagentyp
        satnr LIKE mara-satnr,         "Verweis auf Sammelartikel
        attyp LIKE mara-attyp,         "Artikeltyp
        cuobf LIKE mara-cuobf,       "Interne Objektnr. z. Konfiguration
*TGA/4.6 Erweiterungen Lot (START)
        disst LIKE mara-disst,
*TGA/4.6 Erweiterungen Lot (END)
        mtart LIKE mara-mtart,         "note 1511925
        maktx LIKE makt-maktx,         "Materialkurztext
*#jhl 25.01.96 Materialart als Information entfällt
*       MTBEZ LIKE T134T-MTBEZ,      "Bezeichnung d. Materialart
        umrez_alt LIKE sy-tabix,       "Alter Umrechnungsfaktor
        umren_alt LIKE sy-tabix,
      END   OF t_matnr.
DATA: t_matnr_hlp LIKE TABLE OF t_matnr WITH HEADER LINE.               " n_2749155
*TGA/4.6 Erweiterungen Lot (START)
*----structure as interface for form bestandsdaten_lesen
DATA: BEGIN OF prt_matnr OCCURS 0.
        INCLUDE STRUCTURE t_matnr.
DATA: END   OF prt_matnr.
*------article(variants) with components and sum of component in
DATA: BEGIN OF t_comp_struc OCCURS 0,      " structured article
        comp_matnr LIKE mara-matnr.
        INCLUDE STRUCTURE rmgw2wu.
DATA: END   OF t_comp_struc.
*--- added stocks of components
DATA: BEGIN OF cum_comp OCCURS 0,
        comp_matnr LIKE mara-matnr,
*       gesmng type f.
        labst TYPE f.
DATA: END   OF cum_comp.
*TGA/4.6 Erweiterungen Lot (END)

*---- ARRAY-Fetch MARA ------------------------------------------------*
DATA: BEGIN OF t_mara OCCURS 0.
        INCLUDE STRUCTURE mara.
DATA: END   OF t_mara.

DATA : BEGIN OF t_mara1 OCCURS 0.
          INCLUDE STRUCTURE mara.
DATA : END OF t_mara1.

*---- Prefetch MARC ---------------------------------------------------*
DATA: BEGIN OF t_marc OCCURS 0.
        INCLUDE STRUCTURE marc.
DATA: END   OF t_marc.

*---- Prefetch MARD ---------------------------------------------------*
DATA: BEGIN OF t_mard OCCURS 0.
        INCLUDE STRUCTURE mard.
DATA: END   OF t_mard.

*---- Prefetch MBEW ---------------------------------------------------*
DATA: BEGIN OF t_mbew OCCURS 0.
        INCLUDE STRUCTURE mbew.
DATA: END   OF t_mbew.

*---- Prefetch MCHB ---------------------------------------------------*
DATA: BEGIN OF t_mchb OCCURS 0.
        INCLUDE STRUCTURE mchb.
DATA: END   OF t_mchb.

*---- Die von einem Lieferanten lieferbaren Materialien ---------------*
DATA: BEGIN OF t_liefmat OCCURS 0.
        INCLUDE STRUCTURE eina.
DATA: END   OF t_liefmat.


*---- Liste der Merkmale (inkl. Bezeichnungen) zu einem Sammelart., ---*
*---- einer Basiswarengruppe oder einer Warengruppenhierarchiestufe ---*
DATA: BEGIN OF t_merkm OCCURS 0.
        INCLUDE STRUCTURE api_char.
DATA: END   OF t_merkm.

*---- Liste der direkten Merkmale (ohne vererbte) für die Übergabe ----*
*---- an Selektions-Dynpro -> nur für Testzwecke????               ----*
DATA: BEGIN OF t_dirmerk OCCURS 0,
        atinn LIKE cabn-atinn,         " Interne Merkmalsnr.
        atino LIKE cabn-atinn,         " uninteressant -> weglassen ????
        abtei LIKE ksml-abtei,         " uninteressant -> weglassen ????
      END   OF t_dirmerk.

*---- Liste der Bewertungen (inkl. Bezeichnungen) zu den Merkmalen ----*
*---- in T_MERKM                                                   ----*
DATA: BEGIN OF t_bewert OCCURS 0.
        INCLUDE STRUCTURE api_vali.
DATA: END   OF t_bewert.

*---- Statusinformation zu den ermittelten Merkmalen ------------------*
DATA: BEGIN OF t_merkm_stat OCCURS 0,
        atinn LIKE cabn-atinn,         "Merkmal
        selek(1),                      "Merkmalswerteselektion liegt vor
        slcod LIKE comw-slcod,         "Vergleichsart (INCL, EXCL)
      END   OF t_merkm_stat.

*---- Liste der übers Dynpro selektierten Merkmalsbewertungen ---------*
DATA: BEGIN OF t_selbew OCCURS 0.
        INCLUDE STRUCTURE comw.
DATA: END   OF t_selbew.

*---- Merkmalsbewertungen der Varianten -------------------------------*
DATA: BEGIN OF t_ausp OCCURS 0.
        INCLUDE STRUCTURE ausp.
DATA: END   OF t_ausp.

*---- In der Matrix anzuzeigende Variantendaten -----------------------*
DATA: BEGIN OF t_varart OCCURS 0.
*????   INCLUDE STRUCTURE VARART.      26.07.96 ersetzt!
        INCLUDE STRUCTURE mtrx_vart.
DATA: END OF t_varart.

*---- Mengen, die in der Matrix zu den Varianten angezeigt werden -----*
DATA: BEGIN OF t_varme OCCURS 1.
        INCLUDE STRUCTURE mtrx_wsel.
DATA: END   OF t_varme.

*---- Festlegen des Anzeigemodus in der Matrix ------------------------*
DATA: BEGIN OF t_modes OCCURS 1.
        INCLUDE STRUCTURE mtrx_mode.
DATA: END   OF t_modes.

*---- Anzuzeigende Zeilen des Listkopfes bei Listmodus in Matrix ------*
DATA: BEGIN OF t_listh OCCURS 10,
        line(80),
      END   OF t_listh.

*---- Tabelle der zu inaktivierenden FCodes für die Umschaltung des ---*
*---- Textes bei der Artikelanzeige in der Grundliste zur Art.liste ---*
DATA: BEGIN OF t_fcodes_l OCCURS 5,
        fcode LIKE sy-ucomm,
      END   OF t_fcodes_l.

*---- Tabelle der zu inaktivierenden FCodes für die Umschaltung des ---*
*---- Textes b. d. Werksgrp.anzeige in d. Grundliste z. Einzelart.  ---*
DATA: BEGIN OF t_fcodes_e OCCURS 5,
        fcode LIKE sy-ucomm,
      END   OF t_fcodes_e.

*---- Für Prefetch auf MARM wg. späterer Ermittlung der mögl. Mengen- -*
*---- einheiten und für Prefetch auf MARC ohne Werksselektion         -*
DATA: BEGIN OF t_pre03 OCCURS 0.
        INCLUDE STRUCTURE pre03.
DATA: END   OF t_pre03.

*---- Für Prefetch auf MARC mit Werksselektion ------------------------*
DATA: BEGIN OF t_pre01 OCCURS 0.
        INCLUDE STRUCTURE pre01.
DATA: END   OF t_pre01.

*---- Für Prefetch auf MBEW -------------------------------------------*
DATA: BEGIN OF t_pre17 OCCURS 0.
        INCLUDE STRUCTURE pre17.
DATA: END   OF t_pre17.

*---- Hilfstabelle zur Ermittl. der mögl. Mengeneinheiten eines Mat. --*
DATA: BEGIN OF x_meeinh OCCURS 0.
        INCLUDE STRUCTURE rmmme1.
DATA: END OF x_meeinh.

*---- Mögliche Mengeneinheiten der Materialien ------------------------*
DATA: BEGIN OF t_meeinh OCCURS 0,
        matnr LIKE mara-matnr.
        INCLUDE STRUCTURE rmmme1.
DATA: END OF t_meeinh.

*---- Texte zu den Mengeneinheiten ------------------------------------*
DATA: BEGIN OF t_metext OCCURS 0,
        meinh LIKE rmmme1-meinh,
        msehl LIKE t006a-msehl,
      END   OF t_metext.

*---- Anzuzeigende Felder für eigene F4-Hilfe -------------------------*
DATA: BEGIN OF t_fields OCCURS 3.
        INCLUDE STRUCTURE help_value.
DATA: END   OF t_fields.

*---- Anzuzeigende Werte für eigene F4-Hilfe --------------------------*
DATA: BEGIN OF t_values OCCURS 50,
        value LIKE shvalue-low_value,
      END   OF t_values.

*---- Lieferantenteilsortimente ---------------------------------------*
*DATA: BEGIN OF T_WYT1T OCCURS 40.  ????kann entfallen
*        INCLUDE STRUCTURE WYT1T.
*DATA: END   OF T_WYT1T.

*---- Zusammenfassung der Felder der Grund- und aller Einzellisten ----*
DATA: BEGIN OF t_mefeld OCCURS 0,
            fname LIKE t136-fname,     "Feldname
      END OF   t_mefeld.

*---- Bestandsfelder der Grundliste zur gewählten Version -------------*
DATA: BEGIN OF grund_anzeige OCCURS 0,
        fennr LIKE t136-fennr,         "Fensternummer
        spanr LIKE t136-spanr,         "Spaltennummer
        fname LIKE t136-fname,         "Feldname
        text  LIKE t157b-ftext,        "Feldbezeichnung
      END   OF grund_anzeige.

*---- Bestandsfelder der Einzelliste zur gewählten Organisationsebene -*
DATA: BEGIN OF einzel_anzeige OCCURS 10,
        spanr LIKE t136v-spanr,        "Spaltennummer
        bfnae LIKE t136v-bfnae,        "Feldname
        text  LIKE t157b-ftext,        "Feldbezeichnung
      END   OF einzel_anzeige.

*---- Tabelle mit bereits eingelesenen Lieferanten --------------------*
DATA: BEGIN OF lftab OCCURS 20,
        lifnr LIKE lfa1-lifnr,
        name1 LIKE lfa1-name1,
      END OF lftab.

*---- Tabelle mit bereits eingelesenen Kunden -------------------------*
DATA: BEGIN OF kntab OCCURS 20,
        kunnr LIKE kna1-kunnr,
        name1 LIKE kna1-name1,
      END OF kntab.

*---- Zeilenfelder des HIDE-Bereichs -> Zugriffskey für interne -------*
*---- Bestandstabellen                                          -------*
DATA: BEGIN OF zle,
        matnr LIKE mara-matnr,         "Material
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*       BUKRS LIKE T001-BUKRS,        "Buchungskreis
        bwgrp LIKE rwbwg-bwgrp,        "Basiswerksgruppe
        werks LIKE t001w-werks,        "Werk
        lgort LIKE mard-lgort,         "Lagerort
        lifnr LIKE mkol-lifnr,         "Lieferant
        kunnr LIKE msku-kunnr,         "Kunde
        vbeln LIKE mska-vbeln,         "Vertriebsbelegnummer
        posnr LIKE mska-posnr,         "Positionsnummer
        sgt_scat LIKE mchb-sgt_scat,   "Stock Segment
        charg LIKE mchb-charg,         "Batch
        satnr LIKE mara-satnr,
*       ETENR LIKE MSKA-ETENR,        "Einteilungsnummer
*       PSPNR LIKE MSPR-PSPNR,        "Projekt????uninteress. f. Handel
*<<<        hier Schlüsselfelder für weitere Bestandstabellen ergänzen
      END   OF zle.

*---- HIDE-Daten retten für Rücksprung in Matrix ----------------------*
DATA: BEGIN OF hide_alt.
        INCLUDE STRUCTURE zle.
DATA:   zeilen_kz LIKE zeilen_kz,
        bezei_kz  LIKE bezei_kz,
        sond_kz   LIKE sond_kz,
        kz_kein_o LIKE kz_kein_o,
        kz_kein_w LIKE kz_kein_w,
        kz_kein_v LIKE kz_kein_v,
      END   OF hide_alt.

*---- Bestandstabellen ------------------------------------------------*
*---- (alle auf der jeweiligen Ebene gültigen Bestandsfelder aus der --*
*---- Tabelle T136F; zusätzlich Konsibestandsfelder)                 --*
* Achtung: Erweiterung der Tabelle T136F erfordert Anpassung d. Codings
* Achtung: OMENG müßte eigent. VBMNJ heißen (Kompatibiltät zu bereits
*          durchgeführten Auslieferungen)

*---- Summe der Mandantenbestände aller Materialien einer Liste -------*
*---- (wird aus Performancegründen online bei Bedarf gefüllt)   -------*
DATA: BEGIN OF smb,
        labst TYPE f,                  "Frei verwendbarer Bestand
        umlme TYPE f,                  "Umlagerungsbestand Lagerort
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        retme TYPE f,                  "Retourenbestand
        umlmc TYPE f,                  "Umlagerungsbestand Werk
        trame TYPE f,                  "Transitbestand Werk
        trasf TYPE f,                  "Transitbestand Buchungskreis
        lbkum TYPE f,                  "Bewerteter Bestand
        wespb TYPE f,                  "WE-Sperrbestand
        vbmna TYPE f,                  "Kundenanfragen
        vbmnb TYPE f,                  "Angebote an Kunden
        vbmnc TYPE f,                  "Kundenaufträge
        vbmne TYPE f,                  "Kundenlieferpläne
        vbmng TYPE f,                  "Kundenkontrakte
        vbmni TYPE f,                  "Kostenlose Lieferung an Kund.
        omeng TYPE f,                  "Lieferungen an Kunden
        menge TYPE f,                  "Offener Bestellbestand
        mengk TYPE f,                  "Offener Bestell. Konsilief
        bdmng TYPE f,                  "Reservierter Bestand
        bdmns TYPE f,                  "Geplante Zugänge (Sollreserv
        bsabr TYPE f,                  "Abrufe UL-Bestellungen
        famng TYPE f,                  "FAUF-Menge
        klabs TYPE f,                  "L.Konsi. frei verwendbar
        kinsm TYPE f,                  "L.Konsi. in Qualitätsprüfung
        keinm TYPE f,                  "L.Konsi. eingeschränkt verw.
        kspem TYPE f,                  "L.Konsi. gesperrt
        calab TYPE f,                  "K.A.Best. beim Lief. fr. verw
        cains TYPE f,                  "K.A.Best. beim Lief. QualPrf.
        kalab TYPE f,                  "K.Auftr.Best. frei verwendbar
        kains TYPE f,                  "K.Auftr.Best. Qualitätsprüfg.
        kaspe TYPE f,                  "K.Auftr.Best. Sperrbestand
        kaein TYPE f,                  "K.Auftr.Best. eing. verw.
        kulav TYPE f,                  "K.Leergut frei verwendbar
        kuinv TYPE f,                  "K.Leergut Qualitätsprüfung
        kueiv TYPE f,                  "K.Leergut eing. verw.
        kulaw TYPE f,                  "K.Konsign. frei verwendbar
        kuinw TYPE f,                  "K.Konsign. Qualitätsprüfung
        kueiw TYPE f,                  "K.Konsign. eing. verw.
        lblab TYPE f,                  "L.Beistellung frei verwendbar
        lbins TYPE f,                  "L.Beistellung Qualitätsprüfg.
        lbein TYPE f,                  "L.Beistellung eing. verw.
                                       "MTV = Mehrwegtransportverpackung
        mlabs TYPE f,                  "MTV frei verwendbar
        minsm TYPE f,                  "MTV in Qualitätsprüfung
        meinm TYPE f,                  "MTV eingeschränkt verw.
        mspem TYPE f,                  "MTV gesperrt
        prlab TYPE f,                  "Projektbest. frei verwendbar
        prins TYPE f,                  "Projektbest. Qualitätsprüfg.
        prspe TYPE f,                  "Projektbest. Sperrbestand
        prein TYPE f,                  "Projektbest. eing. verwendb.
* JH/4.0A/28.07.97 Neues Bestandsfeld
        glgmg TYPE f,                  "Gebundene Leergutmenge
*<<<        hier später weitere Sonderbestandsfelder einfügen
      END OF smb.

*---- Mandantenbestände pro Material ----------------------------------*
DATA: BEGIN OF mbe OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        lvorm LIKE mara-lvorm,         "Löschvormerkung
        labst TYPE f,                  "Frei verwendbarer Bestand
        umlme TYPE f,                  "Umlagerungsbestand Lagerort
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        retme TYPE f,                  "Retourenbestand
        umlmc TYPE f,                  "Umlagerungsbestand Werk
        trame TYPE f,                  "Transitbestand Werk
        trasf TYPE f,                  "Transitbestand Buchungskreis
        lbkum TYPE f,                  "Bewerteter Bestand
        wespb TYPE f,                  "WE-Sperrbestand
        vbmna TYPE f,                  "Kundenanfragen
        vbmnb TYPE f,                  "Angebote an Kunden
        vbmnc TYPE f,                  "Kundenaufträge
        vbmne TYPE f,                  "Kundenlieferpläne
        vbmng TYPE f,                  "Kundenkontrakte
        vbmni TYPE f,                  "Kostenlose Lieferung an Kund.
        omeng TYPE f,                  "Lieferungen an Kunden
        menge TYPE f,                  "Offener Bestellbestand
        mengk TYPE f,                  "Offener Bestell. Konsilief
        bdmng TYPE f,                  "Reservierter Bestand
        bdmns TYPE f,                  "Geplante Zugänge (Sollreserv
        bsabr TYPE f,                  "Abrufe UL-Bestellungen
        famng TYPE f,                  "FAUF-Menge
        klabs TYPE f,                  "L.Konsi. frei verwendbar
        kinsm TYPE f,                  "L.Konsi. in Qualitätsprüfung
        keinm TYPE f,                  "L.Konsi. eingeschränkt verw.
        kspem TYPE f,                  "L.Konsi. gesperrt
        calab TYPE f,                  "K.A.Best. beim Lief. fr. verw
        cains TYPE f,                  "K.A.Best. beim Lief. QualPrf.
        kalab TYPE f,                  "K.Auftr.Best. frei verwendbar
        kains TYPE f,                  "K.Auftr.Best. Qualitätsprüfg.
        kaspe TYPE f,                  "K.Auftr.Best. Sperrbestand
        kaein TYPE f,                  "K.Auftr.Best. eing. verw.
        kulav TYPE f,                  "K.Leergut frei verwendbar
        kuinv TYPE f,                  "K.Leergut Qualitätsprüfung
        kueiv TYPE f,                  "K.Leergut eing. verw.
        kulaw TYPE f,                  "K.Konsign. frei verwendbar
        kuinw TYPE f,                  "K.Konsign. Qualitätsprüfung
        kueiw TYPE f,                  "K.Konsign. eing. verw.
        lblab TYPE f,                  "L.Beistellung frei verwendbar
        lbins TYPE f,                  "L.Beistellung Qualitätsprüfg.
        lbein TYPE f,                  "L.Beistellung eing. verw.
*                                      MTV = Mehrwegtransportverpackung
        mlabs TYPE f,                  "MTV frei verwendbar
        minsm TYPE f,                  "MTV in Qualitätsprüfung
        meinm TYPE f,                  "MTV eingeschränkt verw.
        mspem TYPE f,                  "MTV gesperrt
        prlab TYPE f,                  "Projektbest. frei verwendbar
        prins TYPE f,                  "Projektbest. Qualitätsprüfg.
        prspe TYPE f,                  "Projektbest. Sperrbestand
        prein TYPE f,                  "Projektbest. eing. verwendb.
* JH/4.0A/28.07.97 Neues Bestandsfeld
        glgmg TYPE f,                  "Gebundene Leergutmenge
*<<<        hier später weitere Sonderbestandsfelder einfügen
      END OF mbe.

*#jhl 31.01.96 (Anfang)
*#jhl Buchungskreis als Bestandsebene wird durch Ebene der Basiswerks-
*#jhl gruppen ersetzt
*DATA: BEGIN OF BBE OCCURS 0,  "Buchungskreisbestände
*           MATNR LIKE MARA-MATNR,        "Schlüssel - Material
*           BUKRS LIKE MARCV-BUKRS,       "Schlüssel - Buchungskreis
*           SATNR LIKE MARA-SATNR,        "Verweis auf zugeordn. SA
*           LABST TYPE F,                 "Frei verwendbarer Bestand
*           UMLME TYPE F,                 "Umlagerungsbestand Lagerort
*           INSME TYPE F,                 "Qualitaetskontrollbestand
*           EINME TYPE F,                 "eingeschraenkt verwendbar
*           SPEME TYPE F,                 "gesperrter Bestand
*           RETME TYPE F,                 "Retourenbestand
*           UMLMC TYPE F,                 "Umlagerungsbestand Werk
*           TRAME TYPE F,                 "Transitbestand Werk
*           TRASF TYPE F,                 "Transitbestand Buchungskreis
*           LBKUM TYPE F,                 "Bewerteter Bestand
*           WESPB TYPE F,                 "WE-Sperrbestand
*           VBMNA TYPE F,                 "Kundenanfragen
*           VBMNB TYPE F,                 "Angebote an Kunden
*           VBMNC TYPE F,                 "Kundenaufträge
*           VBMNE TYPE F,                 "Kundenlieferpläne
*           VBMNG TYPE F,                 "Kundenkontrakte
*           VBMNI TYPE F,                 "Kostenlose Lieferung an Kund.
*           OMENG TYPE F,                 "Lieferungen an Kunden
*           MENGE TYPE F,                 "Offener Bestellbestand
*           MENGK TYPE F,                 "Offener Bestell. Konsilief
*           BDMNG TYPE F,                 "Reservierter Bestand
*           BDMNS TYPE F,                 "Geplante Zugänge (Sollreserv
*           BSABR TYPE F,                 "Abrufe UL-Bestellungen
*           FAMNG TYPE F,                 "FAUF-Menge
*           KLABS TYPE F,                 "L.Konsi. frei verwendbar
*           KINSM TYPE F,                 "L.Konsi. in Qualitätsprüfung
*           KEINM TYPE F,                 "L.Konsi. eingeschränkt verw.
*           KSPEM TYPE F,                 "L.Konsi. gesperrt
*           CALAB TYPE F,                 "K.A.Best. beim Lief. fr. verw
*           CAINS TYPE F,                 "K.A.Best. beim Lief. QualPrf.
*           KALAB TYPE F,                 "K.Auftr.Best. frei verwendbar
*           KAINS TYPE F,                 "K.Auftr.Best. Qualitätsprüfg.
*           KASPE TYPE F,                 "K.Auftr.Best. Sperrbestand
*           KAEIN TYPE F,                 "K.Auftr.Best. eing. verw.
*           KULAV TYPE F,                 "K.Leergut frei verwendbar
*           KUINV TYPE F,                 "K.Leergut Qualitätsprüfung
*           KUEIV TYPE F,                 "K.Leergut eing. verw.
*           KULAW TYPE F,                 "K.Konsign. frei verwendbar
*           KUINW TYPE F,                 "K.Konsign. Qualitätsprüfung
*           KUEIW TYPE F,                 "K.Konsign. eing. verw.
*           LBLAB TYPE F,                 "L.Beistellung frei verwendbar
*           LBINS TYPE F,                 "L.Beistellung Qualitätsprüfg.
*           LBEIN TYPE F,                 "L.Beistellung eing. verw.
*                                      MTV = Mehrwegtransportverpackung
*           MLABS TYPE F,                 "MTV frei verwendbar
*           MINSM TYPE F,                 "MTV in Qualitätsprüfung
*           MEINM TYPE F,                 "MTV eingeschränkt verw.
*           MSPEM TYPE F,                 "MTV gesperrt
*           PRLAB TYPE F,                 "Projektbest. frei verwendbar
*           PRINS TYPE F,                 "Projektbest. Qualitätsprüfg.
*           PRSPE TYPE F,                 "Projektbest. Sperrbestand
*           PREIN TYPE F,                 "Projektbest. eing. verwendb.
*<<<        hier später weitere Sonderbestandsfelder einfügen
*      END OF BBE.
*#jhl 31.01.96 (Ende)

*---- Basiswerksgruppenbestände pro Material --------------------------*
DATA: BEGIN OF gbe OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
* JH/12.11.96 Damit richtige F1-Hilfe in Liste erscheint
*       BWGRP LIKE RWBWG-BWGRP,       "Schlüssel - Basiswerksgruppe
        bwgrp LIKE rwgrp-wkgrp,        "Schlüssel - Basiswerksgruppe
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Frei verwendbarer Bestand
        umlme TYPE f,                  "Umlagerungsbestand Lagerort
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        retme TYPE f,                  "Retourenbestand
        umlmc TYPE f,                  "Umlagerungsbestand Werk
        trame TYPE f,                  "Transitbestand Werk
        trasf TYPE f,                  "Transitbestand Buchungskreis
        lbkum TYPE f,                  "Bewerteter Bestand
        wespb TYPE f,                  "WE-Sperrbestand
        vbmna TYPE f,                  "Kundenanfragen
        vbmnb TYPE f,                  "Angebote an Kunden
        vbmnc TYPE f,                  "Kundenaufträge
        vbmne TYPE f,                  "Kundenlieferpläne
        vbmng TYPE f,                  "Kundenkontrakte
        vbmni TYPE f,                  "Kostenlose Lieferung an Kund.
        omeng TYPE f,                  "Lieferungen an Kunden
        menge TYPE f,                  "Offener Bestellbestand
        mengk TYPE f,                  "Offener Bestell. Konsilief
        bdmng TYPE f,                  "Reservierter Bestand
        bdmns TYPE f,                  "Geplante Zugänge (Sollreserv
        bsabr TYPE f,                  "Abrufe UL-Bestellungen
        famng TYPE f,                  "FAUF-Menge
        klabs TYPE f,                  "L.Konsi. frei verwendbar
        kinsm TYPE f,                  "L.Konsi. in Qualitätsprüfung
        keinm TYPE f,                  "L.Konsi. eingeschränkt verw.
        kspem TYPE f,                  "L.Konsi. gesperrt
        calab TYPE f,                  "K.A.Best. beim Lief. fr. verw
        cains TYPE f,                  "K.A.Best. beim Lief. QualPrf.
        kalab TYPE f,                  "K.Auftr.Best. frei verwendbar
        kains TYPE f,                  "K.Auftr.Best. Qualitätsprüfg.
        kaspe TYPE f,                  "K.Auftr.Best. Sperrbestand
        kaein TYPE f,                  "K.Auftr.Best. eing. verw.
        kulav TYPE f,                  "K.Leergut frei verwendbar
        kuinv TYPE f,                  "K.Leergut Qualitätsprüfung
        kueiv TYPE f,                  "K.Leergut eing. verw.
        kulaw TYPE f,                  "K.Konsign. frei verwendbar
        kuinw TYPE f,                  "K.Konsign. Qualitätsprüfung
        kueiw TYPE f,                  "K.Konsign. eing. verw.
        lblab TYPE f,                  "L.Beistellung frei verwendbar
        lbins TYPE f,                  "L.Beistellung Qualitätsprüfg.
        lbein TYPE f,                  "L.Beistellung eing. verw.
                                       "MTV = Mehrwegtransportverpackung
        mlabs TYPE f,                  "MTV frei verwendbar
        minsm TYPE f,                  "MTV in Qualitätsprüfung
        meinm TYPE f,                  "MTV eingeschränkt verw.
        mspem TYPE f,                  "MTV gesperrt
        prlab TYPE f,                  "Projektbest. frei verwendbar
        prins TYPE f,                  "Projektbest. Qualitätsprüfg.
        prspe TYPE f,                  "Projektbest. Sperrbestand
        prein TYPE f,                  "Projektbest. eing. verwendb.
* JH/4.0A/28.07.97 Neues Bestandsfeld
        glgmg TYPE f,                  "Gebundene Leergutmenge
*<<<        hier später weitere Sonderbestandsfelder einfügen
      END OF gbe.

*---- Werksbestände pro Material --------------------------------------*
DATA: BEGIN OF wbe OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE marcv-werks,        "Schlüssel - Werk
*#jhl 31.01.96 Buchungskreis durch Basiswerksgruppen ersetzt
*       BUKRS LIKE MARCV-BUKRS,       "Buchungskreis
        bwgrp LIKE rwbwg-bwgrp,        "zugeordnete Basiswerksgruppe
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        name1 LIKE marcv-name1,        "Name1 zum Werk
        lvorm LIKE marc-lvorm,         "Loeschvormerkung
        labst TYPE f,                  "Frei verwendbarer Bestand
        umlme TYPE f,                  "Umlagerungsbestand Lagerort
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        retme TYPE f,                  "Retourenbestand
        umlmc TYPE f,                  "Umlagerungsbestand Werk
        trame TYPE f,                  "Transitbestand Werk
        trasf TYPE f,                  "Transitbestand Buchungskreis
        lbkum TYPE f,                  "Bewerteter Bestand
        wespb TYPE f,                  "WE-Sperrbestand
        vbmna TYPE f,                  "Kundenanfragen
        vbmnb TYPE f,                  "Angebote an Kunden
        vbmnc TYPE f,                  "Kundenaufträge
        vbmne TYPE f,                  "Kundenlieferpläne
        vbmng TYPE f,                  "Kundenkontrakte
        vbmni TYPE f,                  "Kostenlose Lieferung an Kund.
        omeng TYPE f,                  "Lieferungen an Kunden
        menge TYPE f,                  "Offener Bestellbestand
        mengk TYPE f,                  "Offener Bestell. Konsilief
        bdmng TYPE f,                  "Reservierter Bestand
        bdmns TYPE f,                  "Geplante Zugänge (Sollreserv
        bsabr TYPE f,                  "Abrufe UL-Bestellungen
        famng TYPE f,                  "FAUF-Menge
        klabs TYPE f,                  "L.Konsi. frei verwendbar
        kinsm TYPE f,                  "L.Konsi. in Qualitätsprüfung
        keinm TYPE f,                  "L.Konsi. eingeschränkt verw.
        kspem TYPE f,                  "L.Konsi. gesperrt
        calab TYPE f,                  "K.A.Best. beim Lief. fr. verw
        cains TYPE f,                  "K.A.Best. beim Lief. QualPrf.
        kalab TYPE f,                  "K.Auftr.Best. frei verwendbar
        kains TYPE f,                  "K.Auftr.Best. Qualitätsprüfg.
        kaspe TYPE f,                  "K.Auftr.Best. Sperrbestand
        kaein TYPE f,                  "K.Auftr.Best. eing. verw.
        kulav TYPE f,                  "K.Leergut frei verwendbar
        kuinv TYPE f,                  "K.Leergut Qualitätsprüfung
        kueiv TYPE f,                  "K.Leergut eing. verw.
        kulaw TYPE f,                  "K.Konsign. frei verwendbar
        kuinw TYPE f,                  "K.Konsign. Qualitätsprüfung
        kueiw TYPE f,                  "K.Konsign. eing. verw.
        lblab TYPE f,                  "L.Beistellung frei verwendbar
        lbins TYPE f,                  "L.Beistellung Qualitätsprüfg.
        lbein TYPE f,                  "L.Beistellung eing. verw.
                                       "MTV = Mehrwegtransportverpackung
        mlabs TYPE f,                  "MTV frei verwendbar
        minsm TYPE f,                  "MTV in Qualitätsprüfung
        meinm TYPE f,                  "MTV eingeschränkt verw.
        mspem TYPE f,                  "MTV gesperrt
        prlab TYPE f,                  "Projektbest. frei verwendbar
        prins TYPE f,                  "Projektbest. Qualitätsprüfg.
        prspe TYPE f,                  "Projektbest. Sperrbestand
        prein TYPE f,                  "Projektbest. eing. verwendb.
* JH/4.0A/28.07.97 Neues Bestandsfeld
        glgmg TYPE f,                  "Gebundene Leergutmenge
*<<<        hier später weitere Sonderbestandsfelder einfügen
      END OF wbe.

* outtab on level of storage location
TYPES: BEGIN OF ex_lgort,
        lgort LIKE mard-lgort,
        lgortkz TYPE c,
        sondcha(10) TYPE c,
       END OF ex_lgort.

DATA: ex_lgort TYPE ex_lgort.


TYPES:
      BEGIN OF ex_chars.
ENHANCEMENT-POINT RWBE1TOP_05 SPOTS ES_RWBEST01 STATIC .
TYPES: dummy type c,
      END OF ex_chars.

DATA :
  BEGIN OF cbe OCCURS 0,
        matnr LIKE mara-matnr,
        bwgrp LIKE rwbwg-bwgrp,
        werks LIKE mard-werks,
        lgort LIKE mard-lgort,
        sgt_scat TYPE sgt_scat,
        charg TYPE charg_d,
        satnr LIKE mara-satnr,
        lgpbe LIKE mard-lgpbe,
        lvorm LIKE mard-lvorm.
ENHANCEMENT-POINT RWBE1TOP_03 SPOTS ES_RWBEST01 STATIC .
  DATA:
        labst TYPE f,
        umlme TYPE f,
        insme TYPE f,
        einme TYPE f,
        speme TYPE f,
        retme TYPE f,
        vbmna TYPE f,
        vbmnb TYPE f,
        vbmnc TYPE f,
        vbmne TYPE f,
        vbmng TYPE f,
        vbmni TYPE f,
        omeng TYPE f,
        menge TYPE f,
        mengk TYPE f,
        bdmng TYPE f,
        bdmns TYPE f,
        klabs TYPE f,
        kinsm TYPE f,
        keinm TYPE f,
        kspem TYPE f,
        kalab TYPE f,
        kains TYPE f,
        kaspe TYPE f,
        kaein TYPE f,
        mlabs TYPE f,
        minsm TYPE f,
        meinm TYPE f,
        mspem TYPE f,
        prlab TYPE f,
        prins TYPE f,
        prspe TYPE f,
        prein TYPE f,
        lblab TYPE f,
        lbins TYPE f,
        lbein TYPE f.
        INCLUDE TYPE EXT_CHARS.
 DATA END OF cbe.

TYPES : BEGIN OF s_cbe,
        satnr TYPE mara-satnr,
        matnr LIKE mara-matnr,
        bwgrp LIKE rwbwg-bwgrp,
        werks LIKE mard-werks,
        ex_lgort LIKE ex_lgort,
        sgt_scat TYPE sgt_scat,
        charg TYPE charg_d,
        meinh LIKE marm-meinh,
        name1(40) TYPE c.
ENHANCEMENT-POINT RWBETOP_07 SPOTS ES_RWBEST01 STATIC .
TYPES:
        lvorm(3) TYPE c,
        labst LIKE mard-labst,
        umlme LIKE mard-umlme,
        insme LIKE mard-insme,
        einme LIKE mard-einme,
        speme LIKE mard-speme,
        retme LIKE mard-retme,
        umlmc LIKE marc-umlmc,
        trame LIKE marc-trame,
        trasf LIKE ekbe-wesbs,
        wespb LIKE ekbe-wesbs,
        vbmna LIKE rmmmb-vbmna,
        vbmnb LIKE rmmmb-vbmnb,
        vbmnc LIKE rmmmb-vbmnc,
        vbmne LIKE rmmmb-vbmne,
        vbmng LIKE rmmmb-vbmnb,
        vbmni LIKE rmmmb-vbmni,
        omeng LIKE rmmmb-omeng,
        menge LIKE ekpo-menge,
        mengk LIKE rmmmb-mengk,
        bdmng LIKE rmmmb-bdmng,
        bdmns LIKE rmmmb-bdmns,
        bsabr LIKE rmmmb-bsabr,
        klabs LIKE mard-klabs,
        kinsm LIKE mard-kinsm,
        keinm LIKE mard-keinm,
        kspem LIKE mard-kspem,
        kalab LIKE mska-kalab,
        kains LIKE mska-kains,
        kaspe LIKE mska-kaspe,
        kaein LIKE mska-kaein,
        kulav LIKE msku-kulab,
        kuinv LIKE msku-kuins,
        kueiv LIKE msku-kuein,
        kulaw LIKE msku-kulab,
        kuinw LIKE msku-kuins,
        kueiw LIKE msku-kuein,
        lblab LIKE mslb-lblab,
        lbins LIKE mslb-lbins,
        lbein LIKE mslb-lbein,
        mlabs LIKE mkol-slabs,
        minsm LIKE mkol-sinsm,
        meinm LIKE mkol-seinm,
        mspem LIKE mkol-sspem,
        glgmg LIKE marc-glgmg.
        include TYPE EXT_CHARS.
TYPES END OF s_cbe.

TYPES : BEGIN OF tt_mska_seg,
      matnr TYPE matnr,
      werks TYPE werks_d,
      lgort TYPE lgort_d,
      charg TYPE charg_d,
      vbeln TYPE mska-vbeln,
      posnr TYPE mska-posnr,
      kalab TYPE labst,
      kains TYPE insme,
      kaspe TYPE speme,
      kaein TYPE einme,
      sgt_scat TYPE sgt_scat.
      INCLUDE TYPE ext_seasons.
      INCLUDE TYPE EXT_CHARS.
      TYPES END OF tt_mska_seg.

TYPES: BEGIN OF tt_msku_seg,
      matnr TYPE matnr,
      werks TYPE werks_d,
      charg TYPE charg_d,
      kunnr TYPE kunnr,
      sobkz TYPE sobkz,
      kulab TYPE labst,
      kuins TYPE insme,
      kuein TYPE einme,
      sgt_scat TYPE sgt_scat.
      INCLUDE TYPE ext_seasons.
      INCLUDE TYPE EXT_CHARS.
   TYPES    END OF tt_msku_seg.

ENHANCEMENT-POINT RWBE1TOP_06 SPOTS ES_RWBEST01 STATIC .


DATA: gv_charg TYPE charg_d,
      gv_index TYPE sy-tabix.

DATA : BEGIN OF cbe_key,
        matnr LIKE marc-matnr,
        werks LIKE marc-werks,
        lgort LIKE mard-lgort,
        charg LIKE mchb-charg,
       END OF cbe_key.

* additions for ALV-tree start tga >991009
* outtab on site level (without storage location)
* selected key and name of tree item
DATA : lt_sel_node  TYPE   lvc_nkey,
       lt_sel_name  TYPE   lvc_fname.

DATA: ok_code1 LIKE sy-ucomm,  "for mattree1
      ok_code2 LIKE sy-ucomm.  "for mattree2

DATA  var_tree VALUE 'N'.  "variant tree at work

DATA: external_call(1) TYPE c.
* constants
DATA:  ls_variant TYPE disvariant,
*      def_variant Type disvariant,
       x_save VALUE 'A',                        "for parameter save
       maintree_act TYPE c VALUE 'M',            "maintree active
       vartree_act TYPE c VALUE 'V'.             "vartree active
* especially needed for proc. out of class lcl_toolbar_event_receiver
* replaces variable 'sender' which is only known in class area
DATA   tree_act TYPE c.                         "active tree

TYPES: s_t157b LIKE t157b.
TYPES: t_t157b TYPE STANDARD TABLE OF s_t157b.

DATA: t_t157b TYPE t_t157b,
      s_t157b TYPE s_t157b.

TYPES: BEGIN OF ex_werks,
        werks LIKE marcv-werks,
        sondcha(10) TYPE c,
       END OF ex_werks.
DATA: ex_werks TYPE ex_werks.
* outtagb stor. loc.  key
DATA:  norm_sl VALUE '1',    "normal storage location
       sp_sl   VALUE '2',    "storage location special stocks
       no_sl   VALUE '0'.    "no storage location, only for cumulation

ENHANCEMENT-SECTION RWBE1TOP_02 SPOTS ES_RWBEST01 STATIC .
TYPES: BEGIN OF s_wbe ,
        satnr LIKE mara-satnr,
        matnr LIKE mara-matnr,        "Schlüssel - Material
        bwgrp LIKE rwbwg-bwgrp,       "zugeordnete Basiswerksgruppe
        ex_werks LIKE ex_werks,     "Schlüssel - Werk
        meinh LIKE marm-meinh,        "Mengeneinheit
* tga note 356164
        name1(40) TYPE c,
*       NAME1(30) TYPE C,
*              LIKE MARCV-NAME1,       "text of node object
        lvorm(3) TYPE c,                 "Loeschvormerkung
        labst LIKE mard-labst,        "Frei verwendbarer Bestan
        umlme LIKE mard-umlme,        "Umlagerungsbestand Lagerort
        insme LIKE mard-insme,        "Qualitaetskontrollbestand
        einme LIKE mard-einme,        "eingeschraenkt verwendba
        speme LIKE mard-speme,        "gesperrter Bestand
        retme LIKE mard-retme,        "Retourenbestand
        umlmc LIKE marc-umlmc,        "Umlagerungsbestand Werk
        trame LIKE marc-trame,        "Transitbestand Werk
        trasf LIKE ekbe-wesbs,        "Transitbestand Buchungsk
*       LBKUM LIKE MBEW-LBKUM,        "Bewerteter Bestand
        wespb LIKE ekbe-wesbs,        "WE-Sperrbestand
        vbmna LIKE rmmmb-vbmna,       "Kundenanfragen
        vbmnb LIKE rmmmb-vbmnb,       "Angebote an Kunden
        vbmnc LIKE rmmmb-vbmnc,       "Kundenaufträge
        vbmne LIKE rmmmb-vbmne,       "Kundenlieferpläne
        vbmng LIKE rmmmb-vbmnb,       "Kundenkontrakte
        vbmni LIKE rmmmb-vbmni,       "Kostenlose Lieferung an
        omeng LIKE rmmmb-omeng,       "Lieferungen an Kunden
        menge LIKE ekpo-menge,        "Offener Bestellbestand
        mengk LIKE rmmmb-mengk,       "Offener Bestell. Konsil
        bdmng LIKE rmmmb-bdmng,       "Reservierter Bestand
        bdmns LIKE rmmmb-bdmns,       "Geplante Zugänge (Sollr
        bsabr LIKE rmmmb-bsabr,       "Abrufe UL-Bestellungen
*       FAMNG LIKE RMMMB-FAMNG,       "FAUF-Menge
        klabs LIKE mard-klabs,        "L.Konsi. frei verwendbar
        kinsm LIKE mard-kinsm,        "L.Konsi. in Qualitätsprüfung
        keinm LIKE mard-keinm,        "L.Konsi. eingeschränkt verw.
        kspem LIKE mard-kspem,        "L.Konsi. gesperrt
*       CALAB LIKE MSCA-CALAB,        "K.A.Best. beim Lief. fr. verw
*       CAINS LIKE MSCA-CAINS,        "K.A.Best. beim Lief. QualPrf.
        kalab LIKE mska-kalab,        "K.Auftr.Best. frei verwendbar
        kains LIKE mska-kains,        "K.Auftr.Best. Qualitätsprüfg.
        kaspe LIKE mska-kaspe,       "K.Auftr.Best. Sperrbestand
        kaein LIKE mska-kaein,       "K.Auftr.Best. eing. verw.
        kulav LIKE msku-kulab,        "K.Leergut frei verwendbar
        kuinv LIKE msku-kuins,        "K.Leergut Qualitätsprüfung
        kueiv LIKE msku-kuein,        "K.Leergut eing. verw.
        kulaw LIKE msku-kulab,        "K.Konsign. frei verwendbar
        kuinw LIKE msku-kuins,        "K.Konsign. Qualitätsprüfung
        kueiw LIKE msku-kuein,        "K.Konsign. eing. verw.
        lblab LIKE mslb-lblab,        "L.Beistellung frei verwendbar
        lbins LIKE mslb-lbins,        "L.Beistellung Qualitätsprüfg.
        lbein LIKE mslb-lbein,        "L.Beistellung eing. verw.
*                                     "MTV = Mehrwegtransportverpackung
        mlabs LIKE mkol-slabs,        "MTV frei verwendbar
        minsm LIKE mkol-sinsm,        "MTV in Qualitätsprüfung
        meinm LIKE mkol-seinm,       "MTV eingeschränkt verw.
        mspem LIKE mkol-sspem,        "MTV gesperrt
*        PRLAB LIKE MSPR-PRLAB,       "Projektbest. frei verwendbar
*        PRINS LIKE MSPR-PRINS,        "Projektbest. Qualitätsprüfg.
*        PRSPE LIKE MSPR-PRSPE,        "Projektbest. Sperrbestand
*        PREIN LIKE MSPR-PREIN,        "Projektbest. eing. verwendb.
        glgmg LIKE marc-glgmg,        "Gebundene Leergutmenge
END OF s_wbe.
END-ENHANCEMENT-SECTION.
TYPES t_wbe TYPE STANDARD TABLE OF s_wbe.
DATA: t_wbe   TYPE t_wbe,       "outtab site level
      gt_wbe  TYPE t_wbe.       "empty outtab for first display
DATA: s_wbe TYPE s_wbe,
      final_cbe TYPE STANDARD TABLE OF sgt_alv_cbe,
      final_wbe TYPE STANDARD TABLE OF sgt_alv_wbe,
      final_lbe TYPE STANDARD TABLE OF sgt_alv_lbe.

ENHANCEMENT-SECTION RWBE1TOP_01 SPOTS ES_RWBEST01 STATIC .
TYPES: BEGIN OF s_lbe,
        satnr LIKE mara-satnr,
        matnr LIKE mara-matnr,        "Schlüssel - Material
        bwgrp LIKE rwbwg-bwgrp,       "Schlüssel - Basiswerksgr
        werks LIKE mard-werks,        "Schlüssel - Werk
        ex_lgort LIKE ex_lgort,        "expanded key - lgort (sl)
*       SATNR LIKE MARA-SATNR,        "Verweis auf zugeordn. SA
        meinh LIKE marm-meinh,        "Mengeneinheit
* tga note 356164
        name1(40) TYPE c,
*       NAME1(30) TYPE C,
*       LIKE MARCV-NAME1,       "text of node object
*       LGPBE LIKE MARD-LGPBE,        "Lagerplatzbeschreibung
        lvorm(3) TYPE c,              "Loeschvormerkung
        labst LIKE mard-labst,               "Frei verwendbarer Bestand
        umlme LIKE mard-umlme,        "Umlagerungsbestand Lagerort
        insme LIKE mard-insme,        "Qualitaetskontrollbestand
        einme LIKE mard-einme,        "eingeschraenkt verwendba
        speme LIKE mard-speme,        "gesperrter Bestand
        retme LIKE mard-retme,        "Retourenbestand
        umlmc LIKE marc-umlmc,        "Umlagerungsbestand Werk
        trame LIKE marc-trame,        "Transitbestand Werk
        trasf LIKE ekbe-wesbs,        "Transitbestand Buchungskreis
*       LBKUM LIKE MBEW-LBKUM,        "Bewerteter Bestand
        wespb LIKE ekbe-wesbs,        "WE-Sperrbestand
        vbmna LIKE rmmmb-vbmna,        "Kundenanfragen
        vbmnb LIKE rmmmb-vbmnb,       "Angebote an Kunden
        vbmnc LIKE rmmmb-vbmnc,       "Kundenaufträge
        vbmne LIKE rmmmb-vbmne,       "Kundenlieferpläne
        vbmng LIKE rmmmb-vbmnb,       "Kundenkontrakte
        vbmni LIKE rmmmb-vbmni,       "Kostenlose Lieferung an
        omeng LIKE rmmmb-omeng,       "Lieferungen an Kunden
        menge LIKE ekpo-menge,        "Offener Bestellbestand
        mengk LIKE rmmmb-mengk,       "Offener Bestell. Konsil
        bdmng LIKE rmmmb-bdmng,       "Reservierter Bestand
        bdmns LIKE rmmmb-bdmns,       "Geplante Zugänge (Sollr
        bsabr LIKE rmmmb-bsabr,       "Abrufe UL-Bestellungen
*       FAMNG LIKE RMMMB-FAMNG,       "FAUF-Menge
        klabs LIKE mard-klabs,        "L.Konsi. frei verwendbar
        kinsm LIKE mard-kinsm,        "L.Konsi. in Qualitätsprüfung
        keinm LIKE mard-keinm,        "L.Konsi. eingeschränkt verw.
        kspem LIKE mard-kspem,        "L.Konsi. gesperrt
*       CALAB LIKE MSCA-CALAB,        "K.A.Best. beim Lief. fr. verw
*       CAINS LIKE MSCA-CAINS,        "K.A.Best. beim Lief. QualPrf.
        kalab LIKE mska-kalab,        "K.Auftr.Best. frei verwendbar
        kains LIKE mska-kains,        "K.Auftr.Best. Qualitätsprüfg.
        kaspe LIKE mska-kaspe,       "K.Auftr.Best. Sperrbestand
        kaein LIKE mska-kaein,       "K.Auftr.Best. eing. verw.
        kulav LIKE msku-kulab,        "K.Leergut frei verwendbar
        kuinv LIKE msku-kuins,        "K.Leergut Qualitätsprüfung
        kueiv LIKE msku-kuein,        "K.Leergut eing. verw.
        kulaw LIKE msku-kulab,        "K.Konsign. frei verwendbar
        kuinw LIKE msku-kuins,        "K.Konsign. Qualitätsprüfung
        kueiw LIKE msku-kuein,        "K.Konsign. eing. verw.
        lblab LIKE mslb-lblab,        "L.Beistellung frei verwendbar
        lbins LIKE mslb-lbins,        "L.Beistellung Qualitätsprüfg.
        lbein LIKE mslb-lbein,        "L.Beistellung eing. verw.
*                                     "MTV = Mehrwegtransportverpackung
        mlabs LIKE mkol-slabs,        "MTV frei verwendbar
        minsm LIKE mkol-sinsm,        "MTV in Qualitätsprüfung
        meinm LIKE mkol-seinm,       "MTV eingeschränkt verw.
        mspem LIKE mkol-sspem,        "MTV gesperrt
*       PRLAB LIKE MSPR-PRLAB,       "Projektbest. frei verwendbar
*       PRINS LIKE MSPR-PRINS,        "Projektbest. Qualitätsprüfg.
*       PRSPE LIKE MSPR-PRSPE,        "Projektbest. Sperrbestand
*       PREIN LIKE MSPR-PREIN,        "Projektbest. eing. verwendb.
        glgmg LIKE marc-glgmg,        "Gebundene Leergutmenge
      END OF s_lbe.
END-ENHANCEMENT-SECTION.
TYPES: t_lbe   TYPE STANDARD TABLE OF s_lbe.
DATA: t_lbe    TYPE t_lbe.         "outtab for storage location level
DATA: s_lbe    TYPE s_lbe.
DATA: gt_lbe   TYPE t_lbe.         "(empty) outtab for first display
TYPES : t_cbe  TYPE STANDARD TABLE OF s_cbe.
DATA  : t_cbe  TYPE t_cbe,
        gt_cbe TYPE t_cbe,
        tt_cbe TYPE t_cbe,
        s_cbe  TYPE s_cbe,
        w_cbe  TYPE s_cbe.

DATA :
   cont      TYPE REF TO cl_gui_custom_container,
   sgt_cbe   TYPE dd02l-tabname VALUE 'SGT_ALV_CBE',
   sgt_wbe   TYPE dd02l-tabname VALUE 'SGT_ALV_WBE',
   sgt_lbe   TYPE dd02l-tabname VALUE 'SGT_ALV_LBE',
   fieldcat  TYPE lvc_t_fcat.

* thie table is needed for ALV if storage loc. level is chosen,
* and non cumul. stocks on site level are needed to get the right values
* on site level cumulated by ALV
TYPES: BEGIN OF s_w_lbe,
        matnr LIKE mara-matnr,        "Schlüssel - Material
*       BWGRP LIKE RWBWG-BWGRP,       "Schlüssel - Basiswerksgr
        werks LIKE mard-werks,        "Schlüssel - Werk
*       EX_LGORT like ex_lgort,       "expanded key - lgort (sl)
*       MEINH LIKE MARM-MEINH,        "Mengeneinheit
*       NAME1 LIKE MARCV-NAME1,       "text of node object
        umlme LIKE mard-umlme,        "Umlagerungsbestand Lagerort
        umlmc LIKE marc-umlmc,        "Umlagerungsbestand Werk
        trasf LIKE ekbe-wesbs,        "Transitbestand Buchungsk
        trame LIKE marc-trame,        "Transitbestand Werk
        wespb LIKE ekbe-wesbs,        "WE-Sperrbestand
        vbmna LIKE rmmmb-vbmna,        "Kundenanfragen
        vbmnb LIKE rmmmb-vbmnb,       "Angebote an Kunden
        vbmnc LIKE rmmmb-vbmnc,       "Kundenaufträge
        vbmne LIKE rmmmb-vbmne,       "Kundenlieferpläne
        vbmng LIKE rmmmb-vbmnb,       "Kundenkontrakte
        vbmni LIKE rmmmb-vbmni,       "Kostenlose Lieferung an
        omeng LIKE rmmmb-omeng,       "Lieferungen an Kunden
        menge LIKE ekpo-menge,        "Offener Bestellbestand
        mengk LIKE rmmmb-mengk,       "Offener Bestell. Konsil
        bdmng LIKE rmmmb-bdmng,       "Reservierter Bestand
        bdmns LIKE rmmmb-bdmns,       "Geplante Zugänge (Sollr
        bsabr LIKE rmmmb-bsabr,       "Abrufe UL-Bestellungen
        glgmg LIKE marc-glgmg,        "Gebundene Leergutmenge
      END OF s_w_lbe.

TYPES: t_w_lbe TYPE STANDARD TABLE OF s_w_lbe.
DATA: t_w_lbe TYPE t_w_lbe.         "outtab for storage location level
DATA: s_w_lbe TYPE s_w_lbe.

*Feldkatalog
DATA: gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat LIKE lvc_s_fcat.
* here are saved the hide informations, so it's possible to use the
* existing routines to display additional infos, variant matrix etc.
DATA: BEGIN OF t_zle OCCURS 0,
        matnr LIKE mara-matnr,         "Material
        bwgrp LIKE rwbwg-bwgrp,        "Basiswerksgruppe
        werks LIKE t001w-werks,        "Werk
        lgort LIKE mard-lgort,         "Lagerort
        lifnr LIKE mkol-lifnr,         "Lieferant
        kunnr LIKE msku-kunnr,         "Kunde
        vbeln LIKE mska-vbeln,         "Vertriebsbelegnummer
        posnr LIKE mska-posnr,         "Positionsnummer
*       ETENR LIKE MSKA-ETENR,        "Einteilungsnummer
        zeilen_kz(1),                  "zeilen-kennzeichen
        sond_kz(1),                    "Sonderbestandskennzeichen
        attyp LIKE mara-attyp,         "aktueller attyp
        sgt_scat LIKE mchb-sgt_scat,   "Stock Segment
        charg LIKE mchb-charg,         "Batch
        satnr LIKE mara-satnr,
      END OF t_zle.
DATA: BEGIN OF t_v_zle OCCURS 0,
        matnr LIKE mara-matnr,         "Material
        bwgrp LIKE rwbwg-bwgrp,        "Basiswerksgruppe
        werks LIKE t001w-werks,        "Werk
        lgort LIKE mard-lgort,         "Lagerort
        lifnr LIKE mkol-lifnr,         "Lieferant
        kunnr LIKE msku-kunnr,         "Kunde
        vbeln LIKE mska-vbeln,         "Vertriebsbelegnummer
        posnr LIKE mska-posnr,         "Positionsnummer
*       ETENR LIKE MSKA-ETENR,        "Einteilungsnummer
        zeilen_kz(1),                  "zeilen-kennzeichen
        sond_kz(1),                    "Sonderbestandskennzeichen
        attyp LIKE mara-attyp,        "aktueller attyp
        sgt_scat LIKE mchb-sgt_scat,
        charg LIKE mchb-charg,
        satnr LIKE mara-satnr,
      END OF t_v_zle.




*  additions for ALV-tree end tga >991009

*---- Lagerortbestände pro Material -----------------------------------*
DATA: BEGIN OF lbe OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE mard-werks,         "Schlüssel - Werk
        lgort LIKE mard-lgort,         "Schlüssel - Lagerort
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        lgpbe LIKE mard-lgpbe,         "Lagerplatzbeschreibung
        lvorm LIKE mard-lvorm,         "Loeschvormerkung
        labst TYPE f,                  "Frei verwendbarer Bestand
        umlme TYPE f,                  "Umlagerungsbestand Lagerort
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        retme TYPE f,                  "Retourenbestand
        vbmna TYPE f,                  "Kundenanfragen
        vbmnb TYPE f,                  "Angebote an Kunden
        vbmnc TYPE f,                  "Kundenaufträge
        vbmne TYPE f,                  "Kundenlieferpläne
        vbmng TYPE f,                  "Kundenkontrakte
        vbmni TYPE f,                  "Kostenlose Lieferung an Kund.
        omeng TYPE f,                  "Lieferungen an Kunden
        menge TYPE f,                  "Offener Bestellbestand
        mengk TYPE f,                  "Offener Bestell. Konsilief
        bdmng TYPE f,                  "Reservierter Bestand
        bdmns TYPE f,                  "Geplante Zugänge (Sollreserv
        klabs TYPE f,                  "L.Konsi. frei verwendbar
        kinsm TYPE f,                  "L.Konsi. in Qualitätsprüfung
        keinm TYPE f,                  "L.Konsi. eingeschränkt verw.
        kspem TYPE f,                  "L.Konsi. gesperrt
        kalab TYPE f,                  "K.Auftr.Best. frei verwendbar
        kains TYPE f,                  "K.Auftr.Best. Qualitätsprüfg.
        kaspe TYPE f,                  "K.Auftr.Best. Sperrbestand
        kaein TYPE f,                  "K.Auftr.Best. eing. verw.
                                       "MTV = Mehrwegtransportverpackung
        mlabs TYPE f,                  "MTV frei verwendbar
        minsm TYPE f,                  "MTV in Qualitätsprüfung
        meinm TYPE f,                  "MTV eingeschränkt verw.
        mspem TYPE f,                  "MTV gesperrt
        prlab TYPE f,                  "Projektbest. frei verwendbar
        prins TYPE f,                  "Projektbest. Qualitätsprüfg.
        prspe TYPE f,                  "Projektbest. Sperrbestand
        prein TYPE f.                  "Projektbest. eing. verwendb.
*<<<        hier später weitere Sonderbestandsfelder einfügen
    INCLUDE TYPE ext_chars .
    DATA  END OF lbe.

*---- Kundenauftragsbestände pro Material -----------------------------*
DATA: BEGIN OF ebs OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE mska-werks,         "Schlüssel - Werk
        lgort LIKE mska-lgort,         "Schlüssel - Lagerort
*       CHARG LIKE MSKA-CHARG,        "Schlüssel - Chargennummer
        vbeln LIKE mska-vbeln,         "Schlüssel - VertiebsbelegNr.
        posnr LIKE mska-posnr,         "Schlüssel - PositionsNr.
*       ETENR LIKE MSKA-ETENR,        "Schlüssel - EinteilungsNr.
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        speme TYPE f,                  "gesperrter Bestand
        einme TYPE f,                  "eingeschraenkt verwendbar
      END OF ebs.

*---- Lieferantenkonsibestände pro Material ---------------------------*
DATA: BEGIN OF kbe OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE mkol-werks,         "Schlüssel - Werk
        lgort LIKE mkol-lgort,         "Schlüssel - Lagerort
*       CHARG LIKE MKOL-CHARG,        "Schlüssel - Chargennummer
        lifnr LIKE mkol-lifnr,         "Schlüssel - Lieferantennr.
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        lvorm LIKE mkol-lvorm,         "Loeschvormerkung
      END OF kbe.

*---- Lieferanten-MTV pro Material ------------------------------------*
DATA: BEGIN OF mps OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE mkol-werks,         "Schlüssel - Werk
        lgort LIKE mkol-lgort,         "Schlüssel - Lagerort
*       CHARG LIKE MKOL-CHARG,        "Schlüssel - Chargennummer
        lifnr LIKE mkol-lifnr,         "Schlüssel - Lieferantennr
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        speme TYPE f,                  "gesperrter Bestand
        lvorm LIKE mkol-lvorm,         "Loeschvormerkung
      END OF mps.

*---- Lieferantenbeistellung pro Material -----------------------------*
DATA: BEGIN OF obs OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE mslb-werks,         "Schlüssel - Werk
        CHARG LIKE MSLB-CHARG,        "Schlüssel - Chargennummer
        lifnr LIKE mslb-lifnr,         "Schlüssel - Lieferantennr
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        sgt_scat TYPE sgt_scat,
      END OF obs.

*---- Lieferantenbeistellung pro Material (Summen) --------------------*
*ATA: BEGIN OF OSU OCCURS 0, ????entfällt, da jetzt = OBS
*           WERKS LIKE MSLB-WERKS,        "Schluessel - Werk
*           LIFNR LIKE MSLB-LIFNR,        "Schluessel - Chargennummer
*           LABST TYPE F,                 "Gesamtbestand
*           INSME TYPE F,                 "Qualitaetskontrollbestand
*           EINME TYPE F,                 "eingeschraenkt verwendbar
*     END OF OSU.

*---- Kundenleergut pro Material --------------------------------------*
DATA: BEGIN OF vbs OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE msku-werks,         "Schlüssel - Werk
*       CHARG LIKE MSKU-CHARG,        "Schlüssel - Chargennummer
        kunnr LIKE msku-kunnr,         "Schlüssel - Kundennummer
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
      END OF vbs.

*---- Kundenleergut pro Material (Summen) -----------------------------*
*ATA: BEGIN OF VSU OCCURS 200,         ????ENTFäLLT, DA JETZT = VBS
*           WERKS LIKE MSKU-WERKS,        "Schluessel - Werk
*           KUNNR LIKE MSKU-KUNNR,        "Schluessel - Kundennummer
*           LABST TYPE F,                 "Gesamtbestand
*           INSME TYPE F,                 "Qualitaetskontrollbestand
*           EINME TYPE F,                 "eingeschraenkt verwendbar
*     END OF VSU.

*---- Kundenkonsignation pro Material ---------------------------------*
DATA: BEGIN OF wbs OCCURS 0,                                "
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE msku-werks,         "Schlüssel - Werk
*       CHARG LIKE MSKU-CHARG,        "Schlüssel - Chargennummer
        kunnr LIKE msku-kunnr,         "Schlüssel - Kundennummer
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
      END OF wbs.

DATA: BEGIN OF wbs_seg OCCURS 0,                                "
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE msku-werks,         "Schlüssel - Werk
       CHARG  LIKE MSKU-CHARG,         "Schlüssel - Chargennummer
        kunnr LIKE msku-kunnr,         "Schlüssel - Kundennummer
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        einme TYPE f,                  "eingeschraenkt verwendbar
        sgt_scat TYPE sgt_scat,
      END OF wbs_seg.

*---- Kundenkonsignation pro Material (Summen) ------------------------*
*ATA: BEGIN OF WSU OCCURS 200,      ????ENTFäLLT, DA JETZT = VBS
*           WERKS LIKE MSKU-WERKS,        "Schluessel - Werk
*           KUNNR LIKE MSKU-KUNNR,        "Schluessel - Kundennummer
*           LABST  TYPE F,            "Gesamtbestand
*           INSME  TYPE F,            "Qualitaetskontrollbestand
*           EINME  TYPE F,            "eingeschraenkt verwendbar
*     END OF WSU.

*---- Kundenauftragsbestand beim Lieferanten pro Material -------------*
DATA: BEGIN OF oeb OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE msca-werks,         "Schlüssel - Werk
*       CHARG LIKE MSCA-CHARG,        "Schlüssel - Chargennummer
        lifnr LIKE msca-lifnr,         "Schlüssel - Lieferantennr
        vbeln LIKE msca-vbeln,         "Schlüssel - VertiebsbelegNr.
        posnr LIKE msca-posnr,         "Schlüssel - PositionsNr.
*       ETENR LIKE MSCA-ETENR,        "Schlüssel - EinteilungsNr.
        satnr LIKE mara-satnr,         "Verweis auf zugeordn. SA
        labst TYPE f,                  "Gesamtbestand
        insme TYPE f,                  "Qualitaetskontrollbestand
        speme TYPE f,                  "gesperrter Bestand
      END OF oeb.

*????für Handel uninteressant!
*ATA: BEGIN OF PBE OCCURS 200,         "Projektbestand
*           WERKS LIKE MSPR-WERKS,        "Schluessel - Werk
*           LGORT LIKE MSPR-LGORT,        "Schluessel - Lagerort
*           CHARG LIKE MSPR-CHARG,        "Schluessel - Chargennummer
*           PSPNR LIKE MSPR-PSPNR,        "Schluessel-Kontierg.PSP-Elem.
*           LABST TYPE F,                 "Gesamtbestand
*           INSME TYPE F,                 "Qualitaetskontrollbestand
*           EINME TYPE F,                 "eingeschraenkt verwendbar
*           SPEME TYPE F,                 "gesperrter Bestand
*     END OF PBE.

*---- Wertmäßiger Bestand pro Material --------------------------------*
DATA: BEGIN OF ek_vk OCCURS 0,
        matnr LIKE mara-matnr,         "Schlüssel - Material
        werks LIKE marc-werks,         "Schlüssel - Werk
        ekwer LIKE mbew-salk3,       "Wertm. Bestand (EK-seitig) o. MwSt
        vkwer LIKE mbew-vksal,       "Wertm. Bestand (VK-seitig) m. MwSt
      END   OF ek_vk.
*TGA/4.6 Erweiterungen Lot (START)
DATA: BEGIN OF sbe OCCURS 0,
        comp_matnr LIKE mara-matnr,         "Key - component
        stru_matnr LIKE mara-matnr,         "Key - Struc-material
        labst TYPE f,
      END   OF sbe.
*TGA/4.6 Erweiterungen Lot (END)
*<<< hier später weitere Bestandstabellen ergänzen
*TGA/4.6 Erweiterungen Lot (START)
*----- Interne tabellen für schnittstelle bestandsdaten_lesen ---------*
DATA: BEGIN OF prt_mbe OCCURS 0.
        INCLUDE STRUCTURE mbe.
DATA: END   OF prt_mbe.

DATA: BEGIN OF prt_gbe OCCURS 0.
        INCLUDE STRUCTURE gbe.
DATA: END   OF prt_gbe.

DATA: BEGIN OF prt_wbe OCCURS 0.
        INCLUDE STRUCTURE wbe.
DATA: END   OF prt_wbe.

DATA: BEGIN OF prt_lbe OCCURS 0.
        INCLUDE STRUCTURE lbe.
DATA: END   OF prt_lbe.

DATA: BEGIN OF prt_cbe OCCURS 0.
        INCLUDE STRUCTURE cbe.
DATA: END   OF prt_cbe.

*DATA: prt_cbe TYPE cbe OCCURS 0.

DATA: BEGIN OF prt_ebs OCCURS 0.
        INCLUDE STRUCTURE ebs.
DATA: END   OF prt_ebs.

DATA: BEGIN OF prt_kbe OCCURS 0.
        INCLUDE STRUCTURE kbe.
DATA: END   OF prt_kbe.

DATA: BEGIN OF prt_mps OCCURS 0.
        INCLUDE STRUCTURE mps.
DATA: END   OF prt_mps.

DATA: BEGIN OF prt_obs OCCURS 0.
        INCLUDE STRUCTURE obs.
DATA: END   OF prt_obs.

DATA: BEGIN OF obc OCCURS 0.
       INCLUDE STRUCTURE obs.
DATA: END OF obc.

DATA: BEGIN OF prt_vbs OCCURS 0.
        INCLUDE STRUCTURE vbs.
DATA: END   OF prt_vbs.

DATA: BEGIN OF prt_wbs OCCURS 0.
        INCLUDE STRUCTURE wbs.
DATA: END   OF prt_wbs.

DATA: BEGIN OF prt_wbs_seg OCCURS 0.
        INCLUDE STRUCTURE wbs_seg.
DATA: END   OF prt_wbs_seg.

DATA: BEGIN OF prt_oeb OCCURS 0.
        INCLUDE STRUCTURE oeb.
DATA: END   OF prt_oeb.

DATA: BEGIN OF prt_ek_vk OCCURS 0.
        INCLUDE STRUCTURE ek_vk.
DATA: END   OF prt_ek_vk.

*TGA/4.6 Erweiterungen Lot (END)
*---- Summation Sonderbestände ----------------------------------------*
DATA: BEGIN OF sum,
        labst TYPE f,                  "Frei verwendbar
        insme TYPE f,                  "in Qualitätsprüfung
        einme TYPE f,                  "Eingeschränkt verwendbar
        speme TYPE f,                  "Gesperrt
      END   OF sum.

*---- Summation der wertmäßigen Bestände pro Währung ------------------*
DATA: BEGIN OF ekvk_sum OCCURS 10,
        waers LIKE t001-waers,         "Währung
        lbkum LIKE mbew-lbkum,         "Bewertete Bestandsmenge
        ekwer LIKE mbew-salk3,       "Wertm. Bestand (EK-seitig) o. MwSt
        vkwer LIKE mbew-vksal,       "Wertm. Bestand (VK-seitig) m. MwSt
      END   OF ekvk_sum.

*---- Offene Bestellungen aus den Belegdaten --------------------------*
DATA: BEGIN OF xtab OCCURS 0,
        werks LIKE ekpo-werks,
        lgort LIKE ekpo-lgort,
        matnr LIKE ekpo-matnr,
        menge LIKE ekpo-menge,
        mengk LIKE ekpo-menge,
      END OF xtab.

*---- Zu-/Abgangsreservierungen aus den Belegdaten --------------------*
DATA: BEGIN OF xtab1 OCCURS 0,
        werks LIKE resb-werks,
        lgort LIKE resb-lgort,
        charg LIKE resb-charg,
        matnr LIKE resb-matnr,
        bdmng LIKE resb-bdmng,
        bdmns LIKE resb-bdmng,
      END OF xtab1.

*---- WE-Sperrbestände aus den Belegdaten -----------------------------*
DATA: BEGIN OF xtab2 OCCURS 0,
         werks LIKE ekpo-werks,
         matnr LIKE ekpo-matnr,
         ebeln LIKE ekpo-ebeln,
         ebelp LIKE ekpo-ebelp,
         wesbs LIKE ekbe-wesbs,
       END OF xtab2.

*---- Vertriebsbedarfe aus den Belegdaten -----------------------------*
DATA: BEGIN OF xtab4 OCCURS 0,
        matnr LIKE vbbe-matnr,
        werks LIKE vbbe-werks,
        lgort LIKE vbbe-lgort,
        charg LIKE vbbe-charg,
        vbmna LIKE vbbe-omeng,         "offene Kundenanfragemenge
        vbmnb LIKE vbbe-omeng,         "offene Kundenangebotsmenge
        vbmnc LIKE vbbe-omeng,         "offene Kundenauftragsmenge
        vbmne LIKE vbbe-omeng,         "offene Kundenlieferplanmenge
        vbmng LIKE vbbe-omeng,         "offene Kundenkontraktmenge
        vbmni LIKE vbbe-omeng,         "offene Menge kostenloser Liefer.
        omeng LIKE vbbe-omeng,         "offene Liefermenge
      END OF xtab4.

*---- Allg. verwendbare Tabelle für Bestände auf Werksebene aus -------*
*---- Belegdaten                                                -------*
DATA: BEGIN OF xtab5 OCCURS 0.
        INCLUDE STRUCTURE werks_quan.
DATA: END OF xtab5.

*---- Cross-Company-Umlagerungsbestände (Transitbestand auf Buchungs- -*
*---- kreisebene) aus Belegdaten                                      -*
DATA: BEGIN OF xtab6 OCCURS 0,
        werks LIKE ekpo-werks,
        matnr LIKE ekpo-matnr,
        menge LIKE ekbe-wesbs,
      END OF xtab6.

*---- CBI/WWW: zusätzliche Felder fürs Web-Reporting
DATA: p_submit_info LIKE rssubinfo.    " Laufzeitinfo
DATA: BEGIN OF t_fcodes_www OCCURS 5,  " FCodes, die im Web nicht
        fcode LIKE rsmpe-func,         " funktionieren
      END OF t_fcodes_www.

* additions for ALV-tree start tga >991009
* common classes********************************************************
DATA: mattree1 TYPE REF TO cl_gui_alv_tree,  "tree for total overview
      mattree2 TYPE REF TO cl_gui_alv_tree,  "tree for variants overview
      mattree  TYPE REF TO cl_gui_alv_grid.  "tree for alv overview
* for buttons in the alv-tree-toolbar
DATA: ex_toolbar TYPE REF TO cl_gui_toolbar,
      ex_v_toolbar TYPE REF TO cl_gui_toolbar.

CLASS cl_gui_column_tree DEFINITION LOAD.
CLASS cl_gui_cfw DEFINITION LOAD.
CLASS cl_alv_tree_base DEFINITION LOAD.
CLASS lcl_toolbar_event_receiver DEFINITION DEFERRED.
* own classes for event handling
DATA toolbar_event_receiver TYPE REF TO lcl_toolbar_event_receiver.
DATA v_toolbar_event_receiver TYPE REF TO lcl_toolbar_event_receiver.

* additions for ALV-tree end   tga >991009
* tga / accessibility
DATA: sav_ok LIKE sy-ucomm.

* tga / acc retail
TYPE-POOLS slis.
* detailed for single article site group site stor loc
DATA: gt_fieldcat_mbwl  TYPE slis_t_fieldcat_alv.
DATA: gt_einzelanz_mbwl LIKE STANDARD TABLE OF rmmmbestn_popup.
* single view vendor ... vendor consi, MehrwegtransportVerpack
DATA: gt_einzelanz_lief
      LIKE STANDARD TABLE OF rmmmbestn_popup_sb_lief,
      wa_einzelanz_lief LIKE LINE OF gt_einzelanz_lief.
* single view emptiees customer, consi customer
DATA: gt_einzelanz_kd
      LIKE STANDARD TABLE OF rmmmbestn_popup_sb_kd,
      wa_einzelanz_kd LIKE LINE OF gt_einzelanz_kd.
* Kundenauftragsbestand
DATA: gt_einzelanz_auf
      LIKE STANDARD TABLE OF rmmmbestn_popup_sb_aufbs,
      wa_einzelanz_auf LIKE LINE OF gt_einzelanz_auf.
* units of measure
DATA: gt_allowed_uom LIKE STANDARD TABLE OF rmmmbestn_popup_metexte.

*  structure for component stocks COMP_MAT_STOCK
DATA: gt_fieldcat_comp  TYPE slis_t_fieldcat_alv.

DATA: gt_comp_mat_stock
      LIKE STANDARD TABLE OF comp_mat_stock,
      wa_comp_mat_stock LIKE LINE OF gt_comp_mat_stock.

*  alv table
DATA: gr_table     TYPE REF TO cl_salv_table.

DATA: ok_code   TYPE fcode.  "checkman


* global type to avoid the INTO CORRESPONDING FIELDS OF TABLE pattern
TYPES: BEGIN OF tt_mkol,
  matnr TYPE matnr,
  werks TYPE werks_d,
  lgort TYPE lgort_d,
  lifnr TYPE lifnr,
  slabs TYPE klabs,
  sinsm TYPE kinsm,
  seinm TYPE keinm,
  sspem TYPE kspem,
END OF tt_mkol.

TYPES: BEGIN OF tt_mska,
  matnr TYPE matnr,
  werks TYPE werks_d,
  lgort TYPE lgort_d,
  vbeln TYPE mska-vbeln,
  posnr TYPE mska-posnr,
  kalab TYPE labst,
  kains TYPE insme,
  kaspe TYPE speme,
  kaein TYPE einme,
END OF tt_mska.

TYPES: BEGIN OF tt_mslb,
  matnr TYPE matnr,
  werks TYPE werks_d,
  lifnr TYPE lifnr,
  lblab TYPE labst,
  lbins TYPE insme,
  lbein TYPE einme,
END OF tt_mslb.

TYPES: BEGIN OF tt_msku,
  matnr TYPE matnr,
  werks TYPE werks_d,
  kunnr TYPE kunnr,
  sobkz TYPE sobkz,
  kulab TYPE labst,
  kuins TYPE insme,
  kuein TYPE einme,
END OF tt_msku.

TYPES: BEGIN OF tt_mslb_seg,
        matnr TYPE matnr,
        werks TYPE werks_d,
        charg TYPE charg_d,
        lifnr TYPE lifnr,
        lblab TYPE labst,
        lbins TYPE insme,
        lbein TYPE einme,
        sgt_scat TYPE sgt_scat,
       END OF tt_mslb_seg.

TYPES: BEGIN OF tt_mkol_seg,
        matnr TYPE matnr,
        werks TYPE werks_d,
        lgort TYPE lgort_d,
        charg TYPE charg_d,
        lifnr TYPE lifnr,
        slabs TYPE klabs,
        sinsm TYPE kinsm,
        seinm TYPE keinm,
        sspem TYPE kspem,
        sgt_scat TYPE sgt_scat.
        INCLUDE TYPE ext_seasons.
*        INCLUDE TYPE EXT_CHARS.
       TYPES END OF tt_mkol_seg.

DATA:
  gv_parva   TYPE xuvalue,
  gv_tree    TYPE c.

** start_EoP_adaptation
** Read back internal guideline note 1998910 before starting delivering a correction
DATA: gv_data_blocked TYPE boole_d,
      gv_auditor      TYPE boole_d.
** end_EoP_adaptation
