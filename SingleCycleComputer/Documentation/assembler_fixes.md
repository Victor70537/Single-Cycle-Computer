FALL 2022
EDITS MADE TO ASSEMBLER.PY:
    LARGE CHANGES
    1. FIXED CONDITION FLAGS
    2. ADDED LOCATION OF INSTRUCTIONS.JSON TO ARGS

    line 18: Condition lookup table; changed "pl" = 2 -> "pl" = 5
    line 28: Condition lookup table; added never condition "nv" = 15
    line 487: KeyError exception; fixed syntax error in error handling
    line 528-529: Main; added json_directory variable from args to take place of hard-coded location of json file,
        used json_directory in place of specific location on lines 264, 394, and 417

    TO RUN:
        command: python3 assembler.py <asmfile.asm> <jsonfile.json>
        example: python3 parser/assembler.py tests/BabyTest.asm parser/instructions.json