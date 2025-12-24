CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Supplement FOR NUMBERING
      IMPORTING entities FOR CREATE booking\_Supplement.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Supplement.
    DATA:lv_max_suppl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY booking
    BY \_Supplement
    FROM CORRESPONDING #( entities )
    RESULT DATA(lt_result)
    LINK DATA(lt_supplement).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>) GROUP BY <fs_entities>-%tky.


      lv_max_suppl_id = REDUCE #( INIT lv_max = VALUE /dmo/booking_supplement_id(  )
                                  FOR ls_suppl IN lt_supplement USING KEY entity
                                  WHERE ( source-TravelId = <fs_entities>-TravelId
                                          AND source-BookingId = <fs_entities>-BookingId )
                                    NEXT lv_max = COND /dmo/booking_supplement_id(
                                    WHEN ls_suppl-target-BookingSupplementId > lv_max
                                    THEN ls_suppl-target-BookingSupplementId
                                    ELSE lv_max ) ).



      lv_max_suppl_id = REDUCE #( INIT lv_max = lv_max_suppl_id
                                  FOR ls_entity IN entities USING KEY entity WHERE
                                  ( TravelId = <fs_entities>-TravelId
                                    AND BookingId = <fs_entities>-BookingId )
                                    FOR ls_supplement IN ls_entity-%target
                                    NEXT lv_max = COND /dmo/booking_supplement_id(
                                    WHEN ls_supplement-BookingSupplementId > lv_max
                                    THEN ls_supplement-BookingSupplementId
                                    ELSE lv_max ) ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_travel>) USING KEY entity
                       WHERE TravelId = <fs_entities>-TravelId
                       AND BookingId = <fs_entities>-BookingId.

        LOOP AT <fs_travel>-%target ASSIGNING FIELD-SYMBOL(<fs_supplement>).
          APPEND CORRESPONDING #( <fs_supplement> )
            TO mapped-booksuppl ASSIGNING FIELD-SYMBOL(<fs_mapped>).
          IF <fs_supplement>-BookingSupplementId IS INITIAL.
            lv_max_suppl_id = lv_max_suppl_id  + 1.
            <fs_mapped>-BookingSupplementId = lv_max_suppl_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR travel RESULT result.
    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~copytravel.
    METHODS earlynumbering_cba_bookings FOR NUMBERING
      IMPORTING entities FOR CREATE travel\_bookings.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA: lv_travel_id TYPE /dmo/travel_id,
          lv_curr_num  TYPE i.

    DATA(lt_entities) = entities.

    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    IF lt_entities IS NOT INITIAL.
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr        = '01'
              object             = '/DMO/TRV_M'
              quantity          =  CONV #( lines( lt_entities ) )
            IMPORTING
              number            = DATA(lv_last_number)
              returncode        = DATA(lv_ret_code)
              returned_quantity = DATA(lv_qty)
          ).
        CATCH cx_nr_object_not_found INTO DATA(lx_not_found).
          LOOP AT entities INTO DATA(ls_entity).
            APPEND VALUE #( %cid = ls_entity-%cid
                            %key = ls_entity-%key  ) TO failed-travel.
          ENDLOOP.

          LOOP AT entities INTO ls_entity.
            APPEND VALUE #( %cid = ls_entity-%cid
                            %key = ls_entity-%key
                            %msg = lx_not_found ) TO reported-travel.
          ENDLOOP.
        CATCH cx_number_ranges INTO DATA(lx_num_range).
          LOOP AT entities INTO ls_entity.
            APPEND VALUE #( %cid = ls_entity-%cid
                            %key = ls_entity-%key  ) TO failed-travel.
          ENDLOOP.

          LOOP AT entities INTO ls_entity.
            APPEND VALUE #( %cid = ls_entity-%cid
                            %key = ls_entity-%key
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'Incorrect Number Range Object'
                                   ) ) TO reported-travel.
          ENDLOOP.
          EXIT.
      ENDTRY.

      IF lv_qty = lines( lt_entities ).
        lv_curr_num = lv_last_number - lv_qty.
        LOOP AT entities INTO ls_entity.
          lv_curr_num = lv_curr_num + 1.
          lv_travel_id = lv_curr_num.
          APPEND VALUE #( %cid     = ls_entity-%cid
                          travelid = lv_travel_id ) TO mapped-travel.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD earlynumbering_cba_Bookings.
    DATA: lv_max_curr_booking_id TYPE /dmo/booking_id.

    READ ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY travel
    BY \_bookings
    FROM CORRESPONDING #( entities )
    RESULT DATA(lt_result)
    LINK DATA(lt_curr_bookings).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>) GROUP BY <fs_entities>-TravelId.

*     If there are already booking id's present, get the max booking id
      lv_max_curr_booking_id = REDUCE #( INIT lv_max = VALUE /dmo/booking_id( )
                                         FOR LS_curr_book IN lt_curr_bookings USING KEY entity
                                         WHERE ( source-TravelId = <fs_entities>-TravelId  )
                                         NEXT lv_max = COND /dmo/booking_id(
                                                          WHEN LS_curr_book-target-BookingId >  lv_max
                                                          THEN ls_curr_book-target-BookingId
                                                          ELSE lv_max ) ).

