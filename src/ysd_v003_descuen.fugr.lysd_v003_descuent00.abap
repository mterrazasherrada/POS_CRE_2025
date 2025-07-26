*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V003_DESCUEN................................*
TABLES: YSD_V003_DESCUEN, *YSD_V003_DESCUEN. "view work areas
CONTROLS: TCTRL_YSD_V003_DESCUEN
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V003_DESCUEN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V003_DESCUEN.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V003_DESCUEN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V003_DESCUEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V003_DESCUEN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V003_DESCUEN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V003_DESCUEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V003_DESCUEN_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T003_DESCUEN               .
