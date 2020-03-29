[gcode_macro G28]
rename_existing: G990028
gcode:
  {% set do_x = 0 %}
  {% set do_y = 0 %}
  {% set do_z = 0 %}

  {% if params.Y is defined %}
    {% set do_y = 1 %} 
  {% endif %}

  {% if params.X is defined %}
    {% set do_x = 1 %} 
  {% endif %}

  {% if params.Z is defined %}
    {% set do_x = 1 %} 
    {% set do_y = 1 %} 
    {% set do_z = 1 %} 
  {% endif %}


  {% if do_y == 1 %}
    RESPOND PREFIX="info" MSG="Home > Todo: Y"
  {% endif %}
  {% if do_x == 1 %}
    RESPOND PREFIX="info" MSG="Home > Todo: X"
  {% endif %}
  {% if do_z == 1 %}
    RESPOND PREFIX="info" MSG="Home > Todo: Z"
  {% endif %}

  {% if do_x == 0 and do_y == 0 and do_z == 0 %}
    {% set do_x = 1 %} 
    {% set do_y = 1 %} 
    {% set do_z = 1 %} 
    RESPOND PREFIX="info" MSG="Home > Doing all XYZ"
  {% endif %}
  
  {% if do_x == 1 or do_y == 1 or do_z == 1 %}
    RESPOND PREFIX="info" MSG="Home > Moving up 20 mm before homing"
    G91
    G0 Z20
    G90
  {% endif %}

  {% if do_y == 1 %}
    RESPOND PREFIX="info" MSG="Home > Y"
    G90
    G990028 Y0
    G91
    G0 Y-5 F2000
    G90
  {% endif %}

  {% if do_x == 1 %}
    RESPOND PREFIX="info" MSG="Homing > X"
    G90
    G990028 X0
    G91
    G0 X5 F2000
    G90
  {% endif %}

  {% if do_z == 1 %}
    RESPOND PREFIX="info" MSG="Homing > Z"
    G90
    G0 X100 Y100
    G990028 Z0
    G91
    G0 Z20
    G90
  {% endif %}

  RESPOND PREFIX="info" MSG="Homing > Done"
