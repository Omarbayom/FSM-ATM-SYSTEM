`define true 1'b1
`define false 1'b0


`define WAITING               3'b000
`define LANGUAGE              3'b001
`define MENU                  3'b010
`define IDLE                  3'b011
`define CHANGEPIN             3'b100
`define WITHDRAW_SHOW_BALANCE 3'b101
`define BALANCE               3'b110
`define DEPOSIT               3'b111

`define English 1'b1
`define Spanish 1'b0

module DB (
    input [2:0] accNumber,
    input [12:0] pin,
    input [12:0] newpin,
    output reg wasSuccessful,
    output reg [2:0] accIndex
);
  reg[2:0] i;
  reg [2:0] acc_database [0:4];
  reg [12:0] pin_database [0:4];

  initial begin
    acc_database[0] = 4'd1; pin_database[0] = 13'd1000;
    acc_database[1] = 4'd2; pin_database[1] = 13'd1001;
    acc_database[2] = 4'd3; pin_database[2] = 13'd1010;
    acc_database[3] = 4'd4; pin_database[3] = 13'd8000;
    acc_database[4] = 4'd5; pin_database[4] = 13'd1100;
  end

 
  


  always @(accNumber or pin or newpin) begin
     if (1'b1)begin
      
     end 
     
    wasSuccessful = `false;
    accIndex = 0;
 
    // Loop through the database
    for (i = 0; i < 5; i = i + 1) begin
      // Found a match for accNumber
      if (accNumber == acc_database[i]) begin
        
          if (pin == pin_database[i]) begin
            wasSuccessful = `true;
            accIndex = i;
            if(newpin !=0)begin
              pin_database[i]=newpin;
            end
          end
      end 
    end

  end
 
  
endmodule

module ATM(
  input clk,
  input lan,
  input rst,
  input [2:0] accNumber,
  input [12:0] pin,
  input [12:0] newpin,
  input [2:0] menuOption,
  input [15:0] amount,
  output reg error,
  output reg Language,
  output reg [15:0] balance
);

  // Initializing the balance database with an arbitrary amount of money
  reg [15:0] balance_database [0:4];
  initial begin
    balance_database[0] = 16'd500;
    balance_database[1] = 16'd500;
    balance_database[2] = 16'd500;
    balance_database[3] = 16'd65000;
    balance_database[4] = 16'd500;
  end
  integer fd;
  reg [2:0] t;
  reg [2:0] currState = `IDLE;
  reg [2:0] next_state = `WAITING;
  wire [2:0] accIndex;
  wire isAuthenticated;
  reg woh;
 reg[1:0] counter;

  DB authAccNumberModule(accNumber, pin,newpin, isAuthenticated, accIndex);

  always @(posedge clk or negedge rst) begin
  if (!rst) begin
   currState <= `IDLE;
  end
  else begin
    currState <= next_state;
  end
end
always@(posedge clk)begin
  counter=counter+1;
  if(counter==3)begin
    error=1;
    next_state=`WAITING;
  end
end


  always @(currState or menuOption or  accNumber  or  lan or pin  or amount or isAuthenticated) begin 
    counter=0;
    if(isAuthenticated==`false)begin
      currState=`WAITING;
      balance=16'b0 ;
      error=1;
    end
 
    case (currState)
      `WAITING: begin
        
        if (isAuthenticated == `true) begin
             woh=1;
          next_state = `LANGUAGE;
        end
        else  begin
            woh=0;
            error=1;
          next_state = `WAITING;
        end
      end

 
      `LANGUAGE: begin
      
        if (lan == `English) begin
            
          Language = `English;
        end
         else begin
          Language = `Spanish;
        end
        next_state = `MENU;
        
      end

      `MENU:begin
      
         if ((menuOption >= 4)) begin
        next_state = menuOption;
      end else 
        currState = currState;
       
      end

      `BALANCE: begin
        if(woh==`true)begin
        error=0;
        balance = balance_database[accIndex];
        woh=`false;
        next_state = `WAITING;
        end else begin
          next_state=`WAITING;
        end
        

      end
      `CHANGEPIN:begin
        balance = balance_database[accIndex];
        error=`false;
         next_state=`WAITING;
      end

      `WITHDRAW_SHOW_BALANCE: begin
        if(woh==`true)begin
        if (amount <= balance_database[accIndex]) begin
          balance_database[accIndex] = balance_database[accIndex] - amount;
          balance = balance_database[accIndex];
         next_state = `WAITING;
         woh=`false;
          error = `false;
        end else begin
          next_state= `WAITING;
          balance = balance_database[accIndex];
          error = `true;
          woh=`false;
        end
        end else begin
          next_state=`WAITING;
        end
      end

      `DEPOSIT:begin
        if(woh==1)begin
          balance_database[accIndex] = balance_database[accIndex] + amount;
          balance = balance_database[accIndex];
          next_state = `WAITING;
          woh=0;
          error = `false;
        end else begin
          next_state=`WAITING;
        end

      end

      default:begin

        balance=16'bx ;
        error=0;
        next_state=`WAITING;
      end

    endcase
    fd=$fopen("balances.txt","w");
for(t=0;t<5;t=t+1)begin
  $fwrite(fd,"%d\n",balance_database[t]);
end
$fclose(fd);


   end 

    //  psl show_balance: assert always((currState == 2 && menuOption == 6 && woh==1) -> next(balance == balance_database[prev(accIndex)] )) @(posedge clk);
    //  psl show_state: assert always(((currState == 6 ||currState == 7 ||currState == 5) ) -> next(currState == `WAITING   )) @(negedge clk);
    //  psl show_Woh: assert always((woh==0)&&(currState == 6 ||currState == 7 ||currState == 5) -> balance == balance_database[prev(accIndex)] ) @(posedge clk);
    //  psl show_Draw: assert always((currState == 5 &&  amount > balance_database[accIndex]&&rst==1) -> next(balance == balance_database[prev(accIndex)] )) @(negedge clk);
    //  psl show_Draw_failed: assert always((currState == 5 &&  amount > prev(balance_database[accIndex])&&rst==1) -> error==1) @(negedge clk);
    //  psl show_rst: assert (always(rst==0) -> currState==`IDLE) @(negedge clk);
    
endmodule