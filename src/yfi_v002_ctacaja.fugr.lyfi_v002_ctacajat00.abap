*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V002_CTACAJA................................*
TABLES: YFI_V002_CTACAJA, *YFI_V002_CTACAJA. "view work areas
CONTROLS: TCTRL_YFI_V002_CTACAJA
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V002_CTACAJA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V002_CTACAJA.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V002_CTACAJA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V002_CTACAJA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V002_CTACAJA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V002_CTACAJA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V002_CTACAJA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V002_CTACAJA_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T002_CTACAJA               .
