FUNCTION Y_ABAP_TO_INTERNAL_FORMAT.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(IM_INPUT) TYPE  STRING
*"  EXPORTING
*"     VALUE(EX_OUTPUT) TYPE  DATUM
*"     VALUE(EX_ERROR) TYPE  C
*"----------------------------------------------------------------------

  DATA: d(2), m(2), y(4).

* Get the format.
  IF NOT im_input IS INITIAL.
* DD.MM.YYYY
    IF im_input+2(1) = '.'.

      SPLIT im_input AT '.' INTO d m y.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.
      CONCATENATE d m y INTO im_input SEPARATED BY '.'.

      CONCATENATE im_input+6(4) im_input+3(2) im_input(2) INTO ex_output.
* MM/DD/YYYY
    ELSEIF im_input+2(1) = '/'.


      SPLIT im_input AT '/' INTO m d y.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.

      CONCATENATE m d y INTO im_input SEPARATED BY '/'.

      CONCATENATE im_input+6(4) im_input+3(2) im_input(2)  INTO ex_output.
* MM-DD-YYYY
    ELSEIF im_input+2(1) = '-'.

      SPLIT im_input AT '-' INTO m d y.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.

      CONCATENATE m d y INTO im_input SEPARATED BY '-'.

      CONCATENATE im_input+6(4) im_input+3(2) im_input(2)  INTO ex_output.
* YYYY.MM.DD
    ELSEIF im_input+4(1) = '.'.

      SPLIT im_input AT '.' INTO y m d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.

      CONCATENATE y m d INTO im_input SEPARATED BY '.'.

      CONCATENATE im_input(4) im_input+5(2) im_input+8(2)  INTO ex_output.
* YYYY/MM/DD
    ELSEIF im_input+4(1) = '/'.

      SPLIT im_input AT '/' INTO y m d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.

      CONCATENATE y m d INTO im_input SEPARATED BY '.'.

      CONCATENATE im_input(4) im_input+5(2) im_input+8(2)  INTO ex_output.
* YYYY-MM-DD
    ELSEIF im_input+4(1) = '-'.

      SPLIT im_input AT '-' INTO y m d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = d
        IMPORTING
          output = d.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = m
        IMPORTING
          output = m.

      CLEAR im_input.

      CONCATENATE y m d INTO im_input SEPARATED BY '-'.

      CONCATENATE im_input(4) im_input+5(2) im_input+8(2)  INTO ex_output.
    ELSE.
      ex_output = im_input.

      CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
        EXPORTING
          date_external            = ex_output
          accept_initial_date      = 'X'
        IMPORTING
          date_internal            = ex_output
        EXCEPTIONS
          date_external_is_invalid = 1
          OTHERS                   = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.



* Check the valid date.
    IF ex_output IS NOT INITIAL.
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
        EXPORTING
          date                      = ex_output
        EXCEPTIONS
          plausibility_check_failed = 1
          OTHERS                    = 2.
    ENDIF.
* Check if the output parameter is populated. otherwise raise an
* exception.
    IF ex_output IS INITIAL OR sy-subrc <> 0.
      CLEAR: ex_output.
      ex_error = abap_true.
    ENDIF.
  ELSE.
    ex_error = abap_true.
  ENDIF.
ENDFUNCTION.
