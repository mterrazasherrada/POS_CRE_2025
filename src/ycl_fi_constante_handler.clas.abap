class YCL_FI_CONSTANTE_HANDLER definition
  public
  final
  create public .

public section.

  class-data T_CONSTANTE type YFI_TT001_CONSTANTES read-only .
  constants C_SIGN_I type SIGN value 'I' ##NO_TEXT.
  constants C_SIGN_E type SIGN value 'E' ##NO_TEXT.
  constants C_OPTION_EQ type OPTION value 'EQ' ##NO_TEXT.
  constants C_OPTION_NE type OPTION value 'NE' ##NO_TEXT.
  constants C_OPTION_CP type OPTION value 'CP' ##NO_TEXT.

  class-methods CHECK_VALUE
    importing
      !I_APLICA type ANY optional
      !I_CGROUP type ANY optional
      !I_CORRE type ANY optional
      !I_ZVALOR type ANY optional
      !I_YVALOR type ANY optional
      !I_XVALOR type ANY optional
      !I_WVALOR type ANY optional
    returning
      value(E_SUBRC) type SY-SUBRC .
  class-methods GET_VALUE_ZVALOR
    importing
      !I_APLICA type ANY optional
      !I_CGROUP type ANY optional
      !I_CORRE type ANY optional
      !I_YVALOR type ANY optional
      !I_WITH_EXCEPTION type ABAP_BOOL optional
    returning
      value(E_ZVALOR) type STRING
    exceptions
      NOT_VALUES .
  class-methods GET_VALUE_YVALOR
    importing
      !I_APLICA type ANY optional
      !I_CGROUP type ANY optional
      !I_CORRE type ANY optional
      !I_ZVALOR type ANY optional
      !I_WITH_EXCEPTION type ABAP_BOOL optional
    returning
      value(E_YVALOR) type STRING
    exceptions
      NOT_VALUES .
  class-methods GET_VALUE_SINGLE
    importing
      !I_APLICA type ANY optional
      !I_CGROUP type ANY optional
      !I_CORRE type ANY optional
      !I_ZVALOR type ANY optional
      !I_YVALOR type ANY optional
      !I_XVALOR type ANY optional
      !I_WVALOR type ANY optional
      !I_WITH_EXCEPTION type ABAP_BOOL optional
    returning
      value(ES_DATA) type YFI_T008_CONST_D
    exceptions
      NOT_VALUES .
  class-methods GET_RANGE_REF
    importing
      !I_APLICA type ANY optional
      !I_CGROUP type ANY optional
      !I_WITH_EXCEPTION type ABAP_BOOL optional
      !I_REF_ELEMENT type ANY optional
      !I_REF_RSTRUC type ANY optional
      !I_SIGN type SIGN default YCL_FI_CONSTANTE_HANDLER=>C_SIGN_I
      !I_OPTION type OPTION default YCL_FI_CONSTANTE_HANDLER=>C_OPTION_EQ
    returning
      value(E_REF_DATA) type ref to DATA
    exceptions
      NO_DATA
      ERROR .
  class-methods LOAD_CONSTANTE
    importing
      !I_APLICA type ANY
      !I_CGROUP type ANY optional
      !I_WITH_EXCEPTION type ABAP_BOOL optional
    exceptions
      NO_DATA .
**************************************************************************
* Private section of class. *
**************************************************************************
  PRIVATE SECTION.

    CLASS-DATA g_aplica TYPE yfi_t008_const_d-aplica .
    CLASS-DATA g_cgroup TYPE yfi_t008_const_d-cgroup .


ENDCLASS.



CLASS YCL_FI_CONSTANTE_HANDLER IMPLEMENTATION.


  METHOD check_value.
