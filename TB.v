

module testbench();

  // Inputs
  reg clk;
  reg lan;
  reg [2:0] accNumber;
  reg [12:0] pin;
  reg [12:0] newpin;
  reg [2:0] menuOption;
  reg [15:0] amount;
  reg[2:0] j;
  reg rst;
  reg[3:0] i;
  reg[2:0] k;
    integer fd;
  reg[2:0] t; 
  // Outputs
  wire error;
  wire Language;
  wire [15:0] balance;
  reg [12:0] pin_database [0:4];
  reg [2:0] acc_database [0:4];
  initial begin

    acc_database[0] = 4'd1; pin_database[0] = 13'd1000;
    acc_database[1] = 4'd2; pin_database[1] = 13'd1001;
    acc_database[2] = 4'd3; pin_database[2] = 13'd1010;
    acc_database[3] = 4'd4; pin_database[3] = 13'd8000;
    acc_database[4] = 4'd5; pin_database[4] = 13'd1100;
    
  end

  // Instantiate ATM module
  ATM atm_inst (
    .clk(clk),
    .lan(lan),
    .rst(rst),
    .accNumber(accNumber),
    .pin(pin),
    .newpin(newpin),
    .menuOption(menuOption),
    .amount(amount),
    .error(error),
    .Language(Language),
    .balance(balance)
  );

  initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end 
    end
  // Initial stimulus
  
  initial begin

  //rst checking
        
   rst = 0; menuOption = 5; accNumber = 1; pin = 1000; amount = 100; lan = 0;newpin=0;  
   repeat(4) @(negedge clk);
   
    rst = 1; menuOption = 6; accNumber = 1; pin = 1000; amount = 100; lan = 0;newpin=0;  
    repeat(4) @(negedge clk);
         if (balance== 500) begin
            $display("Test 1");
        end 
  //Draw checking
   rst = 1; menuOption = 5; accNumber = 1; pin = 1000; amount = 100; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
         if (balance== 400) begin
            $display("Test 2");
        end 
     rst = 1; menuOption = 5; accNumber = 2; pin = 1001; amount = 200; lan = 0; newpin=0; 
     repeat(4) @(negedge clk);
         if (balance== 300) begin
            $display("Test 3");
        end 
        rst = 1; menuOption = 5; accNumber = 2; pin = 1001; amount = 56270; lan = 0;newpin=0; //wrong amount
     repeat(4) @(negedge clk);
         if (error) begin
            $display("Test 4");
        end 
  //deposit
   rst = 1; menuOption = 7; accNumber = 1; pin = 1000; amount = 1000; lan = 0;newpin=0;  
    repeat(4) @(negedge clk);
         if (balance== 1400) begin
            $display("Test 5");
        end 
          rst = 1; menuOption = 7; accNumber = 2; pin = 1001; amount = 100; lan = 0;  newpin=0;
    repeat(4) @(negedge clk);
         if (balance== 400) begin
            $display("Test 6");
        end      
         rst = 1; menuOption = 7; accNumber = 5; pin = 1100; amount = 100; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
         if (balance== 600) begin
            $display("Test 7");
        end      
 //wrong pass or acc
  rst = 1; menuOption = 7; accNumber = 2; pin = 0000; amount = 100; lan = 0;  newpin=0;
    repeat(4) @(negedge clk);
         
        rst = 1; menuOption = 6; accNumber = 2; pin = 1001; amount = 100; lan = 0;newpin=0;  
    repeat(4) @(negedge clk);
         if (balance==400) begin
            $display("Test 8");
        end 
        rst = 1; menuOption = 7; accNumber = 1; pin = 1001; amount = 1000; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
        
  rst = 1; menuOption = 6; accNumber = 1; pin = 1000; amount = 100; lan = 0;  newpin=0;
    repeat(4) @(negedge clk);
         if (balance== 1400) begin
            $display("Test 9");
        end 

        rst = 1; menuOption = 7; accNumber = 3; pin = 1011; amount = 1000; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
        
  rst = 1; menuOption = 6; accNumber = 3; pin = 1010; amount = 100; lan = 0;  newpin=0;
    repeat(4) @(negedge clk);
         if (balance== 500) begin
            $display("Test 10");
        end 
   
   rst = 1; menuOption = 6; accNumber = 10; pin = 1010; amount = 100; lan = 0;  newpin=0;
    repeat(4) @(negedge clk);
         if (error) begin
            $display("Test 11");
        end 
 rst = 1; menuOption =4 ; accNumber = 1; pin = 1000; amount = 100; lan = 0; newpin=8191; 
    repeat(4) @(negedge clk);
 rst = 1; menuOption = 7; accNumber = 1; pin = 1000; amount = 100; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
         if (error) begin
            $display("Test 12");
        end 
         rst = 1; menuOption = 6; accNumber = 1; pin = 8191; amount = 100; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
        if(balance==1400) begin
          $display("test 13");
        end
        rst = 1; menuOption = 0; accNumber = 1; pin = 8191; amount = 100; lan = 0; newpin=0; 
    repeat(5) @(negedge clk);
        if(error) begin
          $display("test 14");
        end
         rst = 1; menuOption = 5; accNumber = 1; pin = 8191; amount = 1400; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
     
   rst = 0; menuOption = 5; accNumber = 1; pin = 8191; amount = 100; lan = 0;newpin=0;  
   repeat(4) @(negedge clk);
    
    rst = 1; menuOption = 7; accNumber = 1; pin = 8191; amount = 65535; lan = 0; newpin=0; 
    repeat(4) @(negedge clk);
     
   for (i = 0; i < 15; i=i+1) begin
    rst=1;
              lan= {$random()}%2;
              j= {$random()}%5;
              accNumber= acc_database[j];
              pin= pin_database[j];
              menuOption=$urandom_range(4,7) ;
              amount = $urandom_range(100,1000);
              newpin=0;
              repeat(4) @(negedge clk);
              $display("%t: lan = %b, accNumber = %d , pin = %d, menuOption = %d, amount = %d, Language = %b, error = %b, balance = %d ",$time ,lan,accNumber,pin,menuOption-3,amount,Language,error,balance);
end
i=0;

fd=$fopen("pins.txt","w");
for(t=0;t<5;t=t+1)begin
  $fwrite(fd,"%d\n",pin_database[t]);
end
t=0;
$fclose(fd);

fd=$fopen("accs.txt","w");
for(t=0;t<5;t=t+1)begin
  $fwrite(fd,"%d\n",acc_database[t]);
end

$fclose(fd);
    fd=0;
    $stop;
  end

always @(newpin) begin
 
  for (k = 0; k < 5; k = k + 1) begin
    
    
    if (accNumber == acc_database[k]) begin
      if (pin == pin_database[k]) begin
        if (newpin != 0) begin
          pin_database[k] = newpin;
          
        end
      end
    end
  end
  k=0;
end


endmodule
