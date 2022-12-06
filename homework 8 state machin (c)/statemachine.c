#include <stdio.h>
// program
#define slash1 1// look for the first slash
#define slash2 2// look for the second slash
#define commentFound 3// two slashes were found, meaning there was a comment so read.

int main(){
	int state = 1; 
	int charFigure;

	// loop
	while(1){
		// read a character using getchart
		charFigure = getchar();
	        if (charFigure == EOF){ // if char = EOF token (32 bits)
			break;
		}
		// switch state
		switch(state){
			case slash1: 
		
			// if char is equal to one slash, change the state to search for the second slash and loop
				if (charFigure == '/'){
				// change to state 2
				state = 2;
				} else {
				
					putchar(charFigure);
				}
				break ;
			      
			// loop for searching for second / 
			case slash2:
				// if the second char is equal to ANOTHER /, a comment has been found
				
				if (charFigure == '/'){
					state = 3;
					break;
				} else { // restart loop from state 1
					putchar('/');
					putchar(charFigure);
					state = 1;
					break;
				}
				
			case commentFound: // if a comment is found print everything on a new line and return to state 
				
				if (charFigure == '\n'){
					state = 1;
				}	   
				break;
							
		}
	}
	return 0 ;
}