*"----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Validar existencia de constantes                       *
*&---------------------------------------------------------------------*

    "Local data...
    DATA:
     ls_query          TYPE string.

    FIELD-SYMBOLS:
     <fs_constante>    LIKE LINE OF t_constante.

    "Execution...
    FREE e_subrc.

    CLEAR ls_query.

    "Parámetro Aplicación
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_aplica IS SUPPLIED ).
      g_aplica = i_aplica.
    ENDIF.
    ls_query = 'APLICA = G_APLICA'.

    "Parámetro Grupo
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
    ENDIF.
    IF ( g_cgroup IS NOT INITIAL ).
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    IF i_corre IS SUPPLIED.
      CONCATENATE ls_query 'AND CORRE = I_CORRE' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_zvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND ZVALOR = I_ZVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_yvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND YVALOR = I_YVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_xvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND XVALOR = I_XVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_wvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND WVALOR = I_WVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.

    UNASSIGN <fs_constante>.
    LOOP AT t_constante ASSIGNING <fs_constante>
            WHERE (ls_query).
      EXIT.
    ENDLOOP.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
             FROM yfi_t008_const_d
             WHERE (ls_query)
               AND activ = abap_true.
      UNASSIGN <fs_constante>.
      LOOP AT t_constante ASSIGNING <fs_constante>
              WHERE (ls_query).
        EXIT.
      ENDLOOP.
    ENDIF.

    IF ( <fs_constante> IS ASSIGNED ).
      "Constante encontrada!!
      e_subrc = 0.
    ELSE.
      "Constante NO encontrada
      e_subrc = 8.
    ENDIF.

  ENDMETHOD.


  METHOD get_range_ref.
*"----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Traer valores de constante en rango                    *
*&---------------------------------------------------------------------*

