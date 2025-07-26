*----------------------------------------------------------------------*
***INCLUDE LYSD_V003_DESCUENF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  new_entry
*&---------------------------------------------------------------------*
* Objective: When New row is Added, these fields are filled            *
*&---------------------------------------------------------------------*
FORM new_entry.
  "/ Validar el campo al ingresar
  PERFORM validate_table USING ysd_v003_descuen-tabla_ref.

  " Se llenan los valores automáticos
  ysd_v003_descuen-aedtm = sy-datlo. " Date
  ysd_v003_descuen-uzeit = sy-timlo. " Time
  ysd_v003_descuen-uname = sy-uname. " User
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  before_save
*&---------------------------------------------------------------------*
* Objective: When a row is updated, these fields are filled            *
*&---------------------------------------------------------------------*
FORM before_save.
  " -------------------------------------------------------------------------------
  " --- Types Declaration ---------------------------------------------------------
  " -------------------------------------------------------------------------------
  TYPES: BEGIN OF lts_data.
           INCLUDE STRUCTURE ysd_v003_descuen. " Table Structure
           INCLUDE STRUCTURE vimflagtab. " vimflagtab
  TYPES: END OF lts_data.
  " -------------------------------------------------------------------------------

  " -------------------------------------------------------------------------------
  " --- Data Declaration ----------------------------------------------------------
  " -------------------------------------------------------------------------------
  DATA lwa_total     TYPE lts_data.
  DATA lwa_total_aux TYPE lts_data.
  DATA ln_indext     TYPE sy-tabix.
  DATA ln_indexe     TYPE sy-tabix.
  " -------------------------------------------------------------------------------

  LOOP AT total INTO lwa_total.
    ln_indext = sy-tabix.

    " Validación de la tablas referencias para nuevas y actualizadas entradas
    IF lwa_total-action = 'N' OR lwa_total-action = 'U'.
      PERFORM validate_table USING lwa_total-tabla_ref.
    ENDIF.

    " Si la fila está siendo actualizada
    IF lwa_total-action <> 'U'.
      CONTINUE.
    ENDIF.

    lwa_total_aux = lwa_total.

    lwa_total_aux-aedtm = sy-datlo.
    lwa_total_aux-uzeit = sy-timlo.
    lwa_total_aux-uname = sy-uname.

    total = lwa_total_aux.

    MODIFY total INDEX ln_indext.

    CLEAR ln_indext.

    READ TABLE extract WITH KEY lwa_total.
    IF sy-subrc = 0.
      ln_indexe = sy-tabix.
      extract = total.
      MODIFY extract INDEX ln_indexe.
      CLEAR ln_indexe.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  validate_table
*&---------------------------------------------------------------------*
* Objective: Validate that the table reference                         *
*&---------------------------------------------------------------------*
FORM validate_table USING lv_table.
  " Varialbes locales
  DATA lv_tabla TYPE tabname.
  DATA ls_dd02v TYPE dd02v.

  IF lv_table IS INITIAL.
    RETURN.
  ENDIF.

  lv_tabla = lv_table.
  CALL FUNCTION 'DDIF_TABL_GET'
    EXPORTING  name          = lv_tabla
               state         = 'A'
    IMPORTING  dd02v_wa      = ls_dd02v
    EXCEPTIONS illegal_input = 1
               OTHERS        = 2.

  IF sy-subrc <> 0 OR ls_dd02v-tabclass IS INITIAL.
    MESSAGE 'La tabla referencia especificada no existe en SAP' TYPE 'S' DISPLAY LIKE 'E'.
    vim_abort_saving = 'X'.
    EXIT.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ZF_KRECH  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zf_krech INPUT.
  IF ysd_t003_descuen-vtext IS INITIAL.
    SELECT SINGLE vtext INTO ysd_t003_descuen-vtext
      FROM t685t
      WHERE kappl = 'V'
        AND spras = sy-langu
        AND kschl = ysd_t003_descuen-kschl.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZF_KRECH  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zf_krech OUTPUT.
  IF ysd_t003_descuen-vtext IS INITIAL.
    SELECT SINGLE vtext INTO ysd_t003_descuen-vtext
      FROM t685t
      WHERE kappl = 'V'
        AND spras = sy-langu
        AND kschl = ysd_t003_descuen-kschl.
  ENDIF.
ENDMODULE.
