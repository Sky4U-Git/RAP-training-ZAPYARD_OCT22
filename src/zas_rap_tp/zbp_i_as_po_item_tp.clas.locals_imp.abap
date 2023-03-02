CLASS lhc_zi_as_po_item_tp DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateTotalPrice FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZI_AS_PO_item_TP~CalculateTotalPrice.

ENDCLASS.

CLASS lhc_zi_as_po_item_tp IMPLEMENTATION.

  METHOD CalculateTotalPrice.
    DATA: lv_order_total TYPE p LENGTH 10 DECIMALS 2.

    READ ENTITIES OF zi_as_po_header_tp IN LOCAL MODE
      ENTITY zi_as_po_item_tp ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_item).

*Calculate Overall price
    LOOP AT lt_item INTO DATA(ls_item).
      lv_order_total = ( ls_item-OrderQunt * ls_item-ProductPrice ) + lv_order_total.
    ENDLOOP.
    IF lv_order_total > 1000.
*Update Order
      MODIFY ENTITY IN LOCAL MODE zi_as_po_header_tp
         UPDATE FIELDS ( OrderStatus )
         WITH VALUE #( ( PurchaseOrder = VALUE #( lt_item[ 1 ]-PurchaseOrder OPTIONAL )
                         OrderStatus = '01' )  ) REPORTED DATA(lt_reported).

    ENDIF.
  ENDMETHOD.

ENDCLASS.
