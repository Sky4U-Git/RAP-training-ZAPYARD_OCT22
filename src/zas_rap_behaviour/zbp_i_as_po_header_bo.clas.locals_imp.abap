CLASS lhc_ZI_AS_PO_HEADER_BO DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_as_po_header_bo RESULT result.

ENDCLASS.

CLASS lhc_ZI_AS_PO_HEADER_BO IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
