*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V001_PARAMET................................*
TABLES: YSD_V001_PARAMET, *YSD_V001_PARAMET. "view work areas
CONTROLS: TCTRL_YSD_V001_PARAMET
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V001_PARAMET. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V001_PARAMET.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V001_PARAMET_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V001_PARAMET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V001_PARAMET_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V001_PARAMET_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V001_PARAMET.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V001_PARAMET_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T001_PARAMET               .
