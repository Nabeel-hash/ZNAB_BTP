CLASS znab_eml_update_entities DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS znab_eml_update_entities IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF znab_rap_travel
    ENTITY booking
    DELETE FROM
    VALUE #( (  TravelId = '00000111' BookingId = '0003' ) )
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    COMMIT ENTITIES.

    out->write(
    EXPORTING
    data   = lt_mapped
).

    out->write(
        EXPORTING
          data   = lt_failed
      ).

    out->write(
        EXPORTING
          data   = lt_reported
      ).

  ENDMETHOD.
ENDCLASS.
