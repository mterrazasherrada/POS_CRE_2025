*----------------------------------------------------------------------*
*   INCLUDE RWBE1SEL                                                   *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*  Design des Einstiegsbildes (Selektionsbildschirm)                   *
*----------------------------------------------------------------------*

*---- Teilbild "Materialselektion" ------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-002.
* PARAMETERS:     P_MATKL LIKE KLAH-CLASS   "//JH zu 1.2A1
PARAMETERS:     p_matkl LIKE rwgrp-wagrp
                        MEMORY ID mkl.
SELECTION-SCREEN COMMENT 54(26) p_matklt FOR FIELD p_matkl.
SELECT-OPTIONS: s_matnr FOR mara-matnr
                        MEMORY ID mat
                        MATCHCODE OBJECT mat1.
PARAMETER      p_scat LIKE mchb-sgt_scat MODIF ID pgr.
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN PUSHBUTTON 62(24) button_t USER-COMMAND merk.
SELECTION-SCREEN END OF BLOCK b1.
*----------BLOCK FOR  TABSTRIPS----------------------------------------*
SELECTION-SCREEN BEGIN OF TABBED BLOCK sel_disp FOR 25 LINES.
SELECTION-SCREEN TAB (20) sel_cri       USER-COMMAND sel_cri
                 DEFAULT SCREEN 1010.
SELECTION-SCREEN TAB (20) dis_list      USER-COMMAND dis_list
                 DEFAULT SCREEN 1020.
SELECTION-SCREEN END OF BLOCK sel_disp.
*definition of first subscreen
SELECTION-SCREEN BEGIN OF SCREEN 1010 AS SUBSCREEN.

*---- Teilbild "Materialfilter" ---------------------------------------*
 SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-005.
 PARAMETERS:     p_lifnr LIKE lfa1-lifnr
                         MEMORY ID lif
                         MATCHCODE OBJECT kred.
 SELECTION-SCREEN COMMENT 46(34) p_lifnrt FOR FIELD p_lifnr.
 PARAMETERS:     p_ltsnr LIKE wyt1t-ltsnr
                         MEMORY ID lts.
 SELECTION-SCREEN COMMENT 46(20) p_ltsnrt FOR FIELD p_ltsnr.
 PARAMETERS:     p_saiso LIKE mara-saiso.
 SELECTION-SCREEN COMMENT 46(20) p_saisot FOR FIELD p_saiso.
 PARAMETERS:     p_saisj LIKE mara-saisj.

 PARAMETERS:     p_plgtp LIKE mara-plgtp.
 SELECTION-SCREEN COMMENT 46(20) p_plgtpt FOR FIELD p_plgtp.

 PARAMETERS:     p_FSH_SY  TYPE FSH_SEASONS_MAT-FSH_SEASON_YEAR
                                                   MEMORY ID sey
                                                   MODIF ID fsh.
 SELECTION-SCREEN COMMENT 46(20) p_fsh_yt FOR FIELD p_fsh_sy MODIF ID fsh.
 PARAMETERS:     p_FSH_S TYPE FSH_SEASONS_MAT-FSH_SEASON
                                                  MEMORY ID sea
                                                  MODIF ID fsh.
 SELECTION-SCREEN COMMENT 46(20) p_fsh_ST FOR FIELD p_fsh_S MODIF ID fsh .
 PARAMETERS:     p_FSH_C TYPE FSH_SEASONS_MAT-FSH_COLLECTION
                                                  MEMORY ID sec
                                                  MODIF ID fsh.
 SELECTION-SCREEN COMMENT 46(20) p_fsh_CT FOR FIELD p_fsh_C MODIF ID fsh.
 PARAMETERS:     p_FSH_T TYPE FSH_SEASONS_MAT-FSH_THEME
                                                  MEMORY ID set
                                                  MODIF ID fsh.
 SELECTION-SCREEN COMMENT 46(20) p_fsh_TT FOR FIELD p_fsh_T MODIF ID fsh .
 SELECTION-SCREEN END OF BLOCK b2.

*---- Teilbild "Werksselektion" ---------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-001.
* PARAMETERS:     P_WKGRP LIKE KLAH-CLASS      "//JH zu 1.2A1
*JH/1.2B3/16.12.97/int.Meld.3844369 (Anfang)
* PARAMETERS:     P_WKGRP LIKE RWGRP-WKGRP
*                         MEMORY ID KLA.
PARAMETERS:     p_wkgrp LIKE rwgrp-wkgrp.
*JH/1.2B3/16.12.97/int.Meld.3844369 (Anfang)
SELECTION-SCREEN COMMENT 54(26) p_wkgrpt FOR FIELD p_wkgrp.
PARAMETERS:     p_vkorg LIKE tvkwz-vkorg
                        MEMORY ID vko.
SELECTION-SCREEN COMMENT 54(26) p_vkorgt FOR FIELD p_vkorg.
PARAMETERS:     p_vtweg LIKE tvkwz-vtweg
                        MEMORY ID vtw.
SELECTION-SCREEN COMMENT 54(26) p_vtwegt FOR FIELD p_vtweg.
SELECT-OPTIONS: s_werks FOR marc-werks
                        MATCHCODE OBJECT betr
                        MEMORY ID wrk.
SELECTION-SCREEN END OF BLOCK b3.

