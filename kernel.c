
#define VideoMemory (volatile char*)0xB8000

//enum whichColor{

//}; 

void printToKern(char *Message,char color );
//char swapColors(int *j);

void _start(){
  char color = 0x0F; // white in hex
  char Message[] = "Writing to memory !";
  printToKern(Message, color);

  while(1){
    
    //kernel should never stop
  }

}

void printToKern(char *Message, char color){
  
  volatile char *currentAddress = VideoMemory; // Volatile to force the write to said addres
  int j = 0;
  for(int i=0; Message[i] != '\0' ; i++){
      *currentAddress++ = Message[i];
      *currentAddress++ = color ;//swapColors(&j);
      /*VideoMemory layout alternates 1 byte for whats to be printed and 1 byte dictates the color
       
       P.E: 0xB8000 -> starts the VideoMemory domain, Byte to be displayed
       0xB8001 -> Color of the byte
       0xB8002 -> To be displayed
       oxB8003 -> Color of the byte
       
       
       * */
  }
  

}

/* char swapColors(int *j){
  
  char Colors[] = {0xFF, 0x57, 0x33}; 

  int len = sizeof(Colors) / sizeof(Colors[0])

    if (Colors[(*j) + 1] <= len) { // Would this be better with null?
      (*j) = 0;
      return Colors[(*j)];
    //use defines, enums or define for readability (instead of returning the value of j return sum like REDCOLOR)    
}

    return Colors[(*j) + 1];

  }
}
*/ 
