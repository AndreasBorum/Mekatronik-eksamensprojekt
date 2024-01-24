// define input pin from PIC
#define IN_PIC 10

// define pins for color sensor
#define S0 4
#define S1 5
#define S2 6
#define S3 7
#define sensorOut 8

// array for background color and current color
int bgcolor[3];
int current_color[3];

// predefined color values for different tokens
int jeton_colors[6][3] = {{976, 1043, 324},
{1108, 950, 320},
{1129, 982, 332},
{927, 948, 304},
{143 , 138 , 47},
{123, 134, 34}};

// setting up pins and serial communication
void setup() {

  // Setting the output pins
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  pinMode(S2, OUTPUT);
  pinMode(S3, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);

  // Setting input pins
  pinMode(sensorOut, INPUT);
  pinMode(IN_PIC, INPUT);

  // Setting frequency scaling to 2%
  digitalWrite(S1, LOW);
  digitalWrite(S0, HIGH);

  // Begins serial communication
  Serial.begin(9600);
}

void loop() {

  // check for signal from PIC
  if (digitalRead(IN_PIC) == HIGH) {
    Serial.print("start \n");
    main_func();
  }
}

// main function that reads the color and sets output
void main_func() {
  read_color(bgcolor);

  delay(1000);
  read_color(current_color);

  // wait for color to change
  while (diff_color(current_color, bgcolor, 100) == 0 ){
    read_color(current_color);
    Serial.print(".");

  for(int i = 0; i < 3; i++)
  {
    Serial.print(current_color[i]);
    Serial.print(".");
  }

    
    delay(1000);
  }

  delay(1000);
  
  // read color again after change
  read_color(current_color);

  // categori ze the color and set the output
  int color_num = categorize_color(current_color, 60);
  delay(100);
  set_output(color_num);
  delay(6000);
  set_pins(0,0,0);
}

// function to read color from the sensor
void read_color(int* color) {
  // Setting RED (R) filtered photodiodes to be read
  digitalWrite(S2,LOW);
  digitalWrite(S3,LOW);
  // Reading the output frequency
  color[0] = pulseIn(sensorOut, LOW);

  // Setting GREEN (G) filtered photodiodes to be read
  digitalWrite(S2,HIGH);
  digitalWrite(S3,HIGH);
  // Reading the output frequency
  color[1] = pulseIn(sensorOut, LOW);

  // Setting BLUE (B) filtered photodiodes to be read
  digitalWrite(S2,LOW);
  digitalWrite(S3,HIGH);
  // Reading the output frequency
  color[2] = pulseIn(sensorOut, LOW);
}

// function to calculate the difference between two colors
bool diff_color(int arr1[], int arr2[], int num) {
  int diff_sum = 0;
  for (int i = 0; i < 3; i++) {
    diff_sum += abs(arr1[i] - arr2[i]);
  }
  return diff_sum > num;
}

// function to categorize the colors
int categorize_color(int arr1[], int num) {
  int arr[6] = {};

  for (int i = 0; i < 6; i++) {
    int diff_sum = 0;
    for (int j = 0; j < 3; j++) {
        diff_sum += abs(arr1[j] - jeton_colors[i][j]);
    }
    arr[i] = diff_sum;
  }
  for(int i = 0; i < 6; i++)
  {
    Serial.println(arr[i]);
  }
  int small = indexofSmallestElement(arr, 6);
  if ( arr[small]< num){ return small;}
  return 6;
}

// function that sets the output pins to PIC'en
void set_pins(bool num1, bool num2, bool num3){
  if (num1){ digitalWrite(11, HIGH);} else {digitalWrite(11, LOW);}
  if (num2){ digitalWrite(12, HIGH);} else {digitalWrite(12, LOW);}
  if (num2){ digitalWrite(13, HIGH);} else {digitalWrite(13, LOW);}
}

// function that sets the output pins based on kategorized color
void set_output(int num){
  if (num == 0){
    set_pins(0,0,1);
    Serial.print("sets pin 1");
  } else if (num==1){
    set_pins(0,1,0);
    Serial.print("sets pin 2");
  } else if (num==2){
    set_pins(0,1,1);
    Serial.print("sets pin 3");
  } else if (num==3){
    set_pins(1,0,0);
    Serial.print("sets pin 4");
  } else if (num==4){
    set_pins(1,0,1);
    Serial.print("sets pin 5");
  } else if (num==5){
    set_pins(1,1,0);
    Serial.print("sets pin 6");
  } else if (num==6){
    set_pins(1,1,1);
    Serial.print("sets pin 7");
  } else {
    set_pins(0,0,0);
    Serial.print("sets pin 8");
  }
  Serial.print("\n");
}


int indexofSmallestElement(int array[], int size)
{
    int index = 0;

    for(int i = 1; i < size; i++)
    {
        if(array[i] < array[index])
            index = i;              
    }

    return index;
}
