*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: YFI_V007_CONST_H................................*
TABLES: YFI_V007_CONST_H, *YFI_V007_CONST_H. "view work areas
CONTROLS: TCTRL_YFI_V007_CONST_H
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_YFI_V007_CONST_H. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_YFI_V007_CONST_H.
* Table for entries selected to show on screen
DATA: BEGIN OF YFI_V007_CONST_H_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE YFI_V007_CONST_H.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V007_CONST_H_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF YFI_V007_CONST_H_TOTAL OCCURS 0010.
INCLUDE STRUCTURE YFI_V007_CONST_H.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF YFI_V007_CONST_H_TOTAL.

*.........table declarations:.................................*
TABLES: YFI_T007_CONST_H               .
