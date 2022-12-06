# 68k Array Homework

There are three parts to this homework assignment. You need to do all of them to get full credit.

## Filling up an array with constants

Create a 10-byte array in memory. Write a program to fill your array up with the number 0x55.
You can use the `DS.B` directive to allocate space for an array without defining values. For example:

    array:
        DS.B 10


## Sum elements of an array

Create an array of 10 longwords (32-byte integers) with hardcoded values. Write a program to add all of the constants in your array together. You can use the `DC.L` directive to create an array with pre-defined values, for example:

    array:
        DC.L $55, $91, $24, ...
        
## Convert a string from uppercase to lowercase

Create an uppercase string (using `DC.B`) and write a program to loop through the string one character at a time and convert it from uppercase to lowercase. In the [ASCII table](https://www.asciitable.com), lowercase and uppercase letters are separated by 32. So for example, if you start with capital A (coded for by decimal 65) and add 32 to its ASCII code, you get lowercase a, coded for by decimal 97. This works for all of the letters. In your loop, you will know when you have reached the end of the string when you encounter the NULL terminator (0).
