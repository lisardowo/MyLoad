
#define VideoMemory (volatile char*)0xB8000

void printToKern(char *Message,char color );

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

  for(int i=0; Message[i] != '\0' ; i++){
      *currentAddress++ = Message[i];
      *currentAddress++ = color;
      /*VideoMemory layout alternates 1 byte for whats to be printed and 1 byte dictates the color
       
       P.E: 0xB8000 -> starts the VideoMemory domain, Byte to be displayed
       0xB8001 -> Color of the byte
       0xB8002 -> To be displayed
       oxB8003 -> Color of the byte
       
       
       * */
  }
  

}

char swapColors(int *i){
  
  char Colors[] = 

  for(;;*i++){

    if Colors[i + 1] == -1 { // Would this be better with null?
      *i = 0;
      return Colors[i]
    }

    return Colors[i + 1]

  }
}
