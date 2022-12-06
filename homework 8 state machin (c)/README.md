# Homework 9: Stripping Comments from a C file

In this homework, you're going to write a program in C that strips single-line comments from source code files. The input to your program will be a C file with single-line comments. The output will be the same file without any single-line comments.

Single-line comments in C and Java begin with the characters `//` and continue to the end of the line. Your program can either read input from `stdin` or from a file. In either case, it will read one character at a time using the `getc()` or `getchar()` function and process the input with a state machine. Your state machine will print the comment-stripped output to `stdout`.

## State Machines in C

State machines are implemented in C in basically the same way as assembly: one big `while` loop with state handlers.



    #define STATE1 1 // State name definitions
    #define STATE2 2
    // ...
    while(1) {
      // Read a character
      switch(state) {
        case STATE1:
          // State transition logic for STATE1
          // Actions for STATE1
          break;
        case STATE2:
          // State transition logic for STATE2
          // Actions for STATE2
      }
    }

# Reading Characters

## Reading characters from `stdin`

Use the `getchar` function to read one character from the terminal (`stdin`). Just as in assembly, characters are stored as 8-bit ASCII codes. `getchar` will return one ASCII character each time you call it until it reaches the end of the file. Once it encounters the end of the file, it will return the special `EOF` token, indicating that there is no more data to be read from the file. The `EOF` token is represented as a 32-bit integer.

Even though an 8-bit `char` datatype is sufficient to store ASCII characters, you need a 32-bit `int` to store the `EOF` token. Because `EOF` takes up 32 bits, you should declare the variable that you use to read characters from `stdin` as an int so the `EOF` token fits.

If your program is going to read its input from `stdin`, it doesn't really make sense to type by hand a C source file in to the terminal each time you run your program. Instead, you can send the contents of a file on the disk to your program via `stdin` with a pipe in the terminal:

    rambler@rambler-vm:~$ cat file.c | ./commentstripper

The vertical bar `|` character in the command above is called a pipe. It's usually on the keyboard just above the return/enter key. A pipe takes the output of one command and passes it to the `stdin` of the subsequent command. In the example above, `cat file.c` simply prints the contents of `file.c`. The pipe in that example stops the output of `cat` from getting printed to the terminal and instead redirects the file contents to the `stdin` of `./commentstripper`. Characters can be read one at a time by the `getch()` function in `commentstripper`.


## Reading characters from a file

Instead of reading characters from `stdin` using the `getch`, you can read directly from a file. File access in C works the same way as in Easy68k: first you open the file then you read from it. To open a file, you call the `open` command, passing the file's path and a flag that tells the function you want to open it read only:

    int fd = open("sourcefile.c", O_RDONLY);

The `open` command returns an integer file descriptor which can be used to refer to the open file. If `open` fails for some reason (like the file you tried to open doesn't exist), the file descriptor will be negative. If `open` succeeds, the file descriptor will be positive.

Once you have opened a file, you can read its contents into a buffer (array) using the `read` call. `read` needs three inputs: (1) the file you want to read from (returned by `open`), (2) the buffer's address to read into, and (3) the max number of bytes to read into the buffer. 

    unsigned char buf[2048];
    unsigned int nchar = read(fd, buf, sizeof(buf));



# Grading

|              Task                                                            |   Points   |
|------------------------------------------------------------------------------|------------|
| Program Reads Characters (either from stdin or file)                         |     5      |
| Program prints all characters except comments                                |     30     |
| Program correctly prints single slash (as in divide)                         |     15     |
| **Extra Credit:** Read input from file. Accept file name from command line.  |     10     |

