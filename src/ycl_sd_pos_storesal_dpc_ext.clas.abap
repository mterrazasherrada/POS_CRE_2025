class YCL_SD_POS_STORESAL_DPC_EXT definition
  public
  inheriting from YCL_SD_POS_STORESAL_DPC
  create public .

public section.
protected section.

  methods AVAILABLESTOCKSE_GET_ENTITYSET
    redefinition .
  methods BANKACCOUNTSET_GET_ENTITYSET
    redefinition .
  methods BATCHSET_GET_ENTITYSET
    redefinition .
  methods BILLINGLIMITSET_GET_ENTITYSET
    redefinition .
  methods BUSINESSAREASET_GET_ENTITYSET
    redefinition .
  methods COMPANYSET_GET_ENTITYSET
    redefinition .
  methods CUSTOMERSET_GET_ENTITYSET
    redefinition .
  methods DAILYSALESSET_GET_ENTITYSET
    redefinition .
  methods DISCOUNTPRICESET_GET_ENTITYSET
    redefinition .
  methods DISCOUNTSET_GET_ENTITYSET
    redefinition .
  methods DISTRIBUTIONCHAN_GET_ENTITYSET
    redefinition .
  methods DOCUMENTCLASSSET_GET_ENTITYSET
    redefinition .
  methods DOCUMENTFLOWSET_GET_ENTITYSET
    redefinition .
  methods DYNAMICDISCOUNTS_GET_ENTITYSET
    redefinition .
  methods ISSUEREASONSET_GET_ENTITYSET
    redefinition .
  methods MATERIALGROUPSET_GET_ENTITYSET
    redefinition .
  methods MATERIALMASTERSE_GET_ENTITYSET
    redefinition .
  methods MATERIALSET_GET_ENTITYSET
    redefinition .
  methods MATERIALTYPESET_GET_ENTITYSET
    redefinition .
  methods OPENITEMSSET_GET_ENTITYSET
    redefinition .
  methods ORDERCUSTOMERSET_GET_ENTITYSET
    redefinition .
  methods ORDERREASONSET_GET_ENTITYSET
    redefinition .
  methods ORIGINSET_GET_ENTITYSET
    redefinition .
  methods PAYMENTMETHODSET_GET_ENTITYSET
    redefinition .
  methods PAYMENTSET_CREATE_ENTITY
    redefinition .
  methods PERSONNELSET_GET_ENTITYSET
    redefinition .
  methods PLANTSET_GET_ENTITYSET
    redefinition .
  methods POSITIONTYPESET_GET_ENTITYSET
    redefinition .
  methods POSTSET_CREATE_ENTITY
    redefinition .
  methods PRODUCTHIERARCHY_GET_ENTITYSET
    redefinition .
  methods PROFITCENTERSET_GET_ENTITYSET
    redefinition .
  methods QUOTATIONSET_GET_ENTITYSET
    redefinition .
  methods REJECTEDSALESSET_GET_ENTITYSET
    redefinition .
  methods REJECTIONREASONS_GET_ENTITYSET
    redefinition .
  methods ROUTESET_GET_ENTITYSET
    redefinition .
  methods SALESAREASET_GET_ENTITYSET
    redefinition .
  methods SALESGROUPSET_GET_ENTITYSET
    redefinition .
  methods SALESORDERSET_CREATE_ENTITY
    redefinition .
  methods SALESORGANIZATIO_GET_ENTITYSET
    redefinition .
  methods SALESZONESET_GET_ENTITYSET
    redefinition .
  methods SEARCHCONCEPTSET_GET_ENTITYSET
    redefinition .
  methods SECTORSET_GET_ENTITYSET
    redefinition .
  methods STORAGELOCATIONS_GET_ENTITYSET
    redefinition .
  methods STORESET_GET_ENTITYSET
    redefinition .
  methods TAXIDSET_GET_ENTITYSET
    redefinition .
  methods TOLERANCESET_GET_ENTITYSET
    redefinition .
  methods DONATIONACCOUNTS_GET_ENTITYSET
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_SD_POS_STORESAL_DPC_EXT IMPLEMENTATION.


  METHOD availablestockse_get_entityset.
    DATA lv_centro            TYPE werks_d.
    DATA lv_articulo          TYPE matnr18.
    DATA lv_material          TYPE matnr18.
    DATA lv_unidad_medida     TYPE mara-meins.
    DATA lv_organizacionventa TYPE vkorg.
    DATA lo_data              TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Articulo'.
          lv_articulo = ls_opt-low.
        WHEN 'Centro'.
          lv_centro = ls_opt-low.
        WHEN 'UnidadMedida'.
          lv_unidad_medida = ls_opt-low.
        WHEN 'OrganizacionVenta'.
          lv_organizacionventa = ls_opt-low.
      ENDCASE.
    ENDLOOP.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING input  = lv_articulo
      IMPORTING output = lv_material.

    lo_data = NEW #( ).

    lo_data->get_stock_disponible( EXPORTING i_articulo            = lv_material
                                             i_centro              = lv_centro
                                             i_unidad_medida       = lv_unidad_medida
                                             i_organizacion_ventas = lv_organizacionventa
                                   IMPORTING rt_return             = et_entityset ).
  ENDMETHOD.


  METHOD bankaccountset_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_cuenta_banco( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD batchset_get_entityset.
    DATA lv_centro   TYPE werks_d.
    DATA lv_articulo TYPE matnr.
    DATA lv_material TYPE matnr.
    DATA lv_almacen  TYPE mchb-lgort.
    DATA lo_data     TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Articulo'.
          lv_articulo = ls_opt-low.
        WHEN 'Centro'.
          lv_centro = ls_opt-low.
        WHEN 'Almacen'.
          lv_almacen = ls_opt-low.
      ENDCASE.
    ENDLOOP.

    IF lv_articulo IS NOT INITIAL AND lv_centro IS NOT INITIAL AND lv_almacen IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING input  = lv_articulo
        IMPORTING output = lv_material.

      lo_data = NEW #( ).

      lo_data->get_lote( EXPORTING i_articulo = lv_material
                                   i_centro   = lv_centro
                                   i_almacen  = lv_almacen
                         IMPORTING rt_return  = et_entityset ).

    ELSE.

      APPEND VALUE #( messcode = TEXT-e01
                      message  = TEXT-e14 ) TO et_entityset.

    ENDIF.
  ENDMETHOD.


  METHOD billinglimitset_get_entityset.
    DATA lv_org_ventas   TYPE vkorg.
    DATA lv_oficina      TYPE vkbur.
    DATA lv_cliente      TYPE kunnr.
    DATA lv_destinatario TYPE kunnr.
    DATA lv_nit          TYPE stcd1.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Oficina'.
          lv_oficina = ls_opt-low.
        WHEN 'Cliente'.
          lv_cliente = ls_opt-low.
        WHEN 'Bill_to'.
          lv_destinatario = ls_opt-low.
        WHEN 'Nit'.
          lv_nit = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_limite_factura( EXPORTING i_org_ventas   = lv_org_ventas
                                           i_oficina      = lv_oficina
                                           i_cliente      = lv_cliente
                                           i_destinatario = lv_destinatario
                                           i_nit          = lv_nit
                                 IMPORTING rt_return      = et_entityset ).
  ENDMETHOD.


  method BUSINESSAREASET_GET_ENTITYSET.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_division( IMPORTING rt_return = et_entityset ).
  endmethod.


  METHOD companyset_get_entityset.
    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_sociedad( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD customerset_get_entityset.
   DATA lv_cliente  TYPE kna1-kunnr.
    DATA lv_orgventa TYPE vkorg.
    DATA lv_canal    TYPE vtweg.
    DATA lv_sector   TYPE spart.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Cliente'.
          lv_cliente = ls_opt-low.
        WHEN 'OrganizacionVenta'.
          lv_orgventa = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
      ENDCASE.
    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_cliente( EXPORTING i_cliente  = lv_cliente
                                    i_orgventa = lv_orgventa
                                    i_canal    = lv_canal
                                    i_sector   = lv_sector
                          IMPORTING rt_return  = et_entityset ).
  ENDMETHOD.


  METHOD dailysalesset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_canal      TYPE tvakz-vtweg.
    DATA lv_fechai     TYPE char10.
    DATA lv_fechaf     TYPE char10.
    DATA lv_sector     TYPE vbak-spart.
    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>    TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Fecha'.
          lv_fechai = ls_opt-low.
        WHEN 'ValidoA'.
          lv_fechaf = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    IF     lv_org_ventas IS NOT INITIAL
       AND lv_canal      IS NOT INITIAL
       AND lv_sector     IS NOT INITIAL
       AND lv_fechai     IS NOT INITIAL
       AND lv_fechaf     IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_ventas_diarias( EXPORTING i_org_ventas = lv_org_ventas
                                             i_canal      = lv_canal
                                             i_sector     = lv_sector
                                             i_fechai     = lv_fechai
                                             i_fechaf     = lv_fechaf
                                   IMPORTING rt_return    = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_entityset>.
      <fs_entityset>-messcode = TEXT-e01.
      <fs_entityset>-message  = TEXT-e15.

    ENDIF.
  ENDMETHOD.


  METHOD discountpriceset_get_entityset.
    DATA lv_material       TYPE matnr.
    DATA lv_articulo       TYPE matnr.
    DATA lv_org_ventas     TYPE tvakz-vkorg.
    DATA lv_canal          TYPE tvakz-vtweg.
    DATA lv_sector         TYPE spart.
    DATA lv_matkl          TYPE matkl.
    DATA lv_kdgrp          TYPE kdgrp.
    DATA lv_kdkgr          TYPE kdkgr.
    DATA lv_zona_ventas    TYPE bzirk.
    DATA lv_oficina_ventas TYPE vkbur.
    DATA lv_solicitante    TYPE pernr.
    DATA lv_tipo_precio    TYPE pltyp.
    DATA lv_condicion_pago TYPE knvv-zterm.
    DATA lv_fechaf         TYPE char10.
    DATA lv_fechax         TYPE datum.
    DATA ex_error          TYPE c LENGTH 1.
    DATA lo_data           TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Articulo'.
          lv_articulo = ls_opt-low.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
        WHEN 'GrupoArticulos'.
          lv_matkl = ls_opt-low.
        WHEN 'GrupoCliente'.
          lv_kdgrp = ls_opt-low.
        WHEN 'GrupoCondClient'.
          lv_kdkgr = ls_opt-low.
        WHEN 'ZonaVenta'.
          lv_zona_ventas = ls_opt-low.
        WHEN 'Oficina'.
          lv_oficina_ventas = ls_opt-low.
        WHEN 'Solicitante'.
          lv_solicitante = ls_opt-low.
        WHEN 'TipoPrecio'.
          lv_tipo_precio = ls_opt-low.
        WHEN 'CondicionPago'.
          lv_condicion_pago = ls_opt-low.
        WHEN 'ValidoA'.
          CALL FUNCTION 'Y_ABAP_TO_INTERNAL_FORMAT'
            EXPORTING im_input  = ls_opt-low
            IMPORTING ex_output = lv_fechax
                      ex_error  = ex_error.
          lv_fechaf = lv_fechax.
          CLEAR lv_fechax.
      ENDCASE.
    ENDLOOP.

    " Conversión de artículo a formato interno
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING input  = lv_articulo
      IMPORTING output = lv_material.

    lo_data = NEW #( ).

    lo_data->get_precio_descuento( EXPORTING i_articulo           = lv_material
                                             i_org_ventas         = lv_org_ventas
                                             i_canal              = lv_canal
                                             i_sector             = lv_sector
                                             i_grupo_articulo     = lv_matkl
                                             i_grupo_cliente      = lv_kdgrp
                                             i_grupo_cond_cliente = lv_kdkgr
                                             i_zona_ventas        = lv_zona_ventas
                                             i_oficina_ventas     = lv_oficina_ventas
                                             i_solicitante        = lv_solicitante
                                             i_lista_precio       = lv_tipo_precio
                                             i_condicion_pago     = lv_condicion_pago
                                             i_valido_a           = lv_fechaf
                                   IMPORTING rt_return            = et_entityset ).
  ENDMETHOD.


  METHOD discountset_get_entityset.
    DATA lv_org_ventas   TYPE tvakz-vkorg.
    DATA lv_canal        TYPE tvakz-vtweg.
    DATA lv_sector         TYPE spart.
    DATA lv_matkl        TYPE matkl.
    DATA lv_zona_ventas  TYPE bzirk.
    DATA lv_material     TYPE mara-matnr.
    DATA lv_lista_precio TYPE pltyp.
    DATA lv_kdgrp          TYPE kdgrp.
    DATA lv_kdkgr          TYPE kdkgr.
    DATA lv_oficina_ventas TYPE vkbur.
    DATA lv_solicitante    TYPE kunag.
    DATA lv_condicion_pago TYPE knvv-zterm.
    DATA lv_fechaf         TYPE char10.
    DATA lv_fechax         TYPE datum.
    DATA lo_data         TYPE REF TO ycl_sd_store_sales.
    DATA ex_error          TYPE c LENGTH 1.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'ZonaVenta'.
          lv_zona_ventas = ls_opt-low.
        WHEN 'Material'.
          lv_material = ls_opt-low.

          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input  = lv_material
            IMPORTING
              output = lv_material.

        WHEN 'TipoPrecio'.
          lv_lista_precio = ls_opt-low.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
        WHEN 'GrupoArticulos'.
          lv_matkl = ls_opt-low.
*{INSERT @0100
        WHEN 'GrupoCliente'.
          lv_kdgrp = ls_opt-low.
        WHEN 'GrupoCondClient'.
          lv_kdkgr = ls_opt-low.
        WHEN 'Oficina'.
          lv_oficina_ventas = ls_opt-low.
        WHEN 'Solicitante'.
          lv_solicitante =   ls_opt-low .
          lv_solicitante =  |{ lv_solicitante ALPHA = IN }|.
        WHEN 'CondicionPago'.
          lv_condicion_pago = ls_opt-low.
        WHEN 'ValidoA'.
          CALL FUNCTION 'Y_ABAP_TO_INTERNAL_FORMAT'
            EXPORTING
              im_input  = ls_opt-low
            IMPORTING
              ex_output = lv_fechax
              ex_error  = ex_error.
          lv_fechaf = lv_fechax.
          CLEAR lv_fechax.
      ENDCASE.
*}INSERT @0100
    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_descuento( EXPORTING i_material       = lv_material
                                      i_org_ventas         = lv_org_ventas
                                      i_canal              = lv_canal
                                      i_sector             = lv_sector
                                      i_grupo_articulo     = lv_matkl
                                      i_grupo_cliente      = lv_kdgrp
                                      i_grupo_cond_cliente = lv_kdkgr
                                      i_zona_ventas        = lv_zona_ventas
                                      i_oficina_ventas     = lv_oficina_ventas
                                      i_solicitante        = lv_solicitante
                                      i_lista_precio       = lv_lista_precio
                                      i_condicion_pago     = lv_condicion_pago
                                      i_valido_a           = lv_fechaf
                            IMPORTING rt_return            = et_entityset ).
  ENDMETHOD.


  METHOD distributionchan_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'OrganizacionVenta'.
        lv_org_ventas = ls_opt-low.
      ENDIF.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_canal( EXPORTING i_org_ventas = lv_org_ventas
                        IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD documentclassset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_canal      TYPE tvakz-vtweg.
    DATA lv_sector     TYPE tvakz-spart.
    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
      ENDCASE.
    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_clase_doc( EXPORTING i_org_ventas = lv_org_ventas
                                      i_canal      = lv_canal
                                      i_sector     = lv_sector
                            IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD documentflowset_get_entityset.
    DATA lv_documento TYPE vbfa-vbeln. " Documento subsiguiente

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.
    FIELD-SYMBOLS <fs_entityset>  LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      IF <ls_filter>-property = 'DocSubsig'.
        ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
        IF sy-subrc = 0.
          lv_documento = <fs_select_opt>-low.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_documento IS NOT INITIAL.
      DATA(lo_data) = NEW ycl_sd_store_sales( ).
      lo_data->get_flujo_documento( EXPORTING i_documento = lv_documento
                                    IMPORTING rt_return   = et_entityset ).
    ELSE.
      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_entityset>.
      <fs_entityset>-message  = TEXT-e10.
      <fs_entityset>-messcode = TEXT-e01.
    ENDIF.
  ENDMETHOD.


  method DONATIONACCOUNTS_GET_ENTITYSET.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_cuenta_donacion( IMPORTING rt_return = et_entityset ).
  endmethod.


  METHOD dynamicdiscounts_get_entityset.
    DATA lv_orgventa TYPE vkorg.
    DATA lv_tipodoc  TYPE yde_tipodoc.

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
          IF sy-subrc = 0.
            lv_orgventa = <fs_select_opt>-low.
          ENDIF.

        WHEN 'TipoDoc'.
          ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
          IF sy-subrc = 0.
            lv_tipodoc = <fs_select_opt>-low.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_descuentos_dinamicos( EXPORTING i_org_ventas = lv_orgventa
                                                 i_pantalla   = lv_tipodoc
                                       IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD issuereasonset_get_entityset.
    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_motivo_expedicion( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD materialgroupset_get_entityset.
    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_grupo_articulo( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD materialmasterse_get_entityset.
    DATA lv_centro TYPE werks_d.

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      IF <ls_filter>-property = 'Centro'.
        ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
        IF sy-subrc = 0.
          lv_centro = <fs_select_opt>-low.
        ENDIF.
      ENDIF.
    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_articulo( EXPORTING i_centro  = lv_centro
                           IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD materialset_get_entityset.
    DATA lv_articulo TYPE mara-matnr.
    DATA lv_centro   TYPE werks_d.

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      CASE <ls_filter>-property.
        WHEN 'Articulo'.
          ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
          IF sy-subrc = 0.
            lv_articulo = <fs_select_opt>-low.
          ENDIF.
        WHEN 'Centro'.
          ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
          IF sy-subrc = 0.
            lv_centro = <fs_select_opt>-low.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    IF lv_centro IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_material( EXPORTING i_articulo = lv_articulo
                                     i_centro   = lv_centro
                           IMPORTING rt_return  = et_entityset ).
  ENDMETHOD.


  METHOD materialtypeset_get_entityset.
    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_tipo_material( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD openitemsset_get_entityset.
    DATA lv_sociedad TYPE bukrs.
    DATA lv_cliente  TYPE kunnr.
    DATA lo_data     TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Sociedad'.
          lv_sociedad = ls_opt-low.
        WHEN 'Cliente'.
          lv_cliente = ls_opt-low.
      ENDCASE.
    ENDLOOP.

    IF lv_sociedad IS NOT INITIAL AND lv_cliente IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING input  = lv_cliente
        IMPORTING output = lv_cliente.

      lo_data = NEW #( ).

      lo_data->get_partidas_abiertas( EXPORTING i_sociedad = lv_sociedad
                                                i_cliente  = lv_cliente
                                      IMPORTING rt_return  = et_entityset ).

    ELSE.

      APPEND VALUE #( messcode = TEXT-e01
                      message  = TEXT-e14 ) TO et_entityset.

    ENDIF.
  ENDMETHOD.


  METHOD ordercustomerset_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_cliente_pedido( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD orderreasonset_get_entityset.
    DATA lv_org_ventas TYPE vkorg.

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      IF <ls_filter>-property = 'OrganizacionVenta'.
        ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
        IF sy-subrc = 0.
          lv_org_ventas = <fs_select_opt>-low.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_motivo_pedido( EXPORTING i_org_ventas = lv_org_ventas
                                IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD originset_get_entityset.
    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_origen( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD paymentmethodset_get_entityset.

    DATA lv_org_ventas TYPE vkorg.

    FIELD-SYMBOLS <ls_filter>     TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_opt> TYPE /iwbep/s_cod_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.
      IF <ls_filter>-property = 'OrganizacionVenta'.
        ASSIGN <ls_filter>-select_options[ 1 ] TO <fs_select_opt>.
        IF sy-subrc = 0.
          lv_org_ventas = <fs_select_opt>-low.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.

    DATA(lo_data) = NEW ycl_sd_store_sales( ).

    lo_data->get_metodo_pago( EXPORTING i_org_ventas = lv_org_ventas
                              IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD paymentset_create_entity.
    DATA lo_data   TYPE REF TO ycl_sd_store_sales.
    DATA ls_data   TYPE ysd_s_003_contabilizar.
    DATA lt_data_h TYPE TABLE OF ysd_s_003_contabilizar.
    DATA lt_data_p TYPE TABLE OF ysd_s_003_contabilizar.
    DATA lt_data_c TYPE TABLE OF ysd_s_003_contabilizar.

    FIELD-SYMBOLS <fs_data_h> TYPE ysd_s_003_contabilizar.
    FIELD-SYMBOLS <fs_data_p> TYPE ysd_s_003_contabilizar.

    " Leer la entrada desde la app
    io_data_provider->read_entry_data( IMPORTING es_data = ls_data ).

    " Parsear JSON desde la app
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datah
                               CHANGING  data = lt_data_h ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datap
                               CHANGING  data = lt_data_p ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datac
                               CHANGING  data = lt_data_c ).

    IF lt_data_h IS NOT INITIAL AND lt_data_p IS NOT INITIAL AND lt_data_c IS NOT INITIAL.

      LOOP AT lt_data_h ASSIGNING <fs_data_h>.
        <fs_data_h>-cliente          = |{ <fs_data_h>-cliente ALPHA = IN }|.
        <fs_data_h>-numero_documento = |{ <fs_data_h>-numero_documento ALPHA = IN }|.
      ENDLOOP.

      LOOP AT lt_data_p ASSIGNING <fs_data_p>.
        <fs_data_p>-cliente          = |{ <fs_data_p>-cliente ALPHA = IN }|.
        <fs_data_p>-numero_documento = |{ <fs_data_p>-numero_documento ALPHA = IN }|.
      ENDLOOP.

      lo_data = NEW #( ).

      lo_data->set_cobro( EXPORTING i_new_cobro_h = lt_data_h
                                    i_new_cobro_p = lt_data_p
                                    i_new_cobro_c = lt_data_c
                          IMPORTING rt_return     = er_entity ).

    ELSE.
      er_entity-messcode = TEXT-e01.
      er_entity-message  = TEXT-e12.
    ENDIF.
  ENDMETHOD.


  METHOD personnelset_get_entityset.
    DATA lv_solicitante TYPE pa0001-pernr.
    DATA lv_check       TYPE c LENGTH 1.

    DATA lo_data        TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Solicitante'.
          lv_solicitante = ls_opt-low.

        WHEN 'Check'.
          lv_check = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_personal( EXPORTING i_solicitante = lv_solicitante
                                     i_check       = lv_check
                           IMPORTING rt_return     = et_entityset ).
  ENDMETHOD.


  METHOD plantset_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_centro( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD positiontypeset_get_entityset.
    DATA lv_auart      TYPE auart.
    DATA lv_expedicion TYPE vsbed.

    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'ClaseDocumento'.
          lv_auart = ls_opt-low.

        WHEN 'MotivoExpedicion'.
          lv_expedicion = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    " Validación de filtros requeridos
    IF lv_auart IS INITIAL OR lv_expedicion IS INITIAL.
      RETURN.
    ENDIF.

    lo_data = NEW #( ).

    lo_data->get_tipoposicion( EXPORTING i_clasedocumento   = lv_auart
                                         i_motivoexpedicion = lv_expedicion
                               IMPORTING rt_return          = et_entityset ).
  ENDMETHOD.


  METHOD postset_create_entity.
    DATA lo_data   TYPE REF TO ycl_sd_store_sales.
    DATA ls_data   TYPE ysd_s_003_contabilizar.
    DATA lt_data_h TYPE TABLE OF ysd_s_003_contabilizar.
    DATA lt_data_p TYPE TABLE OF ysd_s_003_contabilizar.
    DATA lt_data_c TYPE TABLE OF ysd_s_003_contabilizar.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_doc    TYPE ysd_tt_011_fi_doc.
    DATA lv_flag   TYPE c LENGTH 1.

    FIELD-SYMBOLS <fs_data_h> TYPE ysd_s_003_contabilizar.
    FIELD-SYMBOLS <fs_data_p> TYPE ysd_s_003_contabilizar.

    " Leer la data desde el data provider
    io_data_provider->read_entry_data( IMPORTING es_data = ls_data ).

    " Convertir JSON a estructuras ABAP
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datah
                               CHANGING  data = lt_data_h ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datap
                               CHANGING  data = lt_data_p ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datac
                               CHANGING  data = lt_data_c ).

    IF lt_data_h IS NOT INITIAL AND lt_data_p IS NOT INITIAL AND lt_data_c IS NOT INITIAL.

      " Obtener flag desde el encabezado
      READ TABLE lt_data_h INTO DATA(ls_head) INDEX 1.
      lv_flag = ls_head-etapa.

      " Conversión ALPHA en cliente y documento
      LOOP AT lt_data_h ASSIGNING <fs_data_h>.
        <fs_data_h>-cliente          = |{ <fs_data_h>-cliente ALPHA = IN }|.
        <fs_data_h>-numero_documento = |{ <fs_data_h>-numero_documento ALPHA = IN }|.
      ENDLOOP.

      LOOP AT lt_data_p ASSIGNING <fs_data_p>.
        <fs_data_p>-numero_documento = |{ <fs_data_p>-numero_documento ALPHA = IN }|.
      ENDLOOP.

      lo_data = NEW #( ).

      CASE lv_flag.
        WHEN 'P'.
          lo_data->set_cobro1( EXPORTING i_new_cobro_h = lt_data_h
                                         i_new_cobro_p = lt_data_p
                                         i_new_cobro_c = lt_data_c
                               IMPORTING rt_return     = er_entity
                                         rt_doc        = lt_doc ).

        WHEN 'T'.
          lo_data->set_contabilizar( EXPORTING i_new_cobroe3_h = lt_data_h
                                               i_new_cobroe3_p = lt_data_p
                                               i_new_cobroe3_c = lt_data_c
                                     IMPORTING rt_return       = er_entity ).

        WHEN OTHERS.
          er_entity-messcode = TEXT-e01.
          er_entity-message  = TEXT-e11.
      ENDCASE.

    ELSE.
      er_entity-messcode = TEXT-e01.
      er_entity-message  = TEXT-e12.
    ENDIF.
  ENDMETHOD.


  METHOD producthierarchy_get_entityset.
    " try.
    " CALL METHOD SUPER->PRODUCTHIERARCHY_GET_ENTITYSET
    "   EXPORTING
    "     IV_ENTITY_NAME           =
    "     IV_ENTITY_SET_NAME       =
    "     IV_SOURCE_NAME           =
    "     IT_FILTER_SELECT_OPTIONS =
    "     IS_PAGING                =
    "     IT_KEY_TAB               =
    "     IT_NAVIGATION_PATH       =
    "     IT_ORDER                 =
    "     IV_FILTER_STRING         =
    "     IV_SEARCH_STRING         =
    " io_tech_request_context  =
    " importing
    " et_entityset             =
    " es_response_context      =
    "     .
    " catch /iwbep/cx_mgw_busi_exception .
    " catch /iwbep/cx_mgw_tech_exception .
    " endtry.

    DATA lo_data TYPE REF TO ycl_sd_store_sales. " declaracion de la clase

    lo_data = NEW #( ).

    lo_data->get_jerarquia_producto( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD profitcenterset_get_entityset.
    " try.
    " CALL METHOD SUPER->PROFITCENTERSET_GET_ENTITYSET
    "   EXPORTING
    "     IV_ENTITY_NAME           =
    "     IV_ENTITY_SET_NAME       =
    "     IV_SOURCE_NAME           =
    "     IT_FILTER_SELECT_OPTIONS =
    "     IS_PAGING                =
    "     IT_KEY_TAB               =
    "     IT_NAVIGATION_PATH       =
    "     IT_ORDER                 =
    "     IV_FILTER_STRING         =
    "     IV_SEARCH_STRING         =
    " io_tech_request_context  =
    " importing
    " et_entityset             =
    " es_response_context      =
    "     .
    " catch /iwbep/cx_mgw_busi_exception .
    " catch /iwbep/cx_mgw_tech_exception .
    " endtry.

    DATA lv_sociedad TYPE bukrs.
    DATA lo_data     TYPE REF TO ycl_sd_store_sales.
    DATA ls_filter   TYPE /iwbep/s_mgw_select_option.
    DATA ls_option   TYPE /iwbep/s_cod_select_option.

    " Buscar filtro para Sociedad
    LOOP AT it_filter_select_options INTO ls_filter.
      IF ls_filter-property = 'Sociedad'.
        READ TABLE ls_filter-select_options INTO ls_option INDEX 1.
        IF sy-subrc = 0.
          lv_sociedad = ls_option-low.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_sociedad IS NOT INITIAL.
      lo_data = NEW #( ).
      TRY.
          lo_data->get_beneficio( EXPORTING i_sociedad = lv_sociedad
                                  IMPORTING rt_return  = et_entityset ).
        CATCH cx_root INTO DATA(lo_ex).
          APPEND VALUE #( message  = lo_ex->get_text( )
                          messcode = TEXT-e02 ) TO et_entityset.
      ENDTRY.
    ELSE.
      APPEND VALUE #( message  = TEXT-e14
                      messcode = TEXT-e01 ) TO et_entityset.
    ENDIF.
  ENDMETHOD.


  METHOD quotationset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_oficina    TYPE vbak-vkbur.
    DATA lv_fechai     TYPE char10.
    DATA lv_fechaf     TYPE char10.
    DATA lv_usuario    TYPE uname.
    DATA lv_cliente    TYPE vbak-kunnr.
    DATA lv_fechax     TYPE datum.
    DATA ex_error      TYPE c LENGTH 1.

    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Oficina'.
          lv_oficina = ls_opt-low.
        WHEN 'Cliente'.
          lv_cliente = ls_opt-low.

          lv_cliente = |{ lv_cliente ALPHA = IN }|.

        WHEN 'Fecha'.
          CALL FUNCTION 'Y_ABAP_TO_INTERNAL_FORMAT'
            EXPORTING im_input  = ls_opt-low
            IMPORTING ex_output = lv_fechax
                      ex_error  = ex_error.
          lv_fechai = lv_fechax.
          CLEAR lv_fechax.
        WHEN 'ValidoA'.
          CALL FUNCTION 'Y_ABAP_TO_INTERNAL_FORMAT'
            EXPORTING im_input  = ls_opt-low
            IMPORTING ex_output = lv_fechax
                      ex_error  = ex_error.
          lv_fechaf = lv_fechax.
          CLEAR lv_fechax.
        WHEN 'Usuario'.
          lv_usuario = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_cotizacion( EXPORTING i_org_ventas = lv_org_ventas
                                       i_oficina    = lv_oficina
                                       i_cliente    = lv_cliente
                                       i_fechai     = lv_fechai
                                       i_fechaf     = lv_fechaf
                                       i_usuario    = lv_usuario
                             IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD rejectedsalesset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_canal      TYPE tvakz-vtweg.

    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.

        WHEN 'Canal'.
          lv_canal = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_ventas_rechazadas( EXPORTING i_org_ventas = lv_org_ventas
                                              i_canal      = lv_canal
                                    IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD rejectionreasons_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.

    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'OrganizacionVenta'.
        lv_org_ventas = ls_opt-low.
      ENDIF.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_motivo_rechazo( EXPORTING i_org_ventas = lv_org_ventas
                                 IMPORTING rt_return    = et_entityset ).
  ENDMETHOD.


  METHOD routeset_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_ruta( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD salesareaset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_canal      TYPE tvakz-vtweg.
    DATA lv_sector     TYPE tvakz-spart.
    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
        WHEN 'Sector'.
          lv_sector = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    IF lv_org_ventas IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_area_venta( EXPORTING i_org_ventas = lv_org_ventas
                                         i_canal      = lv_canal
                                         i_sector     = lv_sector
                               IMPORTING rt_return    = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e14.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD salesgroupset_get_entityset.
    DATA lv_oficina TYPE tvbvk-vkbur.
    DATA lo_data    TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'OficinasVentas'.
        lv_oficina = ls_opt-low.
      ENDIF.

    ENDLOOP.

    IF lv_oficina IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_grupo_vendedores( EXPORTING i_oficina = lv_oficina
                                     IMPORTING rt_return = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e14.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD salesorderset_create_entity.
    DATA lo_data   TYPE REF TO ycl_sd_store_sales.
    DATA ls_data   TYPE ysd_s_001_ventas.
    DATA lt_data_h TYPE TABLE OF ysd_s_001_ventas.
    DATA lt_data_p TYPE TABLE OF ysd_s_001_ventas.
    DATA lv_flag   TYPE c LENGTH 1.
    DATA lv_tipo   TYPE c LENGTH 1.

    FIELD-SYMBOLS <fs_data_h> TYPE ysd_s_001_ventas.
    FIELD-SYMBOLS <fs_data_p> TYPE ysd_s_001_ventas.

    " Leer entrada JSON desde app
    io_data_provider->read_entry_data( IMPORTING es_data = ls_data ).

    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datah
                               CHANGING  data = lt_data_h ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_data-datap
                               CHANGING  data = lt_data_p ).

    IF lt_data_h IS NOT INITIAL AND lt_data_p IS NOT INITIAL.

      READ TABLE lt_data_h INTO DATA(ls_head) INDEX 1.
      lv_flag = ls_head-check.
      lv_tipo = ls_head-tipo.

      LOOP AT lt_data_h ASSIGNING <fs_data_h>.
        <fs_data_h>-cliente   = |{ <fs_data_h>-cliente ALPHA = IN }|.
        <fs_data_h>-bill_to   = |{ <fs_data_h>-bill_to ALPHA = IN }|.
        <fs_data_h>-documento = |{ <fs_data_h>-documento ALPHA = IN }|.
      ENDLOOP.

      LOOP AT lt_data_p ASSIGNING <fs_data_p>.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING input  = <fs_data_p>-articulo
          IMPORTING output = <fs_data_p>-articulo.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING input  = <fs_data_p>-unidad_medida
          IMPORTING output = <fs_data_p>-unidad_medida.
      ENDLOOP.

      lo_data = NEW #( ).

      CASE lv_flag.
        WHEN 'C'.
          lo_data->set_cotizacion( EXPORTING i_new_cotizacion_h = lt_data_h
                                             i_new_cotizacion_p = lt_data_p
                                   IMPORTING rt_return          = er_entity ).

        WHEN 'M'.
          lo_data->set_mod_cotizacion( EXPORTING i_new_cotizacion_h = lt_data_h
                                                 i_new_cotizacion_p = lt_data_p
                                       IMPORTING rt_return          = er_entity ).

        WHEN 'V'.
          CASE lv_tipo.
            WHEN 'P' OR 'R'.
              lo_data->set_venta_programada( EXPORTING i_new_ventap_h = lt_data_h
                                                       i_new_ventap_p = lt_data_p
                                             IMPORTING rt_return      = er_entity ).
            WHEN 'I'.
              lo_data->set_venta_inmediata( EXPORTING i_new_ventai_h = lt_data_h
                                                      i_new_ventai_p = lt_data_p
                                            IMPORTING rt_return      = er_entity ).
            WHEN OTHERS.
              er_entity-messcode = TEXT-e01.
              er_entity-message  = TEXT-e13.
          ENDCASE.

        WHEN 'F'.
          CASE lv_tipo.
            WHEN 'P'.
              lo_data->set_pedido_factura_p( EXPORTING i_new_pf_h = lt_data_h
                                                       i_new_pf_p = lt_data_p
                                             IMPORTING rt_return  = er_entity ).
            WHEN 'I'.
              lo_data->set_pedido_factura_i( EXPORTING i_new_pf_h = lt_data_h
                                                       i_new_pf_p = lt_data_p
                                             IMPORTING rt_return  = er_entity ).
            WHEN OTHERS.
              er_entity-messcode = TEXT-e01.
              er_entity-message  = TEXT-e13.
          ENDCASE.

        WHEN OTHERS.
          er_entity-messcode = TEXT-e01.
          er_entity-message  = TEXT-e11.
      ENDCASE.

    ELSE.
      er_entity-messcode = TEXT-e01.
      er_entity-message  = TEXT-e12.
    ENDIF.
  ENDMETHOD.


  METHOD salesorganizatio_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_org_ventas( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD saleszoneset_get_entityset.
    DATA lv_oficina TYPE tvbvk-vkbur.
    DATA lo_data    TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'OficinasVentas'.
        lv_oficina = ls_opt-low.
      ENDIF.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_zona_venta( EXPORTING i_oficina = lv_oficina
                             IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD searchconceptset_get_entityset.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    lo_data = NEW #( ).

    lo_data->get_concepto_busqueda( IMPORTING rt_return = et_entityset ).
  ENDMETHOD.


  METHOD sectorset_get_entityset.
    DATA lv_org_ventas TYPE tvakz-vkorg.
    DATA lv_canal      TYPE tvakz-vtweg.
    DATA lo_data       TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'OrganizacionVenta'.
          lv_org_ventas = ls_opt-low.
        WHEN 'Canal'.
          lv_canal = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    IF lv_org_ventas IS NOT INITIAL AND lv_canal IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_sector( EXPORTING i_org_ventas = lv_org_ventas
                                     i_canal      = lv_canal
                           IMPORTING rt_return    = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e14.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD storagelocations_get_entityset.
    DATA lv_centro   TYPE werks_d.
    DATA lv_articulo TYPE matnr.
    DATA lv_material TYPE matnr.
    DATA lo_data     TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE <ls_filter>-property.
        WHEN 'Articulo'.
          lv_articulo = ls_opt-low.
        WHEN 'Centro'.
          lv_centro = ls_opt-low.
      ENDCASE.

    ENDLOOP.

    IF lv_articulo IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING input  = lv_articulo
        IMPORTING output = lv_material.

      lo_data = NEW #( ).

      lo_data->get_almacen( EXPORTING i_articulo = lv_material
                                      i_centro   = lv_centro
                            IMPORTING rt_return  = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e14.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD storeset_get_entityset.
    DATA lv_sociedad TYPE bkpf-bukrs.
    DATA lo_data     TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'CjSoc'.
        lv_sociedad = ls_opt-low.
      ENDIF.

    ENDLOOP.

    IF lv_sociedad IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_tienda( EXPORTING i_sociedad = lv_sociedad
                           IMPORTING rt_return  = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e14.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD taxidset_get_entityset.
    DATA lv_nit  TYPE stcd1.
    DATA lo_data TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter>       TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_et_entityset> LIKE LINE OF et_entityset.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'NitCpd'.
        lv_nit = ls_opt-low.
      ENDIF.

    ENDLOOP.

    IF lv_nit IS NOT INITIAL.

      lo_data = NEW #( ).

      lo_data->get_nit( EXPORTING i_nit     = lv_nit
                        IMPORTING rt_return = et_entityset ).

    ELSE.

      APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_et_entityset>.
      <fs_et_entityset>-message  = TEXT-e10.
      <fs_et_entityset>-messcode = TEXT-e01.

    ENDIF.
  ENDMETHOD.


  METHOD toleranceset_get_entityset.
    DATA lv_grupo_articulo TYPE matkl.
    DATA lo_data           TYPE REF TO ycl_sd_store_sales.

    FIELD-SYMBOLS <ls_filter> TYPE /iwbep/s_mgw_select_option.

    LOOP AT it_filter_select_options ASSIGNING <ls_filter>.

      READ TABLE <ls_filter>-select_options INTO DATA(ls_opt) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_filter>-property = 'GrupoArticulos'.
        lv_grupo_articulo = ls_opt-low.
      ENDIF.

    ENDLOOP.

    lo_data = NEW #( ).

    lo_data->get_tolerancia( EXPORTING i_grupo_articulo = lv_grupo_articulo
                             IMPORTING rt_return        = et_entityset ).
  ENDMETHOD.
ENDCLASS.
