*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V002_TIPOPOS................................*
TABLES: YSD_V002_TIPOPOS, *YSD_V002_TIPOPOS. "view work areas
CONTROLS: TCTRL_YSD_V002_TIPOPOS
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V002_TIPOPOS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V002_TIPOPOS.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V002_TIPOPOS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V002_TIPOPOS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V002_TIPOPOS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V002_TIPOPOS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V002_TIPOPOS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V002_TIPOPOS_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T002_TIPOPOS               .
