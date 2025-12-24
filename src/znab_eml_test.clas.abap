CLASS znab_eml_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS znab_eml_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    READ ENTITIES OF znab_rap_travel
    ENTITY travel
    ALL FIELDS
    WITH VALUE #( ( TravelId = '00000022' ) )
    RESULT DATA(lt_travels)
    BY \_bookings
    ALL FIELDS
    WITH VALUE #( (  TravelId = '00000022' ) ( TravelId = '00000023' ) )
    RESULT DATA(lt_bookings)
    LINK DATA(lt_link)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_messages).

    out->write(
      EXPORTING
        data   = lt_travels
    ).

    out->write(
        EXPORTING
          data   = lt_bookings
      ).

   out->write(
        EXPORTING
          data   = lt_link
      ).

  ENDMETHOD.
ENDCLASS.
