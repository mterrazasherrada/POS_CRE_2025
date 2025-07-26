
FORM zf_obtener_datos.

  DATA: lv_return TYPE sy-subrc.
  CONSTANTS lc_times TYPE i VALUE '15'.
*{INSERT @0100
*  DO lc_times TIMES.
*    SELECT SINGLE vbeln
*    INTO @DATA(lwa_factura)
*    FROM vbfa
*    WHERE vbeln = @p_vbeln
*      AND vbtyp_n = 'M'.
*    IF sy-subrc = 0.
*      EXIT.
*    ENDIF.
*    WAIT UP TO 1 SECONDS.
*  ENDDO.
*}INSERT @0100
  SELECT SINGLE *
    INTO @DATA(ls_nast)
    FROM nast
    WHERE objky = @p_vbeln.
  IF sy-subrc = 0.

    CALL FUNCTION 'WFMC_MESSAGE_SINGLE'
      EXPORTING
        pi_nast  = ls_nast
      IMPORTING
        pe_rcode = lv_return.

  ELSE.

    DATA(lv_message) = TEXT-e01 && ` ` && p_vbeln.
    MESSAGE e000(ysd001) WITH lv_message DISPLAY LIKE 'I'.

  ENDIF.

ENDFORM.
