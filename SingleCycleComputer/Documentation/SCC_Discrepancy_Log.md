# SCC Discrepancy Log

### Paul
* –/–  Documentation Error, instructions.json
	* no difference between imm or relative opcode for data operations

* 10/19 Documentation Error p23-24
	* condition flag [24,22] => [24,21]

* 10/20 Documentation Error, instructions.json
	* no difference between r_br and o_br opcodes
	* o_br is not a documented operation

* 10/27 Documentation Error, instructions.json
	* no difference between r_stor and o_stor opcodes
	* no difference between r_load and o_load opcodes
	* “o_stor” is not a documented operation (only ‘stor’ is in documentation, assumed r_stor)
	* o_stor and o_load to be used with offset 0 for r_stor and r_load
