// Written by  Timo Dörries

PImage img;
float lastX=0, lastY=0;
color blue = color(0,187,255);
String path; // path of picture to work on
String folder; //parent folder

PrintWriter output,outputl; //output to chosen folder and to location of program folder
boolean startupLine = false; //only show Lines when actually meassuring
boolean selected = false; //don't crash on startup

boolean showLines = true;//Do you want to see the line you are tracking?
float xs,ys; //ratios of picture to displayed size


void setup() {
  size(1200,900);
  ellipseMode(CENTER);
  noFill();
  stroke(blue);
  strokeWeight(4);//Linienbreite
  selectInput("Select picture", "fileSelected");

}
void draw() {
   if(selected)background(img);
   noFill();
   if(mousePressed && mouseButton==LEFT){
     ellipse(mouseX,mouseY, 10,10);
     text(str(distance(xs*lastX,ys*lastY,xs*float(mouseX),ys*float(mouseY))),mouseX+10,mouseY+10);
     if(!startupLine)line(lastX, lastY, mouseX, mouseY);
   }
}
void mouseReleased(){
  if(mouseButton == LEFT){
    finishData();
    if(showLines){    
      save("diagonal.tif");
      delay(100);//if there's an error in the next line increase here
      img = loadImage("diagonal.tif");
      background(img);
     }
  }
  if(mouseButton == RIGHT) {
     nextPicture();
  }
}

float distance (float x1, float y1, float x2, float y2){
  return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}
void finishData(){//Daten speichern
    output.println(distance(xs*lastX,ys*lastY,xs*mouseX,ys*mouseY));//Print to file
    outputl.println(distance(xs*lastX,ys*lastY,xs*mouseX,ys*mouseY));
    output.flush();//save file
    outputl.flush();
    startupLine = false;
    lastX=mouseX;
    lastY=mouseY; 
}
void mousePressed() {
  lastX = mouseX;
  lastY = mouseY; 
}
void keyPressed(){
  if(key=='r'){//manually choose a pic
    selectInput("Select a file to process:", "fileSelected");
  }
  if(key=='n'){//go to next pic
    nextPicture();
  }
}
void nextPicture(){
    String number="";
    int startInt = -1, endInt=-1;
    char temporary;
    for(int i=path.length()-1; i>0; i--){
      temporary = path.charAt(i);//work-with Filename
      if(Character.isDigit(temporary)){
        if(startInt==-1){
          startInt = i;//right boundry
        }
      }
      if(!Character.isDigit(temporary) && startInt!=-1 && endInt==-1){//where do the letters end?
        endInt = i;
      }
    }
    for(int i=endInt+1; i<=startInt;i++){//Put back together
      temporary = path.charAt(i); 
      number=number + temporary;
    }
    String startFileName = path.substring(0,endInt+1);
    String endDateiname = path.substring(startInt+1,path.length());
    int nummer = Integer.parseInt(number);
    boolean success = false;
    for(int i=nummer; i<1000+nummer;i++){//Look wich number exists
      number = nf(i, startInt-endInt);
      path = startFileName+number+endDateiname;
      File f = new File(dataPath(path));
      if (f.exists()) {//This number exists
        success = true;
        img = loadImage(path);
        xs = float(img.width)/float(width);//scale for X
        ys = float(img.height)/float(height);//scale for Y
        img.resize(width,height);//scale Picture to fit Window
        background(img);
        break;
      }
    }
    if(!success)selectInput("Select file", "fileSelected");
}
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());
    path = selection.getAbsolutePath();
    img.resize(width,height);
    background(img);
    xs = float(img.width)/float(width);//scale for X
    ys = float(img.height)/float(height);//scale for Y   
    folder = selection.getParent();
    output = createWriter(folder + "/singleLines.csv"); 
    outputl = createWriter("singleLines.csv");   
    selected = true;
  }
}