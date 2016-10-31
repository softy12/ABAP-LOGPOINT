REPORT ZMM_LOGPOINT_TEST.

PARAMETERS: p_carrid LIKE sflight-carrid.

TYPES: BEGIN OF type_s_sflight,
          carrid TYPE sflight-carrid,
          connid TYPE sflight-connid,
          fldate TYPE sflight-fldate,
          price  TYPE sflight-price,
          max    TYPE i,
        END OF type_s_sflight.
DATA: fs_sflight TYPE type_s_sflight,
      t_sflight  LIKE STANDARD TABLE OF fs_sflight.

SELECT carrid connid fldate MAX( price ) AS max
  INTO CORRESPONDING FIELDS OF fs_sflight
  FROM sflight
  WHERE carrid EQ p_carrid
  GROUP BY carrid connid fldate
  ORDER BY carrid max DESCENDING.
    APPEND fs_sflight TO t_sflight.
    LOG-POINT ID zmm_check SUBKEY 'LOG_POINT'
                           FIELDS  p_carrid
                                   t_sflight
                                   fs_sflight-connid
                                   fs_sflight-fldate
                                   fs_sflight-max.

ENDSELECT.