*I_APLICA
*I_CGROUP
*I_REF_ELEMENT
*I_SIGN
*I_OPTION
*E_REF_DATA

    "Local data...
    DATA:
     ls_line                    TYPE char100.

    DATA:
      lwa_constante LIKE LINE OF t_constante,
      ls_query      TYPE string.

    FIELD-SYMBOLS:
      <fs_s_str>       TYPE any,
      <fs_s_tab>       TYPE any,
      <fs_t_tab>       TYPE ANY TABLE,

      <fs_s_constante> LIKE LINE OF t_constante.

    DATA:
      lo_data TYPE REF TO data,
      lo_tab  TYPE REF TO data,
      lo_str  TYPE REF TO cl_rs_struc.

    "Execution...
    IF ( i_ref_rstruc  IS INITIAL AND
         i_ref_element IS INITIAL ).
      EXIT.
    ENDIF.


    "Arma consulta dinámica...
    CLEAR ls_query.

    "Parámetro Aplicación
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_aplica IS SUPPLIED ).
      g_aplica = i_aplica.
    ENDIF.
    ls_query = 'APLICA = G_APLICA'.

    "Parámetro Grupo
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
    ENDIF.
    IF ( g_cgroup IS NOT INITIAL ).
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    "Busca si se encuentra en tabla temporal...
    UNASSIGN <fs_s_constante>.
    LOOP AT t_constante ASSIGNING <fs_s_constante>
          WHERE (ls_query).
      EXIT.
    ENDLOOP.
    IF ( <fs_s_constante> IS NOT ASSIGNED ).
      "De no encontrar el registro en la tabla temporal consulta a la BD...
      SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
             FROM yfi_t008_const_d
             WHERE (ls_query)
               AND activ = abap_true..
      UNASSIGN <fs_s_constante>.
      LOOP AT t_constante ASSIGNING <fs_s_constante>
              WHERE (ls_query).
        EXIT.
      ENDLOOP.
    ENDIF.

    "Si aun asi no se encontrase se cancela el proceso. El retorno es vacío.
    IF ( <fs_s_constante> IS NOT ASSIGNED ).
      "Si esta marcado el flag de envio con excepción I_WITH_EXCEPTION se emite excepción...
      IF ( i_with_exception EQ abap_true ).
        RAISE no_data.
      ENDIF.
      EXIT.
    ENDIF.


    "Arma referencia a rango segun atributo definido.
    IF     ( i_ref_element IS NOT INITIAL ).

      "Arma rango dinámico
      TRY .

          "Genera tabla instanciada del tipo rango
          "Instanciamos la clase
          CREATE OBJECT lo_str.
          "Añadimos un campo
          lo_str->add_element( EXPORTING i_id      = 'R_RANGE'
                                         i_sconame = 'SIGN'
                                         i_type    = 'RALDB_SIGN').

          lo_str->add_element( EXPORTING i_id      = 'R_RANGE'
                                         i_sconame = 'OPTION'
                                         i_type    = 'RALDB_OPTI' ).

          lo_str->add_element( EXPORTING i_id      = 'R_RANGE'
                                         i_sconame = 'LOW'
                                         i_type    = i_ref_element ).

          lo_str->add_element( EXPORTING i_id      = 'R_RANGE'
                                         i_sconame = 'HIGH'
                                         i_type    = i_ref_element ).

          "Creamos la estructura dinamicamente
          lo_str->create( EXPORTING i_id = 'R_RANGE'
                                    i_dynamic = 'X'
                           RECEIVING r_r_data = lo_data ).

          CHECK lo_data IS NOT INITIAL .

          "En el field-symbol tenemos la estructura
          ASSIGN lo_data->* TO <fs_s_str>.
          CHECK <fs_s_str> IS ASSIGNED.

          CREATE DATA e_ref_data LIKE TABLE OF <fs_s_str>.
          CHECK e_ref_data IS BOUND.

          "Ahora en este fieldsymbol tendriamos la tabla
          ASSIGN e_ref_data->* TO <fs_t_tab>.
          CHECK <fs_t_tab> IS ASSIGNED.

          LOOP AT t_constante ASSIGNING <fs_s_constante>
                  WHERE (ls_query).

            UNASSIGN <fs_s_tab>.
            INSERT INITIAL LINE INTO TABLE <fs_t_tab> ASSIGNING <fs_s_tab>.

            CLEAR ls_line.
            ls_line+0(1) = i_sign.
            ls_line+1(2) = i_option.
            ls_line+3    = <fs_s_constante>-zvalor.

            MOVE ls_line TO <fs_s_tab>.

          ENDLOOP.

          FREE lo_data.
          FREE lo_str.

        CATCH cx_root.
          "Captura excepción presentada..
          IF ( i_with_exception EQ abap_true ).
            RAISE error.
          ENDIF.

      ENDTRY.

    ELSEIF ( i_ref_rstruc IS NOT INITIAL ).

      TRY.

          CREATE DATA e_ref_data TYPE TABLE OF (i_ref_rstruc).

          UNASSIGN <fs_t_tab>.
          ASSIGN e_ref_data->* TO <fs_t_tab>.
          CHECK <fs_t_tab> IS ASSIGNED.

          LOOP AT t_constante ASSIGNING <fs_s_constante>
                  WHERE (ls_query).

            UNASSIGN <fs_s_tab>.
            INSERT INITIAL LINE INTO TABLE <fs_t_tab> ASSIGNING <fs_s_tab>.

            CLEAR ls_line.
            ls_line+0(1) = i_sign.
            ls_line+1(2) = i_option.
            ls_line+3    = <fs_s_constante>-zvalor.

            MOVE ls_line TO <fs_s_tab>.

          ENDLOOP.

        CATCH cx_root.
          "Captura excepción presentada..
          IF ( i_with_exception EQ abap_true ).
            RAISE error.
          ENDIF.

      ENDTRY.

    ELSE.
      "Do nothing...

    ENDIF.


  ENDMETHOD.


  METHOD get_value_single.
*"----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Traer valor de constantes                              *
*&---------------------------------------------------------------------*

