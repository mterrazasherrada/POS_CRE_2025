*&---------------------------------------------------------------------*
*&  Include           YSD_R001_VA23_LAY
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK data1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_vbeln TYPE vbeln_vf MATCHCODE OBJECT shvf_f.
SELECTION-SCREEN END OF BLOCK data1.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.
*
*/ Obtener all datos
*
  PERFORM: zf_obtener_datos.

END-OF-SELECTION.
