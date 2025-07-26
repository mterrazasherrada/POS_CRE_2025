*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YSD_V006_RCONDIC................................*
TABLES: YSD_V006_RCONDIC, *YSD_V006_RCONDIC. "view work areas
CONTROLS: TCTRL_YSD_V006_RCONDIC
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YSD_V006_RCONDIC. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YSD_V006_RCONDIC.
* Table for entries selected to show on screen
DATA: BEGIN OF YSD_V006_RCONDIC_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YSD_V006_RCONDIC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V006_RCONDIC_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YSD_V006_RCONDIC_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YSD_V006_RCONDIC.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YSD_V006_RCONDIC_TOTAL.

*.........table declarations:.................................*
TABLES: YSD_T006_RCONDIC               .