*i_APLICA
*i_CGROUP
*I_CORRE
*I_ZVALOR
*I_YVALOR

    "Local data...
    DATA:
    ls_query          TYPE string.

    FIELD-SYMBOLS:
    <fs_constante>    LIKE LINE OF t_constante.

    "Execution...
    "Arma consulta dinámica...
    CLEAR ls_query.
    "Parámetro Aplicación
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_aplica IS SUPPLIED ).
      g_aplica = i_aplica.
    ENDIF.
    ls_query = 'APLICA = G_APLICA'.

    "Parámetro Grupo
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
    ENDIF.
    IF ( g_cgroup IS NOT INITIAL ).
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    IF ( i_corre IS SUPPLIED ).
      CONCATENATE ls_query 'AND CORRE = I_CORRE' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_zvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND ZVALOR = I_ZVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_yvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND YVALOR = I_YVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_xvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND XVALOR = I_XVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_wvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND WVALOR = I_WVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.

    "Busca si se encuentra en tabla temporal...
    UNASSIGN <fs_constante>.
    LOOP AT t_constante ASSIGNING <fs_constante>
            WHERE (ls_query).
      EXIT.
    ENDLOOP.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      "De no encnotrar el registro en la tabla temporal consulta a la BD...
      SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
             FROM yfi_t008_const_d
             WHERE (ls_query)
               AND activ = abap_true.

      UNASSIGN <fs_constante>.
      LOOP AT t_constante ASSIGNING <fs_constante>
              WHERE (ls_query).
        EXIT.
      ENDLOOP.
    ENDIF.

    "Si aun asi no se encontrase se cancela el proceso. El retorno es vacío.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      "Si esta marcado el flag de envio con excepción I_WITH_EXCEPTION se emite excepción...
      IF ( i_with_exception EQ abap_true ).
        RAISE not_values.
      ENDIF.
      EXIT.
    ENDIF.

    es_data = <fs_constante>.

  ENDMETHOD.


  METHOD get_value_yvalor.
*"----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Traer valor de constantes                              *
*&---------------------------------------------------------------------*

