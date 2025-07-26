FORM zf_obtener_datos.


  TABLES: arc_params, toa_dara, pru_rsv1_body.

  CONSTANTS lc_kschl     TYPE tnapr-kschl VALUE 'YSFE'.
  CONSTANTS lc_times TYPE i VALUE '15'.

  DATA: fm_name               TYPE rs38l_fnam.
  DATA: ls_print_data_to_read TYPE lbbil_print_data_to_read.
  DATA: ls_bil_invoice        TYPE lbbil_invoice.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.
  DATA: ls_dlv-land           LIKE vbrk-land1.
  DATA: ls_job_info           TYPE ssfcrescl.
  DATA: cf_retcode            TYPE sy-subrc.
  DATA: retcode               LIKE sy-subrc.         "Returncode
  DATA: xscreen(1)            TYPE c.               "Output on printer or screen
  DATA: repeat(1)             TYPE c.
  DATA: nast_anzal            LIKE nast-anzal.      "Number of outputs (Orig. + Cop.)
  DATA: nast_tdarmod          LIKE nast-tdarmod.  "Archiving only one time
  DATA is_print_data_to_read  TYPE lbbil_print_data_to_read.
  DATA: lv_form TYPE na_fname.

* current language for read buffered.
  DATA: gf_language LIKE sy-langu.

  DO lc_times TIMES."INSERT @0001
    SELECT SINGLE vkorg, vbtyp
    INTO @DATA(lwa_vbrk)
    FROM vbrk
    WHERE vbeln = @p_vbeln.
    IF sy-subrc = 0.
      EXIT.
    ENDIF.
    WAIT UP TO 1 SECONDS."INSERT @0001
  ENDDO."INSERT @0001
*
*/ Obtener datos del mensaje
*

    CALL METHOD Ycl_sd_utilitys=>get_consultar_print_factura
      EXPORTING
        ip_vbeln = p_vbeln
      IMPORTING
        ep_subrc = DATA(lv_subrc).
    IF lv_subrc <> 0.
      MESSAGE TEXT-e02 type 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM nast
    INTO @DATA(ls_nast)
    WHERE objky = @p_vbeln.
    IF sy-subrc <> 0.
      DATA(lv_message) = TEXT-e01 && ` ` && p_vbeln.
      MESSAGE e000(ysd001) WITH lv_message DISPLAY LIKE 'I'.
      RETURN.
    ENDIF.
*
*/ Validar el tipo de formulario a mostrar
*
    IF lwa_vbrk-vbtyp = 'O'."Crédito/Débito

      lv_form = 'YSDSF_NOTACREDITODEBITO'.

    ELSE.
*
*/ Obtener datos del formulario con clase de mensaje V3
*
      SELECT SINGLE sform
      INTO lv_form
      FROM tnapr
      WHERE kschl = lc_kschl   AND nacha = 1 AND kappl = 'V3'.

    ENDIF.

*
*/ Prepare SmartForm
*
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lv_form
      IMPORTING
        fm_name            = fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    is_print_data_to_read-hd_gen = 'X'.
    is_print_data_to_read-hd_adr = 'X'.
    is_print_data_to_read-hd_gen_descript = 'X'.
    is_print_data_to_read-hd_org = 'X'.
    is_print_data_to_read-hd_part_add = 'X'.
    is_print_data_to_read-hd_kond = 'X'.
    is_print_data_to_read-hd_fin = 'X'.
    is_print_data_to_read-hd_ref = 'X'.
    is_print_data_to_read-hd_tech = 'X'.
    is_print_data_to_read-it_gen = 'X'.
    is_print_data_to_read-it_adr = 'X'.
    is_print_data_to_read-it_price = 'X'.
    is_print_data_to_read-it_kond = 'X'.
    is_print_data_to_read-it_ref = 'X'.
    is_print_data_to_read-it_refdlv = 'X'.
    is_print_data_to_read-it_reford = 'X'.
    is_print_data_to_read-it_refpurord = 'X'.
    is_print_data_to_read-it_refvag = 'X'.
    is_print_data_to_read-it_refvg2 = 'X'.
    is_print_data_to_read-it_refvkt = 'X'.
    is_print_data_to_read-it_tech = 'X'.
    is_print_data_to_read-it_fin = 'X'.
    is_print_data_to_read-it_confitm = 'X'.
    is_print_data_to_read-it_confbatch = 'X'.
    is_print_data_to_read-msr_hd = 'X'.
    is_print_data_to_read-msr_it = 'X'.

    CALL FUNCTION 'LB_BIL_INV_OUTP_READ_PRTDATA'
      EXPORTING
        if_bil_number         = ls_nast-objky
        if_parvw              = ls_nast-parvw
        if_parnr              = ls_nast-parnr
        if_language           = ls_nast-spras
        is_print_data_to_read = is_print_data_to_read
      IMPORTING
        es_bil_invoice        = ls_bil_invoice
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.

    ls_control_param-preview = 'X'.
    ls_control_param-no_dialog = 'X'.

    CALL FUNCTION fm_name
      EXPORTING
        archive_index      = toa_dara
        archive_parameters = arc_params
        control_parameters = ls_control_param
*       mail_appl_obj      =
        mail_recipient     = ls_recipient
        mail_sender        = ls_sender
        output_options     = ls_composer_param
        user_settings      = space
        is_bil_invoice     = ls_bil_invoice
        is_nast            = ls_nast
        is_repeat          = repeat
      IMPORTING
        job_output_info    = ls_job_info
*       document_output_info =
*       job_output_options =
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


ENDFORM.
