*----------------------------------------------------------------------*
***INCLUDE LYFI_V006_DONACIOF01.
*----------------------------------------------------------------------*
FORM new_entry.
  " Se llenan los valores automáticos
  yfi_v006_donacio-aedtm = sy-datlo. " Date
  yfi_v006_donacio-uzeit = sy-timlo. " Time
  yfi_v006_donacio-uname = sy-uname. " User
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
           INCLUDE STRUCTURE yfi_v006_donacio. " Table Structure
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
