use std::fs;
use std::io::{BufReader, BufRead};
use tui::widgets::ListState;



pub struct CPU {
    pub state: ListState,

    //state reached by HALT
    pub stop_state: bool,

    //vector of all instructions executed for UI
    pub prog_mem: Vec<String>,

    //raw contents of mem file
    pub raw_mem: Vec<String>,

    //last memory address written to
    pub last_w: u32,

    //last memory address read from
    pub last_r: u32,

    //last program counter location
    pub last_pc: u32,

    //program counter
    pub program_counter: u32,

    //unused
    pub status: u16,

    //negative flag
    pub N: u8,

    //carry flag
    pub C: u8,

    //zero flag
    pub Z: u8,

    //overflow flag
    pub V: u8,

    //register array
    pub register: [u32; 0x8],

    //memory array
    pub memory: [u32; 0x50],
    
}

//methods belonging to CPU struct
impl CPU {

    //initializing default values
    pub fn new() -> Self {
        CPU {
            state: ListState::default(),

            stop_state: false,

            prog_mem: Vec::new(),

            raw_mem: Vec::new(),

            last_w:  0,

            last_r:  0,

            last_pc: 0,

            program_counter: 0,

            status: 0,

            N: 0,

            C: 0,

            Z: 0,

            V: 0,

            register: [0; 8],

            //array of length 0x50 filled with zeros
            memory: [0; 0x50],
        }
    }

    pub fn setup(&mut self){
    
            //TODO add argument for file loading

            //open mem file 
            let mem_file = fs::read_to_string("/home/ariel/Class-ISA/scc/output.mem")
            .expect("Unable to read file");

            //parse memory file
            let reader = BufReader::new(mem_file.as_bytes());

            //vector to contain program
            let mut program:Vec<u32> = Vec::new();
            
            //start address to write to set to 0 by default
            let mut start_addr: u32 = 0;

            //read every line in mem file
            for line in reader.lines() {
                
                //add every line to raw mem vector for display
                self.raw_mem.push(line.as_ref().unwrap().to_string());

                //remove all whitespace from line
                let data_line = line.unwrap().to_string().replace(' ', "");

                //if line starts with '@' it indicates new write address
                if data_line.starts_with('@') {

                    //if not first line in program
                    if program.len() > 0 {
                        //load section of program read into memory at new write address
                        self.load(&program, start_addr);
                        //clear program vector
                        program.clear();
                    }
                    //set new write address from line as int from hex
                    start_addr = u32::from_str_radix(&data_line.replace('@',""), 16).unwrap();
                    
                } else{
                    //add line to program vector as int from hex
                    program.push(u32::from_str_radix(&data_line, 16).unwrap());
                }
                   
            }
            //loads current program section into memory 
            self.load(&program, start_addr);
    }


    //loads program into memory array
    pub fn load(&mut self, program: & Vec<u32>, addr: u32){

        //address to start writing to
        let mut n = addr;
        
        //iterate through program vector and add to memory
        for e in program {
            self.memory[n as usize] = *e;
            n = n + 1;
        }
    }


    //writes to memory array
    pub fn write(&mut self, addr: u32, data: u32) {
        self.memory[addr as usize] = data;
        self.last_w = addr;
    }


    //reads from memory array
    pub fn read(&mut self, addr: u32) -> u32 {
        self.last_r = addr;
        self.memory[addr as usize]
    }


    ///////////////
    //  Run CPU  //
    ///////////////
    
