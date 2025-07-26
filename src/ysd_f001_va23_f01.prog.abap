*&---------------------------------------------------------------------*
*&  Include           YSD_R001_VA23_F01
*&---------------------------------------------------------------------*
FORM zf_obtener_datos.

  DATA: lv_return TYPE sy-subrc.

  SELECT SINGLE *
*                kappl,
*                objky,
*                kschl,
*                spras,
*                parnr,
*                parvw,
*                erdat,
*                eruhr,
*                nacha,
*                anzal,
*                vsztp,
*                datvr,
*                uhrvr,
*                usnam,
*                vstat,
*                ldest
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

    DATA(lv_message) = TEXT-E01 && ` ` && p_vbeln.
    MESSAGE e000(ysd001) WITH lv_message DISPLAY LIKE 'I'.

  ENDIF.

ENDFORM.
