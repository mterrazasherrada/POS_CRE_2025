*----------------------------------------------------------------------*
***INCLUDE LYSD_V001_PARAMETF01.
*----------------------------------------------------------------------*
FORM f_before_save ##CALLED.
  FIELD-SYMBOLS: <fs_field> TYPE any .
  LOOP AT total.
*CHECK <action> EQ aendern.
** -- Usuario
    ASSIGN COMPONENT 'UNAME' OF STRUCTURE <vim_total_struc> TO <fs_field>.
    IF sy-subrc EQ 0.
      <fs_field> = sy-uname.
    ENDIF.
** -- Fecha
    ASSIGN COMPONENT 'AEDTM' OF STRUCTURE <vim_total_struc> TO <fs_field>.
    IF sy-subrc EQ 0.
      <fs_field> = sy-datum.
    ENDIF.
** -- Hora
    ASSIGN COMPONENT 'UZEIT' OF STRUCTURE <vim_total_struc> TO <fs_field>.
    IF sy-subrc EQ 0.
      <fs_field> = sy-uzeit.
    ENDIF.
    READ TABLE extract WITH KEY <vim_xtotal_key>.
    IF sy-subrc EQ 0.
      extract = total.
      MODIFY extract INDEX sy-tabix.
    ENDIF.
    IF total IS NOT INITIAL.
      MODIFY total.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&----------------------------------------------------------------*
*&      Form  F_AFTER_SAVE
*&----------------------------------------------------------------*
FORM f_after_save ##CALLED.
  COMMIT WORK AND WAIT.
ENDFORM.
