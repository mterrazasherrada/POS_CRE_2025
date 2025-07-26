CLASS ycl_sd_store_sales DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  " -----------------------------------------------------------------------
  " DECLARACIÓN DE LA SECCIÓN PÚBLICA                                   -
  " -----------------------------------------------------------------------
  PUBLIC SECTION.

    TYPES:
      " -----------------------------------------------------------------------
      " TIPOS GLOBALES                                                       -
      " -----------------------------------------------------------------------
      BEGIN OF gty_comparar,
        iguales TYPE boolean,
        message TYPE string,
      END OF gty_comparar .
    TYPES:
      gtyt_bapisditm  TYPE STANDARD TABLE OF bapisditm .
    TYPES:
      gtyt_bapiparnr  TYPE STANDARD TABLE OF bapiparnr .
    TYPES:
      gtyt_bapischdl  TYPE STANDARD TABLE OF bapischdl .
    TYPES:
      gtyt_bapicond   TYPE STANDARD TABLE OF bapicond .
    TYPES:
      gtyt_bapicondx  TYPE STANDARD TABLE OF bapicondx .
    TYPES:
      gtyt_bapisdtext TYPE STANDARD TABLE OF bapisdtext .
    TYPES:
      gtyt_bapiparex  TYPE STANDARD TABLE OF bapiparex .
    TYPES:
      gtyt_bapiaddr1  TYPE STANDARD TABLE OF bapiaddr1 .
    TYPES:
      gtyt_comparar   TYPE STANDARD TABLE OF gty_comparar .

    " -----------------------------------------------------------------------
    " VARIABLES GLOBALES                                                      -
    " -----------------------------------------------------------------------
    DATA gv_message TYPE string .
    DATA gwa_constantes TYPE yfi_t008_const_d .
    " -----------------------------------------------------------------------
    " CONSTANTES GLOBALES                                                      -
    " -----------------------------------------------------------------------
    CONSTANTS gc_error_400 TYPE char3 VALUE '400' ##NO_TEXT.
    CONSTANTS gc_error_401 TYPE char3 VALUE '401' ##NO_TEXT.
    CONSTANTS gc_error_402 TYPE char3 VALUE '402' ##NO_TEXT.
    CONSTANTS gc_msgid TYPE sy-msgid VALUE 'YSD001' ##NO_TEXT.
    " Constante para el nombre de la aplicación
    CONSTANTS gc_aplica TYPE yfi_t007_const_h-aplica VALUE 'VENTAS_MOSTRADOR' ##NO_TEXT.
    " Constantes para los códigos de grupo (CGROUP)
    CONSTANTS gc_cgroup_payhdr TYPE yfi_t007_const_h-cgroup VALUE 'PAYHDR' ##NO_TEXT.
    CONSTANTS gc_cgroup_paygl TYPE yfi_t007_const_h-cgroup VALUE 'PAY_GL' ##NO_TEXT.
    CONSTANTS gc_cgroup_payar TYPE yfi_t007_const_h-cgroup VALUE 'PAY_AR' ##NO_TEXT.
    CONSTANTS gc_cgroup_paypas TYPE yfi_t007_const_h-cgroup VALUE 'PAYPAS' ##NO_TEXT.
    CONSTANTS gc_zblart_cobro TYPE yfi_t008_const_d-zvalor VALUE 'ZBLART_COBRO' ##NO_TEXT.
    CONSTANTS gc_zblart_compensa TYPE yfi_t008_const_d-zvalor VALUE 'ZBLART_COMPENSA' ##NO_TEXT.
    CONSTANTS gc_zblart_mayor TYPE yfi_t008_const_d-zvalor VALUE 'ZBLART_MAYOR' ##NO_TEXT.
    CONSTANTS gc_zxblnr_compensa TYPE yfi_t008_const_d-zvalor VALUE 'ZXBLNR_COMPENSA' ##NO_TEXT.
    CONSTANTS gc_zaugtx_compensa TYPE yfi_t008_const_d-zvalor VALUE 'ZAUGTX_COMPENSA' ##NO_TEXT.
    CONSTANTS gc_zbktxt_compensa TYPE yfi_t008_const_d-zvalor VALUE 'ZBKTXT_COMPENSA' ##NO_TEXT.
    CONSTANTS gc_zxblnr_mecomp TYPE yfi_t008_const_d-zvalor VALUE 'ZXBLNR_MECOMP' ##NO_TEXT.
    CONSTANTS gc_zaugtx_mecomp TYPE yfi_t008_const_d-zvalor VALUE 'ZAUGTX_MECOMP' ##NO_TEXT.
    CONSTANTS gc_zbktxt_mecomp TYPE yfi_t008_const_d-zvalor VALUE 'ZBKTXT_MECOMP' ##NO_TEXT.
    CONSTANTS gc_zwaers_bob TYPE yfi_t008_const_d-zvalor VALUE 'ZWAERS_BOB' ##NO_TEXT.
    CONSTANTS gc_zprctr_gl TYPE yfi_t008_const_d-zvalor VALUE 'ZPRCTR_GL' ##NO_TEXT.
    CONSTANTS gc_znewbs_40 TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWBS_40' ##NO_TEXT.
    CONSTANTS gc_znewbs_50 TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWBS_50' ##NO_TEXT.
    CONSTANTS gc_zsgtxt_me TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT_ME' ##NO_TEXT.
    CONSTANTS gc_znewko_me TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWKO_ME' ##NO_TEXT.
    CONSTANTS gc_znewko_tarjeta TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWKO_TARJETA' ##NO_TEXT.
    CONSTANTS gc_zsgtxt_mecomp TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT_MECOMP' ##NO_TEXT.
    CONSTANTS gc_zmwskz_cliente TYPE yfi_t008_const_d-zvalor VALUE 'ZMWSKZ_CLIENTE' ##NO_TEXT.
    CONSTANTS gc_zprctr_cliente TYPE yfi_t008_const_d-zvalor VALUE 'ZPRCTR_CLIENTE' ##NO_TEXT.
    CONSTANTS gc_znewbs_15 TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWBS_15' ##NO_TEXT.
    CONSTANTS gc_zsgtxt_chpost TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT_CHPOST' ##NO_TEXT.
    CONSTANTS gc_znewko_tarjpos TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWKO_TARJPOS' ##NO_TEXT.
    CONSTANTS gc_zporc_tarjpos TYPE yfi_t008_const_d-zvalor VALUE 'ZPORC_TARJPOS' ##NO_TEXT.
    CONSTANTS gc_zsgtxt TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT' ##NO_TEXT.
    CONSTANTS gc_zwaers TYPE yfi_t008_const_d-zvalor VALUE 'ZWAERS' ##NO_TEXT.
    CONSTANTS gc_zlifnr_pos TYPE yfi_t008_const_d-zvalor VALUE 'ZLIFNR_POS' ##NO_TEXT.
    CONSTANTS gc_znewbs_21 TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWBS_21' ##NO_TEXT.
    CONSTANTS: gc_zsgtxt_dfcomp TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT_DFCOMP',
               gc_znewko_dfing  TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWKO_DFING',
               gc_znewko_dfegr  TYPE yfi_t008_const_d-zvalor VALUE 'ZNEWKO_DFEGR',
               gc_zsgtxt_cbcjmn TYPE yfi_t008_const_d-zvalor VALUE 'ZSGTXT_CBCJMN'.
    METHODS constructor .
    " -----------------------------------------------------------------------
    " DECLARACIÓN DE MÉTODOS PÚBLICOS                                     -
    " -----------------------------------------------------------------------
    " -----------------------------------------------------------------------
    " DECLARACIÓN DE LA SECCIÓN PROTEGIDA                                 -
    " -----------------------------------------------------------------------
    METHODS set_cotizacion
      IMPORTING
        !i_new_cotizacion_h TYPE ysd_tt_001_ventas
        !i_new_cotizacion_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return          TYPE ysd_s_001_ventas .
    METHODS set_mod_cotizacion
      IMPORTING
        !i_new_cotizacion_h TYPE ysd_tt_001_ventas
        !i_new_cotizacion_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return          TYPE ysd_s_001_ventas .
    METHODS set_venta_inmediata
      IMPORTING
        !i_new_ventai_h TYPE ysd_tt_001_ventas
        !i_new_ventai_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return      TYPE ysd_s_001_ventas .
    METHODS set_venta_programada
      IMPORTING
        !i_new_ventap_h TYPE ysd_tt_001_ventas
        !i_new_ventap_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return      TYPE ysd_s_001_ventas .
    METHODS set_pedido_factura_i
      IMPORTING
        !i_new_pf_h TYPE ysd_tt_001_ventas
        !i_new_pf_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return  TYPE ysd_s_001_ventas .
    METHODS set_pedido_factura_p
      IMPORTING
        !i_new_pf_h TYPE ysd_tt_001_ventas
        !i_new_pf_p TYPE ysd_tt_001_ventas
      EXPORTING
        !rt_return  TYPE ysd_s_001_ventas .
    METHODS get_area_venta
      IMPORTING
        !i_org_ventas TYPE tvakz-vkorg
        !i_canal      TYPE tvakz-vtweg
        !i_sector     TYPE tvakz-spart
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_grupo_vendedores
      IMPORTING
        !i_oficina TYPE tvbvk-vkbur
      EXPORTING
        !rt_return TYPE ysd_tt_002_ventas_info .
    METHODS get_tipoposicion
      IMPORTING
        !i_clasedocumento   TYPE auart OPTIONAL
        !i_motivoexpedicion TYPE vsbed OPTIONAL
      EXPORTING
        !rt_return          TYPE ysd_tt_002_ventas_info .
    METHODS get_material
      IMPORTING
        !i_articulo TYPE mara-matnr
        !i_centro   TYPE werks_ext
      EXPORTING
        !rt_return  TYPE ysd_tt_001_ventas .
    METHODS get_centro
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_cliente
      IMPORTING
        !i_cliente  TYPE kna1-kunnr
        !i_orgventa TYPE vkorg OPTIONAL
        !i_canal    TYPE vtweg OPTIONAL
        !i_sector   TYPE spart OPTIONAL
      EXPORTING
        !rt_return  TYPE ysd_tt_001_ventas .
    METHODS get_stock_disponible
      IMPORTING
        !i_centro              TYPE werks_d
        !i_articulo            TYPE matnr18
        !i_unidad_medida       TYPE meins
        !i_organizacion_ventas TYPE vkorg
      EXPORTING
        !rt_return             TYPE ysd_tt_010_stock_disponible .
    METHODS get_personal
      IMPORTING
        !i_solicitante TYPE pa0001-pernr
        !i_check       TYPE char1
      EXPORTING
        !rt_return     TYPE ysd_tt_001_ventas .
    METHODS get_canal
      IMPORTING
        !i_org_ventas TYPE tvkov-vkorg
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_clase_doc
      IMPORTING
        !i_org_ventas TYPE tvakz-vkorg
        !i_canal      TYPE tvakz-vtweg
        !i_sector     TYPE tvakz-spart
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_org_ventas
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_sector
      IMPORTING
        !i_org_ventas TYPE tvta-vkorg
        !i_canal      TYPE tvta-vtweg
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_ventas_diarias
      IMPORTING
        !i_org_ventas TYPE vkorg
        !i_canal      TYPE vtweg
        !i_sector     TYPE vbak-spart
        !i_fechai     TYPE char10
        !i_fechaf     TYPE char10
      EXPORTING
        !rt_return    TYPE ysd_tt_001_ventas .
    METHODS get_precio_descuento
      IMPORTING
        !i_articulo           TYPE matnr
        !i_org_ventas         TYPE vkorg
        !i_canal              TYPE vtweg
        !i_sector             TYPE spart
        !i_grupo_articulo     TYPE matkl
        !i_grupo_cliente      TYPE kdgrp
        !i_oficina_ventas     TYPE vkbur
        !i_zona_ventas        TYPE bzirk
        !i_grupo_cond_cliente TYPE kdkgr
        !i_solicitante        TYPE pernr
        !i_lista_precio       TYPE pltyp
        !i_condicion_pago     TYPE knvv-zterm
        !i_valido_a           TYPE char10 OPTIONAL
      EXPORTING
        !rt_return            TYPE ysd_tt_001_ventas .
    METHODS get_descuento
      IMPORTING
        !i_material           TYPE matnr
        !i_org_ventas         TYPE vkorg
        !i_canal              TYPE vtweg
        !i_sector             TYPE spart
        !i_grupo_articulo     TYPE matkl
        !i_grupo_cliente      TYPE kdgrp
        !i_oficina_ventas     TYPE vkbur
        !i_zona_ventas        TYPE bzirk
        !i_grupo_cond_cliente TYPE kdkgr
        !i_solicitante        TYPE kunag
        !i_lista_precio       TYPE pltyp
        !i_condicion_pago     TYPE knvv-zterm
        !i_valido_a           TYPE char10 OPTIONAL
      EXPORTING
        !rt_return            TYPE ysd_tt_005_descuento .
    METHODS get_descuentos_dinamicos
      IMPORTING
        !i_org_ventas TYPE vkorg
        !i_pantalla   TYPE yde_tipodoc
      EXPORTING
        !rt_return    TYPE ysd_tt_006_descuentos .
    METHODS get_ventas_rechazadas
      IMPORTING
        !i_org_ventas TYPE vkorg
        !i_canal      TYPE vtweg
      EXPORTING
        !rt_return    TYPE ysd_tt_001_ventas .
    METHODS get_flujo_documento
      IMPORTING
        !i_documento TYPE vbfa-vbeln
      EXPORTING
        !rt_return   TYPE ysd_tt_007_documento .
    METHODS get_ruta
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_motivo_pedido
      IMPORTING
        !i_org_ventas TYPE tvkov-vkorg
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_lote
      IMPORTING
        !i_articulo TYPE matnr
        !i_centro   TYPE werks_d
        !i_almacen  TYPE mchb-lgort
      EXPORTING
        !rt_return  TYPE ysd_tt_001_ventas .
    METHODS get_almacen
      IMPORTING
        !i_articulo TYPE matnr
        !i_centro   TYPE werks_d
      EXPORTING
        !rt_return  TYPE ysd_tt_001_ventas .
    METHODS get_articulo
      IMPORTING
        !i_centro  TYPE werks_ext
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_partidas_abiertas
      IMPORTING
        !i_sociedad TYPE bukrs
        !i_cliente  TYPE kunnr
      EXPORTING
        !rt_return  TYPE ysd_tt_009_cobros .
    METHODS get_tienda
      IMPORTING
        !i_sociedad TYPE bukrs
      EXPORTING
        !rt_return  TYPE ysd_tt_004_cobros_info .
    METHODS get_metodo_pago
      IMPORTING
        !i_org_ventas TYPE tvkov-vkorg
      EXPORTING
        !rt_return    TYPE ysd_tt_004_cobros_info .
    METHODS get_cuenta_banco
      EXPORTING
        !rt_return TYPE ysd_tt_004_cobros_info .
    METHODS get_cuenta_donacion
      EXPORTING
        !rt_return TYPE ysd_tt_004_cobros_info .
    METHODS get_division
      EXPORTING
        !rt_return TYPE ysd_tt_004_cobros_info .
    METHODS get_motivo_expedicion
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS set_cobro
      IMPORTING
        !i_new_cobro_h TYPE ysd_tt_003_contabilizar
        !i_new_cobro_p TYPE ysd_tt_003_contabilizar
        !i_new_cobro_c TYPE ysd_tt_003_contabilizar
      EXPORTING
        !rt_return     TYPE ysd_s_003_contabilizar
        !rt_doc        TYPE ysd_tt_011_fi_doc .
    METHODS get_cliente_pedido
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS set_cobro1
      IMPORTING
        !i_new_cobro_h TYPE ysd_tt_003_contabilizar
        !i_new_cobro_p TYPE ysd_tt_003_contabilizar
        !i_new_cobro_c TYPE ysd_tt_003_contabilizar
      EXPORTING
        !rt_return     TYPE ysd_s_003_contabilizar
        !rt_doc        TYPE ysd_tt_011_fi_doc .
    METHODS set_contabilizar
      IMPORTING
        !i_new_cobroe3_h TYPE ysd_tt_003_contabilizar
        !i_new_cobroe3_p TYPE ysd_tt_003_contabilizar
        !i_new_cobroe3_c TYPE ysd_tt_003_contabilizar
      EXPORTING
        !rt_return       TYPE ysd_s_003_contabilizar .
    METHODS set_cobro_automatico
      IMPORTING
        iv_invoice_belnr TYPE belnr_d
        iv_invoice_bukrs TYPE bukrs
        iv_invoice_bdate TYPE budat
        is_metodo_pago   TYPE yfi_t001_metpago
      EXPORTING
        es_return        TYPE ysd_s_003_contabilizar.
    METHODS get_beneficio
      IMPORTING
        !i_sociedad TYPE bukrs
      EXPORTING
        !rt_return  TYPE ysd_tt_001_ventas .
    METHODS get_nit
      IMPORTING
        !i_nit     TYPE stcd1
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_cotizacion
      IMPORTING
        !i_org_ventas TYPE vkorg
        !i_oficina    TYPE vbak-vkbur
        !i_cliente    TYPE vbak-kunnr
        !i_fechai     TYPE char10
        !i_fechaf     TYPE char10
        !i_usuario    TYPE uname
      EXPORTING
        !rt_return    TYPE ysd_tt_001_ventas .
    METHODS get_sociedad
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS set_etapa2_parcial
      IMPORTING
        !i_ftpost      TYPE ysd_tt_012_ftpost
        !i_ftclear     TYPE ysd_tt_013_ftclear
        !i_new_cobro_h TYPE ysd_tt_003_contabilizar
        !i_new_cobro_p TYPE ysd_tt_003_contabilizar
        !i_new_cobro_c TYPE ysd_tt_003_contabilizar
        !lv_ukurs_aux1 TYPE char10
        !lv_ukurs1     TYPE char10
        !lv_cliente    TYPE char1
        !a4            TYPE char24
        !la4           TYPE bseg-wrbtr
      EXPORTING
        !rt_return     TYPE ysd_s_003_contabilizar .
    METHODS get_motivo_rechazo
      IMPORTING
        !i_org_ventas TYPE tvkov-vkorg
      EXPORTING
        !rt_return    TYPE ysd_tt_002_ventas_info .
    METHODS get_tolerancia
      IMPORTING
        !i_grupo_articulo TYPE matkl
      EXPORTING
        !rt_return        TYPE ysd_tt_001_ventas .
    METHODS get_zona_venta
      IMPORTING
        !i_oficina TYPE tvbvk-vkbur OPTIONAL
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_grupo_articulo
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_jerarquia_producto
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_tipo_material
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_origen
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_concepto_busqueda
      EXPORTING
        !rt_return TYPE ysd_tt_001_ventas .
    METHODS get_compara_cotizacion
      IMPORTING
        !i_tipofactura          TYPE char1 OPTIONAL
        !i_order_header_in      TYPE bapisdhd1 OPTIONAL
        !i_order_items_in       TYPE gtyt_bapisditm OPTIONAL
        !i_order_partners       TYPE gtyt_bapiparnr OPTIONAL
        !i_order_schedules_in   TYPE gtyt_bapischdl OPTIONAL
        !i_order_conditions_in  TYPE gtyt_bapicond OPTIONAL
        !i_order_conditions_inx TYPE gtyt_bapicondx OPTIONAL
        !i_order_text           TYPE gtyt_bapisdtext OPTIONAL
        !i_extensionin          TYPE gtyt_bapiparex OPTIONAL
        !i_partneraddresses     TYPE gtyt_bapiaddr1 OPTIONAL
      EXPORTING
        !rt_response            TYPE gtyt_comparar .
    METHODS get_limite_factura
      IMPORTING
        !i_org_ventas   TYPE vkorg
        !i_oficina      TYPE vkbur OPTIONAL
        !i_cliente      TYPE vbak-kunnr OPTIONAL
        !i_destinatario TYPE vbak-kunnr OPTIONAL
        !i_nit          TYPE vbpa3-stcd1 OPTIONAL
      EXPORTING
        !rt_return      TYPE ysd_tt_008_limite_factura .
  PROTECTED SECTION.
    " -----------------------------------------------------------------------
    " DECLARACIÓN DE LA SECCIÓN PRIVADA                                   -
    " -----------------------------------------------------------------------

  PRIVATE SECTION.

    TYPES:
      " -----------------------------------------------------------------------
      " TIPOS LOCALES                                                        -
      " -----------------------------------------------------------------------
      BEGIN OF lty_vbpa3,
        vbeln TYPE vbeln,
        parvw TYPE parvw,
        stcd1 TYPE stcd1,
      END OF lty_vbpa3 .
    TYPES:
      BEGIN OF lty_dfkkbptaxnum,
        vbeln  TYPE vbeln,
        parvw  TYPE parvw,
        taxnum TYPE dfkkbptaxnum-taxnum,
      END OF lty_dfkkbptaxnum .

    " -----------------------------------------------------------------------
    " VARIABLES DE INSTANCIA PRIVADAS                                     -
    " -----------------------------------------------------------------------
    DATA gs_order_view TYPE order_view .
    DATA:
      gt_sales_documents      TYPE STANDARD TABLE OF sales_key .
    DATA:
      gt_order_headers_out    TYPE STANDARD TABLE OF bapisdhd .
    DATA:
      gt_order_items_out      TYPE STANDARD TABLE OF bapisdit .
    DATA:
      gt_order_business_out   TYPE STANDARD TABLE OF bapisdbusi .
    DATA:
      gt_order_partners_out   TYPE STANDARD TABLE OF bapisdpart .
    DATA:
      gt_order_address_out    TYPE STANDARD TABLE OF bapisdcoad .
    DATA:
      gt_order_conditions_out TYPE STANDARD TABLE OF bapisdcond .
    DATA:
      gt_order_textlines_out  TYPE STANDARD TABLE OF bapitextli .
    DATA:
      gt_vbpa3                TYPE STANDARD TABLE OF lty_vbpa3 .
    DATA:
      gt_dfkkbptaxnum         TYPE STANDARD TABLE OF lty_dfkkbptaxnum .
    DATA gv_difinterlocutor TYPE boolean .
    DATA gv_haydiferencias TYPE boolean .
    DATA gv_canta TYPE i .
    DATA gv_cantb TYPE i .
    DATA gv_tabixa TYPE sy-tabix .
    DATA gv_tabixb TYPE sy-tabix .
    DATA gv_cond_valuea TYPE kbetr .
    DATA gv_cond_valueb TYPE kbetr .
    DATA gv_contador TYPE i .
    DATA gv_sociedad TYPE bukrs .
    DATA gv_vendedor TYPE persno .
ENDCLASS.



CLASS ycl_sd_store_sales IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_ALMACEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ARTICULO                     TYPE        MATNR
* | [--->] I_CENTRO                       TYPE        WERKS_D
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_almacen.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtiene los almacenes donde existe stock positivo
    "^                    para un material y centro específico o general.
    "+---------------------------------------------------------------------+

    " Declaración de tipo para la estructura de MARD
    TYPES: BEGIN OF lty_mard,
             matnr TYPE mard-matnr,  ". Código de material
             werks TYPE mard-werks,  ". Centro
             lgort TYPE mard-lgort,  ". Almacén
           END OF lty_mard.

    " Declaración de tabla interna para los registros encontrados
    DATA lt_mard TYPE STANDARD TABLE OF lty_mard.        ". Lista de ubicaciones con stock
    DATA lv_msg TYPE string.                            ". Mensaje de error
    " Declaración de Field-Symbols para recorrer la tabla y manipular resultados
    FIELD-SYMBOLS <ls_mard>   TYPE lty_mard.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    " Consulta de stock según si se especificó centro o no
    IF i_centro IS INITIAL.

      " Buscar stock en cualquier centro
      SELECT matnr werks lgort
        FROM mard
        INTO TABLE lt_mard
        WHERE matnr = i_articulo
          AND labst > 0.

    ELSE.

      " Buscar stock en el centro indicado
      SELECT matnr werks lgort
        FROM mard
        INTO TABLE lt_mard
        WHERE matnr = i_articulo
          AND werks = i_centro
          AND labst > 0.

    ENDIF.

    IF lt_mard IS NOT INITIAL.

      LOOP AT lt_mard ASSIGNING <ls_mard>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-articulo = <ls_mard>-matnr.
        <ls_return>-centro   = <ls_mard>-werks.
        <ls_return>-almacen  = <ls_mard>-lgort.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '003' INTO lv_msg.
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_AREA_VENTA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVAKZ-VKORG
* | [--->] I_CANAL                        TYPE        TVAKZ-VTWEG
* | [--->] I_SECTOR                       TYPE        TVAKZ-SPART
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_area_venta.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtener Oficina de ventas según filtros proporcionados
    " -----------------------------------------------------------------------

    " Tipos locales
    TYPES: BEGIN OF lty_tvkbz,
             vkbur TYPE tvkbz-vkbur, " Oficina de ventas
             vkorg TYPE tvkbz-vkorg, " Organización de ventas
             vtweg TYPE tvkbz-vtweg, " Canal de distribución
             spart TYPE tvkbz-spart, " Sector
             bezei TYPE tvkbt-bezei, " Texto oficina de ventas
           END OF lty_tvkbz.

    DATA: lt_tvkbz TYPE STANDARD TABLE OF lty_tvkbz, " Resultado combinado
          lv_msg   TYPE string.                        " Texto de mensaje

    FIELD-SYMBOLS: <ls_tvkbz> TYPE lty_tvkbz,
                   <ls_ret>   LIKE LINE OF rt_return.

    IF i_org_ventas IS NOT INITIAL
    AND i_canal      IS NOT INITIAL
    AND i_sector     IS NOT INITIAL.

      " Filtro completo por área de ventas
      SELECT DISTINCT a~vkbur,
                      a~vkorg,
                      a~vtweg,
                      a~spart,
                      b~bezei
        INTO TABLE @lt_tvkbz
        FROM tvkbz AS a
        INNER JOIN tvkbt AS b ON b~vkbur = a~vkbur
        WHERE a~vkorg = @i_org_ventas
          AND a~vtweg = @i_canal
          AND a~spart = @i_sector
          AND b~spras = @sy-langu.

    ELSEIF i_org_ventas IS NOT INITIAL.

      " Filtro parcial solo por organización de ventas
      SELECT DISTINCT a~vkbur,
                      a~vkorg,
                      a~vtweg,
                      a~spart,
                      b~bezei
        INTO TABLE @lt_tvkbz
        FROM tvkbz AS a
        INNER JOIN tvkbt AS b ON b~vkbur = a~vkbur
        WHERE a~vkorg = @i_org_ventas
          AND b~spras = @sy-langu.

    ELSE.

      " Sin filtros
      SELECT DISTINCT a~vkbur,
                      a~vkorg,
                      a~vtweg,
                      a~spart,
                      b~bezei
        INTO TABLE @lt_tvkbz
        FROM tvkbz AS a
        INNER JOIN tvkbt AS b ON b~vkbur = a~vkbur
        WHERE b~spras = @sy-langu.

    ENDIF.

    IF lt_tvkbz IS NOT INITIAL.

      LOOP AT lt_tvkbz ASSIGNING <ls_tvkbz>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.

        <ls_ret>-oficinas_ventas    = <ls_tvkbz>-vkbur.
        <ls_ret>-organizacion_venta = <ls_tvkbz>-vkorg.
        <ls_ret>-area_venta         = <ls_tvkbz>-vkorg.
        <ls_ret>-canal              = <ls_tvkbz>-vtweg.
        <ls_ret>-sector             = <ls_tvkbz>-spart.
        <ls_ret>-denominacion_ov    = <ls_tvkbz>-bezei.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message   = lv_msg.
      <ls_ret>-messcode  = gc_error_400.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_ARTICULO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CENTRO                       TYPE        WERKS_EXT
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_articulo.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta de stock disponible por material en centro y almacén.
    " -----------------------------------------------------------------------

    " Declaración de Tipos Locales
    TYPES: BEGIN OF lty_mara,
             matnr TYPE mara-matnr, " Código de material
             meins TYPE mara-meins, " Unidad de medida
             matkl TYPE mara-matkl, " Grupo de artículos
             brgew TYPE mara-brgew, " Peso bruto
             ntgew TYPE mara-ntgew, " Peso neto
           END OF lty_mara.

    TYPES: BEGIN OF lty_makt,
             matnr TYPE makt-matnr, " Código de material
             maktx TYPE makt-maktx, " Descripción breve
           END OF lty_makt.

    TYPES: BEGIN OF lty_mchb,
             matnr TYPE mchb-matnr, " Código de material
             werks TYPE mchb-werks, " Centro
             charg TYPE mchb-charg, " Lote
             lgort TYPE mchb-lgort, " Almacén
           END OF lty_mchb.

    " Declaración de Variables Locales
    DATA lt_mara             TYPE STANDARD TABLE OF lty_mara.                      " Lista de materiales
    DATA lt_makt             TYPE STANDARD TABLE OF lty_makt.                      " Lista de textos de materiales
    DATA lt_mchb             TYPE STANDARD TABLE OF lty_mchb.                      " Lista de lotes disponibles
    DATA lt_wmdvsx           TYPE STANDARD TABLE OF bapiwmdvs.                      " Datos de disponibilidad
    DATA lt_wmdvex           TYPE STANDARD TABLE OF bapiwmdve.                      " Resultados de disponibilidad
    DATA ls_wmard            TYPE mard.              " Datos de stock
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_return           TYPE bapireturn.        " Retorno de BAPI
    DATA lv_com_qty          TYPE bapiwmdve-com_qty. " Cantidad disponible BAPI
    DATA lv_labst            TYPE mard-labst.        " Stock libre uso
    DATA lv_stock_disponible TYPE mard-labst.        " Stock disponible calculado
    DATA lv_lote             TYPE mchb-charg.
    DATA lv_almacen          TYPE mchb-lgort.
    DATA lv_centro           TYPE mchb-werks.

    " Declaración de Field-Symbols
    FIELD-SYMBOLS <ls_mara>   TYPE lty_mara.
    FIELD-SYMBOLS <ls_makt>   TYPE lty_makt.
    FIELD-SYMBOLS <ls_mchb>   TYPE lty_mchb.
    FIELD-SYMBOLS <ls_wmdvex> TYPE bapiwmdve.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    " Leer materiales
    SELECT matnr meins matkl brgew ntgew
      FROM mara
      INTO TABLE lt_mara.

    IF lt_mara IS NOT INITIAL.

      " Leer textos de materiales
      SELECT matnr maktx FROM makt
        INTO TABLE lt_makt
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr.

      " Leer lotes disponibles para el centro solicitado
      SELECT matnr werks charg lgort FROM mchb
        INTO TABLE lt_mchb
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr
          AND werks = i_centro
          AND clabs > 0.

      LOOP AT lt_mara ASSIGNING <ls_mara>.

        " Consultar disponibilidad con BAPI
        CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
          EXPORTING
            plant      = i_centro
            material   = <ls_mara>-matnr
            unit       = <ls_mara>-meins
            check_rule = 'A'
          IMPORTING
            return     = ls_return
          TABLES
            wmdvsx     = lt_wmdvsx
            wmdvex     = lt_wmdvex.

        IF lt_wmdvex IS NOT INITIAL.
          ASSIGN lt_wmdvex[ 1 ] TO <ls_wmdvex>.
          IF sy-subrc = 0.
            lv_com_qty = <ls_wmdvex>-com_qty.
          ENDIF.
        ENDIF.

        " Cargar datos del lote
        ASSIGN lt_mchb[ matnr = <ls_mara>-matnr
                        werks = i_centro ] TO <ls_mchb>.
        IF sy-subrc = 0.
          lv_lote    = <ls_mchb>-charg.
          lv_almacen = <ls_mchb>-lgort.
          lv_centro  = <ls_mchb>-werks.
        ENDIF.
        " Leer stock actual del almacén
        CALL FUNCTION 'MARD_SINGLE_READ'
          EXPORTING
            matnr = <ls_mara>-matnr
            werks = i_centro
            lgort = lv_almacen
          IMPORTING
            wmard = ls_wmard.

        lv_labst = ls_wmard-labst.
        lv_stock_disponible = lv_com_qty - lv_labst.

        IF lv_stock_disponible > 0.
          " Armar estructura de retorno
          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          <ls_return>-stock_disponible = lv_stock_disponible.
          <ls_return>-articulo         = <ls_mara>-matnr.
          <ls_return>-unidad_medida    = <ls_mara>-meins.
          <ls_return>-grupo_articulos  = <ls_mara>-matkl.

          " Cargar pesos si aplica
          IF <ls_return>-unidad_medida = 'KG'.
            <ls_return>-peso_bruto = 1.
            <ls_return>-peso_neto  = 1.
          ELSE.
            <ls_return>-peso_bruto = <ls_mara>-brgew.
            <ls_return>-peso_neto  = <ls_mara>-ntgew.
          ENDIF.

          " Cargar descripción
          ASSIGN lt_makt[ matnr = <ls_mara>-matnr ] TO <ls_makt>.
          IF sy-subrc = 0.
            <ls_return>-descripcion = <ls_makt>-maktx.
          ENDIF.

          " Cargar datos del lote
          <ls_return>-lote    = lv_lote.
          <ls_return>-almacen = lv_almacen.
          <ls_return>-centro  = lv_centro.

        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_message).
      <ls_return>-message  = lv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_BENEFICIO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_SOCIEDAD                     TYPE        BUKRS
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_beneficio.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta de centros de beneficio por sociedad
    "                      Retorna los centros de beneficio y su descripción
    " -----------------------------------------------------------------------

    " Tipos locales
    TYPES: BEGIN OF lty_cepct,
             prctr TYPE cepct-prctr,    ". Centro de beneficio
             ktext TYPE cepct-ktext,    ". Descripción del centro
             spras TYPE cepct-spras,    ". Idioma
             kokrs TYPE cepct-kokrs,    ". Sociedad de controlling
           END OF lty_cepct.

    " Variables locales
    DATA: lt_cepct TYPE STANDARD TABLE OF lty_cepct.

    " Field-symbols
    FIELD-SYMBOLS: <ls_cepct>  TYPE lty_cepct,
                   <ls_return> LIKE LINE OF rt_return.

    " Consulta de centros de beneficio por sociedad
    SELECT prctr ktext spras kokrs
      FROM cepct
      INTO TABLE lt_cepct
      WHERE kokrs = i_sociedad
        AND spras = 'S'.

    IF lt_cepct IS NOT INITIAL.
      LOOP AT lt_cepct ASSIGNING <ls_cepct>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-beneficio   = <ls_cepct>-prctr.
        <ls_return>-descripcion = <ls_cepct>-ktext.
      ENDLOOP.
    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CANAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVKOV-VKORG
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_canal.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtener lista de canales de distribución por organización
    " -----------------------------------------------------------------------

    " Tipos locales
    TYPES: BEGIN OF lty_tvkov_join,
             vkorg TYPE tvkov-vkorg,  " Organización de ventas
             vtweg TYPE tvkov-vtweg,  " Canal de distribución
             vtext TYPE tvtwt-vtext,  " Denominación del canal
           END OF lty_tvkov_join.

    DATA: lt_result TYPE STANDARD TABLE OF lty_tvkov_join,
          lv_msg    TYPE string.

    FIELD-SYMBOLS: <ls_result> TYPE lty_tvkov_join,
                   <ls_ret>    LIKE LINE OF rt_return.

    IF i_org_ventas IS NOT INITIAL.

      " Obtener canales filtrados por organización de ventas
      SELECT a~vkorg,
             a~vtweg,
             b~vtext
        INTO TABLE @lt_result
        FROM tvkov AS a
        INNER JOIN tvtwt AS b
          ON a~vtweg = b~vtweg
        WHERE a~vkorg = @i_org_ventas
          AND b~spras = @sy-langu.

    ELSE.

      " Obtener todos los canales sin filtro por organización
      SELECT a~vkorg,
             a~vtweg,
             b~vtext
        INTO TABLE @lt_result
        FROM tvkov AS a
        INNER JOIN tvtwt AS b
          ON a~vtweg = b~vtweg
        WHERE b~spras = @sy-langu.

    ENDIF.


    IF lt_result IS NOT INITIAL.

      LOOP AT lt_result ASSIGNING <ls_result>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-organizacion_venta = <ls_result>-vkorg.
        <ls_ret>-canal              = <ls_result>-vtweg.
        <ls_ret>-denominacion_ov    = <ls_result>-vtext.
      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message   = lv_msg.
      <ls_ret>-messcode  = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CENTRO
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_centro.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtiene la lista de centros y sus descripciones
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t001w,
             werks TYPE t001w-werks, " Código del centro
             name1 TYPE t001w-name1, " Nombre del centro
           END OF lty_t001w.

    " Declaración de tabla interna
    DATA lt_t001w TYPE STANDARD TABLE OF lty_t001w.

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_t001w>   TYPE lty_t001w.       " Registro de centro
    FIELD-SYMBOLS <ls_return>  LIKE LINE OF rt_return. " Registro de retorno

    " Leer todos los centros disponibles
    SELECT werks, name1
      FROM t001w
      INTO TABLE @lt_t001w.

    IF lt_t001w IS NOT INITIAL.

      LOOP AT lt_t001w ASSIGNING <ls_t001w>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-centro      = <ls_t001w>-werks.
        <ls_return>-descripcion = <ls_t001w>-name1.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CLASE_DOC
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVAKZ-VKORG
* | [--->] I_CANAL                        TYPE        TVAKZ-VTWEG
* | [--->] I_SECTOR                       TYPE        TVAKZ-SPART
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_clase_doc.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtener lista de clases de documento por combinación
    "                      de organización de ventas, canal y sector.
    " -----------------------------------------------------------------------

    TYPES: BEGIN OF lty_tvakz,
             vkorg TYPE tvakz-vkorg,   " Organización de ventas
             vtweg TYPE tvakz-vtweg,   " Canal de distribución
             spart TYPE tvakz-spart,   " Sector
             auart TYPE tvakz-auart,   " Clase de documento
             bezei TYPE tvakt-bezei,   " Descripción de clase de documento
           END OF lty_tvakz.

    DATA lt_tvakz TYPE STANDARD TABLE OF lty_tvakz.

    DATA lv_msg TYPE string.

    FIELD-SYMBOLS: <ls_tvakz> TYPE lty_tvakz,
                   <ls_ret>   LIKE LINE OF rt_return.

    IF     i_org_ventas IS NOT INITIAL
       AND i_canal      IS NOT INITIAL
       AND i_sector     IS NOT INITIAL.

      SELECT DISTINCT a~vkorg,
                      a~vtweg,
                      a~spart,
                      a~auart,
                      b~bezei
        FROM tvakz AS a
        INNER JOIN tvakt AS b
          ON b~auart = a~auart
         AND b~spras = @sy-langu
        WHERE a~vkorg = @i_org_ventas
          AND a~vtweg = @i_canal
          AND a~spart = @i_sector
        INTO TABLE @lt_tvakz.

    ELSE.

      SELECT DISTINCT a~vkorg,
                      a~vtweg,
                      a~spart,
                      a~auart,
                      b~bezei
        INTO TABLE @lt_tvakz
        FROM tvakz AS a
        INNER JOIN tvakt AS b
          ON b~auart = a~auart
         AND b~spras = @sy-langu.

    ENDIF.

    IF lt_tvakz IS NOT INITIAL.

      SORT lt_tvakz BY vkorg auart.
      DELETE ADJACENT DUPLICATES FROM lt_tvakz COMPARING vkorg auart.

      LOOP AT lt_tvakz ASSIGNING <ls_tvakz>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-organizacion_venta = <ls_tvakz>-vkorg.
        <ls_ret>-canal              = <ls_tvakz>-vtweg.
        <ls_ret>-sector             = <ls_tvakz>-spart.
        <ls_ret>-clase_documento    = <ls_tvakz>-auart.
        <ls_ret>-denominacion_ov    = <ls_tvakz>-bezei.
      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message   = lv_msg.
      <ls_ret>-messcode  = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CLIENTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CLIENTE                      TYPE        KNA1-KUNNR
* | [--->] I_ORGVENTA                     TYPE        VKORG(optional)
* | [--->] I_CANAL                        TYPE        VTWEG(optional)
* | [--->] I_SECTOR                       TYPE        SPART(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cliente.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtener información general de clientes incluyendo
    "^                    datos maestros, direcciones y datos comerciales.
    "+---------------------------------------------------------------------+

    TYPES: BEGIN OF lty_kna1,
             kunnr TYPE kna1-kunnr,   " Cliente
             name1 TYPE kna1-name1,   " Nombre
             name2 TYPE kna1-name2,
             name3 TYPE kna1-name3,
             adrnr TYPE kna1-adrnr,   " Dirección
             stras TYPE kna1-stras,   " Calle
             telf1 TYPE kna1-telf1,   " Teléfono
             land1 TYPE kna1-land1,   " País
             stcd1 TYPE kna1-stcd1,   " NIT
             kdkg1 TYPE kna1-kdkg1,   " Grupo cond. 1
             xcpdk TYPE kna1-xcpdk,   " Cliente CPD
             ort01 TYPE kna1-ort01,   " Ciudad
             sortl TYPE kna1-sortl,   " Clasificación
           END OF lty_kna1.

    TYPES: BEGIN OF lty_knvv,
             kunnr TYPE knvv-kunnr,
             kdgrp TYPE knvv-kdgrp,
             bzirk TYPE knvv-bzirk,
             pltyp TYPE knvv-pltyp,
             konda TYPE knvv-konda,
             waers TYPE knvv-waers,
             spart TYPE knvv-spart,
             zterm TYPE knvv-zterm,
             kkber TYPE knvv-kkber,
           END OF lty_knvv.

    TYPES: BEGIN OF lty_but000,
             partner    TYPE but000-partner,
             bu_group   TYPE but000-bu_group,
             bu_sort1   TYPE but000-bu_sort1,
             type       TYPE but000-type,
             name_org1  TYPE but000-name_org1,
             name_org2  TYPE but000-name_org2,
             name_org3  TYPE but000-name_org3,
             name_last  TYPE but000-name_last,
             name_first TYPE but000-name_first,
             name_lst2  TYPE but000-name_lst2,
             name_last2 TYPE but000-name_last2,
             namemiddle TYPE but000-namemiddle,
           END OF lty_but000.

    TYPES: BEGIN OF lty_adrc,
             addrnumber TYPE adrc-addrnumber,
             street     TYPE adrc-street,
           END OF lty_adrc.

    DATA: lt_kna1   TYPE STANDARD TABLE OF lty_kna1,
          lt_knvv   TYPE STANDARD TABLE OF lty_knvv,
          lt_but000 TYPE STANDARD TABLE OF lty_but000,
          lt_adrc   TYPE STANDARD TABLE OF lty_adrc,
          lv_msg    TYPE string.

    FIELD-SYMBOLS: <ls_kna1>   TYPE lty_kna1,
                   <ls_knvv>   TYPE lty_knvv,
                   <ls_but000> TYPE lty_but000,
                   <ls_adrc>   TYPE lty_adrc,
                   <ls_return> LIKE LINE OF rt_return.

    " Obtener datos maestros del cliente
    IF i_cliente IS INITIAL.

      SELECT kunnr name1 name2 name3 adrnr stras telf1 land1 stcd1 kdkg1 xcpdk ort01 sortl
        FROM kna1
        INTO TABLE lt_kna1.

    ELSE.

      SELECT kunnr name1 name2 name3 adrnr stras telf1 land1 stcd1 kdkg1 xcpdk ort01 sortl
        FROM kna1
        INTO TABLE lt_kna1
        WHERE kunnr = i_cliente.

    ENDIF.

    IF lt_kna1 IS NOT INITIAL.

      " Direcciones completas
      SELECT addrnumber street
        FROM adrc
        INTO TABLE lt_adrc
        FOR ALL ENTRIES IN lt_kna1
        WHERE addrnumber = lt_kna1-adrnr.

      " Datos comerciales del cliente
      IF i_orgventa IS NOT INITIAL AND i_canal IS NOT INITIAL AND i_sector IS NOT INITIAL.
        SELECT kunnr kdgrp bzirk pltyp konda waers spart zterm kkber
          FROM knvv
          INTO TABLE lt_knvv
          FOR ALL ENTRIES IN lt_kna1
          WHERE kunnr = lt_kna1-kunnr
            AND vkorg = i_orgventa
            AND vtweg = i_canal
            AND spart = i_sector.
      ELSE.
        SELECT kunnr kdgrp bzirk pltyp konda waers spart zterm kkber
          FROM knvv
          INTO TABLE lt_knvv
          FOR ALL ENTRIES IN lt_kna1
          WHERE kunnr = lt_kna1-kunnr.
      ENDIF.

      " Datos adicionales del cliente (BUT000) TODO
      SELECT partner, bu_group, bu_sort1, type, name_org1, name_org2, name_org3, name_last, name_first, name_lst2, name_last2, namemiddle
        FROM but000
        INTO TABLE @lt_but000
        FOR ALL ENTRIES IN @lt_kna1
        WHERE partner = @lt_kna1-kunnr.
*{TODO
      DATA: lt_valid_kunnr_rng TYPE RANGE OF kna1-kunnr,
            ls_valid_kunnr_rng LIKE LINE OF lt_valid_kunnr_rng.

      " Construir el RANGE con los clientes válidos
      CLEAR lt_valid_kunnr_rng.
      LOOP AT lt_knvv ASSIGNING <ls_knvv>.
        CLEAR ls_valid_kunnr_rng.
        ls_valid_kunnr_rng-sign   = 'I'.
        ls_valid_kunnr_rng-option = 'EQ'.
        ls_valid_kunnr_rng-low    = <ls_knvv>-kunnr.
        APPEND ls_valid_kunnr_rng TO lt_valid_kunnr_rng.
      ENDLOOP.

      " Eliminar clientes sin datos comerciales
      DELETE lt_kna1 WHERE kunnr NOT IN lt_valid_kunnr_rng.

*}TODO
      LOOP AT lt_kna1 ASSIGNING <ls_kna1>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.

*        <ls_return>-referencia_cliente = <ls_kna1>-name1 && <ls_kna1>-name2 && <ls_kna1>-name3."DELETE @100
        CONCATENATE <ls_kna1>-name1 <ls_kna1>-name2 <ls_kna1>-name3 INTO <ls_return>-referencia_cliente SEPARATED BY space."INSERT @100
        <ls_return>-direccion          = <ls_kna1>-adrnr.
        <ls_return>-cliente            = <ls_kna1>-kunnr.
        <ls_return>-telefono           = <ls_kna1>-telf1.
        <ls_return>-pais               = <ls_kna1>-land1.
        <ls_return>-nit                = <ls_kna1>-stcd1.
        <ls_return>-grupo_cond_client  = <ls_kna1>-kdkg1.
        <ls_return>-cliente_cpd        = <ls_kna1>-xcpdk.
        <ls_return>-poblacion          = <ls_kna1>-ort01.
        <ls_return>-concepto_busqueda  = <ls_kna1>-sortl."INSERT @100
        ASSIGN lt_adrc[ addrnumber = <ls_kna1>-adrnr ] TO <ls_adrc>.
        IF sy-subrc = 0.
          <ls_return>-direccion2 = <ls_adrc>-street.
        ENDIF.
        ASSIGN lt_knvv[ kunnr = <ls_kna1>-kunnr ] TO <ls_knvv>.
        IF sy-subrc = 0.
          <ls_return>-grupo_cliente   = <ls_knvv>-kdgrp.
          <ls_return>-zona_venta      = <ls_knvv>-bzirk.
          <ls_return>-tipo_precio     = <ls_knvv>-pltyp.
          <ls_return>-grupo_precio    = <ls_knvv>-konda.
          <ls_return>-moneda          = <ls_knvv>-waers.
          <ls_return>-sector          = <ls_knvv>-spart.
          <ls_return>-condicion_pago  = <ls_knvv>-zterm.
          <ls_return>-cliente_credito = <ls_knvv>-kkber.
        ENDIF.

        ASSIGN lt_but000[ partner = <ls_kna1>-kunnr ] TO <ls_but000>.
        IF sy-subrc = 0.
          <ls_return>-agrup_comerciales = <ls_but000>-bu_group.
*          <ls_return>-concepto_busqueda = <ls_but000>-bu_sort1."DELETE @100
          IF <ls_kna1>-xcpdk = abap_false AND <ls_but000>-type = 2. " No es prodiverso|Es Empresa
            <ls_return>-referencia_cliente = <ls_but000>-name_org1 && <ls_but000>-name_org2 && <ls_but000>-name_org3.
            REPLACE `  ` IN <ls_return>-referencia_cliente WITH ` `.
          ELSEIF <ls_kna1>-xcpdk = abap_false AND <ls_but000>-type <> 2. " No es prodiverso|Es Persona
            <ls_return>-referencia_cliente = |{ <ls_but000>-name_first } { <ls_but000>-namemiddle } { <ls_but000>-name_last } { <ls_but000>-name_lst2 } { <ls_but000>-name_last2 }|.
            REPLACE `  ` IN <ls_return>-referencia_cliente WITH ` `.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CLIENTE_PEDIDO
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cliente_pedido.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta referencias de cliente en pedidos de ventas
    "                      Retorna una lista agrupada de referencias encontradas
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_vbkd,
             bstkd TYPE vbkd-bstkd,    ". Referencia del cliente
           END OF lty_vbkd.

    " Declaración de variables locales
    DATA lt_vbkd TYPE STANDARD TABLE OF lty_vbkd.           ". Tabla de resultados agrupados

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_vbkd>   TYPE lty_vbkd,                ". Registro de referencia de cliente
                   <ls_return> LIKE LINE OF rt_return.      ". Registro de la tabla de retorno

    " Consulta referencias únicas de cliente en los pedidos
    SELECT bstkd
      FROM vbkd
      INTO TABLE lt_vbkd
      UP TO 1000000 ROWS
      GROUP BY bstkd.

    IF lt_vbkd IS NOT INITIAL.

      LOOP AT lt_vbkd ASSIGNING <ls_vbkd>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-referencia_cliente = <ls_vbkd>-bstkd.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message   = lv_msg.
      <ls_return>-messcode  = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_COMPARA_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TIPOFACTURA                  TYPE        CHAR1(optional)
* | [--->] I_ORDER_HEADER_IN              TYPE        BAPISDHD1(optional)
* | [--->] I_ORDER_ITEMS_IN               TYPE        GTYT_BAPISDITM(optional)
* | [--->] I_ORDER_PARTNERS               TYPE        GTYT_BAPIPARNR(optional)
* | [--->] I_ORDER_SCHEDULES_IN           TYPE        GTYT_BAPISCHDL(optional)
* | [--->] I_ORDER_CONDITIONS_IN          TYPE        GTYT_BAPICOND(optional)
* | [--->] I_ORDER_CONDITIONS_INX         TYPE        GTYT_BAPICONDX(optional)
* | [--->] I_ORDER_TEXT                   TYPE        GTYT_BAPISDTEXT(optional)
* | [--->] I_EXTENSIONIN                  TYPE        GTYT_BAPIPAREX(optional)
* | [--->] I_PARTNERADDRESSES             TYPE        GTYT_BAPIADDR1(optional)
* | [<---] RT_RESPONSE                    TYPE        GTYT_COMPARAR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_compara_cotizacion.

    " Field-Symbols :
    FIELD-SYMBOLS <fs_response>                TYPE gty_comparar.
    FIELD-SYMBOLS <fs_sales_documents>         LIKE LINE OF gt_sales_documents.
    FIELD-SYMBOLS <fs_order_partners_out>      LIKE LINE OF gt_order_partners_out.
    FIELD-SYMBOLS <fs_order_headers_out>       LIKE LINE OF gt_order_headers_out.
    FIELD-SYMBOLS <fs_order_business_out>      LIKE LINE OF gt_order_business_out.
    FIELD-SYMBOLS <fs_order_address_out>       LIKE LINE OF gt_order_address_out.
    FIELD-SYMBOLS <fs_order_items_out>         LIKE LINE OF gt_order_items_out.
    FIELD-SYMBOLS <fs_order_conditions_out>    LIKE LINE OF gt_order_conditions_out.
    FIELD-SYMBOLS <fs_order_textlines_out>     LIKE LINE OF gt_order_textlines_out.
    FIELD-SYMBOLS <fs_vbpa3>                   LIKE LINE OF gt_vbpa3.
    FIELD-SYMBOLS <fs_quotation_partners>      LIKE LINE OF i_order_partners.
    FIELD-SYMBOLS <fs_quotation_items_in>      LIKE LINE OF i_order_items_in.
    FIELD-SYMBOLS <fs_extensionin>             LIKE LINE OF i_extensionin.
    FIELD-SYMBOLS <fs_partneraddresses>        LIKE LINE OF i_partneraddresses.
    FIELD-SYMBOLS <fs_quotation_conditions_in> LIKE LINE OF i_order_conditions_in.
    FIELD-SYMBOLS <fs_quotation_text>          LIKE LINE OF i_order_text.

    DATA lr_cond_type TYPE RANGE OF kscha.


    CLEAR gs_order_view.

    APPEND INITIAL LINE TO rt_response ASSIGNING <fs_response>.
    <fs_response>-iguales = 'X'.
    "Parámeters Get data SAP
    gs_order_view-business = 'X'.
    gs_order_view-text     = gs_order_view-business.
    gs_order_view-sdcond   = gs_order_view-text.
    gs_order_view-address  = gs_order_view-sdcond.
    gs_order_view-partner  = gs_order_view-address.
    gs_order_view-item     = gs_order_view-partner.
    gs_order_view-header   = gs_order_view-item.
    APPEND INITIAL LINE TO gt_sales_documents ASSIGNING <fs_sales_documents>. " Documento de cotización
    <fs_sales_documents>-vbeln = i_order_header_in-ref_doc.

    CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
      EXPORTING
        i_bapi_view          = gs_order_view          " Vistas
      TABLES
        sales_documents      = gt_sales_documents     " Cotizacion
        order_headers_out    = gt_order_headers_out   " Datos de cabecera|VBAK
        order_items_out      = gt_order_items_out
        order_business_out   = gt_order_business_out  " Datos comerciales|VBKD
        order_partners_out   = gt_order_partners_out
        order_address_out    = gt_order_address_out
        order_conditions_out = gt_order_conditions_out
        order_textlines_out  = gt_order_textlines_out.

    " / Mismas cantidad de items?
    CLEAR: gv_canta,
           gv_cantb.
    gv_canta = lines( gt_order_items_out ).

    DATA(lt_i_order_items_in) = i_order_items_in[].
    DELETE ADJACENT DUPLICATES FROM lt_i_order_items_in COMPARING itm_number.
    gv_cantb = lines( lt_i_order_items_in ).
    IF gv_canta <> gv_cantb.
      <fs_response>-iguales = ''.
      <fs_response>-message = 'La cantidad de items ha cambiado.'.
      RETURN.
    ENDIF.

    " 1. Cabecera|VBAK|VBKD
    ASSIGN gt_order_headers_out[ 1 ] TO <fs_order_headers_out>.
    IF sy-subrc = 0.
      ASSIGN gt_order_business_out[ 1 ] TO <fs_order_business_out>.
      IF sy-subrc = 0.
        IF    i_order_header_in-sales_org  <> <fs_order_headers_out>-sales_org
           OR i_order_header_in-distr_chan <> <fs_order_headers_out>-distr_chan
           OR i_order_header_in-division   <> <fs_order_headers_out>-division
           OR i_order_header_in-sales_grp  <> <fs_order_headers_out>-sales_grp
           OR i_order_header_in-sales_off  <> <fs_order_headers_out>-sales_off
           OR i_order_header_in-sales_dist <> <fs_order_business_out>-sales_dist
           OR i_order_header_in-pmnttrms   <> <fs_order_business_out>-pmnttrms
           OR i_order_header_in-ord_reason <> <fs_order_headers_out>-ord_reason
           OR i_order_header_in-qt_valid_t <> <fs_order_headers_out>-qt_valid_t
           OR i_order_header_in-ship_cond  <> <fs_order_headers_out>-ship_cond
           OR i_order_header_in-pp_search  <> <fs_order_headers_out>-sear_prpr.
          <fs_response>-iguales = ''.
          <fs_response>-message = 'La cabecera ha cambiado.'.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    " 2. Interlocutores "3. Direccion
    DATA(ycl_sd_utility) = NEW ycl_sd_utility( ).
    CALL METHOD ycl_sd_utility->get_data_nit
      EXPORTING
        ip_client       = sy-mandt
        ip_vbeln        = <fs_sales_documents>-vbeln
      IMPORTING
        ex_vbpa3        = gt_vbpa3 "DATA(lt_vbpa3)
        ex_dfkkbptaxnum = gt_dfkkbptaxnum. "DATA(lt_dfkkbptaxnum).
    LOOP AT gt_order_partners_out ASSIGNING <fs_order_partners_out>.

      CASE <fs_order_partners_out>-partn_role.

        WHEN 'AG'. " AG - PE
          " Verificación NIT
          ASSIGN i_extensionin[ valuepart1(2) = <fs_order_partners_out>-partn_role ] TO <fs_extensionin>.
          IF sy-subrc = 0.
            ASSIGN gt_vbpa3[ parvw = <fs_order_partners_out>-partn_role ] TO <fs_vbpa3>.
            IF sy-subrc = 0.
              IF <fs_vbpa3>-stcd1 <> <fs_extensionin>-valuepart1+2(16).
                <fs_response>-iguales = ''.
                <fs_response>-message = 'Se ha cambiado el NIT para AG.'.
                RETURN.
              ENDIF.
            ENDIF.
          ENDIF.
          " Verificación datos personales
          ASSIGN i_order_partners[ partn_role = 'AG' ] TO <fs_quotation_partners>.
          IF sy-subrc = 0.
            IF <fs_quotation_partners>-partn_numb <> <fs_order_partners_out>-customer.
              <fs_response>-iguales = ''.
              <fs_response>-message = 'Se ha cambiado PARTNER para AG.'.
              RETURN.
            ENDIF.
            ASSIGN gt_order_address_out[ address = <fs_order_partners_out>-address ] TO <fs_order_address_out>.
            IF sy-subrc = 0.
              ASSIGN i_partneraddresses[ addr_no = <fs_quotation_partners>-addr_link ] TO <fs_partneraddresses>.
              IF sy-subrc = 0.
                IF    <fs_order_address_out>-name      <> <fs_partneraddresses>-name
                   OR <fs_order_address_out>-name_2    <> <fs_partneraddresses>-name_2
                   OR <fs_order_address_out>-street    <> <fs_quotation_partners>-street
                   OR <fs_order_address_out>-city      <> <fs_quotation_partners>-city
                   OR <fs_order_address_out>-telephone <> <fs_quotation_partners>-telephone
                   OR <fs_order_address_out>-country   <> <fs_quotation_partners>-country.
                  <fs_response>-iguales = ''.
                  <fs_response>-message = 'Se han cambiado los datos personales para AG.'.
                  RETURN.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN 'RE'. " DF - RE
          " Verificación NIT
          ASSIGN i_extensionin[ valuepart1(2) = <fs_order_partners_out>-partn_role ] TO <fs_extensionin>.
          IF sy-subrc = 0.
            ASSIGN gt_vbpa3[ parvw = <fs_order_partners_out>-partn_role ] TO <fs_vbpa3>.
            IF sy-subrc = 0.
              IF <fs_vbpa3>-stcd1 <> <fs_extensionin>-valuepart1+2(16).
                <fs_response>-iguales = ''.
                <fs_response>-message = 'Se ha cambiado el NIT para RE.'.
                RETURN.
              ENDIF.
            ENDIF.
          ENDIF.
          " Verificación datos personales
          ASSIGN i_order_partners[ partn_role = 'RE' ] TO <fs_quotation_partners>.
          IF sy-subrc = 0.
            IF <fs_quotation_partners>-partn_numb <> <fs_order_partners_out>-customer.
              <fs_response>-iguales = ''.
              <fs_response>-message = 'Se ha cambiado PARTNER para RE.'.
              RETURN.
            ENDIF.
            ASSIGN gt_order_address_out[ address = <fs_order_partners_out>-address ] TO <fs_order_address_out>.
            IF sy-subrc = 0.
              ASSIGN i_partneraddresses[ addr_no = <fs_quotation_partners>-addr_link ] TO <fs_partneraddresses>.
              IF sy-subrc = 0.
                IF    <fs_order_address_out>-name      <> <fs_partneraddresses>-name
                   OR <fs_order_address_out>-name_2    <> <fs_partneraddresses>-name_2
                   OR <fs_order_address_out>-street    <> <fs_quotation_partners>-street
                   OR <fs_order_address_out>-city      <> <fs_quotation_partners>-city
                   OR <fs_order_address_out>-telephone <> <fs_quotation_partners>-telephone
                   OR <fs_order_address_out>-country   <> <fs_quotation_partners>-country.
                  <fs_response>-iguales = ''.
                  <fs_response>-message = 'Se han cambiado los datos personales para RE.'.
                  RETURN.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN 'RG'. " RP - RG

          " Verificación NIT
          ASSIGN i_extensionin[ valuepart1(2) = <fs_order_partners_out>-partn_role ] TO <fs_extensionin>.
          IF sy-subrc = 0.
            ASSIGN gt_vbpa3[ parvw = <fs_order_partners_out>-partn_role ] TO <fs_vbpa3>.
            IF sy-subrc = 0.
              IF <fs_vbpa3>-stcd1 <> <fs_extensionin>-valuepart1+2(16).
                <fs_response>-iguales = ''.
                <fs_response>-message = 'Se ha cambiado el NIT para RG.'.
                RETURN.
              ENDIF.
            ENDIF.
          ENDIF.
          " Verificación datos personales
          ASSIGN i_order_partners[ partn_role = 'RP' ] TO <fs_quotation_partners>.
          IF sy-subrc = 0.
            IF <fs_quotation_partners>-partn_numb <> <fs_order_partners_out>-customer.
              <fs_response>-iguales = ''.
              <fs_response>-message = 'Se ha cambiado PARTNER para RP.'.
              RETURN.
            ENDIF.
            ASSIGN gt_order_address_out[ address = <fs_order_partners_out>-address ] TO <fs_order_address_out>.
            IF sy-subrc = 0.
              ASSIGN i_partneraddresses[ addr_no = <fs_quotation_partners>-addr_link ] TO <fs_partneraddresses>.
              IF sy-subrc = 0.
                IF    <fs_order_address_out>-name      <> <fs_partneraddresses>-name
                   OR <fs_order_address_out>-name_2    <> <fs_partneraddresses>-name_2
                   OR <fs_order_address_out>-street    <> <fs_quotation_partners>-street
                   OR <fs_order_address_out>-city      <> <fs_quotation_partners>-city
                   OR <fs_order_address_out>-telephone <> <fs_quotation_partners>-telephone
                   OR <fs_order_address_out>-country   <> <fs_quotation_partners>-country.
                  <fs_response>-iguales = ''.
                  <fs_response>-message = 'Se han cambiado los datos personales para RP.'.
                  RETURN.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN 'WE'. " BU - WE

          " Verificación NIT
          ASSIGN i_extensionin[ valuepart1(2) = <fs_order_partners_out>-partn_role ] TO <fs_extensionin>.
          IF sy-subrc = 0.
            ASSIGN gt_vbpa3[ parvw = <fs_order_partners_out>-partn_role ] TO <fs_vbpa3>.
            IF sy-subrc = 0.
              IF <fs_vbpa3>-stcd1 <> <fs_extensionin>-valuepart1+2(16).
                <fs_response>-iguales = ''.
                <fs_response>-message = 'Se ha cambiado el NIT para WE.'.
                RETURN.
              ENDIF.
            ENDIF.
          ENDIF.
          " Verificación datos personales
          ASSIGN i_order_partners[ partn_role = 'WE' ] TO <fs_quotation_partners>.
          IF sy-subrc = 0.
            IF <fs_quotation_partners>-partn_numb <> <fs_order_partners_out>-customer.
              <fs_response>-iguales = ''.
              <fs_response>-message = 'Se ha cambiado PARTNER para WE.'.
              RETURN.
            ENDIF.
            ASSIGN gt_order_address_out[ address = <fs_order_partners_out>-address ] TO <fs_order_address_out>.
            IF sy-subrc = 0.
              ASSIGN i_partneraddresses[ addr_no = <fs_quotation_partners>-addr_link ] TO <fs_partneraddresses>.
              IF sy-subrc = 0.
                IF    <fs_order_address_out>-name      <> <fs_partneraddresses>-name
                   OR <fs_order_address_out>-name_2    <> <fs_partneraddresses>-name_2
                   OR <fs_order_address_out>-street    <> <fs_quotation_partners>-street
                   OR <fs_order_address_out>-city      <> <fs_quotation_partners>-city
                   OR <fs_order_address_out>-telephone <> <fs_quotation_partners>-telephone
                   OR <fs_order_address_out>-country   <> <fs_quotation_partners>-country.
                  <fs_response>-iguales = ''.
                  <fs_response>-message = 'Se han cambiado los datos personales para WE.'.
                  RETURN.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    " 4. Items posiciones
    LOOP AT gt_order_items_out ASSIGNING <fs_order_items_out> WHERE rea_for_re = ''.
      ASSIGN i_order_items_in[ itm_number = <fs_order_items_out>-itm_number
                               reason_rej = '' ] TO <fs_quotation_items_in>.
      IF sy-subrc = 0.
        IF    <fs_quotation_items_in>-material   <> <fs_order_items_out>-material
           OR <fs_quotation_items_in>-batch      <> <fs_order_items_out>-batch
           OR <fs_quotation_items_in>-plant      <> <fs_order_items_out>-plant
           OR <fs_quotation_items_in>-target_qty <> <fs_order_items_out>-req_qty
           OR <fs_quotation_items_in>-target_qu  <> <fs_order_items_out>-target_qu
           OR <fs_quotation_items_in>-route      <> <fs_order_items_out>-route
*           OR <fs_quotation_items_in>-po_quan    <> <fs_order_items_out>-po_quan"DELETE @100
           OR ( <fs_quotation_items_in>-store_loc <> <fs_order_items_out>-stge_loc AND i_tipofactura = 'I' )
           OR <fs_quotation_items_in>-reason_rej <> <fs_order_items_out>-rea_for_re.
          <fs_response>-iguales = ''.
          <fs_response>-message = 'Se han cambiado los datos en las posiciones.'.
          RETURN.
        ENDIF.
      ELSE.
        <fs_response>-iguales = ''.
        <fs_response>-message = 'Se han cambiado los datos en las posiciones.'.
        RETURN.
      ENDIF.
    ENDLOOP.

    " Condiciones
    CLEAR: gv_tabixa,
           gv_tabixb.
    DATA(lt_order_conditions_in) = i_order_conditions_in[]. "//Add 07.07.2022

    IF <fs_order_headers_out> IS ASSIGNED.

      ycl_sd_utilitys=>get_consultar_des_dinamicos( EXPORTING i_vkorg    = <fs_order_headers_out>-sales_org
                                                              i_pantalla = 'VTA'
                                                              i_activo   = 'X'
                                                    IMPORTING e_table    = DATA(lt_desc_dinamic) ).
      IF sy-subrc = 0.
        lr_cond_type = VALUE #( FOR lwa_desc_dinamic IN lt_desc_dinamic WHERE ( koaid = 'A' AND ( kmanu = 'A' OR kmanu = '' OR kmanu = 'C' ) ) " Cond. manual solo para descuentos
                                sign   = 'I'
                                option = 'EQ'
                                (  low = lwa_desc_dinamic-kschl  ) ).

      ENDIF.
    ENDIF.

    DATA(lt_order_conditions_out) = gt_order_conditions_out[].
    DELETE lt_order_conditions_out WHERE    cond_type NOT IN lr_cond_type
                                         OR cond_value     = 0 OR condisacti <> ''.
    DELETE lt_order_conditions_in WHERE condisacti <> ''.
    gv_canta = lines( lt_order_conditions_out ).
    gv_cantb = lines( lt_order_conditions_in ).
    IF gv_canta <> gv_cantb.
      <fs_response>-iguales = ''.
      <fs_response>-message = 'Se han cambiado los datos en las condiciones.'.
      RETURN.
    ENDIF.
    CLEAR: gv_tabixa,
           gv_tabixb.
    LOOP AT lt_order_conditions_out ASSIGNING <fs_order_conditions_out> WHERE     cond_type  IN lr_cond_type
                                                                              AND cond_value <> 0.
      LOOP AT lt_order_conditions_in ASSIGNING <fs_quotation_conditions_in> WHERE     itm_number = <fs_order_conditions_out>-itm_number
                                                                                  AND cond_type  = <fs_order_conditions_out>-cond_type.
        IF <fs_order_conditions_out>-pmsignamou = 'X'.
          <fs_quotation_conditions_in>-cond_value = - <fs_quotation_conditions_in>-cond_value.
        ENDIF.
        IF <fs_quotation_conditions_in>-cond_value <> <fs_order_conditions_out>-cond_value.
          <fs_response>-iguales = ''.
          <fs_response>-message = 'Se han cambiado los datos en las condiciones.'.
          RETURN.
        ENDIF.
      ENDLOOP.
      IF sy-subrc <> 0.
        <fs_response>-iguales = ''.
        <fs_response>-message = 'Se han cambiado los datos en las condiciones.'.
        RETURN.
      ENDIF.
    ENDLOOP.

    " 5. Texto

    DATA(lti_order_text) = i_order_text[].
    DELETE lti_order_text WHERE itm_number IS INITIAL.
    gv_canta = lines( gt_order_textlines_out ).
    gv_cantb = lines( lti_order_text ).
    IF gv_canta <> gv_cantb.
      <fs_response>-iguales = ''.
      <fs_response>-message = 'Se han cambiado los datos en los textos.'.
      RETURN.
    ENDIF.
    CLEAR: gv_canta,
           gv_cantb,
           gv_tabixa,
           gv_tabixb.
    LOOP AT gt_order_textlines_out ASSIGNING <fs_order_textlines_out>.
      gv_tabixa = sy-tabix.
      ASSIGN lti_order_text[ gv_tabixa ] TO <fs_quotation_text>.
      IF sy-subrc = 0.
        gv_tabixb = sy-tabix.
        IF     <fs_quotation_text>-text_id    = <fs_order_textlines_out>-text_id
           AND <fs_quotation_text>-text_line <> <fs_order_textlines_out>-line
           AND gv_tabixa = gv_tabixb.
          <fs_response>-iguales = ''.
          <fs_response>-message = 'Se han cambiado los datos en los textos.'.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CONCEPTO_BUSQUEDA
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_concepto_busqueda.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtiene los conceptos de búsqueda (bu_sort1)
    " ^                    registrados en la tabla de socios BUT000.
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_but000,
             bu_sort1 TYPE but000-bu_sort1, ". Concepto de búsqueda
           END OF lty_but000.

    " Declaración de variables locales
    DATA: lt_but000 TYPE STANDARD TABLE OF lty_but000.      ". Tabla interna resultados
    DATA: lt_return LIKE rt_return.                        ". Tabla estructurada de retorno

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_but000> TYPE lty_but000,             ". Registro de tabla but000
                   <ls_return> LIKE LINE OF rt_return.     ". Registro de tabla retorno

    SELECT bu_sort1
      FROM but000
      INTO TABLE lt_but000.

    IF lt_but000 IS NOT INITIAL.
      LOOP AT lt_but000 ASSIGNING <ls_but000>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-concepto_busqueda = <ls_but000>-bu_sort1.
      ENDLOOP.
    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_OFICINA                      TYPE        VBAK-VKBUR
* | [--->] I_CLIENTE                      TYPE        VBAK-KUNNR
* | [--->] I_FECHAI                       TYPE        CHAR10
* | [--->] I_FECHAF                       TYPE        CHAR10
* | [--->] I_USUARIO                      TYPE        UNAME
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cotizacion.
    TYPES: BEGIN OF gy_vbak,
             vkorg TYPE vbak-vkorg,
             vtweg TYPE vbak-vtweg,
             spart TYPE vbak-spart,
             auart TYPE vbak-auart,
             kunnr TYPE vbak-kunnr,
             augru TYPE vbak-augru,
             knumv TYPE vbak-knumv,
             waerk TYPE vbak-waerk,
             erdat TYPE vbak-erdat,
             vbeln TYPE vbak-vbeln,
             vkbur TYPE vbak-vkbur,
             abstk TYPE vbuk-abstk, "REPLACE @100
             gbstk TYPE vbuk-gbstk, "REPLACE @100
             vsbed TYPE vbak-vsbed,
             vbtyp TYPE vbak-vbtyp,
             vkgrp TYPE vbak-vkgrp,
             ktext TYPE vbak-ktext,
           END OF gy_vbak.

    TYPES: BEGIN OF gy_vbap,
             werks   TYPE vbap-werks,
             vstel   TYPE vbap-vstel,
             lgort   TYPE vbap-lgort,
             lprio   TYPE vbap-lprio,
             route   TYPE vbap-route,
             matnr   TYPE vbap-matnr,
             kwmeng  TYPE vbap-kwmeng,
             vrkme   TYPE vbap-vrkme,
             charg   TYPE vbap-charg,
             brgew   TYPE vbap-brgew,
             vbeln   TYPE vbap-vbeln,
             posnr   TYPE vbap-posnr,
             po_quan TYPE vbap-kpein, "vbap-po_quan,"REPLACE @100
             po_unit TYPE vbap-kmein, "po_unit,"REPLACE @100
             ernam   TYPE vbap-ernam,
             abgru   TYPE vbap-abgru,
             pstyv   TYPE vbap-pstyv,
           END OF gy_vbap.

    TYPES: BEGIN OF gy_vbkd,
             bstkd TYPE vbkd-bstkd,
             kdgrp TYPE vbkd-kdgrp,
             bzirk TYPE vbkd-bzirk,
             pltyp TYPE vbkd-pltyp,
             kdkg1 TYPE vbkd-kdkg1,
             vbeln TYPE vbkd-vbeln,
             posnr TYPE vbkd-posnr,
             zterm TYPE vbkd-zterm,
             ihrez TYPE vbkd-ihrez,
           END OF gy_vbkd.

    TYPES: BEGIN OF gy_makt,
             matnr TYPE makt-matnr,
             maktx TYPE makt-maktx,
           END OF gy_makt.

    TYPES: BEGIN OF gy_vbrp,
             aubel TYPE vbrp-aubel,
             aupos TYPE vbrp-aupos,
             vbeln TYPE vbrp-vbeln,
           END OF gy_vbrp.

    TYPES: BEGIN OF gy_bseg,
             vbeln TYPE bseg-vbeln,
             gjahr TYPE bseg-gjahr,
             belnr TYPE bseg-belnr,
           END OF gy_bseg.

    TYPES: BEGIN OF gy_bkpf,
             belnr TYPE bkpf-belnr,
             xblnr TYPE bkpf-xblnr,
           END OF gy_bkpf.

    TYPES: BEGIN OF gy_vbpa,
             vbeln TYPE vbpa-vbeln,
             posnr TYPE vbpa-posnr,
             kunnr TYPE vbpa-kunnr,
             pernr TYPE vbpa-pernr,
             parvw TYPE vbpa-parvw,
             adrnr TYPE vbpa-adrnr,
             xcpdk TYPE vbpa-xcpdk,
           END OF gy_vbpa.

    TYPES: BEGIN OF gy_pa0001,
             pernr TYPE pa0001-pernr,
             uname TYPE pa0001-uname,
             sname TYPE pa0001-sname,
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_konv,
             knumv TYPE konv-knumv,
             kwert TYPE konv-kwert,
             kschl TYPE konv-kschl,
             kherk TYPE konv-kherk,
             kposn TYPE konv-kposn,
             krech TYPE konv-krech,
             kbetr TYPE konv-kbetr,
           END OF gy_konv.

    TYPES: BEGIN OF gy_kna1,
             kunnr TYPE kna1-kunnr,
             name1 TYPE kna1-name1,
             adrnr TYPE kna1-adrnr,
             stras TYPE kna1-stras,
             telf1 TYPE kna1-telf1,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_pa0105,
             usrid TYPE pa0105-usrid,
             pernr TYPE pa0105-pernr,
           END OF gy_pa0105.

    TYPES: BEGIN OF gy_adrc,
             addrnumber TYPE adrc-addrnumber,
             name1      TYPE adrc-name1,
             name2      TYPE adrc-name2,
             name3      TYPE adrc-name3,
             name4      TYPE adrc-name4,
             street     TYPE adrc-street,
             tel_number TYPE adrc-tel_number,
           END OF gy_adrc.

    TYPES: BEGIN OF gy_vbpa3,
             vbeln TYPE vbpa3-vbeln,
             stcd1 TYPE vbpa3-stcd1,
           END OF gy_vbpa3.

    DATA lt_vbak          TYPE TABLE OF gy_vbak.
    DATA lt_makt          TYPE TABLE OF gy_makt.
    DATA lt_vbap          TYPE TABLE OF gy_vbap.
    DATA lt_vbkd          TYPE TABLE OF gy_vbkd.
    DATA lt_vbrp          TYPE TABLE OF gy_vbrp.
    DATA lt_bseg          TYPE TABLE OF gy_bseg.
    DATA lt_bkpf          TYPE TABLE OF gy_bkpf.
    DATA lt_vbpa          TYPE TABLE OF gy_vbpa.
    DATA lt_vbpa2         TYPE TABLE OF gy_vbpa.
    DATA lt_pa0001        TYPE TABLE OF gy_pa0001.
    DATA lt_pa0105        TYPE TABLE OF gy_pa0105.
    DATA lt_kna1          TYPE TABLE OF gy_kna1.
    DATA lt_adrc          TYPE TABLE OF gy_adrc.
    DATA lt_vbpa3         TYPE TABLE OF gy_vbpa3.
    DATA lt_konv          TYPE TABLE OF gy_konv.
    DATA lt_konv2         TYPE TABLE OF gy_konv.
    DATA lt_konv3         TYPE TABLE OF gy_konv.
    DATA lt_konv4         TYPE TABLE OF gy_konv.
    DATA lt_konv5         TYPE TABLE OF gy_konv.
    DATA lt_konv6         TYPE TABLE OF gy_konv.
    DATA lt_konv7         TYPE TABLE OF gy_konv.
    DATA lv_netwr         TYPE konv-kwert.
    DATA lv_mwsbp         TYPE konv-kwert.
    DATA lv_netwr_mwsbp   TYPE konv-kwert.
    DATA lt_tlinec        TYPE TABLE OF tline.
    DATA lt_tlinen        TYPE TABLE OF tline.
    DATA lt_nfabricacion  TYPE TABLE OF tline.
    DATA header           TYPE thead.
    DATA old_line_counter TYPE thead-tdtxtlines.
    DATA lv_documento     TYPE vbak-vbeln.
    DATA lv_posnr         TYPE c LENGTH 6.
    DATA lv_posnr1        TYPE c LENGTH 6.
    DATA lv_objnr         TYPE jsto-objnr.
    DATA lt_status        TYPE TABLE OF jstat.
    DATA name             TYPE thead-tdname.

    FIELD-SYMBOLS <fs_vbak>   LIKE LINE OF lt_vbak.
    FIELD-SYMBOLS <fs_vbap>   LIKE LINE OF lt_vbap.
    FIELD-SYMBOLS <fs_makt>   LIKE LINE OF lt_makt.
    FIELD-SYMBOLS <fs_vbkd>   LIKE LINE OF lt_vbkd.
    FIELD-SYMBOLS <fs_vbrp>   LIKE LINE OF lt_vbrp.
    FIELD-SYMBOLS <fs_bseg>   LIKE LINE OF lt_bseg.
    FIELD-SYMBOLS <fs_bkpf>   LIKE LINE OF lt_bkpf.
    FIELD-SYMBOLS <fs_vbpa>   LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_vbpa2>  LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_pa0001> LIKE LINE OF lt_pa0001.
    FIELD-SYMBOLS <fs_kna1>   LIKE LINE OF lt_kna1.
    FIELD-SYMBOLS <fs_adrc>   LIKE LINE OF lt_adrc.
    FIELD-SYMBOLS <fs_vbpa3>  LIKE LINE OF lt_vbpa3.
    FIELD-SYMBOLS <fs_konv>   LIKE LINE OF lt_konv.
    FIELD-SYMBOLS <fs_konv2>  LIKE LINE OF lt_konv2.
    FIELD-SYMBOLS <fs_konv3>  LIKE LINE OF lt_konv3.
    FIELD-SYMBOLS <fs_konv4>  LIKE LINE OF lt_konv4.
    FIELD-SYMBOLS <fs_konv5>  LIKE LINE OF lt_konv5.
    FIELD-SYMBOLS <fs_konv6>  LIKE LINE OF lt_konv6.
    FIELD-SYMBOLS <fs_status> LIKE LINE OF lt_status.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.
    FIELD-SYMBOLS <fs_tlinec> LIKE LINE OF lt_tlinec.
    FIELD-SYMBOLS <fs_tlinen> LIKE LINE OF lt_tlinen.

    IF i_usuario IS NOT INITIAL.

      SELECT a~vkorg, a~vtweg, a~spart, a~auart, a~kunnr, a~augru,
               a~knumv, a~waerk, a~erdat, a~vbeln, a~vkbur,
               b~abstk, b~gbstk,
               a~vsbed, a~vbtyp, a~vkgrp, a~ktext
          FROM vbak AS a
          INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
          INTO TABLE @lt_vbak
          WHERE a~vbtyp = 'B'
                AND b~abstk NE 'C'
            AND a~vkorg = @i_org_ventas
            AND a~vkbur = @i_oficina
            AND a~erdat BETWEEN @i_fechai AND @i_fechaf
            AND a~ernam = @i_usuario.

    ELSE.

      SELECT a~vkorg, a~vtweg, a~spart, a~auart, a~kunnr, a~augru,
               a~knumv, a~waerk, a~erdat, a~vbeln, a~vkbur,
               b~abstk, b~gbstk,
               a~vsbed, a~vbtyp, a~vkgrp, a~ktext
          FROM vbak AS a
          INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
          INTO TABLE @lt_vbak
          WHERE a~vbtyp = 'B'
                AND b~abstk NE 'C'
            AND a~vkorg = @i_org_ventas
            AND a~vkbur = @i_oficina
            AND a~erdat BETWEEN @i_fechai AND @i_fechaf.


    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      SELECT kunnr name1 adrnr stras telf1
        FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbak
        WHERE kunnr = lt_vbak-kunnr.

      SELECT werks vstel lgort lprio route matnr kwmeng vrkme charg brgew vbeln posnr kpein AS po_quan kmein AS po_unit ernam abgru pstyv
       FROM vbap
       INTO TABLE lt_vbap
       FOR ALL ENTRIES IN lt_vbak
       WHERE vbeln = lt_vbak-vbeln.

      SELECT matnr maktx FROM makt
        INTO TABLE lt_makt
        FOR ALL ENTRIES IN lt_vbap
        WHERE matnr = lt_vbap-matnr.

      IF lt_vbap IS NOT INITIAL.

        SELECT bstkd kdgrp bzirk pltyp kdkg1 vbeln posnr zterm ihrez
          FROM vbkd
          INTO TABLE lt_vbkd
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln.

        SELECT aubel aupos vbeln FROM vbrp
          INTO TABLE lt_vbrp
          FOR ALL ENTRIES IN lt_vbap
          WHERE aubel = lt_vbap-vbeln.

        IF lt_vbrp IS NOT INITIAL.

          SELECT vbeln gjahr belnr FROM bseg
            INTO TABLE lt_bseg
            FOR ALL ENTRIES IN lt_vbrp
            WHERE vbeln = lt_vbrp-vbeln.

          IF lt_bseg IS NOT INITIAL.

            SELECT belnr xblnr FROM bkpf
              INTO TABLE lt_bkpf
              FOR ALL ENTRIES IN lt_bseg
              WHERE belnr = lt_bseg-belnr.

          ENDIF.

        ENDIF.

        SELECT vbeln posnr kunnr pernr parvw adrnr xcpdk
          FROM vbpa
          INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN lt_vbak
          WHERE vbeln = lt_vbak-vbeln
            AND (    parvw = 'DF'
                  OR parvw = 'RE'
                  OR parvw = 'AG'
                  OR parvw = 'PE' ).

        IF lt_vbpa IS NOT INITIAL.

          SELECT addrnumber name1 name2 name3 name4 street tel_number
            FROM adrc
            INTO TABLE lt_adrc
            FOR ALL ENTRIES IN lt_vbpa
            WHERE addrnumber = lt_vbpa-adrnr.

          SELECT vbeln stcd1 FROM vbpa3
            INTO TABLE lt_vbpa3
            FOR ALL ENTRIES IN lt_vbpa
            WHERE vbeln = lt_vbpa-vbeln.

        ENDIF.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa2
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln
            AND parvw = 'VE'.

        IF lt_vbpa2 IS NOT INITIAL.

          SELECT pernr uname sname
            FROM pa0001
            INTO TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_vbpa2
            WHERE pernr = lt_vbpa2-pernr.

          SELECT usrid pernr FROM pa0105
            INTO TABLE lt_pa0105
            FOR ALL ENTRIES IN lt_vbpa2
            WHERE pernr = lt_vbpa2-pernr.

        ENDIF.

      ENDIF.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'NTPS'.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv2
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'MWST'.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv6
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZD00'
          AND kherk = 'C'.

      IF lt_konv6 IS INITIAL.

        SELECT knumv kwert kschl kherk kposn krech kbetr
          FROM konv
          INTO TABLE lt_konv6
          FOR ALL ENTRIES IN lt_vbak
          WHERE knumv = lt_vbak-knumv
            AND kschl = 'ZD00'.

      ENDIF.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv3
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZD01'
          AND kherk = 'C'.

      IF lt_konv3 IS INITIAL.

        SELECT knumv kwert kschl kherk kposn krech kbetr
          FROM konv
          INTO TABLE lt_konv3
          FOR ALL ENTRIES IN lt_vbak
          WHERE knumv = lt_vbak-knumv
            AND kschl = 'ZD01'.

      ENDIF.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv4
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZD02'.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv5
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZBO0'
          AND krech = 'B'.

      DATA: lt_t003_descuen TYPE STANDARD TABLE OF ysd_t003_descuen.
      DATA gr_kschl         TYPE RANGE OF konv-kschl.
      SELECT *
        INTO TABLE lt_t003_descuen
        FROM ysd_t003_descuen
        WHERE vkorg = i_org_ventas
        AND activo = 'X'
        AND tipodoc = 'VTA'.
      IF sy-subrc = 0.
        REFRESH gr_kschl.

        gr_kschl = VALUE #( FOR lwa_kschl IN lt_t003_descuen ( sign = 'I' option = 'EQ' low = lwa_kschl-kschl ) ).

        SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv7
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv EQ lt_vbak-knumv
        AND kschl IN gr_kschl.

      ENDIF.

    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      IF lt_vbap IS NOT INITIAL.
        SORT lt_vbap BY vbeln
                        posnr ASCENDING. "
        LOOP AT lt_vbap ASSIGNING <fs_vbap>.

          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          <ls_return>-centro            = <fs_vbap>-werks.
          <ls_return>-puesto_expedicion = <fs_vbap>-vstel.
          <ls_return>-almacen           = <fs_vbap>-lgort.
          <ls_return>-prioridad_entrega = <fs_vbap>-lprio.
          <ls_return>-ruta              = <fs_vbap>-route.
          <ls_return>-articulo          = <fs_vbap>-matnr.
          <ls_return>-cantidad          = <fs_vbap>-kwmeng.
          <ls_return>-unidad_medida     = <fs_vbap>-vrkme.
          <ls_return>-lote              = <fs_vbap>-charg.
          <ls_return>-peso_bruto        = <fs_vbap>-brgew.
          <ls_return>-posicion          = <fs_vbap>-posnr.
          MOVE <fs_vbap>-po_quan TO <ls_return>-cantidad_pedido.
          MOVE <fs_vbap>-po_unit TO <ls_return>-unidad_pedido.
          <ls_return>-usuario           = <fs_vbap>-ernam.
          <ls_return>-motivo_rechazo    = <fs_vbap>-abgru.
          lv_posnr = <fs_vbap>-posnr.

          ASSIGN lt_makt[ matnr = <fs_vbap>-matnr ] TO <fs_makt>.
          IF sy-subrc = 0.
            <ls_return>-descripcion = <fs_makt>-maktx.
          ENDIF.

          ASSIGN lt_vbak[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbak>.
          IF sy-subrc = 0.
            name = <fs_vbak>-vbeln.
            <ls_return>-documento          = <fs_vbak>-vbeln.
            <ls_return>-organizacion_venta = <fs_vbak>-vkorg.
            <ls_return>-canal              = <fs_vbak>-vtweg.
            <ls_return>-sector             = <fs_vbak>-spart.
            <ls_return>-clase_documento    = <fs_vbak>-auart.
            <ls_return>-solicitante        = <fs_vbak>-kunnr.
            <ls_return>-motivo_pedido      = <fs_vbak>-augru.
            <ls_return>-cliente            = <fs_vbak>-knumv.
            <ls_return>-moneda             = <fs_vbak>-waerk.
            <ls_return>-fecha              = <fs_vbak>-erdat.
            <ls_return>-oficina            = <fs_vbak>-vkbur.
            MOVE <fs_vbak>-abstk TO <ls_return>-estatus_rechazo.
            MOVE <fs_vbak>-gbstk TO <ls_return>-estatus_global_cd.
            <ls_return>-motivo_expedicion  = <fs_vbak>-vsbed.
            <ls_return>-grupo_vendedores   = <fs_vbak>-vkgrp.
            <ls_return>-obra               = <fs_vbak>-ktext.
            lv_documento = <fs_vbak>-vbeln.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'TX04'
                language                = 'S'
                name                    = name
                object                  = 'VBBK'
                archive_handle          = 0
                local_cat               = ' '
              IMPORTING
                header                  = header
                old_line_counter        = old_line_counter
              TABLES
                lines                   = lt_tlinec
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.

            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'TX14'
                language                = 'S'
                name                    = name
                object                  = 'VBBK'
                archive_handle          = 0
                local_cat               = ' '
              IMPORTING
                header                  = header
                old_line_counter        = old_line_counter
              TABLES
                lines                   = lt_tlinen
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.

            name = <fs_vbak>-vbeln && <ls_return>-posicion.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = '0006'
                language                = 'S'
                name                    = name
                object                  = 'VBBP'
                archive_handle          = 0
                local_cat               = ' '
              IMPORTING
                header                  = header
                old_line_counter        = old_line_counter
              TABLES
                lines                   = lt_nfabricacion
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.

            LOOP AT lt_tlinec ASSIGNING <fs_tlinec>.
              <ls_return>-coordenada = <ls_return>-coordenada && <fs_tlinec>-tdline.
            ENDLOOP.

            LOOP AT lt_tlinen ASSIGNING <fs_tlinen>.
              <ls_return>-nota_envio = <ls_return>-nota_envio && <fs_tlinen>-tdline.
            ENDLOOP.

            LOOP AT lt_nfabricacion ASSIGNING <fs_tlinen>.
              <ls_return>-nota_fabricacion = <ls_return>-nota_fabricacion && <fs_tlinen>-tdline.
            ENDLOOP.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lv_posnr
              IMPORTING
                output = lv_posnr1.

            CONCATENATE 'VB' lv_documento lv_posnr1 INTO lv_objnr.

            CALL FUNCTION 'STATUS_READ'
              EXPORTING
                objnr  = lv_objnr
              TABLES
                status = lt_status.

            ASSIGN lt_status[ stat = 'E0002' ] TO <fs_status>.
            IF sy-subrc = 0.
              <ls_return>-inact = <fs_status>-inact.
            ELSE.
              <ls_return>-inact = 'N'.
            ENDIF.

            LOOP AT lt_konv ASSIGNING <fs_konv> WHERE     knumv = <fs_vbak>-knumv
                                                      AND kposn = <fs_vbap>-posnr.
              lv_netwr = lv_netwr + <fs_konv>-kwert.
              <ls_return>-sub_total = <ls_return>-sub_total + <fs_konv>-kwert.
            ENDLOOP.

            LOOP AT lt_konv2 ASSIGNING <fs_konv2> WHERE     knumv = <fs_vbak>-knumv
                                                        AND kposn = <fs_vbap>-posnr.
              lv_mwsbp = lv_mwsbp + <fs_konv2>-kwert.
              <ls_return>-sub_total = <ls_return>-sub_total + <fs_konv2>-kwert.
            ENDLOOP.

            lv_netwr_mwsbp = lv_netwr + lv_mwsbp.
            <ls_return>-importe_bruto = lv_netwr_mwsbp.

            LOOP AT lt_konv6 ASSIGNING <fs_konv6> WHERE     knumv = <fs_vbak>-knumv
                                                        AND kposn = <fs_vbap>-posnr.
              <ls_return>-decuento_vendedor = <ls_return>-decuento_vendedor + <fs_konv6>-kbetr.
            ENDLOOP.

            LOOP AT lt_konv3 ASSIGNING <fs_konv3> WHERE     knumv = <fs_vbak>-knumv
                                                        AND kposn = <fs_vbap>-posnr.
              <ls_return>-desc_come_client = <ls_return>-desc_come_client + <fs_konv3>-kbetr.
            ENDLOOP.

            LOOP AT lt_konv4 ASSIGNING <fs_konv4> WHERE     knumv = <fs_vbak>-knumv
                                                        AND kposn = <fs_vbap>-posnr.
              <ls_return>-desc_pesos_bruto = <ls_return>-desc_pesos_bruto + <fs_konv4>-kwert.
            ENDLOOP.

            LOOP AT lt_konv5 ASSIGNING <fs_konv5> WHERE     knumv = <fs_vbak>-knumv
                                                        AND kposn = <fs_vbap>-posnr.
              <ls_return>-importe_pago = <ls_return>-importe_pago + <fs_konv5>-kwert.
            ENDLOOP.

            LOOP AT lt_konv7 ASSIGNING FIELD-SYMBOL(<fs_konv7>) WHERE     knumv = <fs_vbak>-knumv
                                                                      AND kposn = <fs_vbap>-posnr.
              READ TABLE lt_t003_descuen INTO DATA(lwa_t003_descuen) WITH KEY kschl = <fs_konv7>-kschl.
              IF sy-subrc = 0.
                CASE lwa_t003_descuen-campo_ref.
                  WHEN 'DESC_DIN1'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-desc_din1.
                  WHEN 'DESC_DIN2'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-desc_din2.
                  WHEN 'DESC_DIN3'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-desc_din3.
                  WHEN 'DESC_DIN4'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-desc_din4.
                  WHEN 'DESC_DIN5'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-desc_din5.
                  WHEN 'PRECI_DIN1'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-preci_din1.
                  WHEN 'PRECI_DIN2'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-preci_din2.
                  WHEN 'PRECI_DIN3'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-preci_din3.
                  WHEN 'PRECI_DIN4'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-preci_din4.
                  WHEN 'PRECI_DIN5'.
                    ADD <fs_konv7>-kbetr TO <ls_return>-preci_din5.
                ENDCASE.
              ENDIF.
            ENDLOOP.

            ASSIGN lt_kna1[ kunnr = <fs_vbak>-kunnr ] TO <fs_kna1>.
            IF sy-subrc = 0.
              <ls_return>-referencia_cliente = <fs_kna1>-name1.
              <ls_return>-direccion          = <fs_kna1>-adrnr.
              <ls_return>-telefono           = <fs_kna1>-telf1.
              ASSIGN lt_adrc[ addrnumber = <fs_kna1>-adrnr ] TO <fs_adrc>.
              IF sy-subrc = 0.
                <ls_return>-direccion2 = <fs_adrc>-street.
              ENDIF.

            ENDIF.

          ENDIF.

          ASSIGN lt_vbkd[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbkd>.
          IF sy-subrc = 0.
            <ls_return>-num_ref_cliente   = <fs_vbkd>-bstkd.
            <ls_return>-grupo_cliente     = <fs_vbkd>-kdgrp.
            <ls_return>-zona_venta        = <fs_vbkd>-bzirk.
            <ls_return>-tipo_precio       = <fs_vbkd>-pltyp.
            <ls_return>-grupo_cond_client = <fs_vbkd>-kdkg1.
            <ls_return>-condicion_pago    = <fs_vbkd>-zterm.
          ENDIF.
          ASSIGN lt_vbkd[ vbeln = <fs_vbap>-vbeln
                          posnr = <fs_vbap>-posnr ] TO <fs_vbkd>.
          IF sy-subrc = 0.
            <ls_return>-tipo_posc = <fs_vbkd>-ihrez.
          ELSE.
            <ls_return>-tipo_posc = <fs_vbap>-pstyv.
          ENDIF.
          ASSIGN lt_vbrp[ aubel = <fs_vbap>-vbeln ] TO <fs_vbrp>.
          IF sy-subrc = 0.
            <ls_return>-doc_factura_log = <fs_vbrp>-vbeln.

            ASSIGN lt_bseg[ vbeln = <fs_vbrp>-vbeln ] TO <fs_bseg>.
            IF sy-subrc = 0.
              ASSIGN lt_bkpf[ belnr = <fs_bseg>-belnr ] TO <fs_bkpf>.
              IF sy-subrc = 0.
                <ls_return>-factura = <fs_bkpf>-xblnr.
              ENDIF.
            ENDIF.
          ENDIF.

          ASSIGN lt_vbpa[ vbeln = <fs_vbap>-vbeln
                          parvw = 'RE' ] TO <fs_vbpa>.
          IF sy-subrc = 0.
            <ls_return>-bill_to = <fs_vbpa>-kunnr.
            ASSIGN lt_vbpa[ vbeln = <fs_vbap>-vbeln
                            parvw = 'AG' ] TO <fs_vbpa2>.
            IF sy-subrc = 0.
              IF <fs_vbpa>-xcpdk = '' AND <fs_vbpa2>-xcpdk = 'X'.
                <fs_vbpa> = <fs_vbpa2>.
              ENDIF.
              UNASSIGN <fs_vbpa2>.
            ENDIF.
            IF <fs_vbpa>-xcpdk = 'X'.
              ASSIGN lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] TO <fs_adrc>.
              IF sy-subrc = 0.
                <ls_return>-codigo_y_nombre = <fs_adrc>-name1 && <fs_adrc>-name2 && <fs_adrc>-name3 && <fs_adrc>-name4.
                <ls_return>-direccion3      = <fs_adrc>-street.
                <ls_return>-telefono        = <fs_adrc>-tel_number.
              ENDIF.

              ASSIGN lt_vbpa3[ vbeln = <fs_vbpa>-vbeln ] TO <fs_vbpa3>.
              IF sy-subrc = 0.
                <ls_return>-nit_cpd = <fs_vbpa3>-stcd1.
              ENDIF.
            ENDIF.
          ENDIF.

          ASSIGN lt_vbpa2[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa2>.
          IF sy-subrc = 0.
            <ls_return>-id_vendedor = <fs_vbpa2>-pernr.

            ASSIGN lt_pa0001[ pernr = <fs_vbpa2>-pernr ] TO <fs_pa0001>.
            IF sy-subrc = 0.
              <ls_return>-nombre_solicitante = <fs_pa0001>-sname.
            ENDIF.
          ENDIF.

          CLEAR: lt_tlinec,
                 lt_tlinen,
                 lv_documento,
                 lv_posnr,
                 lv_posnr1,
                 lt_status.
          CLEAR lt_nfabricacion.

        ENDLOOP.

      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-message  = 'No se han encontrado registros de posicion, en la VBAP'.
        <ls_return>-messcode = '400'.

      ENDIF.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      <ls_return>-message  = 'No se han encontrado registros de cabecera, en la VBAK'.
      <ls_return>-messcode = '400'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CUENTA_BANCO
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_004_COBROS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cuenta_banco.

    DATA: lt_yfi_t003_ctabcos TYPE STANDARD TABLE OF yfi_t003_ctabcos.

    FIELD-SYMBOLS: <fs_yfi_t003_ctabcos> LIKE LINE OF lt_yfi_t003_ctabcos,
                   <fs_retunr>           LIKE LINE OF rt_return.


    SELECT *
    FROM yfi_t003_ctabcos
    INTO TABLE lt_yfi_t003_ctabcos.


    IF lt_yfi_t003_ctabcos IS NOT INITIAL.

      LOOP AT lt_yfi_t003_ctabcos ASSIGNING <fs_yfi_t003_ctabcos>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        MOVE <fs_yfi_t003_ctabcos>-soc_bco TO <fs_retunr>-soc_bco.
        MOVE <fs_yfi_t003_ctabcos>-txt_bco TO <fs_retunr>-txt_bco.
        MOVE <fs_yfi_t003_ctabcos>-cta_bco TO <fs_retunr>-cta_bco.
        MOVE <fs_yfi_t003_ctabcos>-mon_bco TO <fs_retunr>-mon_bco.
        MOVE <fs_yfi_t003_ctabcos>-cch_bco TO <fs_retunr>-cch_bco.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message = 'No se han encontrado registros'.
      <fs_retunr>-messcode = '400'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_CUENTA_DONACION
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_004_COBROS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cuenta_donacion.

    DATA: lt_yfi_t006_donacio TYPE STANDARD TABLE OF yfi_t006_donacio.

    FIELD-SYMBOLS: <fs_yfi_t006_donacio> LIKE LINE OF lt_yfi_t006_donacio,
                   <fs_retunr>           LIKE LINE OF rt_return.


    SELECT *
    FROM yfi_t006_donacio
    INTO TABLE lt_yfi_t006_donacio.


    IF lt_yfi_t006_donacio IS NOT INITIAL.

      LOOP AT lt_yfi_t006_donacio ASSIGNING <fs_yfi_t006_donacio>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        MOVE <fs_yfi_t006_donacio>-znewko_don TO <fs_retunr>-znewko_don.
        MOVE <fs_yfi_t006_donacio>-txt_don TO <fs_retunr>-txt_don.

      ENDLOOP.
    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message = 'No se han encontrado registros'.
      <fs_retunr>-messcode = '400'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_DESCUENTO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_MATERIAL                     TYPE        MATNR
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_CANAL                        TYPE        VTWEG
* | [--->] I_SECTOR                       TYPE        SPART
* | [--->] I_GRUPO_ARTICULO               TYPE        MATKL
* | [--->] I_GRUPO_CLIENTE                TYPE        KDGRP
* | [--->] I_OFICINA_VENTAS               TYPE        VKBUR
* | [--->] I_ZONA_VENTAS                  TYPE        BZIRK
* | [--->] I_GRUPO_COND_CLIENTE           TYPE        KDKGR
* | [--->] I_SOLICITANTE                  TYPE        KUNAG
* | [--->] I_LISTA_PRECIO                 TYPE        PLTYP
* | [--->] I_CONDICION_PAGO               TYPE        KNVV-ZTERM
* | [--->] I_VALIDO_A                     TYPE        CHAR10(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_005_DESCUENTO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_descuento.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 04.05.2025
    " ^ Descripción.....: Consulta descuentos dinámicos configurados en
    " ^                  ysd_t003_descue y KONP, filtrando por material,
    " ^                   organización de ventas, canal y grupo de artículos.
    " -----------------------------------------------------------------------

    " Declaración de variables y estructuras locales
    DATA lt_t003_descuen  TYPE STANDARD TABLE OF ysd_t003_descuen.                                         " Tabla de descuentos configurables
    DATA lwa_t003_descuen TYPE ysd_t003_descuen.                     " Registro individual de configuración
    DATA lv_solicitante   TYPE char10.

    DATA lv_tabname       TYPE tabname.                              " Nombre de tabla dinámica
    DATA lo_tabtype       TYPE REF TO cl_abap_tabledescr.            " Descripción tabla dinámica
    DATA lo_struct_type   TYPE REF TO cl_abap_structdescr.           " Descripción estructura dinámica
    DATA lr_data          TYPE REF TO data.                          " Referencia a datos dinámicos
    DATA lt_comp_tab      TYPE cl_abap_structdescr=>component_table. " Componentes de la estructura
    DATA lv_where_clause  TYPE string.                               " Cláusula WHERE dinámica

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_tab>    TYPE ANY TABLE.                      " Tabla dinámica
    FIELD-SYMBOLS <ls_line>   TYPE any.               " Línea dinámica
    FIELD-SYMBOLS <ls_kunmh>  TYPE knumh.             " Campo clave de condición
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return. " Registro de retorno


    " Leer configuraciones activas
    SELECT DISTINCT * FROM ysd_t003_descuen
      INTO TABLE lt_t003_descuen
      WHERE activo = 'X'.

    IF sy-subrc = 0.

      lv_solicitante = i_solicitante.
      LOOP AT lt_t003_descuen INTO lwa_t003_descuen WHERE tabla_ref IS NOT INITIAL.

        " Obtener la definición dinámica de la tabla configurada
        TRY.
            " Obtener la definición dinámica de la tabla configurada
            lv_tabname = lwa_t003_descuen-tabla_ref.
            lo_struct_type ?= cl_abap_typedescr=>describe_by_name( lv_tabname ).
            lt_comp_tab = lo_struct_type->get_components( ).
            lo_struct_type = cl_abap_structdescr=>create( lt_comp_tab ).
            lo_tabtype     = cl_abap_tabledescr=>create( lo_struct_type ).
            " Crear tabla dinámica
            CREATE DATA lr_data TYPE HANDLE lo_tabtype.
            ASSIGN lr_data->* TO <ls_tab>.
          CATCH cx_sy_create_data_error.
            CONTINUE.
        ENDTRY.

        " Armar WHERE dinámico solo con campos existentes
        CLEAR lv_where_clause.
        IF line_exists( lt_comp_tab[ name = 'MATKL' ] ).
          lv_where_clause = |{ lv_where_clause } AND matkl = '{ i_grupo_articulo }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'VKORG' ] ).
          lv_where_clause = |{ lv_where_clause } AND vkorg = '{ i_org_ventas }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'VTWEG' ] ).
          lv_where_clause = |{ lv_where_clause } AND vtweg = '{ i_canal }'|.
        ENDIF.
*{INSERT @0100
        IF line_exists( lt_comp_tab[ name = 'SPART' ] ).
          lv_where_clause = |{ lv_where_clause } AND spart = '{ i_sector }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'KDGRP' ] ).
          lv_where_clause = |{ lv_where_clause } AND kdgrp = '{ i_grupo_cliente }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'VKBUR' ] ).
          lv_where_clause = |{ lv_where_clause } AND vkbur = '{ i_oficina_ventas }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'KDKGR' ] ).
          lv_where_clause = |{ lv_where_clause } AND kdkgr = '{ i_grupo_cond_cliente }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'KUNNR' ] ).
          lv_where_clause = |{ lv_where_clause } AND kunnr = '{ lv_solicitante }'|.
        ENDIF.
*}INSERT @0100
        IF line_exists( lt_comp_tab[ name = 'BZIRK' ] ).
          lv_where_clause = |{ lv_where_clause } AND bzirk = '{ i_zona_ventas }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'PLTYP' ] ).
          lv_where_clause = |{ lv_where_clause } AND pltyp = '{ i_lista_precio }'|.
        ENDIF.
        IF line_exists( lt_comp_tab[ name = 'KSCHL' ] ).
          lv_where_clause = |{ lv_where_clause } AND kschl = '{ lwa_t003_descuen-kschl }'|.
        ENDIF.

        IF line_exists( lt_comp_tab[ name = 'MATNR' ] ).
          lv_where_clause = |{ lv_where_clause } AND matnr = '{ i_material }'|.
        ENDIF.

        " Quitar el primer AND si existe
        IF lv_where_clause CP ' AND *'.
          lv_where_clause = lv_where_clause+5.
        ENDIF.

        " Realizar el SELECT solo si hay filtros
        IF lv_where_clause IS INITIAL.
          CONTINUE.
        ENDIF.

        SELECT DISTINCT knumh
          FROM (lv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE <ls_tab>
          WHERE (lv_where_clause).

        IF <ls_tab> IS INITIAL.
          CONTINUE.
        ENDIF.

        LOOP AT <ls_tab> ASSIGNING <ls_line>.
          ASSIGN COMPONENT 'KNUMH' OF STRUCTURE <ls_line> TO <ls_kunmh>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          " Buscar detalle de la condición en KONP
          SELECT SINGLE * FROM konp
            INTO @DATA(lwa_konp_din)
            WHERE knumh     = @<ls_kunmh>
              AND kbetr    <> '0.00'
              AND loevm_ko  = ' '.

          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          " Armar estructura de retorno
          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          <ls_return>-numero_condicion   = lwa_konp_din-knumh.
          <ls_return>-importe_condicion  = lwa_konp_din-kbetr.
          <ls_return>-cantidad_condicion = lwa_konp_din-kstbm.
          <ls_return>-unidad_medida      = lwa_konp_din-konms.

          " Asignar a la variable dinámica correspondiente según configuración
          CASE lwa_t003_descuen-campo_ref.
            WHEN 'DESC_DIN1'.
              <ls_return>-desc_din1 = lwa_konp_din-kbetr.
            WHEN 'DESC_DIN2'.
              <ls_return>-desc_din2 = lwa_konp_din-kbetr.
            WHEN 'DESC_DIN3'.
              <ls_return>-desc_din3 = lwa_konp_din-kbetr.
            WHEN 'DESC_DIN4'.
              <ls_return>-desc_din4 = lwa_konp_din-kbetr.
            WHEN 'DESC_DIN5'.
              <ls_return>-desc_din5 = lwa_konp_din-kbetr.
            WHEN 'PRECI_DIN1'.
              <ls_return>-preci_din1 = lwa_konp_din-kbetr.
            WHEN 'PRECI_DIN2'.
              <ls_return>-preci_din2 = lwa_konp_din-kbetr.
            WHEN 'PRECI_DIN3'.
              <ls_return>-preci_din3 = lwa_konp_din-kbetr.
            WHEN 'PRECI_DIN4'.
              <ls_return>-preci_din4 = lwa_konp_din-kbetr.
            WHEN 'PRECI_DIN5'.
              <ls_return>-preci_din5 = lwa_konp_din-kbetr.
          ENDCASE.
        ENDLOOP.
      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_DESCUENTOS_DINAMICOS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_PANTALLA                     TYPE        YDE_TIPODOC
* | [<---] RT_RETURN                      TYPE        YSD_TT_006_DESCUENTOS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_descuentos_dinamicos.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta descuentos dinámicos activos por organización de ventas.
    "                      Devuelve condiciones, tipo de descuento y tolerancias configuradas.
    " -----------------------------------------------------------------------

    " Declaración de variables locales
    DATA: lt_tolerancias TYPE STANDARD TABLE OF ysd_t005_toleran.     " Tabla de tolerancias para condiciones

    " Declaración de Field-Symbols descriptivos
    FIELD-SYMBOLS: <ls_return>     LIKE LINE OF rt_return,         " Registro de retorno
                   <ls_tolerancia> TYPE ysd_t005_toleran.          " Registro de tolerancia.

    " Declaración de constantes
    CONSTANTS: lc_krech_pct  TYPE c LENGTH 1 VALUE 'A',              " Identificador descuento porcentual
               lc_krech_imp  TYPE c LENGTH 1 VALUE 'B',              " Identificador descuento importe fijo
               lc_kmanu_manu TYPE c LENGTH 1 VALUE 'A',              " Entrada manual
               lc_kmanu_auto TYPE c LENGTH 1 VALUE 'B',              " Entrada automática
               lc_manu       TYPE string     VALUE 'MANUAL',        " Texto para entrada manual
               lc_auto       TYPE string     VALUE 'AUTOMATICO',    " Texto para entrada automática
               lc_pct        TYPE c LENGTH 1 VALUE '%'.              " Etiqueta porcentaje


    ycl_sd_utilitys=>get_consultar_des_dinamicos(
      EXPORTING
        i_vkorg    = i_org_ventas
        i_pantalla = i_pantalla
        i_activo   = abap_true
      IMPORTING
        e_table    = DATA(lt_descuentos)
    ).

    IF lt_descuentos IS NOT INITIAL.

      " Leer tolerancias asociadas a los descuentos obtenidos
      SELECT * FROM ysd_t005_toleran
        INTO TABLE lt_tolerancias
        FOR ALL ENTRIES IN lt_descuentos
        WHERE vkorg = lt_descuentos-vkorg
          AND kschl = lt_descuentos-kschl.


      LOOP AT lt_descuentos ASSIGNING FIELD-SYMBOL(<ls_descuento>).

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.

        <ls_return>-organizacion_venta  = <ls_descuento>-vkorg."Organizacion de ventas
        <ls_return>-tipo_documento      = <ls_descuento>-tipodoc."Cotizacion o Venta(Pantalla)
        <ls_return>-categoria_condicion = <ls_descuento>-koaid."Categoria de condicion
        <ls_return>-clase_condicion     = <ls_descuento>-kschl."Clase de condicion
        <ls_return>-clase_condicion_txt = <ls_descuento>-vtext."Texto de la clase de condicion
        <ls_return>-campo_ref           = <ls_descuento>-campo_ref."Campo DINAMICO de referencia
        <ls_return>-activo              = <ls_descuento>-activo.

        " Definir tipo de descuento (porcentaje o importe fijo)
        CASE <ls_descuento>-krech.
          WHEN lc_krech_pct.
            <ls_return>-etiqueta = lc_pct.
            <ls_return>-condp    = 2."Porcentaje
          WHEN lc_krech_imp.
            <ls_return>-condp    = 4."Fijo
        ENDCASE.

        " Definir modo de entrada (manual o automático)
        CASE <ls_descuento>-kmanu.
          WHEN lc_kmanu_manu OR ''." OR 'C'.
            <ls_return>-entrada = lc_manu.
          WHEN lc_kmanu_auto OR 'D' OR 'C'.
            <ls_return>-entrada = lc_auto.
        ENDCASE.

        ASSIGN lt_tolerancias[ vkorg = <ls_descuento>-vkorg
                               kschl = <ls_descuento>-kschl ] TO <ls_tolerancia>.
        IF sy-subrc = 0.
          <ls_return>-activa_tolerancia = abap_true.
          <ls_return>-tolerancia_a      = <ls_tolerancia>-tolerancia_a.
          <ls_return>-tolerancia_b      = <ls_tolerancia>-tolerancia_b.
        ELSE.
          <ls_return>-activa_tolerancia = abap_false.
        ENDIF.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message   = lv_msg.
      <ls_return>-messcode  = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_DIVISION
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_004_COBROS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_division.

    DATA: lt_tgsbt TYPE STANDARD TABLE OF tgsbt.

    FIELD-SYMBOLS: <fs_tgsbt>  LIKE LINE OF lt_tgsbt,
                   <fs_retunr> LIKE LINE OF rt_return.


    SELECT *
    FROM tgsbt
    INTO TABLE lt_tgsbt WHERE spras = sy-langu.


    IF lt_tgsbt IS NOT INITIAL.

      LOOP AT lt_tgsbt ASSIGNING <fs_tgsbt>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        MOVE <fs_tgsbt>-gsber TO <fs_retunr>-gsber.
        MOVE <fs_tgsbt>-gtext TO <fs_retunr>-gtext.

      ENDLOOP.
    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message = 'No se han encontrado registros'.
      <fs_retunr>-messcode = '400'.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_FLUJO_DOCUMENTO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_DOCUMENTO                    TYPE        VBFA-VBELN
* | [<---] RT_RETURN                      TYPE        YSD_TT_007_DOCUMENTO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_flujo_documento.
    DATA lv_documento TYPE vbfa-vbeln.
    DATA lv_tipo_doc  TYPE vbak-vbtyp.
    DATA lt_vbfas     TYPE TABLE OF vbfa.
    DATA ls_vbco6     TYPE vbco6.

    FIELD-SYMBOLS <fs_vbfas>  LIKE LINE OF lt_vbfas.
    FIELD-SYMBOLS <fs_retunr> LIKE LINE OF rt_return.

    lv_documento = i_documento.

    ls_vbco6-mandt = sy-mandt.
    ls_vbco6-vbeln = lv_documento.

    IF ls_vbco6-vbeln IS INITIAL.
      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      CONCATENATE <fs_retunr>-message  'NO ES POSIBLE REALIZAR EL FLUJO DEL DOCUMENTO' i_documento
                  INTO <fs_retunr>-message SEPARATED BY ' '.
      <fs_retunr>-messcode = '400'.
    ELSE.
      CALL FUNCTION 'RV_ORDER_FLOW_INFORMATION'
        EXPORTING
          aufbereitung  = '2'
          comwa         = ls_vbco6
          nachfolger    = 'X'
          n_stufen      = '50'
          vorgaenger    = 'X'
          v_stufen      = '50'
          no_acc_doc    = ' '
        IMPORTING
          belegtyp_back = lv_tipo_doc
        TABLES
          vbfa_tab      = lt_vbfas.
      IF sy-subrc <> 0.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        CONCATENATE <fs_retunr>-message  'NO SE ENCONTRO FLUJO PARA EL DOCUMENTO' lv_documento 'TIPO DE DOCUMENTO' lv_tipo_doc
                    INTO <fs_retunr>-message SEPARATED BY ' '.
        <fs_retunr>-messcode = '400'.

      ENDIF.

      IF sy-subrc = 0.

        IF lt_vbfas IS NOT INITIAL.

          LOOP AT lt_vbfas ASSIGNING <fs_vbfas>.

            APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.

*            <fs_retunr>-uuidreldoc       = <fs_vbfas>-ruuid."DELETE 100
            <fs_retunr>-doc_anterior    = <fs_vbfas>-vbelv.
            <fs_retunr>-posicion_anter  = <fs_vbfas>-posnv.
            <fs_retunr>-doc_subsig      = <fs_vbfas>-vbeln.
            <fs_retunr>-posicion_sig    = <fs_vbfas>-posnn.
            <fs_retunr>-tp_doc_subsig   = <fs_vbfas>-vbtyp_n.
            <fs_retunr>-cantidad        = <fs_vbfas>-rfmng.
            <fs_retunr>-um_base         = <fs_vbfas>-meins.
            <fs_retunr>-val_refer       = <fs_vbfas>-rfwrt.
            <fs_retunr>-moneda_estado   = <fs_vbfas>-waers.
            <fs_retunr>-tipo_doc_ant    = <fs_vbfas>-vbtyp_v.
            <fs_retunr>-pos_o_neg       = <fs_vbfas>-plmin.
            <fs_retunr>-ind_confirmac   = <fs_vbfas>-taqui.
            <fs_retunr>-creado          = <fs_vbfas>-erdat.
            <fs_retunr>-hora            = <fs_vbfas>-erzet.
            <fs_retunr>-material        = <fs_vbfas>-matnr.
            <fs_retunr>-cl_movimiento   = <fs_vbfas>-bwart.
            <fs_retunr>-cl_necesidad    = <fs_vbfas>-bdart.
            <fs_retunr>-clase_planific  = <fs_vbfas>-plart.
            <fs_retunr>-num_almacen     = <fs_vbfas>-lgnum.
            <fs_retunr>-modificado      = <fs_vbfas>-aedat.
            <fs_retunr>-tipo_factura    = <fs_vbfas>-fktyp.
            <fs_retunr>-peso_bruto      = <fs_vbfas>-brgew.
            <fs_retunr>-unidad_peso     = <fs_vbfas>-gewei.
            <fs_retunr>-volumen         = <fs_vbfas>-volum.
            <fs_retunr>-unidad_volumen  = <fs_vbfas>-voleh.
            <fs_retunr>-nun_plan_fact   = <fs_vbfas>-fplnr.
            <fs_retunr>-posicion        = <fs_vbfas>-fpltr.
            <fs_retunr>-cant_um_vent    = <fs_vbfas>-rfmng_flo.
            <fs_retunr>-cant_um_base    = <fs_vbfas>-rfmng_flt.
            <fs_retunr>-um_venta        = <fs_vbfas>-vrkme.
            <fs_retunr>-garantizado     = <fs_vbfas>-abges.
            <fs_retunr>-stock_especial  = <fs_vbfas>-sobkz.
            <fs_retunr>-nun_stock_esp   = <fs_vbfas>-sonum.
            <fs_retunr>-determstockacti = <fs_vbfas>-kzbef.
            <fs_retunr>-peso_neto       = <fs_vbfas>-ntgew.
            <fs_retunr>-sistema_logico  = <fs_vbfas>-logsys.
            <fs_retunr>-statmovimmcia   = <fs_vbfas>-wbsta.
            <fs_retunr>-metodo_convers  = <fs_vbfas>-cmeth.
            <fs_retunr>-ejerc_doc_mat   = <fs_vbfas>-mjahr.
            <fs_retunr>-nivel           = <fs_vbfas>-stufe.
*            <fs_retunr>-data_filter_value = <fs_vbfas>-_dataaging."DELETE 100

          ENDLOOP.

        ENDIF.

      ENDIF.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_GRUPO_ARTICULO
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_grupo_articulo.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta de grupos de artículos y sus descripciones
    "                      Retorna lista de grupos de artículos activos con descripción en idioma español
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t023,
             matkl TYPE t023-matkl,          ". Grupo de artículos
           END OF lty_t023.

    TYPES: BEGIN OF lty_t023t,
             matkl   TYPE t023t-matkl,       ". Grupo de artículos
             wgbez60 TYPE t023t-wgbez60,     ". Descripción del grupo
             spras   TYPE t023t-spras,       ". Idioma
           END OF lty_t023t.

    " Declaración de variables locales
    DATA: lt_t023  TYPE STANDARD TABLE OF lty_t023,      ". Grupos de artículos encontrados
          lt_t023t TYPE STANDARD TABLE OF lty_t023t.     ". Descripciones por idioma

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_t023>   TYPE lty_t023,              ". Registro de grupo de artículo
                   <ls_t023t>  TYPE lty_t023t,             ". Registro de descripción
                   <ls_return> LIKE LINE OF rt_return.     ". Registro de tabla de retorno

    " Consulta los grupos de artículos
    SELECT matkl
      FROM t023
      INTO TABLE lt_t023.

    IF lt_t023 IS NOT INITIAL.

      " Consulta las descripciones
      SELECT matkl wgbez60 spras
        FROM t023t
        INTO TABLE lt_t023t
        FOR ALL ENTRIES IN lt_t023
        WHERE matkl = lt_t023-matkl
          AND spras = 'S'.

      LOOP AT lt_t023 ASSIGNING <ls_t023>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-grupo_articulos = <ls_t023>-matkl.

        ASSIGN lt_t023t[ matkl = <ls_t023>-matkl ] TO <ls_t023t>.
        IF sy-subrc = 0.
          <ls_return>-descripcion = <ls_t023t>-wgbez60.
        ENDIF.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_GRUPO_VENDEDORES
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_OFICINA                      TYPE        TVBVK-VKBUR
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_grupo_vendedores.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtener los grupos de vendedores por oficina de ventas,
    "                     incluyendo su denominación.
    " -----------------------------------------------------------------------

    TYPES: BEGIN OF lty_grupo_vendedores,
             vkbur TYPE tvbvk-vkbur, " Oficina de ventas
             vkgrp TYPE tvbvk-vkgrp, " Grupo de vendedores
             bezei TYPE tvgrt-bezei, " Denominación grupo
           END OF lty_grupo_vendedores.

    DATA lt_grupos TYPE STANDARD TABLE OF lty_grupo_vendedores.

    FIELD-SYMBOLS: <ls_grupo> TYPE lty_grupo_vendedores,
                   <ls_ret>   LIKE LINE OF rt_return.

    " Obtener grupos de vendedores con sus descripciones
    SELECT DISTINCT
           a~vkbur,
           a~vkgrp,
           b~bezei
      INTO TABLE @lt_grupos
      FROM tvbvk AS a
           INNER JOIN tvgrt AS b
           ON b~vkgrp = a~vkgrp
      WHERE a~vkbur = @i_oficina
        AND b~spras = @sy-langu.

    IF lt_grupos IS NOT INITIAL.

      LOOP AT lt_grupos ASSIGNING <ls_grupo>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-oficinas_ventas   = <ls_grupo>-vkbur.
        <ls_ret>-grupo_vendedores = <ls_grupo>-vkgrp.
        <ls_ret>-denominacion_ov  = <ls_grupo>-bezei.
      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_ret>-message   = lv_msg.
      <ls_ret>-messcode  = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_JERARQUIA_PRODUCTO
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_jerarquia_producto.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtiene la jerarquía de productos y sus descripciones
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t179,
             prodh TYPE t179-prodh,      ". Código de jerarquía de productos
           END OF lty_t179.

    TYPES: BEGIN OF lty_t179t,
             prodh TYPE t179t-prodh,     ". Código de jerarquía de productos
             vtext TYPE t179t-vtext,     ". Descripción de la jerarquía
             spras TYPE t179t-spras,     ". Idioma
           END OF lty_t179t.

    " Declaración de variables locales
    DATA: lt_jerarquias    TYPE STANDARD TABLE OF lty_t179,    ". Jerarquías encontradas
          lt_jerarquias_tx TYPE STANDARD TABLE OF lty_t179t.   ". Descripciones encontradas

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_jerarquia>    TYPE lty_t179,            ". Registro de jerarquía
                   <ls_jerarquia_tx> TYPE lty_t179t,           ". Registro de descripción
                   <ls_return>       LIKE LINE OF rt_return.   ". Registro de retorno

    " Obtener jerarquías de producto existentes
    SELECT prodh
      FROM t179
      INTO TABLE lt_jerarquias.

    IF lt_jerarquias IS NOT INITIAL.

      " Obtener las descripciones
      SELECT prodh vtext spras
        FROM t179t
        INTO TABLE lt_jerarquias_tx
        FOR ALL ENTRIES IN lt_jerarquias
        WHERE prodh = lt_jerarquias-prodh
          AND spras = 'S'.

      LOOP AT lt_jerarquias ASSIGNING <ls_jerarquia>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-jerarquia_productos = <ls_jerarquia>-prodh.

        IF lt_jerarquias_tx IS NOT INITIAL.
          ASSIGN lt_jerarquias_tx[ prodh = <ls_jerarquia>-prodh ] TO <ls_jerarquia_tx>.
          IF sy-subrc = 0.
            <ls_return>-descripcion = <ls_jerarquia_tx>-vtext.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_LIMITE_FACTURA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_OFICINA                      TYPE        VKBUR(optional)
* | [--->] I_CLIENTE                      TYPE        VBAK-KUNNR(optional)
* | [--->] I_DESTINATARIO                 TYPE        VBAK-KUNNR(optional)
* | [--->] I_NIT                          TYPE        VBPA3-STCD1(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_008_LIMITE_FACTURA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_limite_factura.
    DATA:
* ls_config       type zsd_008_limifact,
          ls_resultado    TYPE ysd_s_008_limite_factura.
*          lv_monto_total  type wrbtr,
*          lv_fecha_inicio type sy-datum,
*          lv_destinatario type kunnr.
*
*    clear rt_return.
*
*    " Leer configuración activa
*    select single * into @ls_config
*      from zsd_008_limifact
*      where vkorg = @i_org_ventas
*        and estado = 'X'.
*
*    if sy-subrc <> 0.
*      ls_resultado-messcode = '400'.
*      ls_resultado-message  = |No se encontró configuración activa para la org. de ventas { i_org_ventas }|.
*      append ls_resultado to rt_return.
*      return.
*    endif.
*
*    " Calcular fecha de inicio según duración configurada
*    lv_fecha_inicio = sy-datum - ls_config-duracion_limite + 1.
*
*    if i_destinatario is initial.
*      lv_destinatario = i_cliente.
*    else.
*      lv_destinatario = i_destinatario.
*    endif.
*    lv_destinatario = |{ lv_destinatario alpha = in }|.
*
*    if i_nit is not initial.
*
*      " Buscar cliente por el destinatario
*      select single xcpdk into @data(lv_cliente_cpd)
*        from kna1
*        where kunnr = @lv_destinatario.
*
*    endif.
*    if lv_cliente_cpd = 'X'.
*
*      if ls_config-por_oficina = 'X'.
*
*        " Modo agrupado por oficina de ventas
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrp
*          inner join vbrk on vbrk~vbeln = vbrp~vbeln
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          inner join vbpa3 on vbpa3~vbeln = vbrk~vbeln
*          and vbpa3~parvw = vbpa~parvw
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum
*            and vbrp~vkbur = @i_oficina
*            and vbpa3~stcd1 = @i_nit.
*
*      elseif ls_config-por_ciudad = 'X'.
*
*        data(lv_ciudad) = i_oficina(2).
*        data(lv_filtro_ciudad) = |{ lv_ciudad }%|.
*
*        " Modo agrupado por ciudad (2 primeras letras de VKBUR)
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrp
*          inner join vbrk on vbrk~vbeln = vbrp~vbeln
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          inner join vbpa3 on vbpa3~vbeln = vbrk~vbeln
*          and vbpa3~parvw = vbpa~parvw
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum
*            and vbrp~vkbur like @lv_filtro_ciudad
*          and vbpa3~stcd1 = @i_nit.
*
*      else.
*
*        " Modo normal por destinatario
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrk
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          inner join vbpa3 on vbpa3~vbeln = vbrk~vbeln
*          and vbpa3~parvw = vbpa~parvw
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum
*          and vbpa3~stcd1 = @i_nit.
*
*      endif.
*
*    else.
*      if ls_config-por_oficina = 'X'.
*
*        " Modo agrupado por oficina de ventas
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrp
*          inner join vbrk on vbrk~vbeln = vbrp~vbeln
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum
*            and vbrp~vkbur = @i_oficina.
*
*      elseif ls_config-por_ciudad = 'X'.
*
*        data(lv_ciudad1) = i_oficina(2).
*        data(lv_filtro_ciudad1) = |{ lv_ciudad1 }%|.
*
*        " Modo agrupado por ciudad (2 primeras letras de VKBUR)
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrp
*          inner join vbrk on vbrk~vbeln = vbrp~vbeln
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum
*            and vbrp~vkbur like @lv_filtro_ciudad1.
*
*      else.
*
*        " Modo normal por destinatario
*        select sum( vbrk~netwr ) into @lv_monto_total
*          from vbrk
*          inner join vbpa on vbpa~vbeln = vbrk~vbeln
*          where vbpa~parvw = 'RE'
*            and vbpa~kunnr = @lv_destinatario
*            and vbrk~vkorg = @i_org_ventas
*            and vbrk~fkdat between @lv_fecha_inicio and @sy-datum.
*
*      endif.
*    endif.
    " Preparar salida
    ls_resultado-organizacion_venta = i_org_ventas.
    ls_resultado-cliente            = i_cliente.
*    ls_resultado-moneda             = ls_config-moneda.
    ls_resultado-monto_limite       = 999999999.
*    ls_resultado-duracion_limite    = ls_config-duracion_limite.
*    ls_resultado-monto_factura      = lv_monto_total.
*    ls_resultado-mensaje = ls_config-mensaje.
*    replace '&' in ls_resultado-mensaje with lv_destinatario.
    APPEND ls_resultado TO rt_return.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_LOTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ARTICULO                     TYPE        MATNR
* | [--->] I_CENTRO                       TYPE        WERKS_D
* | [--->] I_ALMACEN                      TYPE        MCHB-LGORT
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_lote.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 04.05.2025
    " ^ Descripción.....: Consulta lotes disponibles para un material, centro y almacén
    " -----------------------------------------------------------------------

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_return> LIKE LINE OF rt_return. " Línea de la tabla de retorno

    " Se lee de la tabla MCHB (Stocks de lote) y se une con MCHA (Lotes)
    " para obtener la fecha de caducidad (VFDAT).
    " El resultado se ordena por VFDAT de forma ascendente para que el lote
    " más próximo a vencer aparezca primero.
    SELECT mchb~matnr,
           mchb~werks,
           mchb~charg,
           mchb~lgort,
           mcha~vfdat
      FROM mchb
      INNER JOIN mcha ON mcha~matnr = mchb~matnr AND mcha~charg = mchb~charg
      WHERE mchb~matnr = @i_articulo
        AND mchb~werks = @i_centro
        AND mchb~lgort = @i_almacen
        AND mchb~clabs > 0  " Stock de libre utilización
      ORDER BY mcha~vfdat ASCENDING
      INTO TABLE @DATA(lt_lotes).

    IF lt_lotes IS NOT INITIAL.
      " Si se encontraron lotes, se mapean a la tabla de retorno
      rt_return = CORRESPONDING #( lt_lotes MAPPING lote    = charg
                                                   articulo = matnr
                                                   centro   = werks
                                                   almacen  = lgort ).
    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_return>-message  = lv_msg.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ARTICULO                     TYPE        MARA-MATNR
* | [--->] I_CENTRO                       TYPE        WERKS_EXT
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_material.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtener información general de materiales incluyendo
    "^                    textos, datos comerciales, jerarquías y ubicación.
    "+---------------------------------------------------------------------+

    " Tipos locales
    TYPES: BEGIN OF lty_mara,
             matnr TYPE mara-matnr, " Código material
             meins TYPE mara-meins, " Unidad de medida base
             matkl TYPE mara-matkl, " Grupo de artículos
             brgew TYPE mara-brgew, " Peso bruto
             ntgew TYPE mara-ntgew, " Peso neto
             xchpf TYPE mara-xchpf, " Indicador de gestión por lotes
             mfrpn TYPE mara-mfrpn, " Número de pieza del fabricante
             prdha TYPE mara-prdha, " Jerarquía de productos
             bismt TYPE mara-bismt, " Número de material antiguo
             mtart TYPE mara-mtart, " Tipo de material
             bstme TYPE mara-bstme, " UM pedido
           END OF lty_mara.

    TYPES: BEGIN OF lty_makt,
             matnr TYPE makt-matnr,
             maktx TYPE makt-maktx,
           END OF lty_makt.

    TYPES: BEGIN OF lty_mvke,
             matnr TYPE mvke-matnr,
             vkorg TYPE mvke-vkorg,
             vtweg TYPE mvke-vtweg,
             vrkme TYPE mvke-vrkme,
           END OF lty_mvke.

    TYPES: BEGIN OF lty_marc,
             matnr TYPE marc-matnr,
             herkl TYPE marc-herkl,
           END OF lty_marc.

    TYPES: BEGIN OF lty_mchb,
             matnr TYPE mchb-matnr,
             werks TYPE mchb-werks,
             charg TYPE mchb-charg,
             lgort TYPE mchb-lgort,
           END OF lty_mchb.

    TYPES: BEGIN OF lty_mard,
             matnr TYPE mard-matnr,
             werks TYPE mard-werks,
             lgort TYPE mard-lgort,
             labst TYPE mard-labst,
           END OF lty_mard.

    " Declaración de variables
    DATA lt_mara  TYPE STANDARD TABLE OF lty_mara.                                                                       " Materiales
    DATA lt_makt  TYPE STANDARD TABLE OF lty_makt.                                                                       " Textos
    DATA lt_mvke  TYPE STANDARD TABLE OF lty_mvke.                                                                       " Datos comerciales
    DATA lt_marc  TYPE STANDARD TABLE OF lty_marc.                                                                       " Datos centro
    DATA lt_mchb  TYPE STANDARD TABLE OF lty_mchb.                                                                       " Lotes
    DATA lt_mard  TYPE STANDARD TABLE OF lty_mard.                                                                       " Stock
    DATA lt_matnr TYPE STANDARD TABLE OF lty_makt.                                                                       " Lista de materiales
    DATA lv_msg   TYPE string.                                                             " Mensaje
    DATA lv_extnd TYPE abap_bool                                          VALUE abap_true. " Búsqueda extendida
    DATA lv_req   TYPE if_dsh_type_ahead_processor=>ty_type_ahead_request.                 " Petición búsqueda
    DATA lv_rows  TYPE i.                                                                  " Máx resultados

    DATA lo_dsh   TYPE REF TO if_dsh_type_ahead_processor.                                 " Objeto búsqueda
    DATA lo_desc  TYPE REF TO cl_abap_tabledescr.
    DATA lo_data  TYPE REF TO data.

    FIELD-SYMBOLS <ls_mara>   TYPE lty_mara.
    FIELD-SYMBOLS <ls_makt>   TYPE lty_makt.
    FIELD-SYMBOLS <ls_mvke>   TYPE lty_mvke.
    FIELD-SYMBOLS <ls_marc>   TYPE lty_marc.
    FIELD-SYMBOLS <ls_mchb>   TYPE lty_mchb.
    FIELD-SYMBOLS <ls_mard>   TYPE lty_mard.
    FIELD-SYMBOLS <ls_matnr>  TYPE matnr.
    FIELD-SYMBOLS <ls_matnrs> TYPE lty_makt.
    FIELD-SYMBOLS <lt_result> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_ret>    LIKE LINE OF rt_return.

    " Carga de materiales
    IF i_articulo IS INITIAL.
      SELECT mara~matnr meins matkl brgew ntgew xchpf mfrpn prdha bismt mtart bstme
        FROM mara
        INNER JOIN mvke
        ON mara~matnr = mvke~matnr
        INTO TABLE lt_mara.
    ELSE.
      "Búqueda similar al estándar
      lo_dsh = cl_dsh_type_ahead_processor=>create_instance_for_shlp( i_search_help_name            = 'SD_MAT1'
                                                                      i_use_extended_select_options = lv_extnd
                                                                      i_force_type_ahead            = abap_true ).

      lo_desc = lo_dsh->get_result_descriptor( ).
      CREATE DATA lo_data TYPE HANDLE lo_desc.
      ASSIGN lo_data->* TO <lt_result>.

      lv_req = i_articulo.
      lo_dsh->get_type_ahead_values( EXPORTING i_type_ahead_request = lv_req
                                               i_max_results        = lv_rows
                                     IMPORTING e_type_ahead_values  = <lt_result> ).

      LOOP AT <lt_result> ASSIGNING FIELD-SYMBOL(<ls_materials>).
        ASSIGN COMPONENT 'MATNR' OF STRUCTURE <ls_materials> TO <ls_matnr>.
        IF sy-subrc = 0.
          APPEND INITIAL LINE TO lt_matnr ASSIGNING <ls_matnrs>.
          <ls_matnrs>-matnr = <ls_matnr>.
        ENDIF.
      ENDLOOP.

      SELECT matnr meins matkl brgew ntgew xchpf mfrpn prdha bismt mtart bstme
        FROM mara
        INTO TABLE lt_mara
        FOR ALL ENTRIES IN lt_matnr
        WHERE matnr = lt_matnr-matnr.
    ENDIF.

    IF lt_mara IS NOT INITIAL.

      SELECT matnr maktx FROM makt
        INTO TABLE lt_makt
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr.

      SELECT matnr vkorg vtweg vrkme FROM mvke
        INTO TABLE lt_mvke
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr.

      SELECT matnr herkl FROM marc
        INTO TABLE lt_marc
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr.

      SELECT matnr werks charg lgort FROM mchb
        INTO TABLE lt_mchb
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr AND werks = i_centro AND clabs > 0.

      SELECT matnr werks lgort FROM mard
        INTO TABLE lt_mard
        FOR ALL ENTRIES IN lt_mara
        WHERE matnr = lt_mara-matnr AND werks = i_centro AND labst > 0.

      LOOP AT lt_mara ASSIGNING <ls_mara>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.

        <ls_ret>-articulo            = <ls_mara>-matnr.
        <ls_ret>-grupo_articulos     = <ls_mara>-matkl.
        <ls_ret>-jerarquia_productos = <ls_mara>-prdha.
        <ls_ret>-numero_material_ant = <ls_mara>-bismt.
        <ls_ret>-tipo_material       = <ls_mara>-mtart.
        <ls_ret>-numero_p_fabricante = <ls_mara>-mfrpn.

        ASSIGN lt_makt[ matnr = <ls_mara>-matnr ] TO <ls_makt>.
        IF sy-subrc = 0.
          <ls_ret>-descripcion = <ls_makt>-maktx.
        ENDIF.

        ASSIGN lt_mvke[ matnr = <ls_mara>-matnr ] TO <ls_mvke>.
        IF sy-subrc = 0.
          <ls_ret>-organizacion_venta = <ls_mvke>-vkorg.
          <ls_ret>-canal              = <ls_mvke>-vtweg.
          <ls_ret>-unidad_medida      = COND #( WHEN <ls_mvke>-vrkme IS NOT INITIAL
                                                THEN <ls_mvke>-vrkme
                                                ELSE <ls_mara>-meins ).
        ENDIF.

        <ls_ret>-peso_bruto = COND #( WHEN <ls_mara>-brgew IS NOT INITIAL AND <ls_ret>-unidad_medida <> 'KG'
                                      THEN <ls_mara>-brgew
                                      ELSE 1 ).
        <ls_ret>-peso_neto  = COND #( WHEN <ls_mara>-ntgew IS NOT INITIAL AND <ls_ret>-unidad_medida <> 'KG'
                                      THEN <ls_mara>-ntgew
                                      ELSE 1 ).

        ASSIGN lt_marc[ matnr = <ls_mara>-matnr ] TO <ls_marc>.
        IF sy-subrc = 0.
          <ls_ret>-pais = <ls_marc>-herkl.
        ENDIF.

        IF <ls_mara>-xchpf = abap_true.
          ASSIGN lt_mchb[ matnr = <ls_mara>-matnr ] TO <ls_mchb>.
          IF sy-subrc = 0.
            <ls_ret>-lote    = <ls_mchb>-charg.
            <ls_ret>-almacen = <ls_mchb>-lgort.
            <ls_ret>-centro  = <ls_mchb>-werks.
          ENDIF.
        ELSE.
          ASSIGN lt_mard[ matnr = <ls_mara>-matnr ] TO <ls_mard>.
          IF sy-subrc = 0.
            <ls_ret>-almacen = <ls_mard>-lgort.
            <ls_ret>-centro  = <ls_mard>-werks.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_METODO_PAGO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVKOV-VKORG
* | [<---] RT_RETURN                      TYPE        YSD_TT_004_COBROS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_metodo_pago.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: FI
    " ^ Funcional.......: Oscar Gomez
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 04.05.2025
    " ^ Descripción.....: Métodos de pago configurados en YFI_T001_METPAGO.
    " -----------------------------------------------------------------------

    " Declaración de variables
    DATA lt_metodos_pago TYPE STANDARD TABLE OF yfi_t001_metpago. " Lista de métodos de pago

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_metodo_pago> TYPE yfi_t001_metpago.
    FIELD-SYMBOLS <ls_return>      LIKE LINE OF rt_return.

    " Consultar métodos de pago configurados
    IF i_org_ventas IS INITIAL.
      SELECT * FROM yfi_t001_metpago INTO TABLE lt_metodos_pago.
    ELSE.
      SELECT * FROM yfi_t001_metpago
        WHERE vkorg = @i_org_ventas
        INTO TABLE @lt_metodos_pago.
    ENDIF.
    IF lt_metodos_pago IS NOT INITIAL.
      SORT lt_metodos_pago BY met_pag ASCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_metodos_pago COMPARING met_pag.
      LOOP AT lt_metodos_pago ASSIGNING <ls_metodo_pago>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-vkorg = i_org_ventas.
        <ls_return>-met_pag = <ls_metodo_pago>-met_pag. " Código de método de pago
        <ls_return>-txt_pag = <ls_metodo_pago>-txt_pag. " Descripción del método de pago
      ENDLOOP.


    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_MOTIVO_EXPEDICION
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_motivo_expedicion.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Recuperar lista de condiciones de expedición con
    "^                    su descripción
    "+---------------------------------------------------------------------+

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_tvsbt,
             vsbed TYPE tvsbt-vsbed, " Clave condición de expedición
             vtext TYPE tvsbt-vtext, " Texto condición expedición
           END OF lty_tvsbt.

    " Declaración de variables internas
    DATA lt_tvsbt   TYPE STANDARD TABLE OF lty_tvsbt. " Lista de condiciones
    DATA lv_msg     TYPE string.                      " Mensaje para retorno

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_tvsbt>  TYPE lty_tvsbt.
    FIELD-SYMBOLS <ls_ret>    LIKE LINE OF rt_return.

    " Lectura de condiciones de expedición
    SELECT vsbed, vtext
      INTO TABLE @lt_tvsbt
      FROM tvsbt
      WHERE spras = 'S'.

    IF lt_tvsbt IS NOT INITIAL.

      LOOP AT lt_tvsbt ASSIGNING <ls_tvsbt>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-motivo_expedicion   = <ls_tvsbt>-vsbed.
        <ls_ret>-denominacion_varias = <ls_tvsbt>-vtext.
      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_MOTIVO_PEDIDO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVKOV-VKORG
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_motivo_pedido.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 05.05.2025
    "^ Descripción.....: Obtener motivos de pedido por clase de documento
    "^                    y organización de ventas.
    "+---------------------------------------------------------------------+

    " Tipos locales para datos de motivos y descripciones
    TYPES: BEGIN OF lty_tvau,
             vkorg TYPE tvau_auart_vko-vkorg, " Organización de ventas
             auart TYPE tvau_auart_vko-auart, " Clase de documento
             augru TYPE tvau_auart_vko-augru, " Motivo de pedido
           END OF lty_tvau.

    TYPES: BEGIN OF lty_param,
             doc_type_c TYPE ysd_t001_paramet-doc_type_c, " Clase doc ventas
           END OF lty_param.

    TYPES: BEGIN OF lty_tvaut,
             augru TYPE tvaut-augru, " Motivo de pedido
             bezei TYPE tvaut-bezei, " Descripción motivo
           END OF lty_tvaut.

    " Declaración de variables internas
    DATA lt_tvau  TYPE STANDARD TABLE OF lty_tvau.           " Motivos por clase/venta
    DATA lt_tvaut TYPE STANDARD TABLE OF lty_tvaut.           " Textos motivos
    DATA lt_param TYPE STANDARD TABLE OF lty_param.           " Parámetros z*
    DATA lv_msg   TYPE string. " Mensaje texto

    FIELD-SYMBOLS <ls_tvau>  TYPE lty_tvau.
    FIELD-SYMBOLS <ls_tvaut> TYPE lty_tvaut.
    FIELD-SYMBOLS <ls_ret>   LIKE LINE OF rt_return.

    " Leer clases de documento parametrizadas
    SELECT doc_type_c FROM ysd_t001_paramet
      INTO TABLE @lt_param.

    " Obtener motivos válidos por clase y organización de ventas
    IF i_org_ventas IS NOT INITIAL.
      SELECT vkorg, auart, augru INTO TABLE @lt_tvau
        FROM tvau_auart_vko
        FOR ALL ENTRIES IN @lt_param
        WHERE auart = @lt_param-doc_type_c
          AND vkorg = @i_org_ventas.
*{INSERT @100
      IF sy-subrc <> 0.
        SELECT augru INTO CORRESPONDING FIELDS OF TABLE @lt_tvau
        FROM tvau.
      ENDIF.
*}INSERT @100
    ELSE.
      SELECT vkorg, auart, augru INTO TABLE @lt_tvau
        FROM tvau_auart_vko.
*{INSERT @100
      IF sy-subrc <> 0.
        SELECT augru INTO CORRESPONDING FIELDS OF TABLE @lt_tvau
        FROM tvau.
      ENDIF.
*}INSERT @100
    ENDIF.

    IF lt_tvau IS NOT INITIAL.

      " Leer descripciones de motivos
      SELECT augru, bezei INTO TABLE @lt_tvaut
        FROM tvaut
        FOR ALL ENTRIES IN @lt_tvau
        WHERE augru = @lt_tvau-augru
          AND spras = @sy-langu.

      LOOP AT lt_tvau ASSIGNING <ls_tvau>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.

        <ls_ret>-organizacion_venta = <ls_tvau>-vkorg.
        <ls_ret>-clase_documento    = <ls_tvau>-auart.
        <ls_ret>-motivo_pedido      = <ls_tvau>-augru.

        ASSIGN lt_tvaut[ augru = <ls_tvau>-augru ] TO <ls_tvaut>.
        IF sy-subrc = 0.
          <ls_ret>-denominacion_ov = <ls_tvaut>-bezei.
        ENDIF.
      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_MOTIVO_RECHAZO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVKOV-VKORG
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_motivo_rechazo.

    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 03.05.2025
    "^ Descripción.....: Consulta de motivos de rechazo por organización de
    "^ ventas y tipo de documento
    "+---------------------------------------------------------------------+

    " Tipos locales
    TYPES: BEGIN OF lty_tvag_auart_vko,
             vkorg TYPE tvag_auart_vko-vkorg,
             abgru TYPE tvag_auart_vko-abgru,
             auart TYPE tvag_auart_vko-auart,
           END OF lty_tvag_auart_vko,
           BEGIN OF lty_tvagt,
             abgru TYPE tvagt-abgru,
             bezei TYPE tvagt-bezei,
             spras TYPE tvagt-spras,
           END OF lty_tvagt,
           BEGIN OF lty_parametros,
             doc_type_c TYPE ysd_t001_paramet-doc_type_c,
             doc_type_p TYPE ysd_t001_paramet-doc_type_p,
           END OF lty_parametros.

    " Declaración de variables
    DATA: lt_tvag_auart_vko TYPE STANDARD TABLE OF lty_tvag_auart_vko,
          lt_tvagt          TYPE STANDARD TABLE OF lty_tvagt,
          lt_parametros     TYPE STANDARD TABLE OF lty_parametros.

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_tvag_auart_vko> TYPE lty_tvag_auart_vko,
                   <ls_tvagt>          TYPE lty_tvagt,
                   <ls_return>         LIKE LINE OF rt_return.

    " Rango para exclusiones de motivos de rechazo
    DATA: lr_abgru TYPE RANGE OF abgru,
          ls_abgru LIKE LINE OF lr_abgru.

    CONSTANTS: lc_abgru_var TYPE c LENGTH 15 VALUE 'ZSD_ABGRU'.

    " Leer exclusiones desde TVARVC
    SELECT sign, opti AS option, low, high
      FROM tvarvc
      INTO CORRESPONDING FIELDS OF TABLE @lr_abgru
      WHERE name = @lc_abgru_var.

    " Leer parámetros por organización
    SELECT doc_type_c, doc_type_p
      FROM ysd_t001_paramet
      INTO TABLE @lt_parametros
      WHERE vkorg = @i_org_ventas.

    DELETE ADJACENT DUPLICATES FROM lt_parametros.

    " Leer motivos de rechazo
    IF i_org_ventas IS NOT INITIAL.
      SELECT vkorg, abgru, auart
        FROM tvag_auart_vko
        INTO TABLE @lt_tvag_auart_vko
        FOR ALL ENTRIES IN @lt_parametros
        WHERE vkorg = @i_org_ventas
          AND ( auart = @lt_parametros-doc_type_c OR auart = @lt_parametros-doc_type_p )
          AND abgru NOT IN @lr_abgru.
    ELSE.
      SELECT vkorg, abgru, auart
        FROM tvag_auart_vko
        INTO TABLE @lt_tvag_auart_vko
        FOR ALL ENTRIES IN @lt_parametros
        WHERE ( auart = @lt_parametros-doc_type_c OR auart = @lt_parametros-doc_type_p )
          AND abgru NOT IN @lr_abgru.
    ENDIF.

    SORT lt_tvag_auart_vko BY vkorg abgru ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_tvag_auart_vko COMPARING abgru.

    " Leer descripciones
    SELECT abgru, bezei, spras
      FROM tvagt
      INTO TABLE @lt_tvagt
      FOR ALL ENTRIES IN @lt_tvag_auart_vko
      WHERE abgru = @lt_tvag_auart_vko-abgru
        AND spras = 'S'.

    IF lt_tvag_auart_vko IS NOT INITIAL.
      LOOP AT lt_tvag_auart_vko ASSIGNING <ls_tvag_auart_vko>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-organizacion_venta = <ls_tvag_auart_vko>-vkorg.
        <ls_return>-motivo_rechazo     = <ls_tvag_auart_vko>-abgru.
        <ls_return>-clase_documento    = <ls_tvag_auart_vko>-auart.

        READ TABLE lt_tvagt ASSIGNING <ls_tvagt> WITH KEY abgru = <ls_tvag_auart_vko>-abgru.
        IF sy-subrc = 0.
          <ls_return>-denominacion_ov = <ls_tvagt>-bezei.
        ENDIF.

      ENDLOOP.
    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_message).
      <ls_return>-message  = lv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_NIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NIT                          TYPE        STCD1
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_nit.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta de documento comercial y referencia del cliente
    " ^                   según NIT ingresado.
    " -----------------------------------------------------------------------

    " Declaración de Tipos Locales
    TYPES: BEGIN OF lty_vbpa3,
             stcd1 TYPE vbpa3-stcd1,  " NIT del cliente
             vbeln TYPE vbpa3-vbeln,  " Documento de ventas
             parvw TYPE vbpa3-parvw,  " Función del interlocutor
           END OF lty_vbpa3,

           BEGIN OF lty_vbpa,
             vbeln TYPE vbpa-vbeln,   " Documento de ventas
             xcpdk TYPE vbpa-xcpdk,   " Indicador CPD
             adrnr TYPE vbpa-adrnr,   " Dirección del cliente
           END OF lty_vbpa,

           BEGIN OF lty_adrc,
             addrnumber TYPE adrc-addrnumber, " Número de dirección
             name1      TYPE adrc-name1,      " Nombre 1
             name2      TYPE adrc-name2,      " Nombre 2
           END OF lty_adrc.

    " Declaración de Variables Locales
    DATA: lt_vbpa3 TYPE STANDARD TABLE OF lty_vbpa3,  " Tabla de documentos con NIT
          lt_vbpa  TYPE STANDARD TABLE OF lty_vbpa,   " Tabla de interlocutores CPD
          lt_adrc  TYPE STANDARD TABLE OF lty_adrc.   " Tabla de direcciones ADRC

    " Declaración de Field-Symbols
    FIELD-SYMBOLS: <ls_vbpa3>  TYPE lty_vbpa3,
                   <ls_vbpa>   TYPE lty_vbpa,
                   <ls_adrc>   TYPE lty_adrc,
                   <ls_return> LIKE LINE OF rt_return.

    " Consulta de documentos por NIT y función RE
    SELECT stcd1, vbeln, parvw
      FROM vbpa3
      INTO TABLE @lt_vbpa3
      WHERE stcd1 = @i_nit
        AND parvw = 'RE'
        AND stcd1 <> ''.

    " Consulta de interlocutores CPD para los documentos encontrados
    IF lt_vbpa3 IS NOT INITIAL.
      SELECT vbeln, xcpdk, adrnr
        FROM vbpa
        INTO TABLE @lt_vbpa
        FOR ALL ENTRIES IN @lt_vbpa3
        WHERE vbeln = @lt_vbpa3-vbeln
          AND xcpdk = 'X'.

      " Consulta de direcciones asociadas
      SELECT addrnumber, name1, name2
        FROM adrc
        INTO TABLE @lt_adrc
        FOR ALL ENTRIES IN @lt_vbpa
        WHERE addrnumber = @lt_vbpa-adrnr.

      READ TABLE lt_vbpa3 ASSIGNING <ls_vbpa3> WITH KEY stcd1 = i_nit.
      IF sy-subrc = 0.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-nit_cpd   = <ls_vbpa3>-stcd1.
        <ls_return>-documento = <ls_vbpa3>-vbeln.

        " Buscar referencia del cliente
        READ TABLE lt_vbpa ASSIGNING <ls_vbpa> WITH KEY vbeln = <ls_vbpa3>-vbeln.
        IF sy-subrc = 0.
          READ TABLE lt_adrc ASSIGNING <ls_adrc> WITH KEY addrnumber = <ls_vbpa>-adrnr.
          IF sy-subrc = 0.
            <ls_return>-referencia_cliente = <ls_adrc>-name1.
            IF <ls_adrc>-name2 IS NOT INITIAL.
              <ls_return>-referencia_cliente = <ls_adrc>-name1 && <ls_adrc>-name2.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.

      IF rt_return IS INITIAL.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
        <ls_return>-message  = gv_message.
        <ls_return>-messcode = gc_error_400.
      ENDIF.

    ELSE.
      " NIT no encontrado
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_ORG_VENTAS
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_org_ventas.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 02.05.2025
    " ^ Descripción.....: Obtener organizaciones de ventas con descripción
    " -----------------------------------------------------------------------

    " Tipos locales
    TYPES: BEGIN OF lty_tvko_join,
             vkorg               TYPE tvko-vkorg,     " Organización de ventas
             waers               TYPE tvko-waers,     " Moneda estadística
             bukrs               TYPE tvko-bukrs,     " Sociedad
             txnam_adr           TYPE tvko-txnam_adr, " Dirección
             kunnr               TYPE tvko-kunnr,     " Cliente
             werks               TYPE tvko-werks,     " Centro
             bsart               TYPE tvko-bsart,     " Clase de pedido
             denominacion_varias TYPE tvkot-vtext,    " Texto org. ventas
           END OF lty_tvko_join.

    DATA lt_tvko TYPE STANDARD TABLE OF lty_tvko_join.

    FIELD-SYMBOLS <ls_tvko> TYPE lty_tvko_join.
    FIELD-SYMBOLS <ls_ret>  LIKE LINE OF rt_return.

    SELECT a~vkorg,
           a~waers,
           a~bukrs,
           a~txnam_adr,
           a~kunnr,
           a~werks,
           a~bsart,
           b~vtext     AS denominacion_varias
      INTO TABLE @lt_tvko
      FROM tvko AS a
             INNER JOIN
               tvkot AS b ON a~vkorg = b~vkorg
      WHERE b~spras = @sy-langu.

    IF lt_tvko IS NOT INITIAL.

      LOOP AT lt_tvko ASSIGNING <ls_tvko>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.

        <ls_ret>-organizacion_venta  = <ls_tvko>-vkorg.
        <ls_ret>-moneda              = <ls_tvko>-waers.
        <ls_ret>-sociedad            = <ls_tvko>-bukrs.
        <ls_ret>-direccion           = <ls_tvko>-txnam_adr.
        <ls_ret>-cliente             = <ls_tvko>-kunnr.
        <ls_ret>-centro              = <ls_tvko>-werks.
        <ls_ret>-clase_pedido        = <ls_tvko>-bsart.
        <ls_ret>-denominacion_varias = <ls_tvko>-denominacion_varias.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID 'YSD001' TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_ORIGEN
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_origen.

    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 03.05.2025
    "^ Descripción.....: Obtiene lista de países y su descripción en español.
    "+---------------------------------------------------------------------+

    " Tipos locales para la estructura de datos
    TYPES: BEGIN OF lty_t005,
             land1 TYPE t005-land1,    " Código del país
           END OF lty_t005,
           BEGIN OF lty_t005t,
             land1 TYPE t005t-land1,   " Código del país
             landx TYPE t005t-landx,   " Nombre del país
             spras TYPE t005t-spras,   " Idioma
           END OF lty_t005t.

    " Declaración de variables internas
    DATA: lt_t005  TYPE STANDARD TABLE OF lty_t005,    " Lista de países
          lt_t005t TYPE STANDARD TABLE OF lty_t005t.   " Lista de descripciones de países

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_t005>   TYPE lty_t005,           " Registro de país
                   <ls_t005t>  TYPE lty_t005t,          " Registro de descripción del país
                   <ls_return> LIKE LINE OF rt_return.  " Registro de retorno

    " Leer países
    SELECT land1 FROM t005
      INTO TABLE lt_t005.

    IF lt_t005 IS NOT INITIAL.

      " Leer descripciones para los países obtenidos
      SELECT land1, landx, spras
        FROM t005t
        INTO TABLE @lt_t005t
        FOR ALL ENTRIES IN @lt_t005
        WHERE land1 = @lt_t005-land1
          AND spras = 'S'.

      LOOP AT lt_t005 ASSIGNING <ls_t005>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-pais = <ls_t005>-land1.

        READ TABLE lt_t005t ASSIGNING <ls_t005t> WITH KEY land1 = <ls_t005>-land1.
        IF sy-subrc = 0.
          <ls_return>-descripcion = <ls_t005t>-landx.
        ENDIF.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_PARTIDAS_ABIERTAS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_SOCIEDAD                     TYPE        BUKRS
* | [--->] I_CLIENTE                      TYPE        KUNNR
* | [<---] RT_RETURN                      TYPE        YSD_TT_009_COBROS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_partidas_abiertas.
    TYPES: BEGIN OF gy_bkpf,
             bukrs TYPE bkpf-bukrs,
             belnr TYPE bkpf-belnr,
             gjahr TYPE bkpf-gjahr,
             kursf TYPE bkpf-kursf,
           END OF gy_bkpf.

    TYPES: BEGIN OF gy_tcurr,
             kurst TYPE tcurr-kurst,
             fcurr TYPE tcurr-fcurr,
             tcurr TYPE tcurr-tcurr,
             ukurs TYPE tcurr-ukurs,
             gdatu TYPE tcurr-gdatu,
           END OF gy_tcurr.

    DATA lv_companycode TYPE bapi3007_1-comp_code.
    DATA lv_customer    TYPE bapi3007_1-customer.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_fecha       TYPE bapi3007-key_date.
    DATA lt_lineitems   TYPE TABLE OF bapi3007_2.
    DATA lt_bkpf        TYPE TABLE OF gy_bkpf.
    DATA lt_tcurr       TYPE TABLE OF gy_tcurr.
    DATA ls_returnbp    TYPE bapireturn.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_error       TYPE c LENGTH 1.
    DATA go_error       TYPE REF TO cx_root.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_errorf      TYPE string.

    FIELD-SYMBOLS <fs_lineitems> LIKE LINE OF lt_lineitems.
    FIELD-SYMBOLS <fs_bkpf>      LIKE LINE OF lt_bkpf.
    FIELD-SYMBOLS <fs_tcurr>     LIKE LINE OF lt_tcurr.
    FIELD-SYMBOLS <fs_retunr>    LIKE LINE OF rt_return.

    lv_companycode = i_sociedad.
    lv_customer = i_cliente.
    lv_fecha = sy-datum.

    SELECT DISTINCT kurst fcurr tcurr ukurs gdatu
      FROM tcurr
      INTO TABLE lt_tcurr
      WHERE kurst = 'M'
        AND fcurr = 'USD'
        AND tcurr = 'BOB'.

    TRY.

        CALL FUNCTION 'BAPI_AR_ACC_GETOPENITEMS'
          EXPORTING
            companycode = lv_companycode
            customer    = lv_customer
            keydate     = '99991231'
          IMPORTING
            return      = ls_returnbp
          TABLES
            lineitems   = lt_lineitems.

        SELECT bukrs belnr gjahr kursf FROM bkpf
          INTO TABLE lt_bkpf
          FOR ALL ENTRIES IN lt_lineitems
          WHERE bukrs = lt_lineitems-comp_code
            AND belnr = lt_lineitems-doc_no
            AND gjahr = lt_lineitems-fisc_year.

        IF lt_lineitems IS NOT INITIAL.

          LOOP AT lt_lineitems ASSIGNING <fs_lineitems>.

            APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
            <fs_retunr>-sociedad           = <fs_lineitems>-comp_code.
            <fs_retunr>-cliente            = <fs_lineitems>-customer.
            <fs_retunr>-clase_documento    = <fs_lineitems>-doc_type.
            <fs_retunr>-numero_documento   = <fs_lineitems>-doc_no.
            <fs_retunr>-numero_referencia  = <fs_lineitems>-ref_doc_no.
            <fs_retunr>-asignacion         = <fs_lineitems>-alloc_nmbr.
            <fs_retunr>-moneda             = <fs_lineitems>-currency.
            <fs_retunr>-fecha_documento    = <fs_lineitems>-doc_date.
            <fs_retunr>-importe_bob        = <fs_lineitems>-amount."<fs_lineitems>-lc_amount. "REPLACE @100
            <fs_retunr>-db_cr_ind          = <fs_lineitems>-db_cr_ind.
            <fs_retunr>-referencia_factura = <fs_lineitems>-inv_ref.
            <fs_retunr>-ejercicio          = <fs_lineitems>-fisc_year.
            <fs_retunr>-importe_mon_doc    = <fs_lineitems>-amt_doccur.
            <fs_retunr>-item_num           = <fs_lineitems>-item_num.
            ASSIGN lt_bkpf[ bukrs = <fs_lineitems>-comp_code
                            belnr = <fs_lineitems>-doc_no
                            gjahr = <fs_lineitems>-fisc_year ] TO <fs_bkpf>.
            IF sy-subrc = 0.
              <fs_retunr>-tipo_cambio = <fs_bkpf>-kursf.
            ENDIF.

            ASSIGN lt_tcurr[ 1 ] TO <fs_tcurr>.
            IF sy-subrc = 0.
              <fs_retunr>-tipo_cambio_sistem = <fs_tcurr>-ukurs.
            ENDIF.

          ENDLOOP.

        ELSE.

          APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
          <fs_retunr>-message  = ls_returnbp-message.
          <fs_retunr>-messcode = '400'.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorf = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_PERSONAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_SOLICITANTE                  TYPE        PA0001-PERNR
* | [--->] I_CHECK                        TYPE        CHAR1
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_personal.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtener información del personal y vendedores
    "^                    vinculados al usuario logueado o solicitante.
    "+---------------------------------------------------------------------+

    " Declaración de Tipos Locales
    TYPES: BEGIN OF lty_pa0105,
             usrid TYPE pa0105-usrid, ". Usuario SAP
             pernr TYPE pa0105-pernr, ". Número de personal
             subty TYPE pa0105-subty, ". Subtipo
           END OF lty_pa0105.

    TYPES: BEGIN OF lty_pa0001,
             uname TYPE pa0001-uname, ". Usuario SAP
             pernr TYPE pa0001-pernr, ". Número de personal
             bukrs TYPE pa0001-bukrs, ". Sociedad
             btrtl TYPE pa0001-btrtl, ". Oficina
             werks TYPE pa0001-werks, ". División de personal
             persg TYPE pa0001-persg, ". Grupo de personal
             persk TYPE pa0001-persk, ". Área de personal
             vdsk1 TYPE pa0001-vdsk1, ". Clave organizacional
             gsber TYPE pa0001-gsber, ". División
             sname TYPE pa0001-sname, ". Nombre del empleado
           END OF lty_pa0001.

    TYPES: BEGIN OF lty_pa0900,
             pernr TYPE pa0900-pernr, ". Número de personal
             vkorg TYPE pa0900-vkorg, ". Organización de ventas
             vkbur TYPE pa0900-vkbur, ". Oficina de ventas
             vkgrp TYPE pa0900-vkgrp, ". Grupo de vendedores
           END OF lty_pa0900.

    " Declaración de Variables Locales
    DATA lt_pa0105    TYPE STANDARD TABLE OF lty_pa0105.           ". Relación usuario/personal
    DATA lt_pa0001    TYPE STANDARD TABLE OF lty_pa0001.           ". Datos maestros de personal
    DATA lt_pa0900    TYPE STANDARD TABLE OF lty_pa0900.           ". Vendedores relacionados
    DATA lt_pa0900aux TYPE STANDARD TABLE OF lty_pa0900.           ". Auxiliar vendedores
    DATA lt_usr05     TYPE STANDARD TABLE OF usr05.           ". Parámetros usuario
    DATA lv_usuario   TYPE uname.  ". Usuario actual
    DATA lv_msg       TYPE string. ". Mensaje

    " Declaración de Field-Symbols
    FIELD-SYMBOLS <ls_pa0105> TYPE lty_pa0105.
    FIELD-SYMBOLS <ls_pa0001> TYPE lty_pa0001.
    FIELD-SYMBOLS <ls_usr05>  TYPE usr05.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    IF i_solicitante IS INITIAL AND i_check IS INITIAL.

      lv_usuario = sy-uname.

      SELECT usrid pernr subty FROM pa0105
        INTO TABLE lt_pa0105
        WHERE usrid  = lv_usuario
          AND subty  = '0001'
          AND begda <= sy-datum
          AND endda >= sy-datum.

      IF lt_pa0105 IS NOT INITIAL.

        SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
          FROM pa0001
          INTO TABLE lt_pa0001
          FOR ALL ENTRIES IN lt_pa0105
          WHERE pernr  = lt_pa0105-pernr
            AND begda <= sy-datum
            AND endda >= sy-datum.

        " btener vendedores de la oficina
        SELECT pernr vkorg vkbur vkgrp FROM pa0900
          INTO TABLE lt_pa0900aux
          FOR ALL ENTRIES IN lt_pa0105
          WHERE pernr  = lt_pa0105-pernr
            AND begda <= sy-datum
            AND endda >= sy-datum.
        IF sy-subrc = 0.
          SELECT pernr vkorg vkbur vkgrp FROM pa0900
            INTO TABLE lt_pa0900
            FOR ALL ENTRIES IN lt_pa0900aux
            WHERE vkbur  = lt_pa0900aux-vkbur
              AND pernr <> lt_pa0900aux-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
            FROM pa0001
            APPENDING TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT usrid pernr subty FROM pa0105
            APPENDING TABLE lt_pa0105
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND subty  = '0001'
              AND begda <= sy-datum
              AND endda >= sy-datum.
        ENDIF.

        SELECT * FROM usr05
          INTO TABLE lt_usr05
          WHERE bname = lv_usuario.

        IF lt_pa0001 IS NOT INITIAL.

          LOOP AT lt_pa0001 ASSIGNING <ls_pa0001>.

            APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
            <ls_return>-solicitante        = <ls_pa0001>-pernr.
            <ls_return>-sociedad           = <ls_pa0001>-bukrs.
            <ls_return>-division_personal  = <ls_pa0001>-werks.
            <ls_return>-grupo_personal     = <ls_pa0001>-persg.
            <ls_return>-area_personal      = <ls_pa0001>-persk.
            <ls_return>-clave_organizacion = <ls_pa0001>-vdsk1.
            <ls_return>-division           = <ls_pa0001>-gsber.
            <ls_return>-nombre_solicitante = <ls_pa0001>-sname.

            ASSIGN lt_pa0105[ pernr = <ls_pa0001>-pernr ] TO <ls_pa0105>.
            IF sy-subrc <> 0.
              CONTINUE.
            ENDIF.

            <ls_return>-usuario = <ls_pa0105>-usrid.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKO' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-organizacion_venta = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VTW' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-canal = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'SPA' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-sector = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKB' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-oficina = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKG' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-grupo_vendedores = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VST' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-puesto_expedicion = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'WRK' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-centro = <ls_usr05>-parva.
            ENDIF.

          ENDLOOP.

        ELSE.

          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          MESSAGE ID gc_msgid TYPE 'I' NUMBER '002'
                  WITH 'PA0001' lv_usuario
                  INTO lv_msg.
          <ls_return>-message  = lv_msg.
          <ls_return>-messcode = gc_error_400.

        ENDIF.

      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '002'
                WITH 'PA0105' lv_usuario
                INTO lv_msg.
        <ls_return>-message  = lv_msg.
        <ls_return>-messcode = gc_error_400.

      ENDIF.

    ELSEIF i_solicitante IS NOT INITIAL.

      SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
        FROM pa0001
        INTO TABLE lt_pa0001
        WHERE pernr  = i_solicitante
          AND begda <= sy-datum
          AND endda >= sy-datum.

      IF lt_pa0001 IS NOT INITIAL.

        SELECT usrid pernr subty FROM pa0105
          INTO TABLE lt_pa0105
          FOR ALL ENTRIES IN lt_pa0001
          WHERE pernr  = lt_pa0001-pernr
            AND subty  = '0001'
            AND begda <= sy-datum "
            AND endda >= sy-datum.

        ASSIGN lt_pa0105[ 1 ] TO <ls_pa0105>.
        IF sy-subrc = 0.
          lv_usuario = <ls_pa0105>-usrid.
        ENDIF.

        " btener vendedores de la oficina
        SELECT pernr vkorg vkbur vkgrp FROM pa0900
          INTO TABLE lt_pa0900aux
          FOR ALL ENTRIES IN lt_pa0105
          WHERE pernr  = lt_pa0105-pernr
            AND begda <= sy-datum
            AND endda >= sy-datum.
        IF sy-subrc = 0.
          SELECT pernr vkorg vkbur vkgrp FROM pa0900
            INTO TABLE lt_pa0900
            FOR ALL ENTRIES IN lt_pa0900aux
            WHERE vkbur  = lt_pa0900aux-vkbur
              AND pernr <> lt_pa0900aux-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
            FROM pa0001
            APPENDING TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT usrid pernr subty FROM pa0105
            APPENDING TABLE lt_pa0105
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND subty  = '0001'
              AND begda <= sy-datum
              AND endda >= sy-datum.
        ENDIF.

        SELECT * FROM usr05
          INTO TABLE lt_usr05
          WHERE bname = lv_usuario.

        LOOP AT lt_pa0001 ASSIGNING <ls_pa0001>.

          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          <ls_return>-solicitante        = <ls_pa0001>-pernr.
          <ls_return>-sociedad           = <ls_pa0001>-bukrs.
          <ls_return>-division_personal  = <ls_pa0001>-werks.
          <ls_return>-grupo_personal     = <ls_pa0001>-persg.
          <ls_return>-area_personal      = <ls_pa0001>-persk.
          <ls_return>-clave_organizacion = <ls_pa0001>-vdsk1.
          <ls_return>-division           = <ls_pa0001>-gsber.
          <ls_return>-nombre_solicitante = <ls_pa0001>-sname.

          ASSIGN lt_pa0105[ pernr = <ls_pa0001>-pernr ] TO <ls_pa0105>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          <ls_return>-usuario = <ls_pa0105>-usrid.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'VKO' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-organizacion_venta = <ls_usr05>-parva.
          ENDIF.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'VTW' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-canal = <ls_usr05>-parva.
          ENDIF.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'VKB' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-oficina = <ls_usr05>-parva.
          ENDIF.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'VKG' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-grupo_vendedores = <ls_usr05>-parva.
          ENDIF.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'VST' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-puesto_expedicion = <ls_usr05>-parva.
          ENDIF.

          ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                           parid = 'WRK' ] TO <ls_usr05>.
          IF sy-subrc = 0.
            <ls_return>-centro = <ls_usr05>-parva.
          ENDIF.
          "
          "

        ENDLOOP.

      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '002'
                WITH 'PA0001' lv_usuario
                INTO lv_msg.
        <ls_return>-message  = lv_msg.
        <ls_return>-messcode = gc_error_400.
      ENDIF.

    ELSEIF i_check IS NOT INITIAL.

      lv_usuario = sy-uname.

      SELECT usrid pernr subty FROM pa0105
        INTO TABLE lt_pa0105
        WHERE usrid  = lv_usuario
          AND subty  = '0001'
          AND begda <= sy-datum
          AND endda >= sy-datum.
      IF sy-subrc <> 0.
        SELECT usrid pernr subty FROM pa0105
          INTO TABLE lt_pa0105
          UP TO 1 ROWS
          WHERE subty  = '0001'
            AND begda <= sy-datum
            AND endda >= sy-datum.
      ENDIF.
      IF lt_pa0105 IS NOT INITIAL.

        SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
          FROM pa0001
          INTO TABLE lt_pa0001
          FOR ALL ENTRIES IN lt_pa0105
          WHERE pernr  = lt_pa0105-pernr
            AND begda <= sy-datum
            AND endda >= sy-datum.

        SELECT pernr vkorg vkbur vkgrp FROM pa0900
          INTO TABLE lt_pa0900aux
          FOR ALL ENTRIES IN lt_pa0105
          WHERE pernr  = lt_pa0105-pernr
            AND begda <= sy-datum
            AND endda >= sy-datum.
        IF sy-subrc = 0.
          SELECT pernr vkorg vkbur vkgrp FROM pa0900
            INTO TABLE lt_pa0900
            FOR ALL ENTRIES IN lt_pa0900aux
            WHERE vkbur  = lt_pa0900aux-vkbur
              AND pernr <> lt_pa0900aux-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT uname pernr bukrs btrtl werks persg persk vdsk1 gsber sname
            FROM pa0001
            APPENDING TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND begda <= sy-datum
              AND endda >= sy-datum.

          SELECT usrid pernr subty FROM pa0105
            APPENDING TABLE lt_pa0105
            FOR ALL ENTRIES IN lt_pa0900
            WHERE pernr  = lt_pa0900-pernr
              AND subty  = '0001'
              AND begda <= sy-datum
              AND endda >= sy-datum.
        ENDIF.

        SELECT * FROM usr05
          INTO TABLE lt_usr05
          WHERE bname = lv_usuario.

        IF lt_pa0001 IS NOT INITIAL.

          LOOP AT lt_pa0001 ASSIGNING <ls_pa0001>.

            APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
            <ls_return>-solicitante        = <ls_pa0001>-pernr.
            <ls_return>-sociedad           = <ls_pa0001>-bukrs.
            <ls_return>-division_personal  = <ls_pa0001>-werks.
            <ls_return>-grupo_personal     = <ls_pa0001>-persg.
            <ls_return>-area_personal      = <ls_pa0001>-persk.
            <ls_return>-clave_organizacion = <ls_pa0001>-vdsk1.
            <ls_return>-division           = <ls_pa0001>-gsber.
            <ls_return>-nombre_solicitante = <ls_pa0001>-sname.

            ASSIGN lt_pa0105[ pernr = <ls_pa0001>-pernr ] TO <ls_pa0105>.
            IF sy-subrc <> 0.
              CONTINUE.
            ENDIF.

            <ls_return>-usuario = <ls_pa0105>-usrid.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKO' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-organizacion_venta = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VTW' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-canal = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'SPA' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-sector = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKB' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-oficina = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VKG' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-grupo_vendedores = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'VST' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-puesto_expedicion = <ls_usr05>-parva.
            ENDIF.

            ASSIGN lt_usr05[ bname = <ls_pa0105>-usrid
                             parid = 'WRK' ] TO <ls_usr05>.
            IF sy-subrc = 0.
              <ls_return>-centro = <ls_usr05>-parva.
            ENDIF.

          ENDLOOP.
        ENDIF.
      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '002'
                WITH 'PA0001' lv_usuario
                INTO lv_msg.
        <ls_return>-message  = lv_msg.
        <ls_return>-messcode = gc_error_400.

      ENDIF.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_PRECIO_DESCUENTO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ARTICULO                     TYPE        MATNR
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_CANAL                        TYPE        VTWEG
* | [--->] I_SECTOR                       TYPE        SPART
* | [--->] I_GRUPO_ARTICULO               TYPE        MATKL
* | [--->] I_GRUPO_CLIENTE                TYPE        KDGRP
* | [--->] I_OFICINA_VENTAS               TYPE        VKBUR
* | [--->] I_ZONA_VENTAS                  TYPE        BZIRK
* | [--->] I_GRUPO_COND_CLIENTE           TYPE        KDKGR
* | [--->] I_SOLICITANTE                  TYPE        PERNR
* | [--->] I_LISTA_PRECIO                 TYPE        PLTYP
* | [--->] I_CONDICION_PAGO               TYPE        KNVV-ZTERM
* | [--->] I_VALIDO_A                     TYPE        CHAR10(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_precio_descuento.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 04.05.2025
    " ^ Descripción.....: Consulta el precio unitario de un material según
    " ^                   las condiciones comerciales configuradas en A950 o A952/KONP
    " -----------------------------------------------------------------------

    " Declaración de tablas internas
    DATA lt_a950 TYPE STANDARD TABLE OF a950. " Condiciones A950
    DATA lt_a952 TYPE STANDARD TABLE OF a952. " Condiciones A952
    DATA lt_konp TYPE STANDARD TABLE OF konp. " Detalle de condiciones

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_a950>   TYPE a950.
    FIELD-SYMBOLS <ls_a952>   TYPE a952.
    FIELD-SYMBOLS <ls_konp>   TYPE konp.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    SELECT * FROM a950
      INTO TABLE lt_a950
      WHERE matnr  = i_articulo
        AND vkorg  = i_org_ventas
        AND vtweg  = i_canal
        AND kschl  = 'Y001'
        AND pltyp  = i_lista_precio
        AND datab <= sy-datum
        AND datbi >= sy-datum.

    IF lt_a950 IS INITIAL.
      SELECT * FROM a952
        INTO TABLE lt_a952
        WHERE matkl  = i_grupo_articulo
          AND vkorg  = i_org_ventas
          AND vtweg  = i_canal
          AND kschl  = 'Y001'
          AND kdgrp  = i_grupo_cliente
          AND datab <= sy-datum
          AND datbi >= sy-datum.

      IF lt_a952 IS NOT INITIAL.
        SORT lt_a952 BY datbi DESCENDING.
        SELECT * FROM konp
          INTO TABLE lt_konp
          FOR ALL ENTRIES IN lt_a952
          WHERE knumh     = lt_a952-knumh
            AND kbetr    <> '0.00'
            AND loevm_ko  = ' '.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        LOOP AT lt_a952 ASSIGNING <ls_a952>.
          ASSIGN lt_konp[ knumh = <ls_a952>-knumh ] TO <ls_konp>.
          IF sy-subrc = 0.
            <ls_return>-precio_unitario = <ls_konp>-kbetr.
            EXIT.
          ENDIF.
        ENDLOOP.

      ELSE.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
        <ls_return>-message  = gv_message.
        <ls_return>-messcode = gc_error_400.
      ENDIF.

    ELSE.
      " Si se encontró en A950
      SORT lt_a950 BY datbi DESCENDING.
      SELECT * FROM konp
        INTO TABLE lt_konp
        FOR ALL ENTRIES IN lt_a950
        WHERE knumh     = lt_a950-knumh
          AND kbetr    <> '0.00'
          AND loevm_ko  = ' '.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      LOOP AT lt_a950 ASSIGNING <ls_a950>.
        ASSIGN lt_konp[ knumh = <ls_a950>-knumh ] TO <ls_konp>.
        IF sy-subrc = 0.
          <ls_return>-precio_unitario = <ls_konp>-kbetr.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_RUTA
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ruta.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtener lista de rutas logísticas (TVRO) con su
    "^                    descripción asociada (TVROT)
    "+---------------------------------------------------------------------+

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_tvro,
             route TYPE tvro-route, " Código de ruta
           END OF lty_tvro.

    TYPES: BEGIN OF lty_tvrot,
             route TYPE tvrot-route, " Código de ruta
             bezei TYPE tvrot-bezei, " Descripción
           END OF lty_tvrot.

    " Variables internas
    DATA lt_tvro  TYPE STANDARD TABLE OF lty_tvro.           " Rutas logísticas
    DATA lt_tvrot TYPE STANDARD TABLE OF lty_tvrot.           " Textos de rutas
    DATA lv_msg   TYPE string. " Texto de mensaje

    FIELD-SYMBOLS <ls_tvro>  TYPE lty_tvro.
    FIELD-SYMBOLS <ls_tvrot> TYPE lty_tvrot.
    FIELD-SYMBOLS <ls_ret>   LIKE LINE OF rt_return.

    " Lectura de rutas logísticas
    SELECT route FROM tvro
      INTO TABLE @lt_tvro.

    IF lt_tvro IS NOT INITIAL.

      " Lectura de descripciones de rutas
      SELECT route, bezei FROM tvrot
        INTO TABLE @lt_tvrot
        FOR ALL ENTRIES IN @lt_tvro
        WHERE route = @lt_tvro-route
          AND spras = 'S'.

      LOOP AT lt_tvro ASSIGNING <ls_tvro>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-ruta = <ls_tvro>-route.

        ASSIGN lt_tvrot[ route = <ls_tvro>-route ] TO <ls_tvrot>.
        IF sy-subrc = 0.
          <ls_ret>-descripcion = <ls_tvrot>-bezei.
        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_SECTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        TVTA-VKORG
* | [--->] I_CANAL                        TYPE        TVTA-VTWEG
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sector.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....: SD-DEV-003
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtener sectores por organización de ventas y canal
    " -----------------------------------------------------------------------

    " Tipos locales
    TYPES: BEGIN OF lty_tvta,
             vkorg TYPE tvta-vkorg,   " Organización de ventas
             vtweg TYPE tvta-vtweg,   " Canal de distribución
             spart TYPE tvta-spart,   " Sector
             vtext TYPE tspat-vtext,  " Descripción del sector
           END OF lty_tvta.

    DATA lt_tvta TYPE STANDARD TABLE OF lty_tvta.
    FIELD-SYMBOLS <ls_tvta> TYPE lty_tvta.
    FIELD-SYMBOLS <ls_ret>  LIKE LINE OF rt_return.

    " Consulta de sectores con descripción
    SELECT a~vkorg,
           a~vtweg,
           a~spart,
           b~vtext
      FROM tvta AS a
      INNER JOIN tspat AS b
        ON b~spart = a~spart
      WHERE ( a~vkorg = @i_org_ventas AND a~vtweg = @i_canal )
         OR ( @i_org_ventas = @space AND @i_canal = @space AND b~spras = @sy-langu )
         INTO TABLE @lt_tvta.

    IF lt_tvta IS NOT INITIAL.

      LOOP AT lt_tvta ASSIGNING <ls_tvta>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.

        <ls_ret>-organizacion_venta = <ls_tvta>-vkorg.
        <ls_ret>-canal              = <ls_tvta>-vtweg.
        <ls_ret>-sector             = <ls_tvta>-spart.
        <ls_ret>-denominacion_ov    = <ls_tvta>-vtext.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO DATA(lv_msg).
      <ls_ret>-message   = lv_msg.
      <ls_ret>-messcode  = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_SOCIEDAD
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sociedad.

    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: FI
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta de sociedades activas para operaciones contables.
    "                      Devuelve código y descripción de la sociedad.
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t001,
             bukrs       TYPE t001-bukrs,        " Sociedad
             butxt       TYPE t001-butxt,        " Descripción de la sociedad
             rcomp       TYPE t001-rcomp,        " Grupo contable
             pst_per_var TYPE t001-pst_per_var,  " Indicador de variante de periodo
           END OF lty_t001.

    " Declaración de variables locales
    DATA: lt_t001 TYPE STANDARD TABLE OF lty_t001.           " Tabla interna de sociedades

    " Declaración de field-symbols
    FIELD-SYMBOLS: <ls_t001>   TYPE lty_t001,                " Registro de sociedad
                   <ls_return> LIKE LINE OF rt_return.      " Registro de retorno

    " Leer sociedades activas
    SELECT bukrs, butxt, rcomp, pst_per_var
      FROM t001
      INTO TABLE @lt_t001
      WHERE bukrs = 'FCRE'.

    IF lt_t001 IS NOT INITIAL.

      LOOP AT lt_t001 ASSIGNING <ls_t001>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-sociedad    = <ls_t001>-bukrs.
        <ls_return>-descripcion = <ls_t001>-butxt.

      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_STOCK_DISPONIBLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CENTRO                       TYPE        WERKS_D
* | [--->] I_ARTICULO                     TYPE        MATNR18
* | [--->] I_UNIDAD_MEDIDA                TYPE        MEINS
* | [--->] I_ORGANIZACION_VENTAS          TYPE        VKORG
* | [<---] RT_RETURN                      TYPE        YSD_TT_010_STOCK_DISPONIBLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_stock_disponible.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta stock disponible de un material
    " ^ en un centro y almacén
    " -----------------------------------------------------------------------

    " Declaración de variables locales
    DATA lv_centro           TYPE werks_d.                    " Centro solicitado
    DATA lv_articulo         TYPE matnr.                      " Material solicitado
    DATA lv_unidad_medida    TYPE meins.                      " Unidad de medida
    DATA lv_com_qty          TYPE bapiwmdve-com_qty.          " Cantidad disponible BAPI
    DATA ls_wmard            TYPE mard.                       " Datos de stock
    DATA lv_labst            TYPE mard-labst.                 " Stock en libre utilización
    DATA lv_stock_disponible TYPE mard-labst.                 " Stock disponible calculado
    DATA ls_return           TYPE bapireturn.                 " Retorno de BAPI
    DATA lv_errorbp          TYPE string.                     " Mensaje de error BAPI
    DATA lv_message          TYPE bapi_msg.                   " Mensaje de retorno
    DATA lv_error            TYPE c LENGTH 1.                 " Indicador de error
    DATA go_error            TYPE REF TO cx_root.             " Objeto de error
    DATA lv_errorf           TYPE string.                     " Texto de error
    DATA lv_exceptions       TYPE string.                     " Excepción capturada
    DATA lv_msj              TYPE ysd_t004_valmace-selection. " Indicador validación stock

    " Declaración de tablas internas
    DATA lt_wmdvsx           TYPE TABLE OF bapiwmdvs.
    DATA lt_wmdvex           TYPE TABLE OF bapiwmdve.

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_wmdvex> TYPE bapiwmdve.
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    " Leer validación de stock por sociedad
    SELECT SINGLE selection INTO @lv_msj
      FROM ysd_t004_valmace
      WHERE vkorg = @i_organizacion_ventas AND werks = @i_centro AND selection = 'X'.

    lv_centro = i_centro.
    lv_articulo = i_articulo.
    lv_unidad_medida = i_unidad_medida.

    TRY.
        " Consultar disponibilidad con BAPI
        CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
          EXPORTING
            plant      = lv_centro
            material   = lv_articulo
            unit       = lv_unidad_medida
            check_rule = 'A'
          IMPORTING
            return     = ls_return
          TABLES
            wmdvsx     = lt_wmdvsx
            wmdvex     = lt_wmdvex.

        IF lt_wmdvex IS NOT INITIAL.
          ASSIGN lt_wmdvex[ 1 ] TO <ls_wmdvex>.
          IF sy-subrc = 0.
            lv_com_qty = <ls_wmdvex>-com_qty.
          ENDIF.
        ENDIF.
        IF ls_return IS NOT INITIAL.
          lv_errorbp = ls_return-message.
          CONCATENATE 'ERROR BAPI:' lv_errorbp '-ERROR FUNCION:' lv_exceptions INTO lv_message.
          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          <ls_return>-message            = lv_message.
          <ls_return>-messcode           = gc_error_400.
          <ls_return>-valida_vkorg_stock = lv_msj.
          RETURN.
        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.
        lv_errorf = go_error->get_text( ).
        lv_error = 'X'.
    ENDTRY.

    IF lv_error IS INITIAL.

*      TRY.
*          CALL FUNCTION 'MARD_SINGLE_READ'
*            EXPORTING  matnr      = lv_articulo
*                       werks      = i_centro
*                       lgort      = 'FM01' " lv_lgort TODO
*            IMPORTING  wmard      = ls_wmard
*            EXCEPTIONS wrong_call = 1
*                       not_found  = 2
*                       OTHERS     = 3.
*          IF sy-subrc <> 0.
*            IF sy-subrc = 1.
*              CONCATENATE 'WRONG_CALL' '/1' INTO lv_exceptions.
*            ELSEIF sy-subrc = 2.
*              CONCATENATE 'NOT_FOUND' '2' INTO lv_exceptions.
*            ELSE.
*              CONCATENATE 'OTROS' '3' INTO lv_exceptions.
*            ENDIF.
*
*          ENDIF.
*
*          IF ls_wmard IS NOT INITIAL.
*            lv_labst = ls_wmard-labst.
*          ENDIF.
*
*        CATCH cx_sy_zerodivide INTO go_error.
*          lv_errorf = go_error->get_text( ).
*          lv_error = 'X'.
*      ENDTRY.

*      IF lv_error IS INITIAL.
      lv_stock_disponible = lv_com_qty - lv_labst.
      IF lv_stock_disponible IS NOT INITIAL.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-stock_disponible   = lv_stock_disponible.
        <ls_return>-articulo           = lv_articulo.
        <ls_return>-unidad_medida      = lv_unidad_medida.
        <ls_return>-centro             = lv_centro.
*          <ls_return>-almacen            = 'FM01'. " lv_lgort. TODO
        <ls_return>-valida_vkorg_stock = lv_msj.
      ELSE.
        CONCATENATE 'ERROR BAPI:' lv_errorbp '-ERROR FUNCION:' lv_exceptions INTO lv_message.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-message            = lv_message.
        <ls_return>-messcode           = gc_error_400.
        <ls_return>-valida_vkorg_stock = lv_msj.
      ENDIF.
*      ELSE.
*        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
*        <ls_return>-message  = lv_errorf.
*        <ls_return>-messcode = gc_error_402.
*      ENDIF.
    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      <ls_return>-message  = lv_errorf.
      <ls_return>-messcode = gc_error_401.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_TIENDA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_SOCIEDAD                     TYPE        BUKRS
* | [<---] RT_RETURN                      TYPE        YSD_TT_004_COBROS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tienda.

    DATA: lt_yfi_t002_ctacaja TYPE STANDARD TABLE OF yfi_t002_ctacaja,
          lt_retunr           LIKE rt_return.

    FIELD-SYMBOLS: <fs_yfi_t002_ctacaja> LIKE LINE OF lt_yfi_t002_ctacaja,
                   <fs_retunr>           LIKE LINE OF lt_retunr.

    IF i_sociedad IS NOT INITIAL.

      SELECT *
      FROM yfi_t002_ctacaja
      INTO TABLE lt_yfi_t002_ctacaja
      WHERE cj_central EQ ' '
      AND cj_cob EQ ' '
      AND cj_soc EQ i_sociedad.

    ELSE.

      SELECT *
      FROM yfi_t002_ctacaja
      INTO TABLE lt_yfi_t002_ctacaja
      WHERE cj_central EQ ' '
      AND cj_cob EQ ' '.

    ENDIF.




    IF lt_yfi_t002_ctacaja IS NOT INITIAL.

      LOOP AT lt_yfi_t002_ctacaja ASSIGNING <fs_yfi_t002_ctacaja>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        MOVE <fs_yfi_t002_ctacaja>-cj_mm TO <fs_retunr>-cj_mm.
        MOVE <fs_yfi_t002_ctacaja>-cj_me TO <fs_retunr>-cj_me.
        MOVE <fs_yfi_t002_ctacaja>-cj_txt TO <fs_retunr>-cj_txt.
        MOVE <fs_yfi_t002_ctacaja>-cj_cob TO <fs_retunr>-cj_cob.
        MOVE <fs_yfi_t002_ctacaja>-cj_soc TO <fs_retunr>-cj_soc.


      ENDLOOP.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message = 'No se han encontrado registros'.
      <fs_retunr>-messcode = '400'.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_TIPOPOSICION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_CLASEDOCUMENTO               TYPE        AUART(optional)
* | [--->] I_MOTIVOEXPEDICION             TYPE        VSBED(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_002_VENTAS_INFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tipoposicion.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta tipos de posición asociados a una clase de
    " ^ documento de venta y motivo de expedición
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t184,
             uepst  TYPE t184-uepst,  " Indicador de subposición
             pstyv  TYPE t184-pstyv,  " Tipo posición principal
             psty1  TYPE t184-psty1,
             psty2  TYPE t184-psty2,
             psty3  TYPE t184-psty3,
             psty4  TYPE t184-psty4,
             psty5  TYPE t184-psty5,
             psty6  TYPE t184-psty6,
             psty7  TYPE t184-psty7,
             psty8  TYPE t184-psty8,
             psty9  TYPE t184-psty9,
             psty10 TYPE t184-psty10,
             psty11 TYPE t184-psty11,
             vtext  TYPE tvapt-vtext, " Denominación
           END OF lty_t184.

    " Declaración de variables locales
    DATA ls_t184       TYPE lty_t184.   " Registro tipo posición
    DATA lv_pstyxx     TYPE t184-psty1. " Posición variante
    DATA lv_doc_type_p TYPE auart.      " Clase documento homologada

    " Declaración de tablas internas
    DATA lt_t184       TYPE STANDARD TABLE OF lty_t184.               " Tabla tipos de posición

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.

    " Validación de entrada
    IF i_clasedocumento IS NOT INITIAL.

      " Buscar homologación de clase de documento
      SELECT SINGLE doc_type_p INTO @lv_doc_type_p
        FROM ysd_t001_paramet
        WHERE indi_expedi = @i_motivoexpedicion
          AND doc_type_c  = @i_clasedocumento.

      IF sy-subrc = 0.

        " Buscar posiciones configuradas
        SELECT mtpos, pstyv INTO TABLE @DATA(lt_t002_tipopos)
          FROM ysd_t002_tipopos
          WHERE doc_type_p = @lv_doc_type_p
            AND selection  = 'X'.

        IF sy-subrc = 0.

          " Leer tipos de posición desde T184 y sus textos
          SELECT a~uepst,
                 a~pstyv,
                 a~psty1,
                 a~psty2,
                 a~psty3,
                 a~psty4,
                 a~psty5,
                 a~psty6,
                 a~psty7,
                 a~psty8,
                 a~psty9,
                 a~psty10,
                 a~psty11,
                 b~vtext
            INTO TABLE @lt_t184
            FROM t184 AS a
                   INNER JOIN
                     tvapt AS b ON a~pstyv = b~pstyv
            FOR ALL ENTRIES IN @lt_t002_tipopos
            WHERE a~auart = @lv_doc_type_p
              AND a~mtpos = @lt_t002_tipopos-mtpos
              AND a~uepst = ''
              AND a~pstyv = @lt_t002_tipopos-pstyv
              AND b~spras = @sy-langu.

          IF sy-subrc = 0.

            LOOP AT lt_t184 INTO ls_t184.
              " Agregar tipo de posición principal
              APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
              IF sy-tabix = 1.
                <ls_return>-check_pos = 'X'.
              ENDIF.
              <ls_return>-tipo_pos         = ls_t184-pstyv.
              <ls_return>-denominacion_pos = ls_t184-vtext.

              " Agregar variantes de posición
              DO 11 TIMES VARYING lv_pstyxx FROM ls_t184-psty1 NEXT ls_t184-psty2.
                IF lv_pstyxx IS NOT INITIAL.
                  APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
                  <ls_return>-tipo_pos = lv_pstyxx.
                  SELECT SINGLE vtext INTO @<ls_return>-denominacion_pos
                    FROM tvapt
                    WHERE pstyv = @lv_pstyxx
                      AND spras = @sy-langu.
                ENDIF.
              ENDDO.

              CLEAR: lv_pstyxx,
                     ls_t184.
            ENDLOOP.

            DELETE ADJACENT DUPLICATES FROM rt_return COMPARING tipo_pos.

          ELSE.
            APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
            MESSAGE ID gc_msgid TYPE 'I' NUMBER '004' INTO gv_message.
            <ls_return>-message  = gv_message.
            <ls_return>-messcode = gc_error_400.
          ENDIF.

        ELSE.
          APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
          MESSAGE ID gc_msgid TYPE 'I' NUMBER '004' INTO gv_message.
          <ls_return>-message  = gv_message.
          <ls_return>-messcode = gc_error_400.
        ENDIF.

      ELSE.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        MESSAGE ID gc_msgid TYPE 'I' NUMBER '004' INTO gv_message.
        <ls_return>-message  = gv_message.
        <ls_return>-messcode = gc_error_400.
      ENDIF.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '004' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_TIPO_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tipo_material.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Consulta los tipos de material existentes con su
    " ^                    descripción en idioma español.
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_t134,
             mtart TYPE t134-mtart,    " Tipo de material
           END OF lty_t134,
           BEGIN OF lty_t134t,
             mtart TYPE t134t-mtart,   " Tipo de material
             mtbez TYPE t134t-mtbez,   " Descripción del tipo de material
             spras TYPE t134t-spras,   " Idioma
           END OF lty_t134t.

    " Declaración de variables locales
    DATA lt_t134   TYPE STANDARD TABLE OF lty_t134.     " Tabla tipos de material
    DATA lt_t134t  TYPE STANDARD TABLE OF lty_t134t.    " Tabla textos de tipos de material

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_t134>   TYPE lty_t134.             " Registro tipo de material
    FIELD-SYMBOLS <ls_t134t>  TYPE lty_t134t.            " Registro descripción tipo material
    FIELD-SYMBOLS <ls_return> LIKE LINE OF rt_return.    " Registro estructura de retorno

    " Lectura de tipos de material
    SELECT mtart
      FROM t134
      INTO TABLE lt_t134.

    IF lt_t134 IS NOT INITIAL.

      " Lectura de las descripciones
      SELECT mtart mtbez spras
        FROM t134t
        INTO TABLE lt_t134t
        FOR ALL ENTRIES IN lt_t134
        WHERE mtart = lt_t134-mtart
          AND spras = 'S'.

      LOOP AT lt_t134 ASSIGNING <ls_t134>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-tipo_material = <ls_t134>-mtart.

        READ TABLE lt_t134t ASSIGNING <ls_t134t> WITH KEY mtart = <ls_t134>-mtart.
        IF sy-subrc = 0.
          <ls_return>-descripcion = <ls_t134t>-mtbez.
        ENDIF.

      ENDLOOP.

    ELSE.

      " No se encontraron registros
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_TOLERANCIA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_GRUPO_ARTICULO               TYPE        MATKL
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tolerancia.
    " -----------------------------------------------------------------------
    " ^ IDesarrollo.....:
    " ^ Módulo..........: SD
    " ^ Funcional.......: Yubisay Porte
    " ^ Autor...........: Milton Terrazas
    " ^ Fecha...........: 03.05.2025
    " ^ Descripción.....: Obtiene las tolerancias comerciales para un grupo
    " ^                   de artículos y usuario logueado, desde ysd_t006_rcondic
    " -----------------------------------------------------------------------

    " Declaración de tipos locales
    TYPES: BEGIN OF lty_reg_condicio,
             auart           TYPE ysd_t006_rcondic-auart,           " Clase de documento
             kschl           TYPE ysd_t006_rcondic-kschl,           " Clase de condición
             matkl           TYPE ysd_t006_rcondic-matkl,           " Grupo de artículos
             bname           TYPE ysd_t006_rcondic-bname,           " Usuario
             kbetra          TYPE ysd_t006_rcondic-kbetra,          " Desde
             kbetrb          TYPE ysd_t006_rcondic-kbetrb,          " Hasta
             zzsd_tolerancia TYPE ysd_t006_rcondic-zzsd_tolerancia, " Tolerancia
           END OF lty_reg_condicio.

    " Declaración de tablas internas
    DATA lt_reg_condicio TYPE STANDARD TABLE OF lty_reg_condicio.             " Lista de registros encontrados

    " Declaración de variables locales
    DATA lv_usuario      TYPE sy-uname. " Usuario logueado

    " Declaración de field-symbols
    FIELD-SYMBOLS <ls_reg_condicio> TYPE lty_reg_condicio.  " Registro de condiciones
    FIELD-SYMBOLS <ls_return>       LIKE LINE OF rt_return. " Registro de retorno

    lv_usuario = sy-uname.

    " Seleccionar registros de tolerancias para el usuario y grupo de artículo
    SELECT auart, kschl, matkl, bname, kbetra, kbetrb, zzsd_tolerancia
      INTO TABLE @lt_reg_condicio
      FROM ysd_t006_rcondic
      WHERE kschl = 'ZD00'
        AND bname = @lv_usuario
        AND matkl = @i_grupo_articulo.

    IF lt_reg_condicio IS NOT INITIAL.

      LOOP AT lt_reg_condicio ASSIGNING <ls_reg_condicio>.
        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
        <ls_return>-clase_documento = <ls_reg_condicio>-auart.
        <ls_return>-clase_condicion = <ls_reg_condicio>-kschl.
        <ls_return>-grupo_articulos = <ls_reg_condicio>-matkl.
        <ls_return>-usuario         = <ls_reg_condicio>-bname.
        <ls_return>-desde_a         = <ls_reg_condicio>-kbetra.
        <ls_return>-hasta_b         = <ls_reg_condicio>-kbetrb.
        <ls_return>-tolerancia      = <ls_reg_condicio>-zzsd_tolerancia.
      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_return>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO gv_message.
      <ls_return>-message  = gv_message.
      <ls_return>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_VENTAS_DIARIAS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_CANAL                        TYPE        VTWEG
* | [--->] I_SECTOR                       TYPE        VBAK-SPART
* | [--->] I_FECHAI                       TYPE        CHAR10
* | [--->] I_FECHAF                       TYPE        CHAR10
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ventas_diarias.
    TYPES: BEGIN OF gy_vbak,
             vkorg TYPE vbak-vkorg,
             vtweg TYPE vbak-vtweg,
             spart TYPE vbak-spart,
             auart TYPE vbak-auart,
             kunnr TYPE vbak-kunnr,
             augru TYPE vbak-augru,
             knumv TYPE vbak-knumv,
             waerk TYPE vbak-waerk,
             erdat TYPE vbak-erdat,
             vbeln TYPE vbak-vbeln,
             vkbur TYPE vbak-vkbur,
             abstk TYPE vbuk-abstk, "REPLACE @100
             gbstk TYPE vbuk-gbstk, "REPLACE @100
             vsbed TYPE vbak-vsbed,
           END OF gy_vbak.

    TYPES: BEGIN OF gy_vbap,
             werks   TYPE vbap-werks,
             vstel   TYPE vbap-vstel,
             lgort   TYPE vbap-lgort,
             lprio   TYPE vbap-lprio,
             route   TYPE vbap-route,
             matnr   TYPE vbap-matnr,
             kwmeng  TYPE vbap-kwmeng,
             vrkme   TYPE vbap-vrkme,
             charg   TYPE vbap-charg,
             brgew   TYPE vbap-brgew,
             vbeln   TYPE vbap-vbeln,
             posnr   TYPE vbap-posnr,
             po_quan TYPE vbap-kpein, "vbap-po_quan,"REPLACE @100
             po_unit TYPE vbap-kmein, "po_unit,"REPLACE @100
             ernam   TYPE vbap-ernam,
           END OF gy_vbap.

    TYPES: BEGIN OF gy_vbkd,
             bstkd TYPE vbkd-bstkd,
             kdgrp TYPE vbkd-kdgrp,
             bzirk TYPE vbkd-bzirk,
             pltyp TYPE vbkd-pltyp,
             kdkg1 TYPE vbkd-kdkg1,
             vbeln TYPE vbkd-vbeln,
             posnr TYPE vbkd-posnr,
             zterm TYPE vbkd-zterm,
           END OF gy_vbkd.

    TYPES: BEGIN OF gy_makt,
             matnr TYPE makt-matnr, "(Material)
             maktx TYPE makt-maktx, "(Texto breve material)
           END OF gy_makt.

    TYPES: BEGIN OF gy_vbrp,
             aubel TYPE vbrp-aubel,
             aupos TYPE vbrp-aupos,
             vbeln TYPE vbrp-vbeln,
           END OF gy_vbrp.

    TYPES: BEGIN OF gy_bseg,
             vbeln TYPE bseg-vbeln,
             gjahr TYPE bseg-gjahr,
             belnr TYPE bseg-belnr,
           END OF gy_bseg.

    TYPES: BEGIN OF gy_bkpf,
             belnr TYPE bkpf-belnr,
             xblnr TYPE bkpf-xblnr,
           END OF gy_bkpf.

    TYPES: BEGIN OF gy_vbpa,
             vbeln TYPE vbpa-vbeln,
             posnr TYPE vbpa-posnr,
             kunnr TYPE vbpa-kunnr,
             pernr TYPE vbpa-pernr,
             parvw TYPE vbpa-parvw,
           END OF gy_vbpa.

    TYPES: BEGIN OF gy_pa0001,
             pernr TYPE pa0001-pernr,
             uname TYPE pa0001-uname,
             sname TYPE pa0001-sname,
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_konv,
             knumv TYPE konv-knumv,
             kwert TYPE konv-kwert,
             kschl TYPE konv-kschl,
             kherk TYPE konv-kherk,
             kposn TYPE konv-kposn,
             krech TYPE konv-krech,
             kbetr TYPE konv-kbetr,
           END OF gy_konv.

    TYPES: BEGIN OF gy_kna1,
             kunnr TYPE kna1-kunnr, " CLIENTE
             name1 TYPE kna1-name1, " NOMBRE
             adrnr TYPE kna1-adrnr, " DIRECCION
             stras TYPE kna1-stras, " CALLE Y NO
           END OF gy_kna1.

    TYPES: BEGIN OF gy_adrc,
             addrnumber TYPE adrc-addrnumber,
             street     TYPE adrc-street,
           END OF gy_adrc.

    TYPES: BEGIN OF gy_pa0105,
             usrid TYPE pa0105-usrid, " usuario
             pernr TYPE pa0105-pernr, " NUMERO DE PERSONAL
           END OF gy_pa0105.

    TYPES: BEGIN OF gy_vbfa,
             vbelv   TYPE vbfa-vbelv,
             vbeln   TYPE vbfa-vbeln,
             vbtyp_n TYPE vbfa-vbtyp_n,
           END OF gy_vbfa.

    DATA lt_vbak        TYPE TABLE OF gy_vbak.
    DATA lt_makt        TYPE TABLE OF gy_makt.
    DATA lt_vbap        TYPE TABLE OF gy_vbap.
    DATA lt_vbkd        TYPE TABLE OF gy_vbkd.
    DATA lt_vbrp        TYPE TABLE OF gy_vbrp.
    DATA lt_bseg        TYPE TABLE OF gy_bseg.
    DATA lt_bkpf        TYPE TABLE OF gy_bkpf.
    DATA lt_vbpa        TYPE TABLE OF gy_vbpa.
    DATA lt_vbpa2       TYPE TABLE OF gy_vbpa.
    DATA lt_pa0001      TYPE TABLE OF gy_pa0001.
    DATA lt_pa0105      TYPE TABLE OF gy_pa0105.
    DATA lt_vbfa        TYPE TABLE OF gy_vbfa.
    DATA lt_kna1        TYPE TABLE OF gy_kna1.
    DATA lt_adrc        TYPE TABLE OF gy_adrc.
    DATA lt_konv        TYPE TABLE OF gy_konv.
    DATA lt_konv2       TYPE TABLE OF gy_konv.
    DATA lt_konv3       TYPE TABLE OF gy_konv.
    DATA lt_konv4       TYPE TABLE OF gy_konv.
    DATA lv_netwr       TYPE konv-kwert.
    DATA lv_mwsbp       TYPE konv-kwert.
    DATA lv_netwr_mwsbp TYPE konv-kwert.

    FIELD-SYMBOLS <fs_vbak>   LIKE LINE OF lt_vbak.
    FIELD-SYMBOLS <fs_vbap>   LIKE LINE OF lt_vbap.
    FIELD-SYMBOLS <fs_makt>   LIKE LINE OF lt_makt.
    FIELD-SYMBOLS <fs_vbkd>   LIKE LINE OF lt_vbkd.
    FIELD-SYMBOLS <fs_vbrp>   LIKE LINE OF lt_vbrp.
    FIELD-SYMBOLS <fs_bseg>   LIKE LINE OF lt_bseg.
    FIELD-SYMBOLS <fs_vbpa>   LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_vbpa2>  LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_pa0001> LIKE LINE OF lt_pa0001.
    FIELD-SYMBOLS <fs_vbfa>   LIKE LINE OF lt_vbfa.
    FIELD-SYMBOLS <fs_kna1>   LIKE LINE OF lt_kna1.
    FIELD-SYMBOLS <fs_adrc>   LIKE LINE OF lt_adrc.
    FIELD-SYMBOLS <fs_konv>   LIKE LINE OF lt_konv.
    FIELD-SYMBOLS <fs_konv2>  LIKE LINE OF lt_konv2.
    FIELD-SYMBOLS <fs_konv3>  LIKE LINE OF lt_konv3.
    FIELD-SYMBOLS <fs_konv4>  LIKE LINE OF lt_konv4.
    FIELD-SYMBOLS <fs_retunr> LIKE LINE OF rt_return.

    IF i_org_ventas IS INITIAL AND i_canal IS INITIAL.

      SELECT a~vkorg, a~vtweg, a~spart, a~auart, a~kunnr, a~augru,
        a~knumv, a~waerk, a~erdat, a~vbeln, a~vkbur,
        b~abstk, b~gbstk,
        a~vsbed
   FROM vbak AS a
   INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
   INTO TABLE @lt_vbak.

    ELSE.

      SELECT a~vkorg, a~vtweg, a~spart, a~auart, a~kunnr, a~augru,
             a~knumv, a~waerk, a~erdat, a~vbeln, a~vkbur,
             b~abstk, b~gbstk,
             a~vsbed
        FROM vbak AS a
        INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
        INTO TABLE @lt_vbak
        WHERE a~vkorg = @i_org_ventas
          AND a~vtweg = @i_canal
          AND a~spart = @i_sector
          AND a~erdat BETWEEN @i_fechai AND @i_fechaf.

    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      SELECT kunnr name1 adrnr stras FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbak
        WHERE kunnr = lt_vbak-kunnr.

      SELECT addrnumber street
        FROM adrc
        INTO TABLE lt_adrc
        FOR ALL ENTRIES IN lt_kna1
        WHERE addrnumber = lt_kna1-adrnr.

      SELECT werks vstel lgort lprio route matnr kwmeng vrkme charg brgew vbeln posnr kpein AS po_quan kmein AS po_unit ernam
        FROM vbap
        INTO TABLE lt_vbap
        FOR ALL ENTRIES IN lt_vbak
        WHERE vbeln = lt_vbak-vbeln.

      SELECT matnr maktx FROM makt
        INTO TABLE lt_makt
        FOR ALL ENTRIES IN lt_vbap
        WHERE matnr = lt_vbap-matnr.

      IF lt_vbap IS NOT INITIAL.

        SELECT bstkd kdgrp bzirk pltyp kdkg1 vbeln posnr zterm
          FROM vbkd
          INTO TABLE lt_vbkd
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln.

        SELECT vbelv vbeln vbtyp_n FROM vbfa
          INTO TABLE lt_vbfa
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbelv   = lt_vbap-vbeln
            AND vbtyp_n = 'M'.

        SELECT aubel aupos vbeln FROM vbrp
          INTO TABLE lt_vbrp
          FOR ALL ENTRIES IN lt_vbap
          WHERE aubel = lt_vbap-vbeln.

        IF lt_vbrp IS NOT INITIAL.

          SELECT vbeln gjahr belnr FROM bseg
            INTO TABLE lt_bseg
            FOR ALL ENTRIES IN lt_vbrp
            WHERE vbeln = lt_vbrp-vbeln.

          IF lt_bseg IS NOT INITIAL.

            SELECT belnr xblnr FROM bkpf
              INTO TABLE lt_bkpf
              FOR ALL ENTRIES IN lt_bseg
              WHERE belnr = lt_bseg-belnr.

          ENDIF.

        ENDIF.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN lt_vbap
          WHERE     vbeln = lt_vbap-vbeln
                AND parvw = 'DF'
             OR parvw = 'RE'.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa2
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln
            AND parvw = 'VE'.

        IF lt_vbpa2 IS NOT INITIAL.

          SELECT pernr uname sname
            FROM pa0001
            INTO TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_vbpa2
            WHERE pernr = lt_vbpa2-pernr.

          SELECT usrid pernr FROM pa0105
            INTO TABLE lt_pa0105
            FOR ALL ENTRIES IN lt_vbpa2
            WHERE pernr = lt_vbpa2-pernr.

        ENDIF.

      ENDIF.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'NTPS'.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv2
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'MWST'.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv3
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZD01'
          AND kherk = 'C'.

      IF lt_konv3 IS INITIAL.

        SELECT knumv kwert kschl kherk kposn krech kbetr
          FROM konv
          INTO TABLE lt_konv3
          FOR ALL ENTRIES IN lt_vbak
          WHERE knumv = lt_vbak-knumv
            AND kschl = 'ZD01'.

      ENDIF.

      SELECT knumv kwert kschl kherk kposn krech kbetr
        FROM konv
        INTO TABLE lt_konv4
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'ZD02'.

    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      IF lt_vbap IS NOT INITIAL.

        LOOP AT lt_vbap ASSIGNING <fs_vbap>.

          APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
          <fs_retunr>-centro            = <fs_vbap>-werks.
          <fs_retunr>-puesto_expedicion = <fs_vbap>-vstel.
          <fs_retunr>-almacen           = <fs_vbap>-lgort.
          <fs_retunr>-prioridad_entrega = <fs_vbap>-lprio.
          <fs_retunr>-ruta              = <fs_vbap>-route.
          <fs_retunr>-articulo          = <fs_vbap>-matnr.
          <fs_retunr>-cantidad          = <fs_vbap>-kwmeng.
          <fs_retunr>-unidad_medida     = <fs_vbap>-vrkme.
          <fs_retunr>-lote              = <fs_vbap>-charg.
          <fs_retunr>-peso_bruto        = <fs_vbap>-brgew.
          <fs_retunr>-posicion          = <fs_vbap>-posnr.
          MOVE <fs_vbap>-po_quan TO <fs_retunr>-cantidad_pedido.
          MOVE <fs_vbap>-po_unit TO <fs_retunr>-unidad_pedido.
          <fs_retunr>-usuario           = <fs_vbap>-ernam.

          ASSIGN lt_makt[ matnr = <fs_vbap>-matnr ] TO <fs_makt>.
          IF sy-subrc = 0.
            <fs_retunr>-descripcion = <fs_makt>-maktx.
          ENDIF.

          ASSIGN lt_vbak[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbak>.
          IF sy-subrc = 0.
            <fs_retunr>-documento          = <fs_vbak>-vbeln.
            <fs_retunr>-organizacion_venta = <fs_vbak>-vkorg.
            <fs_retunr>-canal              = <fs_vbak>-vtweg.
            <fs_retunr>-sector             = <fs_vbak>-spart.
            <fs_retunr>-clase_documento    = <fs_vbak>-auart.
            <fs_retunr>-solicitante        = <fs_vbak>-kunnr.
            <fs_retunr>-motivo_pedido      = <fs_vbak>-augru.
            <fs_retunr>-cliente            = <fs_vbak>-knumv.
            <fs_retunr>-moneda             = <fs_vbak>-waerk.
            <fs_retunr>-fecha              = <fs_vbak>-erdat.
            <fs_retunr>-oficina            = <fs_vbak>-vkbur.
            MOVE <fs_vbak>-abstk TO <fs_retunr>-estatus_rechazo.
            MOVE <fs_vbak>-gbstk TO <fs_retunr>-estatus_global_cd.
            <fs_retunr>-motivo_expedicion  = <fs_vbak>-vsbed.

            ASSIGN lt_konv[ knumv = <fs_vbak>-knumv
                            kposn = <fs_vbap>-posnr ] TO <fs_konv>.
            IF sy-subrc = 0.
              lv_netwr = <fs_konv>-kwert.
            ENDIF.
            ASSIGN lt_konv2[ knumv = <fs_vbak>-knumv
                             kposn = <fs_vbap>-posnr ] TO <fs_konv2>.
            IF sy-subrc = 0.
              lv_mwsbp = <fs_konv2>-kwert.
            ENDIF.

            lv_netwr_mwsbp = lv_netwr + lv_mwsbp.
            <fs_retunr>-importe_bruto = lv_netwr_mwsbp.

            ASSIGN lt_konv3[ knumv = <fs_vbak>-knumv
                             kposn = <fs_vbap>-posnr ] TO <fs_konv3>.
            IF sy-subrc = 0.
              <fs_retunr>-desc_come_client = <fs_konv3>-kbetr.
            ENDIF.
            ASSIGN lt_konv4[ knumv = <fs_vbak>-knumv
                             kposn = <fs_vbap>-posnr ] TO <fs_konv4>.
            IF sy-subrc = 0.
              <fs_retunr>-desc_pesos_bruto = <fs_konv4>-kbetr.
            ENDIF.

            ASSIGN lt_kna1[ kunnr = <fs_vbak>-kunnr ] TO <fs_kna1>.
            IF sy-subrc = 0.
              <fs_retunr>-referencia_cliente = <fs_kna1>-name1.
              <fs_retunr>-direccion          = <fs_kna1>-adrnr.
              ASSIGN lt_adrc[ addrnumber = <fs_kna1>-adrnr ] TO <fs_adrc>.
              IF sy-subrc = 0.
                <fs_retunr>-direccion2 = <fs_adrc>-street.
              ENDIF.
            ENDIF.

          ENDIF.

          ASSIGN lt_vbkd[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbkd>.
          IF sy-subrc = 0.
            <fs_retunr>-num_ref_cliente   = <fs_vbkd>-bstkd.
            <fs_retunr>-grupo_cliente     = <fs_vbkd>-kdgrp.
            <fs_retunr>-zona_venta        = <fs_vbkd>-bzirk.
            <fs_retunr>-tipo_precio       = <fs_vbkd>-pltyp.
            <fs_retunr>-grupo_cond_client = <fs_vbkd>-kdkg1.
            <fs_retunr>-condicion_pago    = <fs_vbkd>-zterm.
          ENDIF.

          ASSIGN lt_vbrp[ aubel = <fs_vbap>-vbeln ] TO <fs_vbrp>.
          IF sy-subrc = 0.
            <fs_retunr>-doc_factura_log = <fs_vbrp>-vbeln.

            ASSIGN lt_bseg[ vbeln = <fs_vbrp>-vbeln ] TO <fs_bseg>.
            IF sy-subrc = 0.

            ENDIF.
          ENDIF.

          ASSIGN lt_vbfa[ vbelv = <fs_vbap>-vbeln ] TO <fs_vbfa>.
          IF sy-subrc = 0.
            <fs_retunr>-factura = <fs_vbfa>-vbeln.
          ENDIF.

          ASSIGN lt_vbpa[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa>.
          IF sy-subrc = 0.
            <fs_retunr>-bill_to = <fs_vbpa>-kunnr.
          ENDIF.

          ASSIGN lt_vbpa2[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa2>.
          IF sy-subrc = 0.
            <fs_retunr>-id_vendedor = <fs_vbpa2>-pernr.

            ASSIGN lt_pa0001[ pernr = <fs_vbpa2>-pernr ] TO <fs_pa0001>.
            IF sy-subrc = 0.
              <fs_retunr>-nombre_solicitante = <fs_pa0001>-sname.
            ENDIF.

          ENDIF.

          CLEAR: lv_netwr,
                 lv_mwsbp,
                 lv_netwr_mwsbp.

        ENDLOOP.

      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        <fs_retunr>-message  = 'No se han encontrado registros de posicion, en la VBAP'.
        <fs_retunr>-messcode = '400'.

      ENDIF.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message  = 'No se han encontrado registros de cabecera, en la VBAK'.
      <fs_retunr>-messcode = '400'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_VENTAS_RECHAZADAS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_ORG_VENTAS                   TYPE        VKORG
* | [--->] I_CANAL                        TYPE        VTWEG
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_ventas_rechazadas.
    TYPES: BEGIN OF gy_vbak,
             vkorg TYPE vbak-vkorg,
             vtweg TYPE vbak-vtweg,
             spart TYPE vbak-spart,
             kunnr TYPE vbak-kunnr,
             vkbur TYPE vbak-vkbur,
             vkgrp TYPE vbak-vkgrp,
             auart TYPE vbak-auart,
             vbeln TYPE vbak-vbeln,
             audat TYPE vbak-audat,
             waerk TYPE vbak-waerk,
             abstk TYPE vbuk-abstk, "REPLACE @100
             gbstk TYPE vbuk-gbstk, "REPLACE @100
             ernam TYPE vbak-ernam,
             knumv TYPE vbak-knumv,
             vsbed TYPE vbak-vsbed,
             augru TYPE vbak-augru,
           END OF gy_vbak.

    TYPES: BEGIN OF gy_vbap,
             werks   TYPE vbap-werks,
             vbeln   TYPE vbap-vbeln,
             posnr   TYPE vbap-posnr,
             matnr   TYPE vbap-matnr,
             kwmeng  TYPE vbap-kwmeng,
             abgru   TYPE vbap-abgru,
             vrkme   TYPE vbap-vrkme,
             charg   TYPE vbap-charg,
             po_quan TYPE vbap-kpein, "vbap-po_quan,"REPLACE @100
             po_unit TYPE vbap-kmein, "po_unit,"REPLACE @100
             brgew   TYPE vbap-brgew,
             vstel   TYPE vbap-vstel,
           END OF gy_vbap.

    TYPES: BEGIN OF gy_vbkd,
             bstkd TYPE vbkd-bstkd,
             vbeln TYPE vbkd-vbeln,
             posnr TYPE vbkd-posnr,
           END OF gy_vbkd.

    TYPES: BEGIN OF gy_but000,
             kunnr    TYPE but000-partner,
             mc_name1 TYPE but000-mc_name1,
             mc_name2 TYPE but000-mc_name2,
           END OF gy_but000.

    TYPES: BEGIN OF gy_tvagt,
             abgru TYPE tvagt-abgru,
             bezei TYPE tvagt-bezei,
             spras TYPE tvagt-spras,
           END OF gy_tvagt.

    TYPES: BEGIN OF gy_vbpa,
             vbeln TYPE vbpa-vbeln,
             posnr TYPE vbpa-posnr,
             kunnr TYPE vbpa-kunnr,
             pernr TYPE vbpa-pernr,
             parvw TYPE vbpa-parvw,
           END OF gy_vbpa.

    TYPES: BEGIN OF gy_pa0001,
             pernr TYPE pa0001-pernr, " NUMERO DE PERSONAL
             uname TYPE pa0001-uname, " usuario
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_konv,
             knumv TYPE konv-knumv,
             kwert TYPE konv-kwert,
             kschl TYPE konv-kschl,
           END OF gy_konv.

    TYPES: BEGIN OF gy_kna1,
             kunnr TYPE kna1-kunnr, " CLIENTE
             name1 TYPE kna1-name1, " NOMBRE
             adrnr TYPE kna1-adrnr, " DIRECCION
             stras TYPE kna1-stras, " CALLE Y NO
           END OF gy_kna1.

    TYPES: BEGIN OF gy_adrc,
             addrnumber TYPE adrc-addrnumber,
             street     TYPE adrc-street,
           END OF gy_adrc.

    TYPES: BEGIN OF gy_makt,
             matnr TYPE makt-matnr, "(Material)
             maktx TYPE makt-maktx, "(Texto breve material)
           END OF gy_makt.

    DATA lt_vbak        TYPE TABLE OF gy_vbak.
    DATA lt_vbap        TYPE TABLE OF gy_vbap.
    DATA lt_vbkd        TYPE TABLE OF gy_vbkd.
    DATA lt_but000      TYPE TABLE OF gy_but000.
    DATA lt_tvagt       TYPE TABLE OF gy_tvagt.
    DATA lt_vbpa        TYPE TABLE OF gy_vbpa.
    DATA lt_vbpa2       TYPE TABLE OF gy_vbpa.
    DATA lt_vbpa3       TYPE TABLE OF gy_vbpa.
    DATA lt_vbpa4       TYPE TABLE OF gy_vbpa.
    DATA lt_pa0001      TYPE TABLE OF gy_pa0001.
    DATA lt_kna1        TYPE TABLE OF gy_kna1.
    DATA lt_adrc        TYPE TABLE OF gy_adrc.
    DATA lt_makt        TYPE TABLE OF gy_makt.
    DATA lt_konv        TYPE TABLE OF gy_konv.
    DATA lt_konv2       TYPE TABLE OF gy_konv.
    DATA lv_netwr       TYPE konv-kwert.
    DATA lv_mwsbp       TYPE konv-kwert.
    DATA lv_netwr_mwsbp TYPE konv-kwert.

    FIELD-SYMBOLS <fs_vbak>   LIKE LINE OF lt_vbak.
    FIELD-SYMBOLS <fs_vbap>   LIKE LINE OF lt_vbap.
    FIELD-SYMBOLS <fs_vbkd>   LIKE LINE OF lt_vbkd.
    FIELD-SYMBOLS <fs_but000> LIKE LINE OF lt_but000.
    FIELD-SYMBOLS <fs_tvagt>  LIKE LINE OF lt_tvagt.
    FIELD-SYMBOLS <fs_vbpa>   LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_vbpa2>  LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_vbpa3>  LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_vbpa4>  LIKE LINE OF lt_vbpa.
    FIELD-SYMBOLS <fs_pa0001> LIKE LINE OF lt_pa0001.
    FIELD-SYMBOLS <fs_kna1>   LIKE LINE OF lt_kna1.
    FIELD-SYMBOLS <fs_adrc>   LIKE LINE OF lt_adrc.
    FIELD-SYMBOLS <fs_makt>   LIKE LINE OF lt_makt.
    FIELD-SYMBOLS <fs_konv>   LIKE LINE OF lt_konv.
    FIELD-SYMBOLS <fs_konv2>  LIKE LINE OF lt_konv2.
    FIELD-SYMBOLS <fs_retunr> LIKE LINE OF rt_return.

    SELECT a~vkorg, a~vtweg, a~spart, a~kunnr, a~vkbur, a~vkgrp,
           a~auart, a~vbeln, a~audat, a~waerk,
           b~abstk, b~gbstk,
           a~ernam, a~knumv, a~vsbed, a~augru
      FROM vbak AS a
      INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
      INTO TABLE @lt_vbak
      WHERE a~vkorg = @i_org_ventas
        AND a~vtweg = @i_canal.

    IF lt_vbak IS NOT INITIAL.

      SELECT partner mc_name1 mc_name2
        FROM but000
        INTO TABLE lt_but000
        FOR ALL ENTRIES IN lt_vbak
        WHERE partner = lt_vbak-kunnr.

      SELECT kunnr name1 adrnr stras FROM kna1
        INTO TABLE lt_kna1
        FOR ALL ENTRIES IN lt_vbak
        WHERE kunnr = lt_vbak-kunnr.

      SELECT addrnumber street
        FROM adrc
        INTO TABLE lt_adrc
        FOR ALL ENTRIES IN lt_kna1
        WHERE addrnumber = lt_kna1-adrnr.

      SELECT werks vbeln posnr matnr kwmeng abgru vrkme charg kpein AS po_quan kmein AS po_unit brgew vstel
       FROM vbap
       INTO TABLE lt_vbap
       FOR ALL ENTRIES IN lt_vbak
       WHERE vbeln = lt_vbak-vbeln.

      IF lt_vbap IS NOT INITIAL.

        SELECT matnr maktx FROM makt
          INTO TABLE lt_makt
          FOR ALL ENTRIES IN lt_vbap
          WHERE matnr = lt_vbap-matnr.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa
          FOR ALL ENTRIES IN lt_vbap
          WHERE     vbeln = lt_vbap-vbeln
                AND parvw = 'DF'
             OR parvw = 'RE'.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa2
          FOR ALL ENTRIES IN lt_vbap
          WHERE     vbeln = lt_vbap-vbeln
                AND parvw = 'RP'
             OR parvw = 'RG'.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa3
          FOR ALL ENTRIES IN lt_vbap
          WHERE     vbeln = lt_vbap-vbeln
                AND parvw = 'BU'
             OR parvw = 'WE'.

        SELECT vbeln posnr kunnr pernr parvw
          FROM vbpa
          INTO TABLE lt_vbpa4
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln
            AND parvw = 'VE'.

        IF lt_vbpa4 IS NOT INITIAL.

          SELECT pernr uname FROM pa0001
            INTO TABLE lt_pa0001
            FOR ALL ENTRIES IN lt_vbpa4
            WHERE pernr = lt_vbpa4-pernr.

        ENDIF.

        SELECT bstkd vbeln posnr FROM vbkd
          INTO TABLE lt_vbkd
          FOR ALL ENTRIES IN lt_vbap
          WHERE vbeln = lt_vbap-vbeln
            AND posnr = lt_vbap-posnr.

        SELECT abgru bezei spras FROM tvagt
          INTO TABLE lt_tvagt
          FOR ALL ENTRIES IN lt_vbap
          WHERE abgru = lt_vbap-abgru
            AND spras = 'S'.

      ENDIF.

      SELECT knumv kwert kschl FROM konv
        INTO TABLE lt_konv
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'NTPS'.

      SELECT knumv kwert kschl FROM konv
        INTO TABLE lt_konv2
        FOR ALL ENTRIES IN lt_vbak
        WHERE knumv = lt_vbak-knumv
          AND kschl = 'MWST'.

    ENDIF.

    IF lt_vbak IS NOT INITIAL.

      IF lt_vbap IS NOT INITIAL.

        LOOP AT lt_vbap ASSIGNING <fs_vbap>.

          APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
          <fs_retunr>-centro            = <fs_vbap>-werks.
          <fs_retunr>-motivo_rechazo    = <fs_vbap>-abgru.
          <fs_retunr>-articulo          = <fs_vbap>-matnr.
          <fs_retunr>-cantidad          = <fs_vbap>-kwmeng.
          <fs_retunr>-posicion          = <fs_vbap>-posnr.
          <fs_retunr>-unidad_medida     = <fs_vbap>-vrkme.
          <fs_retunr>-lote              = <fs_vbap>-charg.
          MOVE <fs_vbap>-po_quan TO <fs_retunr>-cantidad_pedido.
          MOVE <fs_vbap>-po_unit TO <fs_retunr>-unidad_pedido.
          <fs_retunr>-peso_bruto        = <fs_vbap>-brgew.
          <fs_retunr>-puesto_expedicion = <fs_vbap>-vstel.

          ASSIGN lt_makt[ matnr = <fs_vbap>-matnr ] TO <fs_makt>.
          IF sy-subrc = 0.
            <fs_retunr>-descripcion = <fs_makt>-maktx.
          ENDIF.

          ASSIGN lt_vbak[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbak>.
          IF sy-subrc = 0.
            <fs_retunr>-documento          = <fs_vbak>-vbeln.
            <fs_retunr>-organizacion_venta = <fs_vbak>-vkorg.
            <fs_retunr>-canal              = <fs_vbak>-vtweg.
            <fs_retunr>-sector             = <fs_vbak>-spart.
            <fs_retunr>-clase_documento    = <fs_vbak>-auart.
            <fs_retunr>-cliente            = <fs_vbak>-kunnr.
            <fs_retunr>-grupo_vendedores   = <fs_vbak>-vkgrp.
            <fs_retunr>-fecha              = <fs_vbak>-audat.
            <fs_retunr>-moneda             = <fs_vbak>-waerk.
            MOVE <fs_vbak>-abstk TO <fs_retunr>-estatus_rechazo.
            <fs_retunr>-oficina            = <fs_vbak>-vkbur.
            MOVE <fs_vbak>-gbstk TO <fs_retunr>-estatus_global_cd.
            <fs_retunr>-usuario            = <fs_vbak>-ernam.
            <fs_retunr>-motivo_expedicion  = <fs_vbak>-vsbed.
            <fs_retunr>-motivo_pedido      = <fs_vbak>-augru.
            <fs_retunr>-usuario            = <fs_vbak>-ernam.

            ASSIGN lt_but000[ kunnr = <fs_vbak>-kunnr ] TO <fs_but000>.
            IF sy-subrc = 0.

              <fs_retunr>-mc_name1 = <fs_but000>-mc_name1.
              <fs_retunr>-mc_name2 = <fs_but000>-mc_name2.

            ENDIF.

            ASSIGN lt_konv[ knumv = <fs_vbak>-knumv ] TO <fs_konv>.
            IF sy-subrc = 0.
              lv_netwr = <fs_konv>-kwert.
            ENDIF.
            ASSIGN lt_konv2[ knumv = <fs_vbak>-knumv ] TO <fs_konv2>.
            IF sy-subrc = 0.
              lv_mwsbp = <fs_konv2>-kwert.
            ENDIF.

            lv_netwr_mwsbp = lv_netwr + lv_mwsbp.
            <fs_retunr>-importe_bruto = lv_netwr_mwsbp.

            ASSIGN lt_kna1[ kunnr = <fs_vbak>-kunnr ] TO <fs_kna1>.
            IF sy-subrc = 0.
              <fs_retunr>-referencia_cliente = <fs_kna1>-name1.
              <fs_retunr>-direccion          = <fs_kna1>-adrnr.
              ASSIGN lt_adrc[ addrnumber = <fs_kna1>-adrnr ] TO <fs_adrc>.
              IF sy-subrc = 0.
                <fs_retunr>-direccion2 = <fs_adrc>-street.
              ENDIF.

            ENDIF.

          ENDIF.

          ASSIGN lt_vbkd[ vbeln = <fs_vbap>-vbeln
                          posnr = <fs_vbap>-posnr ] TO <fs_vbkd>.

          IF sy-subrc = 0.
            <fs_retunr>-referencia_cliente = <fs_vbkd>-bstkd.
          ENDIF.

          ASSIGN lt_tvagt[ abgru = <fs_vbap>-abgru ] TO <fs_tvagt>.
          IF sy-subrc = 0.

            <fs_retunr>-motivo_rechazo_deno = <fs_tvagt>-bezei.
          ENDIF.

          ASSIGN lt_vbpa[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa>.
          IF sy-subrc = 0.
            <fs_retunr>-bill_to = <fs_vbpa>-kunnr.
          ENDIF.

          ASSIGN lt_vbpa2[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa2>.
          IF sy-subrc = 0.
            <fs_retunr>-payer = <fs_vbpa2>-kunnr.
          ENDIF.

          ASSIGN lt_vbpa3[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa3>.
          IF sy-subrc = 0.
            <fs_retunr>-ship_to = <fs_vbpa3>-kunnr.
          ENDIF.

          ASSIGN lt_vbpa4[ vbeln = <fs_vbap>-vbeln ] TO <fs_vbpa4>.
          IF sy-subrc = 0.
            <fs_retunr>-id_vendedor = <fs_vbpa4>-pernr.

            ASSIGN lt_pa0001[ pernr = <fs_vbpa4>-pernr ] TO <fs_pa0001>.
            IF sy-subrc = 0.

            ENDIF.
          ENDIF.

        ENDLOOP.

      ELSE.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
        <fs_retunr>-message  = 'No se han encontrado registros de posicion, en la VBAP'.
        <fs_retunr>-messcode = '400'.

      ENDIF.

    ELSE.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_retunr>.
      <fs_retunr>-message  = 'No se han encontrado registros de cabecera, en la VBAK'.
      <fs_retunr>-messcode = '400'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->GET_ZONA_VENTA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_OFICINA                      TYPE        TVBVK-VKBUR(optional)
* | [<---] RT_RETURN                      TYPE        YSD_TT_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_zona_venta.
    "+---------------------------------------------------------------------+
    "^ IDesarrollo.....:
    "^ Módulo..........: SD
    "^ Funcional.......: Yubisay Porte
    "^ Autor...........: Milton Terrazas
    "^ Fecha...........: 04.05.2025
    "^ Descripción.....: Obtener zonas de venta (t171) con descripción
    "^                    y marcar como activa si coincide con oficina.
    "+---------------------------------------------------------------------+

    " Tipos locales para zonas y sus textos
    TYPES: BEGIN OF lty_t171,
             bzirk TYPE t171-bzirk, " Zona de ventas
           END OF lty_t171.

    TYPES: BEGIN OF lty_t171t,
             bzirk TYPE t171t-bzirk, " Zona de ventas
             bztxt TYPE t171t-bztxt, " Descripción zona
             spras TYPE t171t-spras, " Idioma
           END OF lty_t171t.

    " Variables internas
    DATA lt_t171   TYPE STANDARD TABLE OF lty_t171.                " Zonas
    DATA lt_t171t  TYPE STANDARD TABLE OF lty_t171t.                " Textos zonas
    DATA lv_depart TYPE t005u-bezei. " Descripción departamento
    DATA lv_msg    TYPE string.      " Texto mensaje

    FIELD-SYMBOLS <ls_t171>  TYPE lty_t171.
    FIELD-SYMBOLS <ls_t171t> TYPE lty_t171t.
    FIELD-SYMBOLS <ls_ret>   LIKE LINE OF rt_return.

    " Obtener nombre del departamento asociado a la oficina
    SELECT SINGLE c~bezei INTO @lv_depart
      FROM tvbur AS a
             INNER JOIN
               adrc AS b ON a~adrnr = b~addrnumber
                 INNER JOIN
                   t005u AS c ON b~region = c~bland
      WHERE a~vkbur = @i_oficina
        AND c~spras = 'S'
        AND c~land1 = 'BO'.

    " Leer zonas de venta
    SELECT bzirk INTO TABLE @lt_t171
      FROM t171.

    IF lt_t171 IS NOT INITIAL.

      " Leer descripciones de zonas (según idioma)
      SELECT bzirk, bztxt, spras INTO TABLE @lt_t171t
        FROM t171t
        FOR ALL ENTRIES IN @lt_t171
        WHERE bzirk = @lt_t171-bzirk
          AND spras = 'S'.

      LOOP AT lt_t171 ASSIGNING <ls_t171>.

        APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
        <ls_ret>-zona_venta = <ls_t171>-bzirk.
        ASSIGN lt_t171t[ bzirk = <ls_t171>-bzirk ] TO <ls_t171t>.
        IF sy-subrc = 0.
          " Marcar si la zona coincide con el departamento obtenido
          <ls_ret>-descripcion = <ls_t171t>-bztxt.
          IF lv_depart = <ls_t171t>-bztxt.
            <ls_ret>-check_zona_venta = 'X'.
          ENDIF.
        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND INITIAL LINE TO rt_return ASSIGNING <ls_ret>.
      MESSAGE ID gc_msgid TYPE 'I' NUMBER '001' INTO lv_msg.
      <ls_ret>-message  = lv_msg.
      <ls_ret>-messcode = gc_error_400.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_COBRO
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_COBRO_H                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_P                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_C                  TYPE        YSD_TT_003_CONTABILIZAR
* | [<---] RT_RETURN                      TYPE        YSD_S_003_CONTABILIZAR
* | [<---] RT_DOC                         TYPE        YSD_TT_011_FI_DOC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cobro.

    TYPES: BEGIN OF gy_doc,
             indice          TYPE char2,
             documento_cobro TYPE char10,
             metodo_pago     TYPE char20,
             importe(24),
           END OF gy_doc.
    DATA: lv_importechar(24).
    CLEAR lv_importechar.
    DATA: lt_t_ftpost   TYPE TABLE OF ftpost,
          lt_t_ftpost2  TYPE TABLE OF ftpost,
          lt_t_ftclear2 TYPE TABLE OF ftclear,
          lt_t_ftpost3  TYPE TABLE OF ftpost,
          lt_t_ftclear3 TYPE TABLE OF ftclear,
          ls_retunr     LIKE rt_return,
          lt_doc        TYPE TABLE OF gy_doc,
          lv_indice     TYPE char2,
          lv_importe    TYPE char15,
          lv_error      TYPE c,
          go_error      TYPE REF TO cx_root,
          lv_message    TYPE string,
          lv_salida     TYPE string,
          lv_errorch    TYPE string,
          lv_errorbpe1  TYPE string,
          lv_errorbpe2  TYPE string,
          lv_errorbpe3  TYPE string,
          lv_errorbp    TYPE string,
          lv_errorbp2   TYPE string,
          lv_errorbp3   TYPE string,
          lv_errorbp4   TYPE string,
          lv_errorbp5   TYPE string,
          lv_errorbp6   TYPE string,
          lv_errorbp7   TYPE string,
          lv_errorbp8   TYPE string,
          lv_errorbp9   TYPE string,
          lv_e_subrc    TYPE sy-subrc,
          lv_e_subrc2   TYPE sy-subrc,
          lv_e_subrc3   TYPE sy-subrc,
          lv_e_subrce   TYPE string,
          lv_e_subrce2  TYPE sstring,
          lv_e_subrce3  TYPE string.

    DATA: lt_t_fttax   TYPE TABLE OF fttax,
          lt_t_fttax2  TYPE TABLE OF fttax,
          lt_t_fttax3  TYPE TABLE OF fttax,
          lt_t_blntab  TYPE TABLE OF blntab,
          lt_t_blntab2 TYPE TABLE OF blntab,
          lt_t_blntab3 TYPE TABLE OF blntab,
          lt_t_ftclear TYPE TABLE OF ftclear.

    DATA: lv_e_msgid     LIKE  sy-msgid,
          lv_e_msgno     LIKE  sy-msgno,
          lv_e_msgty     LIKE  sy-msgty,
          lv_e_msgv1     LIKE  sy-msgv1,
          lv_documentoe1 LIKE  sy-msgv1,
          lv_documentoe2 LIKE  sy-msgv1,
          lv_e_msgv2     LIKE  sy-msgv2,
          lv_e_msgv3     LIKE  sy-msgv3,
          lv_e_msgv4     LIKE  sy-msgv4.

    DATA: lv_e_msgid2 LIKE  sy-msgid,
          lv_e_msgno2 LIKE  sy-msgno,
          lv_e_msgty2 LIKE  sy-msgty,
          lv_e_msgv12 LIKE  sy-msgv1,
          lv_e_msgv22 LIKE  sy-msgv2,
          lv_e_msgv32 LIKE  sy-msgv3,
          lv_e_msgv42 LIKE  sy-msgv4.

    DATA: lv_e_msgid3 LIKE  sy-msgid,
          lv_e_msgno3 LIKE  sy-msgno,
          lv_e_msgty3 LIKE  sy-msgty,
          lv_e_msgv13 LIKE  sy-msgv1,
          lv_e_msgv23 LIKE  sy-msgv2,
          lv_e_msgv33 LIKE  sy-msgv3,
          lv_e_msgv43 LIKE  sy-msgv4.

    DATA: lv_text   TYPE string,
          lv_text2  TYPE string,
          lv_text3  TYPE string,
          lv_i_mode TYPE rfpdo-allgazmd.

    FIELD-SYMBOLS: <fs_t_ftpost>      LIKE LINE OF lt_t_ftpost,
                   <fs_t_ftpost2>     LIKE LINE OF lt_t_ftpost2,
                   <fs_t_ftclear2>    LIKE LINE OF lt_t_ftclear2,
                   <fs_t_ftpost3>     LIKE LINE OF lt_t_ftpost3,
                   <fs_t_ftclear3>    LIKE LINE OF lt_t_ftclear3,
                   <fs_i_new_cobro_h> LIKE LINE OF i_new_cobro_h,
                   <fs_i_new_cobro_p> LIKE LINE OF i_new_cobro_p,
                   <fs_i_new_cobro_c> LIKE LINE OF i_new_cobro_c,
                   <fs_doc>           LIKE LINE OF lt_doc.

    CALL METHOD ycl_fi_constante_handler=>load_constante
      EXPORTING
        i_aplica = gc_aplica.

********************************************************************************************************************************************
****************************************************** Etapa 1******************************************************************************
********************************************************************************************************************************************
    LOOP AT i_new_cobro_h ASSIGNING <fs_i_new_cobro_h>.

      LOOP AT i_new_cobro_c ASSIGNING <fs_i_new_cobro_c>.

        lv_indice = <fs_i_new_cobro_c>-indice.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-XBLNR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-numero_referencia.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BKTXT'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-metodo_pago.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-WAERS'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-moneda.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-KURSF'.
        <fs_t_ftpost>-fval =  <fs_i_new_cobro_h>-tipo_cambio.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BUDAT'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_contab.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_postfechado.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COBRO'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.

        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                          WITH KEY cgroup = gc_cgroup_payhdr
                                                   zvalor = gc_zblart_cobro.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BUKRS'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-sociedad.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BLDAT'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_documento.

************************************************************POSISCION*****************************************************+

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-VALUT'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_documento.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-WRBTR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-importe_pagar.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-documento_pago.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-txt_pag.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
*{REPLACE @100
*          READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZSGTXT_CHPOST'.
*          IF sy-subrc = 0.
*            CONDENSE lw_tvarvc-low.
*            <fs_t_ftpost>-fval = lw_tvarvc-low.
*          ENDIF.

          READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                        WITH KEY cgroup = gc_cgroup_payar
                                                 zvalor = gc_zsgtxt_chpost.
          IF sy-subrc = 0.
            CONDENSE gwa_constantes-yvalor.
            <fs_t_ftpost>-fval = gwa_constantes-yvalor.
          ENDIF.
*}REPLACE @100
        ENDIF.


        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>."
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'COBL-PRCTR'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZPRCTR_GL'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.

        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_paygl
                                                     zvalor = gc_zprctr_gl.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-cuenta_banco.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_paygl
                                                     zvalor = gc_znewbs_40.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-WRBTR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-importe_pagar.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-documento_pago.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.

        DATA: gv_txt_pag  TYPE yfi_t001_metpago-met_pag.
        CLEAR: gv_txt_pag.
        SELECT SINGLE txt_pag INTO gv_txt_pag
          FROM yfi_t001_metpago
          WHERE  met_pag =   <fs_i_new_cobro_h>-metodo_pago.


        CONCATENATE gv_txt_pag <fs_i_new_cobro_h>-glosa INTO  <fs_t_ftpost>-fval SEPARATED BY space.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-MWSKZ'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZMWSKZ_CLIENTE'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payar
                                                     zvalor = gc_zmwskz_cliente.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-cliente.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_15'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payar
                                                     zvalor = gc_znewbs_15.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_START'
              EXPORTING
                i_client           = sy-mandt
                i_function         = 'C'
*               I_GROUP            = ' '
                i_keep             = 'X'
                i_mode             = 'N'
                i_update           = 'S'
                i_user             = sy-uname
              EXCEPTIONS
                client_incorrect   = 1
                function_invalid   = 2
                group_name_missing = 3
                mode_invalid       = 4
                update_invalid     = 5
                user_invalid       = 6
                OTHERS             = 7.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp '1/CLIENT_INCORRECT' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp '2/FUNCTION_INVALID' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp 'GROUP_NAME_MISSING' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp 'MODE_INVALID'       INTO lv_errorbp.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp 'UPDATE_INVALID'     INTO lv_errorbp.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp 'USER_INVALID'       INTO lv_errorbp.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp 'OTHERS'             INTO lv_errorbp.
              ENDIF.
            ENDIF.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
              EXPORTING
                i_auglv                    = 'EINGZAHL'
                i_tcode                    = 'FB05'
                i_sgfunct                  = 'C'
              IMPORTING
                e_msgid                    = lv_e_msgid
                e_msgno                    = lv_e_msgno
                e_msgty                    = lv_e_msgty
                e_msgv1                    = lv_e_msgv1
                e_msgv2                    = lv_e_msgv2
                e_msgv3                    = lv_e_msgv3
                e_msgv4                    = lv_e_msgv4
                e_subrc                    = lv_e_subrc
              TABLES
                t_blntab                   = lt_t_blntab
                t_ftclear                  = lt_t_ftclear
                t_ftpost                   = lt_t_ftpost
                t_fttax                    = lt_t_fttax
              EXCEPTIONS
                clearing_procedure_invalid = 1
                clearing_procedure_missing = 2
                table_t041a_empty          = 3
                transaction_code_invalid   = 4
                amount_format_error        = 5
                too_many_line_items        = 6
                company_code_invalid       = 7
                screen_not_found           = 8
                no_authorization           = 9
                OTHERS                     = 10.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp2 'TABLE_T041A_EMPTY' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp2  'TRANSACTION_CODE_INVALID' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp2 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp2 'TOO_MANY_LINE_ITEMS'   INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp2 'COMPANY_CODE_INVALID'  INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 8.
                CONCATENATE lv_errorbp2 'SCREEN_NOT_FOUND'      INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 9.
                CONCATENATE lv_errorbp2 'NO_AUTHORIZATION'      INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 10.
                CONCATENATE lv_errorbp2 'OTHERS'                INTO lv_errorbp2.
              ENDIF.
            ENDIF.

            IF lv_e_subrc <> 0.

              SELECT SINGLE text
                      FROM t100
                      INTO (lv_text)
                      WHERE sprsl EQ 'S'
                      AND arbgb EQ lv_e_msgid
                      AND msgnr EQ lv_e_msgno.

              CONCATENATE lv_errorbpe1 lv_e_msgid '/' lv_e_msgno '/' lv_e_msgty '/' lv_e_msgv1 '/' lv_text '-' INTO lv_errorbpe1 SEPARATED BY ' '.

            ELSE.

              CONCATENATE lv_documentoe1 lv_indice '/' lv_e_msgv1 '-' INTO lv_documentoe1. "SEPARATED BY ' '.

              APPEND INITIAL LINE TO lt_doc ASSIGNING <fs_doc>.
              <fs_doc>-indice = lv_indice.
              <fs_doc>-documento_cobro = lv_e_msgv1.
              <fs_doc>-metodo_pago = <fs_i_new_cobro_c>-metodo_pago.
              READ TABLE lt_t_ftpost ASSIGNING <fs_t_ftpost> WITH KEY fnam = 'BSEG-WRBTR'.
              IF sy-subrc EQ 0.
                <fs_doc>-importe = <fs_t_ftpost>-fval.
              ENDIF.

            ENDIF.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_END'
              EXPORTING
                i_bdcimmed              = 'X'
              EXCEPTIONS
                session_not_processable = 1
                OTHERS                  = 2.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp3 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp3.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp3 'OTHERS' INTO lv_errorbp3.
              ENDIF.
            ENDIF.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        CLEAR: lt_t_ftpost, lv_e_msgid, lv_e_msgno, lv_e_msgty, lv_e_msgv1, lv_text, lv_indice.

      ENDLOOP.
    ENDLOOP.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND lv_errorbpe1 IS INITIAL.
********************************************************************************************************************************************
****************************************************** Etapa 2******************************************************************************
********************************************************************************************************************************************

      LOOP AT i_new_cobro_h ASSIGNING <fs_i_new_cobro_h>.

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam  = 'BKPF-XBLNR'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost2>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                    WITH KEY cgroup = gc_cgroup_payhdr
                                             zvalor = gc_zbktxt_compensa.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam  = 'RF05A-AUGTX'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZAUGTX_COMPENSA'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost2>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payhdr
                                                     zvalor = gc_zaugtx_compensa.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-BKTXT'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost2>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                          WITH KEY cgroup = gc_cgroup_payhdr
                                                   zvalor = gc_zbktxt_compensa.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-WAERS'.
        <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-moneda.

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-KURSF'.
        <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-tipo_cambio.

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-BUDAT'.
        <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_contab.

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COMPENSA'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost2>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payhdr
                                                     zvalor = gc_zblart_compensa.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-BUKRS'.
        <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-sociedad."

        APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
        <fs_t_ftpost2>-stype = 'K'.
        <fs_t_ftpost2>-count = '001'.
        <fs_t_ftpost2>-fnam = 'BKPF-BLDAT'.
        <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_documento.

        IF <fs_i_new_cobro_h>-check IS INITIAL.
************************************************************POSISCION******************************************************
          LOOP AT i_new_cobro_p ASSIGNING <fs_i_new_cobro_p>.
            APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
            <fs_t_ftclear2>-agkoa  = 'D'.
            <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
            <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
            <fs_t_ftclear2>-xnops  = 'X'.
            <fs_t_ftclear2>-agums  = ' '.
            <fs_t_ftclear2>-selfd  = 'BELNR'.
            <fs_t_ftclear2>-selvon = <fs_i_new_cobro_p>-numero_documento.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
            <fs_t_ftpost2>-stype = 'P'.
            <fs_t_ftpost2>-count = '002'.
            <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
            <fs_t_ftpost2>-fval = <fs_i_new_cobro_p>-numero_documento.

          ENDLOOP.

          LOOP AT lt_doc ASSIGNING <fs_doc>.
            APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
            <fs_t_ftclear2>-agkoa  = 'D'.
            <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
            <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
            <fs_t_ftclear2>-xnops  = 'X'.
            <fs_t_ftclear2>-agums  = ' '.
            <fs_t_ftclear2>-selfd  = 'BELNR'.
            <fs_t_ftclear2>-selvon = <fs_doc>-documento_cobro.
            <fs_t_ftclear2>-selbis = <fs_doc>-documento_cobro.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
            <fs_t_ftpost2>-stype = 'P'.
            <fs_t_ftpost2>-count = '002'.
            <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
            <fs_t_ftpost2>-fval = <fs_doc>-documento_cobro.

          ENDLOOP.

        ELSEIF <fs_i_new_cobro_h>-check EQ 'X'.


        ENDIF.


      ENDLOOP.

      lv_i_mode = 'N'.

      TRY.


          CALL FUNCTION 'POSTING_INTERFACE_START'
            EXPORTING
              i_client           = sy-mandt
              i_function         = 'C'
*             I_GROUP            = ' '
              i_keep             = 'X'
              i_mode             = lv_i_mode "'N'
              i_update           = 'S'
              i_user             = sy-uname
            EXCEPTIONS
              client_incorrect   = 1
              function_invalid   = 2
              group_name_missing = 3
              mode_invalid       = 4
              update_invalid     = 5
              user_invalid       = 6
              OTHERS             = 7.
          IF sy-subrc <> 0.
            IF sy-subrc EQ 1.
              CONCATENATE lv_errorbp4 '1/CLIENT_INCORRECT' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 2.
              CONCATENATE lv_errorbp4 '2/FUNCTION_INVALID' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 3.
              CONCATENATE lv_errorbp4 'GROUP_NAME_MISSING' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 4.
              CONCATENATE lv_errorbp4 'MODE_INVALID' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 5.
              CONCATENATE lv_errorbp4 'UPDATE_INVALID' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 6.
              CONCATENATE lv_errorbp4 'USER_INVALID' INTO lv_errorbp4.
            ELSEIF sy-subrc EQ 7.
              CONCATENATE lv_errorbp4 'OTHERS' INTO lv_errorbp4.
            ENDIF.
          ENDIF.


        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

      TRY.

          CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
            EXPORTING
              i_auglv                    = 'UMBUCHNG'
              i_tcode                    = 'FB05'
              i_sgfunct                  = 'C'
            IMPORTING
              e_msgid                    = lv_e_msgid2
              e_msgno                    = lv_e_msgno2
              e_msgty                    = lv_e_msgty2
              e_msgv1                    = lv_e_msgv12
              e_msgv2                    = lv_e_msgv22
              e_msgv3                    = lv_e_msgv32
              e_msgv4                    = lv_e_msgv42
              e_subrc                    = lv_e_subrc2
            TABLES
              t_blntab                   = lt_t_blntab2
              t_ftpost                   = lt_t_ftpost2
              t_ftclear                  = lt_t_ftclear2
              t_fttax                    = lt_t_fttax2
            EXCEPTIONS
              clearing_procedure_invalid = 1
              clearing_procedure_missing = 2
              table_t041a_empty          = 3
              transaction_code_invalid   = 4
              amount_format_error        = 5
              too_many_line_items        = 6
              company_code_invalid       = 7
              screen_not_found           = 8
              no_authorization           = 9
              OTHERS                     = 10.
          IF sy-subrc <> 0.
            IF sy-subrc EQ 1.
              CONCATENATE lv_errorbp5 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 2.
              CONCATENATE lv_errorbp5 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 3.
              CONCATENATE lv_errorbp5  'TABLE_T041A_EMPTY' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 4.
              CONCATENATE lv_errorbp5  'TRANSACTION_CODE_INVALID' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 5.
              CONCATENATE lv_errorbp5 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 6.
              CONCATENATE lv_errorbp5 'TOO_MANY_LINE_ITEMS' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 7.
              CONCATENATE lv_errorbp5 'COMPANY_CODE_INVALID' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 8.
              CONCATENATE lv_errorbp5 'SCREEN_NOT_FOUND' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 9.
              CONCATENATE lv_errorbp5 'NO_AUTHORIZATION' INTO lv_errorbp5.
            ELSEIF sy-subrc EQ 10.
              CONCATENATE lv_errorbp5 'OTHERS' INTO lv_errorbp.
            ENDIF.
          ENDIF.

          IF lv_e_subrc2 <> 0.

            SELECT SINGLE text
                    FROM t100
                    INTO (lv_text2)
                    WHERE sprsl EQ 'S'
                    AND arbgb EQ lv_e_msgid2
                    AND msgnr EQ lv_e_msgno2.

            CONCATENATE lv_errorbpe2 lv_e_msgid2 '/' lv_e_msgno2 '/' lv_e_msgty2 '/' lv_e_msgv12 '/' lv_text2 '-' INTO lv_errorbpe2 SEPARATED BY ' '.
          ELSE.

            CONCATENATE lv_documentoe2 lv_e_msgv12 '-' INTO lv_documentoe2 SEPARATED BY ' '.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

      TRY.

          CALL FUNCTION 'POSTING_INTERFACE_END'
            EXPORTING
              i_bdcimmed              = 'X'
            EXCEPTIONS
              session_not_processable = 1
              OTHERS                  = 2.
          IF sy-subrc <> 0.
            IF sy-subrc EQ 1.
              CONCATENATE lv_errorbp6 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp6.
            ELSEIF sy-subrc EQ 2.
              CONCATENATE lv_errorbp6 'OTHERS' INTO lv_errorbp6.
            ENDIF.
          ENDIF.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND
       lv_errorbp4 IS INITIAL AND lv_errorbp5 IS INITIAL AND lv_errorbp6 IS INITIAL AND
       lv_errorbp7 IS INITIAL AND lv_errorbp8 IS INITIAL AND lv_errorbp9 IS INITIAL.

      IF lv_errorbpe1 IS INITIAL AND lv_errorbpe2 IS INITIAL AND lv_errorbpe3 IS INITIAL.

        lv_e_subrce = lv_e_subrc.
        lv_e_subrce2 = lv_e_subrc2.
        lv_e_subrce3 = lv_e_subrc3.

        CONCATENATE 'COBROS: ' lv_e_msgv1 '-'  lv_e_msgv12 '-' lv_e_msgv13 INTO lv_salida SEPARATED BY space.
        CONCATENATE 'Se proceso exitosamente la etapa 1 y 2: ' lv_salida INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '200'.
        rt_return-datac = lv_documentoe1.

        rt_doc = lt_doc.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        IF lv_errorbpe1 IS NOT INITIAL.

          CONCATENATE 'Etapa 1 con error : ' lv_errorbpe1 '-' INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.

        ELSEIF lv_errorbpe2 IS NOT INITIAL.

          CONCATENATE 'Etapa 2 con error: ' lv_errorbpe2 '-' INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.
          rt_return-datac = lv_documentoe1.

        ELSEIF lv_errorbpe3 IS NOT INITIAL.

          CONCATENATE 'Etapa 3 con error: ' lv_errorbpe3 '-' INTO lv_message.
          CONCATENATE 'Documentos de la Etapa 1: ' lv_documentoe1 'Documento de la Etapa 2: ' lv_documentoe2 INTO lv_salida.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.
          rt_return-datac = lv_salida.

        ENDIF.

      ENDIF.

    ELSE.

      IF lv_errorbp IS NOT INITIAL OR lv_errorbp2 IS NOT INITIAL OR lv_errorbp3 IS NOT INITIAL.

        CONCATENATE 'Etapa 1 con error : ' lv_errorbp '-' lv_errorbp2 '-' lv_errorbp3 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp4 IS NOT INITIAL OR lv_errorbp5 IS NOT INITIAL OR lv_errorbp6 IS NOT INITIAL.

        CONCATENATE 'Etapa 2 con error: ' lv_errorbp4 '-' lv_errorbp5 '-' lv_errorbp6 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp7 IS NOT INITIAL OR lv_errorbp8 IS NOT INITIAL OR lv_errorbp9 IS NOT INITIAL.

        CONCATENATE 'Etapa 3 con error: ' lv_errorbp7 '-' lv_errorbp8 '-' lv_errorbp9 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_COBRO1
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_COBRO_H                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_P                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_C                  TYPE        YSD_TT_003_CONTABILIZAR
* | [<---] RT_RETURN                      TYPE        YSD_S_003_CONTABILIZAR
* | [<---] RT_DOC                         TYPE        YSD_TT_011_FI_DOC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cobro1.

    TYPES: BEGIN OF gy_doc,
             indice          TYPE char2,
             documento_cobro TYPE char10,
             metodo_pago     TYPE char20,
             moneda          TYPE char5,
             importe(24),
           END OF gy_doc.

    TYPES: BEGIN OF gy_cuenta,
             cuenta TYPE skb1-saknr,
           END OF gy_cuenta.

    TYPES: BEGIN OF gy_usd,
             clase_doc     TYPE char2,
             num_documento TYPE char10,
             moneda        TYPE char5,
             importe(24),
           END OF gy_usd.

    TYPES: BEGIN OF gy_tcurr,
             kurst TYPE tcurr-kurst,
             fcurr TYPE tcurr-fcurr,
             tcurr TYPE tcurr-tcurr,
             ukurs TYPE tcurr-ukurs,
             gdatu TYPE tcurr-gdatu,
           END OF gy_tcurr.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_bsec, "Maestro de clientes (parte general)
             name1 TYPE  bsec-name1, "Número de cliente
             ort01 TYPE  bsec-ort01, "Clientes grupo de condiciones 1
             stcd1 TYPE  bsec-stcd1,
             bukrs TYPE  bsec-bukrs, "SOCIEDAD
             belnr TYPE  bsec-belnr, "DOCUMENTO
             buzei TYPE  bsec-gjahr,
             stras TYPE bsec-stras,
             regio TYPE bsec-regio,
           END OF gy_bsec.

    TYPES: BEGIN OF gy_bseg, "Maestro de clientes (parte general)
             belnr TYPE  bseg-belnr, "DOCUMENTO
             bukrs TYPE  bseg-bukrs, "SOCIEDAD
             buzei TYPE  bseg-gjahr,
             rebzg TYPE  bseg-rebzg,
             rebzj TYPE  bseg-rebzj,
             koart TYPE  bseg-koart,
             bupla TYPE  bseg-bupla,
           END OF gy_bseg.

    TYPES: BEGIN OF gy_skb1,
             saknr TYPE  skb1-saknr,
             bukrs TYPE  skb1-bukrs,
             hbkid TYPE  skb1-hbkid,
           END OF gy_skb1.

    DATA: lv_importechar(24).
    CLEAR lv_importechar.
    DATA: lt_t_ftpost         TYPE TABLE OF ftpost,
          lt_t_ftpost2        TYPE TABLE OF ftpost,
          lt_t_ftclear2       TYPE TABLE OF ftclear,
          lt_t_new_cobro_h    TYPE ysd_tt_003_contabilizar,
          lt_t_new_cobro_p    TYPE ysd_tt_003_contabilizar,
          lt_t_new_cobro_c    TYPE ysd_tt_003_contabilizar,
          lt_t_ftpost3        TYPE TABLE OF ftpost,
          lt_t_ftclear3       TYPE TABLE OF ftclear,
          lt_tcurr            TYPE TABLE OF gy_tcurr,
          lt_kna1             TYPE TABLE OF gy_kna1,
          lt_bsec             TYPE TABLE OF gy_bsec,
          lt_bseg             TYPE TABLE OF gy_bseg,
          lt_skb1             TYPE TABLE OF gy_skb1,
          lt_cuenta           TYPE TABLE OF gy_cuenta,
          lt_caja             TYPE TABLE OF yfi_t002_ctacaja,
          lt_doc              TYPE TABLE OF gy_doc,
          wa_yfi_t004_cobrotm TYPE yfi_t004_cobrotm,
          lt_usd              TYPE TABLE OF gy_usd,
          lv_indice           TYPE char2,
          lv_importe          TYPE char15,
          lv_cliente          TYPE c,
          lv_documento        TYPE belnr_d,
          lv_ejercicio2       TYPE bseg-gjahr,
          lv_bupla(5),
          lv_hbkid(6),
          lv_cuenta           TYPE saknr,
          lv_concat           TYPE bdc_fval,
          lv_concat2          TYPE bdc_fval,
          lv_concat3          TYPE bdc_fval,
          lv_error            TYPE c,
          go_error            TYPE REF TO cx_root,
          lv_message          TYPE string,
          lv_salida           TYPE string,
          lv_errorch          TYPE string,
          lv_errorbpe1        TYPE string,
          lv_errorbpe2        TYPE string,
          lv_errorbpe3        TYPE string,
          lv_errorbp          TYPE string,
          lv_errorbp2         TYPE string,
          lv_errorbp3         TYPE string,
          lv_errorbp4         TYPE string,
          lv_errorbp5         TYPE string,
          lv_errorbp6         TYPE string,
          lv_errorbp7         TYPE string,
          lv_errorbp8         TYPE string,
          lv_errorbp9         TYPE string,
          lv_e_subrc          TYPE sy-subrc,
          lv_e_subrc2         TYPE sy-subrc,
          lv_e_subrc3         TYPE sy-subrc,
          lv_e_subrce         TYPE string,
          lv_e_subrce2        TYPE sstring,
          lv_e_subrce3        TYPE string,
          ls_return           LIKE rt_return.

    DATA: lt_t_fttax   TYPE TABLE OF fttax,
          lt_t_fttax2  TYPE TABLE OF fttax,
          lt_t_fttax3  TYPE TABLE OF fttax,
          lt_t_blntab  TYPE TABLE OF blntab,
          lt_t_blntab2 TYPE TABLE OF blntab,
          lt_t_blntab3 TYPE TABLE OF blntab,
          lt_t_ftclear TYPE TABLE OF ftclear.

    DATA: lv_e_msgid     LIKE  sy-msgid,
          lv_e_msgno     LIKE  sy-msgno,
          lv_e_msgty     LIKE  sy-msgty,
          lv_e_msgv1     LIKE  sy-msgv1,
          lv_documentoe1 TYPE  string,
          lv_documentoe2 TYPE  string,
          lv_e_msgv2     LIKE  sy-msgv2,
          lv_e_msgv3     LIKE  sy-msgv3,
          lv_e_msgv4     LIKE  sy-msgv4.

    DATA: lv_e_msgid2 LIKE  sy-msgid,
          lv_e_msgno2 LIKE  sy-msgno,
          lv_e_msgty2 LIKE  sy-msgty,
          lv_e_msgv12 LIKE  sy-msgv1,
          lv_e_msgv22 LIKE  sy-msgv2,
          lv_e_msgv32 LIKE  sy-msgv3,
          lv_e_msgv42 LIKE  sy-msgv4.

    DATA: lv_e_msgid3 LIKE  sy-msgid,
          lv_e_msgno3 LIKE  sy-msgno,
          lv_e_msgty3 LIKE  sy-msgty,
          lv_e_msgv13 LIKE  sy-msgv1,
          lv_e_msgv23 LIKE  sy-msgv2,
          lv_e_msgv33 LIKE  sy-msgv3,
          lv_e_msgv43 LIKE  sy-msgv4.

    DATA: lv_text   TYPE string,
          lv_text2  TYPE string,
          lv_text3  TYPE string,
          lv_i_mode TYPE rfpdo-allgazmd.

    DATA: v1(10)," TYPE string,
          v2(10),"TYPE string,
          v3(24),"TYPE string,
          a2(24),"TYPE string,
          a3(24),"TYPE string,
          a4(24)," TYPE string,
          lv_ukurs(10)," TYPE string,
          lv_ukurs_aux(10)," TYPE string,
          lv_ukurs1(10),
          lv_ukurs_aux1(10),
          lv_ukursn         TYPE ukurs_curr, " TYPE string,
          lv_importe1(24)," type string,
          lv_importe2       TYPE bseg-wrbtr, "p LENGTH 9 decimals 2,
          lv_importe3       TYPE bseg-wrbtr, "p LENGTH 9 decimals 2,
          lv1               TYPE ukurs_curr, " p LENGTH 9 decimals 2,
          lv2               TYPE ukurs_curr, "p LENGTH 9 decimals 2,
          lv3               TYPE bseg-wrbtr, "p LENGTH 9 decimals 2,
          lv3_2             TYPE bseg-wrbtr,
          la2               TYPE bseg-wrbtr, "p LENGTH 9 decimals 2,
          la3               TYPE bseg-wrbtr, "p LENGTH 9 decimals 2,
          la4               TYPE bseg-wrbtr, "p LENGTH 9 decimals 2.
          la4_2             TYPE bseg-wrbtr,
          lv_sociedad(4),
          lv_ejercicio(4),
          lv_parcial(1).

    FIELD-SYMBOLS: <fs_t_ftpost>      LIKE LINE OF lt_t_ftpost,
                   <fs_t_ftpost2>     LIKE LINE OF lt_t_ftpost2,
                   <fs_t_ftclear2>    LIKE LINE OF lt_t_ftclear2,
                   <fs_t_ftpost3>     LIKE LINE OF lt_t_ftpost3,
                   <fs_t_ftclear3>    LIKE LINE OF lt_t_ftclear3,
                   <fs_i_new_cobro_h> LIKE LINE OF i_new_cobro_h,
                   <fs_i_new_cobro_p> LIKE LINE OF i_new_cobro_p,
                   <fs_i_new_cobro_c> LIKE LINE OF i_new_cobro_c,
                   <fs_doc>           LIKE LINE OF lt_doc,
                   <fs_usd>           LIKE LINE OF lt_usd,
                   <fs_caja>          LIKE LINE OF lt_caja,
                   <fs_tcurr>         LIKE LINE OF lt_tcurr,
                   <fs_kna1>          LIKE LINE OF lt_kna1,
                   <fs_bsec>          LIKE LINE OF lt_bsec,
                   <fs_bseg>          LIKE LINE OF lt_bseg,
                   <fs_skb1>          LIKE LINE OF lt_skb1,
                   <fs_cuenta>        LIKE LINE OF lt_cuenta.

    READ TABLE i_new_cobro_h ASSIGNING <fs_i_new_cobro_h>  INDEX 1.
    IF  i_new_cobro_h IS NOT INITIAL.
      lv_sociedad  = <fs_i_new_cobro_h>-sociedad.
      lv_ejercicio = <fs_i_new_cobro_h>-ejercicio.
    ENDIF.

    LOOP AT i_new_cobro_c ASSIGNING <fs_i_new_cobro_c>.
      APPEND INITIAL LINE TO lt_cuenta ASSIGNING <fs_cuenta>.
      MOVE <fs_i_new_cobro_c>-cuenta_banco TO <fs_cuenta>-cuenta.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_cuenta>-cuenta
        IMPORTING
          output = <fs_cuenta>-cuenta.

    ENDLOOP.

*{REPLACE @100
*    SELECT * INTO TABLE lt_tvarvc
*          FROM tvarvc
*          WHERE name IN ('ZBLART_COBRO',
*                         'ZBLART_COMPENSA',
*                         'ZBLART_MAYOR',
*                         'ZXBLNR_COMPENSA',
*                         'ZAUGTX_COMPENSA',
*                         'ZBKTXT_COMPENSA',
*                         'ZWAERS_BOB',
*                         'ZPRCTR_GL',
*                         'ZNEWBS_40',
*                         'ZNEWBS_50',
*                         'ZSGTXT_ME',
*                         'ZNEWKO_ME',
*                         'ZNEWKO_TARJETA',
*                         'ZSGTXT_MECOMP',
*                         'ZMWSKZ_CLIENTE',
*                         'ZPRCTR_CLIENTE',
*                         'ZNEWBS_50',
*                         'ZNEWBS_15',
*                         'ZSGTXT_CHPOST'  ,
*                         'ZNEWKO_DFING',
*                         'ZNEWKO_DFEGR',
*                         'ZSGTXT_DFCOMP',
*                        'ZSGTXT_CBCJMN' ).

    CALL METHOD ycl_fi_constante_handler=>load_constante
      EXPORTING
        i_aplica = gc_aplica.

*}REPLACE @100

    SELECT kurst fcurr tcurr ukurs gdatu
    FROM tcurr
    INTO TABLE lt_tcurr
    WHERE kurst EQ 'M'
    AND fcurr EQ 'USD'
    AND tcurr EQ 'BOB'.

    SELECT *
      FROM yfi_t002_ctacaja
      INTO TABLE lt_caja
      FOR ALL ENTRIES IN i_new_cobro_h
      WHERE cj_txt EQ i_new_cobro_h-tienda.


    SELECT kunnr kdkg1 xcpdk
     FROM kna1
     INTO TABLE lt_kna1
     FOR ALL ENTRIES IN i_new_cobro_h
     WHERE kunnr EQ i_new_cobro_h-cliente.

    READ TABLE i_new_cobro_p ASSIGNING <fs_i_new_cobro_p> INDEX 1.
    IF sy-subrc EQ 0.
      lv_documento = <fs_i_new_cobro_p>-numero_documento.
      lv_ejercicio2 = <fs_i_new_cobro_p>-ejercicio.
    ENDIF.

    SELECT name1 ort01 stcd1 bukrs belnr gjahr stras regio
      FROM bsec
      INTO TABLE lt_bsec
      FOR ALL ENTRIES IN i_new_cobro_h
      WHERE bukrs EQ i_new_cobro_h-sociedad
      AND belnr EQ lv_documento.

    SELECT belnr bukrs gjahr rebzg rebzj koart bupla
    FROM bseg
    INTO TABLE lt_bseg
    FOR ALL ENTRIES IN i_new_cobro_h
    WHERE bukrs EQ i_new_cobro_h-sociedad
    AND belnr EQ lv_documento
    AND gjahr EQ lv_ejercicio2
    AND koart EQ 'D'.

    SELECT saknr bukrs hbkid
    FROM skb1
    INTO TABLE lt_skb1
    FOR ALL ENTRIES IN lt_cuenta
    WHERE saknr EQ lt_cuenta-cuenta
    AND bukrs EQ lv_sociedad.


********************************************************************************************************************************************
****************************************************** Etapa 1******************************************************************************
********************************************************************************************************************************************
    LOOP AT i_new_cobro_h ASSIGNING <fs_i_new_cobro_h>.
      lv_parcial = <fs_i_new_cobro_h>-parcial.

      LOOP AT i_new_cobro_c ASSIGNING <fs_i_new_cobro_c>.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_i_new_cobro_c>-cuenta_banco
          IMPORTING
            output = lv_cuenta.

        READ TABLE lt_skb1 ASSIGNING <fs_skb1> WITH KEY saknr = lv_cuenta.
        IF sy-subrc EQ 0.
          IF <fs_skb1>-hbkid IS NOT INITIAL.
            CONCATENATE <fs_skb1>-hbkid ',' INTO lv_hbkid.
          ENDIF.

        ENDIF.

        READ TABLE lt_bseg ASSIGNING <fs_bseg> INDEX 1.
        IF sy-subrc EQ 0.
          IF <fs_bseg>-bupla IS NOT INITIAL.
            CONCATENATE <fs_bseg>-bupla ',' INTO lv_bupla.
          ENDIF.

        ENDIF.

        lv_indice = <fs_i_new_cobro_c>-indice.

        READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
        IF sy-subrc EQ 0.
          lv_cliente = <fs_kna1>-xcpdk.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-XBLNR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-numero_referencia.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BKTXT'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-metodo_pago.

        IF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO' OR <fs_i_new_cobro_c>-metodo_pago EQ 'Cheque'.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BSEG-XREF2'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.

        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-WAERS'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-moneda.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-KURSF'.
        IF <fs_i_new_cobro_h>-tipo_cambio EQ 'X'.
          <fs_t_ftpost>-fval = ' '.
        ELSE.
          <fs_t_ftpost>-fval =  <fs_i_new_cobro_h>-tipo_cambio.
        ENDIF.


        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BUDAT'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_contab.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_postfechado.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COBRO'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payhdr
                                                     zvalor = gc_zblart_cobro.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BUKRS'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-sociedad.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam = 'BKPF-BLDAT'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_documento.
*{INSERT @100
        " AÑADIR DIVISIÓN A LA POSICIÓN 001
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'K'.
        <fs_t_ftpost>-count = '001'.
        <fs_t_ftpost>-fnam  = 'COBL-GSBER'.
        <fs_t_ftpost>-fval  = <fs_i_new_cobro_h>-division.
*}INSERT @100
************************************************************POSISCION*****************************************************+

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-VALUT'.
        IF <fs_i_new_cobro_c>-metodo_pago NE 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_contab.
        ELSEIF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-fecha_postfechado.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-WRBTR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-importe_pagar.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-documento_pago.

        CONCATENATE <fs_i_new_cobro_c>-txt_pag ',' lv_hbkid lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
        <fs_t_ftpost>-fval = lv_concat.

        IF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO' OR <fs_i_new_cobro_c>-metodo_pago EQ 'Cheque'.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'BSEG-XREF2'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.

        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
        IF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO' OR <fs_i_new_cobro_c>-metodo_pago EQ 'Cheque'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-cuenta_banco.
        ELSE.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.
        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_paygl
                                                     zvalor = gc_znewbs_40.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100

*{INSERT @100
        " AÑADIR DIVISIÓN A LA POSICIÓN 002
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '002'.
*        <fs_t_ftpost>-fnam  = 'BSEG-GSBER'.
        <fs_t_ftpost>-fnam  = 'COBL-GSBER'.
        <fs_t_ftpost>-fval  = <fs_i_new_cobro_h>-division.


*        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
*        <fs_t_ftpost>-stype = 'P'.
*        <fs_t_ftpost>-count = '002'.
*        <fs_t_ftpost>-fnam = 'BSEG-MWSKZ'.
*        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
*                                                    WITH KEY cgroup = gc_cgroup_payar
*                                                             zvalor = gc_zmwskz_cliente.
*        IF sy-subrc = 0.
*          CONDENSE gwa_constantes-yvalor.
*          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
*        ENDIF.
*}INSERT @100

        IF lv_cliente EQ 'X'.

          READ TABLE lt_bsec ASSIGNING <fs_bsec> INDEX 1.
          IF sy-subrc EQ 0.

            APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '003'.
            <fs_t_ftpost>-fnam = 'BSEC-NAME1'.
            <fs_t_ftpost>-fval = <fs_bsec>-name1.

            APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '003'.
            <fs_t_ftpost>-fnam = 'BSEC-STCD1'.
            <fs_t_ftpost>-fval = <fs_bsec>-stcd1.

            APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '003'.
            <fs_t_ftpost>-fnam = 'BSEC-ORT01'.
            <fs_t_ftpost>-fval = <fs_bsec>-ort01.

            APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '003'.
            <fs_t_ftpost>-fnam = 'BSEC-STRAS'.
            <fs_t_ftpost>-fval = <fs_bsec>-stras.

            APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '003'.
            <fs_t_ftpost>-fnam = 'BSEC-REGIO'.
            <fs_t_ftpost>-fval = <fs_bsec>-regio.

          ENDIF.
        ENDIF.

*{INSERT @100
*/Importe donación
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam  = 'BSEG-WRBTR'.
        IF <fs_i_new_cobro_h>-importe_donacion > 0.
*          DATA(lv_importe_cliente) = <fs_i_new_cobro_h>-importe_pagar - <fs_i_new_cobro_h>-importe_donacion.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-importe_pagar."lv_importe_cliente.
          CONDENSE <fs_t_ftpost>-fval.
        ELSE.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-importe_pagar.
        ENDIF.

*{INSERT @100

****************************************************************************************************************************************

        READ TABLE i_new_cobro_p ASSIGNING <fs_i_new_cobro_p> INDEX 1.
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-REBZG'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_p>-numero_documento.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-REBZJ'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_p>-ejercicio.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-REBZZ'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_p>-item_num.
*{DELETE @100
*        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
*        <fs_t_ftpost>-stype = 'P'.
*        <fs_t_ftpost>-count = '003'.
*        <fs_t_ftpost>-fnam = 'BSEG-BUPLA'.
*        READ TABLE lt_bseg ASSIGNING <fs_bseg> INDEX 1.
*        IF sy-subrc EQ 0.
*          <fs_t_ftpost>-fval = <fs_bseg>-bupla.
*        ENDIF.
*{DELETE @100
****************************************************************************************************************************************

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-documento_pago.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-glosa.

        IF <fs_i_new_cobro_c>-metodo_pago EQ 'CH.POSTFECHADO' OR <fs_i_new_cobro_c>-metodo_pago EQ 'Cheque'.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '003'.
          <fs_t_ftpost>-fnam = 'BSEG-XREF2'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-caja.

        ENDIF.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'BSEG-MWSKZ'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZMWSKZ_CLIENTE'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payar
                                                     zvalor = gc_zmwskz_cliente.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
        <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-cliente.

        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
        <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*        READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_15'.
*        IF sy-subrc = 0.
*          CONDENSE lw_tvarvc-low.
*          <fs_t_ftpost>-fval = lw_tvarvc-low.
*        ENDIF.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                            WITH KEY cgroup = gc_cgroup_payar
                                                     zvalor = gc_znewbs_15.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          <fs_t_ftpost>-fval = gwa_constantes-yvalor.
        ENDIF.
*}REPLACE @100

*{INSERT @100
        " AÑADIR DIVISIÓN A LA POSICIÓN 003
        APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
        <fs_t_ftpost>-stype = 'P'.
        <fs_t_ftpost>-count = '003'.
*        <fs_t_ftpost>-fnam  = 'BSEG-GSBER'.
        <fs_t_ftpost>-fnam  = 'COBL-GSBER'.
        <fs_t_ftpost>-fval  = <fs_i_new_cobro_h>-division.
*}INSERT @100

*{INSERT @100
*/Importe donación
        IF <fs_i_new_cobro_h>-importe_donacion > 0.
          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam  = 'BSEG-WRBTR'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-importe_donacion.
          CONDENSE <fs_t_ftpost>-fval.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam  = 'COBL-GSBER'.
          <fs_t_ftpost>-fval  = <fs_i_new_cobro_h>-division.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
          <fs_t_ftpost>-fval = <fs_i_new_cobro_c>-documento_pago.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
*          <fs_t_ftpost>-fval = <fs_i_new_cobro_h>-glosa.
          CONCATENATE <fs_i_new_cobro_c>-txt_pag ',' lv_hbkid lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
          <fs_t_ftpost>-fval = lv_concat.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
          READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                              WITH KEY cgroup = gc_cgroup_payar
                                                       zvalor = gc_znewbs_50.
          IF sy-subrc = 0.
            CONDENSE gwa_constantes-yvalor.
            <fs_t_ftpost>-fval = gwa_constantes-yvalor.
          ENDIF.

          APPEND INITIAL LINE TO lt_t_ftpost ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '004'.
          <fs_t_ftpost>-fnam  = 'RF05A-NEWKO'.
          <fs_t_ftpost>-fval  = <fs_i_new_cobro_h>-cuenta_donacion.

        ENDIF.

*{INSERT @100


        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_START'
              EXPORTING
                i_client           = sy-mandt
                i_function         = 'C'
*               I_GROUP            = ' '
                i_keep             = 'X'
                i_mode             = 'N'
                i_update           = 'S'
                i_user             = sy-uname
              EXCEPTIONS
                client_incorrect   = 1
                function_invalid   = 2
                group_name_missing = 3
                mode_invalid       = 4
                update_invalid     = 5
                user_invalid       = 6
                OTHERS             = 7.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp '1/CLIENT_INCORRECT' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp '2/FUNCTION_INVALID' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp 'GROUP_NAME_MISSING' INTO lv_errorbp.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp 'MODE_INVALID'       INTO lv_errorbp.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp 'UPDATE_INVALID'     INTO lv_errorbp.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp 'USER_INVALID'       INTO lv_errorbp.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp 'OTHERS'             INTO lv_errorbp.
              ENDIF.
            ENDIF.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
              EXPORTING
                i_auglv                    = 'EINGZAHL'
                i_tcode                    = 'FB05'
                i_sgfunct                  = 'C'
              IMPORTING
                e_msgid                    = lv_e_msgid
                e_msgno                    = lv_e_msgno
                e_msgty                    = lv_e_msgty
                e_msgv1                    = lv_e_msgv1
                e_msgv2                    = lv_e_msgv2
                e_msgv3                    = lv_e_msgv3
                e_msgv4                    = lv_e_msgv4
                e_subrc                    = lv_e_subrc
              TABLES
                t_blntab                   = lt_t_blntab
                t_ftclear                  = lt_t_ftclear
                t_ftpost                   = lt_t_ftpost
                t_fttax                    = lt_t_fttax
              EXCEPTIONS
                clearing_procedure_invalid = 1
                clearing_procedure_missing = 2
                table_t041a_empty          = 3
                transaction_code_invalid   = 4
                amount_format_error        = 5
                too_many_line_items        = 6
                company_code_invalid       = 7
                screen_not_found           = 8
                no_authorization           = 9
                OTHERS                     = 10.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp2 'TABLE_T041A_EMPTY' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp2  'TRANSACTION_CODE_INVALID' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp2 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp2 'TOO_MANY_LINE_ITEMS'   INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp2 'COMPANY_CODE_INVALID'  INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 8.
                CONCATENATE lv_errorbp2 'SCREEN_NOT_FOUND'      INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 9.
                CONCATENATE lv_errorbp2 'NO_AUTHORIZATION'      INTO lv_errorbp2.
              ELSEIF sy-subrc EQ 10.
                CONCATENATE lv_errorbp2 'OTHERS'                INTO lv_errorbp2.
              ENDIF.
            ENDIF.

            IF lv_e_subrc <> 0.

              SELECT SINGLE text
                      FROM t100
                      INTO (lv_text)
                      WHERE sprsl EQ 'S'
                      AND arbgb EQ lv_e_msgid
                      AND msgnr EQ lv_e_msgno.

              CONCATENATE lv_errorbpe1 lv_indice '/' lv_e_msgid '/' lv_e_msgno '/' lv_e_msgty '/' lv_e_msgv1 '/' lv_text '-' INTO lv_errorbpe1 SEPARATED BY ' '.

            ELSE.

              CONCATENATE lv_documentoe1 lv_indice '/' lv_e_msgv1 '-' INTO lv_documentoe1.

              APPEND INITIAL LINE TO lt_doc ASSIGNING <fs_doc>.
              <fs_doc>-indice = lv_indice.
              <fs_doc>-documento_cobro = lv_e_msgv1.
              <fs_doc>-metodo_pago = <fs_i_new_cobro_c>-metodo_pago.
              <fs_doc>-moneda = <fs_i_new_cobro_c>-moneda.
              READ TABLE lt_t_ftpost ASSIGNING <fs_t_ftpost> WITH KEY fnam = 'BSEG-WRBTR'.
              IF sy-subrc EQ 0.
                <fs_doc>-importe = <fs_t_ftpost>-fval.
              ENDIF.
            ENDIF.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_END'
              EXPORTING
                i_bdcimmed              = 'X'
              EXCEPTIONS
                session_not_processable = 1
                OTHERS                  = 2.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp3 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp3.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp3 'OTHERS' INTO lv_errorbp3.
              ENDIF.
            ENDIF.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        CLEAR: lt_t_ftpost, lv_e_msgid, lv_e_msgno, lv_e_msgty, lv_e_msgv1, lv_text, lv_indice, lv_bupla, lv_hbkid, lv_cuenta.

      ENDLOOP.

    ENDLOOP.

    LOOP AT lt_doc ASSIGNING <fs_doc>.
      wa_yfi_t004_cobrotm-indice            = <fs_doc>-indice .
      wa_yfi_t004_cobrotm-documento_cobro   = <fs_doc>-documento_cobro .
      wa_yfi_t004_cobrotm-metodo_pago       = <fs_doc>-metodo_pago .
      wa_yfi_t004_cobrotm-moneda            = <fs_doc>-moneda .
      wa_yfi_t004_cobrotm-importe           = <fs_doc>-importe .
      wa_yfi_t004_cobrotm-sociedad          = lv_sociedad.
      wa_yfi_t004_cobrotm-ejercicio         = lv_ejercicio.
      wa_yfi_t004_cobrotm-usuario           = sy-uname.
      wa_yfi_t004_cobrotm-fecha_creado      = sy-datum.

      INSERT INTO yfi_t004_cobrotm VALUES  wa_yfi_t004_cobrotm.

    ENDLOOP.

    IF lv_error IS NOT INITIAL.
      DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado NE sy-datum.


    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND lv_errorbpe1 IS INITIAL.
********************************************************************************************************************************************
****************************************************** Etapa 2******************************************************************************
********************************************************************************************************************************************¿

      IF lv_parcial IS INITIAL.
        LOOP AT i_new_cobro_p ASSIGNING <fs_i_new_cobro_p> WHERE clase_documento EQ 'DZ' AND  moneda EQ 'USD'.
          APPEND INITIAL LINE TO lt_usd ASSIGNING <fs_usd>.
          <fs_usd>-clase_doc = <fs_i_new_cobro_p>-clase_documento.
          <fs_usd>-num_documento = <fs_i_new_cobro_p>-numero_documento.
          <fs_usd>-moneda = <fs_i_new_cobro_p>-moneda.
          <fs_usd>-importe = <fs_i_new_cobro_p>-importe_mon_doc.
        ENDLOOP.

        LOOP AT i_new_cobro_h ASSIGNING <fs_i_new_cobro_h>.

          READ TABLE lt_bseg ASSIGNING <fs_bseg> INDEX 1.
          IF sy-subrc EQ 0.
            IF <fs_bseg>-bupla IS NOT INITIAL.
              CONCATENATE <fs_bseg>-bupla ',' INTO lv_bupla.
            ENDIF.

          ENDIF.

          READ TABLE lt_tcurr ASSIGNING <fs_tcurr> INDEX 1.
          IF sy-subrc EQ 0.

            IF <fs_i_new_cobro_h>-check IS INITIAL.

              MOVE <fs_tcurr>-ukurs TO lv_ukurs.
              REPLACE ALL OCCURRENCES OF '0' IN lv_ukurs_aux WITH ''.
              CONDENSE lv_ukurs NO-GAPS.

              IF <fs_i_new_cobro_h>-tipo_cambio IS NOT INITIAL.
                MOVE <fs_i_new_cobro_h>-tipo_cambio TO lv_ukurs_aux.
                CONDENSE lv_ukurs_aux NO-GAPS.
                REPLACE ',' IN lv_ukurs_aux WITH '.'.
              ENDIF.

              lv_ukurs1 = lv_ukurs+0(4).
              lv_ukurs_aux1 = lv_ukurs_aux+0(4).


              IF lv_ukurs_aux1 IS INITIAL OR lv_ukurs_aux1 EQ lv_ukurs1.


                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam  = 'BKPF-XBLNR'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zbktxt_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZAUGTX_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  CONCATENATE lw_tvarvc-low ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*                ELSE.
*                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zaugtx_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
                ELSE.
                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
                ENDIF.
*}REPLACE @100

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam  = 'RF05A-AUGTX'.
                <fs_t_ftpost2>-fval =  lv_concat3.
                CLEAR lv_concat3.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BKTXT'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zbktxt_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-WAERS'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZWAERS_BOB'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zwaers_bob.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-KURSF'.
                <fs_t_ftpost2>-fval = ''.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BUDAT'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_contab.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zblart_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BUKRS'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-sociedad."

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BLDAT'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_documento.

*          ***********************************************************POSISCION******************************************************
                LOOP AT i_new_cobro_p ASSIGNING <fs_i_new_cobro_p>.
                  APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                  <fs_t_ftclear2>-agkoa  = 'D'.
                  <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                  <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                  <fs_t_ftclear2>-xnops  = 'X'.
                  <fs_t_ftclear2>-agums  = 'A'.
                  <fs_t_ftclear2>-selfd  = 'BELNR'.
                  <fs_t_ftclear2>-selvon = <fs_i_new_cobro_p>-numero_documento.
*                           <FS_T_ftclear2>-selbis = <FS_I_NEW_COBRO_P>-numero_documento.

                  APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                  <fs_t_ftpost2>-stype = 'P'.
                  <fs_t_ftpost2>-count = '003'.
                  <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                  <fs_t_ftpost2>-fval = <fs_i_new_cobro_p>-numero_documento.

                ENDLOOP.

                LOOP AT lt_doc ASSIGNING <fs_doc>.
                  APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                  <fs_t_ftclear2>-agkoa  = 'D'.
                  <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                  <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                  <fs_t_ftclear2>-xnops  = 'X'.
                  <fs_t_ftclear2>-agums  = 'A'.
                  <fs_t_ftclear2>-selfd  = 'BELNR'.
                  <fs_t_ftclear2>-selvon = <fs_doc>-documento_cobro.
                  <fs_t_ftclear2>-selbis = <fs_doc>-documento_cobro.

                  APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                  <fs_t_ftpost2>-stype = 'P'.
                  <fs_t_ftpost2>-count = '003'.
                  <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                  <fs_t_ftpost2>-fval = <fs_doc>-documento_cobro.

                ENDLOOP.
              ELSEIF <fs_i_new_cobro_h>-tipo_cambio IS NOT INITIAL AND <fs_i_new_cobro_h>-tipo_cambio NE lv_ukurs.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam  = 'BKPF-XBLNR'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZAUGTX_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  CONCATENATE lw_tvarvc-low ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*                ELSE.
*                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zaugtx_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
                ELSE.
                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
                ENDIF.
*}REPLACE @100

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam  = 'RF05A-AUGTX'.
                <fs_t_ftpost2>-fval = lv_concat3.

                CLEAR lv_concat3.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BKTXT'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zbktxt_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-WAERS'.
*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZWAERS_BOB'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zwaers_bob.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-KURSF'.
                <fs_t_ftpost2>-fval = ''.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BUDAT'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_contab.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BLART'.

*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zblart_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BUKRS'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-sociedad."

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam = 'BKPF-BLDAT'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_documento.
*{INSERT @100
                " AÑADIR DIVISIÓN A LA POSICIÓN 001
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'K'.
                <fs_t_ftpost2>-count = '001'.
                <fs_t_ftpost2>-fnam  = 'COBL-GSBER'.
                <fs_t_ftpost2>-fval  = <fs_i_new_cobro_h>-division.
*}INSERT @100
*          ***********************************************************POSISCION******************************************************

                IF <fs_i_new_cobro_h>-tipo_cambio EQ 'X'.

                  LOOP AT lt_usd ASSIGNING <fs_usd> WHERE moneda EQ 'USD' AND clase_doc EQ 'DZ'.
                    CLEAR lv_importe1.
                    WRITE  <fs_usd>-importe TO lv_importe1 LEFT-JUSTIFIED.
                    CONDENSE lv_importe1 NO-GAPS.
                    REPLACE ',' IN lv_importe1 WITH '.'.
                    MOVE lv_importe1 TO lv_importe2.
                    la4 = la4 + lv_importe2.
                  ENDLOOP.

                ELSE.

                  WRITE <fs_i_new_cobro_h>-tipo_cambio TO v1 LEFT-JUSTIFIED.
                  CONDENSE v1 NO-GAPS.
                  REPLACE ',' IN v1 WITH '.'.

                  WRITE <fs_tcurr>-ukurs TO v2 LEFT-JUSTIFIED.
                  CONDENSE v2 NO-GAPS.
                  REPLACE ',' IN v2 WITH '.'.

                  MOVE v1 TO lv1.
                  MOVE v2 TO lv2.

                  LOOP AT lt_doc ASSIGNING <fs_doc> WHERE moneda EQ 'USD'.
                    CLEAR lv_importe1.
                    WRITE  <fs_doc>-importe TO lv_importe1 LEFT-JUSTIFIED.
                    CONDENSE lv_importe1 NO-GAPS.
                    REPLACE ',' IN lv_importe1 WITH '.'.
                    MOVE lv_importe1 TO lv_importe2.
                    lv3 = lv3 + lv_importe2.
                  ENDLOOP.

                  IF lt_usd IS NOT INITIAL.

                    LOOP AT lt_usd ASSIGNING <fs_usd> WHERE moneda EQ 'USD' AND clase_doc EQ 'DZ'.
                      CLEAR lv_importe1.
                      WRITE  <fs_usd>-importe TO lv_importe1 LEFT-JUSTIFIED.
                      CONDENSE lv_importe1 NO-GAPS.
                      REPLACE ',' IN lv_importe1 WITH '.'.
                      MOVE lv_importe1 TO lv_importe3.
                      lv3_2 = lv3_2 + lv_importe3.
                    ENDLOOP.

                  ENDIF.

                  la2 = lv3 * lv1.
                  la3 = lv3 * lv2.
                  la4_2 = la3 - la2.

                  la4 = la4_2 + lv3_2.
                ENDIF.


                a4 = la4.
                REPLACE '.' IN a4 WITH ','.
                REPLACE '-' IN a4 WITH ''.
                CONDENSE a4 NO-GAPS.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '002'.
                <fs_t_ftpost2>-fnam = 'BSEG-WRBTR'.
                <fs_t_ftpost2>-fval = a4.



                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '002'.
                <fs_t_ftpost2>-fnam = 'BSEG-ZUONR'.

*{REPLACE @100
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr
                                                             zvalor = gc_zbktxt_compensa.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZSGTXT_DFCOMP'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  CONCATENATE lw_tvarvc-low ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
*                ELSE.
*                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
*                ENDIF.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_payhdr "Asumido"
                                                             zvalor = gc_zsgtxt_dfcomp. "Nuevo"
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
                ELSE.
                  CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '002'.
                <fs_t_ftpost2>-fnam = 'BSEG-SGTXT'.

                <fs_t_ftpost2>-fval = lv_concat.

                CLEAR lv_concat.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '002'.
                <fs_t_ftpost2>-fnam = 'RF05A-NEWKO'.
*{REPLACE @100
*                IF la4 > 0.
*                  READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWKO_DFING'.
*                  IF sy-subrc = 0.
*                    CONDENSE lw_tvarvc-low.
*                    <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                  ENDIF.
*                ELSE.
*
*                  READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWKO_DFEGR'.
*                  IF sy-subrc = 0.
*                    CONDENSE lw_tvarvc-low.
*                    <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                  ENDIF.
*                ENDIF.
                IF la4 > 0.
                  READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_paygl "Asumido"
                                                             zvalor = gc_znewko_dfing. "Nuevo"
                  IF sy-subrc = 0.
                    CONDENSE gwa_constantes-yvalor.
                    <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                  ENDIF.
                ELSE.
                  READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_paygl "Asumido"
                                                             zvalor = gc_znewko_dfegr. "Nuevo"
                  IF sy-subrc = 0.
                    CONDENSE gwa_constantes-yvalor.
                    <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                  ENDIF.
                ENDIF.
*}REPLACE @100
                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '002'.
                <fs_t_ftpost2>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*                IF la4 > 0.
*                  READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_50'.
*                  IF sy-subrc = 0.
*                    CONDENSE lw_tvarvc-low.
*                    <fs_t_ftpost2>-fval  = lw_tvarvc-low.
*                  ENDIF.
*                ELSE.
*                  READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*                  IF sy-subrc = 0.
*                    CONDENSE lw_tvarvc-low.
*                    <fs_t_ftpost2>-fval  = lw_tvarvc-low.
*                  ENDIF.
*                ENDIF.
                IF la4 > 0.
                  READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_paygl
                                                             zvalor = gc_znewbs_50.
                  IF sy-subrc = 0.
                    CONDENSE gwa_constantes-yvalor.
                    <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                  ENDIF.
                ELSE.
                  READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                    WITH KEY cgroup = gc_cgroup_paygl
                                                             zvalor = gc_znewbs_40.
                  IF sy-subrc = 0.
                    CONDENSE gwa_constantes-yvalor.
                    <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                  ENDIF.
                ENDIF.

*}REPLACE @100
                LOOP AT i_new_cobro_p ASSIGNING <fs_i_new_cobro_p>.
                  APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                  <fs_t_ftclear2>-agkoa  = 'D'.
                  <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                  <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                  <fs_t_ftclear2>-xnops  = 'X'.
                  <fs_t_ftclear2>-agums  = 'A'.
                  <fs_t_ftclear2>-selfd  = 'BELNR'.
                  <fs_t_ftclear2>-selvon = <fs_i_new_cobro_p>-numero_documento.
                  <fs_t_ftclear2>-selbis = <fs_i_new_cobro_p>-numero_documento.

                  APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                  <fs_t_ftpost2>-stype = 'P'.
                  <fs_t_ftpost2>-count = '003'.
                  <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                  <fs_t_ftpost2>-fval = <fs_i_new_cobro_p>-numero_documento.

                ENDLOOP.

                LOOP AT lt_doc ASSIGNING <fs_doc>.
                  APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                  <fs_t_ftclear2>-agkoa  = 'D'.
                  <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                  <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                  <fs_t_ftclear2>-xnops  = 'X'.
                  <fs_t_ftclear2>-agums  = 'A'.
                  <fs_t_ftclear2>-selfd  = 'BELNR'.
                  <fs_t_ftclear2>-selvon = <fs_doc>-documento_cobro.
                  <fs_t_ftclear2>-selbis = <fs_doc>-documento_cobro.

                  APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                  <fs_t_ftpost2>-stype = 'P'.
                  <fs_t_ftpost2>-count = '003'.
                  <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                  <fs_t_ftpost2>-fval = <fs_doc>-documento_cobro.
                ENDLOOP.

              ENDIF.
            ELSEIF <fs_i_new_cobro_h>-check EQ 'X'.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam  = 'BKPF-XBLNR'.
*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZAUGTX_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                CONCATENATE lw_tvarvc-low  ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*              ELSE.
*                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_payhdr
                                                           zvalor = gc_zbktxt_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                WITH KEY cgroup = gc_cgroup_payhdr
                                                         zvalor = gc_zaugtx_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
              ELSE.
                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat3.
              ENDIF.
*}REPLACE @100

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam  = 'RF05A-AUGTX'.
              <fs_t_ftpost2>-fval = lv_concat3.

              CLEAR lv_concat3.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-BKTXT'.
*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                    WITH KEY cgroup = gc_cgroup_payhdr
                                             zvalor = gc_zbktxt_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
*}REPLACE @100


              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-WAERS'.
*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZWAERS_BOB'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_payhdr
                                                           zvalor = gc_zwaers_bob.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
*}REPLACE @100

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-KURSF'.
              <fs_t_ftpost2>-fval = ''.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-BUDAT'.
              <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_contab.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_payhdr
                                                           zvalor = gc_zblart_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
*}REPLACE @100

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-BUKRS'.
              <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-sociedad."

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam = 'BKPF-BLDAT'.
              <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-fecha_documento.

*{INSERT @100
              " AÑADIR DIVISIÓN A LA POSICIÓN 001
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'K'.
              <fs_t_ftpost2>-count = '001'.
              <fs_t_ftpost2>-fnam  = 'COBL-GSBER'.
              <fs_t_ftpost2>-fval  = <fs_i_new_cobro_h>-division.
*}INSERT @100

*          ***********************************************************POSISCION******************************************************

              IF <fs_i_new_cobro_h>-tipo_cambio EQ 'X'.

                LOOP AT lt_usd ASSIGNING <fs_usd> WHERE moneda EQ 'USD' AND clase_doc EQ 'DZ'.
                  CLEAR lv_importe1.
                  WRITE  <fs_usd>-importe TO lv_importe1 LEFT-JUSTIFIED.
                  CONDENSE lv_importe1 NO-GAPS.
                  REPLACE ',' IN lv_importe1 WITH '.'.
                  MOVE lv_importe1 TO lv_importe2.
                  la4 = la4 + lv_importe2.
                ENDLOOP.

              ELSE.

                WRITE <fs_i_new_cobro_h>-tipo_cambio TO v1 LEFT-JUSTIFIED.
                CONDENSE v1 NO-GAPS.
                REPLACE ',' IN v1 WITH '.'.

                WRITE <fs_tcurr>-ukurs TO v2 LEFT-JUSTIFIED.
                CONDENSE v2 NO-GAPS.
                REPLACE ',' IN v2 WITH '.'.

                MOVE v1 TO lv1.
                MOVE v2 TO lv2.

                LOOP AT lt_doc ASSIGNING <fs_doc> WHERE moneda EQ 'USD'.
                  CLEAR lv_importe1.
                  WRITE  <fs_doc>-importe TO lv_importe1 LEFT-JUSTIFIED.
                  CONDENSE lv_importe1 NO-GAPS.
                  REPLACE ',' IN lv_importe1 WITH '.'.
                  MOVE lv_importe1 TO lv_importe2.
                  lv3 = lv3 + lv_importe2.
                ENDLOOP.

                IF lt_usd IS NOT INITIAL.

                  LOOP AT lt_usd ASSIGNING <fs_usd> WHERE moneda EQ 'USD' AND clase_doc EQ 'DZ'.
                    CLEAR lv_importe1.
                    WRITE  <fs_usd>-importe TO lv_importe1 LEFT-JUSTIFIED.
                    CONDENSE lv_importe1 NO-GAPS.
                    REPLACE ',' IN lv_importe1 WITH '.'.
                    MOVE lv_importe1 TO lv_importe3.
                    lv3_2 = lv3_2 + lv_importe3.
                  ENDLOOP.

                ENDIF.

                la2 = lv3 * lv1.
                la3 = lv3 * lv2.
                la4_2 = la3 - la2.

                la4 = la4_2 + lv3_2.
              ENDIF.

              a4 = la4.
              REPLACE '.' IN a4 WITH ','.
              REPLACE '-' IN a4 WITH ''.
              CONDENSE a4 NO-GAPS.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
              <fs_t_ftpost2>-fnam = 'BSEG-WRBTR'.
              <fs_t_ftpost2>-fval = a4.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
              <fs_t_ftpost2>-fnam = 'BSEG-ZUONR'.

*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
*
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZSGTXT_DFCOMP'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                CONCATENATE lw_tvarvc-low ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
*              ELSE.
*                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_payhdr
                                                           zvalor = gc_zbktxt_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                 WITH KEY cgroup = gc_cgroup_payhdr "Asumido"
                                                          zvalor = gc_zsgtxt_dfcomp. "Nuevo"
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
              ELSE.
                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat.
              ENDIF.
*}REPLACE @100
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
              <fs_t_ftpost2>-fnam = 'BSEG-SGTXT'.
              <fs_t_ftpost2>-fval = lv_concat.
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
              <fs_t_ftpost2>-fnam = 'RF05A-NEWKO'.
*{REPLACE @100
*              IF la4 > 0.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWKO_DFING'.
*                IF sy-subrc = 0.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
*              ELSE.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWKO_DFEGR'.
*                IF sy-subrc = 0.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
*              ENDIF.
              IF la4 > 0.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_paygl "Asumido"
                                                           zvalor = gc_znewko_dfing. "Nuevo"
                IF sy-subrc = 0.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
              ELSE.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_paygl "Asumido"
                                                           zvalor = gc_znewko_dfegr. "Nuevo"
                IF sy-subrc = 0.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
              ENDIF.
*}REPLACE @100

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
              <fs_t_ftpost2>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*              IF la4 > 0.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_50'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
*              ELSE.
*                READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*                IF sy-subrc = 0.
*                  CONDENSE lw_tvarvc-low.
*                  <fs_t_ftpost2>-fval = lw_tvarvc-low.
*                ENDIF.
*              ENDIF.
              IF la4 > 0.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_paygl
                                                           zvalor = gc_znewbs_50.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
              ELSE.
                READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_paygl
                                                           zvalor = gc_znewbs_40.
                IF sy-subrc = 0.
                  CONDENSE gwa_constantes-yvalor.
                  <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
                ENDIF.
              ENDIF.
*}REPLACE @100
*{INSERT @100
              " AÑADIR DIVISIÓN A LA POSICIÓN 002
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '002'.
*        <fs_t_ftpost2>-fnam  = 'BSEG-GSBER'.
              <fs_t_ftpost2>-fnam  = 'COBL-GSBER'.
              <fs_t_ftpost2>-fval  =  <fs_i_new_cobro_h>-division.
*}INSERT @100

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
              <fs_t_ftpost2>-fnam = 'BSEG-WRBTR'.
              <fs_t_ftpost2>-fval = <fs_i_new_cobro_h>-cambio_dar.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
              <fs_t_ftpost2>-fnam = 'BSEG-ZUONR'.

*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBKTXT_COMPENSA'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
*
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZSGTXT_CBCJMN'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.             .
*                CONCATENATE lw_tvarvc-low ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat2.
*              ELSE.
*                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat2.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_payhdr
                                                           zvalor = gc_zbktxt_compensa.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                WITH KEY cgroup = gc_cgroup_payhdr "Asumido"
                                                         zvalor = gc_zsgtxt_cbcjmn. "Nuevo"
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                CONCATENATE gwa_constantes-yvalor ',' lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat2.
              ELSE.
                CONCATENATE lv_bupla <fs_i_new_cobro_h>-glosa INTO lv_concat2.
              ENDIF.
*}REPLACE @100
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
              <fs_t_ftpost2>-fnam = 'BSEG-SGTXT'.
              <fs_t_ftpost2>-fval = lv_concat2.
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
              <fs_t_ftpost2>-fnam = 'RF05A-NEWKO'.
              READ TABLE lt_caja ASSIGNING <fs_caja> INDEX 1.
              IF sy-subrc EQ 0.
                <fs_t_ftpost2>-fval = <fs_caja>-cj_mm.
              ENDIF.

              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
              <fs_t_ftpost2>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*              READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_50'.
*              IF sy-subrc = 0.
*                CONDENSE lw_tvarvc-low.
*                <fs_t_ftpost2>-fval = lw_tvarvc-low.
*              ENDIF.
              READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                  WITH KEY cgroup = gc_cgroup_paygl
                                                           zvalor = gc_znewbs_50.
              IF sy-subrc = 0.
                CONDENSE gwa_constantes-yvalor.
                <fs_t_ftpost2>-fval = gwa_constantes-yvalor.
              ENDIF.
*}REPLACE @100
*{INSERT @100
              " AÑADIR DIVISIÓN A LA POSICIÓN 003
              APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
              <fs_t_ftpost2>-stype = 'P'.
              <fs_t_ftpost2>-count = '003'.
*        <fs_t_ftpost2>-fnam  = 'BSEG-GSBER'.
              <fs_t_ftpost2>-fnam  = 'COBL-GSBER'.
              <fs_t_ftpost2>-fval  = <fs_i_new_cobro_h>-division.
*}INSERT @100

              LOOP AT i_new_cobro_p ASSIGNING <fs_i_new_cobro_p>.
                APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                <fs_t_ftclear2>-agkoa  = 'D'.
                <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                <fs_t_ftclear2>-xnops  = 'X'.
                <fs_t_ftclear2>-agums  = 'A'.
                <fs_t_ftclear2>-selfd  = 'BELNR'.
                <fs_t_ftclear2>-selvon = <fs_i_new_cobro_p>-numero_documento.
                <fs_t_ftclear2>-selbis = <fs_i_new_cobro_p>-numero_documento.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '004'.
                <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                <fs_t_ftpost2>-fval = <fs_i_new_cobro_p>-numero_documento.

              ENDLOOP.

              LOOP AT lt_doc ASSIGNING <fs_doc>.
                APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
                <fs_t_ftclear2>-agkoa  = 'D'.
                <fs_t_ftclear2>-agkon  = <fs_i_new_cobro_h>-cliente.
                <fs_t_ftclear2>-agbuk  = <fs_i_new_cobro_h>-sociedad.
                <fs_t_ftclear2>-xnops  = 'X'.
                <fs_t_ftclear2>-agums  = 'A'.
                <fs_t_ftclear2>-selfd  = 'BELNR'.
                <fs_t_ftclear2>-selvon = <fs_doc>-documento_cobro.
                <fs_t_ftclear2>-selbis = <fs_doc>-documento_cobro.

                APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
                <fs_t_ftpost2>-stype = 'P'.
                <fs_t_ftpost2>-count = '004'.
                <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
                <fs_t_ftpost2>-fval = <fs_doc>-documento_cobro.
              ENDLOOP.
            ENDIF.
          ENDIF.

        ENDLOOP.

        lv_i_mode = 'N'.

        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_START'
              EXPORTING
                i_client           = sy-mandt
                i_function         = 'C'
*               I_GROUP            = ' '
                i_keep             = 'X'
                i_mode             = lv_i_mode "'N'
                i_update           = 'S'
                i_user             = sy-uname
              EXCEPTIONS
                client_incorrect   = 1
                function_invalid   = 2
                group_name_missing = 3
                mode_invalid       = 4
                update_invalid     = 5
                user_invalid       = 6
                OTHERS             = 7.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp4 '1/CLIENT_INCORRECT' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp4 '2/FUNCTION_INVALID' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp4 'GROUP_NAME_MISSING' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp4 'MODE_INVALID' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp4 'UPDATE_INVALID' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp4 'USER_INVALID' INTO lv_errorbp4.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp4 'OTHERS' INTO lv_errorbp4.
              ENDIF.
            ENDIF.


          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

        """*  IF lv_parcial IS INITIAL. """SSS_ER

        TRY.
*            BREAK-POINT.

            CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
              EXPORTING
                i_auglv                    = 'UMBUCHNG'
                i_tcode                    = 'FB05'
                i_sgfunct                  = 'C'
              IMPORTING
                e_msgid                    = lv_e_msgid2
                e_msgno                    = lv_e_msgno2
                e_msgty                    = lv_e_msgty2
                e_msgv1                    = lv_e_msgv12
                e_msgv2                    = lv_e_msgv22
                e_msgv3                    = lv_e_msgv32
                e_msgv4                    = lv_e_msgv42
                e_subrc                    = lv_e_subrc2
              TABLES
                t_blntab                   = lt_t_blntab2
                t_ftpost                   = lt_t_ftpost2
                t_ftclear                  = lt_t_ftclear2
                t_fttax                    = lt_t_fttax2
              EXCEPTIONS
                clearing_procedure_invalid = 1
                clearing_procedure_missing = 2
                table_t041a_empty          = 3
                transaction_code_invalid   = 4
                amount_format_error        = 5
                too_many_line_items        = 6
                company_code_invalid       = 7
                screen_not_found           = 8
                no_authorization           = 9
                OTHERS                     = 10.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp5 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp5 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 3.
                CONCATENATE lv_errorbp5  'TABLE_T041A_EMPTY' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 4.
                CONCATENATE lv_errorbp5  'TRANSACTION_CODE_INVALID' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 5.
                CONCATENATE lv_errorbp5 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 6.
                CONCATENATE lv_errorbp5 'TOO_MANY_LINE_ITEMS' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 7.
                CONCATENATE lv_errorbp5 'COMPANY_CODE_INVALID' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 8.
                CONCATENATE lv_errorbp5 'SCREEN_NOT_FOUND' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 9.
                CONCATENATE lv_errorbp5 'NO_AUTHORIZATION' INTO lv_errorbp5.
              ELSEIF sy-subrc EQ 10.
                CONCATENATE lv_errorbp5 'OTHERS' INTO lv_errorbp.
              ENDIF.
            ENDIF.

            IF lv_e_subrc2 <> 0.

              SELECT SINGLE text
                      FROM t100
                      INTO (lv_text2)
                      WHERE sprsl EQ 'S'
                      AND arbgb EQ lv_e_msgid2
                      AND msgnr EQ lv_e_msgno2.

              CONCATENATE lv_errorbpe2 lv_e_msgid2 '/' lv_e_msgno2 '/' lv_e_msgty2 '/' lv_e_msgv12 '/' lv_text2 '-' INTO lv_errorbpe2 SEPARATED BY ' '.
            ELSE.

              CONCATENATE lv_documentoe2 lv_e_msgv12 '-' INTO lv_documentoe2.

            ENDIF.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.



        TRY.

            CALL FUNCTION 'POSTING_INTERFACE_END'
              EXPORTING
                i_bdcimmed              = 'X'
              EXCEPTIONS
                session_not_processable = 1
                OTHERS                  = 2.
            IF sy-subrc <> 0.
              IF sy-subrc EQ 1.
                CONCATENATE lv_errorbp6 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp6.
              ELSEIF sy-subrc EQ 2.
                CONCATENATE lv_errorbp6 'OTHERS' INTO lv_errorbp6.
              ENDIF.
            ENDIF.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

          CATCH cx_sy_zerodivide INTO go_error.

            lv_errorch = go_error->get_text( ).

            lv_error = 'X'.

        ENDTRY.

      ENDIF.
      IF lv_errorbp IS NOT INITIAL OR lv_errorbp2 IS NOT INITIAL OR lv_errorbp3 IS NOT INITIAL OR lv_errorbpe1 IS NOT INITIAL  OR lv_error = 'X'.
        DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado NE sy-datum.
      ENDIF.
    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND
       lv_errorbp4 IS INITIAL AND lv_errorbp5 IS INITIAL AND lv_errorbp6 IS INITIAL AND
       lv_errorbp7 IS INITIAL AND lv_errorbp8 IS INITIAL AND lv_errorbp9 IS INITIAL.

      IF lv_errorbpe1 IS INITIAL AND lv_errorbpe2 IS INITIAL AND lv_errorbpe3 IS INITIAL.

        lv_e_subrce = lv_e_subrc.
        lv_e_subrce2 = lv_e_subrc2.
        lv_e_subrce3 = lv_e_subrc3.

*ajm 24.03.2022      CONCATENATE lv_e_subrcE '/' lv_E_MSGV1 '-' lv_e_subrcE2 '/' lv_documentoE2 INTO lv_salida.
        CONCATENATE 'COBROS: ' lv_e_msgv1 'COMPENSACION: ' lv_documentoe2   INTO lv_salida SEPARATED BY space. "aJM
        CONCATENATE 'Se proceso exitosamente la etapa 1 y 2: ' lv_salida INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '200'.
        rt_return-datac = lv_documentoe1.
        rt_return-datap = lv_documentoe2.

        rt_doc = lt_doc.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.


        IF lv_errorbpe1 IS NOT INITIAL.
          DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado NE sy-datum.

          CONCATENATE 'Etapa 1 con error : ' lv_errorbpe1 '-' INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.

        ELSEIF lv_errorbpe2 IS NOT INITIAL.

          CONCATENATE 'Etapa 2 con error: ' lv_errorbpe2 '-' INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.
          rt_return-datac = lv_documentoe1.

        ELSEIF lv_errorbpe3 IS NOT INITIAL.

          CONCATENATE 'Etapa 3 con error: ' lv_errorbpe3 '-' INTO lv_message.
          CONCATENATE 'Documentos de la Etapa 1: ' lv_documentoe1 'Documento de la Etapa 2: ' lv_documentoe2 INTO lv_salida.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.
          rt_return-datac = lv_salida.

        ENDIF.

      ENDIF.

    ELSE.

      IF lv_errorbp IS NOT INITIAL OR lv_errorbp2 IS NOT INITIAL OR lv_errorbp3 IS NOT INITIAL.
        DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado NE sy-datum.
        CONCATENATE 'Etapa 1 con error : ' lv_errorbp '-' lv_errorbp2 '-' lv_errorbp3 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp4 IS NOT INITIAL OR lv_errorbp5 IS NOT INITIAL OR lv_errorbp6 IS NOT INITIAL.
        DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado NE sy-datum.
        CONCATENATE 'Etapa 2 con error: ' lv_errorbp4 '-' lv_errorbp5 '-' lv_errorbp6 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp7 IS NOT INITIAL OR lv_errorbp8 IS NOT INITIAL OR lv_errorbp9 IS NOT INITIAL.

        CONCATENATE 'Etapa 3 con error: ' lv_errorbp7 '-' lv_errorbp8 '-' lv_errorbp9 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_COBRO_AUTOMATICO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INVOICE_BELNR               TYPE        BELNR_D
* | [--->] IV_INVOICE_BUKRS               TYPE        BUKRS
* | [--->] IV_INVOICE_GJAHR               TYPE        GJAHR
* | [--->] IV_METODO_PAGO                 TYPE        YFI_T001_METPAGO-MET_PAG
* | [<---] ES_RETURN                      TYPE        YSD_S_003_CONTABILIZAR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cobro_automatico.
    DATA lt_t_ftpost TYPE TABLE OF ftpost.

    TYPES: BEGIN OF gy_doc,
             indice          TYPE char2,
             documento_cobro TYPE char10,
             metodo_pago     TYPE char20,
             moneda          TYPE char5,
             importe         TYPE c LENGTH 24,
           END OF gy_doc.

    DATA lt_doc              TYPE TABLE OF gy_doc.
    DATA wa_yfi_t004_cobrotm TYPE yfi_t004_cobrotm.

    DATA lv_indice           TYPE char2.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_bupla            TYPE c LENGTH 5.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_hbkid            TYPE c LENGTH 6.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_cuenta           TYPE saknr.
    DATA lv_error            TYPE c LENGTH 1.
    DATA lv_errorbpe1        TYPE string.
    DATA lv_errorbp          TYPE string.
    DATA lv_errorbp2         TYPE string.
    DATA lv_errorbp3         TYPE string.
    DATA lv_e_subrc          TYPE sy-subrc.

    DATA lt_t_fttax          TYPE TABLE OF fttax.
    DATA lt_t_blntab         TYPE TABLE OF blntab.
    DATA lt_t_ftclear        TYPE TABLE OF ftclear.

    DATA lv_e_msgid          LIKE sy-msgid.
    DATA lv_e_msgno          LIKE sy-msgno.
    DATA lv_e_msgty          LIKE sy-msgty.
    DATA lv_e_msgv1          LIKE sy-msgv1.
    DATA lv_documentoe1      TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_e_msgv2          LIKE sy-msgv2.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_e_msgv3          LIKE sy-msgv3.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_e_msgv4          LIKE sy-msgv4.

    DATA lv_text             TYPE string.

    FIELD-SYMBOLS <fs_doc> LIKE LINE OF lt_doc.

    ycl_fi_constante_handler=>load_constante( gc_aplica ).

    SELECT SINGLE bseg~kunnr,
                  bkpf~budat,
                  bkpf~bldat,
                  bseg~gsber,
                  bseg~dmbe2,
                  bseg~xref2
      FROM bseg
             INNER JOIN
               bkpf ON bkpf~bukrs = bseg~bukrs AND bkpf~belnr = bseg~belnr AND bkpf~gjahr = bseg~gjahr
      WHERE bseg~bukrs = @iv_invoice_bukrs
        AND bkpf~awkey = @iv_invoice_belnr
        AND bseg~gjahr = @iv_invoice_bdate(4)
        AND bseg~bschl = '01' " Clave de contabilización de cliente, como indica el doc
      INTO @DATA(ls_factura).

    IF sy-subrc <> 0.
      es_return-messcode = '400'.
      es_return-message  = |No se encontraron detalles para la factura { iv_invoice_belnr }|.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM yfi_t005_ctapasa
      WHERE gsber = @ls_factura-gsber AND pas_pag = @is_metodo_pago-pas_pag
      INTO @DATA(ls_cuentas_pasarela).

    "
    " / ETAPA 1.- Proceso de Contabilización del Cobro
    "

    "
    " / 1.- ARMAR CABECERA (stype = 'K')
    "

    " / BKPF-XBLNR: Número de Referencia
    "   Toma un valor FIJO desde la tabla de constantes (ej. 'COMP.FACTURAS').
    READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
         WITH KEY cgroup = gc_cgroup_paypas
                  zvalor = 'ZXBLNR'.
    IF sy-subrc = 0.
      CONDENSE gwa_constantes-yvalor.
      APPEND VALUE #( stype = 'K'
                      count = '001'
                      fnam  = 'BKPF-XBLNR'
                      fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
    ENDIF.

    " / BKPF-BKTXT: Texto de Cabecera
    "   Toma el nombre del método de pago que se está utilizando (ej. 'Pago QR').
    APPEND VALUE #( stype = 'K'
                    count = '001'
                    fnam  = 'BKPF-BKTXT'
                    fval  = is_metodo_pago-met_pag ) TO lt_t_ftpost.

    " / BKPF-WAERS: Moneda
    "   Toma un valor FIJO ('BOB') desde la tabla de constantes.

    READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
         WITH KEY cgroup = gc_cgroup_paypas
                  zvalor = 'ZWAERS'.
    IF sy-subrc = 0.
      CONDENSE gwa_constantes-yvalor.
      APPEND VALUE #( stype = 'K'
                      count = '001'
                      fnam  = 'BKPF-WAERS'
                      fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
    ENDIF.
    " / BKPF-KURSF: Tipo de Cambio
    "   Se deja explícitamente en blanco, según la especificación.
    APPEND VALUE #( stype = 'K'
                    count = '001'
                    fnam  = 'BKPF-KURSF'
                    fval  = '' ) TO lt_t_ftpost.

    " / BKPF-BUDAT: Fecha de Contabilización
    "   Hereda la fecha de contabilización de la factura original.
    APPEND VALUE #( stype = 'K'
                    count = '001'
                    fnam  = 'BKPF-BUDAT'
                    fval  = ls_factura-budat ) TO lt_t_ftpost.

    " / BKPF-BLART: Clase de Documento
    "   Toma un valor FIJO (ej. 'DZ') desde la tabla de constantes.
    READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
         WITH KEY cgroup = gc_cgroup_payhdr
                  zvalor = gc_zblart_cobro.
    IF sy-subrc = 0.
      APPEND VALUE #( stype = 'K'
                      count = '001'
                      fnam  = 'BKPF-BLART'
                      fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
    ENDIF.

    " / BKPF-BUKRS: Sociedad
    "   Hereda la sociedad de la factura original.
    APPEND VALUE #( stype = 'K'
                    count = '001'
                    fnam  = 'BKPF-BUKRS'
                    fval  = iv_invoice_bukrs ) TO lt_t_ftpost.

    " / BKPF-BLDAT: Fecha de Documento
    "   Hereda la fecha de documento de la factura original.
    APPEND VALUE #( stype = 'K'
                    count = '001'
                    fnam  = 'BKPF-BLDAT'
                    fval  = ls_factura-bldat ) TO lt_t_ftpost.

    CASE is_metodo_pago-pas_pag.
      WHEN 1 OR 3. " QR o Tigo Money (mapeo estándar de 2 posiciones)
        "----------------------------------------------------------------
        " Posición 002 (Débito a Cuenta de Pasarela)
        "----------------------------------------------------------------
        " / BSEG-VALUT: Fecha Valor
        "   Toma la fecha de contabilización de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-VALUT'
                        fval  = ls_factura-budat ) TO lt_t_ftpost.
        " / BSEG-WRBTR: Importe
        "   Toma el importe total de la factura.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-WRBTR'
                        fval  = ls_factura-dmbe2 ) TO lt_t_ftpost.
        " / BSEG-ZUONR: Asignación
        "   Toma el valor del campo 'Clave de referencia 2' (XREF2/ZREF2) de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-ZUONR'
                        fval  = ls_factura-xref2 ) TO lt_t_ftpost.
        " / BSEG-SGTXT: Texto de Posición
        "   Toma el texto descriptivo del método de pago desde la tabla de configuración YFI_T001_METPAGO.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-SGTXT'
                        fval  = iS_metodo_pago-txt_pag ) TO lt_t_ftpost.
        " / COBL-GSBER: División
        "   Toma la división de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'COBL-GSBER'
                        fval  = ls_factura-gsber ) TO lt_t_ftpost.
        " / RF05A-NEWKO: Cuenta a Contabilizar
        "   Toma la cuenta de mayor configurada en la tabla YFI_T005_CTAPASA para la combinación de División y Método de Pago.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'RF05A-NEWKO'
                        fval  = ls_cuentas_pasarela-znewko ) TO lt_t_ftpost.
        " / RF05A-NEWBS: Clave de Contabilización
        "   Toma el valor del parámetro ZNEWBS_40 (Débito) de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_paygl
                      zvalor = gc_znewbs_40.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
        ENDIF.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'RF05A-NEWBS'
                        fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.

        "----------------------------------------------------------------
        " Posición 003 (Crédito al Cliente)
        "----------------------------------------------------------------
        " / BSEG-VALUT: Fecha Valor
        "   Toma la fecha de contabilización de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'BSEG-VALUT'
                        fval  = ls_factura-budat ) TO lt_t_ftpost.
        " / COBL-GSBER: División
        "   Toma la división de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'COBL-GSBER'
                        fval  = ls_factura-gsber ) TO lt_t_ftpost.
        " / BSEG-WRBTR: Importe
        "   Toma el importe total de la factura.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'BSEG-WRBTR'
                        fval  = ls_factura-dmbe2 ) TO lt_t_ftpost.
        " / BSEG-ZUONR: Asignación
        "   Toma el valor del campo 'Clave de referencia 2' (XREF2/ZREF2) de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'BSEG-ZUONR'
                        fval  = ls_factura-xref2 ) TO lt_t_ftpost.
        " / BSEG-SGTXT: Texto de Posición
        "   Toma el valor del parámetro ZSGTXT (ej. "Cobro por pasarela") de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_paypas
                      zvalor = gc_zsgtxt.
        IF sy-subrc = 0.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'BSEG-SGTXT'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        " / BSEG-MWSKZ: Indicador de Impuestos
        "   Toma el valor del parámetro ZMWSKZ_CLIENTE de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_zmwskz_cliente.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'BSEG-MWSKZ'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.

        " / RF05A-NEWKO: Cuenta a Contabilizar
        "   Toma el número del cliente de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'RF05A-NEWKO'
                        fval  = ls_factura-kunnr ) TO lt_t_ftpost.
        " / RF05A-NEWBS: Clave de Contabilización
        "   Toma el valor del parámetro ZNEWBS_15 (Crédito a cliente) de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_znewbs_15.
        IF sy-subrc = 0.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'RF05A-NEWBS'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.

      WHEN 2. " CASO: Tarjeta POS (mapeo especial de 3 posiciones con comisión)
        " Se calcula el importe de la comisión y el valor neto a pagar.
        DATA(lv_comision) = ls_factura-dmbe2.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_paypas
                      zvalor = gc_zporc_tarjpos.
        IF sy-subrc = 0.
          lv_comision = lv_comision * gwa_constantes-yvalor.
        ENDIF.
        DATA(lv_neto) = ls_factura-dmbe2 - lv_comision.

        "----------------------------------------------------------------
        " Posición 002 (Débito a Cuenta de Pasarela por el valor NETO)
        "----------------------------------------------------------------
        "*/ BSEG-WRBTR: Importe
        "   Toma el valor NETO calculado (Importe Total - Comisión).
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-WRBTR'
                        fval  = lv_neto ) TO lt_t_ftpost.
        " / RF05A-NEWKO: Cuenta a Contabilizar
        "   Toma la cuenta de mayor configurada en YFI_T005_CTAPASA.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'RF05A-NEWKO'
                        fval  = ls_cuentas_pasarela-znewko ) TO lt_t_ftpost.
        " (El resto de los campos de la Posición 002 se llenan igual que en el caso QR/Tigo Money)
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-ZUONR'
                        fval  = ls_factura-xref2 ) TO lt_t_ftpost.
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'BSEG-SGTXT'
                        fval  = is_metodo_pago-txt_pag ) TO lt_t_ftpost.
        " /
        APPEND VALUE #( stype = 'P'
                        count = '002'
                        fnam  = 'COBL-GSBER'
                        fval  = ls_factura-gsber ) TO lt_t_ftpost.
        " /
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_paygl
                      zvalor = gc_znewbs_40.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          APPEND VALUE #( stype = 'P'
                          count = '002'
                          fnam  = 'RF05A-NEWBS'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        "----------------------------------------------------------------
        " Posición 003 (Crédito al Cliente por el valor TOTAL)
        "----------------------------------------------------------------
        "*/ BSEG-WRBTR: Importe
        "   Toma el importe TOTAL de la factura.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'BSEG-WRBTR'
                        fval  = ls_factura-dmbe2 ) TO lt_t_ftpost.
        " / RF05A-NEWKO: Cuenta a Contabilizar
        "   Toma el número del cliente de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'RF05A-NEWKO'
                        fval  = ls_factura-kunnr ) TO lt_t_ftpost.
        " /
        " (El resto de los campos de la Posición 003 se llenan igual que en el caso QR/Tigo Money)
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'BSEG-ZUONR'
                        fval  = ls_factura-xref2 ) TO lt_t_ftpost.
        " /
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_paypas
                      zvalor = gc_zsgtxt.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'BSEG-SGTXT'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        " /
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_zmwskz_cliente.
        IF sy-subrc = 0.
          CONDENSE gwa_constantes-yvalor.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'BSEG-MWSKZ'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        " /
        APPEND VALUE #( stype = 'P'
                        count = '003'
                        fnam  = 'COBL-GSBER'
                        fval  = ls_factura-gsber ) TO lt_t_ftpost.
        " /
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_znewbs_15.
        IF sy-subrc = 0.
          APPEND VALUE #( stype = 'P'
                          count = '003'
                          fnam  = 'RF05A-NEWBS'
                          fval  = gwa_constantes-yvalor  ) TO lt_t_ftpost.
        ENDIF.
        "----------------------------------------------------------------
        " Posición 004 (Débito a Proveedor POS por la COMISIÓN)
        "----------------------------------------------------------------
        " / BSEG-WRBTR: Importe
        "   Toma el valor de la COMISIÓN calculado.
        APPEND VALUE #( stype = 'P'
                        count = '004'
                        fnam  = 'BSEG-WRBTR'
                        fval  = lv_comision ) TO lt_t_ftpost.
        " / RF05A-NEWKO: Cuenta a Contabilizar
        "   Toma el valor del parámetro ZLIFNR_POS (código del Acreedor/Proveedor del servicio POS) de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_zlifnr_pos.
        IF sy-subrc = 0.
          APPEND VALUE #( stype = 'P'
                          count = '004'
                          fnam  = 'RF05A-NEWKO'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        " / RF05A-NEWBS: Clave de Contabilización
        "   Toma el valor del parámetro ZNEWBS_21 (Débito a Acreedor) de la tabla de constantes.
        READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
             WITH KEY cgroup = gc_cgroup_payar
                      zvalor = gc_znewbs_21.
        IF sy-subrc = 0.
          APPEND VALUE #( stype = 'P'
                          count = '004'
                          fnam  = 'RF05A-NEWBS'
                          fval  = gwa_constantes-yvalor ) TO lt_t_ftpost.
        ENDIF.
        " / BSEG-ZUONR: Asignación
        "   Toma el valor del campo 'Clave de referencia 2' (XREF2/ZREF2) de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '004'
                        fnam  = 'BSEG-ZUONR'
                        fval  = ls_factura-xref2 ) TO lt_t_ftpost.
        " / BSEG-SGTXT: Texto de Posición
        "   Se asigna un texto fijo para identificar la comisión.
        APPEND VALUE #( stype = 'P'
                        count = '004'
                        fnam  = 'BSEG-SGTXT'
                        fval  = 'Comisión Tarjeta POS' ) TO lt_t_ftpost.
        " / COBL-GSBER: División
        "   Toma la división de la factura original.
        APPEND VALUE #( stype = 'P'
                        count = '004'
                        fnam  = 'COBL-GSBER'
                        fval  = ls_factura-gsber ) TO lt_t_ftpost.
    ENDCASE.

    "---------------------

    CALL FUNCTION 'POSTING_INTERFACE_START'
      EXPORTING  i_client           = sy-mandt
                 i_function         = 'C'
*                 I_GROUP            = ' '
                 i_keep             = 'X'
                 i_mode             = 'N'
                 i_update           = 'S'
                 i_user             = sy-uname
      EXCEPTIONS client_incorrect   = 1
                 function_invalid   = 2
                 group_name_missing = 3
                 mode_invalid       = 4
                 update_invalid     = 5
                 user_invalid       = 6
                 OTHERS             = 7.
    IF sy-subrc <> 0.
      IF sy-subrc = 1.
        CONCATENATE lv_errorbp '1/CLIENT_INCORRECT' INTO lv_errorbp.
      ELSEIF sy-subrc = 2.
        CONCATENATE lv_errorbp '2/FUNCTION_INVALID' INTO lv_errorbp.
      ELSEIF sy-subrc = 3.
        CONCATENATE lv_errorbp 'GROUP_NAME_MISSING' INTO lv_errorbp.
      ELSEIF sy-subrc = 4.
        CONCATENATE lv_errorbp 'MODE_INVALID'       INTO lv_errorbp.
      ELSEIF sy-subrc = 5.
        CONCATENATE lv_errorbp 'UPDATE_INVALID'     INTO lv_errorbp.
      ELSEIF sy-subrc = 6.
        CONCATENATE lv_errorbp 'USER_INVALID'       INTO lv_errorbp.
      ELSEIF sy-subrc = 7.
        CONCATENATE lv_errorbp 'OTHERS'             INTO lv_errorbp.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING  i_auglv                    = 'EINGZAHL'
                 i_tcode                    = 'FB05'
                 i_sgfunct                  = 'C'
      IMPORTING  e_msgid                    = lv_e_msgid
                 e_msgno                    = lv_e_msgno
                 e_msgty                    = lv_e_msgty
                 e_msgv1                    = lv_e_msgv1
                 e_msgv2                    = lv_e_msgv2
                 e_msgv3                    = lv_e_msgv3
                 e_msgv4                    = lv_e_msgv4
                 e_subrc                    = lv_e_subrc
      TABLES     t_blntab                   = lt_t_blntab
                 t_ftclear                  = lt_t_ftclear
                 t_ftpost                   = lt_t_ftpost
                 t_fttax                    = lt_t_fttax
      EXCEPTIONS clearing_procedure_invalid = 1
                 clearing_procedure_missing = 2
                 table_t041a_empty          = 3
                 transaction_code_invalid   = 4
                 amount_format_error        = 5
                 too_many_line_items        = 6
                 company_code_invalid       = 7
                 screen_not_found           = 8
                 no_authorization           = 9
                 OTHERS                     = 10.
    IF sy-subrc <> 0.
      IF sy-subrc = 1.
        CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp2.
      ELSEIF sy-subrc = 2.
        CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp2.
      ELSEIF sy-subrc = 3.
        CONCATENATE lv_errorbp2 'TABLE_T041A_EMPTY' INTO lv_errorbp2.
      ELSEIF sy-subrc = 4.
        CONCATENATE lv_errorbp2 'TRANSACTION_CODE_INVALID' INTO lv_errorbp2.
      ELSEIF sy-subrc = 5.
        CONCATENATE lv_errorbp2 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp2.
      ELSEIF sy-subrc = 6.
        CONCATENATE lv_errorbp2 'TOO_MANY_LINE_ITEMS'  INTO lv_errorbp2.
      ELSEIF sy-subrc = 7.
        CONCATENATE lv_errorbp2 'COMPANY_CODE_INVALID' INTO lv_errorbp2.
      ELSEIF sy-subrc = 8.
        CONCATENATE lv_errorbp2 'SCREEN_NOT_FOUND'     INTO lv_errorbp2.
      ELSEIF sy-subrc = 9.
        CONCATENATE lv_errorbp2 'NO_AUTHORIZATION'     INTO lv_errorbp2.
      ELSEIF sy-subrc = 10.
        CONCATENATE lv_errorbp2 'OTHERS'               INTO lv_errorbp2.
      ENDIF.
    ENDIF.

    IF lv_e_subrc <> 0.

      SELECT SINGLE text FROM t100
        INTO ( lv_text )
        WHERE sprsl = 'S'
          AND arbgb = lv_e_msgid
          AND msgnr = lv_e_msgno.

      CONCATENATE lv_errorbpe1 lv_indice '/' lv_e_msgid '/' lv_e_msgno '/' lv_e_msgty '/' lv_e_msgv1 '/' lv_text '-' INTO lv_errorbpe1 SEPARATED BY ' '.

    ELSE.

      CONCATENATE lv_documentoe1 lv_indice '/' lv_e_msgv1 '-' INTO lv_documentoe1.

      APPEND INITIAL LINE TO lt_doc ASSIGNING <fs_doc>.
      <fs_doc>-indice          = lv_indice.
      <fs_doc>-documento_cobro = lv_e_msgv1.
      <fs_doc>-metodo_pago     = is_metodo_pago-met_pag.
      <fs_doc>-moneda          = 'BOB'.
      <fs_doc>-importe         = ls_factura-dmbe2.

    ENDIF.

    CALL FUNCTION 'POSTING_INTERFACE_END'
      EXPORTING  i_bdcimmed              = 'X'
      EXCEPTIONS session_not_processable = 1
                 OTHERS                  = 2.
    IF sy-subrc <> 0.
      IF sy-subrc = 1.
        CONCATENATE lv_errorbp3 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp3.
      ELSEIF sy-subrc = 2.
        CONCATENATE lv_errorbp3 'OTHERS' INTO lv_errorbp3.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING wait = 'X'.

    CLEAR: lt_t_ftpost,
           lv_e_msgid,
           lv_e_msgno,
           lv_e_msgty,
           lv_e_msgv1,
           lv_text,
           lv_indice,
           lv_bupla,
           lv_hbkid,
           lv_cuenta.

    LOOP AT lt_doc ASSIGNING <fs_doc>.
      wa_yfi_t004_cobrotm-indice          = <fs_doc>-indice.
      wa_yfi_t004_cobrotm-documento_cobro = <fs_doc>-documento_cobro.
      wa_yfi_t004_cobrotm-metodo_pago     = <fs_doc>-metodo_pago.
      wa_yfi_t004_cobrotm-moneda          = <fs_doc>-moneda.
      wa_yfi_t004_cobrotm-importe         = <fs_doc>-importe.
      wa_yfi_t004_cobrotm-sociedad        = 'FCRE'.
      wa_yfi_t004_cobrotm-ejercicio       = iv_invoice_bdate(4).
      wa_yfi_t004_cobrotm-usuario         = sy-uname.
      wa_yfi_t004_cobrotm-fecha_creado    = sy-datum.

      INSERT INTO yfi_t004_cobrotm VALUES wa_yfi_t004_cobrotm.

    ENDLOOP.

    IF lv_error IS NOT INITIAL.
      DELETE FROM yfi_t004_cobrotm WHERE usuario = sy-uname AND fecha_creado <> sy-datum.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_CONTABILIZAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_COBROE3_H                TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBROE3_P                TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBROE3_C                TYPE        YSD_TT_003_CONTABILIZAR
* | [<---] RT_RETURN                      TYPE        YSD_S_003_CONTABILIZAR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_contabilizar.

    TYPES: BEGIN OF gy_bseg, "Maestro de clientes (parte general)
             belnr TYPE  bseg-belnr, "DOCUMENTO
             bukrs TYPE  bseg-bukrs, "SOCIEDAD
             buzei TYPE  bseg-gjahr,
             rebzg TYPE  bseg-rebzg,
             rebzj TYPE  bseg-rebzj,
             koart TYPE  bseg-koart,
             bupla TYPE  bseg-bupla,
           END OF gy_bseg.

    TYPES: BEGIN OF gy_skb1,
             saknr TYPE  skb1-saknr,
             bukrs TYPE  skb1-bukrs,
             hbkid TYPE  skb1-hbkid,
           END OF gy_skb1.

    TYPES: BEGIN OF gy_cuenta,
             cuenta TYPE skb1-saknr,
           END OF gy_cuenta.

    DATA: lt_t_ftpost2  TYPE TABLE OF ftpost,
          lt_t_ftclear2 TYPE TABLE OF ftclear,
          lt_bseg       TYPE TABLE OF gy_bseg,
          lt_skb1       TYPE TABLE OF gy_skb1,
          lt_cuenta     TYPE TABLE OF gy_cuenta,
          lv_bupla(5),
          lv_hbkid(6),
          lv_cuenta     TYPE saknr,
          lv_concat     TYPE bdc_fval,
          lv_sociedad   TYPE bukrs,
          lv_error      TYPE c,
          go_error      TYPE REF TO cx_root,
          lv_errorch    TYPE string,
          lv_errorbp    TYPE string,
          lv_errorbp2   TYPE string,
          lv_errorbp4   TYPE string,
          lv_errorbp5   TYPE string,
          lv_errorbp6   TYPE string,
          lv_errorbp3   TYPE string.

    DATA: lv_e_msgid   LIKE  sy-msgid,
          lv_e_msgno   LIKE  sy-msgno,
          lv_e_msgty   LIKE  sy-msgty,
          lv_e_msgv1   LIKE  sy-msgv1,
          lv_doc       TYPE belnr_d,
          lv_importe   TYPE char23,
          lv_docf      TYPE string,
          lv_documento LIKE  sy-msgv1,
          lv_e_msgv2   LIKE  sy-msgv2,
          lv_e_msgv3   LIKE  sy-msgv3,
          lv_e_msgv4   LIKE  sy-msgv4,
          lv_e_subrc   TYPE sy-subrc,
          lv_text      TYPE string,
          lt_t_fttax2  TYPE TABLE OF fttax,
          lt_t_blntab2 TYPE TABLE OF blntab,
          lv_errorbpe3 TYPE string,
          lv_e_subrce  TYPE string,
          lv_salida    TYPE string,
          lv_message   TYPE string.


    FIELD-SYMBOLS: <fs_t_ftpost>        LIKE LINE OF lt_t_ftpost2,
                   <fs_t_ftpost2>       LIKE LINE OF lt_t_ftpost2,
                   <fs_t_ftclear2>      LIKE LINE OF lt_t_ftclear2,
                   <fs_i_new_cobroe3_h> LIKE LINE OF i_new_cobroe3_h,
                   <fs_i_new_cobroe3_p> LIKE LINE OF i_new_cobroe3_p,
                   <fs_i_new_cobroe3_c> LIKE LINE OF i_new_cobroe3_c,
                   <fs_bseg>            LIKE LINE OF lt_bseg,
                   <fs_skb1>            LIKE LINE OF lt_skb1,
                   <fs_cuenta>          LIKE LINE OF lt_cuenta.

    READ TABLE i_new_cobroe3_h ASSIGNING <fs_i_new_cobroe3_h>  INDEX 1.
    IF  i_new_cobroe3_h IS NOT INITIAL.
      lv_sociedad  = <fs_i_new_cobroe3_h>-sociedad.
    ENDIF.

    LOOP AT i_new_cobroe3_c ASSIGNING <fs_i_new_cobroe3_c>.
      APPEND INITIAL LINE TO lt_cuenta ASSIGNING <fs_cuenta>.
      MOVE <fs_i_new_cobroe3_c>-cuenta_banco TO <fs_cuenta>-cuenta.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_cuenta>-cuenta
        IMPORTING
          output = <fs_cuenta>-cuenta.
    ENDLOOP.

    READ TABLE i_new_cobroe3_p ASSIGNING <fs_i_new_cobroe3_p> INDEX 1.
    IF sy-subrc EQ 0.
      lv_documento = <fs_i_new_cobroe3_p>-numero_documento.
    ENDIF.

*{REPLACE @100
*    SELECT * INTO TABLE lt_tvarvc
*           FROM tvarvc
*           WHERE name IN ('ZBLART_COBRO',
*                          'ZBLART_COMPENSA',
*                          'ZBLART_MAYOR',
*                          'ZXBLNR_COMPENSA',
*                          'ZAUGTX_COMPENSA',
*                          'ZBKTXT_COMPENSA',
*                          'ZWAERS_BOB',
*                          'ZPRCTR_GL',
*                          'ZNEWBS_40',
*                          'ZNEWBS_50',
*                          'ZSGTXT_ME',
*                          'ZNEWKO_ME',
*                          'ZNEWKO_TARJETA',
*                          'ZSGTXT_MECOMP',
*                          'ZMWSKZ_CLIENTE',
*                          'ZPRCTR_CLIENTE',
*                          'ZNEWBS_50',
*                          'ZNEWBS_15',
*                          'ZSGTXT_CHPOST'  ,
*                          'ZNEWKO_DFING',
*                          'ZNEWKO_DFEGR',
*                          'ZSGTXT_DFCOMP',
*                         'ZSGTXT_CBCJMN' ).

    CALL METHOD ycl_fi_constante_handler=>load_constante
      EXPORTING
        i_aplica = gc_aplica.

*}REPLACE @100

    SELECT belnr bukrs gjahr rebzg rebzj koart bupla
    FROM bseg
    INTO TABLE lt_bseg
    FOR ALL ENTRIES IN i_new_cobroe3_h
    WHERE bukrs EQ i_new_cobroe3_h-sociedad
    AND belnr EQ lv_documento
    AND gjahr EQ i_new_cobroe3_h-ejercicio
    AND koart EQ 'D'.

    SELECT saknr bukrs hbkid
    FROM skb1
    INTO TABLE lt_skb1
    FOR ALL ENTRIES IN lt_cuenta
    WHERE saknr EQ lt_cuenta-cuenta
    AND bukrs EQ lv_sociedad.



    LOOP AT i_new_cobroe3_h ASSIGNING <fs_i_new_cobroe3_h>.
      LOOP AT i_new_cobroe3_c ASSIGNING <fs_i_new_cobroe3_c>.

        IF <fs_i_new_cobroe3_c>-metodo_pago EQ 'Transferencia' OR <fs_i_new_cobroe3_c>-metodo_pago EQ 'Deposito'. "or <FS_I_NEW_COBROE3_C>-metodo_pago eq 'Cheque'.
          IF <fs_i_new_cobroe3_c>-cuenta_banco IS NOT INITIAL.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <fs_i_new_cobroe3_c>-cuenta_banco
              IMPORTING
                output = lv_cuenta.

            READ TABLE lt_skb1 ASSIGNING <fs_skb1> WITH KEY saknr = lv_cuenta.
            IF sy-subrc EQ 0.
              IF <fs_skb1>-hbkid IS NOT INITIAL.
                CONCATENATE <fs_skb1>-hbkid ',' INTO lv_hbkid.
              ENDIF.

            ENDIF.

            READ TABLE lt_bseg ASSIGNING <fs_bseg> INDEX 1.
            IF sy-subrc EQ 0.
              IF <fs_bseg>-bupla IS NOT INITIAL.
                CONCATENATE <fs_bseg>-bupla ',' INTO lv_bupla.
              ENDIF.

            ENDIF.

            APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
            <fs_t_ftclear2>-agkoa  = 'S'.             "Deudor
            <fs_t_ftclear2>-agkon  = <fs_i_new_cobroe3_c>-caja.
            <fs_t_ftclear2>-agbuk  = <fs_i_new_cobroe3_h>-sociedad.
            <fs_t_ftclear2>-xnops  = 'X'.
            <fs_t_ftclear2>-agums  = ' '.
            <fs_t_ftclear2>-selfd  = 'BELNR'.
            <fs_t_ftclear2>-selvon = <fs_i_new_cobroe3_c>-documento_cobro.


*            *********************************************************** CABECERA*****************************++

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-BUKRS'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-sociedad.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-BLDAT'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-fecha_documento.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-BUDAT'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-fecha_contab.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-WAERS'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-moneda.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-KURSF'.
            <fs_t_ftpost>-fval =  <fs_i_new_cobroe3_c>-tipo_cambio.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*            READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_MAYOR'.
*            IF sy-subrc = 0.
*              CONDENSE lw_tvarvc-low.
*              <fs_t_ftpost>-fval = lw_tvarvc-low.
*            ENDIF.
            READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                WITH KEY cgroup = gc_cgroup_payhdr
                                                         zvalor = gc_zblart_mayor.
            IF sy-subrc = 0.
              CONDENSE gwa_constantes-yvalor.
              <fs_t_ftpost>-fval = gwa_constantes-yvalor.
            ENDIF.
*}REPLACE @100
            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-BKTXT'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-metodo_pago.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'BKPF-XBLNR'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-numero_referencia.

            CONCATENATE <fs_i_new_cobroe3_c>-txt_pag ',' lv_hbkid lv_bupla <fs_i_new_cobroe3_h>-glosa INTO lv_concat.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'K'.
            <fs_t_ftpost>-count = '001'.
            <fs_t_ftpost>-fnam = 'RF05A-AUGTX'.
            <fs_t_ftpost>-fval = lv_concat.

*            ***********************************************************POSISCION************************
            CLEAR lv_importe.
            lv_importe = <fs_i_new_cobroe3_c>-importe_pagar.
            CONDENSE lv_importe NO-GAPS.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*            READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*            IF sy-subrc = 0.
*              CONDENSE lw_tvarvc-low.
*              <fs_t_ftpost>-fval = lw_tvarvc-low.
*            ENDIF.
            READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                                WITH KEY cgroup = gc_cgroup_paygl
                                                         zvalor = gc_znewbs_40.
            IF sy-subrc = 0.
              CONDENSE gwa_constantes-yvalor.
              <fs_t_ftpost>-fval = gwa_constantes-yvalor.
            ENDIF.
*}REPLACE @100
            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-cuenta_banco.

            CONCATENATE <fs_i_new_cobroe3_c>-txt_pag ',' lv_hbkid lv_bupla <fs_i_new_cobroe3_h>-glosa INTO lv_concat.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
            <fs_t_ftpost>-fval = lv_concat.
*                    <FS_I_NEW_COBROE3_C>-txt_pag.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'BSEG-VALUT'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-fecha_documento.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'BSEG-WRBTR'.
            <fs_t_ftpost>-fval = lv_importe.

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
            <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-documento_pago.

*{INSERT @100
            " AÑADIR DIVISIÓN A LA POSICIÓN 001
            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
            <fs_t_ftpost>-stype = 'P'.
            <fs_t_ftpost>-count = '002'.
            <fs_t_ftpost>-fnam  = 'COBL-GSBER'.
            <fs_t_ftpost>-fval  = <fs_i_new_cobroe3_h>-division.
*}INSERT @100

            APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
            <fs_t_ftpost2>-stype = 'P'.
            <fs_t_ftpost2>-count = '003'.
            <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
            <fs_t_ftpost2>-fval = <fs_i_new_cobroe3_c>-documento_cobro.

            TRY.

                CALL FUNCTION 'POSTING_INTERFACE_START'
                  EXPORTING
                    i_client           = sy-mandt
                    i_function         = 'C'
*                   I_GROUP            = ' '
                    i_keep             = 'X'
                    i_mode             = 'N'
                    i_update           = 'S'
                    i_user             = sy-uname
                  EXCEPTIONS
                    client_incorrect   = 1
                    function_invalid   = 2
                    group_name_missing = 3
                    mode_invalid       = 4
                    update_invalid     = 5
                    user_invalid       = 6
                    OTHERS             = 7.

                IF sy-subrc <> 0.
                  IF sy-subrc EQ 1.
                    CONCATENATE lv_errorbp '1/CLIENT_INCORRECT' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 2.
                    CONCATENATE lv_errorbp '2/FUNCTION_INVALID' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 3.
                    CONCATENATE lv_errorbp 'GROUP_NAME_MISSING' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 4.
                    CONCATENATE lv_errorbp 'MODE_INVALID' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 5.
                    CONCATENATE lv_errorbp 'UPDATE_INVALID' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 6.
                    CONCATENATE lv_errorbp 'USER_INVALID' INTO lv_errorbp.
                  ELSEIF sy-subrc EQ 7.
                    CONCATENATE lv_errorbp 'OTHERS' INTO lv_errorbp.
                  ENDIF.
                ENDIF.

              CATCH cx_sy_zerodivide INTO go_error.

                lv_errorch = go_error->get_text( ).

                lv_error = 'X'.

            ENDTRY.

            TRY.

                CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
                  EXPORTING
                    i_auglv                    = 'UMBUCHNG'
                    i_tcode                    = 'FB05'
                    i_sgfunct                  = 'C'
                  IMPORTING
                    e_msgid                    = lv_e_msgid
                    e_msgno                    = lv_e_msgno
                    e_msgty                    = lv_e_msgty
                    e_msgv1                    = lv_e_msgv1
                    e_msgv2                    = lv_e_msgv2
                    e_msgv3                    = lv_e_msgv3
                    e_msgv4                    = lv_e_msgv4
                    e_subrc                    = lv_e_subrc
                  TABLES
                    t_blntab                   = lt_t_blntab2
                    t_ftpost                   = lt_t_ftpost2
                    t_ftclear                  = lt_t_ftclear2
                    t_fttax                    = lt_t_fttax2
                  EXCEPTIONS
                    clearing_procedure_invalid = 1
                    clearing_procedure_missing = 2
                    table_t041a_empty          = 3
                    transaction_code_invalid   = 4
                    amount_format_error        = 5
                    too_many_line_items        = 6
                    company_code_invalid       = 7
                    screen_not_found           = 8
                    no_authorization           = 9
                    OTHERS                     = 10.
                IF sy-subrc <> 0.
                  IF sy-subrc EQ 1.
                    CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 2.
                    CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 3.
                    CONCATENATE lv_errorbp2 'TABLE_T041A_EMPTY' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 4.
                    CONCATENATE lv_errorbp2  'TRANSACTION_CODE_INVALID' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 5.
                    CONCATENATE lv_errorbp2 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 6.
                    CONCATENATE lv_errorbp2 'TOO_MANY_LINE_ITEMS' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 7.
                    CONCATENATE lv_errorbp2 'COMPANY_CODE_INVALID' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 8.
                    CONCATENATE lv_errorbp2 'SCREEN_NOT_FOUND' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 9.
                    CONCATENATE lv_errorbp2 'NO_AUTHORIZATION' INTO lv_errorbp2.
                  ELSEIF sy-subrc EQ 10.
                    CONCATENATE lv_errorbp2 'OTHERS' INTO lv_errorbp2.
                  ENDIF.
                ENDIF.

                IF lv_e_subrc <> 0.

                  SELECT SINGLE text
                  FROM t100
                  INTO (lv_text)
                  WHERE sprsl EQ 'S'
                  AND arbgb EQ lv_e_msgid
                  AND msgnr EQ lv_e_msgno.

                  CONCATENATE lv_errorbpe3 <fs_i_new_cobroe3_c>-indice '(' lv_e_msgid '/' lv_e_msgno '/' lv_e_msgty '/' lv_e_msgv1 '/' lv_text ')' '-' INTO lv_errorbpe3 SEPARATED BY ' '.
                ELSE.
                  CONCATENATE lv_docf <fs_i_new_cobroe3_c>-indice '/' lv_e_msgv1 '-' INTO lv_docf.
                ENDIF.

              CATCH cx_sy_zerodivide INTO go_error.

                lv_errorch = go_error->get_text( ).

                lv_error = 'X'.

            ENDTRY.

            TRY.
                CALL FUNCTION 'POSTING_INTERFACE_END'
                  EXPORTING
                    i_bdcimmed              = 'X'
                  EXCEPTIONS
                    session_not_processable = 1
                    OTHERS                  = 2.
                IF sy-subrc <> 0.
                  IF sy-subrc EQ 1.
                    CONCATENATE lv_errorbp3 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp3.
                  ELSEIF sy-subrc EQ 2.
                    CONCATENATE lv_errorbp3 'OTHERS' INTO lv_errorbp3.
                  ENDIF.
                ENDIF.

              CATCH cx_sy_zerodivide INTO go_error.

                lv_errorch = go_error->get_text( ).

                lv_error = 'X'.

            ENDTRY.


          ENDIF.
        ELSEIF <fs_i_new_cobroe3_c>-metodo_pago EQ 'Tarjeta Crédito (POS)' OR <fs_i_new_cobroe3_c>-metodo_pago EQ 'Tarjeta Débito (POS)'.

          READ TABLE lt_bseg ASSIGNING <fs_bseg> INDEX 1.
          IF sy-subrc EQ 0.
            IF <fs_bseg>-bupla IS NOT INITIAL.
              CONCATENATE <fs_bseg>-bupla ',' INTO lv_bupla.
            ENDIF.

          ENDIF.

          APPEND INITIAL LINE TO lt_t_ftclear2 ASSIGNING <fs_t_ftclear2>.
          <fs_t_ftclear2>-agkoa  = 'S'.             "Deudor
          <fs_t_ftclear2>-agkon  = <fs_i_new_cobroe3_c>-caja.
          <fs_t_ftclear2>-agbuk  = <fs_i_new_cobroe3_h>-sociedad.
          <fs_t_ftclear2>-xnops  = 'X'.
          <fs_t_ftclear2>-agums  = ' '.
          <fs_t_ftclear2>-selfd  = 'BELNR'.
          <fs_t_ftclear2>-selvon = <fs_i_new_cobroe3_c>-documento_cobro.


*            *********************************************************** CABECERA*****************************++

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-BUKRS'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-sociedad.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-BLDAT'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-fecha_documento.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-BUDAT'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_h>-fecha_contab.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-WAERS'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-moneda.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-KURSF'.
          <fs_t_ftpost>-fval =  <fs_i_new_cobroe3_c>-tipo_cambio.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-BLART'.
*{REPLACE @100
*          READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZBLART_MAYOR'.
*          IF sy-subrc = 0.
*            CONDENSE lw_tvarvc-low.
*            <fs_t_ftpost>-fval = lw_tvarvc-low.
*          ENDIF.
          READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                              WITH KEY cgroup = gc_cgroup_payhdr
                                                       zvalor = gc_zblart_mayor.
          IF sy-subrc = 0.
            CONDENSE gwa_constantes-yvalor.
            <fs_t_ftpost>-fval = gwa_constantes-yvalor.
          ENDIF.
*}REPLACE @100
          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-BKTXT'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-metodo_pago.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'BKPF-XBLNR'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-numero_referencia.

          CONCATENATE <fs_i_new_cobroe3_c>-txt_pag ',' lv_bupla <fs_i_new_cobroe3_h>-glosa INTO lv_concat.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'K'.
          <fs_t_ftpost>-count = '001'.
          <fs_t_ftpost>-fnam = 'RF05A-AUGTX'.
          <fs_t_ftpost>-fval = lv_concat.


*            ***********************************************************POSISCION************************
          CLEAR lv_importe.
          lv_importe = <fs_i_new_cobroe3_c>-importe_pagar.
          CONDENSE lv_importe NO-GAPS.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'RF05A-NEWBS'.
*{REPLACE @100
*          READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWBS_40'.
*          IF sy-subrc = 0.
*            CONDENSE lw_tvarvc-low.
*            <fs_t_ftpost>-fval = lw_tvarvc-low.
*          ENDIF.
          READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                             WITH KEY cgroup = gc_cgroup_paygl
                                                      zvalor = gc_znewbs_40.
          IF sy-subrc = 0.
            CONDENSE gwa_constantes-yvalor.
            <fs_t_ftpost>-fval = gwa_constantes-yvalor.
          ENDIF.
*}REPLACE @100

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'RF05A-NEWKO'.
*{REPLACE @100
*          READ TABLE lt_tvarvc INTO lw_tvarvc WITH  KEY name = 'ZNEWKO_TARJETA'.
*          IF sy-subrc = 0.
*            CONDENSE lw_tvarvc-low.
*            <fs_t_ftpost>-fval = lw_tvarvc-low.
*          ENDIF.
          READ TABLE ycl_fi_constante_handler=>t_constante INTO gwa_constantes
                                             WITH KEY cgroup = gc_cgroup_paygl
                                                      zvalor = gc_znewko_tarjeta.
          IF sy-subrc = 0.
            CONDENSE gwa_constantes-yvalor.
            <fs_t_ftpost>-fval = gwa_constantes-yvalor.
          ENDIF.
*}REPLACE @100
          CONCATENATE <fs_i_new_cobroe3_c>-txt_pag ',' lv_bupla <fs_i_new_cobroe3_h>-glosa INTO lv_concat.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'BSEG-SGTXT'.
          <fs_t_ftpost>-fval = lv_concat.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'BSEG-WRBTR'.
          <fs_t_ftpost>-fval = lv_importe.

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost>-stype = 'P'.
          <fs_t_ftpost>-count = '002'.
          <fs_t_ftpost>-fnam = 'BSEG-ZUONR'.
          <fs_t_ftpost>-fval = <fs_i_new_cobroe3_c>-documento_pago.

*{INSERT @100
          " AÑADIR DIVISIÓN A LA POSICIÓN 001
          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost>.
          <fs_t_ftpost2>-stype = 'P'.
          <fs_t_ftpost2>-count = '002'.
          <fs_t_ftpost2>-fnam  = 'COBL-GSBER'.
          <fs_t_ftpost2>-fval  = <fs_i_new_cobroe3_h>-division.
*}INSERT @100

          APPEND INITIAL LINE TO lt_t_ftpost2 ASSIGNING <fs_t_ftpost2>.
          <fs_t_ftpost2>-stype = 'P'.
          <fs_t_ftpost2>-count = '003'.
          <fs_t_ftpost2>-fnam = 'RF05A-SEL01'.
          <fs_t_ftpost2>-fval = <fs_i_new_cobroe3_c>-documento_cobro.

          TRY.

              CALL FUNCTION 'POSTING_INTERFACE_START'
                EXPORTING
                  i_client           = sy-mandt
                  i_function         = 'C'
*                 I_GROUP            = ' '
                  i_keep             = 'X'
                  i_mode             = 'N'
                  i_update           = 'S'
                  i_user             = sy-uname
                EXCEPTIONS
                  client_incorrect   = 1
                  function_invalid   = 2
                  group_name_missing = 3
                  mode_invalid       = 4
                  update_invalid     = 5
                  user_invalid       = 6
                  OTHERS             = 7.

              IF sy-subrc <> 0.
                IF sy-subrc EQ 1.
                  CONCATENATE lv_errorbp '1/CLIENT_INCORRECT' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 2.
                  CONCATENATE lv_errorbp '2/FUNCTION_INVALID' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 3.
                  CONCATENATE lv_errorbp 'GROUP_NAME_MISSING' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 4.
                  CONCATENATE lv_errorbp 'MODE_INVALID' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 5.
                  CONCATENATE lv_errorbp 'UPDATE_INVALID' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 6.
                  CONCATENATE lv_errorbp 'USER_INVALID' INTO lv_errorbp.
                ELSEIF sy-subrc EQ 7.
                  CONCATENATE lv_errorbp 'OTHERS' INTO lv_errorbp.
                ENDIF.
              ENDIF.

            CATCH cx_sy_zerodivide INTO go_error.

              lv_errorch = go_error->get_text( ).

              lv_error = 'X'.

          ENDTRY.


          TRY.


              CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
                EXPORTING
                  i_auglv                    = 'UMBUCHNG'
                  i_tcode                    = 'FB05'
                  i_sgfunct                  = 'C'
                IMPORTING
                  e_msgid                    = lv_e_msgid
                  e_msgno                    = lv_e_msgno
                  e_msgty                    = lv_e_msgty
                  e_msgv1                    = lv_e_msgv1
                  e_msgv2                    = lv_e_msgv2
                  e_msgv3                    = lv_e_msgv3
                  e_msgv4                    = lv_e_msgv4
                  e_subrc                    = lv_e_subrc
                TABLES
                  t_blntab                   = lt_t_blntab2
                  t_ftpost                   = lt_t_ftpost2
                  t_ftclear                  = lt_t_ftclear2
                  t_fttax                    = lt_t_fttax2
                EXCEPTIONS
                  clearing_procedure_invalid = 1
                  clearing_procedure_missing = 2
                  table_t041a_empty          = 3
                  transaction_code_invalid   = 4
                  amount_format_error        = 5
                  too_many_line_items        = 6
                  company_code_invalid       = 7
                  screen_not_found           = 8
                  no_authorization           = 9
                  OTHERS                     = 10.
              IF sy-subrc <> 0.
                IF sy-subrc EQ 1.
                  CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_INVALID' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 2.
                  CONCATENATE lv_errorbp2 'CLEARING_PROCEDURE_MISSING' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 3.
                  CONCATENATE lv_errorbp2 'TABLE_T041A_EMPTY' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 4.
                  CONCATENATE lv_errorbp2  'TRANSACTION_CODE_INVALID' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 5.
                  CONCATENATE lv_errorbp2 'AMOUNT_FORMAT_ERROR' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 6.
                  CONCATENATE lv_errorbp2 'TOO_MANY_LINE_ITEMS' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 7.
                  CONCATENATE lv_errorbp2 'COMPANY_CODE_INVALID' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 8.
                  CONCATENATE lv_errorbp2 'SCREEN_NOT_FOUND' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 9.
                  CONCATENATE lv_errorbp2 'NO_AUTHORIZATION' INTO lv_errorbp2.
                ELSEIF sy-subrc EQ 10.
                  CONCATENATE lv_errorbp2 'OTHERS' INTO lv_errorbp2.
                ENDIF.
              ENDIF.

              IF lv_e_subrc <> 0.

                SELECT SINGLE text
                FROM t100
                INTO (lv_text)
                WHERE sprsl EQ 'S'
                AND arbgb EQ lv_e_msgid
                AND msgnr EQ lv_e_msgno.

                CONCATENATE lv_errorbpe3 <fs_i_new_cobroe3_c>-indice '(' lv_e_msgid '/' lv_e_msgno '/' lv_e_msgty '/' lv_e_msgv1 '/' lv_text ')' '-' INTO lv_errorbpe3 SEPARATED BY ' '.
              ELSE.
                CONCATENATE lv_docf <fs_i_new_cobroe3_c>-indice '/' lv_e_msgv1 '-' INTO lv_docf.
              ENDIF.

            CATCH cx_sy_zerodivide INTO go_error.

              lv_errorch = go_error->get_text( ).

              lv_error = 'X'.

          ENDTRY.

          TRY.
              CALL FUNCTION 'POSTING_INTERFACE_END'
                EXPORTING
                  i_bdcimmed              = 'X'
                EXCEPTIONS
                  session_not_processable = 1
                  OTHERS                  = 2.
              IF sy-subrc <> 0.
                IF sy-subrc EQ 1.
                  CONCATENATE lv_errorbp3 'SESSION_NOT_PROCESSABLE' INTO lv_errorbp3.
                ELSEIF sy-subrc EQ 2.
                  CONCATENATE lv_errorbp3 'OTHERS' INTO lv_errorbp3.
                ENDIF.
              ENDIF.

            CATCH cx_sy_zerodivide INTO go_error.

              lv_errorch = go_error->get_text( ).

              lv_error = 'X'.

          ENDTRY.


          """ ER

        ENDIF.

        CLEAR: lt_t_ftpost2, lt_t_ftclear2, lv_hbkid, lv_bupla, lv_cuenta.

      ENDLOOP.
    ENDLOOP.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL.

      IF lv_errorbpe3 IS INITIAL.

        lv_e_subrce = lv_e_subrc.

        CONCATENATE  'Documento Traspaso: ' lv_docf INTO lv_salida SEPARATED BY space.
        CONCATENATE 'Se proceso exitosamente la etapa 3: ' lv_salida INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '200'.
        rt_return-datac = lv_docf.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        IF lv_errorbpe3 IS NOT INITIAL.

          CONCATENATE 'Etapa 3 con error: ' lv_errorbpe3 '-' INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.
          rt_return-datac = lv_doc.

        ENDIF.

      ENDIF.

    ELSE.

      IF lv_errorbp IS NOT INITIAL OR lv_errorbp2 IS NOT INITIAL OR lv_errorbp3 IS NOT INITIAL.

        CONCATENATE 'Etapa 1 con error : ' lv_errorbp '-' lv_errorbp2 '-' lv_errorbp3 '-' INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '401'.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_COTIZACION_H             TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_COTIZACION_P             TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cotizacion.
    " TODO: parameter RT_RETURN is never cleared or assigned (ABAP cleaner)

    TYPES: BEGIN OF gy_pa0001, " Registro maestro de personal Infotipo 0001 (Asignac.organ.)
             uname TYPE pa0001-uname, " USUARIO
             pernr TYPE pa0001-pernr, " CODIGO DE SOLICITANTE
             bukrs TYPE pa0001-bukrs, " SOCIEDAD
             btrtl TYPE pa0001-btrtl, " Subdivisión de personal
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_knvv, " Maestro de clientes datos comerciales
             kunnr TYPE knvv-kunnr, " NUMERO DE CLIENTE
             kdgrp TYPE knvv-kdgrp, " Grupo de clientes
             bzirk TYPE knvv-bzirk, " Zona de ventas
             pltyp TYPE knvv-pltyp, " Tipo de lista de precios
             konda TYPE knvv-konda, " Grupo de precio de cliente
             waers TYPE knvv-waers, " Moneda
             spart TYPE knvv-spart, " SECTOR
           END OF gy_knvv.

    TYPES: BEGIN OF gy_tvau_auart_vko,
             auart TYPE tvau_auart_vko-auart, " Clase de documento de ventas
             augru TYPE tvau_auart_vko-augru, " Motivo de pedido (motivo de la operación)
           END OF gy_tvau_auart_vko.

    TYPES: BEGIN OF gy_kna1, " Maestro de clientes (parte general)
             kunnr TYPE kna1-kunnr, " Número de cliente
             kdkg1 TYPE kna1-kdkg1, " Clientes grupo de condiciones 1
             xcpdk TYPE kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_zparametros, " Condiciones de variantes/TABLAS DE PARAMETROS
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, " Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi,
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_tvak, " Documentos ventas: Clases
             auart TYPE tvak-auart, " Clase de documento de ventas
             vbtyp TYPE tvak-vbtyp, " Tipo de documento comercial
           END OF gy_tvak.

*    TYPES: BEGIN OF gy_a931, " Org.Ventas/Can.distr./Zona vta./Ofic.vta./Gr.client./ListaPr
*             bzirk TYPE a931-bzirk, " ZONA DE VENTA
*             matnr TYPE a931-matnr, " MATERIAL
*             vtweg TYPE a931-vtweg, " canal de distribucion
*             kschl TYPE a931-kschl, " clase de condicion
*           END OF gy_a931.

    DATA lt_pa0001           TYPE TABLE OF gy_pa0001.
    DATA lt_knvv             TYPE TABLE OF gy_knvv.
    DATA lt_tvau_auart_vko   TYPE TABLE OF gy_tvau_auart_vko.
    DATA lt_kna1             TYPE TABLE OF gy_kna1.
    DATA lt_kna12            TYPE TABLE OF gy_kna1.
    DATA lt_tvak             TYPE TABLE OF gy_tvak.
    DATA lt_zparametros      TYPE TABLE OF gy_zparametros.
*    DATA lt_a931             TYPE TABLE OF gy_a931.
    DATA lv_cliente          TYPE c LENGTH 1.
    DATA lv_destina          TYPE c LENGTH 1.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_text_line        TYPE tdline.

    DATA lt_partneraddresses TYPE TABLE OF bapiaddr1. "{Add 16.05.2022 - No llega la dirección completa}
    FIELD-SYMBOLS <fs_partneraddresses> LIKE LINE OF lt_partneraddresses. "{Add 16.05.2022 - No llega la dirección completa}

    DATA ls_quotation_header_in      TYPE bapisdhd1.
    DATA lt_quotation_items_in       TYPE TABLE OF bapisditm.
    DATA lt_quotation_partners       TYPE TABLE OF bapiparnr.
    DATA lt_quotation_conditions_in  TYPE TABLE OF bapicond.
    DATA lt_quotation_schedules_in   TYPE TABLE OF bapischdl.
    DATA lt_quotation_text           TYPE TABLE OF bapisdtext.
    DATA lt_quotation_items_inx      TYPE TABLE OF bapisditmx.
    DATA lt_quotation_conditions_inx TYPE TABLE OF bapicondx.
    DATA lt_quotation_schedules_inx  TYPE TABLE OF bapischdlx.
    DATA lv_salesdocument            TYPE bapivbeln-vbeln.
    DATA lt_returnbp                 TYPE TABLE OF bapiret2.
    DATA lv_message                  TYPE string.
    DATA lv_error                    TYPE c LENGTH 1.
    DATA go_error                    TYPE REF TO cx_root.
    DATA lv_errorch                  TYPE string.
    DATA lv_errorbp                  TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_usuario                  TYPE sy-uname.

    FIELD-SYMBOLS <fs_quotation_items_in>       LIKE LINE OF lt_quotation_items_in.
    FIELD-SYMBOLS <fs_quotation_partners>       LIKE LINE OF lt_quotation_partners.
    FIELD-SYMBOLS <fs_quotation_conditions_in>  LIKE LINE OF lt_quotation_conditions_in.
    FIELD-SYMBOLS <fs_quotation_schedules_in>   LIKE LINE OF lt_quotation_schedules_in.
    FIELD-SYMBOLS <fs_quotation_text>           LIKE LINE OF lt_quotation_text.
    FIELD-SYMBOLS <fs_quotation_conditions_inx> LIKE LINE OF lt_quotation_conditions_inx.
    FIELD-SYMBOLS <fs_returnbp>                 LIKE LINE OF lt_returnbp.
    FIELD-SYMBOLS <fs_i_new_cotizacion_h>       LIKE LINE OF i_new_cotizacion_h.
    FIELD-SYMBOLS <fs_i_new_cotizacion_p>       LIKE LINE OF i_new_cotizacion_p.
    FIELD-SYMBOLS <fs_kna1>                     LIKE LINE OF lt_kna1.
    FIELD-SYMBOLS <fs_kna12>                    LIKE LINE OF lt_kna12.
    FIELD-SYMBOLS <fs_zparametros>              LIKE LINE OF lt_zparametros.

*    CONSTANTS lv_name  TYPE rvari_vnam VALUE 'ZAUART1'.
*    CONSTANTS lv_typo  TYPE rsscr_kind VALUE 'P'.
*    CONSTANTS lv_tvarc TYPE tvarv_val VALUE 'X'.

    DATA lt_string_components TYPE TABLE OF swastrtab.
    DATA lv_input             TYPE string.
    DATA lv_fact              TYPE c LENGTH 1.
    DATA lv_nit               TYPE string.
    DATA lt_extensionin       TYPE TABLE OF bapiparex.

    FIELD-SYMBOLS <fs_extensionin> LIKE LINE OF lt_extensionin.
    FIELD-SYMBOLS <fs_string>      LIKE LINE OF lt_string_components.

    DATA lv_nombre1              TYPE char35.
    DATA lv_nombre2              TYPE char35.
    DATA lv_nombre3              TYPE char35.
    DATA lv_nombre4              TYPE char35.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_order_view           TYPE order_view.
    DATA lt_sales_documents      TYPE TABLE OF sales_key.
    DATA lt_order_headers_out    TYPE TABLE OF bapisdhd.
    DATA lt_order_conditions_out TYPE TABLE OF bapisdcond.
    DATA lt_conditions_in        TYPE TABLE OF bapicond.
    DATA lt_conditions_inx       TYPE TABLE OF bapicondx.

    FIELD-SYMBOLS <fs_sales_documents> LIKE LINE OF lt_sales_documents.

    lv_usuario = sy-uname.

    ASSIGN i_new_cotizacion_h[ 1 ] TO <fs_i_new_cotizacion_h>.
    IF sy-subrc = 0.
      lv_fact = <fs_i_new_cotizacion_h>-fact.
*{INSERT @100
      SELECT SINGLE via_pago, pas_pag FROM yfi_t001_metpago WHERE met_pag = @<fs_i_new_cotizacion_h>-metodo_pago
        INTO @DATA(ls_metodo_pago).
*}INSERT @100

    ENDIF.

    IF lv_fact = 'M'.

      SELECT doc_type_c doc_type_p indi_expedi
        FROM ysd_t001_paramet
        INTO TABLE lt_zparametros
        FOR ALL ENTRIES IN i_new_cotizacion_h
        WHERE indi_expedi = i_new_cotizacion_h-motivo_expedicion
          AND facturacion = 'B' " Facturación manual
          AND vkorg       = i_new_cotizacion_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p indi_expedi
        FROM ysd_t001_paramet
        INTO TABLE lt_zparametros
        FOR ALL ENTRIES IN i_new_cotizacion_h
        WHERE indi_expedi = i_new_cotizacion_h-motivo_expedicion
          AND facturacion = 'A' " Facturación normal
          AND vkorg       = i_new_cotizacion_h-organizacion_venta.

    ENDIF.

    SELECT uname pernr bukrs btrtl FROM pa0001
      INTO TABLE lt_pa0001
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE uname = i_new_cotizacion_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
      FROM knvv
      INTO TABLE lt_knvv
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE kunnr = i_new_cotizacion_h-cliente.

    SELECT kunnr kdkg1 xcpdk FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE kunnr = i_new_cotizacion_h-cliente.

    SELECT kunnr kdkg1 xcpdk FROM kna1
      INTO TABLE lt_kna12
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE kunnr = i_new_cotizacion_h-bill_to.

*    SELECT bzirk matnr vtweg kschl FROM a931
*      INTO TABLE lt_a931
*      FOR ALL ENTRIES IN lt_knvv
*      WHERE bzirk = lt_knvv-bzirk.

    " CREAR LA COTIZACION ------------------------------------------------------------------
    " ----------------------------------------------------------------------------------------------------------------------------------------

    LOOP AT i_new_cotizacion_h ASSIGNING <fs_i_new_cotizacion_h>.
      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_cotizacion_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

      " LLENADO DE LA ESTRUCTURA --------------------------------------------------------
      ASSIGN lt_zparametros[ 1 ] TO <fs_zparametros>.
      IF sy-subrc = 0.
        ls_quotation_header_in-doc_type = <fs_zparametros>-doc_type_c.
      ENDIF.
      ls_quotation_header_in-ship_cond  = <fs_i_new_cotizacion_h>-motivo_expedicion.
      ls_quotation_header_in-ord_reason = <fs_i_new_cotizacion_h>-motivo_pedido.
      ls_quotation_header_in-sales_org  = <fs_i_new_cotizacion_h>-organizacion_venta.
      ls_quotation_header_in-distr_chan = <fs_i_new_cotizacion_h>-canal.
      ls_quotation_header_in-division   = <fs_i_new_cotizacion_h>-sector.
      ls_quotation_header_in-sales_grp  = <fs_i_new_cotizacion_h>-grupo_vendedores.
      ls_quotation_header_in-sales_off  = <fs_i_new_cotizacion_h>-oficina.
      ls_quotation_header_in-req_date_h = <fs_i_new_cotizacion_h>-fecha_entrega.
      ls_quotation_header_in-price_date = sy-datum.
      ls_quotation_header_in-qt_valid_f = sy-datum.
      ls_quotation_header_in-qt_valid_t = <fs_i_new_cotizacion_h>-fecha_oferta.
      ls_quotation_header_in-ct_valid_f = <fs_i_new_cotizacion_h>-fecha_precio.
      ls_quotation_header_in-ct_valid_t = <fs_i_new_cotizacion_h>-fecha_oferta.
      ls_quotation_header_in-purch_no_c = <fs_i_new_cotizacion_h>-referencia_cliente.
      ls_quotation_header_in-sd_doc_cat = 'B'.
      ls_quotation_header_in-sales_dist = <fs_i_new_cotizacion_h>-zona_venta.
      ls_quotation_header_in-pp_search  = <fs_i_new_cotizacion_h>-obra.
      ls_quotation_header_in-pmnttrms   = <fs_i_new_cotizacion_h>-condicion_pago.
      ls_quotation_header_in-pymt_meth = ls_metodo_pago-via_pago."<fs_i_new_cotizacion_h>-metodo_pago.
      " LLENADO DE LA PRIMERA TABLA -------------------------------------------------------
      ASSIGN lt_kna1[ 1 ] TO <fs_kna1>.
      IF sy-subrc = 0.
        lv_cliente = <fs_kna1>-xcpdk.
      ENDIF.

      ASSIGN lt_kna12[ 1 ] TO <fs_kna12>.
      IF sy-subrc = 0.
        lv_destina = <fs_kna12>-xcpdk.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'AG'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      IF lv_cliente = 'X'.
        <fs_quotation_partners>-name      = lv_nombre1.
        <fs_quotation_partners>-name_2    = lv_nombre2.
        <fs_quotation_partners>-name_3    = lv_nombre3.
        <fs_quotation_partners>-name_4    = lv_nombre4.
        <fs_quotation_partners>-street    = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city      = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country   = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu     = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no    = '1'.
        <fs_partneraddresses>-name       = lv_nombre1.
        <fs_partneraddresses>-name_2     = lv_nombre2.
        <fs_partneraddresses>-name_3     = lv_nombre3.
        <fs_partneraddresses>-name_4     = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city       = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country    = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu      = 'S'.
        CLEAR lv_nit.

        CONCATENATE 'AG' <fs_i_new_cotizacion_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure  = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.

        CONCATENATE 'RG' <fs_i_new_cotizacion_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure  = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RE'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      ENDIF.
      IF lv_destina = 'X'.
        <fs_quotation_partners>-name      = lv_nombre1.
        <fs_quotation_partners>-name_2    = lv_nombre2.
        <fs_quotation_partners>-name_3    = lv_nombre3.
        <fs_quotation_partners>-name_4    = lv_nombre4.
        <fs_quotation_partners>-street    = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city      = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country   = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu     = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no    = '1'.
        <fs_partneraddresses>-name       = lv_nombre1.
        <fs_partneraddresses>-name_2     = lv_nombre2.
        <fs_partneraddresses>-name_3     = lv_nombre3.
        <fs_partneraddresses>-name_4     = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city       = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country    = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu      = 'S'.

        CLEAR lv_nit.
        IF lv_cliente = 'X'.
          CONCATENATE 'RE' <fs_i_new_cotizacion_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_cotizacion_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure  = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RP'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'BU'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'WE'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.

      ENDIF.
      IF lv_destina = 'X'.
        <fs_quotation_partners>-name      = lv_nombre1.
        <fs_quotation_partners>-name_2    = lv_nombre2.
        <fs_quotation_partners>-name_3    = lv_nombre3.
        <fs_quotation_partners>-name_4    = lv_nombre4.
        <fs_quotation_partners>-street    = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city      = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country   = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu     = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no    = '1'.
        <fs_partneraddresses>-name       = lv_nombre1.
        <fs_partneraddresses>-name_2     = lv_nombre2.
        <fs_partneraddresses>-name_3     = lv_nombre3.
        <fs_partneraddresses>-name_4     = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city       = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country    = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu      = 'S'.

        CLEAR lv_nit.
        IF lv_cliente = 'X'.
          CONCATENATE 'WE' <fs_i_new_cotizacion_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'WE' <fs_i_new_cotizacion_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure  = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'VE'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-solicitante. "'0001000430'.

      " SEGUNDA DE LA PRIMERA TABLA -------------------------------------------------------
      CONCATENATE <fs_i_new_cotizacion_h>-nota_envio ' ' <fs_i_new_cotizacion_h>-coordenada INTO lv_text_line.

      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id   = 'TX04'.
      <fs_quotation_text>-langu     = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_cotizacion_h>-coordenada.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_cotizacion_h>-nota_envio.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id   = 'TX14'.
        <fs_quotation_text>-langu     = 'S'.
        <fs_quotation_text>-text_line = <fs_string>-str.
      ENDLOOP.

      LOOP AT i_new_cotizacion_p ASSIGNING <fs_i_new_cotizacion_p>.

        IF <fs_i_new_cotizacion_p>-nota_fabricacion IS NOT INITIAL.

          CLEAR lv_input. FREE lt_string_components.
          lv_input = <fs_i_new_cotizacion_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_cotizacion_p>-posicion.
            <fs_quotation_text>-text_id    = '0006'.
            <fs_quotation_text>-langu      = 'S'.
            <fs_quotation_text>-text_line  = <fs_string>-str.
          ENDLOOP.

        ENDIF.

        " SEGUNDA DE LA PRIMERA TABLA -------------------------------------------------------
        IF <fs_i_new_cotizacion_p>-condp = '1'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type  = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_pago.
          <fs_quotation_conditions_in>-currency   = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type  = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_inx>-currency   = 'X'.

        ELSEIF <fs_i_new_cotizacion_p>-condp = '2'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit  = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_inx>-currency   = 'X'.

        ELSEIF <fs_i_new_cotizacion_p>-condp = '3'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type  = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_pago.
          <fs_quotation_conditions_in>-currency   = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion. "
          <fs_quotation_conditions_inx>-cond_type  = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_inx>-currency   = 'X'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit  = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_inx>-currency   = 'X'.
        ELSEIF <fs_i_new_cotizacion_p>-condp = '4'. " Descuentos por valor
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_decuento.
          <fs_quotation_conditions_in>-currency   = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type  = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_inx>-currency   = 'X'.

        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
        <fs_quotation_conditions_inx>-updateflag = 'I'.
        <fs_quotation_conditions_inx>-cond_value = 'X'.
        <fs_quotation_conditions_inx>-itm_number = <fs_i_new_cotizacion_p>-posicion.
        <fs_quotation_conditions_inx>-currency   = 'X'.

        " TERCERA DE LA PRIMERA TABLA -------------------------------------------------------
        APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
        <fs_quotation_schedules_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
        <fs_quotation_schedules_in>-req_date   = <fs_i_new_cotizacion_h>-fecha_precio.
        <fs_quotation_schedules_in>-req_qty    = <fs_i_new_cotizacion_p>-cantidad.

        " CUARTE DE LA PRIMERA TABLA -------------------------------------------------------
        APPEND INITIAL LINE TO lt_quotation_items_in ASSIGNING <fs_quotation_items_in>.
        <fs_quotation_items_in>-pmnttrms   = <fs_i_new_cotizacion_h>-condicion_pago.
        <fs_quotation_items_in>-sales_dist = <fs_i_new_cotizacion_h>-zona_venta.
        <fs_quotation_items_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
        <fs_quotation_items_in>-po_itm_no  = <fs_i_new_cotizacion_p>-posicion.
        <fs_quotation_items_in>-material   = <fs_i_new_cotizacion_p>-articulo.
        <fs_quotation_items_in>-batch      = <fs_i_new_cotizacion_p>-lote.
        <fs_quotation_items_in>-plant      = <fs_i_new_cotizacion_p>-centro.
        <fs_quotation_items_in>-target_qty = <fs_i_new_cotizacion_p>-cantidad.
        <fs_quotation_items_in>-target_qu  = <fs_i_new_cotizacion_p>-unidad_medida.
*        <fs_quotation_items_in>-item_categ = 'AGN'."DELETE @0100 Caso programacion stock y almacen
        <fs_quotation_items_in>-gross_wght = <fs_i_new_cotizacion_p>-peso_neto.
        <fs_quotation_items_in>-net_weight = <fs_i_new_cotizacion_p>-peso_neto.
        <fs_quotation_items_in>-untof_wght = 'KG'.
        <fs_quotation_items_in>-route      = <fs_i_new_cotizacion_p>-ruta.
        <fs_quotation_items_in>-po_quan    = <fs_i_new_cotizacion_p>-cantidad.
        <fs_quotation_items_in>-store_loc  = <fs_i_new_cotizacion_p>-almacen.
        <fs_quotation_items_in>-reason_rej = <fs_i_new_cotizacion_p>-motivo_rechazo.
        IF <fs_i_new_cotizacion_p>-tipo_posc IS NOT INITIAL.
          <fs_quotation_items_in>-ref_1 = <fs_i_new_cotizacion_p>-tipo_posc.
        ELSE.
          <fs_quotation_items_in>-ref_1 = 'AGN'.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

    TRY.
        DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
        CALL FUNCTION 'BAPI_QUOTATION_CREATEFROMDATA2'
          EXPORTING
            quotation_header_in      = ls_quotation_header_in
          IMPORTING
            salesdocument            = lv_salesdocument
          TABLES
            return                   = lt_returnbp
            quotation_items_in       = lt_quotation_items_in
            quotation_partners       = lt_quotation_partners
            quotation_schedules_in   = lt_quotation_schedules_in
            quotation_conditions_in  = lt_quotation_conditions_in
            quotation_conditions_inx = lt_quotation_conditions_inx
            quotation_text           = lt_quotation_text
            extensionin              = lt_extensionin
            partneraddresses         = lt_partneraddresses.

        IF lv_salesdocument IS INITIAL.

          LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.

            CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.

          ENDLOOP.

        ELSE.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorch = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.

    " TRAER EL TOTAL_SAP ----------------------------------------------------------------

    ls_order_view-header = 'X'.
    ls_order_view-sdcond = 'X'.

    APPEND INITIAL LINE TO lt_sales_documents ASSIGNING <fs_sales_documents>.
    <fs_sales_documents>-vbeln = lv_salesdocument.

    IF lv_salesdocument IS NOT INITIAL AND lv_error IS INITIAL.

      rt_return-message  = 'Se creo la cotizacion exitosamente'.
      rt_return-messcode = '200'.
      rt_return-data     = lv_salesdocument.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

    ELSE.

      IF lv_errorbp IS NOT INITIAL.

        CONCATENATE 'Cotizacion con Error : ' lv_errorbp INTO lv_message.

        rt_return-message  = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_error IS NOT INITIAL.

        CONCATENATE 'Cotizacion con CATCH en la bapi : ' lv_errorch INTO lv_message.

        rt_return-message  = lv_message.
        rt_return-messcode = '400'.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_ETAPA2_PARCIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_FTPOST                       TYPE        YSD_TT_012_FTPOST
* | [--->] I_FTCLEAR                      TYPE        YSD_TT_013_FTCLEAR
* | [--->] I_NEW_COBRO_H                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_P                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] I_NEW_COBRO_C                  TYPE        YSD_TT_003_CONTABILIZAR
* | [--->] LV_UKURS_AUX1                  TYPE        CHAR10
* | [--->] LV_UKURS1                      TYPE        CHAR10
* | [--->] LV_CLIENTE                     TYPE        CHAR1
* | [--->] A4                             TYPE        CHAR24
* | [--->] LA4                            TYPE        BSEG-WRBTR
* | [<---] RT_RETURN                      TYPE        YSD_S_003_CONTABILIZAR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_etapa2_parcial.
    " TODO: parameter LV_UKURS_AUX1 is never used (ABAP cleaner)
    " TODO: parameter LV_UKURS1 is never used (ABAP cleaner)

    DATA lt_ftclear       TYPE ysd_tt_013_ftclear.
    " data lt_ftclear2      type  ysd_tt_013_ftclear.
    DATA lt_ftpost        TYPE ysd_tt_012_ftpost.
    " data lt_ftpost2       type  ysd_tt_012_ftpost.
    DATA lt_t_new_cobro_h TYPE ysd_tt_003_contabilizar.
    DATA lt_t_new_cobro_p TYPE ysd_tt_003_contabilizar.
    DATA lt_t_new_cobro_c TYPE ysd_tt_003_contabilizar.
    DATA lt_retunr        TYPE TABLE OF ysd_s_003_contabilizar.
    DATA ls_retunr        TYPE ysd_s_003_contabilizar.
    DATA wa_new_cobro_h   LIKE LINE OF lt_t_new_cobro_h.
    DATA lv_a4            TYPE c LENGTH 24.
    DATA lv_la4           TYPE bseg-wrbtr.

    lt_ftclear[]       = i_ftclear[].
    lt_ftpost[]        = i_ftpost[].
    lt_t_new_cobro_h[] = i_new_cobro_h[].
    lt_t_new_cobro_p[] = i_new_cobro_p[].
    lt_t_new_cobro_c[] = i_new_cobro_c[].
    lv_la4 = la4.
    lv_a4  = a4.

*
*  EXPORT LT_FTCLEAR  FROM LT_FTCLEAR2 TO   MEMORY ID 'CLEAR'.
*  EXPORT LT_FTCLEAR2  FROM LT_FTCLEAR TO   MEMORY ID 'AB'.
    EXPORT lt_ftclear = lt_ftclear    TO MEMORY ID 'AC'. "
    EXPORT lt_ftpost = lt_ftpost     TO MEMORY ID 'AB'. "
    EXPORT lt_t_new_cobro_h = i_new_cobro_h TO MEMORY ID 'BA'. "
    EXPORT lt_t_new_cobro_p = i_new_cobro_p TO MEMORY ID 'BC'. "
    EXPORT lt_t_new_cobro_c = i_new_cobro_c TO MEMORY ID 'BD'. "

    EXPORT lv_la4 = lv_la4        TO MEMORY ID 'CA'. "
    EXPORT lv_a4 = a4            TO MEMORY ID 'CB'. "
*  EXPORT LT_FTPOST   FROM LT_FTPOST2  TO   MEMORY ID 'FTPOST'.

    READ TABLE lt_t_new_cobro_h INTO wa_new_cobro_h INDEX 1.
    IF wa_new_cobro_h-check IS INITIAL AND lv_cliente IS INITIAL AND wa_new_cobro_h-moneda = 'BOB'.
      ""si es normal bob
      SUBMIT zfi_contabilza_e2
      AND RETURN.

    ENDIF.
    IF wa_new_cobro_h-check IS INITIAL AND wa_new_cobro_h-moneda = 'USD'.
      "" si es dolares
      SUBMIT zparcial_tasavaria2
      AND RETURN.
*        SUBMIT ZFI_CONTABILZA_E2_DOL
*    AND RETURN .

    ENDIF.

    IF wa_new_cobro_h-check IS INITIAL AND lv_cliente IS NOT INITIAL AND wa_new_cobro_h-moneda = 'BOB'.
      ""si es cpd
      SUBMIT zparcial_cpd2
      AND RETURN.
    ENDIF.
*  IMPORT LT_RETUNR   = LT_RETUNR  FROM  MEMORY ID 'AD'."
    IMPORT ls_retunr = ls_retunr FROM MEMORY ID 'AD'. "
    FREE MEMORY ID 'AD'.

    rt_return = ls_retunr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_MOD_COTIZACION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_COTIZACION_H             TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_COTIZACION_P             TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_mod_cotizacion.
* ******************************************************************* *
*                           T A B L E S                               *
* ******************************************************************* *
    TYPES: BEGIN OF gy_pa0001, "Infotype 0001 - Asig. Organizativa
             uname TYPE  pa0001-uname,
             pernr TYPE  pa0001-pernr,
             bukrs TYPE  pa0001-bukrs,
             btrtl TYPE  pa0001-btrtl,
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_zparametros, "Condiciones de variantes/Tabla de parámetros
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, "Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi,
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_knvv, "Maestro de clientes datos comerciales
             kunnr TYPE  knvv-kunnr, "Número de cliente
             kdgrp TYPE  knvv-kdgrp, "Grupo de clientes
             bzirk TYPE  knvv-bzirk, "Zona de ventas
             pltyp TYPE  knvv-pltyp, "Tipo de lista de precios
             konda TYPE  knvv-konda, "Grupo de precio de cliente
             waers TYPE  knvv-waers, "Moneda
             spart TYPE  knvv-spart, "Sector
           END OF gy_knvv.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.
*
* Variables del Reporte :                                             *
    DATA:
      lv_usuario       TYPE sy-uname,
      lv_fact          TYPE c,
      lv_salesdocument TYPE bapivbeln-vbeln,
      lv_cliente       TYPE c,
      lv_destina       TYPE c,
      lv_nit           TYPE string,
      lv_text_line     TYPE tdline,
      lv_input         TYPE string,
      lv_unidad        TYPE meins,
      lv_iso           TYPE isocd_vrkme,
      go_error         TYPE REF TO cx_root,
      lv_errorch       TYPE string,
      lv_errorbp       TYPE string,
      lv_error         TYPE c,
      lv_message       TYPE string.

*
* Data :                                                              *
    DATA:lt_zparametros             TYPE TABLE OF gy_zparametros,
         lt_pa0001                  TYPE TABLE OF gy_pa0001,
         lt_knvv                    TYPE TABLE OF gy_knvv,
         lt_kna1                    TYPE TABLE OF gy_kna1,
         lt_kna12                   TYPE TABLE OF gy_kna1,
         lt_quotation_partners      TYPE TABLE OF bapiparnr,
         lt_partneraddresses        TYPE TABLE OF bapiaddr1,
         lt_extensionin             TYPE TABLE OF  bapiparex,
         lt_quotation_text          TYPE TABLE OF bapisdtext,
         lt_string_components       TYPE TABLE OF swastrtab,
         lt_quotation_conditions_in TYPE TABLE OF bapicond,
         lt_quotation_schedules_in  TYPE TABLE OF bapischdl,
         lt_order_items_in          TYPE TABLE OF bapisditm,
         lt_order_item_inx          TYPE TABLE OF bapisditmx,
         lt_returnbp                TYPE TABLE OF bapiret2,
         lt_partnerchanges          TYPE TABLE OF bapiparnrc.

    DATA: ls_order_header_in  TYPE bapisdh1,
          ls_order_header_inx TYPE bapisdh1x,
          ls_logic_switch     TYPE bapisdls.

*
* Field-Symbols :                                                     *
    FIELD-SYMBOLS:
      <fs_i_new_cotizacion_h>      LIKE LINE OF i_new_cotizacion_h,
      <fs_i_new_cotizacion_p>      LIKE LINE OF i_new_cotizacion_p,
      <fs_kna1>                    LIKE LINE OF lt_kna1,
      <fs_kna12>                   LIKE LINE OF lt_kna12,
      <fs_quotation_partners>      LIKE LINE OF lt_quotation_partners,
      <fs_partneraddresses>        LIKE LINE OF lt_partneraddresses,
      <fs_extensionin>             LIKE LINE OF lt_extensionin,
      <fs_quotation_text>          LIKE LINE OF lt_quotation_text,
      <fs_quotation_conditions_in> LIKE LINE OF lt_quotation_conditions_in,
      <fs_quotation_schedules_in>  LIKE LINE OF lt_quotation_schedules_in,
      <fs_order_items_in>          LIKE LINE OF lt_order_items_in,
      <fs_sales_documents>         LIKE LINE OF gt_sales_documents,
      <fs_order_items_out>         LIKE LINE OF gt_order_items_out,
      <fs_order_item_inx>          LIKE LINE OF lt_order_item_inx,
      <fs_returnbp>                LIKE LINE OF lt_returnbp,
      <fs_partnerchanges>          LIKE LINE OF lt_partnerchanges,
      <fs_order_partners_out>      LIKE LINE OF gt_order_partners_out.

    FIELD-SYMBOLS:  <fs_string>      LIKE LINE OF lt_string_components.

    DATA: lv_nombre1 TYPE char35,
          lv_nombre2 TYPE char35,
          lv_nombre3 TYPE char35,
          lv_nombre4 TYPE char35.
    DATA: lv_posicion  TYPE posnr.
    DATA: lv_posicion1 TYPE posnr.
    DATA: lt_desc_dinamic  TYPE STANDARD TABLE OF ycl_sd_utilitys=>ty_desc_dinamic .


* ******************************************************************* *
*                            READ TABLES                              *
* ******************************************************************* *
    lv_usuario = sy-uname.

    READ TABLE i_new_cotizacion_h ASSIGNING <fs_i_new_cotizacion_h> INDEX 1.
    IF sy-subrc EQ 0.
      lv_fact = <fs_i_new_cotizacion_h>-fact.
    ENDIF.

    IF lv_fact EQ 'M'.

      SELECT doc_type_c doc_type_p indi_expedi
      FROM ysd_t001_paramet
      INTO TABLE lt_zparametros
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE indi_expedi = i_new_cotizacion_h-motivo_expedicion
      AND facturacion = 'B'"Facturación manual
      AND vkorg = i_new_cotizacion_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p indi_expedi
      FROM ysd_t001_paramet
      INTO TABLE lt_zparametros
      FOR ALL ENTRIES IN i_new_cotizacion_h
      WHERE indi_expedi = i_new_cotizacion_h-motivo_expedicion
      AND facturacion = 'A'"Facturación normal
      AND vkorg = i_new_cotizacion_h-organizacion_venta.

    ENDIF.

    SELECT uname pernr bukrs btrtl
    FROM pa0001
    INTO TABLE lt_pa0001
    FOR ALL ENTRIES IN i_new_cotizacion_h
    WHERE uname EQ i_new_cotizacion_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
    FROM knvv
    INTO TABLE lt_knvv
    FOR ALL ENTRIES IN i_new_cotizacion_h
    WHERE kunnr EQ i_new_cotizacion_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna1
    FOR ALL ENTRIES IN i_new_cotizacion_h
    WHERE kunnr EQ i_new_cotizacion_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna12
    FOR ALL ENTRIES IN i_new_cotizacion_h
    WHERE kunnr EQ i_new_cotizacion_h-bill_to.

* ******************************************************************* *
*                       MODIF LA COTIZACION                           *
* ******************************************************************* *

*/ Parámeters Get data SAP
    gs_order_view-header = gs_order_view-item = gs_order_view-partner = gs_order_view-address = gs_order_view-sdcond = gs_order_view-text = 'X'.
    ls_order_header_inx-updateflag = 'U'.
    ls_logic_switch-pricing = 'C'."Tomar componentes precio manual

*/ Read data of Fiori
    LOOP AT i_new_cotizacion_h ASSIGNING <fs_i_new_cotizacion_h>.
      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_cotizacion_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

      IF <fs_i_new_cotizacion_h>-documento IS INITIAL.
        rt_return-message  = 'No se pudo recuperar el nro. de Documento de la Cotización'.
        rt_return-messcode = '400'.
        EXIT.
      ENDIF.
      lv_salesdocument = <fs_i_new_cotizacion_h>-documento.

*/ Delete data
      TRY.
          APPEND INITIAL LINE TO gt_sales_documents ASSIGNING <fs_sales_documents>.
          <fs_sales_documents>-vbeln = lv_salesdocument.

          CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
            EXPORTING
              i_bapi_view          = gs_order_view
            TABLES
              sales_documents      = gt_sales_documents
              order_headers_out    = gt_order_headers_out
              order_items_out      = gt_order_items_out
              order_partners_out   = gt_order_partners_out
              order_address_out    = gt_order_address_out
              order_conditions_out = gt_order_conditions_out
              order_textlines_out  = gt_order_textlines_out.

          LOOP AT gt_order_items_out ASSIGNING <fs_order_items_out>.
            APPEND INITIAL LINE TO lt_order_item_inx ASSIGNING <fs_order_item_inx>.
            <fs_order_item_inx>-itm_number = <fs_order_items_out>-itm_number.
            <fs_order_item_inx>-updateflag = 'D'.
            APPEND INITIAL LINE TO lt_order_items_in ASSIGNING <fs_order_items_in>.
            <fs_order_items_in>-itm_number = <fs_order_items_out>-itm_number.
          ENDLOOP.
          TRY.

              CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
                EXPORTING
                  salesdocument    = lv_salesdocument
                  order_header_inx = ls_order_header_inx
                  logic_switch     = ls_logic_switch
                TABLES
                  return           = lt_returnbp
                  order_item_in    = lt_order_items_in
                  order_item_inx   = lt_order_item_inx.

              READ TABLE lt_returnbp ASSIGNING <fs_returnbp> WITH KEY type = 'E'.
              IF sy-subrc = 0.

                LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.
                  CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.
                ENDLOOP.

                CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                rt_return-message = lv_errorbp.
                rt_return-messcode = '400'.
                RETURN.

              ENDIF.

            CATCH cx_sy_zerodivide INTO go_error.

              lv_errorch = go_error->get_text( ).

              lv_error = 'X'.

          ENDTRY.
          FREE lt_returnbp.
          FREE lt_order_items_in.
          FREE lt_order_item_inx.
          FREE lt_quotation_partners.
          FREE lt_partnerchanges.
          FREE lt_quotation_schedules_in.
          FREE lt_quotation_conditions_in.
          FREE lt_quotation_text.
          FREE lt_extensionin.
          FREE lt_partneraddresses.

*/ Update all header
          ls_order_header_inx-ship_cond  = 'X'.
          ls_order_header_inx-ord_reason = 'X'.
          ls_order_header_inx-sales_org  = 'X'.
          ls_order_header_inx-distr_chan = 'X'.
          ls_order_header_inx-division   = 'X'.
          ls_order_header_inx-sales_grp  = 'X'.
          ls_order_header_inx-sales_off  = 'X'.
          ls_order_header_inx-price_date = 'X'.
          ls_order_header_inx-qt_valid_t = 'X'.
          ls_order_header_inx-purch_no_c = 'X'.
          ls_order_header_inx-sd_doc_cat = 'X'.
          ls_order_header_inx-sales_dist = 'X'.
          ls_order_header_inx-pp_search  = 'X'.
          ls_order_header_inx-pmnttrms   = 'X'.
        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

* ********************LLENADO DE LA ESTRUCTURA*********************** *
      ls_order_header_in-ship_cond   = <fs_i_new_cotizacion_h>-motivo_expedicion.
      ls_order_header_in-ord_reason = <fs_i_new_cotizacion_h>-motivo_pedido.
      ls_order_header_in-sales_org  = <fs_i_new_cotizacion_h>-organizacion_venta.
      ls_order_header_in-distr_chan = <fs_i_new_cotizacion_h>-canal.
      ls_order_header_in-division   = <fs_i_new_cotizacion_h>-sector.
      ls_order_header_in-sales_grp  = <fs_i_new_cotizacion_h>-grupo_vendedores.
      ls_order_header_in-sales_off  = <fs_i_new_cotizacion_h>-oficina.
      ls_order_header_in-req_date_h = <fs_i_new_cotizacion_h>-fecha_entrega.
      ls_order_header_in-price_date = sy-datum.
      ls_order_header_in-qt_valid_t = <fs_i_new_cotizacion_h>-fecha_oferta.
      ls_order_header_in-ct_valid_f = <fs_i_new_cotizacion_h>-fecha_precio.
      ls_order_header_in-ct_valid_t = <fs_i_new_cotizacion_h>-fecha_oferta.
      ls_order_header_in-purch_no_c = <fs_i_new_cotizacion_h>-referencia_cliente.
      ls_order_header_in-sd_doc_cat = 'B'.
      ls_order_header_in-sales_dist = <fs_i_new_cotizacion_h>-zona_venta.
      ls_order_header_in-pp_search  = <fs_i_new_cotizacion_h>-obra.
      ls_order_header_in-pmnttrms   = <fs_i_new_cotizacion_h>-condicion_pago.

* *******************LLENADO DE LA PRIMERA TABLA********************* *
      READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
      IF sy-subrc EQ 0.
        lv_cliente = <fs_kna1>-xcpdk.
      ENDIF.

      READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
      IF sy-subrc EQ 0.
        lv_destina = <fs_kna12>-xcpdk.
      ENDIF.
*
*/ Solicitante
*
      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'AG'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      IF lv_cliente EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.

        CONCATENATE 'AG' <fs_i_new_cotizacion_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.

        CONCATENATE 'RG' <fs_i_new_cotizacion_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.
      READ TABLE gt_order_partners_out ASSIGNING <fs_order_partners_out> WITH KEY partn_role = 'AG'.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO lt_partnerchanges ASSIGNING <fs_partnerchanges>.
        <fs_partnerchanges>-document = lv_salesdocument.
        <fs_partnerchanges>-updateflag = 'U'.
        <fs_partnerchanges>-partn_role = 'AG'.
        <fs_partnerchanges>-p_numb_old = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-p_numb_new = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-addr_link  = <fs_quotation_partners>-addr_link.
      ENDIF.
*
*/ Destinatario factura
*
      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RE'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '2'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '2'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.

        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'RE' <fs_i_new_cotizacion_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_cotizacion_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.
      READ TABLE gt_order_partners_out ASSIGNING <fs_order_partners_out> WITH KEY partn_role = 'RE'.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO lt_partnerchanges ASSIGNING <fs_partnerchanges>.
        <fs_partnerchanges>-document = lv_salesdocument.
        <fs_partnerchanges>-updateflag = 'U'.
        <fs_partnerchanges>-partn_role = 'RE'.
        <fs_partnerchanges>-p_numb_old = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-p_numb_new = <fs_quotation_partners>-partn_numb.
        <fs_partnerchanges>-addr_link  = <fs_quotation_partners>-addr_link.
        gv_difinterlocutor = abap_true.
      ENDIF.
*
*/ Responsable de pago
*
      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RP'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      IF lv_cliente EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '3'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '3'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
      ENDIF.
      READ TABLE gt_order_partners_out ASSIGNING <fs_order_partners_out> WITH KEY partn_role = 'RG'.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO lt_partnerchanges ASSIGNING <fs_partnerchanges>.
        <fs_partnerchanges>-document = lv_salesdocument.
        <fs_partnerchanges>-updateflag = 'U'.
        <fs_partnerchanges>-partn_role = 'RG'.
        <fs_partnerchanges>-p_numb_old = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-p_numb_new = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-addr_link  = <fs_quotation_partners>-addr_link.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'BU'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      ENDIF.
*
*/ Destinatario mercancia
*
      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'WE'.
      IF <fs_i_new_cotizacion_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_cotizacion_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_cotizacion_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '4'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '4'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_cotizacion_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_cotizacion_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_cotizacion_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.

        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'WE' <fs_i_new_cotizacion_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'WE' <fs_i_new_cotizacion_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.
      READ TABLE gt_order_partners_out ASSIGNING <fs_order_partners_out> WITH KEY partn_role = 'WE'.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO lt_partnerchanges ASSIGNING <fs_partnerchanges>.
        <fs_partnerchanges>-document = lv_salesdocument.
        <fs_partnerchanges>-updateflag = 'U'.
        <fs_partnerchanges>-partn_role = 'WE'.
        <fs_partnerchanges>-p_numb_old = <fs_order_partners_out>-customer.
        <fs_partnerchanges>-p_numb_new = <fs_quotation_partners>-partn_numb.
        <fs_partnerchanges>-addr_link  = <fs_quotation_partners>-addr_link.
      ENDIF.

*
*/ Empleado dpto. ventas
*
* *******************SEGUNDA DE LA PRIMERA TABLA********************* *
      CONCATENATE  <fs_i_new_cotizacion_h>-nota_envio ' ' <fs_i_new_cotizacion_h>-coordenada INTO lv_text_line.

      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id = 'TX04'.
      <fs_quotation_text>-langu = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_cotizacion_h>-coordenada.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_cotizacion_h>-nota_envio.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id = 'TX14'.
        <fs_quotation_text>-langu = 'S'.
        <fs_quotation_text>-text_line = <fs_string>-str.
      ENDLOOP.
      CLEAR lv_input. FREE lt_string_components.


*/ Fill posiciones
      CALL METHOD ycl_sd_utilitys=>get_consultar_des_dinamicos
        EXPORTING
          i_vkorg    = <fs_i_new_cotizacion_h>-organizacion_venta
          i_pantalla = 'VTA'
          i_activo   = 'X'
        IMPORTING
          e_table    = lt_desc_dinamic.

      CLEAR lv_posicion1.
      LOOP AT i_new_cotizacion_p ASSIGNING <fs_i_new_cotizacion_p>.

        IF <fs_i_new_cotizacion_p>-nota_fabricacion IS NOT INITIAL
           AND <fs_i_new_cotizacion_p>-posicion <> lv_posicion1.

          CLEAR lv_input. FREE lt_string_components.

          lv_input = <fs_i_new_cotizacion_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_cotizacion_p>-posicion.
            <fs_quotation_text>-text_id = '0006'.
            <fs_quotation_text>-langu = 'S'.
            <fs_quotation_text>-text_line = <fs_string>-str.
          ENDLOOP.

          lv_posicion1 = <fs_i_new_cotizacion_p>-posicion.

        ENDIF.

* *****************SEGUNDA DE LA PRIMERA TABLA*********************** *
        IF <fs_i_new_cotizacion_p>-condp EQ '1'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

        ELSEIF <fs_i_new_cotizacion_p>-condp EQ '2'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = - <fs_i_new_cotizacion_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

        ELSEIF <fs_i_new_cotizacion_p>-condp EQ '3'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_cotizacion_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

        ELSEIF <fs_i_new_cotizacion_p>-condp EQ '4'.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_cotizacion_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_cotizacion_p>-importe_decuento.
          READ TABLE lt_desc_dinamic INTO DATA(lwa_data) WITH KEY kschl = <fs_i_new_cotizacion_p>-condicion_descuento.
          IF sy-subrc = 0.
            IF lwa_data-knega = 'X'."Negativo
              <fs_quotation_conditions_in>-cond_value = - <fs_quotation_conditions_in>-cond_value.
            ENDIF.
          ENDIF.
          <fs_quotation_conditions_in>-currency = <fs_i_new_cotizacion_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

        ENDIF.


* *******************TERCERA DE LA PRIMERA TABLA********************* *
        IF lv_posicion <> <fs_i_new_cotizacion_p>-posicion.
          lv_posicion = <fs_i_new_cotizacion_p>-posicion.
          APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
          <fs_quotation_schedules_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_quotation_schedules_in>-req_date = <fs_i_new_cotizacion_h>-fecha_precio.
          <fs_quotation_schedules_in>-req_qty = <fs_i_new_cotizacion_p>-cantidad.

* *********************CUARTA DE LA PRIMERA TABLA******************** *
          APPEND INITIAL LINE TO lt_order_items_in ASSIGNING <fs_order_items_in>.
          <fs_order_items_in>-pmnttrms = <fs_i_new_cotizacion_h>-condicion_pago.
          <fs_order_items_in>-sales_dist = <fs_i_new_cotizacion_h>-zona_venta.
          <fs_order_items_in>-itm_number = <fs_i_new_cotizacion_p>-posicion.
          <fs_order_items_in>-po_itm_no = <fs_i_new_cotizacion_p>-posicion.
          <fs_order_items_in>-material = <fs_i_new_cotizacion_p>-articulo.
          <fs_order_items_in>-batch = <fs_i_new_cotizacion_p>-lote.
          <fs_order_items_in>-plant = <fs_i_new_cotizacion_p>-centro.
          <fs_order_items_in>-target_qty = <fs_i_new_cotizacion_p>-cantidad.
          <fs_order_items_in>-target_qu = <fs_i_new_cotizacion_p>-unidad_medida.
*          <fs_order_items_in>-item_categ = 'AGN'."DELETE @0100 Caso programacion stock y almacen
          <fs_order_items_in>-gross_wght = <fs_i_new_cotizacion_p>-peso_neto.
          <fs_order_items_in>-net_weight = <fs_i_new_cotizacion_p>-peso_neto.
          <fs_order_items_in>-untof_wght = 'KG'.
          <fs_order_items_in>-route = <fs_i_new_cotizacion_p>-ruta.
          <fs_order_items_in>-po_quan = <fs_i_new_cotizacion_p>-cantidad.
          <fs_order_items_in>-store_loc = <fs_i_new_cotizacion_p>-almacen.
          <fs_order_items_in>-reason_rej = <fs_i_new_cotizacion_p>-motivo_rechazo.
          <fs_order_items_in>-sales_unit = <fs_i_new_cotizacion_p>-unidad_medida.
          IF <fs_i_new_cotizacion_p>-tipo_posc IS NOT INITIAL.
            <fs_order_items_in>-ref_1 = <fs_i_new_cotizacion_p>-tipo_posc.
          ELSE.
            <fs_order_items_in>-ref_1 = 'AGN'.
          ENDIF.
          APPEND INITIAL LINE TO lt_order_item_inx ASSIGNING <fs_order_item_inx>.
          <fs_order_item_inx>-itm_number = <fs_order_items_in>-itm_number.
          <fs_order_item_inx>-updateflag = 'I'.

        ENDIF.

      ENDLOOP.

*/ Insertar datos nuevamente de cada línea
      TRY.  "

          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = lv_salesdocument
              simulation       = 'X'
              order_header_in  = ls_order_header_in
              order_header_inx = ls_order_header_inx
              logic_switch     = ls_logic_switch
            TABLES
              return           = lt_returnbp
              order_item_in    = lt_order_items_in
              order_item_inx   = lt_order_item_inx
*             partners         = lt_quotation_partners
              partnerchanges   = lt_partnerchanges
              schedule_lines   = lt_quotation_schedules_in
              conditions_in    = lt_quotation_conditions_in
              order_text       = lt_quotation_text
              extensionin      = lt_extensionin
              partneraddresses = lt_partneraddresses.

          READ TABLE lt_returnbp ASSIGNING <fs_returnbp> WITH KEY type = 'E'.
          IF sy-subrc = 0.

            LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.
              CASE <fs_returnbp>-number.
                WHEN '122'.
                  CONCATENATE 'Destinatario de Factura no actualizado en el área de Ventas: '
                  ls_order_header_in-sales_org
                  ls_order_header_in-distr_chan
                  ls_order_header_in-division INTO <fs_returnbp>-message SEPARATED BY space.
                WHEN OTHERS.
              ENDCASE.
              CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.
            ENDLOOP.
            EXIT.
          ELSE.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

            TRY.
                DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
                FREE lt_order_item_inx.
                CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
                  EXPORTING
                    salesdocument    = lv_salesdocument
                    order_header_in  = ls_order_header_in
                    order_header_inx = ls_order_header_inx
                    logic_switch     = ls_logic_switch
                  TABLES
                    return           = lt_returnbp
                    order_item_in    = lt_order_items_in
                    order_item_inx   = lt_order_item_inx
*                   partners         = lt_quotation_partners
                    partnerchanges   = lt_partnerchanges
                    schedule_lines   = lt_quotation_schedules_in
                    conditions_in    = lt_quotation_conditions_in
                    order_text       = lt_quotation_text
                    extensionin      = lt_extensionin
                    partneraddresses = lt_partneraddresses.

                READ TABLE lt_returnbp ASSIGNING <fs_returnbp> WITH KEY type = 'E'.
                IF sy-subrc <> 0.

                  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                    EXPORTING
                      wait = 'X'.
                ELSE.
                  LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.
                    CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.
                  ENDLOOP.
                ENDIF.

              CATCH cx_sy_zerodivide INTO go_error.

                lv_errorch = go_error->get_text( ).

                lv_error = 'X'.

            ENDTRY.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

      IF lv_salesdocument IS NOT INITIAL AND lv_errorbp IS INITIAL.

        rt_return-message = 'Se realizó la modificación de la cotizacion exitosamente'.
        rt_return-messcode = '200'.
        rt_return-data = lv_salesdocument.

      ELSE.

        IF lv_errorbp IS NOT INITIAL.

          CONCATENATE 'Cotizacion con Error : ' lv_errorbp INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.

          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        ELSEIF lv_error IS NOT INITIAL.

          CONCATENATE 'Cotizacion con CATCH en la bapi : ' lv_errorch INTO lv_message.

          rt_return-message = lv_message.
          rt_return-messcode = '400'.

        ENDIF.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      ENDIF.

*/ Clear varibles
      CLEAR: lv_salesdocument, gv_haydiferencias.

    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_PEDIDO_FACTURA_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_PF_H                     TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_PF_P                     TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_pedido_factura_i.

    TYPES: BEGIN OF gy_pa0001, "Registro maestro de personal Infotipo 0001 (Asignac.organ.)
             uname TYPE  pa0001-uname, "USUARIO
             pernr TYPE  pa0001-pernr, "CODIGO DE SOLICITANTE
             bukrs TYPE  pa0001-bukrs, "SOCIEDAD
             btrtl TYPE  pa0001-btrtl, "Subdivisión de personal
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_knvv, "Maestro de clientes datos comerciales
             kunnr TYPE  knvv-kunnr, "NUMERO DE CLIENTE
             kdgrp TYPE  knvv-kdgrp, "Grupo de clientes
             bzirk TYPE  knvv-bzirk, "Zona de ventas
             pltyp TYPE  knvv-pltyp, "Tipo de lista de precios
             konda TYPE  knvv-konda, "Grupo de precio de cliente
             waers TYPE  knvv-waers, "Moneda
             spart TYPE  knvv-spart, "SECTOR
           END OF gy_knvv.

    TYPES: BEGIN OF gy_tvau_auart_vko,
             auart TYPE  tvau_auart_vko-auart, "Clase de documento de ventas
             augru TYPE  tvau_auart_vko-augru, "Motivo de pedido (motivo de la operación)
           END OF gy_tvau_auart_vko.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_zparametros, "Condiciones de variantes/TABLAS DE PARAMETROS
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, "Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             doc_type_f  TYPE ysd_t001_paramet-doc_type_f,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi, "Pto.exped./depto.entrada mcía.
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_tvak, "Documentos ventas: Clases
             auart TYPE  tvak-auart, "Clase de documento de ventas
             vbtyp TYPE  tvak-vbtyp, "Tipo de documento comercial
           END OF gy_tvak.

    DATA: lt_pa0001         TYPE TABLE OF gy_pa0001,
          lt_knvv           TYPE TABLE OF gy_knvv,
          lt_tvau_auart_vko TYPE TABLE OF gy_tvau_auart_vko,
          lt_kna1           TYPE TABLE OF gy_kna1,
          lt_kna12          TYPE TABLE OF gy_kna1,
          lt_tvak           TYPE TABLE OF gy_tvak,
          lt_zparametros    TYPE TABLE OF gy_zparametros.

    DATA: ls_quotation_header_in       TYPE bapisdhd1,
          lt_quotation_items_in        TYPE TABLE OF bapisditm,
          lt_quotation_partners        TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in   TYPE TABLE OF bapicond,
          lt_quotation_schedules_in    TYPE TABLE OF bapischdl,
          lt_quotation_text            TYPE TABLE OF bapisdtext,
          lt_quotation_conditions_inx2 TYPE TABLE OF bapicondx,
          lv_salesdocument             TYPE bapivbeln-vbeln,
          lv_documento                 TYPE bapivbeln-vbeln,
          lt_returnbp                  TYPE TABLE OF bapiret2,
          lt_i_new_pf_h                LIKE i_new_pf_h,
          lt_et_created_hus            TYPE TABLE OF vekpvb,
          lv_centro                    TYPE werks_ext,
          lv_salida                    TYPE string,
          lv_salidah                   TYPE string,
          lv_message                   TYPE string,
          lv_error                     TYPE c,
          go_error                     TYPE REF TO cx_root,
          lv_errorch                   TYPE string,
          lv_errorbp                   TYPE string,
          lv_msj                       TYPE string,
          lv_material                  TYPE mara-matnr,
          lv_unidad                    TYPE meins,
          lv_usuario                   TYPE sy-uname,
          lv_cliente                   TYPE c,
          lv_destina                   TYPE c,
          lv_commit                    TYPE rvsel-xfeld,
          lv_text_line                 TYPE tdline.

    DATA: ls_quotation_header_in2     TYPE bapisdhd1,
          lt_quotation_items_in2      TYPE TABLE OF bapisditm,
          lt_quotation_partners2      TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in2 TYPE TABLE OF bapicond,
          lv_salesdocument2           TYPE bapivbeln-vbeln,
          lv_errorbp2                 TYPE bapi_msg,
          lt_returnbp2                TYPE TABLE OF bapiret2.

    DATA:     lt_partneraddresses        TYPE TABLE OF bapiaddr1.
    FIELD-SYMBOLS: <fs_partneraddresses> LIKE LINE OF lt_partneraddresses.

    FIELD-SYMBOLS: <fs_quotation_items_in2>      LIKE LINE OF lt_quotation_items_in2,
                   <fs_quotation_partners2>      LIKE LINE OF lt_quotation_partners2,
                   <fs_quotation_conditions_in2> LIKE LINE OF lt_quotation_conditions_in2,
                   <fs_returnbp2>                LIKE LINE OF lt_returnbp2.

    FIELD-SYMBOLS: <fs_quotation_items_in>        LIKE LINE OF lt_quotation_items_in,
                   <fs_quotation_partners>        LIKE LINE OF lt_quotation_partners,
                   <fs_quotation_conditions_in>   LIKE LINE OF lt_quotation_conditions_in,
                   <fs_quotation_schedules_in>    LIKE LINE OF lt_quotation_schedules_in,
                   <fs_quotation_conditions_inx2> LIKE LINE OF lt_quotation_conditions_inx2,
                   <fs_quotation_text>            LIKE LINE OF lt_quotation_text,
                   <fs_returnbp>                  LIKE LINE OF lt_returnbp,
                   <fs_i_new_pf_h>                LIKE LINE OF i_new_pf_h,
                   <fs_i_new_pf_p>                LIKE LINE OF i_new_pf_p,
                   <fs_pa0001>                    LIKE LINE OF lt_pa0001,
                   <fs_knvv>                      LIKE LINE OF lt_knvv,
                   <fs_tvau_auart_vko>            LIKE LINE OF lt_tvau_auart_vko,
                   <fs_kna1>                      LIKE LINE OF lt_kna1,
                   <fs_kna12>                     LIKE LINE OF lt_kna12,
                   <fs_tvak>                      LIKE LINE OF lt_tvak,
                   <fs_zparametros>               LIKE LINE OF lt_zparametros.

    TYPES: BEGIN OF gy_doc_ent,
             documento TYPE  vbak-vbeln,
             entrega   TYPE  likp-vbeln,
           END OF gy_doc_ent.

    DATA: lt_sales_order_items TYPE TABLE OF bapidlvreftosalesorder,
          lv_delivery          TYPE bapishpdelivnumb-deliv_numb,
          lv_num_deliveries    TYPE  bapidlvcreateheader-num_deliveries,
          lv_factura           TYPE bapivbrksuccess-bill_doc,
          ldt_return           TYPE string,
          lt_doc_ent           TYPE TABLE OF gy_doc_ent,
          lt_returnbp3         TYPE TABLE OF bapiret2,
          lv_errorbp3          TYPE string,
          lv_errorbp4          TYPE string,
          lv_errorbp6          TYPE string. "INSERT @0100

    DATA: ls_vbkok_wa  TYPE vbkok,
          lt_vbpok_tab TYPE TABLE OF vbpok.

    DATA: lt_string_components TYPE TABLE OF swastrtab,
          lv_input             TYPE  string.

    DATA: lv_ef_error_any   TYPE  xfeld,
          lv_item_deletion  TYPE  xfeld,
          lv_pod_update     TYPE  xfeld,
          lv_interface      TYPE  xfeld,
          lv_goods_issue    TYPE  xfeld,
          lv_final_check    TYPE  xfeld,
          lv_partner_update TYPE  xfeld,
          lv_sernr_update   TYPE  xfeld.

    FIELD-SYMBOLS: <fs_sales_order_items> LIKE LINE OF lt_sales_order_items,
                   <fs_doc_ent>           LIKE LINE OF lt_doc_ent,
                   <fs_returnbp3>         LIKE LINE OF lt_returnbp3,
                   <fs_vbpok_tab>         LIKE LINE OF lt_vbpok_tab.


    DATA: lt_billingdatain TYPE TABLE OF bapivbrk,
          lt_returnbp5     TYPE TABLE OF bapiret1,
          lt_success       TYPE TABLE OF bapivbrksuccess,
          lv_errorbp5      TYPE bapi_msg.


    FIELD-SYMBOLS: <fs_billingdatain> LIKE LINE OF lt_billingdatain,
                   <fs_success>       LIKE LINE OF lt_success,
                   <fs_returnbp5>     LIKE LINE OF lt_returnbp5.

    DATA: lv_fact        TYPE c,
          lv_nit         TYPE string,
          lv_nit2        TYPE string,
          lt_extensionin TYPE TABLE OF  bapiparex.

    FIELD-SYMBOLS:  <fs_extensionin> LIKE LINE OF lt_extensionin.

    DATA: ls_order_view           TYPE order_view,
          lt_sales_documents      TYPE TABLE OF sales_key,
          lt_order_headers_out    TYPE TABLE OF bapisdhd,
          lt_order_conditions_out TYPE TABLE OF bapisdcond,
          lv_net_val              TYPE bapicurext,
          lv_suma_iva             TYPE bapicurext,
          lv_total_sap            TYPE bapicurext,
          lv_total_fiori          TYPE p  DECIMALS  2,
          lv_diferencia(16)       TYPE p  DECIMALS  2,
          lt_conditions_in        TYPE TABLE OF bapicond,
          lt_conditions_inx       TYPE TABLE OF bapicondx,
          lt_return_change        TYPE TABLE OF bapiret2,
          ls_order_header_inx     TYPE bapisdh1x.
    DATA: lt_comparar TYPE STANDARD TABLE OF gty_comparar,
          ls_comparar LIKE LINE OF lt_comparar.

    FIELD-SYMBOLS: <fs_sales_documents>      LIKE LINE OF lt_sales_documents,
                   <fs_order_headers_out>    LIKE LINE OF lt_order_headers_out,
                   <fs_order_conditions_out> LIKE LINE OF lt_order_conditions_out,
                   <fs_conditions_in>        LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx>       LIKE LINE OF lt_conditions_inx.

    FIELD-SYMBOLS:  <fs_string>      LIKE LINE OF lt_string_components.

    DATA: lv_nombre1 TYPE char35,
          lv_nombre2 TYPE char35,
          lv_nombre3 TYPE char35,
          lv_nombre4 TYPE char35.

    lv_usuario = sy-uname.

    READ TABLE i_new_pf_h ASSIGNING <fs_i_new_pf_h> INDEX 1.
    IF sy-subrc EQ 0.
      lv_fact = <fs_i_new_pf_h>-fact.
    ENDIF.

    IF lv_fact EQ 'M'.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_pf_h
            WHERE indi_expedi = i_new_pf_h-motivo_expedicion
            AND facturacion = 'B' "Facturación manual
            AND vkorg = i_new_pf_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_pf_h
            WHERE indi_expedi = i_new_pf_h-motivo_expedicion
            AND facturacion = 'A'"Facturación normal
            AND vkorg = i_new_pf_h-organizacion_venta.

    ENDIF.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna1
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna12
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-bill_to.

    SELECT uname pernr bukrs btrtl
    FROM pa0001
    INTO TABLE lt_pa0001
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE uname EQ i_new_pf_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
    FROM knvv
    INTO TABLE lt_knvv
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-cliente.

******************************************************** CREAR EL PEDIDO ******************************************************************
*******************************************************************************************************************************************

    LOOP AT i_new_pf_h ASSIGNING <fs_i_new_pf_h>.
      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_pf_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

      CLEAR gv_sociedad.
      gv_sociedad = <fs_i_new_pf_h>-organizacion_venta.
      lv_documento = <fs_i_new_pf_h>-documento.

*/ Parámeters Get data SAP
      gs_order_view-partner = 'X'.
      APPEND INITIAL LINE TO gt_sales_documents ASSIGNING <fs_sales_documents>."Documento de cotización
      <fs_sales_documents>-vbeln = lv_documento.

      CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
        EXPORTING
          i_bapi_view        = gs_order_view
        TABLES
          sales_documents    = gt_sales_documents
          order_partners_out = gt_order_partners_out.

      READ TABLE gt_order_partners_out ASSIGNING FIELD-SYMBOL(<fs_order_partners_out>) WITH KEY partn_role = 'VE'.
      IF sy-subrc = 0.
        CLEAR gv_vendedor.
        gv_vendedor = <fs_order_partners_out>-person_no.
      ENDIF.

* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

      READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
      IF sy-subrc EQ 0.
        ls_quotation_header_in2-doc_type = <fs_zparametros>-doc_type_p.
        IF lv_fact EQ 'M'.
          ls_quotation_header_in2-ship_cond = '01'."//REPLACE@100"'03'.
        ELSE.
          ls_quotation_header_in2-ship_cond = <fs_i_new_pf_h>-motivo_expedicion.
        ENDIF.
      ENDIF.

      ls_quotation_header_in2-ord_reason = <fs_i_new_pf_h>-motivo_pedido.
      ls_quotation_header_in2-ref_doc = lv_documento.
      ls_quotation_header_in2-refdoc_cat = 'B'.
      ls_quotation_header_in2-sd_doc_cat = 'C'.
      ls_quotation_header_in2-sales_org = <fs_i_new_pf_h>-organizacion_venta.
      ls_quotation_header_in2-distr_chan = <fs_i_new_pf_h>-canal.
      ls_quotation_header_in2-division   = <fs_i_new_pf_h>-sector.
      ls_quotation_header_in2-sales_grp = <fs_i_new_pf_h>-grupo_vendedores.
      ls_quotation_header_in2-sales_off = <fs_i_new_pf_h>-oficina.
      ls_quotation_header_in2-req_date_h = <fs_i_new_pf_h>-fecha_entrega.
      ls_quotation_header_in2-price_date = sy-datum.
      ls_quotation_header_in2-qt_valid_t = <fs_i_new_pf_h>-fecha_oferta.
      ls_quotation_header_in2-purch_no_c = <fs_i_new_pf_h>-referencia_cliente.
      ls_quotation_header_in2-req_date_h = <fs_i_new_pf_h>-fecha_entrega.
      ls_quotation_header_in2-ct_valid_f = <fs_i_new_pf_h>-fecha_precio.
      ls_quotation_header_in2-ct_valid_t = <fs_i_new_pf_h>-fecha_oferta.

      ls_quotation_header_in2-sales_dist = <fs_i_new_pf_h>-zona_venta.
      ls_quotation_header_in2-pp_search = <fs_i_new_pf_h>-obra.
      ls_quotation_header_in2-pmnttrms = <fs_i_new_pf_h>-condicion_pago.
      lv_total_fiori = <fs_i_new_pf_h>-sub_total.
*  *********************************** LLENADO DE LA PRIMERA TABLA *******************************************************
      READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
      IF sy-subrc EQ 0.

        lv_cliente = <fs_kna1>-xcpdk.

      ENDIF.

      READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
      IF sy-subrc EQ 0.

        lv_destina = <fs_kna12>-xcpdk.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'AG'.
      <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      IF lv_cliente EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.

        CONCATENATE 'AG' <fs_i_new_pf_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.

        CONCATENATE 'RG' <fs_i_new_pf_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'RE'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'RE' <fs_i_new_pf_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_pf_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'RP'.
      <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'BU'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'WE'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'WE' <fs_i_new_pf_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'WE' <fs_i_new_pf_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'VE'.
      <fs_quotation_partners2>-partn_numb = gv_vendedor.

*   ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id = 'TX04'.
      <fs_quotation_text>-langu = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_pf_h>-coordenada.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_pf_h>-nota_envio.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id = 'TX14'.
        <fs_quotation_text>-langu = 'S'.
        <fs_quotation_text>-text_line = <fs_string>-str.
      ENDLOOP.

      LOOP AT i_new_pf_p ASSIGNING <fs_i_new_pf_p>.

        IF <fs_i_new_pf_p>-nota_fabricacion IS NOT INITIAL.

          CLEAR lv_input. FREE lt_string_components.

          lv_input = <fs_i_new_pf_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_pf_p>-posicion.
            <fs_quotation_text>-text_id = '0006'.
            <fs_quotation_text>-langu = 'S'.
            <fs_quotation_text>-text_line = <fs_string>-str.
          ENDLOOP.

        ENDIF.

*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
        <fs_quotation_schedules_in>-itm_number = <fs_i_new_pf_p>-posicion.
        <fs_quotation_schedules_in>-req_date = <fs_i_new_pf_h>-fecha_precio.
        <fs_quotation_schedules_in>-req_qty = <fs_i_new_pf_p>-cantidad.

*     ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
        IF <fs_i_new_pf_p>-condp EQ '1'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_pago.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_pago.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_pago.

        ELSEIF <fs_i_new_pf_p>-condp EQ '2'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-cond_unit = '%'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.

        ELSEIF <fs_i_new_pf_p>-condp EQ '3'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_pago.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_pago.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_pago.

          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-cond_unit = '%'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
        ELSEIF <fs_i_new_pf_p>-condp EQ '4'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.

        ENDIF.


*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************

        APPEND INITIAL LINE TO lt_quotation_items_in2 ASSIGNING <fs_quotation_items_in2>.
        <fs_quotation_items_in2>-pmnttrms = <fs_i_new_pf_h>-condicion_pago.
        <fs_quotation_items_in2>-sales_dist = <fs_i_new_pf_h>-zona_venta.
        <fs_quotation_items_in2>-ref_doc = lv_documento.
        <fs_quotation_items_in2>-ref_doc_it = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-ref_doc_ca = 'B'.
        <fs_quotation_items_in2>-itm_number = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-po_itm_no = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-material = <fs_i_new_pf_p>-articulo.
        <fs_quotation_items_in2>-batch = <fs_i_new_pf_p>-lote.
        <fs_quotation_items_in2>-plant = <fs_i_new_pf_p>-centro.
        <fs_quotation_items_in2>-target_qty = <fs_i_new_pf_p>-cantidad.
        <fs_quotation_items_in2>-target_qu = <fs_i_new_pf_p>-unidad_medida.
        <fs_quotation_items_in2>-gross_wght = <fs_i_new_pf_p>-peso_bruto.
        <fs_quotation_items_in2>-net_weight = <fs_i_new_pf_p>-peso_bruto.
        <fs_quotation_items_in2>-untof_wght = 'KG'.
        <fs_quotation_items_in2>-po_quan = <fs_i_new_pf_p>-cantidad.
        <fs_quotation_items_in2>-route = <fs_i_new_pf_p>-ruta.
        <fs_quotation_items_in2>-store_loc = <fs_i_new_pf_p>-almacen.
        <fs_quotation_items_in2>-reason_rej = <fs_i_new_pf_p>-motivo_rechazo.
        IF <fs_i_new_pf_p>-tipo_posc IS NOT INITIAL.
          <fs_quotation_items_in2>-item_categ = <fs_i_new_pf_p>-tipo_posc.
        ENDIF.

      ENDLOOP.


    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
    me->get_compara_cotizacion( EXPORTING i_tipofactura          = 'I'
                                          i_order_header_in      = ls_quotation_header_in2
                                          i_order_items_in       = lt_quotation_items_in2
                                          i_order_partners       = lt_quotation_partners2
                                          i_order_schedules_in   = lt_quotation_schedules_in
                                          i_order_conditions_in  = lt_quotation_conditions_in2
                                          i_order_conditions_inx = lt_quotation_conditions_inx2
                                          i_order_text           = lt_quotation_text
                                          i_extensionin          = lt_extensionin
                                          i_partneraddresses     = lt_partneraddresses
                                IMPORTING rt_response = lt_comparar ).
    READ TABLE lt_comparar INTO ls_comparar INDEX 1.
    IF sy-subrc = 0.
      IF ls_comparar-iguales <> 'X'.
        CONCATENATE 'Existen modificaciones pendientes por guardar. Primero modifique la cotización, luego cree la factura. Cotización: ' ls_quotation_header_in2-ref_doc INTO lv_message SEPARATED BY space.
        rt_return-message = lv_message && ` ` && ls_comparar-message.
        rt_return-messcode = '500'.
        CLEAR lv_message.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.

        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            order_header_in      = ls_quotation_header_in2
            convert              = ' '
          IMPORTING
            salesdocument        = lv_salesdocument2
          TABLES
            return               = lt_returnbp2
            order_items_in       = lt_quotation_items_in2
            order_partners       = lt_quotation_partners2
            order_schedules_in   = lt_quotation_schedules_in
            order_conditions_in  = lt_quotation_conditions_in2
            order_conditions_inx = lt_quotation_conditions_inx2
            order_text           = lt_quotation_text
            extensionin          = lt_extensionin
            partneraddresses     = lt_partneraddresses.


        IF lv_salesdocument2 IS INITIAL.

          LOOP AT lt_returnbp2 ASSIGNING <fs_returnbp2>.

            CONCATENATE lv_errorbp <fs_returnbp2>-type ' / ' <fs_returnbp2>-id ' / ' <fs_returnbp2>-number ' / ' <fs_returnbp2>-message ' - ' INTO lv_errorbp.

          ENDLOOP.

        ELSE.
*{REPLACE @0100
*          READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2> INDEX 1.
*          IF sy-subrc EQ 0.
*            lv_delivery = <fs_returnbp2>-message_v3.
*
*          ENDIF.
          READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2>
                               WITH KEY id     = 'V1'
                                        number = '260'. "Creó la entrega

          IF sy-subrc = 0.
            lv_delivery = <fs_returnbp2>-message_v3.
            lv_delivery = |{ lv_delivery  ALPHA = IN }| .
          ENDIF.
*}REPLACE @0100
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO 1 SECONDS.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorch = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.

    CLEAR: lv_diferencia, lv_total_sap, lv_net_val, lv_suma_iva, lt_conditions_in, lt_conditions_inx.

    IF lv_errorbp IS INITIAL AND lv_delivery IS INITIAL.
*
********************************************************* CREAR LA ENTREGA ******************************************************************
*********************************************************************************************************************************************

      IF lv_delivery IS  INITIAL.

        IF lt_returnbp IS NOT INITIAL.

          LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.

            CONCATENATE lv_errorbp2  <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / '
                       <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp2.

          ENDLOOP.
        ELSE.

          lv_errorbp2 = 'Error al crear la Entrega'.

        ENDIF.



      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        WAIT UP TO 1 SECONDS.

      ENDIF.

    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL.
*
**     ******************************************************* CREAR EL PICKING ******************************************************************
**     *******************************************************************************************************************************************
*
*
      LOOP AT i_new_pf_h ASSIGNING <fs_i_new_pf_h>.

        ls_vbkok_wa-vbeln_vl = lv_delivery.
        ls_vbkok_wa-vbeln = lv_delivery.
        ls_vbkok_wa-wabuc = 'X'.
        lv_commit = 'X'.
        gv_contador = 10.
        DATA(lt_i_new_pf_p) = i_new_pf_p[].
        DELETE ADJACENT DUPLICATES FROM lt_i_new_pf_p COMPARING posicion.
        LOOP AT lt_i_new_pf_p ASSIGNING <fs_i_new_pf_p> WHERE motivo_rechazo IS INITIAL.
          APPEND INITIAL LINE TO lt_vbpok_tab ASSIGNING <fs_vbpok_tab>.
          <fs_vbpok_tab>-vbeln_vl = lv_delivery.
          <fs_vbpok_tab>-vbeln = lv_delivery.
          <fs_vbpok_tab>-posnr_vl = <fs_vbpok_tab>-posnn = gv_contador.
          <fs_vbpok_tab>-pikmg = <fs_i_new_pf_p>-cantidad.
          gv_contador = gv_contador + 10.
        ENDLOOP.

      ENDLOOP.
      CLEAR gv_contador.

      TRY.

          CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
            EXPORTING
              vbkok_wa                  = ls_vbkok_wa
              commit                    = 'X'
              delivery                  = lv_delivery
              update_picking            = 'X'
              if_database_update_1      = '1'
              if_error_messages_send    = 'X'
            IMPORTING
              ef_error_any              = lv_ef_error_any
              ef_error_in_item_deletion = lv_item_deletion
              ef_error_in_pod_update    = lv_pod_update
              ef_error_in_interface     = lv_interface
              ef_error_in_goods_issue   = lv_goods_issue
              ef_error_in_final_check   = lv_final_check
              ef_error_partner_update   = lv_partner_update
              ef_error_sernr_update     = lv_partner_update
            TABLES
              vbpok_tab                 = lt_vbpok_tab.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO 1 SECONDS.

          IF lv_ef_error_any IS NOT INITIAL.

            CONCATENATE 'ERROR EN EL PICKING : ' lv_ef_error_any '-'  INTO lv_errorbp3.

          ELSE.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL. "

*     ******************************************************* CREAR LA FACTURA ******************************************************************
*     *******************************************************************************************************************************************

      LOOP AT i_new_pf_h ASSIGNING <fs_i_new_pf_h>.

        APPEND INITIAL LINE TO lt_billingdatain ASSIGNING <fs_billingdatain>.
        <fs_billingdatain>-doc_number = lv_delivery.
        <fs_billingdatain>-ref_doc = lv_delivery.
        <fs_billingdatain>-ref_doc_ca = 'J'.
        <fs_billingdatain>-bill_date = sy-datum.
        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          <fs_billingdatain>-ordbilltyp = <fs_zparametros>-doc_type_f.
        ENDIF.

      ENDLOOP.

      TRY.

          CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
            TABLES
              billingdatain = lt_billingdatain
              return        = lt_returnbp5
              success       = lt_success.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO '1' SECONDS.

          IF lt_success IS INITIAL.

            LOOP AT lt_returnbp5 ASSIGNING <fs_returnbp5>.

              CONCATENATE lv_errorbp4 <fs_returnbp5>-type ' / ' <fs_returnbp5>-id ' / ' <fs_returnbp5>-number ' / ' <fs_returnbp5>-message INTO lv_errorbp4.

            ENDLOOP.

          ELSE.

            READ TABLE lt_success ASSIGNING <fs_success> INDEX 1.
            IF sy-subrc EQ 0.

              lv_factura = <fs_success>-bill_doc.

              IMPORT ldt_return = ldt_return FROM MEMORY ID 'ZSD_PRINTMSJ'.

              READ TABLE lt_quotation_partners2 INTO DATA(lwa_quotation_partners2) WITH KEY partn_role = 'BU'.
              IF sy-subrc = 0 AND <fs_i_new_pf_p>-centro IS ASSIGNED.
                CALL METHOD ycl_sd_utilitys=>set_crearmsj_entrega
                  EXPORTING
                    ip_vbeln  = lv_delivery
                    ip_parnr  = lwa_quotation_partners2-partn_numb
                    ip_vstel  = ls_quotation_header_in2-sales_off
                    ip_werks  = <fs_i_new_pf_p>-centro
                  IMPORTING
                    ep_return = lv_errorbp6.
              ELSE.
                lv_errorbp6 = TEXT-e01.
              ENDIF.

            ENDIF.

            IF lt_returnbp5 IS NOT INITIAL.

              LOOP AT lt_returnbp5 ASSIGNING <fs_returnbp5>.

                CONCATENATE lv_msj <fs_returnbp5>-message INTO lv_msj.

              ENDLOOP.

            ENDIF.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_error IS INITIAL AND lv_errorbp2 IS INITIAL  AND lv_errorbp4 IS INITIAL AND lv_errorbp3 IS INITIAL.

      CONCATENATE 'DOCUMENTO PEDIDO: ' lv_salesdocument2 ' - ENTREGA: ' lv_delivery ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.
      CONCATENATE lv_salesdocument2 '-' lv_delivery '-' lv_factura INTO lv_salidah.

      IF lv_msj IS NOT INITIAL.

        CONCATENATE 'Se creo la Factura exitosamente -' 'con mensaje: ' lv_msj INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.
        rt_return-datah = lv_salidah.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        rt_return-message = 'Se creo la Factura exitosamente'.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ENDIF.

      rt_return-message = 'Se creo la Factura exitosamente'.
      rt_return-messcode = '200'.
      rt_return-data = lv_salida.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

    ELSE.

      CONCATENATE 'DOCUMENTO PEDIDO: ' lv_salesdocument2 ' - ENTREGA: ' lv_delivery ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.

      IF lv_errorbp IS NOT INITIAL.

        CONCATENATE 'Error en el pedido: ' lv_errorbp INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp2 IS NOT INITIAL.

        CONCATENATE 'Error en la Entrega : ' lv_errorbp2 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp3 IS NOT INITIAL.

        CONCATENATE 'Error en la Piking : ' lv_errorbp3 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp4 IS NOT INITIAL.

        CONCATENATE 'Error en la Factura : ' lv_errorbp4 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp6 IS NOT INITIAL.

        CONCATENATE 'Error msj en la Entrega : ' lv_errorbp6 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.


      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_PEDIDO_FACTURA_P
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_PF_H                     TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_PF_P                     TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_pedido_factura_p.

    TYPES: BEGIN OF gy_pa0001, "Registro maestro de personal Infotipo 0001 (Asignac.organ.)
             uname TYPE  pa0001-uname, "USUARIO
             pernr TYPE  pa0001-pernr, "CODIGO DE SOLICITANTE
             bukrs TYPE  pa0001-bukrs, "SOCIEDAD
             btrtl TYPE  pa0001-btrtl, "Subdivisión de personal
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_knvv, "Maestro de clientes datos comerciales
             kunnr TYPE  knvv-kunnr, "NUMERO DE CLIENTE
             kdgrp TYPE  knvv-kdgrp, "Grupo de clientes
             bzirk TYPE  knvv-bzirk, "Zona de ventas
             pltyp TYPE  knvv-pltyp, "Tipo de lista de precios
             konda TYPE  knvv-konda, "Grupo de precio de cliente
             waers TYPE  knvv-waers, "Moneda
             spart TYPE  knvv-spart, "SECTOR
           END OF gy_knvv.

    TYPES: BEGIN OF gy_tvau_auart_vko,
             auart TYPE  tvau_auart_vko-auart, "Clase de documento de ventas
             augru TYPE  tvau_auart_vko-augru, "Motivo de pedido (motivo de la operación)
           END OF gy_tvau_auart_vko.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_zparametros, "Condiciones de variantes/TABLAS DE PARAMETROS
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, "Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             doc_type_f  TYPE ysd_t001_paramet-doc_type_f,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi, "Pto.exped./depto.entrada mcía.
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_tvak, "Documentos ventas: Clases
             auart TYPE  tvak-auart, "Clase de documento de ventas
             vbtyp TYPE  tvak-vbtyp, "Tipo de documento comercial
           END OF gy_tvak.

    DATA: lt_pa0001         TYPE TABLE OF gy_pa0001,
          lt_knvv           TYPE TABLE OF gy_knvv,
          lt_tvau_auart_vko TYPE TABLE OF gy_tvau_auart_vko,
          lt_kna1           TYPE TABLE OF gy_kna1,
          lt_kna12          TYPE TABLE OF gy_kna1,
          lt_tvak           TYPE TABLE OF gy_tvak,
          lt_zparametros    TYPE TABLE OF gy_zparametros.

    DATA: ls_quotation_header_in     TYPE bapisdhd1,
          lt_quotation_items_in      TYPE TABLE OF bapisditm,
          lt_quotation_partners      TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in TYPE TABLE OF bapicond,
          lt_quotation_schedules_in  TYPE TABLE OF bapischdl,
          lt_quotation_text          TYPE TABLE OF bapisdtext,
          lv_salesdocument           TYPE bapivbeln-vbeln,
          lv_documento               TYPE bapivbeln-vbeln,
          lt_returnbp                TYPE TABLE OF bapiret2,
          lt_i_new_pf_h              LIKE i_new_pf_h,
          lt_et_created_hus          TYPE TABLE OF vekpvb,
          lv_centro                  TYPE werks_ext,
          lv_salida                  TYPE string,
          lv_salidah                 TYPE string,
          lv_message                 TYPE string,
          lv_error                   TYPE c,
          go_error                   TYPE REF TO cx_root,
          lv_errorch                 TYPE string,
          lv_errorbp                 TYPE string,
          lv_msj                     TYPE string,
          lv_material                TYPE mara-matnr,
          lv_unidad                  TYPE meins,
          lv_usuario                 TYPE sy-uname,
          lv_cliente                 TYPE c,
          lv_destina                 TYPE c,
          lv_commit                  TYPE rvsel-xfeld,
          lv_text_line               TYPE tdline.

    DATA:     lt_partneraddresses        TYPE TABLE OF bapiaddr1.
    FIELD-SYMBOLS: <fs_partneraddresses> LIKE LINE OF lt_partneraddresses.

    DATA: ls_quotation_header_in2      TYPE bapisdhd1,
          lt_quotation_items_in2       TYPE TABLE OF bapisditm,
          lt_quotation_partners2       TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in2  TYPE TABLE OF bapicond,
          lt_quotation_conditions_inx2 TYPE TABLE OF bapicondx,
          lv_salesdocument2            TYPE bapivbeln-vbeln,
          lv_errorbp2                  TYPE bapi_msg,
          lt_returnbp2                 TYPE TABLE OF bapiret2,
          lt_quotation_items_in2x      TYPE TABLE OF bapisditmx.

    FIELD-SYMBOLS: <fs_quotation_items_in2>       LIKE LINE OF lt_quotation_items_in2,
                   <fs_quotation_partners2>       LIKE LINE OF lt_quotation_partners2,
                   <fs_quotation_conditions_in2>  LIKE LINE OF lt_quotation_conditions_in2,
                   <fs_quotation_conditions_inx2> LIKE LINE OF lt_quotation_conditions_inx2,
                   <fs_returnbp2>                 LIKE LINE OF lt_returnbp2,
                   <fs_quotation_items_in2x>      LIKE LINE OF lt_quotation_items_in2x.

    FIELD-SYMBOLS: <fs_quotation_items_in>      LIKE LINE OF lt_quotation_items_in,
                   <fs_quotation_partners>      LIKE LINE OF lt_quotation_partners,
                   <fs_quotation_conditions_in> LIKE LINE OF lt_quotation_conditions_in,
                   <fs_quotation_schedules_in>  LIKE LINE OF lt_quotation_schedules_in,
                   <fs_quotation_text>          LIKE LINE OF lt_quotation_text,
                   <fs_returnbp>                LIKE LINE OF lt_returnbp,
                   <fs_i_new_pf_h>              LIKE LINE OF i_new_pf_h,
                   <fs_i_new_pf_p>              LIKE LINE OF i_new_pf_p,
                   <fs_pa0001>                  LIKE LINE OF lt_pa0001,
                   <fs_knvv>                    LIKE LINE OF lt_knvv,
                   <fs_tvau_auart_vko>          LIKE LINE OF lt_tvau_auart_vko,
                   <fs_kna1>                    LIKE LINE OF lt_kna1,
                   <fs_kna12>                   LIKE LINE OF lt_kna12,
                   <fs_tvak>                    LIKE LINE OF lt_tvak,
                   <fs_zparametros>             LIKE LINE OF lt_zparametros.

    TYPES: BEGIN OF gy_doc_ent,
             documento TYPE  vbak-vbeln,
             entrega   TYPE  likp-vbeln,
           END OF gy_doc_ent.

    DATA: lt_sales_order_items TYPE TABLE OF bapidlvreftosalesorder,
          lv_delivery          TYPE bapishpdelivnumb-deliv_numb,
          lv_num_deliveries    TYPE  bapidlvcreateheader-num_deliveries,
          lv_factura           TYPE bapivbrksuccess-bill_doc,
          ldt_return           TYPE string,
          lt_doc_ent           TYPE TABLE OF gy_doc_ent,
          lt_returnbp3         TYPE TABLE OF bapiret2,
          lv_errorbp3          TYPE string,
          lv_errorbp4          TYPE string.

    DATA: ls_vbkok_wa  TYPE vbkok,
          lt_vbpok_tab TYPE TABLE OF vbpok.

    DATA: lt_string_components TYPE TABLE OF swastrtab,
          lv_input             TYPE  string.

    DATA: lv_ef_error_any   TYPE  xfeld,
          lv_item_deletion  TYPE  xfeld,
          lv_pod_update     TYPE  xfeld,
          lv_interface      TYPE  xfeld,
          lv_goods_issue    TYPE  xfeld,
          lv_final_check    TYPE  xfeld,
          lv_partner_update TYPE  xfeld,
          lv_sernr_update   TYPE  xfeld.

    FIELD-SYMBOLS: <fs_sales_order_items> LIKE LINE OF lt_sales_order_items,
                   <fs_doc_ent>           LIKE LINE OF lt_doc_ent,
                   <fs_returnbp3>         LIKE LINE OF lt_returnbp3,
                   <fs_vbpok_tab>         LIKE LINE OF lt_vbpok_tab.


    DATA: lt_billingdatain TYPE TABLE OF bapivbrk,
          lt_returnbp5     TYPE TABLE OF bapiret1,
          lt_success       TYPE TABLE OF bapivbrksuccess,
          lv_errorbp5      TYPE bapi_msg.


    FIELD-SYMBOLS: <fs_billingdatain> LIKE LINE OF lt_billingdatain,
                   <fs_success>       LIKE LINE OF lt_success,
                   <fs_returnbp5>     LIKE LINE OF lt_returnbp5.

    DATA: lv_fact        TYPE c,
          lv_tipo        TYPE c,
          lv_nit         TYPE string,
          lv_nit2        TYPE string,
          lt_extensionin TYPE TABLE OF  bapiparex.

    FIELD-SYMBOLS:  <fs_extensionin> LIKE LINE OF lt_extensionin.

    DATA: ls_order_view           TYPE order_view,
          lt_sales_documents      TYPE TABLE OF sales_key,
          lt_order_headers_out    TYPE TABLE OF bapisdhd,
          lt_order_conditions_out TYPE TABLE OF bapisdcond,
          lv_net_val              TYPE bapicurext,
          lv_suma_iva             TYPE bapicurext,
          lv_total_sap            TYPE bapicurext,
          lv_total_fiori          TYPE p  DECIMALS  2,
          lv_diferencia(16)       TYPE p  DECIMALS  2,
          lt_conditions_in        TYPE TABLE OF bapicond,
          lt_conditions_inx       TYPE TABLE OF bapicondx,
          lt_return_change        TYPE TABLE OF bapiret2,
          ls_order_header_inx     TYPE bapisdh1x.
    DATA: lt_comparar TYPE STANDARD TABLE OF gty_comparar,
          ls_comparar LIKE LINE OF lt_comparar.

    FIELD-SYMBOLS: <fs_sales_documents>      LIKE LINE OF lt_sales_documents,
                   <fs_order_headers_out>    LIKE LINE OF lt_order_headers_out,
                   <fs_order_conditions_out> LIKE LINE OF lt_order_conditions_out,
                   <fs_conditions_in>        LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx>       LIKE LINE OF lt_conditions_inx.

    FIELD-SYMBOLS:  <fs_string>      LIKE LINE OF lt_string_components.

    DATA: lv_nombre1 TYPE char35,
          lv_nombre2 TYPE char35,
          lv_nombre3 TYPE char35,
          lv_nombre4 TYPE char35.

    lv_usuario = sy-uname.

    READ TABLE i_new_pf_h ASSIGNING <fs_i_new_pf_h> INDEX 1.
    IF sy-subrc EQ 0.
      lv_fact = <fs_i_new_pf_h>-fact.
      lv_tipo = <fs_i_new_pf_h>-tipo.
    ENDIF.

    IF lv_fact EQ 'M'.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_pf_h
            WHERE indi_expedi = i_new_pf_h-motivo_expedicion
            AND facturacion = 'B'"Facturación manual
            AND vkorg = i_new_pf_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_pf_h
            WHERE indi_expedi = i_new_pf_h-motivo_expedicion
            AND facturacion = 'A'"Facturación normal
            AND vkorg = i_new_pf_h-organizacion_venta.
    ENDIF.


    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna1
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna12
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-bill_to.

    SELECT uname pernr bukrs btrtl
    FROM pa0001
    INTO TABLE lt_pa0001
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE uname EQ i_new_pf_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
    FROM knvv
    INTO TABLE lt_knvv
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE kunnr EQ i_new_pf_h-cliente.

    SELECT auart augru
    FROM tvau_auart_vko
    INTO TABLE lt_tvau_auart_vko
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE auart EQ i_new_pf_h-clase_documento.

    SELECT auart vbtyp
    FROM tvak
    INTO TABLE lt_tvak
    FOR ALL ENTRIES IN i_new_pf_h
    WHERE auart EQ i_new_pf_h-clase_documento.

*************************************************** CREAR EL PEDIDO ******************************************************************
******************************************************************************************************************************************

    LOOP AT i_new_pf_h ASSIGNING <fs_i_new_pf_h>.
      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_pf_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

      CLEAR gv_sociedad.
      gv_sociedad = <fs_i_new_pf_h>-organizacion_venta.

      lv_documento = <fs_i_new_pf_h>-documento.

*/ Parámeters Get data SAP
      gs_order_view-partner = 'X'.
      APPEND INITIAL LINE TO gt_sales_documents ASSIGNING <fs_sales_documents>."Documento de cotización
      <fs_sales_documents>-vbeln = lv_documento.

      CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
        EXPORTING
          i_bapi_view        = gs_order_view
        TABLES
          sales_documents    = gt_sales_documents
          order_partners_out = gt_order_partners_out.

      READ TABLE gt_order_partners_out ASSIGNING FIELD-SYMBOL(<fs_order_partners_out>) WITH KEY partn_role = 'VE'.
      IF sy-subrc = 0.
        CLEAR gv_vendedor.
        gv_vendedor = <fs_order_partners_out>-person_no.
      ENDIF.

* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

      READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
      IF sy-subrc EQ 0.
        ls_quotation_header_in2-doc_type = <fs_zparametros>-doc_type_p.
        IF lv_fact EQ 'M'.
          IF lv_tipo EQ 'P'.
            ls_quotation_header_in2-ship_cond = <fs_i_new_pf_h>-motivo_expedicion.
          ELSEIF lv_tipo EQ 'R'.
            ls_quotation_header_in2-ship_cond = '02'.
          ENDIF.
        ELSE.
          ls_quotation_header_in2-ship_cond = <fs_i_new_pf_h>-motivo_expedicion.
        ENDIF.
      ENDIF.

      ls_quotation_header_in2-ord_reason = <fs_i_new_pf_h>-motivo_pedido.
      ls_quotation_header_in2-ref_doc = lv_documento.
      ls_quotation_header_in2-refdoc_cat = 'B'.
      ls_quotation_header_in2-sd_doc_cat = 'C'.
      ls_quotation_header_in2-sales_org = <fs_i_new_pf_h>-organizacion_venta.
      ls_quotation_header_in2-distr_chan = <fs_i_new_pf_h>-canal.
      ls_quotation_header_in2-division   = <fs_i_new_pf_h>-sector.
      ls_quotation_header_in2-sales_grp = <fs_i_new_pf_h>-grupo_vendedores.
      ls_quotation_header_in2-sales_off = <fs_i_new_pf_h>-oficina.
      ls_quotation_header_in2-req_date_h = <fs_i_new_pf_h>-fecha_entrega.
      ls_quotation_header_in2-price_date = sy-datum.
      ls_quotation_header_in2-qt_valid_t = <fs_i_new_pf_h>-fecha_oferta.
      ls_quotation_header_in2-purch_no_c = <fs_i_new_pf_h>-referencia_cliente.
      ls_quotation_header_in2-req_date_h = <fs_i_new_pf_h>-fecha_entrega.
      ls_quotation_header_in2-ct_valid_f = <fs_i_new_pf_h>-fecha_precio.
      ls_quotation_header_in2-ct_valid_t = <fs_i_new_pf_h>-fecha_oferta.

      ls_quotation_header_in2-sales_dist = <fs_i_new_pf_h>-zona_venta.
      ls_quotation_header_in2-pp_search = <fs_i_new_pf_h>-obra.
      ls_quotation_header_in2-pmnttrms = <fs_i_new_pf_h>-condicion_pago.
      lv_total_fiori = <fs_i_new_pf_h>-sub_total.
*  *********************************** LLENADO DE LA PRIMERA TABLA *******************************************************
      READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
      IF sy-subrc EQ 0.

        lv_cliente = <fs_kna1>-xcpdk.

      ENDIF.

      READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
      IF sy-subrc EQ 0.

        lv_destina = <fs_kna12>-xcpdk.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'AG'.
      <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      IF lv_cliente EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        CONCATENATE 'AG' <fs_i_new_pf_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.
        CONCATENATE 'RG' <fs_i_new_pf_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'RE'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'RE' <fs_i_new_pf_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_pf_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'RP'.
      <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'BU'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'WE'.
      IF <fs_i_new_pf_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-bill_to.
      ELSE.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_pf_h>-cliente.

      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners2>-name = lv_nombre1.
        <fs_quotation_partners2>-name_2 = lv_nombre2.
        <fs_quotation_partners2>-name_3 = lv_nombre3.
        <fs_quotation_partners2>-name_4 = lv_nombre4.
        <fs_quotation_partners2>-street = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-city = <fs_i_new_pf_h>-direccion3.
        <fs_quotation_partners2>-telephone = <fs_i_new_pf_h>-telefono.
        <fs_quotation_partners2>-country = <fs_i_new_pf_h>-pais.
        <fs_quotation_partners2>-langu   = 'S'.
        <fs_quotation_partners2>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street_lng = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_pf_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_pf_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_pf_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'WE' <fs_i_new_pf_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'WE' <fs_i_new_pf_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
      <fs_quotation_partners2>-partn_role = 'VE'.
      <fs_quotation_partners2>-partn_numb = gv_vendedor.

*   ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id = 'TX04'.
      <fs_quotation_text>-langu = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_pf_h>-coordenada.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_pf_h>-nota_envio.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id = 'TX14'.
        <fs_quotation_text>-langu = 'S'.
        <fs_quotation_text>-text_line = <fs_string>-str.
      ENDLOOP.

      LOOP AT i_new_pf_p ASSIGNING <fs_i_new_pf_p>.

        IF <fs_i_new_pf_p>-nota_fabricacion IS NOT INITIAL.

          CLEAR lv_input. FREE lt_string_components.

          lv_input = <fs_i_new_pf_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_pf_p>-posicion.
            <fs_quotation_text>-text_id = '0006'.
            <fs_quotation_text>-langu = 'S'.
            <fs_quotation_text>-text_line = <fs_string>-str.
          ENDLOOP.

        ENDIF.

*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
        <fs_quotation_schedules_in>-itm_number = <fs_i_new_pf_p>-posicion.
        <fs_quotation_schedules_in>-req_date = <fs_i_new_pf_h>-fecha_precio.
        <fs_quotation_schedules_in>-req_qty = <fs_i_new_pf_p>-cantidad.

*     ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
        IF <fs_i_new_pf_p>-condp EQ '1'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_pago.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_pago.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_pago.

        ELSEIF <fs_i_new_pf_p>-condp EQ '2'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-cond_unit = '%'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.

        ELSEIF <fs_i_new_pf_p>-condp EQ '3'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_pago.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_pago.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_pago.

          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-cond_unit = '%'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
        ELSEIF <fs_i_new_pf_p>-condp EQ '4'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
          <fs_quotation_conditions_in2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_in2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.
          <fs_quotation_conditions_in2>-cond_value = <fs_i_new_pf_p>-importe_decuento.
          <fs_quotation_conditions_in2>-currency = <fs_i_new_pf_h>-moneda.
          <fs_quotation_conditions_in2>-calctypcon = 'B'.
          IF <fs_i_new_pf_p>-motivo_rechazo IS NOT INITIAL.
            <fs_quotation_conditions_in2>-condisacti = 'W'.
          ENDIF.
          APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
          <fs_quotation_conditions_inx2>-updateflag = 'I'.
          <fs_quotation_conditions_inx2>-cond_value = 'X'.
          <fs_quotation_conditions_inx2>-currency = 'X'.
          <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_pf_p>-posicion.
          <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_pf_p>-condicion_descuento.

        ENDIF.


*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************

        APPEND INITIAL LINE TO lt_quotation_items_in2 ASSIGNING <fs_quotation_items_in2>.
        <fs_quotation_items_in2>-pmnttrms = <fs_i_new_pf_h>-condicion_pago.
        <fs_quotation_items_in2>-sales_dist = <fs_i_new_pf_h>-zona_venta.
        <fs_quotation_items_in2>-ref_doc = lv_documento.
        <fs_quotation_items_in2>-ref_doc_it = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-ref_doc_ca = 'B'.
        <fs_quotation_items_in2>-itm_number = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-po_itm_no = <fs_i_new_pf_p>-posicion.
        <fs_quotation_items_in2>-material = <fs_i_new_pf_p>-articulo.
        <fs_quotation_items_in2>-batch = <fs_i_new_pf_p>-lote.
        <fs_quotation_items_in2>-plant = <fs_i_new_pf_p>-centro.
        <fs_quotation_items_in2>-target_qty = <fs_i_new_pf_p>-cantidad.
        <fs_quotation_items_in2>-target_qu = <fs_i_new_pf_p>-unidad_medida.
        <fs_quotation_items_in2>-gross_wght = <fs_i_new_pf_p>-peso_bruto.
        <fs_quotation_items_in2>-net_weight = <fs_i_new_pf_p>-peso_bruto.
        <fs_quotation_items_in2>-untof_wght = 'KG'.
        <fs_quotation_items_in2>-po_quan = <fs_i_new_pf_p>-cantidad.
        <fs_quotation_items_in2>-route = <fs_i_new_pf_p>-ruta.
        <fs_quotation_items_in2>-reason_rej = <fs_i_new_pf_p>-motivo_rechazo.
        IF <fs_i_new_pf_p>-tipo_posc IS NOT INITIAL.
          <fs_quotation_items_in2>-item_categ = <fs_i_new_pf_p>-tipo_posc.
        ENDIF.
      ENDLOOP.

    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
    me->get_compara_cotizacion( EXPORTING i_tipofactura          = 'P'
                                          i_order_header_in      = ls_quotation_header_in2
                                          i_order_items_in       = lt_quotation_items_in2
                                          i_order_partners       = lt_quotation_partners2
                                          i_order_schedules_in   = lt_quotation_schedules_in
                                          i_order_conditions_in  = lt_quotation_conditions_in2
                                          i_order_conditions_inx = lt_quotation_conditions_inx2
                                          i_order_text           = lt_quotation_text
                                          i_extensionin          = lt_extensionin
                                          i_partneraddresses     = lt_partneraddresses
                                IMPORTING rt_response = lt_comparar ).
    READ TABLE lt_comparar INTO ls_comparar INDEX 1.
    IF sy-subrc = 0.
      IF ls_comparar-iguales <> 'X'.
        CONCATENATE 'Existen modificaciones pendientes por guardar. Primero modifique la cotización, luego cree la factura. Cotización: ' ls_quotation_header_in2-ref_doc INTO lv_message SEPARATED BY space.
        rt_return-message = lv_message && `. ` && ls_comparar-message.
        rt_return-messcode = '500'.
        CLEAR lv_message.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.

        DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            order_header_in      = ls_quotation_header_in2
            convert              = ' '
          IMPORTING
            salesdocument        = lv_salesdocument2
          TABLES
            return               = lt_returnbp2
            order_items_in       = lt_quotation_items_in2
            order_items_inx      = lt_quotation_items_in2x
            order_partners       = lt_quotation_partners2
            order_schedules_in   = lt_quotation_schedules_in
            order_conditions_in  = lt_quotation_conditions_in2
            order_conditions_inx = lt_quotation_conditions_inx2
            order_text           = lt_quotation_text
            extensionin          = lt_extensionin
            partneraddresses     = lt_partneraddresses.

        IF lv_salesdocument2 IS INITIAL.

          LOOP AT lt_returnbp2 ASSIGNING <fs_returnbp2>.

            CONCATENATE lv_errorbp <fs_returnbp2>-type ' / ' <fs_returnbp2>-id ' / ' <fs_returnbp2>-number ' / ' <fs_returnbp2>-message ' - ' INTO lv_errorbp.

          ENDLOOP.

        ELSE.

*{REPLACE @0100
*          READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2> INDEX 1.
*          IF sy-subrc EQ 0.
*            lv_delivery = <fs_returnbp2>-message_v3.
*
*          ENDIF.
          READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2>
                               WITH KEY id     = 'V1'
                                        number = '260'. "Creó la entrega

          IF sy-subrc = 0.
            lv_delivery = <fs_returnbp2>-message_v3.
            lv_delivery = |{ lv_delivery  ALPHA = IN }| .
          ENDIF.
*}REPLACE @0100

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO 1 SECONDS.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorch = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.

    CLEAR: lv_diferencia, lv_total_sap, lv_net_val, lv_suma_iva, lt_conditions_in, lt_conditions_inx.

    IF lv_errorbp IS INITIAL.

*     ******************************************************* CREAR LA FACTURA ******************************************************************
*     *******************************************************************************************************************************************

      LOOP AT i_new_pf_h ASSIGNING <fs_i_new_pf_h>.

        APPEND INITIAL LINE TO lt_billingdatain ASSIGNING <fs_billingdatain>.
        <fs_billingdatain>-doc_number = lv_salesdocument2.
        <fs_billingdatain>-ref_doc = lv_salesdocument2.
        <fs_billingdatain>-ref_doc_ca = 'C'.
        <fs_billingdatain>-bill_date = sy-datum.
        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          <fs_billingdatain>-ordbilltyp = <fs_zparametros>-doc_type_f.
        ENDIF.

      ENDLOOP.

      TRY.

          CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
            TABLES
              billingdatain = lt_billingdatain
              return        = lt_returnbp5
              success       = lt_success.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO '0.5' SECONDS.

          IF lt_success IS INITIAL.

            LOOP AT lt_returnbp5 ASSIGNING <fs_returnbp5>.

              CONCATENATE lv_errorbp4 <fs_returnbp5>-type ' / ' <fs_returnbp5>-id ' / ' <fs_returnbp5>-number ' / ' <fs_returnbp5>-message INTO lv_errorbp4.

            ENDLOOP.

          ELSE.

            READ TABLE lt_success ASSIGNING <fs_success> INDEX 1.
            IF sy-subrc EQ 0.

              lv_factura = <fs_success>-bill_doc.

              IMPORT ldt_return = ldt_return FROM MEMORY ID 'ZSD_PRINTMSJ'.

            ENDIF.

            IF lt_returnbp5 IS NOT INITIAL.

              LOOP AT lt_returnbp5 ASSIGNING <fs_returnbp5>.

                CONCATENATE lv_msj <fs_returnbp5>-message INTO lv_msj.

              ENDLOOP.

            ENDIF.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_errorbp4 IS INITIAL.

      CONCATENATE 'DOCUMENTO PEDIDO: ' lv_salesdocument2 ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.
      CONCATENATE lv_salesdocument2 '-' lv_factura INTO lv_salidah.

      IF lv_msj IS NOT INITIAL.

        CONCATENATE 'Se creo la Factura exitosamente -' 'con mensaje: ' lv_msj INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.
        rt_return-datah = lv_salidah.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        rt_return-message = 'Se creo la Factura exitosamente'.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ENDIF.

      rt_return-message = 'Se creo la Factura exitosamente'.
      rt_return-messcode = '200'.
      rt_return-data = lv_salida.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

    ELSE.

      CONCATENATE 'DOCUMENTO PEDIDO: ' lv_salesdocument2  ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.

      IF lv_errorbp IS NOT INITIAL.

        CONCATENATE 'Error en el pedido: ' lv_errorbp INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp4 IS NOT INITIAL.

        CONCATENATE 'Error en la Factura : ' lv_errorbp4 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_VENTA_INMEDIATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_VENTAI_H                 TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_VENTAI_P                 TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_venta_inmediata.

    TYPES: BEGIN OF gy_pa0001, "Registro maestro de personal Infotipo 0001 (Asignac.organ.)
             uname TYPE  pa0001-uname, "USUARIO
             pernr TYPE  pa0001-pernr, "CODIGO DE SOLICITANTE
             bukrs TYPE  pa0001-bukrs, "SOCIEDAD
             btrtl TYPE  pa0001-btrtl, "Subdivisión de personal
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_knvv, "Maestro de clientes datos comerciales
             kunnr TYPE  knvv-kunnr, "NUMERO DE CLIENTE
             kdgrp TYPE  knvv-kdgrp, "Grupo de clientes
             bzirk TYPE  knvv-bzirk, "Zona de ventas
             pltyp TYPE  knvv-pltyp, "Tipo de lista de precios
             konda TYPE  knvv-konda, "Grupo de precio de cliente
             waers TYPE  knvv-waers, "Moneda
             spart TYPE  knvv-spart, "SECTOR
           END OF gy_knvv.

    TYPES: BEGIN OF gy_tvau_auart_vko,
             auart TYPE  tvau_auart_vko-auart, "Clase de documento de ventas
             augru TYPE  tvau_auart_vko-augru, "Motivo de pedido (motivo de la operación)
           END OF gy_tvau_auart_vko.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_zparametros, "Condiciones de variantes/TABLAS DE PARAMETROS
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, "Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             doc_type_f  TYPE ysd_t001_paramet-doc_type_f,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi, "Pto.exped./depto.entrada mcía.
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_tvak, "Documentos ventas: Clases
             auart TYPE  tvak-auart, "Clase de documento de ventas
             vbtyp TYPE  tvak-vbtyp, "Tipo de documento comercial
           END OF gy_tvak.

    DATA: lt_pa0001         TYPE TABLE OF gy_pa0001,
          lt_knvv           TYPE TABLE OF gy_knvv,
          lt_tvau_auart_vko TYPE TABLE OF gy_tvau_auart_vko,
          lt_kna1           TYPE TABLE OF gy_kna1,
          lt_tvak           TYPE TABLE OF gy_tvak,
          lt_kna12          TYPE TABLE OF gy_kna1,
          lt_zparametros    TYPE TABLE OF gy_zparametros,
          lt_zparametros2   TYPE TABLE OF gy_zparametros,
          lv_cliente        TYPE c,
          lv_destina        TYPE c,
          lv_text_line      TYPE tdline,
          lv_nit            TYPE string,
          lv_nit2           TYPE string.

    DATA:     lt_partneraddresses        TYPE TABLE OF bapiaddr1."{Add 16.05.2022 - No llega la dirección completa}
    FIELD-SYMBOLS: <fs_partneraddresses> LIKE LINE OF lt_partneraddresses."{Add 16.05.2022 - No llega la dirección completa}

    DATA: ls_quotation_header_in      TYPE bapisdhd1,
          lt_quotation_items_in       TYPE TABLE OF bapisditm,
          lt_quotation_partners       TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in  TYPE TABLE OF bapicond,
          lt_quotation_schedules_in   TYPE TABLE OF bapischdl,
          lt_quotation_text           TYPE TABLE OF bapisdtext,
          lt_extensionin              TYPE TABLE OF  bapiparex,
          lt_quotation_conditions_inx TYPE TABLE OF bapicondx,
          lv_salesdocument            TYPE bapivbeln-vbeln,
          lt_returnbp                 TYPE TABLE OF bapiret2,
          lt_i_new_ventai_h           LIKE i_new_ventai_h,
          lv_centro                   TYPE werks_ext,
          lv_unidad                   TYPE meins,
          lv_salida                   TYPE string,
          lv_salidah                  TYPE string,
          lv_message                  TYPE string,
          lv_error                    TYPE c,
          go_error                    TYPE REF TO cx_root,
          lv_errorch                  TYPE string,
          lv_errorbp                  TYPE string,
          lv_material                 TYPE mara-matnr,
          lv_usuario                  TYPE sy-uname.

    DATA: ls_quotation_header_in2      TYPE bapisdhd1,
          lt_quotation_items_in2       TYPE TABLE OF bapisditm,
          lt_quotation_partners2       TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in2  TYPE TABLE OF bapicond,
          lt_quotation_conditions_inx2 TYPE TABLE OF bapicondx,
          lt_quotation_schedules_in2   TYPE TABLE OF bapischdl,
          lt_quotation_text2           TYPE TABLE OF bapisdtext,
          lt_extensionin2              TYPE TABLE OF  bapiparex,
          lv_salesdocument2            TYPE bapivbeln-vbeln,
          lv_errorbp2                  TYPE string,
          lt_returnbp2                 TYPE TABLE OF bapiret2.

    DATA: lv_ef_error_any   TYPE  xfeld,
          lv_item_deletion  TYPE  xfeld,
          lv_pod_update     TYPE  xfeld,
          lv_interface      TYPE  xfeld,
          lv_goods_issue    TYPE  xfeld,
          lv_final_check    TYPE  xfeld,
          lv_partner_update TYPE  xfeld,
          lv_sernr_update   TYPE  xfeld.

    FIELD-SYMBOLS: <fs_quotation_items_in2>       LIKE LINE OF lt_quotation_items_in2,
                   <fs_quotation_partners2>       LIKE LINE OF lt_quotation_partners2,
                   <fs_quotation_conditions_in2>  LIKE LINE OF lt_quotation_conditions_in2,
                   <fs_quotation_conditions_inx2> LIKE LINE OF lt_quotation_conditions_inx2,
                   <fs_quotation_schedules_in2>   LIKE LINE OF lt_quotation_schedules_in2,
                   <fs_quotation_text2>           LIKE LINE OF lt_quotation_text,
                   <fs_extensionin2>              LIKE LINE OF lt_extensionin,
                   <fs_returnbp2>                 LIKE LINE OF lt_returnbp2.

    FIELD-SYMBOLS: <fs_quotation_items_in>       LIKE LINE OF lt_quotation_items_in,
                   <fs_quotation_partners>       LIKE LINE OF lt_quotation_partners,
                   <fs_quotation_conditions_in>  LIKE LINE OF lt_quotation_conditions_in,
                   <fs_quotation_conditions_inx> LIKE LINE OF lt_quotation_conditions_inx,
                   <fs_quotation_schedules_in>   LIKE LINE OF lt_quotation_schedules_in,
                   <fs_quotation_text>           LIKE LINE OF lt_quotation_text,
                   <fs_extensionin>              LIKE LINE OF lt_extensionin,
                   <fs_returnbp>                 LIKE LINE OF lt_returnbp,
                   <fs_i_new_ventai_h>           LIKE LINE OF i_new_ventai_h,
                   <fs_i_new_ventai_p>           LIKE LINE OF i_new_ventai_p,
                   <fs_pa0001>                   LIKE LINE OF lt_pa0001,
                   <fs_knvv>                     LIKE LINE OF lt_knvv,
                   <fs_tvau_auart_vko>           LIKE LINE OF lt_tvau_auart_vko,
                   <fs_kna1>                     LIKE LINE OF lt_kna1,
                   <fs_tvak>                     LIKE LINE OF lt_tvak,
                   <fs_kna12>                    LIKE LINE OF lt_kna12,
                   <fs_zparametros>              LIKE LINE OF lt_zparametros,
                   <fs_zparametros2>             LIKE LINE OF lt_zparametros2.

    TYPES: BEGIN OF gy_doc_ent,
             documento TYPE  vbak-vbeln,
             entrega   TYPE  likp-vbeln,
           END OF gy_doc_ent.

    DATA: lt_sales_order_items TYPE TABLE OF bapidlvreftosalesorder,
          lv_delivery          TYPE bapishpdelivnumb-deliv_numb,
          lv_num_deliveries    TYPE  bapidlvcreateheader-num_deliveries,
          lt_doc_ent           TYPE TABLE OF gy_doc_ent,
          lt_returnbp3         TYPE TABLE OF bapiret2,
          lv_errorbp3          TYPE string,
          lv_errorbp4          TYPE string,
          lv_errorbp6          TYPE string, "INSERT @0100
          lv_fact              TYPE c.

    DATA: ls_vbkok_wa  TYPE vbkok,
          lt_vbpok_tab TYPE TABLE OF vbpok.

    DATA: lt_string_components TYPE TABLE OF swastrtab,
          lv_input             TYPE  string.

    FIELD-SYMBOLS: <fs_sales_order_items> LIKE LINE OF lt_sales_order_items,
                   <fs_doc_ent>           LIKE LINE OF lt_doc_ent,
                   <fs_returnbp3>         LIKE LINE OF lt_returnbp3,
                   <fs_vbpok_tab>         LIKE LINE OF lt_vbpok_tab.


    DATA: lt_billingdatain TYPE TABLE OF bapivbrk,
          lt_returnbp5     TYPE TABLE OF bapiret1,
          lt_success       TYPE TABLE OF bapivbrksuccess,
          lv_factura       TYPE bapivbrksuccess-bill_doc,
          lv_errorbp5      TYPE string.

    DATA: ldt_return TYPE string.

    FIELD-SYMBOLS:  <fs_string>      LIKE LINE OF lt_string_components."

    DATA: lv_nombre1 TYPE char35,
          lv_nombre2 TYPE char35,
          lv_nombre3 TYPE char35,
          lv_nombre4 TYPE char35.

    FIELD-SYMBOLS: <fs_billingdatain> LIKE LINE OF lt_billingdatain,
                   <fs_success>       LIKE LINE OF lt_success,
                   <fs_returnbp5>     LIKE LINE OF lt_returnbp5.

    DATA: ls_order_view           TYPE order_view,
          lt_sales_documents      TYPE TABLE OF sales_key,
          lt_order_headers_out    TYPE TABLE OF bapisdhd,
          lt_order_conditions_out TYPE TABLE OF bapisdcond,
          lv_net_val              TYPE bapicurext, "DEC 28
          lv_suma_iva             TYPE bapicurext, "DEC 28
          lv_total_sap            TYPE bapicurext,
          lv_total_fiori          TYPE p  DECIMALS  2, "kwmeng,
          lv_diferencia(16)       TYPE p  DECIMALS  2,
          lt_conditions_in        TYPE TABLE OF bapicond,
          lt_conditions_inx       TYPE TABLE OF bapicondx,
          lt_return_change        TYPE TABLE OF bapiret2,
          ls_order_header_inx     TYPE bapisdh1x,

          lt_conditions_in2       TYPE TABLE OF bapicond,
          lt_conditions_inx2      TYPE TABLE OF bapicondx,
          lt_return_change2       TYPE TABLE OF bapiret2,
          ls_order_header_inx2    TYPE bapisdh1x.


    FIELD-SYMBOLS: <fs_sales_documents>      LIKE LINE OF lt_sales_documents,
                   <fs_order_headers_out>    LIKE LINE OF lt_order_headers_out,
                   <fs_order_conditions_out> LIKE LINE OF lt_order_conditions_out,
                   <fs_conditions_in>        LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx>       LIKE LINE OF lt_conditions_inx,

                   <fs_conditions_in2>       LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx2>      LIKE LINE OF lt_conditions_inx.

    lv_usuario = sy-uname.

    READ TABLE i_new_ventai_h ASSIGNING <fs_i_new_ventai_h> INDEX 1.
    IF sy-subrc EQ 0.
      lv_fact = <fs_i_new_ventai_h>-fact.
*{INSERT @100
      SELECT SINGLE * FROM yfi_t001_metpago WHERE met_pag = @<fs_i_new_ventai_h>-metodo_pago
      INTO @DATA(ls_metodo_pago).
*}INSERT @100
    ENDIF.

    IF lv_fact EQ 'M'.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_ventai_h
            WHERE indi_expedi = i_new_ventai_h-motivo_expedicion
            AND facturacion = 'B'"Facturación manual
            AND vkorg = i_new_ventai_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
            FROM ysd_t001_paramet
            INTO TABLE lt_zparametros
            FOR ALL ENTRIES IN i_new_ventai_h
            WHERE indi_expedi = i_new_ventai_h-motivo_expedicion
            AND facturacion = 'A'"Facturación normal
            AND vkorg = i_new_ventai_h-organizacion_venta.

    ENDIF.


    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna1
    FOR ALL ENTRIES IN i_new_ventai_h
    WHERE kunnr EQ i_new_ventai_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna12
    FOR ALL ENTRIES IN i_new_ventai_h
    WHERE kunnr EQ i_new_ventai_h-bill_to.

    SELECT uname pernr bukrs btrtl
    FROM pa0001
    INTO TABLE lt_pa0001
    FOR ALL ENTRIES IN i_new_ventai_h
    WHERE uname EQ i_new_ventai_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
    FROM knvv
    INTO TABLE lt_knvv
    FOR ALL ENTRIES IN i_new_ventai_h
    WHERE kunnr EQ i_new_ventai_h-cliente.

*************************************************** CREAR LA COTIZACION ******************************************************************
******************************************************************************************************************************************

    LOOP AT i_new_ventai_h ASSIGNING <fs_i_new_ventai_h>.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_ventai_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

      READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
      IF sy-subrc EQ 0.
        ls_quotation_header_in-doc_type = <fs_zparametros>-doc_type_c.
        IF lv_fact EQ 'M'.
          ls_quotation_header_in-ship_cond = '01'."//REPLACE@100
        ELSE.
          ls_quotation_header_in-ship_cond = <fs_zparametros>-indi_expedi.
        ENDIF.
      ENDIF.
      ls_quotation_header_in-ord_reason = <fs_i_new_ventai_h>-motivo_pedido.
      ls_quotation_header_in-sales_org = <fs_i_new_ventai_h>-organizacion_venta.
      ls_quotation_header_in-distr_chan = <fs_i_new_ventai_h>-canal.
      ls_quotation_header_in-division   = <fs_i_new_ventai_h>-sector.
      ls_quotation_header_in-sales_grp = <fs_i_new_ventai_h>-grupo_vendedores.
      ls_quotation_header_in-sales_off = <fs_i_new_ventai_h>-oficina.
      ls_quotation_header_in-req_date_h = <fs_i_new_ventai_h>-fecha_entrega.
      ls_quotation_header_in-price_date = sy-datum.
      ls_quotation_header_in-qt_valid_f = sy-datum.
      ls_quotation_header_in-qt_valid_t = <fs_i_new_ventai_h>-fecha_oferta.
      ls_quotation_header_in-ct_valid_f = <fs_i_new_ventai_h>-fecha_precio.
      ls_quotation_header_in-ct_valid_t = <fs_i_new_ventai_h>-fecha_oferta.
      ls_quotation_header_in-purch_no_c = <fs_i_new_ventai_h>-referencia_cliente.
      ls_quotation_header_in-sd_doc_cat = 'B'.

      ls_quotation_header_in-sales_dist = <fs_i_new_ventai_h>-zona_venta.
      ls_quotation_header_in-pp_search = <fs_i_new_ventai_h>-obra.
      ls_quotation_header_in-pmnttrms = <fs_i_new_ventai_h>-condicion_pago.
      ls_quotation_header_in-pymt_meth = ls_metodo_pago-via_pago."<fs_i_new_cotizacion_h>-metodo_pago.
      lv_total_fiori = <fs_i_new_ventai_h>-sub_total.

************************************ LLENADO DE LA PRIMERA TABLA *******************************************************
      READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
      IF sy-subrc EQ 0.

        lv_cliente = <fs_kna1>-xcpdk.

      ENDIF.

      READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
      IF sy-subrc EQ 0.

        lv_destina = <fs_kna12>-xcpdk.

      ENDIF.


      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'AG'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-cliente.
      IF lv_cliente EQ 'X'.
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.
        <fs_quotation_partners>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-street = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventai_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventai_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.                                      "{ADD 16.05.2022 - No llega la dirección completa}
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.   "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-addr_no = '1'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.            "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.                  "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.                     "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-langu   = 'S'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
        CLEAR lv_nit.

        CONCATENATE 'AG' <fs_i_new_ventai_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.

        CONCATENATE 'RG' <fs_i_new_ventai_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RE'.
      IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'."lv_cliente EQ 'X' OR lv_destina EQ 'X'."{-+01.07.2022}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.
        <fs_quotation_partners>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-street = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventai_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventai_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.                                      "{ADD 16.05.2022 - No llega la dirección completa}
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.   "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-addr_no = '1'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.            "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.                  "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.                     "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-langu   = 'S'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'RE' <fs_i_new_ventai_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_ventai_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

      ENDIF.


*       APPEND INITIAL LINE TO LT_QUOTATION_PARTNERS ASSIGNING <FS_QUOTATION_PARTNERS>.
*       <FS_QUOTATION_PARTNERS>-PARTN_ROLE = 'DF'.
*       <FS_QUOTATION_PARTNERS>-PARTN_NUMB = <FS_I_NEW_VENTAI_H>-CLIENTE.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RP'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-cliente.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'BU'.
      IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-cliente.
      ENDIF.


      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'WE'.
      IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'."lv_cliente EQ 'X' OR lv_destina EQ 'X'."{-+01.07.2022}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.
        <fs_quotation_partners>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_quotation_partners>-street = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventai_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventai_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventai_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.                                      "{ADD 16.05.2022 - No llega la dirección completa}
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.   "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-addr_no = '1'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
        <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.            "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.                  "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.              "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.                     "{ADD 16.05.2022 - No llega la dirección completa}
        <fs_partneraddresses>-langu   = 'S'.                                          "{ADD 16.05.2022 - No llega la dirección completa}

        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'WE' <fs_i_new_ventai_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'WE' <fs_i_new_ventai_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'VE'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventai_h>-solicitante. "'0001000430'

* ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
      CONCATENATE  <fs_i_new_ventai_h>-nota_envio ' ' <fs_i_new_ventai_h>-coordenada INTO lv_text_line.

      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id = 'TX04'.
      <fs_quotation_text>-langu = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_ventai_h>-coordenada.

      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_ventai_h>-nota_envio.                               "{Add. 18.05.2022 - Se cortaba en 132 caracteres}
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id = 'TX14'.
        <fs_quotation_text>-langu = 'S'.
        <fs_quotation_text>-text_line = <fs_string>-str.
      ENDLOOP.
*      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>. "{Comm. 18.05.2022 - Se cortaba en 132 caracteres}
*      <fs_quotation_text>-text_id = 'TX14'.
*      <fs_quotation_text>-langu = 'S'.
*      <fs_quotation_text>-text_line = <fs_i_new_ventai_h>-nota_envio.


      LOOP AT i_new_ventai_p ASSIGNING <fs_i_new_ventai_p>.

*{ INSERT @003
        IF <fs_i_new_ventai_p>-nota_fabricacion IS NOT INITIAL.

          CLEAR lv_input. FREE lt_string_components.
          lv_input = <fs_i_new_ventai_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_text>-text_id = '0006'.
            <fs_quotation_text>-langu = 'S'.
            <fs_quotation_text>-text_line = <fs_string>-str.
          ENDLOOP.

        ENDIF.
*} INSERT @003
* ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
        IF <fs_i_new_ventai_p>-condp EQ '1'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventai_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventai_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventai_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventai_p>-condicion_pago.

        ELSEIF <fs_i_new_ventai_p>-condp EQ '2'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.

        ELSEIF <fs_i_new_ventai_p>-condp EQ '3'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventai_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventai_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventai_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventai_p>-condicion_pago.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
*{ INSERT @006
        ELSEIF <fs_i_new_ventai_p>-condp EQ '4'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventai_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.

*} INSERT @006
        ENDIF.

* ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
        <fs_quotation_schedules_in>-itm_number = <fs_i_new_ventai_p>-posicion.
        <fs_quotation_schedules_in>-req_date = <fs_i_new_ventai_h>-fecha_precio.
        <fs_quotation_schedules_in>-req_qty = <fs_i_new_ventai_p>-cantidad.

* ********************************** CUARTE DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_items_in ASSIGNING <fs_quotation_items_in>.
        <fs_quotation_items_in>-pmnttrms = <fs_i_new_ventai_h>-condicion_pago. "{Add. 13.05.2022 - Se están particionando facturas}
        <fs_quotation_items_in>-sales_dist = <fs_i_new_ventai_h>-zona_venta.   "{Add. 13.05.2022 - Las posiciones no toman la zona correcta}
        <fs_quotation_items_in>-itm_number = <fs_i_new_ventai_p>-posicion.
        <fs_quotation_items_in>-po_itm_no = <fs_i_new_ventai_p>-posicion.
        <fs_quotation_items_in>-material = <fs_i_new_ventai_p>-articulo.
        <fs_quotation_items_in>-batch = <fs_i_new_ventai_p>-lote.
        <fs_quotation_items_in>-plant = <fs_i_new_ventai_p>-centro.
        <fs_quotation_items_in>-target_qty = <fs_i_new_ventai_p>-cantidad.
        <fs_quotation_items_in>-target_qu = <fs_i_new_ventai_p>-unidad_medida.
*          <fs_quotation_items_in>-item_categ = 'AGN'."DELETE @0100 Caso programacion stock y almacen
        <fs_quotation_items_in>-gross_wght = <fs_i_new_ventai_p>-peso_neto.
        <fs_quotation_items_in>-net_weight = <fs_i_new_ventai_p>-peso_neto.
        <fs_quotation_items_in>-untof_wght = 'KG'.
        <fs_quotation_items_in>-route = <fs_i_new_ventai_p>-ruta.
        <fs_quotation_items_in>-po_quan = <fs_i_new_ventai_p>-cantidad.
        <fs_quotation_items_in>-store_loc = <fs_i_new_ventai_p>-almacen.
        <fs_quotation_items_in>-reason_rej = <fs_i_new_ventai_p>-motivo_rechazo.
*/*BEGIN Add. 14.11.2022 - Recuperar el tipo posición en Pedido
        IF <fs_i_new_ventai_p>-tipo_posc IS NOT INITIAL.
          <fs_quotation_items_in>-ref_1 = <fs_i_new_ventai_p>-tipo_posc.
        ELSE.
          <fs_quotation_items_in>-ref_1 = 'AGN'.
        ENDIF.
*\*END Add. 14.11.2022 - Recuperar el tipo posición en Pedido
      ENDLOOP.

    ENDLOOP.

    TRY.
        DELETE ADJACENT DUPLICATES FROM lt_quotation_text."INSERT @009
        CALL FUNCTION 'BAPI_QUOTATION_CREATEFROMDATA2'
          EXPORTING
            quotation_header_in      = ls_quotation_header_in
          IMPORTING
            salesdocument            = lv_salesdocument
          TABLES
            return                   = lt_returnbp
            quotation_items_in       = lt_quotation_items_in
            quotation_partners       = lt_quotation_partners
            quotation_schedules_in   = lt_quotation_schedules_in
            quotation_conditions_in  = lt_quotation_conditions_in
            quotation_conditions_inx = lt_quotation_conditions_inx
            quotation_text           = lt_quotation_text
            extensionin              = lt_extensionin
            partneraddresses         = lt_partneraddresses. "{ADD 16.05.2022 - No llega la dirección completa}

        IF lv_salesdocument IS INITIAL.

          LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.

            CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.

          ENDLOOP.

        ELSE.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO 1 SECONDS.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorch = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.


    IF lv_errorbp IS INITIAL.
      FREE lt_partneraddresses.
      UNASSIGN <fs_partneraddresses>.

******************************************************** CREAR EL PEDIDO ******************************************************************
*******************************************************************************************************************************************

      LOOP AT i_new_ventai_h ASSIGNING <fs_i_new_ventai_h>.
        CLEAR gv_sociedad.
        gv_sociedad = <fs_i_new_ventai_h>-organizacion_venta.
* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          ls_quotation_header_in2-doc_type = <fs_zparametros>-doc_type_p.
          IF lv_fact EQ 'M'.
            ls_quotation_header_in2-ship_cond = '01'."//REPLACE@100"'03'.
          ELSE.
            ls_quotation_header_in2-ship_cond = <fs_zparametros>-indi_expedi.
          ENDIF.
        ENDIF.

        ls_quotation_header_in2-ord_reason = <fs_i_new_ventai_h>-motivo_pedido.
        ls_quotation_header_in2-ref_doc = lv_salesdocument.
        ls_quotation_header_in2-refdoc_cat = 'B'.
        ls_quotation_header_in2-sd_doc_cat = 'C'.
        ls_quotation_header_in2-sales_org = <fs_i_new_ventai_h>-organizacion_venta.
        ls_quotation_header_in2-distr_chan = <fs_i_new_ventai_h>-canal.
        ls_quotation_header_in2-division   = <fs_i_new_ventai_h>-sector.
        ls_quotation_header_in2-sales_grp = <fs_i_new_ventai_h>-grupo_vendedores.
        ls_quotation_header_in2-sales_off = <fs_i_new_ventai_h>-oficina.
        ls_quotation_header_in2-req_date_h = <fs_i_new_ventai_h>-fecha_entrega.
*{   INSERT         QASK900005                                        2
*
*}   INSERT
*{   REPLACE        QASK900005                                        3
*\        ls_quotation_header_in2-price_date = <fs_i_new_ventai_h>-fecha_precio.
        ls_quotation_header_in2-price_date = sy-datum. "INSERT @012.
*}   REPLACE
        ls_quotation_header_in2-qt_valid_f = sy-datum."INSERT @012
        ls_quotation_header_in2-qt_valid_t = <fs_i_new_ventai_h>-fecha_oferta.
        ls_quotation_header_in2-purch_no_c = <fs_i_new_ventai_h>-referencia_cliente.
        ls_quotation_header_in2-req_date_h = <fs_i_new_ventai_h>-fecha_entrega.
        ls_quotation_header_in2-ct_valid_f = <fs_i_new_ventai_h>-fecha_precio.
        ls_quotation_header_in2-ct_valid_t = <fs_i_new_ventai_h>-fecha_oferta.

        ls_quotation_header_in2-sales_dist = <fs_i_new_ventai_h>-zona_venta.
        ls_quotation_header_in2-pp_search = <fs_i_new_ventai_h>-obra.
        ls_quotation_header_in2-pmnttrms = <fs_i_new_ventai_h>-condicion_pago.

*  *********************************** LLENADO DE LA PRIMERA TABLA *******************************************************
        READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
        IF sy-subrc EQ 0.

          lv_cliente = <fs_kna1>-xcpdk.

        ENDIF.

        READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
        IF sy-subrc EQ 0.

          lv_destina = <fs_kna12>-xcpdk.

        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'AG'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-cliente.
        IF lv_cliente EQ 'X'.
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
          <fs_quotation_partners2>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_quotation_partners2>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
          <fs_quotation_partners2>-street = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventai_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventai_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.                                      "{ADD 16.05.2022 - No llega la dirección completa}
          APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.   "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-addr_no = '1'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
          <fs_partneraddresses>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
          <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.            "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.                  "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.                     "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-langu   = 'S'.
          CLEAR lv_nit.

          CONCATENATE 'AG' <fs_i_new_ventai_h>-nit INTO lv_nit.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.

          CLEAR lv_nit.

          CONCATENATE 'RG' <fs_i_new_ventai_h>-nit INTO lv_nit.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.

        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'RE'.
        IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-cliente.
        ENDIF.
        IF lv_destina EQ 'X'."lv_cliente EQ 'X' OR lv_destina EQ 'X'."{-+01.07.2022}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
          <fs_quotation_partners2>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_quotation_partners2>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
          <fs_quotation_partners2>-street = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventai_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventai_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.                                     "{ADD 16.05.2022 - No llega la dirección completa}
          APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.   "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-addr_no = '1'.                                          "{ADD 16.05.2022 - No llega la dirección completa}
*/BEGIN Mod 19.09.2022 - Cortar cadena de nombres
          <fs_partneraddresses>-name = lv_nombre1."<fs_i_new_ventai_h>-codigo_y_nombre.         "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-name_2 = lv_nombre2."<fs_i_new_ventai_h>-mc_name2.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
*\END Mod 19.09.2022 - Cortar cadena de nombres
          <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.            "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.                  "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.              "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.                     "{ADD 16.05.2022 - No llega la dirección completa}
          <fs_partneraddresses>-langu   = 'S'.                                          "{ADD 16.05.2022 - No llega la dirección completa}

          CLEAR lv_nit.
          IF lv_cliente EQ 'X'.
            CONCATENATE 'RE' <fs_i_new_ventai_h>-nit INTO lv_nit.
          ELSE.
            CONCATENATE 'RE' <fs_i_new_ventai_h>-nit_cpd INTO lv_nit.
          ENDIF.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'RP'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-cliente.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'BU'.
        IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-cliente.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'WE'.
        IF <fs_i_new_ventai_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-cliente.
        ENDIF.
        IF lv_destina EQ 'X'.
          <fs_quotation_partners2>-name = lv_nombre1.
          <fs_quotation_partners2>-name_2 = lv_nombre2.
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
          <fs_quotation_partners2>-street = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventai_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventai_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventai_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.
          APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
          <fs_partneraddresses>-addr_no = '1'.
          <fs_partneraddresses>-name = lv_nombre1.
          <fs_partneraddresses>-name_2 = lv_nombre2.
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
          <fs_partneraddresses>-street_lng = <fs_i_new_ventai_h>-direccion3.
          <fs_partneraddresses>-city = <fs_i_new_ventai_h>-direccion3.
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventai_h>-telefono.
          <fs_partneraddresses>-country = <fs_i_new_ventai_h>-pais.
          <fs_partneraddresses>-langu   = 'S'.
          CLEAR lv_nit.
          IF lv_cliente EQ 'X'.
            CONCATENATE 'WE' <fs_i_new_ventai_h>-nit INTO lv_nit.
          ELSE.
            CONCATENATE 'WE' <fs_i_new_ventai_h>-nit_cpd INTO lv_nit.
          ENDIF.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'VE'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventai_h>-solicitante.

*   ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
        <fs_quotation_text2>-text_id = 'TX04'.
        <fs_quotation_text2>-langu = 'S'.
        <fs_quotation_text2>-text_line = <fs_i_new_ventai_h>-coordenada.

        lv_input = <fs_i_new_ventai_h>-nota_envio.
        CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
          EXPORTING
            input_string         = lv_input
            max_component_length = 132
          TABLES
            string_components    = lt_string_components.
        LOOP AT lt_string_components ASSIGNING FIELD-SYMBOL(<fs_string2>).
          APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
          <fs_quotation_text2>-text_id = 'TX14'.
          <fs_quotation_text2>-langu = 'S'.
          <fs_quotation_text2>-text_line = <fs_string2>-str.
        ENDLOOP.

        LOOP AT i_new_ventai_p ASSIGNING <fs_i_new_ventai_p>.

          IF <fs_i_new_ventai_p>-nota_fabricacion IS NOT INITIAL.

            CLEAR lv_input. FREE lt_string_components.
            lv_input = <fs_i_new_ventai_p>-nota_fabricacion.
            CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
              EXPORTING
                input_string         = lv_input
                max_component_length = 132
              TABLES
                string_components    = lt_string_components.
            LOOP AT lt_string_components ASSIGNING <fs_string>.
              APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
              <fs_quotation_text2>-text_id = '0006'.
              <fs_quotation_text2>-itm_number = <fs_i_new_ventai_p>-posicion.
              <fs_quotation_text2>-langu = 'S'.
              <fs_quotation_text2>-text_line = <fs_string>-str.
            ENDLOOP.

          ENDIF.

*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
          APPEND INITIAL LINE TO lt_quotation_schedules_in2 ASSIGNING <fs_quotation_schedules_in2>.
          <fs_quotation_schedules_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_schedules_in2>-req_date = <fs_i_new_ventai_h>-fecha_precio.
          <fs_quotation_schedules_in2>-req_qty = <fs_i_new_ventai_p>-cantidad.

*     ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
          IF <fs_i_new_ventai_p>-condp EQ '1'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventai_p>-condicion_pago.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventai_p>-importe_pago.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventai_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventai_p>-condicion_pago.

          ELSEIF <fs_i_new_ventai_p>-condp EQ '2'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
            <fs_quotation_conditions_in2>-cond_unit = '%'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.

          ELSEIF <fs_i_new_ventai_p>-condp EQ '3'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventai_p>-condicion_pago.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventai_p>-importe_pago.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventai_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventai_p>-condicion_pago.

            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
            <fs_quotation_conditions_in2>-cond_unit = '%'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.

          ELSEIF <fs_i_new_ventai_p>-condp EQ '4'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventai_p>-importe_decuento.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventai_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventai_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventai_p>-condicion_descuento.
          ENDIF.


*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************

          APPEND INITIAL LINE TO lt_quotation_items_in2 ASSIGNING <fs_quotation_items_in2>.
          <fs_quotation_items_in2>-pmnttrms = <fs_i_new_ventai_h>-condicion_pago.
          <fs_quotation_items_in2>-sales_dist = <fs_i_new_ventai_h>-zona_venta.
          <fs_quotation_items_in2>-ref_doc = lv_salesdocument.
          <fs_quotation_items_in2>-ref_doc_it = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_items_in2>-ref_doc_ca = 'B'.
          <fs_quotation_items_in2>-itm_number = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_items_in2>-po_itm_no = <fs_i_new_ventai_p>-posicion.
          <fs_quotation_items_in2>-material = <fs_i_new_ventai_p>-articulo.
          <fs_quotation_items_in2>-batch = <fs_i_new_ventai_p>-lote.
          <fs_quotation_items_in2>-plant = <fs_i_new_ventai_p>-centro.
          <fs_quotation_items_in2>-target_qty = <fs_i_new_ventai_p>-cantidad.
          <fs_quotation_items_in2>-target_qu = <fs_i_new_ventai_p>-unidad_medida.
          <fs_quotation_items_in2>-gross_wght = <fs_i_new_ventai_p>-peso_bruto.
          <fs_quotation_items_in2>-net_weight = <fs_i_new_ventai_p>-peso_bruto.
          <fs_quotation_items_in2>-untof_wght = 'KG'.
          <fs_quotation_items_in2>-po_quan = <fs_i_new_ventai_p>-cantidad.
          <fs_quotation_items_in2>-route = <fs_i_new_ventai_p>-ruta.
          <fs_quotation_items_in2>-store_loc = <fs_i_new_ventai_p>-almacen.
          <fs_quotation_items_in2>-reason_rej = <fs_i_new_ventai_p>-motivo_rechazo.
          IF <fs_i_new_ventai_p>-tipo_posc IS NOT INITIAL.
            <fs_quotation_items_in2>-item_categ = <fs_i_new_ventai_p>-tipo_posc.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

      TRY.

          DELETE ADJACENT DUPLICATES FROM lt_quotation_text2.
          CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
            EXPORTING
              order_header_in      = ls_quotation_header_in2
              convert              = ' '
            IMPORTING
              salesdocument        = lv_salesdocument2
            TABLES
              return               = lt_returnbp2
              order_items_in       = lt_quotation_items_in2
              order_partners       = lt_quotation_partners2
              order_schedules_in   = lt_quotation_schedules_in2
              order_conditions_in  = lt_quotation_conditions_in2
              order_conditions_inx = lt_quotation_conditions_inx2
              order_text           = lt_quotation_text2
              extensionin          = lt_extensionin2
              partneraddresses     = lt_partneraddresses.

          IF lv_salesdocument2 IS INITIAL.

            LOOP AT lt_returnbp2 ASSIGNING <fs_returnbp2>.

              CONCATENATE lv_errorbp2 <fs_returnbp2>-type ' / ' <fs_returnbp2>-id ' / ' <fs_returnbp2>-number ' / ' <fs_returnbp2>-message ' - ' INTO lv_errorbp2.

            ENDLOOP.

          ELSE.

*{REPLACE @0100
*          READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2> INDEX 1.
*          IF sy-subrc EQ 0.
*            lv_delivery = <fs_returnbp2>-message_v3.
*
*          ENDIF.
            READ TABLE lt_returnbp2 ASSIGNING <fs_returnbp2>
                                 WITH KEY id     = 'V1'
                                          number = '260'. "Creó la entrega

            IF sy-subrc = 0.
              lv_delivery = <fs_returnbp2>-message_v3.
              lv_delivery = |{ lv_delivery  ALPHA = IN }| .
            ENDIF.
*}REPLACE @0100

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

            WAIT UP TO 1 SECONDS.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.

    CLEAR: lv_diferencia, lv_total_sap, lv_net_val, lv_suma_iva, lt_conditions_in, lt_conditions_inx, lt_conditions_in2, lt_conditions_inx2.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_delivery IS INITIAL.
*
********************************************************** CREAR LA ENTREGA ******************************************************************
**********************************************************************************************************************************************
*
*      LOOP AT i_new_ventai_h ASSIGNING <fs_i_new_ventai_h>.
*
*        LOOP AT i_new_ventai_p ASSIGNING <fs_i_new_ventai_p> WHERE motivo_rechazo IS INITIAL.
*
*          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
*            EXPORTING
*              input                = <fs_i_new_ventai_p>-unidad_medida
**             LANGUAGE             = SY-LANGU
*           IMPORTING
*             output               = lv_unidad.
*
*          APPEND INITIAL LINE TO lt_sales_order_items ASSIGNING <fs_sales_order_items>.
*          <fs_sales_order_items>-ref_doc = lv_salesdocument2.
*          <fs_sales_order_items>-ref_item = <fs_i_new_ventai_p>-posicion.
*          <fs_sales_order_items>-dlv_qty = <fs_i_new_ventai_p>-cantidad.
*          <fs_sales_order_items>-sales_unit = lv_unidad.
*          lv_centro = <fs_i_new_ventai_p>-centro.
*
*        ENDLOOP.
*
*      ENDLOOP.
*
*      TRY.
*
*          CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
*            EXPORTING
*              ship_point        = lv_centro
*            IMPORTING
*              delivery          = lv_delivery
*              num_deliveries    = lv_num_deliveries
*            TABLES
*              sales_order_items = lt_sales_order_items
*              return            = lt_returnbp3.
*
*
      IF lv_delivery IS  INITIAL.

        READ TABLE lt_returnbp3 ASSIGNING <fs_returnbp3> INDEX 1.
        IF sy-subrc EQ 0.

          CONCATENATE lv_errorbp3  <fs_returnbp3>-type ' / ' <fs_returnbp3>-id ' / '
                     <fs_returnbp3>-number ' / ' <fs_returnbp3>-message ' - ' INTO lv_errorbp3.

        ELSE.

          lv_errorbp3 = 'Error al crear la entrega'.

        ENDIF.

      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        WAIT UP TO 1 SECONDS.

      ENDIF.

*        catch cx_sy_zerodivide into go_error.
*
*          lv_errorch = go_error->get_text( ).
*
*          lv_error = 'X'.
*
*      endtry.
    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL.

**     ******************************************************* CREAR EL PICKING ******************************************************************
**     *******************************************************************************************************************************************

      LOOP AT i_new_ventai_h ASSIGNING <fs_i_new_ventai_h>.

        ls_vbkok_wa-vbeln_vl = lv_delivery.
        ls_vbkok_wa-vbeln = lv_delivery.
        ls_vbkok_wa-wabuc = 'X'.

        LOOP AT i_new_ventai_p ASSIGNING <fs_i_new_ventai_p> WHERE motivo_rechazo IS INITIAL.
*{INSERT @100
          "--- INICIO DE LA MODIFICACIÓN ---
          DATA: lv_menge_um_base TYPE p DECIMALS 3, " Cantidad en Unidad de Medida Base
                lv_um_venta      TYPE meins.      " Unidad de Medida de Venta

          lv_um_venta = <fs_i_new_ventai_p>-unidad_medida.

* Convert quantity into base quantity
          CALL FUNCTION 'MATERIAL_UNIT_CONVERSION'
            EXPORTING
              input                = <fs_i_new_ventai_p>-cantidad
              kzmeinh              = 'X'
              matnr                = <fs_i_new_ventai_p>-articulo
              meinh                = lv_um_venta
            IMPORTING
              output               = lv_menge_um_base
            EXCEPTIONS
              conversion_not_found = 1
              input_invalid        = 2
              material_not_found   = 3
              meinh_not_found      = 4
              meins_missing        = 5
              no_meinh             = 6
              output_invalid       = 7
              overflow             = 8
              OTHERS               = 9.
*}INSERT @100
          APPEND INITIAL LINE TO lt_vbpok_tab ASSIGNING <fs_vbpok_tab>.
          <fs_vbpok_tab>-vbeln_vl = lv_delivery.
          <fs_vbpok_tab>-posnr_vl = <fs_i_new_ventai_p>-posicion.
          <fs_vbpok_tab>-vbeln = lv_delivery.
          <fs_vbpok_tab>-posnn = <fs_i_new_ventai_p>-posicion.
          <fs_vbpok_tab>-pikmg = lv_menge_um_base.
        ENDLOOP.

      ENDLOOP.

      TRY.
          DATA: lt_prot TYPE TABLE OF prott.
          CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
            EXPORTING
              vbkok_wa                  = ls_vbkok_wa
              commit                    = 'X'
              delivery                  = lv_delivery
              update_picking            = 'X'
              if_database_update_1      = '1'
              if_error_messages_send    = 'X'
            IMPORTING
              ef_error_any              = lv_ef_error_any
              ef_error_in_item_deletion = lv_item_deletion
              ef_error_in_pod_update    = lv_pod_update
              ef_error_in_interface     = lv_interface
              ef_error_in_goods_issue   = lv_goods_issue
              ef_error_in_final_check   = lv_final_check
              ef_error_partner_update   = lv_partner_update
              ef_error_sernr_update     = lv_partner_update
            TABLES
              vbpok_tab                 = lt_vbpok_tab
              prot                      = lt_prot.

*{REPLACE @100
          IF lv_ef_error_any IS NOT INITIAL.
            " Si hubo un error, ahora leemos la tabla de mensajes detallados
            CLEAR lv_errorbp4.
            DATA: lv_formatted_message TYPE string.
            LOOP AT lt_prot ASSIGNING FIELD-SYMBOL(<fs_prot>)
                WHERE msgty = 'E' OR msgty = 'A'. " Solo nos interesan los errores (E) o abortos (A)

              " Usamos esta función estándar para crear un mensaje legible
              CALL FUNCTION 'FORMAT_MESSAGE'
                EXPORTING
                  id     = <fs_prot>-msgid
                  lang   = sy-langu
                  no     = <fs_prot>-msgno
                  v1     = <fs_prot>-msgv1
                  v2     = <fs_prot>-msgv2
                  v3     = <fs_prot>-msgv3
                  v4     = <fs_prot>-msgv4
                IMPORTING
                  msg    = lv_formatted_message
                EXCEPTIONS
                  OTHERS = 1.

              IF sy-subrc = 0.
                " Concatenamos cada mensaje de error en una sola variable para mostrarlo
                CONCATENATE lv_errorbp4 lv_formatted_message ';' INTO lv_errorbp4 SEPARATED BY space.
              ENDIF.
            ENDLOOP.

            IF lv_errorbp4 IS INITIAL.
              lv_errorbp4 = 'Error no especificado durante la actualización de la entrega.'.
            ENDIF.


            " Como hubo un error, revertimos cualquier cambio en la base de datos
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          ELSE.
            " Si NO hubo ningún error, ahora sí guardamos todo en la base de datos
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.
            WAIT UP TO '0.5' SECONDS.
          ENDIF.
*}REPLACE @100
        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND lv_errorbp4 IS INITIAL.

******************************************************** CREAR LA FACTURA ******************************************************************
********************************************************************************************************************************************

      LOOP AT i_new_ventai_h ASSIGNING <fs_i_new_ventai_h>.

        APPEND INITIAL LINE TO lt_billingdatain ASSIGNING <fs_billingdatain>.
        <fs_billingdatain>-doc_number = lv_delivery.
        <fs_billingdatain>-ref_doc = lv_delivery.
        <fs_billingdatain>-ref_doc_ca = 'J'.
        <fs_billingdatain>-bill_date = sy-datum.
        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          <fs_billingdatain>-ordbilltyp = <fs_zparametros>-doc_type_f.
        ENDIF.

      ENDLOOP.

      TRY.

          CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
            TABLES
              billingdatain = lt_billingdatain
              return        = lt_returnbp5
              success       = lt_success.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          WAIT UP TO '0.5' SECONDS.
          IF lt_success IS INITIAL.

            LOOP AT lt_returnbp5 ASSIGNING <fs_returnbp5>.

              CONCATENATE lv_errorbp5 <fs_returnbp5>-type ' / ' <fs_returnbp5>-id ' / ' <fs_returnbp5>-number ' / ' <fs_returnbp5>-message ' - ' INTO lv_errorbp5.

            ENDLOOP.

          ELSE.

            READ TABLE lt_success ASSIGNING <fs_success> INDEX 1.
            IF sy-subrc EQ 0.

              lv_factura = <fs_success>-bill_doc.

              IMPORT ldt_return = ldt_return FROM MEMORY ID 'ZSD_PRINTMSJ'.

              READ TABLE lt_quotation_partners2 INTO DATA(lwa_quotation_partners2) WITH KEY partn_role = 'BU'.
              IF sy-subrc = 0 AND <fs_i_new_ventai_p>-centro IS ASSIGNED.
                CALL METHOD ycl_sd_utilitys=>set_crearmsj_entrega
                  EXPORTING
                    ip_vbeln  = lv_delivery
                    ip_parnr  = lwa_quotation_partners2-partn_numb
                    ip_vstel  = ls_quotation_header_in2-sales_off
                    ip_werks  = <fs_i_new_ventai_p>-centro
                  IMPORTING
                    ep_return = lv_errorbp6.
              ELSE.
                lv_errorbp6 = TEXT-e01.
              ENDIF.



            ENDIF.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL AND lv_errorbp4 IS INITIAL AND lv_errorbp5 IS INITIAL AND lv_errorbp6 IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.


      DATA lv_collection_message TYPE string.


*{INSERT @100
      rt_return-messcode = '200'.
      IF lv_factura IS NOT INITIAL.

        IF  ( ls_metodo_pago-pas_pag = '1' OR ls_metodo_pago-pas_pag = '2' OR ls_metodo_pago-pas_pag = '3' ). " 1=QR, 2=POS, 3=Tigo Money

          "
          READ TABLE lt_billingdatain INTO DATA(ls_billdatain) INDEX 1.
          IF sy-subrc = 0.

            me->set_cobro_automatico(
              EXPORTING
                iv_invoice_belnr = lv_factura
                iv_invoice_bukrs = 'FCRE'
                iv_invoice_bdate = ls_billdatain-bill_date
                is_metodo_pago   = ls_metodo_pago
              IMPORTING
                es_return        = DATA(ls_cobro_return)
            ).


            IF ls_cobro_return-messcode = '400' OR ls_cobro_return-messcode = 'E'.
              lv_collection_message = |ERROR: El cobro automático falló: { ls_cobro_return-message }|.
              rt_return-messcode = '400'.
            ELSE.
              lv_collection_message = 'El cobro automático fue procesado correctamente.'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*}INSERT @100

      CONCATENATE 'DOCUMENTO COTIZACION: ' lv_salesdocument ' - PEDIDO: ' lv_salesdocument2 ' - ENTREGA: ' lv_delivery ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline lv_collection_message INTO lv_salida.
      CONCATENATE lv_salesdocument '-' lv_salesdocument2 '-' lv_delivery '-' lv_factura INTO lv_salidah.
      rt_return-message = 'Se creo la Venta Inmediata exitosamente'.

      rt_return-data = lv_salida.
      rt_return-datah = lv_salidah.

    ELSE.

      CONCATENATE 'DOCUMENTO COTIZACION: ' lv_salesdocument 'DOCUMENTO PEDIDO: ' lv_salesdocument2 ' - ENTREGA: ' lv_delivery ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida."*->F Generación de Tickets sorteo


      IF lv_errorbp IS NOT INITIAL.

        CONCATENATE 'Cotizacion con Error : ' lv_errorbp INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp2 IS NOT INITIAL.

        CONCATENATE 'Error en el pedido: ' lv_errorbp2 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp3 IS NOT INITIAL.

        CONCATENATE 'Error en la Entrega : ' lv_errorbp3 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp4 IS NOT INITIAL.

        CONCATENATE 'Error en la Piking : ' lv_errorbp4 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp5 IS NOT INITIAL.

        CONCATENATE 'Error en la Factura : ' lv_errorbp5 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp6 IS NOT INITIAL.

        CONCATENATE 'Error msj en la Entrega : ' lv_errorbp6 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method YCL_SD_STORE_SALES->SET_VENTA_PROGRAMADA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_NEW_VENTAP_H                 TYPE        YSD_TT_001_VENTAS
* | [--->] I_NEW_VENTAP_P                 TYPE        YSD_TT_001_VENTAS
* | [<---] RT_RETURN                      TYPE        YSD_S_001_VENTAS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_venta_programada.

    TYPES: BEGIN OF gy_pa0001, "Registro maestro de personal Infotipo 0001 (Asignac.organ.)
             uname TYPE  pa0001-uname, "USUARIO
             pernr TYPE  pa0001-pernr, "CODIGO DE SOLICITANTE
             bukrs TYPE  pa0001-bukrs, "SOCIEDAD
             btrtl TYPE  pa0001-btrtl, "Subdivisión de personal
           END OF gy_pa0001.

    TYPES: BEGIN OF gy_knvv, "Maestro de clientes datos comerciales
             kunnr TYPE  knvv-kunnr, "NUMERO DE CLIENTE
             kdgrp TYPE  knvv-kdgrp, "Grupo de clientes
             bzirk TYPE  knvv-bzirk, "Zona de ventas
             pltyp TYPE  knvv-pltyp, "Tipo de lista de precios
             konda TYPE  knvv-konda, "Grupo de precio de cliente
             waers TYPE  knvv-waers, "Moneda
             spart TYPE  knvv-spart, "SECTOR
           END OF gy_knvv.

    TYPES: BEGIN OF gy_tvau_auart_vko,
             auart TYPE  tvau_auart_vko-auart, "Clase de documento de ventas
             augru TYPE  tvau_auart_vko-augru, "Motivo de pedido (motivo de la operación)
           END OF gy_tvau_auart_vko.

    TYPES: BEGIN OF gy_kna1, "Maestro de clientes (parte general)
             kunnr TYPE  kna1-kunnr, "Número de cliente
             kdkg1 TYPE  kna1-kdkg1, "Clientes grupo de condiciones 1
             xcpdk TYPE  kna1-xcpdk,
           END OF gy_kna1.

    TYPES: BEGIN OF gy_zparametros, "Condiciones de variantes/TABLAS DE PARAMETROS
             doc_type_c  TYPE ysd_t001_paramet-doc_type_c, "Clase de documento de ventas
             doc_type_p  TYPE ysd_t001_paramet-doc_type_p,
             doc_type_f  TYPE ysd_t001_paramet-doc_type_f,
             indi_expedi TYPE ysd_t001_paramet-indi_expedi, "Pto.exped./depto.entrada mcía.
           END OF gy_zparametros.

    TYPES: BEGIN OF gy_tvak, "Documentos ventas: Clases
             auart TYPE  tvak-auart, "Clase de documento de ventas
             vbtyp TYPE  tvak-vbtyp, "Tipo de documento comercial
           END OF gy_tvak.

    DATA: lt_pa0001         TYPE TABLE OF gy_pa0001,
          lt_knvv           TYPE TABLE OF gy_knvv,
          lt_tvau_auart_vko TYPE TABLE OF gy_tvau_auart_vko,
          lt_kna1           TYPE TABLE OF gy_kna1,
          lt_tvak           TYPE TABLE OF gy_tvak,
          lt_kna12          TYPE TABLE OF gy_kna1,
          lt_zparametros    TYPE TABLE OF gy_zparametros,
          lt_zparametros2   TYPE TABLE OF gy_zparametros,
          lv_cliente        TYPE c,
          lv_destina        TYPE c,
          lv_text_line      TYPE tdline.

    DATA: lt_partneraddresses  TYPE TABLE OF bapiaddr1,
          lt_partneraddresses2 TYPE TABLE OF bapiaddr1.
    FIELD-SYMBOLS: <fs_partneraddresses> LIKE LINE OF lt_partneraddresses.

    DATA: ls_quotation_header_in      TYPE bapisdhd1,
          lt_quotation_items_in       TYPE TABLE OF bapisditm,
          lt_quotation_partners       TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in  TYPE TABLE OF bapicond,
          lt_quotation_conditions_inx TYPE TABLE OF bapicondx,
          lt_quotation_schedules_in   TYPE TABLE OF bapischdl,
          lt_quotation_text           TYPE TABLE OF bapisdtext,
          lt_extensionin              TYPE TABLE OF  bapiparex,
          lv_salesdocument            TYPE bapivbeln-vbeln,
          lt_returnbp                 TYPE TABLE OF bapiret2,
          lt_i_new_ventap_h           LIKE i_new_ventap_h,
          lv_salida                   TYPE string,
          lv_salidah                  TYPE string,
          lv_message                  TYPE string,
          lv_error                    TYPE c,
          go_error                    TYPE REF TO cx_root,
          lv_errorch                  TYPE string,
          lv_errorbp                  TYPE string,
          lv_material                 TYPE mara-matnr,
          lv_usuario                  TYPE sy-uname,
          lv_nit                      TYPE string,
          lv_nit2                     TYPE string.

    DATA: ls_quotation_header_in2      TYPE bapisdhd1,
          lt_quotation_items_in2       TYPE TABLE OF bapisditm,
          lt_quotation_partners2       TYPE TABLE OF bapiparnr,
          lt_quotation_conditions_in2  TYPE TABLE OF bapicond,
          lt_quotation_conditions_inx2 TYPE TABLE OF bapicondx,
          lt_quotation_schedules_in2   TYPE TABLE OF bapischdl,
          lt_quotation_text2           TYPE TABLE OF bapisdtext,
          lt_extensionin2              TYPE TABLE OF  bapiparex,
          lv_salesdocument2            TYPE bapivbeln-vbeln,
          lv_errorbp2                  TYPE string,
          lt_returnbp2                 TYPE TABLE OF bapiret2.

    FIELD-SYMBOLS: <fs_quotation_items_in2>       LIKE LINE OF lt_quotation_items_in2,
                   <fs_quotation_partners2>       LIKE LINE OF lt_quotation_partners2,
                   <fs_quotation_conditions_in2>  LIKE LINE OF lt_quotation_conditions_in2,
                   <fs_quotation_conditions_inx2> LIKE LINE OF lt_quotation_conditions_inx2,
                   <fs_quotation_schedules_in2>   LIKE LINE OF lt_quotation_schedules_in,
                   <fs_quotation_text2>           LIKE LINE OF lt_quotation_text,
                   <fs_extensionin2>              LIKE LINE OF lt_extensionin,
                   <fs_returnbp2>                 LIKE LINE OF lt_returnbp2.

    FIELD-SYMBOLS: <fs_quotation_items_in>       LIKE LINE OF lt_quotation_items_in,
                   <fs_quotation_partners>       LIKE LINE OF lt_quotation_partners,
                   <fs_quotation_conditions_in>  LIKE LINE OF lt_quotation_conditions_in,
                   <fs_quotation_conditions_inx> LIKE LINE OF lt_quotation_conditions_inx,
                   <fs_quotation_schedules_in>   LIKE LINE OF lt_quotation_schedules_in,
                   <fs_quotation_text>           LIKE LINE OF lt_quotation_text,
                   <fs_extensionin>              LIKE LINE OF lt_extensionin,
                   <fs_returnbp>                 LIKE LINE OF lt_returnbp,
                   <fs_i_new_ventap_h>           LIKE LINE OF i_new_ventap_h,
                   <fs_i_new_ventap_p>           LIKE LINE OF i_new_ventap_p,
                   <fs_pa0001>                   LIKE LINE OF lt_pa0001,
                   <fs_knvv>                     LIKE LINE OF lt_knvv,
                   <fs_tvau_auart_vko>           LIKE LINE OF lt_tvau_auart_vko,
                   <fs_kna1>                     LIKE LINE OF lt_kna1,
                   <fs_tvak>                     LIKE LINE OF lt_tvak,
                   <fs_kna12>                    LIKE LINE OF lt_kna12,
                   <fs_zparametros>              LIKE LINE OF lt_zparametros,
                   <fs_zparametros2>             LIKE LINE OF lt_zparametros2.

    TYPES: BEGIN OF gy_doc_ent,
             documento TYPE  vbak-vbeln,
             entrega   TYPE  likp-vbeln,
           END OF gy_doc_ent.

    DATA: lt_sales_order_items TYPE TABLE OF bapidlvreftosalesorder,
*          LV_SALESDOCUMENT TYPE BAPIVBELN-VBELN,
          lv_delivery          TYPE bapishpdelivnumb-deliv_numb,
          lv_num_deliveries    TYPE  bapidlvcreateheader-num_deliveries,
          lt_doc_ent           TYPE TABLE OF gy_doc_ent,
          lt_returnbp3         TYPE TABLE OF bapiret2,
          lv_fact              TYPE c,
          lv_tipo              TYPE c,
          lv_errorbp3          TYPE string.

    DATA: ls_vbkok_wa  TYPE vbkok,
          lt_vbpok_tab TYPE TABLE OF vbpok.

    DATA: lt_string_components TYPE TABLE OF swastrtab,
          lv_input             TYPE  string.

    FIELD-SYMBOLS: <fs_sales_order_items> LIKE LINE OF lt_sales_order_items,
                   <fs_doc_ent>           LIKE LINE OF lt_doc_ent,
                   <fs_returnbp3>         LIKE LINE OF lt_returnbp3,
                   <fs_vbpok_tab>         LIKE LINE OF lt_vbpok_tab.


    DATA: lt_billingdatain TYPE TABLE OF bapivbrk,
          lt_returnbp5     TYPE TABLE OF bapiret1,
          lt_success       TYPE TABLE OF bapivbrksuccess,
          lv_factura       TYPE bapivbrksuccess-bill_doc,
          ldt_return       TYPE string,
          lv_errorbp5      TYPE bapi_msg.


    FIELD-SYMBOLS: <fs_billingdatain> LIKE LINE OF lt_billingdatain,
                   <fs_success>       LIKE LINE OF lt_success,
                   <fs_returnbp5>     LIKE LINE OF lt_returnbp5.
    DATA: ls_order_view           TYPE order_view,
          lt_sales_documents      TYPE TABLE OF sales_key,
          lt_order_headers_out    TYPE TABLE OF bapisdhd,
          lt_order_conditions_out TYPE TABLE OF bapisdcond,
          lv_net_val              TYPE bapicurext, "DEC 28
          lv_suma_iva             TYPE bapicurext, "DEC 28
          lv_total_sap            TYPE bapicurext,
          lv_total_fiori          TYPE p  DECIMALS  2,
          lv_diferencia(16)       TYPE p  DECIMALS  2,
          lt_conditions_in        TYPE TABLE OF bapicond,
          lt_conditions_inx       TYPE TABLE OF bapicondx,
          lt_return_change        TYPE TABLE OF bapiret2,
          ls_order_header_inx     TYPE bapisdh1x,

          lt_conditions_in2       TYPE TABLE OF bapicond,
          lt_conditions_inx2      TYPE TABLE OF bapicondx,
          lt_return_change2       TYPE TABLE OF bapiret2,
          ls_order_header_inx2    TYPE bapisdh1x.


    FIELD-SYMBOLS: <fs_sales_documents>      LIKE LINE OF lt_sales_documents,
                   <fs_order_headers_out>    LIKE LINE OF lt_order_headers_out,
                   <fs_order_conditions_out> LIKE LINE OF lt_order_conditions_out,
                   <fs_conditions_in>        LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx>       LIKE LINE OF lt_conditions_inx,

                   <fs_conditions_in2>       LIKE LINE OF lt_conditions_in,
                   <fs_conditions_inx2>      LIKE LINE OF lt_conditions_inx.

    FIELD-SYMBOLS:  <fs_string>      LIKE LINE OF lt_string_components.

    DATA: lv_nombre1 TYPE char35,
          lv_nombre2 TYPE char35,
          lv_nombre3 TYPE char35,
          lv_nombre4 TYPE char35.



    lv_usuario = sy-uname.

    READ TABLE i_new_ventap_h ASSIGNING <fs_i_new_ventap_h> INDEX 1.
    IF sy-subrc EQ 0.
      lv_fact = <fs_i_new_ventap_h>-fact.
      lv_tipo = <fs_i_new_ventap_h>-tipo.
    ENDIF.

    IF lv_fact EQ 'M'.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
      FROM ysd_t001_paramet
      INTO TABLE lt_zparametros
      FOR ALL ENTRIES IN i_new_ventap_h
      WHERE indi_expedi = i_new_ventap_h-motivo_expedicion
      AND facturacion = 'B'"Facturación manual
      AND vkorg = i_new_ventap_h-organizacion_venta.

    ELSE.

      SELECT doc_type_c doc_type_p doc_type_f indi_expedi
      FROM ysd_t001_paramet
      INTO TABLE lt_zparametros
      FOR ALL ENTRIES IN i_new_ventap_h
      WHERE indi_expedi = i_new_ventap_h-motivo_expedicion
      AND facturacion = 'A'"Facturación normal
      AND vkorg = i_new_ventap_h-organizacion_venta.

    ENDIF.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna1
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE kunnr EQ i_new_ventap_h-cliente.

    SELECT kunnr kdkg1 xcpdk
    FROM kna1
    INTO TABLE lt_kna12
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE kunnr EQ i_new_ventap_h-bill_to.

    SELECT uname pernr bukrs btrtl
    FROM pa0001
    INTO TABLE lt_pa0001
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE uname EQ i_new_ventap_h-usuario.

    SELECT kunnr kdgrp bzirk pltyp konda waers
    FROM knvv
    INTO TABLE lt_knvv
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE kunnr EQ i_new_ventap_h-cliente.

    SELECT auart augru
    FROM tvau_auart_vko
    INTO TABLE lt_tvau_auart_vko
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE auart EQ i_new_ventap_h-clase_documento.

    SELECT auart vbtyp
    FROM tvak
    INTO TABLE lt_tvak
    FOR ALL ENTRIES IN i_new_ventap_h
    WHERE auart EQ i_new_ventap_h-clase_documento.


*************************************************** CREAR LA COTIZACION ******************************************************************
******************************************************************************************************************************************

    LOOP AT i_new_ventap_h ASSIGNING <fs_i_new_ventap_h>.
      CLEAR lv_input.
      FREE lt_string_components.
      lv_input = <fs_i_new_ventap_h>-codigo_y_nombre.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 35
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING <fs_string>.
        CASE sy-tabix.
          WHEN 1.
            lv_nombre1 = <fs_string>-str.
          WHEN 2.
            lv_nombre2 = <fs_string>-str.
          WHEN 3.
            lv_nombre3 = <fs_string>-str.
          WHEN 4.
            lv_nombre4 = <fs_string>-str.
        ENDCASE.
      ENDLOOP.

* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

      READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
      IF sy-subrc EQ 0.
        ls_quotation_header_in-doc_type = <fs_zparametros>-doc_type_c.
        IF lv_fact EQ 'M'.
          IF lv_tipo EQ 'P'.
            ls_quotation_header_in-ship_cond = <fs_i_new_ventap_h>-motivo_expedicion.
          ELSEIF lv_tipo EQ 'R'.
            ls_quotation_header_in-ship_cond = '02'.
          ENDIF.
        ELSE.
          ls_quotation_header_in-ship_cond = <fs_i_new_ventap_h>-motivo_expedicion.
        ENDIF.
      ENDIF.
      ls_quotation_header_in-ord_reason = <fs_i_new_ventap_h>-motivo_pedido.
      ls_quotation_header_in-sales_org = <fs_i_new_ventap_h>-organizacion_venta.
      ls_quotation_header_in-distr_chan = <fs_i_new_ventap_h>-canal.
      ls_quotation_header_in-division   = <fs_i_new_ventap_h>-sector.
      ls_quotation_header_in-sales_grp = <fs_i_new_ventap_h>-grupo_vendedores.
      ls_quotation_header_in-sales_off = <fs_i_new_ventap_h>-oficina.
      ls_quotation_header_in-req_date_h = <fs_i_new_ventap_h>-fecha_entrega.
      ls_quotation_header_in-price_date = sy-datum.
      ls_quotation_header_in-qt_valid_f = sy-datum.
      ls_quotation_header_in-qt_valid_t = <fs_i_new_ventap_h>-fecha_oferta.
      ls_quotation_header_in-ct_valid_f = <fs_i_new_ventap_h>-fecha_precio.
      ls_quotation_header_in-ct_valid_t = <fs_i_new_ventap_h>-fecha_oferta.
      ls_quotation_header_in-purch_no_c = <fs_i_new_ventap_h>-referencia_cliente.
      ls_quotation_header_in-sd_doc_cat = 'B'.

      ls_quotation_header_in-sales_dist = <fs_i_new_ventap_h>-zona_venta.
      ls_quotation_header_in-pp_search = <fs_i_new_ventap_h>-obra.
      ls_quotation_header_in-pmnttrms = <fs_i_new_ventap_h>-condicion_pago.
      lv_total_fiori = <fs_i_new_ventap_h>-sub_total.

************************************ LLENADO DE LA PRIMERA TABLA *******************************************************
      READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
      IF sy-subrc EQ 0.

        lv_cliente = <fs_kna1>-xcpdk.

      ENDIF.

      READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
      IF sy-subrc EQ 0.

        lv_destina = <fs_kna12>-xcpdk.

      ENDIF.


      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'AG'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-cliente.
      IF lv_cliente EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventap_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventap_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.
        CLEAR lv_nit.
        CONCATENATE 'AG' <fs_i_new_ventap_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

        CLEAR lv_nit.
        CONCATENATE 'RG' <fs_i_new_ventap_h>-nit INTO lv_nit.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RE'.
      IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventap_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventap_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.

        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'RE' <fs_i_new_ventap_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'RE' <fs_i_new_ventap_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'RP'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-cliente.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'BU'.
      IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-cliente.

      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'WE'.
      IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-bill_to.
      ELSE.
        <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-cliente.
      ENDIF.
      IF lv_destina EQ 'X'.
        <fs_quotation_partners>-name = lv_nombre1.
        <fs_quotation_partners>-name_2 = lv_nombre2.
        <fs_quotation_partners>-name_3 = lv_nombre3.
        <fs_quotation_partners>-name_4 = lv_nombre4.
        <fs_quotation_partners>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_quotation_partners>-telephone = <fs_i_new_ventap_h>-telefono.
        <fs_quotation_partners>-country = <fs_i_new_ventap_h>-pais.
        <fs_quotation_partners>-langu   = 'S'.
        <fs_quotation_partners>-addr_link = '1'.
        APPEND INITIAL LINE TO lt_partneraddresses ASSIGNING <fs_partneraddresses>.
        <fs_partneraddresses>-addr_no = '1'.
        <fs_partneraddresses>-name = lv_nombre1.
        <fs_partneraddresses>-name_2 = lv_nombre2.
        <fs_partneraddresses>-name_3 = lv_nombre3.
        <fs_partneraddresses>-name_4 = lv_nombre4.
        <fs_partneraddresses>-street = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
        <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
        <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
        <fs_partneraddresses>-langu   = 'S'.

        CLEAR lv_nit.
        IF lv_cliente EQ 'X'.
          CONCATENATE 'WE' <fs_i_new_ventap_h>-nit INTO lv_nit.
        ELSE.
          CONCATENATE 'wE' <fs_i_new_ventap_h>-nit_cpd INTO lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_extensionin ASSIGNING <fs_extensionin>.
        <fs_extensionin>-structure = 'STCD1'.
        <fs_extensionin>-valuepart1 = lv_nit.
      ENDIF.

      APPEND INITIAL LINE TO lt_quotation_partners ASSIGNING <fs_quotation_partners>.
      <fs_quotation_partners>-partn_role = 'VE'.
      <fs_quotation_partners>-partn_numb = <fs_i_new_ventap_h>-solicitante.

* ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
      CONCATENATE  <fs_i_new_ventap_h>-nota_envio ' ' <fs_i_new_ventap_h>-coordenada INTO lv_text_line.

      APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
      <fs_quotation_text>-text_id = 'TX04'.
      <fs_quotation_text>-langu = 'S'.
      <fs_quotation_text>-text_line = <fs_i_new_ventap_h>-coordenada.

      lv_input = <fs_i_new_ventap_h>-nota_envio.
      CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
        EXPORTING
          input_string         = lv_input
          max_component_length = 132
        TABLES
          string_components    = lt_string_components.
      LOOP AT lt_string_components ASSIGNING FIELD-SYMBOL(<fs_stringx>).
        APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
        <fs_quotation_text>-text_id = 'TX14'.
        <fs_quotation_text>-langu = 'S'.
        <fs_quotation_text>-text_line = <fs_stringx>-str.
      ENDLOOP.

      LOOP AT i_new_ventap_p ASSIGNING <fs_i_new_ventap_p>.

* ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************

        IF <fs_i_new_ventap_p>-nota_fabricacion IS NOT INITIAL.

          CLEAR lv_input. FREE lt_string_components.
          lv_input = <fs_i_new_ventap_p>-nota_fabricacion.
          CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
            EXPORTING
              input_string         = lv_input
              max_component_length = 132
            TABLES
              string_components    = lt_string_components.
          LOOP AT lt_string_components ASSIGNING <fs_string>.
            APPEND INITIAL LINE TO lt_quotation_text ASSIGNING <fs_quotation_text>.
            <fs_quotation_text>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_text>-text_id = '0006'.
            <fs_quotation_text>-langu = 'S'.
            <fs_quotation_text>-text_line = <fs_string>-str.
          ENDLOOP.

        ENDIF.

        IF <fs_i_new_ventap_p>-condp EQ '1'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventap_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventap_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventap_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventap_p>-condicion_pago.

        ELSEIF <fs_i_new_ventap_p>-condp EQ '2'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.

        ELSEIF <fs_i_new_ventap_p>-condp EQ '3'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventap_p>-condicion_pago.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventap_p>-importe_pago.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventap_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventap_p>-condicion_pago.

          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
          <fs_quotation_conditions_in>-cond_unit = '%'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.

        ELSEIF <fs_i_new_ventap_p>-condp EQ '4'.
          APPEND INITIAL LINE TO lt_quotation_conditions_in ASSIGNING <fs_quotation_conditions_in>.
          <fs_quotation_conditions_in>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_in>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
          <fs_quotation_conditions_in>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
          <fs_quotation_conditions_in>-currency = <fs_i_new_ventap_h>-moneda.
          <fs_quotation_conditions_in>-calctypcon = 'B'.

          APPEND INITIAL LINE TO lt_quotation_conditions_inx ASSIGNING <fs_quotation_conditions_inx>.
          <fs_quotation_conditions_inx>-updateflag = 'I'.
          <fs_quotation_conditions_inx>-cond_value = 'X'.
          <fs_quotation_conditions_inx>-currency = 'X'.
          <fs_quotation_conditions_inx>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_conditions_inx>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.

        ENDIF.

* ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_schedules_in ASSIGNING <fs_quotation_schedules_in>.
        <fs_quotation_schedules_in>-itm_number = <fs_i_new_ventap_p>-posicion.
        <fs_quotation_schedules_in>-req_date = <fs_i_new_ventap_h>-fecha_precio.
        <fs_quotation_schedules_in>-req_qty = <fs_i_new_ventap_p>-cantidad.

* ********************************** CUARTE DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_items_in ASSIGNING <fs_quotation_items_in>.
        <fs_quotation_items_in>-pmnttrms = <fs_i_new_ventap_h>-condicion_pago.
        <fs_quotation_items_in>-sales_dist = <fs_i_new_ventap_h>-zona_venta.
        <fs_quotation_items_in>-itm_number = <fs_i_new_ventap_p>-posicion.
        <fs_quotation_items_in>-po_itm_no = <fs_i_new_ventap_p>-posicion.
        <fs_quotation_items_in>-material = <fs_i_new_ventap_p>-articulo.
        <fs_quotation_items_in>-batch = <fs_i_new_ventap_p>-lote.
        <fs_quotation_items_in>-plant = <fs_i_new_ventap_p>-centro.
        <fs_quotation_items_in>-target_qty = <fs_i_new_ventap_p>-cantidad.
        <fs_quotation_items_in>-target_qu = <fs_i_new_ventap_p>-unidad_medida.
*        <fs_quotation_items_in>-item_categ = 'AGN'."DELETE @0100 Caso programacion stock y almacen
        <fs_quotation_items_in>-gross_wght = <fs_i_new_ventap_p>-peso_neto.
        <fs_quotation_items_in>-net_weight = <fs_i_new_ventap_p>-peso_neto.
        <fs_quotation_items_in>-untof_wght = 'KG'.
        <fs_quotation_items_in>-route = <fs_i_new_ventap_p>-ruta.
        <fs_quotation_items_in>-po_quan = <fs_i_new_ventap_p>-cantidad.
        <fs_quotation_items_in>-reason_rej = <fs_i_new_ventap_p>-motivo_rechazo.
        IF <fs_i_new_ventap_p>-tipo_posc IS NOT INITIAL.
          <fs_quotation_items_in>-ref_1 = <fs_i_new_ventap_p>-tipo_posc.
        ELSE.
          <fs_quotation_items_in>-ref_1 = 'AGN'.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

    TRY.
        DELETE ADJACENT DUPLICATES FROM lt_quotation_text.
        CALL FUNCTION 'BAPI_QUOTATION_CREATEFROMDATA2'
          EXPORTING
            quotation_header_in      = ls_quotation_header_in
          IMPORTING
            salesdocument            = lv_salesdocument
          TABLES
            return                   = lt_returnbp
            quotation_items_in       = lt_quotation_items_in
            quotation_partners       = lt_quotation_partners
            quotation_conditions_in  = lt_quotation_conditions_in
            quotation_conditions_inx = lt_quotation_conditions_inx
            quotation_schedules_in   = lt_quotation_schedules_in
            quotation_text           = lt_quotation_text
            extensionin              = lt_extensionin
            partneraddresses         = lt_partneraddresses.

        IF lv_salesdocument IS INITIAL.

          LOOP AT lt_returnbp ASSIGNING <fs_returnbp>.

            CONCATENATE lv_errorbp <fs_returnbp>-type ' / ' <fs_returnbp>-id ' / ' <fs_returnbp>-number ' / ' <fs_returnbp>-message ' - ' INTO lv_errorbp.

          ENDLOOP.

        ELSE.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          WAIT UP TO 1 SECONDS.

        ENDIF.

      CATCH cx_sy_zerodivide INTO go_error.

        lv_errorch = go_error->get_text( ).

        lv_error = 'X'.

    ENDTRY.


    IF lv_errorbp IS INITIAL.

******************************************************** CREAR EL PEDIDO ******************************************************************
*******************************************************************************************************************************************

      LOOP AT i_new_ventap_h ASSIGNING <fs_i_new_ventap_h>.
        CLEAR gv_sociedad.
        gv_sociedad = <fs_i_new_ventap_h>-organizacion_venta.
* **************************** LLENADO DE LA ESTRUCTURA ********************************************************

        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          ls_quotation_header_in2-doc_type = <fs_zparametros>-doc_type_p.
          IF lv_fact EQ 'M'.
            IF lv_tipo EQ 'P'.
              ls_quotation_header_in2-ship_cond = <fs_i_new_ventap_h>-motivo_expedicion.
            ELSEIF lv_tipo EQ 'R'.
              ls_quotation_header_in2-ship_cond = '02'.
            ENDIF.
          ELSE.
            ls_quotation_header_in2-ship_cond = <fs_zparametros>-indi_expedi.
          ENDIF.
        ENDIF.

        ls_quotation_header_in2-ord_reason = <fs_i_new_ventap_h>-motivo_pedido.
        ls_quotation_header_in2-ref_doc = lv_salesdocument.
        ls_quotation_header_in2-refdoc_cat = 'B'.
        ls_quotation_header_in2-sd_doc_cat = 'C'.
        ls_quotation_header_in2-sales_org = <fs_i_new_ventap_h>-organizacion_venta.
        ls_quotation_header_in2-distr_chan = <fs_i_new_ventap_h>-canal.
        ls_quotation_header_in2-division   = <fs_i_new_ventap_h>-sector.
        ls_quotation_header_in2-sales_grp = <fs_i_new_ventap_h>-grupo_vendedores.
        ls_quotation_header_in2-sales_off = <fs_i_new_ventap_h>-oficina.
        ls_quotation_header_in2-req_date_h = <fs_i_new_ventap_h>-fecha_entrega.
        ls_quotation_header_in2-price_date = sy-datum.
        ls_quotation_header_in2-qt_valid_t = <fs_i_new_ventap_h>-fecha_oferta.
        ls_quotation_header_in2-purch_no_c = <fs_i_new_ventap_h>-referencia_cliente.
        ls_quotation_header_in2-req_date_h = <fs_i_new_ventap_h>-fecha_entrega.
        ls_quotation_header_in2-ct_valid_f = <fs_i_new_ventap_h>-fecha_precio.
        ls_quotation_header_in2-ct_valid_t = <fs_i_new_ventap_h>-fecha_oferta.

        ls_quotation_header_in2-sales_dist = <fs_i_new_ventap_h>-zona_venta.
        ls_quotation_header_in2-pp_search = <fs_i_new_ventap_h>-obra.
        ls_quotation_header_in2-pmnttrms = <fs_i_new_ventap_h>-condicion_pago.

*  *********************************** LLENADO DE LA PRIMERA TABLA *******************************************************
        READ TABLE lt_kna1 ASSIGNING <fs_kna1> INDEX 1.
        IF sy-subrc EQ 0.

          lv_cliente = <fs_kna1>-xcpdk.

        ENDIF.

        READ TABLE lt_kna12 ASSIGNING <fs_kna12> INDEX 1.
        IF sy-subrc EQ 0.

          lv_destina = <fs_kna12>-xcpdk.

        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'AG'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-cliente.
        IF lv_cliente EQ 'X'.
          <fs_quotation_partners2>-name = lv_nombre1.
          <fs_quotation_partners2>-name_2 = lv_nombre2.
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
          <fs_quotation_partners2>-street = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventap_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventap_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.
          APPEND INITIAL LINE TO lt_partneraddresses2 ASSIGNING <fs_partneraddresses>.
          <fs_partneraddresses>-addr_no = '1'.
          <fs_partneraddresses>-name = lv_nombre1.
          <fs_partneraddresses>-name_2 = lv_nombre2.
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
          <fs_partneraddresses>-street_lng = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
          <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
          <fs_partneraddresses>-langu   = 'S'.
          CLEAR lv_nit.
          CONCATENATE 'AG' <fs_i_new_ventap_h>-nit INTO lv_nit.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.

          CLEAR lv_nit.
          CONCATENATE 'RG' <fs_i_new_ventap_h>-nit INTO lv_nit.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.

        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'RE'.
        IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-cliente.
        ENDIF.
        IF lv_destina EQ 'X'.
          <fs_quotation_partners2>-name = lv_nombre1.
          <fs_quotation_partners2>-name_2 = lv_nombre2.
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
          <fs_quotation_partners2>-street = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventap_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventap_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.
          APPEND INITIAL LINE TO lt_partneraddresses2 ASSIGNING <fs_partneraddresses>.
          <fs_partneraddresses>-addr_no = '1'.
          <fs_partneraddresses>-name = lv_nombre1.
          <fs_partneraddresses>-name_2 = lv_nombre2.
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
          <fs_partneraddresses>-street_lng = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
          <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
          <fs_partneraddresses>-langu   = 'S'.
          CLEAR lv_nit.
          IF lv_cliente EQ 'X'.
            CONCATENATE 'RE' <fs_i_new_ventap_h>-nit INTO lv_nit.
          ELSE.
            CONCATENATE 'RE' <fs_i_new_ventap_h>-nit_cpd INTO lv_nit.
          ENDIF.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'RP'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-cliente.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'BU'.
        IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-cliente.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'WE'.
        IF <fs_i_new_ventap_h>-bill_to IS NOT INITIAL.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-bill_to.
        ELSE.
          <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-cliente.

        ENDIF.
        IF lv_destina EQ 'X'.

          <fs_quotation_partners2>-name = lv_nombre1.
          <fs_quotation_partners2>-name_2 = lv_nombre2.
          <fs_quotation_partners2>-name_3 = lv_nombre3.
          <fs_quotation_partners2>-name_4 = lv_nombre4.
          <fs_quotation_partners2>-street = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_quotation_partners2>-telephone = <fs_i_new_ventap_h>-telefono.
          <fs_quotation_partners2>-country = <fs_i_new_ventap_h>-pais.
          <fs_quotation_partners2>-langu   = 'S'.
          <fs_quotation_partners2>-addr_link = '1'.
          APPEND INITIAL LINE TO lt_partneraddresses2 ASSIGNING <fs_partneraddresses>.
          <fs_partneraddresses>-addr_no = '1'.
          <fs_partneraddresses>-name = lv_nombre1.
          <fs_partneraddresses>-name_2 = lv_nombre2.
          <fs_partneraddresses>-name_3 = lv_nombre3.
          <fs_partneraddresses>-name_4 = lv_nombre4.
          <fs_partneraddresses>-street_lng = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-city = <fs_i_new_ventap_h>-direccion3.
          <fs_partneraddresses>-tel1_numbr = <fs_i_new_ventap_h>-telefono.
          <fs_partneraddresses>-country = <fs_i_new_ventap_h>-pais.
          <fs_partneraddresses>-langu   = 'S'.
          CLEAR lv_nit.
          IF lv_cliente EQ 'X'.
            CONCATENATE 'WE' <fs_i_new_ventap_h>-nit INTO lv_nit.
          ELSE.
            CONCATENATE 'WE' <fs_i_new_ventap_h>-nit_cpd INTO lv_nit.
          ENDIF.

          APPEND INITIAL LINE TO lt_extensionin2 ASSIGNING <fs_extensionin2>.
          <fs_extensionin2>-structure = 'STCD1'.
          <fs_extensionin2>-valuepart1 = lv_nit.
        ENDIF.

        APPEND INITIAL LINE TO lt_quotation_partners2 ASSIGNING <fs_quotation_partners2>.
        <fs_quotation_partners2>-partn_role = 'VE'.
        <fs_quotation_partners2>-partn_numb = <fs_i_new_ventap_h>-solicitante.

*   ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
        APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
        <fs_quotation_text2>-text_id = 'TX04'.
        <fs_quotation_text2>-langu = 'S'.
        <fs_quotation_text2>-text_line = <fs_i_new_ventap_h>-coordenada.

        CLEAR lv_input.
        FREE lt_string_components.
        lv_input = <fs_i_new_ventap_h>-nota_envio.
        CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
          EXPORTING
            input_string         = lv_input
            max_component_length = 132
          TABLES
            string_components    = lt_string_components.
        LOOP AT lt_string_components ASSIGNING <fs_string>.
          APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
          <fs_quotation_text2>-text_id = 'TX14'.
          <fs_quotation_text2>-langu = 'S'.
          <fs_quotation_text2>-text_line = <fs_string>-str.
        ENDLOOP.

        LOOP AT i_new_ventap_p ASSIGNING <fs_i_new_ventap_p>.

          IF <fs_i_new_ventap_p>-nota_fabricacion IS NOT INITIAL.

            CLEAR lv_input. FREE lt_string_components.
            lv_input = <fs_i_new_ventap_p>-nota_fabricacion.
            CALL FUNCTION 'Y_ABAP_STRING_SPLIT'
              EXPORTING
                input_string         = lv_input
                max_component_length = 132
              TABLES
                string_components    = lt_string_components.
            LOOP AT lt_string_components ASSIGNING <fs_string>.
              APPEND INITIAL LINE TO lt_quotation_text2 ASSIGNING <fs_quotation_text2>.
              <fs_quotation_text2>-text_id = '0006'.
              <fs_quotation_text2>-langu = 'S'.
              <fs_quotation_text2>-text_line = <fs_string>-str.
              <fs_quotation_text2>-itm_number = <fs_i_new_ventap_p>-posicion.
            ENDLOOP.

          ENDIF.

*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************
          APPEND INITIAL LINE TO lt_quotation_schedules_in2 ASSIGNING <fs_quotation_schedules_in2>.
          <fs_quotation_schedules_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_schedules_in2>-req_date = <fs_i_new_ventap_h>-fecha_precio.
          <fs_quotation_schedules_in2>-req_qty = <fs_i_new_ventap_p>-cantidad.

*     ********************************** SEGUNDA DE LA PRIMERA TABLA *******************************************************
          IF <fs_i_new_ventap_p>-condp EQ '1'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventap_p>-condicion_pago.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventap_p>-importe_pago.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventap_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventap_p>-condicion_pago.

          ELSEIF <fs_i_new_ventap_p>-condp EQ '2'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
            <fs_quotation_conditions_in2>-cond_unit = '%'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.

          ELSEIF <fs_i_new_ventap_p>-condp EQ '3'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventap_p>-condicion_pago.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventap_p>-importe_pago.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventap_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventap_p>-condicion_pago.

            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
            <fs_quotation_conditions_in2>-cond_unit = '%'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.

          ELSEIF <fs_i_new_ventap_p>-condp EQ '4'.
            APPEND INITIAL LINE TO lt_quotation_conditions_in2 ASSIGNING <fs_quotation_conditions_in2>.
            <fs_quotation_conditions_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_in2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.
            <fs_quotation_conditions_in2>-cond_value = <fs_i_new_ventap_p>-importe_decuento.
            <fs_quotation_conditions_in2>-currency = <fs_i_new_ventap_h>-moneda.
            <fs_quotation_conditions_in2>-calctypcon = 'B'.

            APPEND INITIAL LINE TO lt_quotation_conditions_inx2 ASSIGNING <fs_quotation_conditions_inx2>.
            <fs_quotation_conditions_inx2>-updateflag = 'I'.
            <fs_quotation_conditions_inx2>-cond_value = 'X'.
            <fs_quotation_conditions_inx2>-currency = 'X'.
            <fs_quotation_conditions_inx2>-itm_number = <fs_i_new_ventap_p>-posicion.
            <fs_quotation_conditions_inx2>-cond_type = <fs_i_new_ventap_p>-condicion_descuento.


          ENDIF.


*   ********************************** TERCERA DE LA PRIMERA TABLA *******************************************************

          APPEND INITIAL LINE TO lt_quotation_items_in2 ASSIGNING <fs_quotation_items_in2>.
          <fs_quotation_items_in2>-pmnttrms = <fs_i_new_ventap_h>-condicion_pago.
          <fs_quotation_items_in2>-sales_dist = <fs_i_new_ventap_h>-zona_venta.
          <fs_quotation_items_in2>-ref_doc = lv_salesdocument.
          <fs_quotation_items_in2>-ref_doc_it = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_items_in2>-ref_doc_ca = 'B'.
          <fs_quotation_items_in2>-itm_number = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_items_in2>-po_itm_no = <fs_i_new_ventap_p>-posicion.
          <fs_quotation_items_in2>-material = <fs_i_new_ventap_p>-articulo.
          <fs_quotation_items_in2>-batch = <fs_i_new_ventap_p>-lote.
          <fs_quotation_items_in2>-plant = <fs_i_new_ventap_p>-centro.
          <fs_quotation_items_in2>-target_qty = <fs_i_new_ventap_p>-cantidad.
          <fs_quotation_items_in2>-target_qu = <fs_i_new_ventap_p>-unidad_medida.
          <fs_quotation_items_in2>-gross_wght = <fs_i_new_ventap_p>-peso_bruto.
          <fs_quotation_items_in2>-net_weight = <fs_i_new_ventap_p>-peso_bruto.
          <fs_quotation_items_in2>-untof_wght = 'KG'.
          <fs_quotation_items_in2>-po_quan = <fs_i_new_ventap_p>-cantidad.
          <fs_quotation_items_in2>-route = <fs_i_new_ventap_p>-ruta.
          <fs_quotation_items_in2>-reason_rej = <fs_i_new_ventap_p>-motivo_rechazo.

          IF <fs_i_new_ventap_p>-tipo_posc IS NOT INITIAL.
            <fs_quotation_items_in2>-item_categ = <fs_i_new_ventap_p>-tipo_posc.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

      TRY.

          DELETE ADJACENT DUPLICATES FROM lt_quotation_text2.
          CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
            EXPORTING
              order_header_in      = ls_quotation_header_in2
              convert              = ' '
            IMPORTING
              salesdocument        = lv_salesdocument2
            TABLES
              return               = lt_returnbp2
              order_items_in       = lt_quotation_items_in2
              order_partners       = lt_quotation_partners2
              order_schedules_in   = lt_quotation_schedules_in2
              order_conditions_in  = lt_quotation_conditions_in2
              order_conditions_inx = lt_quotation_conditions_inx2
              order_text           = lt_quotation_text2
              extensionin          = lt_extensionin2
              partneraddresses     = lt_partneraddresses2.

          IF lv_salesdocument2 IS INITIAL.

            LOOP AT lt_returnbp2 ASSIGNING <fs_returnbp2>.

              CONCATENATE lv_errorbp2 <fs_returnbp2>-type ' / ' <fs_returnbp2>-id ' / ' <fs_returnbp2>-number ' / ' <fs_returnbp2>-message ' - ' INTO lv_errorbp2.

            ENDLOOP.

          ELSE.

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

            WAIT UP TO 1 SECONDS.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.


      CLEAR: lv_diferencia, lv_total_sap, lv_net_val, lv_suma_iva, lt_conditions_in, lt_conditions_inx, lt_conditions_in2, lt_conditions_inx2.

    ENDIF.

    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL.

******************************************************** CREAR LA FACTURA ******************************************************************
********************************************************************************************************************************************

      LOOP AT i_new_ventap_h ASSIGNING <fs_i_new_ventap_h>.

        APPEND INITIAL LINE TO lt_billingdatain ASSIGNING <fs_billingdatain>.
        <fs_billingdatain>-doc_number = lv_salesdocument2.
        <fs_billingdatain>-ref_doc = lv_salesdocument2.
        <fs_billingdatain>-ref_doc_ca = 'C'.
        <fs_billingdatain>-bill_date = sy-datum.
        READ TABLE lt_zparametros ASSIGNING <fs_zparametros> INDEX 1.
        IF sy-subrc EQ 0.
          <fs_billingdatain>-ordbilltyp = <fs_zparametros>-doc_type_f.
        ENDIF.
        .

      ENDLOOP.

      TRY.

          CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
            TABLES
              billingdatain = lt_billingdatain
              return        = lt_returnbp3
              success       = lt_success.

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.
          WAIT UP TO '0.5' SECONDS.

          IF lt_success IS INITIAL.

            LOOP AT lt_returnbp3 ASSIGNING <fs_returnbp3>.

              CONCATENATE lv_errorbp3 <fs_returnbp3>-type ' / ' <fs_returnbp3>-id ' / ' <fs_returnbp3>-number ' / ' <fs_returnbp3>-message ' - ' INTO lv_errorbp3.

            ENDLOOP.

          ELSE.

            READ TABLE lt_success ASSIGNING <fs_success> INDEX 1.
            IF sy-subrc EQ 0.

              lv_factura = <fs_success>-bill_doc.

              IMPORT ldt_return = ldt_return FROM MEMORY ID 'ZSD_PRINTMSJ'.


            ENDIF.

          ENDIF.

        CATCH cx_sy_zerodivide INTO go_error.

          lv_errorch = go_error->get_text( ).

          lv_error = 'X'.

      ENDTRY.

    ENDIF.


    IF lv_errorbp IS INITIAL AND lv_errorbp2 IS INITIAL AND lv_errorbp3 IS INITIAL.

      IF lv_fact EQ 'M'.

        CONCATENATE 'DOCUMENTO COTIZACION: ' lv_salesdocument ' - PEDIDO: ' lv_salesdocument2 ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.
        CONCATENATE lv_salesdocument '-' lv_salesdocument2 '-' lv_factura INTO lv_salidah.


        rt_return-message = 'Se creo la Factura Manual exitosamente'.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.
        rt_return-datah = lv_salidah.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        CONCATENATE 'DOCUMENTO COTIZACION: ' lv_salesdocument ' - PEDIDO: ' lv_salesdocument2 ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.
        CONCATENATE lv_salesdocument '-' lv_salesdocument2 '-' lv_factura INTO lv_salidah.


        rt_return-message = 'Se creo la Venta Programada exitosamente'.
        rt_return-messcode = '200'.
        rt_return-data = lv_salida.
        rt_return-datah = lv_salidah.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.

    ELSE.

      CONCATENATE 'DOCUMENTO COTIZACION: ' lv_salesdocument 'DOCUMENTO PEDIDO: ' lv_salesdocument2 ' - FACTURA: ' lv_factura cl_abap_char_utilities=>newline ldt_return INTO lv_salida.

      IF lv_errorbp IS NOT INITIAL.

        CONCATENATE 'Cotizacion con Error : ' lv_errorbp INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.

      ELSEIF lv_errorbp2 IS NOT INITIAL.

        CONCATENATE 'Error en el pedido: ' lv_errorbp2 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ELSEIF lv_errorbp3 IS NOT INITIAL.

        CONCATENATE 'Error en la Factura : ' lv_errorbp3 INTO lv_message.

        rt_return-message = lv_message.
        rt_return-messcode = '400'.
        rt_return-data = lv_salida.

      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
