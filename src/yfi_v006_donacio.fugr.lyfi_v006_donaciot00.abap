*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V006_DONACIO................................*
TABLES: YFI_V006_DONACIO, *YFI_V006_DONACIO. "view work areas
CONTROLS: TCTRL_YFI_V006_DONACIO
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V006_DONACIO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V006_DONACIO.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V006_DONACIO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V006_DONACIO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V006_DONACIO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V006_DONACIO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V006_DONACIO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V006_DONACIO_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T006_DONACIO               .