*---- Teilbild "Bestandsartenselektion" -------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-067.
PARAMETERS: p_kzlso LIKE rmmmb-kzlso
                    DEFAULT ' '.
PARAMETERS: p_kzlon LIKE rmmmb-kzlon
                    DEFAULT ' '.
SELECTION-SCREEN END OF BLOCK b4.
SELECTION-SCREEN END OF SCREEN 1010.   "end of first subscreen
*definition of second subscreen of tabstrip
SELECTION-SCREEN BEGIN OF SCREEN 1020 AS SUBSCREEN.
*---- Teilbild "Listdarstellung" --------------------------------------*
*SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-003.
* SELECT-OPTIONS: S_SOBKZ FOR MSKU-SOBKZ. //JH 09.09.96 neues Daten-
*                                         //element wg. umpaßender Doku
*-Params for display as ALVTree or classic report // tga 11.11.99 start
SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-104.
SELECTION-SCREEN BEGIN OF LINE.
 PARAMETERS: p_kzvstc RADIOBUTTON GROUP ANZ USER-COMMAND switch.
 SELECTION-SCREEN COMMENT  3(30) TEXT-103
                                 FOR FIELD p_kzvstc.  "classic List
SELECTION-SCREEN END OF LINE.
 PARAMETERS: p_vernu LIKE t136-vernu
                     MEMORY ID vnr
                     OBLIGATORY.
SELECTION-SCREEN COMMENT 38(20) p_vernut FOR FIELD p_vernu.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF LINE.
 PARAMETERS: p_kzvst0 RADIOBUTTON GROUP ANZ DEFAULT 'X'.
 SELECTION-SCREEN COMMENT  3(30) TEXT-102
                                 FOR FIELD p_kzvst0.  " ALV tree
SELECTION-SCREEN END OF LINE.
 PARAMETERS: p_alvvar LIKE disvariant-variant.
 SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF LINE .
 PARAMETERS : p_kzalv  RADIOBUTTON GROUP ANZ.
 SELECTION-SCREEN COMMENT  3(30) TEXT-117
                                 FOR FIELD p_kzalv.
 SELECTION-SCREEN END OF LINE .
SELECTION-SCREEN END OF BLOCK B6.
*SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS: s_sobkz FOR rmmmb-sel_sobkz.
 SELECTION-SCREEN SKIP 1.
*PARAMETERS: p_vernu LIKE t136-vernu
*                    MEMORY ID vnr
*                    OBLIGATORY.
*SELECTION-SCREEN COMMENT 38(20) p_vernut FOR FIELD p_vernu.
PARAMETERS: p_kznul LIKE rmmmb-kznbw
                    DEFAULT 'X',
*-Parameter for display units of measure as customized // tga 11.06.99
             p_kzngc LIKE rmmmb-kzngc DEFAULT space.  " // tga 11.06.99
*-Params for display as ALVTree or classic report // tga 11.11.99 end
  SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN COMMENT /1(30) text-004.
PARAMETERS: p_kzbwg LIKE rmmmb-kzbwg   "Anmerkung: Da die zugeordnete
                    DEFAULT 'X',       "Domäne nur die Festwerte ' '
            p_kzwer LIKE rmmmb-kzwer   "und 'X' umfaßt, wird auf dem
                    DEFAULT 'X',       "Selektionsbildschirm automat.
            p_kzlgo LIKE rmmmb-kzlgo   "eine Checkbox generiert!
                    DEFAULT ' ',
            p_kzson LIKE rmmmb-kzson
                    DEFAULT ' ',
            p_chrg  LIKE rmmmb-kzcha
                    DEFAULT 'X'  USER-COMMAND c1,
            p_kzcha RADIOBUTTON GROUP g1 DEFAULT 'X',
            p_kzseg RADIOBUTTON GROUP g1,
            p_kzsea RADIOBUTTON GROUP g1 .

*SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN END OF SCREEN 1020.

*---- Parameter ohne Anzeigefunktion                              -----*
*---- (nur Übergabefunktion bei neuem Programmaufruf über SUBMIT) -----*
PARAMETERS: p_meinh LIKE rmmme-meinh   "z.B. Funktion 'Neue Selektion'
                    NO-DISPLAY,
            p_field(20) TYPE c         "bei PERFORM NEUSTART_FEHLER
                    NO-DISPLAY,        "wird im Fehlerfall das Feld
                                       "übergeben, auf dem der Cursor
                                       "stehen soll
*//JH 19.09.96 zu 1.2A1 -> Int.Pr. 208090
*             P_SUBMIT(1) TYPE C
            p_recall(1) TYPE c         "Wdhl. Programmaufruf wg. Fehler
                    NO-DISPLAY,        "oder Fnk. 'Neue Selektion'
            p_mcall(1)  TYPE c         "Aufruf der TA aus Bereichsmenü
                    NO-DISPLAY.        "-> vermerken, denn bei wdhl.
                                       "Aufruf d. Reports nach einem
                                       "Fehler oder bei der Fnk. 'Neue
                                       "Selektion' wird SY-CALLD umge-
                                       "setzt

* EhP2: Invisible Parameter. Not switched because it is invisible anyway.
*       This allows to avoid an enhancement section in the report call.
parameters p_iltest type c
* rwbe will be used as test-screen for class inventoty_lookup
           DEFAULT ' '
           NO-DISPLAY.
