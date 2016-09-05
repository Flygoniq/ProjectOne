// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt center;

//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(800, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
  center = new pt(width / 2, height / 2);
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3];     // crates points with more convenient names
    pt AP = A.invert();  pt BP = B.invert();  pt CP = C.invert();  pt DP = D.invert();  

   pen(green,3); edge(A,B); edge(AP,BP);  pen(red,3); edge(C,D); edge(CP,DP);
   //pt F = SpiralCenter1(A,B,C,D);

    pen(black,2); showId(A,"A"); showId(B,"B"); showId(C,"C"); showId(D,"D"); showId(center, "8");// showId(F,"F");
    //showId(AP,"AP"); showId(BP,"BP"); showId(CP,"CP"); showId(DP,"DP");
    noFill();
    //pen(blue,2); show(SpiralCenter2(A,B,C,D),16);
    //pen(magenta,2); show(SpiralCenter3(A,B,C,D),20);
    pen(cyan,2); showSpiralPattern(A,B,C,D);
    pen(cyan,2); showSpiralPattern(AP,BP,CP,DP);
    pen(blue,2); showSpiralThrough3Points(center,A,C);
    pen(blue,2); showSpiralThrough3Points(center,AP,CP);

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  