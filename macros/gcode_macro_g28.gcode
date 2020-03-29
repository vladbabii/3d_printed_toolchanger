
## Homing status per axis
## 0 - not homed
## 1 - real homed
## 2 - fake home
[gcode_macro HOMING_STATUS]
variable_x: 0
variable_y: 0
variable_z: 0
variable_e: 0
gcode:
  RESPOND PREFIX="info" MSG="Homing status:"
  RESPOND PREFIX="info" MSG=" X: {printer['gcode_macro HOMING_STATUS'].x}"
  RESPOND PREFIX="info" MSG=" Y: {printer['gcode_macro HOMING_STATUS'].y}"
  RESPOND PREFIX="info" MSG=" Z: {printer['gcode_macro HOMING_STATUS'].z}"
  
  
[gcode_macro M84]
rename_existing: G990084
gcode:
  RESPOND PREFIX="info" MSG="Disable Steppers > ..."
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=x VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=y VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=z VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=e VALUE=0
  G990084
  
[gcode_macro M18]
rename_existing: G990018
gcode:
  RESPOND PREFIX="info" MSG="Disable Steppers > ..."
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=x VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=y VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=z VALUE=0
  SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=e VALUE=0
  G990018

[gcode_macro SET_KINEMATIC_POSITION]
rename_existing: REAL_SET_KINEMATIC_POSITION
gcode:
  {% if params.X is defined %}
    RESPOND PREFIX="info" MSG="SET_KINEMATIC_POSITION > X={params.X}"
    SET_KINEMATIC_POSITION X={params.X}
    SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=x VALUE=2
  {% endif %}
  
  {% if params.Y is defined %}
    RESPOND PREFIX="info" MSG="SET_KINEMATIC_POSITION > Y={params.Y}"
    SET_KINEMATIC_POSITION Y={params.Y}
    SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=y VALUE=2
  {% endif %}
  
  {% if params.Z is defined %}
    RESPOND PREFIX="info" MSG="SET_KINEMATIC_POSITION > Z={params.Z}"
    SET_KINEMATIC_POSITION Z={params.Z}
    SET_GCODE_VARIABLE MACRO=HOMING_STATUS VARIABLE=z VALUE=2
  {% endif %}

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