*i_APLICA
*I_CGROUP
*I_CORRE
*I_ZVALOR
*I_YVALOR

    "Local data...
    DATA:
    ls_query          TYPE string.

    FIELD-SYMBOLS:
    <fs_constante>    LIKE LINE OF t_constante.

    "Execution...

    "Arma consulta dinámica...
    CLEAR ls_query.

    "Parámetro Aplicación
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_aplica IS SUPPLIED ).
      g_aplica = i_aplica.
    ENDIF.
    ls_query = 'APLICA = G_APLICA'.

    "Parámetro Grupo
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
    ENDIF.
    IF ( g_cgroup IS NOT INITIAL ).
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    IF ( i_corre IS SUPPLIED ).
      CONCATENATE ls_query 'AND CORRE = I_CORRE' INTO ls_query SEPARATED BY space.
    ENDIF.
    IF ( i_zvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND ZVALOR = I_ZVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.

    UNASSIGN <fs_constante>.
    LOOP AT t_constante ASSIGNING <fs_constante>
            WHERE (ls_query).
      EXIT.
    ENDLOOP.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      "De no encnotrar el registro en la tabla temporal consulta a la BD...
      SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
             FROM yfi_t008_const_d
             WHERE (ls_query)
               AND activ = abap_true.

      UNASSIGN <fs_constante>.
      LOOP AT t_constante ASSIGNING <fs_constante>
              WHERE (ls_query).
        EXIT.
      ENDLOOP.
    ENDIF.

    "Si aun asi no se encontrase se cancela el proceso. El retorno es vacío.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      "Si esta marcado el flag de envio con excepción I_WITH_EXCEPTION se emite excepción...
      IF ( i_with_exception EQ abap_true ).
        RAISE not_values.
      ENDIF.
      EXIT.
    ENDIF.

    e_yvalor = <fs_constante>-yvalor.

  ENDMETHOD.


  METHOD get_value_zvalor.
*"----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Traer valor de constantes                              *
*&---------------------------------------------------------------------*

*I_APLICA
*I_CGROUP
*I_CORRE
*I_ZVALOR
*I_YVALOR

    "Local data...
    DATA:
    ls_query          TYPE string.

    FIELD-SYMBOLS:
    <fs_constante>    LIKE LINE OF t_constante.

    "Execution...
    CLEAR ls_query.

    "Parámetro Aplicación
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_aplica IS SUPPLIED ).
      g_aplica = i_aplica.
    ENDIF.
    ls_query = 'APLICA = G_APLICA'.

    "Parámetro Grupo
    "Si no se consulta por parámetro se toma el valor cargado en memoria
    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
    ENDIF.
    IF ( g_cgroup IS NOT INITIAL ).
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    "Parámetro Correlativo
    IF ( i_corre IS SUPPLIED ).
      CONCATENATE ls_query 'AND CORRE = I_CORRE' INTO ls_query SEPARATED BY space.
    ENDIF.
    "Parámetro Yvalor
    IF ( i_yvalor IS SUPPLIED ).
      CONCATENATE ls_query 'AND YVALOR = I_YVALOR' INTO ls_query SEPARATED BY space.
    ENDIF.

    "Evalua constantes
    UNASSIGN <fs_constante>.
    LOOP AT t_constante ASSIGNING <fs_constante>
            WHERE (ls_query).
      EXIT.
    ENDLOOP.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
             FROM yfi_t008_const_d
             WHERE (ls_query)
               AND activ = abap_true.
      UNASSIGN <fs_constante>.
      LOOP AT t_constante ASSIGNING <fs_constante>
              WHERE (ls_query).
        EXIT.
      ENDLOOP.
    ENDIF.

    "Si aun asi no se encontrase se cancela el proceso. El retorno es vacío.
    IF ( <fs_constante> IS NOT ASSIGNED ).
      "Si esta marcado el flag de envio con excepción I_WITH_EXCEPTION se emite excepción...
      IF ( i_with_exception EQ abap_true ).
        RAISE not_values.
      ENDIF.
      EXIT.
    ENDIF.

    e_zvalor = <fs_constante>-zvalor.

  ENDMETHOD.


  METHOD load_constante.
*&----------------------------------------------------------------------
*& Módulo.....: BC - Multiplicaciones                                  *
*& Autor......: Developer                                              *
*& Fecha......: 01.01.1900                                             *
*& Descripción: Pre-Carga valores de constantes segun ID y Grupo       *
*&---------------------------------------------------------------------*

    "Local data...
    DATA:
    ls_query                    TYPE string.

    "Execution
    "Arma consulta dinámica...
    CLEAR ls_query.

    CHECK ( i_aplica IS NOT INITIAL ).
    g_aplica = i_aplica.

    "Arma query dinámico
    ls_query = 'APLICA = G_APLICA'.

    IF ( i_cgroup IS SUPPLIED ).
      g_cgroup = i_cgroup.
      CONCATENATE ls_query 'AND CGROUP = G_CGROUP' INTO ls_query SEPARATED BY space.
    ENDIF.

    "Borra datos en tabla global de constantes. (si se vuelve a ejecutar el método)
    DELETE t_constante WHERE (ls_query).

    " "De no encnotrar el registro en la tabla temporal consulta a la BD...
    SELECT * APPENDING CORRESPONDING FIELDS OF TABLE t_constante
           FROM yfi_t008_const_d
           WHERE (ls_query)
             AND activ = abap_true.

    IF ( sy-subrc <> 0 ).
      "Si no encuentra valores cancela el proceso
      IF ( i_with_exception EQ abap_true ).
        "Si esta marcado el flag de envio con excepción I_WITH_EXCEPTION se emite excepción...
        RAISE no_data.
      ENDIF.
      EXIT.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