    pub fn run(&mut self, mut count: u32) {

            //runs number of cycles specified in count 
            while count > 0 && !self.stop_state {

                //space used for instruction vector
                let spc =" ";


                /////////////////////////
                //  Fetch instruction  //
                /////////////////////////

                let instruction:u32 = self.memory[self.program_counter as usize];


                //adds PC value to variable for displaying last PC location
                self.last_pc = self.program_counter;

                //increments program counter
                self.program_counter += 1;
                
                //bitmask for relevant opcode bits
                let opcode       = ((instruction & 0b1111_1110_0000_0000_0000_0000_0000_0000) >> 25) as u8;

                //bitmask for bit used to represent I vs R types
                let mode         = ((instruction & 0b0100_0000_0000_0000_0000_0000_0000_0000) >> 28) as u8;

                //bitmask for bit indicating setting flags
                let set_flags    = ((instruction & 0b0001_0000_0000_0000_0000_0000_0000_0000) >> 28) as u8;   
                
                //bitmask for destination register
                let destination = ((instruction & 0b0000_0001_1100_0000_0000_0000_0000_0000) >> 22) as u32;

                //bitmask for source regitser 
                let source      = ((instruction & 0b0000_0000_0011_1000_0000_0000_0000_0000) >> 19) as u32;

                //bitmask for optional register
                let op2         = ((instruction & 0b0000_0000_0000_0111_0000_0000_0000_0000) >> 16) as u32;

                //bitmask for immediate or offset
                let mut immediate   = ((instruction & 0b0000_0000_0000_0000_1111_1111_1111_1111)) as i16;


                ////////////////////
                // execute opcode //
                ////////////////////
                
                match opcode {
                    0x40 => { //load

                       self.prog_mem.push(format!("LOAD({}) R{}   R{}   {:#X}", opcode, destination, source, immediate));
                       self.register[destination as usize] = self.read(self.register[source as usize] + immediate as u32);


                    }


                    0x41 =>{ //STOR
                       
                       self.prog_mem.push(format!("STOR({}) R{}   R{}   {:#X}", opcode, destination, source, immediate));
                       self.write(self.register[source as usize] + immediate as u32, self.register[destination as usize]);


                    }


                    0x11 =>{ //ADD

                       self.prog_mem.push(format!("ADD({})\t  R{}   R{}   {:#X}", opcode, source, destination, immediate));
                       self.register[destination as usize] = self.register[source as usize] + immediate as u32;

                    }


                    0x12 =>{ //SUB
                        if op2 > 0{
                            //let op2 = ((instruction & 0b0000_0000_0000_0111_0000_0000_0000_0000) >> 16) as u32;
                            immediate = self.register[op2 as usize] as i16;
                            self.prog_mem.push(format!("CMP({})\t R{}   R{}   R{}", opcode, destination, source, op2));
                           } else {
                            self.prog_mem.push(format!("CMP({})\t R{}   R{}   {:#X}", opcode, destination, source, immediate));
                           }
                       self.register[destination as usize] = self.register[source as usize] - immediate as u32;


                    }


                    0x1A =>{ //CMP

                        //TODO fix I vs R type
                        if op2 > 0{
                        //let op2 = ((instruction & 0b0000_0000_0000_0111_0000_0000_0000_0000) >> 16) as u32;
                        
                        //immediate set to value at op2 register
                            immediate = self.register[op2 as usize] as i16;
                            self.prog_mem.push(format!("CMP({})\t  R{}   R{}   R{}", opcode, destination, source, op2));

                        } else {

                            self.prog_mem.push(format!("CMP({})\t  R{}   R{}   {:#X}", opcode, destination, source, immediate));
                        }

                        //check for overflow before subtraction
                        if (self.register[source as usize].checked_sub(immediate as u32)) != None{
                            self.register[destination as usize] = self.register[source as usize] - immediate as u32
                        }

                        //checks for zero result
                        if self.register[source as usize] as i32 - immediate as i32 == 0 {
                            self.Z = 1;
                        } else {
                            self.Z = 0;
                        }

                        //checks for negative result
                        if (self.register[source as usize] as i32 - immediate as i32) < 0 {
                            self.N = 1;
                        } else {
                            self.N = 0;
                        }

                        //checks for overflow for carry
                        if (self.register[source as usize] as u32).checked_sub (immediate as u32) == None {
                            self.C = 1;
                        } else {
                            self.C = 0;
                        }

                        //TODO implement V flag setting for unsigned overflow

                    }


                    0x13 =>{ //AND

                       self.prog_mem.push(format!("AND({})\t R{}   R{}", opcode, source, destination));
                       self.register[destination as usize] = self.register[source as usize] & immediate as u32;

                    }


                    0x14 =>{ //OR
                        
                       self.prog_mem.push(format!("OR({})\t R{}   R{}", opcode, source, destination));
                       self.register[destination as usize] = self.register[source as usize] | immediate as u32;

                    }


                    0x15 =>{ //XOR

                       self.prog_mem.push(format!("XOR({})\t R{}   R{}", opcode, source, destination));
                       self.register[destination as usize] = self.register[source as usize] ^ immediate as u32;

                    }


                    0x1 =>{ //LSL
                    
                       self.prog_mem.push(format!("LSL({})\t R{}   R{}", opcode, source, destination));
                       self.register[destination as usize] = self.register[source as usize] << immediate as u32;

                    }


                    0x5 =>{ //LSR
                    
                       self.prog_mem.push(format!("LSR({})\t R{}   R{}", opcode, source, destination));
                       self.register[destination as usize] = self.register[source as usize] >> immediate as u32;

                    }


                    0x2 =>{ //CLR

                       self.prog_mem.push(format!("CLR({})\t {}   {}", opcode, source, destination));
                       self.register[destination as usize] = 0;

                    }


                    0x3 =>{ //SET

                       self.prog_mem.push(format!("SET({})\t {}   {}", opcode, source, destination));
                       self.register[destination as usize] = 0b1111_1111_1111_1111_1111_1111_1111_1111;

                    }


                    0x60 =>{ //B

                        self.prog_mem.push(format!("B({})\t    {}", opcode, immediate/4));
                        self.prog_mem.push(spc.to_string());
                        self.prog_mem.push(format!("Branch Taken\n"));

                        //rmeoved first instructions for smooth scrollin in UI
                        self.prog_mem.remove(0);
                        self.prog_mem.remove(0);
                        self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                        
 
                     }


                     0x61 =>{ //b.cond

                        //bitmask for condition specified
                        let condition = ((instruction & 0b0000_0001_1110_0000_0000_0000_0000_0000) >> 21) as u32;

                        //TODO fix print spacing and add extra renove for all conds
                        match condition {
                            0x0 =>{
                                self.prog_mem.push(format!("b.eq({}) {}", opcode, immediate/4));
                                if self.Z == 1 {
                                    self.prog_mem.push(spc.to_string());
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x1 =>{
                                self.prog_mem.push(format!("b.ne({})\t {}", opcode, immediate/4));
                                if self.Z == 0 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32;
                                }
                            }

                            0x2 =>{
                                self.prog_mem.push(format!("b.hs({})\t {}", opcode, immediate/4));
                                if self.C == 1 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x3 =>{
                                self.prog_mem.push(format!("b.lo({}) {}", opcode, immediate/4));
                                if self.C == 0 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x4 =>{
                                self.prog_mem.push(format!("b.mi({}) {}", opcode, immediate/4));
                                if self.N == 1 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x5 =>{
                                self.prog_mem.push(format!("b.pl({})\t {}", opcode, immediate/4));
                                if self.N == 0 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x6 =>{
                                self.prog_mem.push(format!("b.vs({})\t {}", opcode, immediate/4));
                                if self.V == 1 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x7 =>{
                                self.prog_mem.push(format!("b.vc({})\t {}", opcode, immediate/4));
                                if self.V == 0 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x8 =>{
                                self.prog_mem.push(format!("b.hi({})\t {}", opcode, immediate/4));
                                if self.Z == 0 && self.C == 1 {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0x9 =>{
                                self.prog_mem.push(format!("b.ls({})\t {}", opcode, immediate/4));
                                if !(self.Z == 0 && self.C == 1) {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0xA =>{
                                self.prog_mem.push(format!("b.ge({})\t {}", opcode, immediate/4));
                                if self.N == self.V {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0xB =>{
                                self.prog_mem.push(format!("b.lt({})\t {}", opcode, immediate/4));
                                if self.N != self.V {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0xC =>{
                                self.prog_mem.push(format!("b.gt({})\t {}", opcode, immediate/4));
                                if (self.Z == 0 && self.N == self.V) {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0xD =>{
                                self.prog_mem.push(format!("b.le({})\t {}", opcode, immediate/4));
                                if !(self.Z == 0 && self.N == self.V) {
                                    self.prog_mem.push(format!("Condition Met\n"));
                                    self.prog_mem.remove(0);
                                    self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                                }
                            }

                            0xE =>{
                                self.prog_mem.push(format!("b.al({})\t {}", opcode, immediate/4));
                                self.prog_mem.push(format!("Condition Met\n"));
                                self.prog_mem.remove(0);
                                self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                            }

                            0xF =>{
                                self.prog_mem.push(format!("b.nv({})\t {}", opcode, immediate/4));
                                self.prog_mem.push(format!("Condition Met\n"));
                                self.prog_mem.remove(0);
                                self.program_counter = ( self.program_counter as i32 + ((immediate/4)-1) as i32) as u32; 
                            }

                            _ => {
                                self.prog_mem.push(format!("Invalid Condition: {}", condition));
                            }
                        }
                        
 
                     }


                    0x68 =>{ //HALT

                        self.prog_mem.push(format!("HALT({})", opcode));
                        //stop execution
                        self.stop_state = true;
                        break;
 
                     }
                    //default case invalid opcode
                    _ =>{self.prog_mem.push(format!("Invalid Opcode: {}", opcode));
                        }
                }
                //decrement cycle count
                count = count -1;
            }
            
    }

}