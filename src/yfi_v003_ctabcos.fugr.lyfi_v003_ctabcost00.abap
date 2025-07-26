*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V003_CTABCOS................................*
TABLES: YFI_V003_CTABCOS, *YFI_V003_CTABCOS. "view work areas
CONTROLS: TCTRL_YFI_V003_CTABCOS
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V003_CTABCOS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V003_CTABCOS.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V003_CTABCOS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V003_CTABCOS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V003_CTABCOS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V003_CTABCOS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V003_CTABCOS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V003_CTABCOS_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T003_CTABCOS               .
