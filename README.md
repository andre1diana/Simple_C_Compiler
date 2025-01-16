1. Supported Data Types:


The interpreter support int, double and float data types
Allow declaration and initialization of variables for each of these types
Example: int a = 5; double b = 3.14; float c = 2.5f;


2. Arithmetic Operations:


Implement basic arithmetic operations: addition, subtraction, multiplication, division
Ensure operations follow C type conversion rules
Example: a + b; b * c; a / 2;


3. Input and Output:


Allow reading user input for variables
Implement console output display
Example:
printf("Enter a number: ");
scanf("%d", &a);
printf("You entered: %d", a);


4. Error Handling:


Handle common errors, such as division by zero and data type limit overflows
Display appropriate error messages for the user
Example:
// Division by zero
int d = 0;
if (d == 0) {
printf("Error: Division by zero!");
} else {
a = a / d;
}


5. Code Blocks:


Allow the use of code blocks, delimited by curly braces {}
Ensure proper handling of variable scope inside blocks
Example:
{
int x = 10;
printf("%d", x);
}
// x is no longer accessible here


6. Type Conversions:


Implement explicit conversions between int, double and float
Example: double e = (double)a; float f = (float)e;


7. Comments:


Allow the use of single-line (//) and multi-line comments (/* ... */)
Example:
// This is a single line comment
int x = 5; /* This is a
multi-line comment */


8. User Interface:


Develop a simple command-line interface for interpreter interaction
Ensure the interpreter can execute both individual commands and scripts from files
Example:
Command line: > int x = 5;
Execute script from file: > run script.txt
