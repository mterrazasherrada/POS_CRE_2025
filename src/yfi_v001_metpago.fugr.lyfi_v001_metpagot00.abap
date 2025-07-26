*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V001_METPAGO................................*
TABLES: YFI_V001_METPAGO, *YFI_V001_METPAGO. "view work areas
CONTROLS: TCTRL_YFI_V001_METPAGO
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V001_METPAGO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V001_METPAGO.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V001_METPAGO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V001_METPAGO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V001_METPAGO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V001_METPAGO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V001_METPAGO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V001_METPAGO_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T001_METPAGO               .
