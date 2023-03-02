CLASS lcl_store_data DEFINITION.

  PUBLIC SECTION.
    TYPES:BEGIN OF gty_item_pid,
            pid                   TYPE sysuuid_x16,
            po_order              TYPE zas_po_item_db-po_order,
            po_item               TYPE zas_po_item_db-po_item,
            short_text            TYPE zas_po_item_db-short_text,
            material              TYPE zas_po_item_db-material,
            plant                 TYPE zas_po_item_db-plant,
            mat_group             TYPE zas_po_item_db-mat_group,
            Order_qunt            TYPE zas_po_item_db-order_qunt,
            order_unit            TYPE zas_po_item_db-order_unit,
            product_price         TYPE zas_po_item_db-product_price,
            price_unit            TYPE zas_po_item_db-price_unit,
            local_last_changed_by TYPE zas_po_item_db-local_last_changed_by,
            local_last_changed_at TYPE zas_po_item_db-local_last_changed_at,
          END OF gty_item_pid.
    CLASS-DATA: gt_header   TYPE STANDARD TABLE OF zas_po_header_db WITH DEFAULT KEY,
                gt_item     TYPE STANDARD TABLE OF zas_po_item_db WITH DEFAULT KEY,
                gt_item_pid TYPE STANDARD TABLE OF gty_item_pid WITH DEFAULT KEY.


ENDCLASS.
CLASS lhc_ZI_AS_PO_HEADER_UM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_as_po_header_um RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_as_po_header_um.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_as_po_header_um.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_as_po_header_um.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_as_po_header_um RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_as_po_header_um.

    METHODS rba_Purchaseitems FOR READ
      IMPORTING keys_rba FOR READ zi_as_po_header_um\_Purchaseitems FULL result_requested RESULT result LINK association_links.

    METHODS cba_Purchaseitems FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_as_po_header_um\_Purchaseitems.

ENDCLASS.

CLASS lhc_ZI_AS_PO_HEADER_UM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA lv_po TYPE ebeln.
    SELECT FROM zc_as_po_head_um
           FIELDS MAX( PurchaseOrder )
           INTO @lv_PO.
    IF NOT lv_po IS INITIAL.
      LOOP AT entities INTO DATA(ls_entities).
        lv_po = lv_po + 1.
        ls_entities-purchaseorder = lv_po.
        ls_entities-PurchaseOrder = |{ ls_entities-PurchaseOrder ALPHA = IN }|.
        ls_entities-OrderStatus = '01'.
        ls_entities-CreateBy = cl_abap_context_info=>get_user_technical_name(  ).
        GET TIME STAMP FIELD ls_entities-CreatedDateTime.
        APPEND CORRESPONDING #( ls_entities MAPPING FROM ENTITY ) TO lcl_store_data=>gt_header.
        APPEND VALUE #( %cid = ls_entities-%cid
                        %pid = ls_entities-PurchaseOrder  ) TO mapped-zi_as_po_header_um.

      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD update.
    DATA(lv_check) = abap_true.
    LOOP AT entities INTO DATA(ls_entities).
      reported-zi_as_po_header_um = VALUE #( ( %cid = ls_entities-%cid_ref
                                               %action-Edit = if_abap_behv=>fc-o-enabled
                                               %tky = ls_entities-%tky ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD read.
    DATA(lv_check) = abap_true.
    SELECT FROM zi_as_po_header_um FIELDS *
              FOR ALL ENTRIES IN @keys WHERE purchaseorder = @keys-PurchaseOrder
              INTO TABLE @DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD rba_Purchaseitems.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD cba_Purchaseitems.
    DATA: lv_item     TYPE ebelp,
          ls_item_pid TYPE lcl_store_data=>gty_item_pid.

    LOOP AT entities_cba INTO DATA(ls_entities_cba) .
      SELECT FROM zc_as_po_item_um
             FIELDS MAX( Purchaseitem )
             WHERE purchaseorder = @ls_entities_cba-PurchaseOrder
             INTO @lv_item.

      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
        lv_item += 10.
        ls_target-PurchaseItem = lv_item.
        ls_target-PurchaseItem = |{ ls_target-PurchaseItem ALPHA = IN }|.
        ls_target-PurchaseOrder = ls_entities_cba-PurchaseOrder.
        DATA(lv_pid) = |{ ls_entities_cba-PurchaseOrder }{ ls_target-PurchaseItem }|.
        APPEND INITIAL LINE TO lcl_store_data=>gt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
        <lfs_item> = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).
        ls_item_pid = CORRESPONDING #( <lfs_item> ).
        ls_item_pid-pid = lv_pid.
        APPEND ls_item_pid TO lcl_store_data=>gt_item_pid.
        APPEND VALUE #( %cid = ls_target-%cid
                        %pid = lv_pid
                        purchaseorder = ls_target-PurchaseOrder
                        purchaseitem = ls_target-PurchaseItem ) TO mapped-zi_as_po_item_um.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_AS_PO_ITEM_UM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_as_po_item_um.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_as_po_item_um.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_as_po_item_um RESULT result.

    METHODS rba_Purchaseheader FOR READ
      IMPORTING keys_rba FOR READ zi_as_po_item_um\_Purchaseheader FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_AS_PO_ITEM_UM IMPLEMENTATION.

  METHOD update.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD delete.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD read.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

  METHOD rba_Purchaseheader.
    DATA(lv_check) = abap_true.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_AS_PO_HEADER_UM DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_AS_PO_HEADER_UM IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    IF NOT lcl_store_data=>gt_header IS INITIAL.
      DATA(lt_header) = lcl_store_data=>gt_header[].
      MODIFY zas_po_header_db FROM TABLE @lt_header.
    ENDIF.
    IF NOT lcl_store_data=>gt_item_pid IS INITIAL.
      MOVE-CORRESPONDING lcl_store_data=>gt_item_pid TO lcl_store_data=>gt_item.
      DATA(lt_item) = lcl_store_data=>gt_item[].
      MODIFY zas_po_item_db FROM TABLE @lt_item.
    ENDIF.
  ENDMETHOD.

  METHOD adjust_numbers.

    LOOP AT lcl_store_data=>gt_header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      APPEND VALUE #( %pid = <lfs_head>-po_order
                      purchaseorder = <lfs_head>-po_order
                      ) TO mapped-zi_as_po_header_um.
    ENDLOOP.
    LOOP AT lcl_store_data=>gt_item_pid ASSIGNING FIELD-SYMBOL(<lfs_item>).
      APPEND VALUE #( %pid = <lfs_item>-pid
                      purchaseorder = <lfs_item>-po_order
                      purchaseitem = <lfs_item>-po_item ) TO mapped-zi_as_po_item_um.
    ENDLOOP.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
