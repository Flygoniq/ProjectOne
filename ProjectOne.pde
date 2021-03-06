// Template for 2D projects
// Author: Jarek Rossignac.  Used by Alan Jiang, Anish Sharma
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import controlP5.*;

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
//int ms=0, me=0; // milli seconds start and end for timing
float interpolator1; //this variable bounces between 0 and 1 to help manage interpolations
float interpolator2;
boolean rising1; //manages interpolator1
boolean rising2;
int npts=20000; // number of points
pt center;
ControlP5 cp5;
float InterpolateRateOne = 5;
float InterpolateRateTwo = 5;
int displayCounter;
boolean viewDots;
pt[] dots;
int dotCount;
color dotColor, edge1Color, edge2Color, movingEdgesColor, movingSpiralColor;

//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
    dotColor = black;
    edge1Color = green;
    edge2Color = red;
    movingEdgesColor = cyan;
    movingSpiralColor = cyan;
    dots = new pt[3];
    dotCount = 0;
    viewDots = true;
    displayCounter = 0;
    cp5 = new ControlP5(this);
    interpolator1 = 0;
    rising1 = true;
    size(800, 800);            // window size
    frameRate(30);             // render 30 frames per second
    smooth();                  // turn on antialiasing
    myFace = loadImage("data/Face.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
    myFace2 = loadImage("data/FaceTwo.jpg"); 
    P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
    // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
    P.loadPts("data/pts");  // loads points form file saved with this program
    center = new pt(width / 2, height / 2);
  
    cp5.addSlider("InterpolateRateOne")
       .setPosition(50, 650)
       .setRange(2, 100)
       .setSize(90, 20)
       .setLabel("Line Rate")
       .setColorLabel(ControlP5.BLACK)
       ;
    cp5.addSlider("InterpolateRateTwo")
       .setPosition(50, 680)
       .setRange(2, 100)
       .setSize(90, 20)
       .setLabel("Dot Rate")
       .setColorLabel(ControlP5.BLACK)
       ;
  }// end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3];     // crates points with more convenient names
    pt AP = A.invert();  pt BP = B.invert();  pt CP = C.invert();  pt DP = D.invert();  

    //pt F = SpiralCenter1(A,B,C,D);

    
    //showId(AP,"AP"); showId(BP,"BP"); showId(CP,"CP"); showId(DP,"DP");
    noFill();
    displayCounter = 0;
    dotCount = 0;
    doTheAnimation(A, B, C, D, AP, BP, CP, DP);
    pen(movingSpiralColor, 2);
    showSpiralThrough3Points(dots[0], dots[1], dots[2]);
    if (viewDots) {
      pen(dotColor,1); showId(A,"A"); showId(B,"B"); showId(C,"C"); showId(D,"D");// showId(center, "8");showId(F,"F");
      for (pt p : dots) {
        showId(p, "P");
      }
    }

    pen(edge1Color,3); edge(A,B); edge(AP,BP);  pen(edge2Color,3); edge(C,D); edge(CP,DP);

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  
  //interpolator1 update
  if (rising1) {
    interpolator1 += (.1 / InterpolateRateOne);
    if (interpolator1 >= 1 - (.1 / InterpolateRateOne)) {
      rising1 = false;
    }
  } else {
    interpolator1 -= (.1 / InterpolateRateOne);
    if (interpolator1 <= (.1 / InterpolateRateOne)) {
      rising1 = true;
    }
  }
  //interpolator2 update
  if (rising2) {
    interpolator2 += (.1 / InterpolateRateTwo);
    if (interpolator2 >= 1 - (.1 / InterpolateRateTwo)) {
      rising2 = false;
    }
  } else {
    interpolator2 -= (.1 / InterpolateRateTwo);
    if (interpolator2 <= (.1 / InterpolateRateTwo)) {
      rising2 = true;
    }
  }
  }  // end of draw
  