*     If new booking id's passed by user
      lv_max_curr_booking_id = REDUCE #( INIT lv_max = lv_max_curr_booking_id
                                         FOR ls_entity IN entities USING KEY entity
                                         WHERE ( TravelId = <fs_entities>-TravelId )
                                         FOR ls_booking IN ls_entity-%target
                                         NEXT lv_max = COND /dmo/booking_id(
                                                          WHEN ls_booking-BookingId > lv_max
                                                          THEN ls_booking-BookingId
                                                          ELSE lv_max ) ).

* Loop all the entities for travel
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_travel>)
                       USING KEY entity WHERE TravelId = <fs_entities>-TravelId.
        LOOP AT <fs_travel>-%target ASSIGNING FIELD-SYMBOL(<fs_bookings>).
          APPEND CORRESPONDING #( <fs_bookings> ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<fs_mapped>).
          IF <fs_bookings>-BookingId IS INITIAL.
            lv_max_curr_booking_id = lv_max_curr_booking_id + 1.
            <fs_mapped>-BookingId = lv_max_curr_booking_id.

          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD copyTravel.
    DATA: lt_travels     TYPE TABLE FOR CREATE znab_rap_travel\\travel,
          lt_bookings    TYPE TABLE FOR CREATE znab_rap_travel\\travel\_bookings,
          lt_supplements TYPE TABLE FOR CREATE znab_rap_travel\\booking\_Supplement.

    READ TABLE keys WITH KEY %cid = ' ' INTO DATA(lv_with_initial_cid).
    ASSERT lv_with_initial_cid IS INITIAL.

* Read travel using EML
    READ ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_result)
    FAILED DATA(lt_travel_failed).

* Read booking using EML
    READ ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY travel
    BY \_bookings
    ALL FIELDS WITH CORRESPONDING #( lt_travel_result )
    RESULT DATA(lt_booking_result)
    FAILED DATA(lt_booking_failed).

* Read supplements using EML
    READ ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY booking
    BY \_Supplement
    ALL FIELDS WITH CORRESPONDING #( lt_booking_result )
    RESULT DATA(lt_supplement_result)
    FAILED DATA(lt_supplement_failed).

* loop the records of travel entity first
    LOOP AT lt_travel_result ASSIGNING FIELD-SYMBOL(<fs_travel_result>).

      APPEND VALUE #( %cid = keys[ KEY entity %tky = <fs_travel_result>-%tky ]-%cid
                      %data = CORRESPONDING #( <fs_travel_result> EXCEPT travelid ) )
       TO lt_travels ASSIGNING FIELD-SYMBOL(<fs_travels>).

      <fs_travels>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <fs_travels>-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <fs_travels>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = keys[ KEY entity  %tky = <fs_travel_result>-%tky ]-%cid )
       TO lt_bookings ASSIGNING FIELD-SYMBOL(<fs_bookings>).

      LOOP AT lt_booking_result ASSIGNING FIELD-SYMBOL(<fs_booking_result>)
                                USING KEY entity WHERE TravelId = <fs_travel_result>-TravelId.

        APPEND VALUE #( %cid = keys[ KEY entity  %tky = <fs_travel_result>-%tky ]-%cid &&
                                                        <fs_booking_result>-BookingId
                        %data = CORRESPONDING #( <fs_booking_result> EXCEPT travelid bookingid ) )
         TO <fs_bookings>-%target ASSIGNING FIELD-SYMBOL(<fs_booking_target>).

        <fs_booking_target>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <fs_travel_result>-%tky ]-%cid &&
                                                         <fs_booking_result>-BookingId )
       TO lt_supplements ASSIGNING FIELD-SYMBOL(<fs_supplement>).

      ENDLOOP.

      LOOP AT lt_supplement_result ASSIGNING FIELD-SYMBOL(<fs_suppl_result>)
                                   USING KEY entity WHERE TravelId = <fs_travel_result>-TravelId
                                                    AND BookingId = <fs_booking_result>-BookingId.
        APPEND VALUE #( %cid = keys[ KEY entity %tky = <fs_travel_result>-%tky ]-%cid &&
                                                       <fs_booking_result>-BookingId &&
                                                       <fs_suppl_result>-BookingSupplementId
                        %data = CORRESPONDING #( <fs_supplement> EXCEPT travelid bookingid BookingSupplementId ) )
        TO <fs_supplement>-%target ASSIGNING FIELD-SYMBOL(<fs_suppl_target>).
      ENDLOOP.
    ENDLOOP.

* Create Travels/Booking together

    MODIFY ENTITIES OF znab_rap_travel IN LOCAL MODE
    ENTITY travel
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate OverallStatus )
    WITH lt_travels
    ENTITY travel
    CREATE BY \_bookings
    FIELDS (  BookingDate BookingStatus CustomerId CarrierId ConnectionId )
    WITH lt_bookings
    ENTITY booking
    CREATE BY \_Supplement
    FIELDS ( SupplementId Price CurrencyCode )
    WITH lt_supplements
    MAPPED DATA(lt_mapped).

    mapped-travel = lt_mapped-travel.

  ENDMETHOD.

ENDCLASS.
