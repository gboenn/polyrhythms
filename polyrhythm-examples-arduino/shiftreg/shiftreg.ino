
//Pin Definitions
//Pin Definitions
//The 74HC595 uses a serial communication link which has three pins
int data = 2; 
int clock = 3;
int latch = 4;
/////////////////////////

/////////////////////////
float my_bpm = 100.f;
int cstart = 0;
int clength = 2310;
////////////////////////

const int six_cycle = 6;
const int cycle_235_length = 30;
int beat_cycle[six_cycle] = {7, 1, 3, 5, 3, 1};
int beat_cycle_235[cycle_235_length] = {15,1,3,5,3,9,7,1,3,5,11,1,7,1,3,13,3,1,7,1,11,5,3,1,7,9,3,5,3,1};
int beat_cycle_7bit[100] = {127,1,3,5,3,9,7,17,3,5,11,33,7,65,19,13,3,1,7,1,11,21,35,1,7,9,67,5,19,1,15,1,3,37,3,25,7,1,3,69,11,1,23,1,35,13,3,1,7,17,11,5,67,1,7,41,19,5,3,1,15,1,3,21,3,73,39,1,3,5,27,1,7,1,3,13,3,49,71,1,11,5,3,1,23,9,3,5,35,1,15,81,3,5,3,9,7,1,19,37};

int trigger_pattern (int count) {
    int result = 0;
    int cycle0 = 1 << 0;
    int cycle1 = 1 << 1;
    int cycle2 = 1 << 2;
    int cycle3 = 1 << 3;
    int cycle4 = 1 << 4;
    int cycle5 = 1 << 5;
    int cycle6 = 1 << 6;
    int cycle7 = 1 << 7;
    
    if (count % 1 == 0)
        result |= cycle0;
    if (count % 2 == 0)
        result |= cycle1;
    if (count % 3 == 0)
        result |= cycle2;
    if (count % 5 == 0)
        result |= cycle3;
    if (count % 7 == 0)
        result |= cycle4;
    if (count % 11 == 0)
        result |= cycle5;
    if (count % 13 == 0)
        result |= cycle6;
    if (count % 17 == 0)
        result |= cycle7;
    return result;
}

/*
 * setup() - this function runs once when you turn your Arduino on
 * We set the three control pins to outputs
 */
void setup()
{
  pinMode(data, OUTPUT);
  pinMode(clock, OUTPUT);  
  pinMode(latch, OUTPUT);  
}

int bpm_time (float bpm) {
  return int((60./bpm)*1000. + 0.5);
}
/*
 * loop() - this function will start after setup finishes and then repeat
 * we set which LEDs we want on then call a routine which sends the states to the 74HC595
 */

#if 0
void loop()                     // run over and over again
{
  for(int i = 0; i < cycle_235_length; i++){
    next_beat (beat_cycle_235[i]);
    delay (bpm_time (my_bpm));  
  }
}
#endif
#if 0
void loop()                     // run over and over again
{
  for(int i = 0; i < 23; i++){
    next_beat (beat_cycle_7bit[i]);
    delay (bpm_time (my_bpm));  
  }
}
#endif
void loop ()                     // run over and over again
{
  for (int i = cstart; i < clength; i++){
    next_beat (trigger_pattern (i));
    delay (bpm_time (my_bpm));  
  }
}

void next_beat (int value) {
  digitalWrite (latch, LOW);     //Pulls the chips latch low
  shiftOut (data, clock, MSBFIRST, value); //Shifts out the 8 bits to the shift register
  digitalWrite (latch, HIGH);   //Pulls the latch high displaying the data
}
