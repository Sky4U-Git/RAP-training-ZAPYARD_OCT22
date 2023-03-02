CLASS lhc_ZI_AS_PO_HEADER_TP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_as_po_header_tp RESULT result.
    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION zi_as_po_header_tp~copy RESULT result.

    METHODS withdrawapproval FOR MODIFY
      IMPORTING keys FOR ACTION zi_as_po_header_tp~withdrawapproval RESULT result.
    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION zi_as_po_header_tp~approve RESULT result.
    METHODS orderstatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_as_po_header_tp~orderstatus.
    METHODS earlynumbering_cba_poattachmen FOR NUMBERING
      IMPORTING entities FOR CREATE zi_as_po_header_tp\_poattachments.
    METHODS earlynumbering_cba_purchaseite FOR NUMBERING
      IMPORTING entities FOR CREATE zi_as_po_header_tp\_purchaseitems.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_as_po_header_tp.

ENDCLASS.

CLASS lhc_ZI_AS_PO_HEADER_TP IMPLEMENTATION.

  METHOD get_instance_authorizations.
    DATA(lv_keys) = keys.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA: lv_max_po TYPE ebeln.

    SELECT FROM zc_as_po_header_tp
           FIELDS MAX( PurchaseOrder )
           INTO @lv_max_po.
    IF sy-subrc EQ 0.
      LOOP AT entities INTO DATA(ls_entities).
        lv_max_po += 1.
        ls_entities-PurchaseOrder = lv_max_po = |{ lv_max_po ALPHA = IN }|.
        APPEND VALUE #( %cid = ls_entities-%cid
                        %is_draft = ls_entities-%is_draft
                         purchaseorder = ls_entities-PurchaseOrder ) TO mapped-zi_as_po_header_tp.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD earlynumbering_cba_Purchaseite.
    DATA: lv_item TYPE ebelp.

    READ ENTITY IN LOCAL MODE zi_as_po_header_tp
         BY \_PurchaseItems ALL FIELDS WITH CORRESPONDING #( entities )
         RESULT DATA(lt_purchaseItems).


    LOOP AT entities INTO DATA(ls_entities).
      SELECT FROM @lt_purchaseItems AS lt_Item FIELDS MAX( PurchaseItem )
                                               WHERE PurchaseOrder = @ls_entities-PurchaseOrder
                                               INTO @lv_item.


      LOOP AT ls_entities-%target INTO DATA(ls_item).
        IF ls_entities-%is_draft = '01'.
          lv_item += 10.
        ELSE.
          lv_item = ls_item-PurchaseItem.
        ENDIF.
        lv_item = |{ lv_item ALPHA = IN }|.
        ls_item-PurchaseItem = lv_item.
        APPEND VALUE #(  %cid = ls_item-%cid
                         %tky = ls_entities-%tky
                         %key = ls_item-%key   ) TO mapped-zi_as_po_item_tp.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD Copy.

    DATA: lt_keys TYPE TABLE FOR READ IMPORT zi_as_po_header_tp.

*Prepare Keys
    LOOP AT keys INTO DATA(ls_keys).
      APPEND VALUE #( %key = ls_keys-%key
                      %control-description = 01
                      %control-ordertype = 01
                      %control-companycode = 01
                      %control-organization = 01
                      %control-supplier = 01
                      ) TO lt_keys.
    ENDLOOP.
*Read source entity
    READ ENTITY IN LOCAL MODE zi_as_po_header_tp FROM lt_keys RESULT DATA(lt_source).
*Initialize status & update description
    LOOP AT lt_source ASSIGNING FIELD-SYMBOL(<lfs_source>).
      <lfs_source>-OrderStatus = '01'.
      <lfs_source>-Description = <lfs_source>-Description && '(copy)'.
    ENDLOOP.
*Create new entity(Triggers early Numbering for new entity)
    MODIFY ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
           ENTITY zi_as_po_header_tp
           CREATE
           AUTO FILL CID
           FIELDS ( description ordertype orderstatus companycode organization supplier )
           WITH CORRESPONDING #( lt_source )
           MAPPED DATA(lt_new_po_key).
