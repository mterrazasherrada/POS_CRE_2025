*----------------------------------------------------------------------*
***INCLUDE LYFI_V007_CONST_HF01.
*----------------------------------------------------------------------*
FORM new_entry .
  yfi_v007_const_h-ernam = sy-uname . " User
  yfi_v007_const_h-erdat = sy-datlo . " Date
  yfi_v007_const_h-erzet = sy-timlo . " Time
ENDFORM .                    "new_entry


FORM before_save .

  TYPES: BEGIN OF lts_data .
           INCLUDE STRUCTURE yfi_v007_const_h . " Table Structure
           INCLUDE STRUCTURE vimflagtab    . " vimflagtab
         TYPES: END OF lts_data .
  DATA: lwa_total     TYPE lts_data .
  DATA: lwa_total_aux TYPE lts_data .
  DATA: ln_indext     TYPE sy-tabix .
  DATA: ln_indexe     TYPE sy-tabix .

  LOOP AT total INTO lwa_total .

    ln_indext = sy-tabix .

    IF lwa_total-action EQ 'U'. " Only For update Rows

      lwa_total_aux = lwa_total .

      lwa_total_aux-aenam = sy-uname .
      lwa_total_aux-aedat = sy-datlo .
      lwa_total_aux-aezet = sy-timlo .

      total = lwa_total_aux .

      MODIFY total INDEX ln_indext .

      CLEAR ln_indext .

      READ TABLE extract WITH KEY lwa_total .
      IF sy-subrc EQ 0 .

        ln_indexe = sy-tabix .

        extract = total .

        MODIFY extract INDEX ln_indexe .

        CLEAR ln_indexe .
      ENDIF .
    ENDIF .
  ENDLOOP .
ENDFORM .                    "before_save
