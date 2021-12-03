#include <stdio.h>
#include "pstring.h"
//#include "func_select.s"

//extern char pstrlen (Pstring* pstr);
//extern Pstring* replaceChar(Pstring pstr, char oldChar, char newChar);
extern void run_func(int opt, Pstring* dst, Pstring* src);

void run_main() {

	Pstring p1;
	Pstring p2;
	int len;
	int opt;

	// initialize first pstring
	scanf("%d", &len);
	scanf("%s", p1.str);
	p1.len = len;

    //initialize second pstring
	scanf("%d", &len);
	scanf("%s", p2.str);
	p2.len = len;

	// select which function to run
	scanf("%d", &opt);
	//scanf("%d", &opt);
    run_func(opt, &p1, &p2);
    //int len1 = pstrlen(&p1);
    //int len2 = pstrlen(&p2);
    //printf("len p1: %d, len p2: %d\n", len1, len2);
    //char char1 = 'h';
    //char char2 = 'b';
    //printf("naw p1: %s\n" ,replaceChar(&p1,char1,char2)->str);
    //printf("naw p2: %s\n" ,replaceChar(&p2,char1,char2)->str);
    //pstrijcpy(&p1, &p2,10,7);
    //printf("new p1: %s\n", p1.str);
    //printf("old p2: %s\n", p2.str);
    //swapCase(&p1);
    //int result = pstrijcmp(&p1, &p2, 0,4);
    //printf("the result: %d\n", result);

}