*Retrieve new purchase order
    READ ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
    ENTITY zi_as_po_header_tp
    ALL FIELDS
    WITH CORRESPONDING #( lt_new_po_key-zi_as_po_header_tp )
    RESULT DATA(lt_new_po).
*Send new purchase order to UI
    LOOP AT lt_new_po INTO DATA(ls_new_po).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<lfs_result>).
      <lfs_result>-%cid_ref = VALUE #( keys[ sy-tabix ]-%cid_ref OPTIONAL ).
      <lfs_result>-%key = VALUE #( keys[ sy-tabix ]-%key OPTIONAL ).
      <lfs_result>-%param = CORRESPONDING #( ls_new_po ).
    ENDLOOP.
  ENDMETHOD.

  METHOD WithdrawApproval.
*Modify order status
    MODIFY ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
        ENTITY zi_as_po_header_tp
        UPDATE FIELDS ( orderstatus )
        WITH VALUE #( FOR ls_keys IN keys
                        ( %key = ls_keys-%key
                          orderstatus = '03' )  ) REPORTED DATA(lt_reported).
*Read entities for modifying status
    READ ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
        ENTITY zi_as_po_header_tp
        ALL FIELDS WITH
        CORRESPONDING #( keys ) RESULT DATA(lt_purchaseorder).
*Send changed data back to UI
    result = VALUE #( FOR ls_po IN lt_purchaseorder (
                     %key = ls_po-%key
                     %param = CORRESPONDING #( ls_po ) ) ).
  ENDMETHOD.

  METHOD Approve.
*Modify order status
    MODIFY ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
        ENTITY zi_as_po_header_tp
        UPDATE FIELDS ( orderstatus )
        WITH VALUE #( FOR ls_keys IN keys
                        ( %key = ls_keys-%key
                          orderstatus = '02' )  ) REPORTED DATA(lt_reported).
*Read entities for modifying status
    READ ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
        ENTITY zi_as_po_header_tp
        ALL FIELDS WITH
        CORRESPONDING #( keys ) RESULT DATA(lt_purchaseorder).
*Send changed data back to UI
    result = VALUE #( FOR ls_po IN lt_purchaseorder (
                     %key = ls_po-%key
                     %param = CORRESPONDING #( ls_po ) ) ).
  ENDMETHOD.

  METHOD OrderStatus.

*Read entity
    READ ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
        ENTITY zi_as_po_header_tp FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys ) RESULT DATA(lt_po).
*Check Status
    LOOP AT lt_po INTO DATA(ls_po).
      CASE ls_po-OrderStatus.
        WHEN '01' OR '02' OR '03'.
        WHEN OTHERS.
          APPEND VALUE #( %key = ls_po-%key ) TO failed-zi_as_po_header_tp.
          APPEND VALUE #( %key = ls_po-%key
                          %msg = NEW cl_abap_behv(  )->new_message_with_text(
                                                      severity = if_abap_behv_message=>severity-error
                                                      text     = 'Invalid Status! Use F4 help for correct status.'
                                                    )
                          %element-orderstatus = if_abap_behv=>mk-on
                          ) TO reported-zi_as_po_header_tp.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Poattachmen.
    DATA: lv_attachid TYPE zid.

*Read attachment entities
    READ ENTITY IN LOCAL MODE zi_as_po_header_tp
        BY \_PoAttachments ALL FIELDS WITH CORRESPONDING #( entities )
        RESULT DATA(lt_attachment).

    LOOP AT entities INTO DATA(ls_entities).
      SELECT FROM @lt_attachment AS attachments FIELDS MAX( AttachId )
                                                WHERE PurchaseOrder = @ls_entities-PurchaseOrder
                                                INTO @lv_attachid.
      LOOP AT ls_entities-%target INTO DATA(ls_attachment).
        IF ls_attachment-%is_draft = '01'.
          lv_attachid  = lv_attachid + 1.
        ELSE.
          lv_attachid = ls_attachment-AttachId.
        ENDIF.
        lv_attachid = | { lv_attachid ALPHA = IN } |.
        ls_attachment-AttachId = lv_attachid.
        APPEND VALUE #( %cid = ls_attachment-%cid
                        %tky = ls_entities-%tky
                        %key = ls_attachment-%key ) TO mapped-zi_as_po_attach_tp.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
