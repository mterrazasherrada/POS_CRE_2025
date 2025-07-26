*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V005_CTAPASA................................*
TABLES: YFI_V005_CTAPASA, *YFI_V005_CTAPASA. "view work areas
CONTROLS: TCTRL_YFI_V005_CTAPASA
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V005_CTAPASA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V005_CTAPASA.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V005_CTAPASA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V005_CTAPASA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V005_CTAPASA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V005_CTAPASA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V005_CTAPASA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V005_CTAPASA_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T005_CTAPASA               .
