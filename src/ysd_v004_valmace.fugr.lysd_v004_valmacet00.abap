*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V004_VALMACE................................*
TABLES: YSD_V004_VALMACE, *YSD_V004_VALMACE. "view work areas
CONTROLS: TCTRL_YSD_V004_VALMACE
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V004_VALMACE. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V004_VALMACE.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V004_VALMACE_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V004_VALMACE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V004_VALMACE_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V004_VALMACE_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V004_VALMACE.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V004_VALMACE_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T004_VALMACE               .
