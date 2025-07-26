FUNCTION Y_ABAP_STRING_SPLIT.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(INPUT_STRING) TYPE  STRING
*"     VALUE(MAX_COMPONENT_LENGTH) TYPE  I DEFAULT
*"       SWB1_HTML_LINE_LENGTH
*"  TABLES
*"      STRING_COMPONENTS STRUCTURE  SWASTRTAB
*"----------------------------------------------------------------------

  DATA:
    total_length     TYPE i,
    remaining_length TYPE i,
    current_offset   TYPE i,
    current_char     TYPE c,
    search_position  TYPE i,
    component_length TYPE i.

  DATA: current_string TYPE swastrtab.


  CHECK NOT input_string IS INITIAL.

**** UK 00/06/14 Unicode syntax
  DESCRIBE FIELD current_string-str LENGTH total_length
    IN CHARACTER MODE.

  IF max_component_length <= 0.
    max_component_length = 100.
  ENDIF.

  total_length     = strlen( input_string ).
  remaining_length = total_length.
  current_offset   = 0.

  CLEAR string_components[].

  WHILE remaining_length >= max_component_length.

**** find a position where the string may be split:

    search_position   = current_offset + max_component_length - 1.
    component_length  = max_component_length.

    WHILE search_position >= current_offset.

****  search (backwards) for separators.

      current_char = input_string+search_position(1).

      SUBTRACT 1 FROM component_length.

      SUBTRACT 1 FROM search_position.

    ENDWHILE.

    IF component_length = 0.
****   no separator found, cut a maximal piece ...
      component_length = max_component_length.
    ENDIF.

    current_string-len = component_length.
    current_string-str = input_string+current_offset(component_length).
    APPEND current_string TO string_components.

    ADD component_length TO current_offset.
    SUBTRACT component_length FROM remaining_length.

  ENDWHILE.  " remaining_length > component_length

  IF remaining_length > 0.
    CLEAR current_string.
    current_string-len = remaining_length.
    current_string-str = input_string+current_offset(remaining_length).
    APPEND current_string TO string_components.
  ENDIF.

ENDFUNCTION.
