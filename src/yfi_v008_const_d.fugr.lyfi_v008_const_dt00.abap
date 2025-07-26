*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V008_CONST_D................................*
TABLES: YFI_V008_CONST_D, *YFI_V008_CONST_D. "view work areas
CONTROLS: TCTRL_YFI_V008_CONST_D
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V008_CONST_D. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V008_CONST_D.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V008_CONST_D_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V008_CONST_D.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V008_CONST_D_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V008_CONST_D_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V008_CONST_D.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V008_CONST_D_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T008_CONST_D               .
