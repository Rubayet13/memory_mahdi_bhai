typedef enum {RESET, IDLE, WRITE, READ} OPERATION; // defining a custom type to specify operations for use
typedef enum {NA, FAILED, PASSED} VALIDITY; // defining a custom type to specify test result

/*
Display Macros
Here we define a type called SHOW,
SHOW_KEY can hold the values specified in the enum list of SHOW.
KEYS will be supplied as a list {<values>} while calling `DISPLAY and
and TXT should be supplied as $sformatf(<content>).

SHOW_KEY can now be used to specify which componets we want to show $display() function.
*/
typedef enum {NONE, ALL, DRVR, ANALYSIS, SCB} SHOW;
SHOW SHOW_KEY = ALL;
`define DISPLAY(KEYS, TXT) \
  if (SHOW_KEY inside KEYS) $display($time, "ns || [%s] ", name, TXT); \




/*
  Defining test parameters and data types for convenience 
*/
parameter addrWidth = 16;
parameter dataWidth = 32;

typedef bit [addrWidth -1:0] ADDR_VAL;
typedef bit [dataWidth -1:0] DATA_VAL;