*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V005_TOLERAN................................*
TABLES: YSD_V005_TOLERAN, *YSD_V005_TOLERAN. "view work areas
CONTROLS: TCTRL_YSD_V005_TOLERAN
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V005_TOLERAN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V005_TOLERAN.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V005_TOLERAN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V005_TOLERAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V005_TOLERAN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V005_TOLERAN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V005_TOLERAN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V005_TOLERAN_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T005_TOLERAN               .
