//============================================================+
// File name   : Caroline.vala
// Last Update : 2020-6-9
//
// Version: 0.2.0
//
// Description : This is an extension of a GTK Drawing Area. Its purpose is to make it easy for any level
// of developer to use charts in their application. More in depth documentation is found in below and in the
// README, if you have any critiques or questions, go ahead and open an issue in this repo.
//
// valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vapi Sample.vala -X Caroline.so -X -I. -o demo
//
// Author: David Johnson
//============================================================+

//Importing Gtk, Cairo, and Gee; These are needed to support our Gtk.DrawingArea
using Gtk;
using Cairo;
using Gee;

//Extending the Gtk.DrawingArea Class
public class Caroline : Gtk.DrawingArea {

  /*
  *
  * Items that are used internally and are not exposed to the developer.
  *
  */

  public double spreadFinalY { get; set; }
  private double spreadFinalX { get; set; }

  private int yTickStart { get; set; }
  private int yTickEnd { get; set; }
  private int yTextStart { get; set; }

  private int xTickStart { get; set; }
  private int xTickEnd { get; set; }
  private int xTextStart { get; set; }
  private int xTextEnd { get; set; }

  public int widthPadding { get; set; }
  private int heightPadding { get; set; }

  private double gapPoint { get; set; }
  private double maxPoint { get; set; }
  private double minPoint { get; set; }



  private ArrayList<string> labelYList = new ArrayList<string>();

  private double PIX { get; set; }

  /*
  *
  * Items that can be changed without a recompile by the developer.
  *
  */

  //Used to store colors
  public struct ChartColor {
    public double r;
    public double g;
    public double b;
  }

  public struct Point {
    public double x;
    public double y;
  }

  public int width { get; set; }
  public int height { get; set; }

  public double gap { get; set; }
  public double max { get; set; }
  public double min { get; set; }

  public int chartPadding { get; set; }

  public double lineThicknessTicks { get; set; }
  public double lineThicknessPlane { get; set; }
  public double lineThicknessData { get; set; }
  public double spreadY { get; set; }
  public double spreadX { get; set; }

  public string dataTypeY { get; set; }
  public string dataTypeX { get; set; }
  public string chartType { get; set; }

  public ArrayList<double?> labelXList = new ArrayList<double?>();

  public int pieChartXStart { get; set; }
  public int pieChartYStart { get; set; }
  public int pieChartRadius { get; set; }
  public int pieChartYLabelBStart { get; set; }
  public int pieChartYLabelBSpacing { get; set; }
  public int pieChartLabelBSize { get; set; }
  public int pieChartLabelOffsetX { get; set; }
  public int pieChartLabelOffsetY { get; set; }

  public ArrayList<ChartColor?> chartColorArray = new ArrayList<ChartColor?>();

  public ArrayList<Point?> pointsArray = new ArrayList<Point?>();
  public ArrayList<Point?> pointsCalculatedArray = new ArrayList<Point?>();
  public ArrayList<Point?> pointsCalculatedBarArray = new ArrayList<Point?>();

  public ArrayList<string> chartTypes = new ArrayList<string>();

  public bool scatterLabels {get; set;}

  construct{

    //Initializing default values
    this.widthPadding = 50;
    this.heightPadding = 50;

    this.chartPadding = 14;

    this.yTickStart = 20;
    this.yTickEnd = 45;
    this.yTextStart = 0;

    this.xTickStart = 20;
    this.xTickEnd = 5;
    this.xTextStart = 11;
    this.xTextEnd = 30;

    this.width = 500;
    this.height = 500;
    this.spreadX = 10;
    this.spreadY = 10;
    this.lineThicknessTicks = 0.5;
    this.lineThicknessData = 1;
    this.lineThicknessTicks = 2;
    this.dataTypeY = "";
    this.dataTypeX = "";
    this.gap = 0;
    this.minPoint = 0;
    this.maxPoint = 0;
    this.chartType = "line";

    this.pieChartXStart = 175;
    this.pieChartYStart = 175;
    this.pieChartRadius = 150;
    this.pieChartYLabelBStart = 50;
    this.pieChartYLabelBSpacing = 25;
    this.pieChartLabelBSize = 15;
    this.pieChartLabelOffsetX = 20;
    this.pieChartLabelOffsetY = 10;

    this.scatterLabels = true;

  }

  /**
  * data - the actual data for that charts
  * chartType - this can either be line, bar, or pie
  * generateColors - array for ChartColor structs
  * scatterPlotLabels - show labels on the scatter plot
  */
  public Caroline(double[] dataX, double[] dataY, string[] chartTypeArray, bool generateColors, bool scatterPlotLabels){

    /*Since our widget will already be "realized" we want to use add_events, this
    function allows us to set the window event bit flags, which I document directly below.
    For more info on this start here: https://valadoc.org/gtk+-3.0/Gtk.Widget.add_events.html*/
    add_events(
      /*Gdk.EventMast are a set of bit flags used to decide which events a window is to recieve.
      In our case we want to be able to track press, release, and motion. Eventually as this
      "library" grows we will take advantage of all of these.*/
      Gdk.EventMask.BUTTON_PRESS_MASK |
      Gdk.EventMask.BUTTON_RELEASE_MASK |
      Gdk.EventMask.POINTER_MOTION_MASK
    );

    /*We want to allow the developer to set a minimum size of the widget so their parent
    application knows approx what the size will be.
    For more info on this start here: https://valadoc.org/gtk+-3.0/Gtk.Widget.set_size_request.html*/
    set_size_request(
      this.width,
      this.height
    );

    this.scatterLabels = scatterPlotLabels;
    this.chartType = chartTypeArray[0];
    this.labelXList.add(0);

    if (dataX.length < 15){

      this.spreadX = dataX.length;
      this.spreadY = dataY.length;

    }

    for (int i = 0; i < dataX.length; i++) {

      Caroline.Point point = {dataX[i], dataY[i]};
      this.pointsArray.add(point);

    }

    foreach (string type in chartTypeArray)
      this.chartTypes.add(type);

    if (chartType != "pie")
      this.arrayListSort();

    if (chartType == "pie" && generateColors)
      this.generateColors();

    double tick = this.pointsArray[dataY.length-1].x / spreadX;

    for (double f = 0; f < this.spreadX; f++){
      if (f == 0)
        this.labelXList.add(tick+(tick*f));
      else
        this.labelXList.add((tick+(tick*f)) + (tick));
    }

    //  }else
    //  for (int i = 0; i < pointsArray.size; i++)
    //this.labelXList.add(pointsArray[i].x);

  }

  /**
  * Draws the tick marks and calls sub chart type functions
  *
  * Within draw we do several things, first we confirm our height/width. Then we move our
  * pointer on the canvas and draw the x & y axis. After we draw all the ticks on each axis.
  * Lastly we point to the proper chart type function which will draw the chart itself.
  *
  * @param type var Description
  * @return return type
  */
  public override bool draw (Cairo.Context cr) {

    this.calculations();

    /*Here we are grabbing the width and height assocaited with 'this'.
    We then subtract a settable padding around the entirety of the widget. We can also
    observe that 'this' should have the width and height we requested in the set_size_request
    function.*/
    this.width = get_allocated_width() - this.widthPadding;
    this.height = get_allocated_height() - this.heightPadding;

    if(this.chartType != "pie"){

      //As the function illudes too, this sets the width of the lines for the x & y ticks.
      cr.set_line_width(this.lineThicknessTicks);

      //setting the color of the lines.
      cr.set_source_rgba(255, 255, 255, 0.2);

      this.drawOutline(cr);

      this.drawYTicks(cr);

      this.drawXTicks(cr);

      /*Sets the drawing area and its attributes back to their defaults, which are set on
      previous save() or the initial value*/
      cr.restore();

      //Saves the drawing area context and the attributes set before this save
      cr.save();

    }

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(1);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    for (int f = 0; f < this.chartTypes.size; f++){

      if (this.chartTypes.get(f) != "bar")
        this.pointCalculationsLoose();
      else
        this.pointCalculationsBar();

      /*This switch-case will execute the proper chart depending on what the
      developer has choosen.*/
      switch (this.chartTypes.get(f)) {
        case "line":
          Line line = new Line();
          line.drawLineChart(cr,this.pointsCalculatedArray,this.chartPadding + (this.widthPadding / 3));
          break;
        case "smooth-line":
          LineSmooth lineSmooth = new LineSmooth();
          lineSmooth.drawLineSmoothChart(cr,this.pointsCalculatedArray,this.chartPadding + (this.widthPadding / 3));
          break;
        case "bar":
          Bar bar = new Bar();
          bar.drawBarChart(cr,this.pointsCalculatedBarArray,this.height+this.chartPadding);
          break;
        case "pie":
          Pie pie = new Pie();
          pie.drawPieChart(
            cr,
            this.pointsArray,
            this.chartColorArray,
            this.pieChartXStart,
            this.pieChartYStart,
            this.pieChartRadius,
            this.pieChartYLabelBStart,
            this.pieChartYLabelBSpacing,
            this.pieChartLabelOffsetX,
            this.pieChartLabelOffsetY,
            this.pieChartLabelBSize,
            this.width
          );
          break;
        case "scatter":
          Scatter scatter = new Scatter();
          scatter.drawScatterChart(cr,this.pointsCalculatedArray,this.pointsArray,this.scatterLabels);
          break;
        default:
          LineSmooth lineSmooth = new LineSmooth();
          lineSmooth.drawLineSmoothChart(cr,this.pointsCalculatedArray,this.chartPadding + (this.widthPadding / 3));
          break;
      }

    }

    return true;

  }

  /**
  * Finds the correct positioning for the x & y labels.
  *
  * Below we first attempt to find the max and min values of the data array. After
  * that we use those values to calculate the gap between each of the labels. This
  * gap value will also be used elsewhere for the chart lines. Finally we dynamically
  * write the y labels to our list to be used in the drawing stage, this allows us to
  * not have to manually input values for the y axis.
  *
  * @param none
  * @return void
  */
  private void calculations(){

    /*This next sector of arithmetic is to find the max value of the data array*/
    this.maxPoint = this.pointsArray[0].y;

    //Loop and compare each value to our initial value to see if it becomes the max
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray[i].y > this.maxPoint)
        this.maxPoint = this.pointsArray[i].y;

    /*This next sector of arithmetic is to find the min value of the data array*/
    this.minPoint = 0;

    //Loop and compare each scatterArray to our initial value to see if it becomes the min
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray[i].y < this.minPoint)
        this.minPoint = this.pointsArray[i].y;

    /*Finds the gap between each y axis label to be displayed. spreadY is set on the
    developers side, it is meant to tell Caroline how many y axis ticks needed.*/
    this.gap = (this.maxPoint - this.minPoint) / this.spreadY;

    //Initial y axis value
    double yLabel = this.minPoint;

    for (int i = 0; i < this.spreadY + 1; i++){

      if (i > 0)
        yLabel = yLabel + gap;

      //Depending on double length we clean it up a bit for display if its over 8 digits
      if (yLabel.to_string().length >= 8)
        this.labelYList.add(yLabel.to_string().slice (0, 8));
      else
        this.labelYList.add(yLabel.to_string());

    }

  }

  private void pointCalculationsLoose(){

    this.pointsCalculatedArray.clear();
    double maxX = 0;

    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray.get(i).x > maxX)
        maxX = this.pointsArray.get(i).x;

    for (int i = 0; i < this.pointsArray.size; i++) {

      double scaler = ((this.pointsArray[i].y - this.minPoint) / (this.maxPoint - this.minPoint)) * this.spreadY;

      double x = this.pointsArray[i].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 3);
      double y = (this.height + this.chartPadding) - ((this.spreadFinalY * scaler));

      Caroline.Point point = {x, y};
      this.pointsCalculatedArray.add(point);

    }

  }

  private void pointCalculationsBar(){

    this.pointsCalculatedBarArray.clear();
    double maxX = 0;

    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray.get(i).x > maxX)
        maxX = this.pointsArray.get(i).x;

    for (int i = 0; i < this.pointsArray.size; i++) {

      double scaler = ((this.pointsArray[i].y - this.minPoint) / (this.maxPoint - this.minPoint)) * this.spreadY;

      double x = this.pointsArray[i].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 4.35);
      double y = -(this.spreadFinalY * scaler);

      Caroline.Point point = {x, y};
      this.pointsCalculatedBarArray.add(point);

    }

  }

  private void drawOutline(Cairo.Context cr){

    double widthPaddingDiv = this.chartPadding + (this.widthPadding / 3);

    /*We want to move the pointer on the canvas to where we want the axis's to be, to
    learn more about move_to: https://valadoc.org/cairo/Cairo.Context.move_to.html*/
    cr.move_to(
      widthPaddingDiv,
      this.chartPadding
    );

    //We draw a line from x axis 15 to the height plus 15
    cr.line_to(
      widthPaddingDiv,
      this.height + this.chartPadding
    );

    //Now we draw the x axis using the same methodolgy as the y axis directly above.
    cr.move_to(
      this.width + widthPaddingDiv,
      this.height + this.chartPadding
    );
    cr.line_to(
      widthPaddingDiv,
      this.height + this.chartPadding
    );

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

  private void drawYTicks(Cairo.Context cr){

    //Reset the path so when we execute move_to again we are starting from 0,0 on the cario canvas
    cr.new_path();

    //Figure out the spread of each of the y coordinates.
    this.spreadFinalY = this.height/this.spreadY;

    /*We loop through all of the y labels and actually draw thes lines and add the actual text for
    each tick mark.*/
    for (int i = 0; i < this.spreadY + 1; i++){

      double y = height + this.chartPadding - (this.spreadFinalY * i);

      //line drawing
      cr.move_to(
        this.yTickStart,
        y
      );
      cr.line_to(
        this.yTickEnd,
        y
      );

      //moves the current drawing area so the text will display properly
      cr.move_to(
        this.yTextStart + (this.widthPadding / 3),
        y
      );
      cr.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

    };

  }

  private void drawXTicks(Cairo.Context cr){

    /*Figure out the spread of each of the x coordinates, notice this is differnt from the y
    plane, we want to display each data point on the x axis here.*/
    this.spreadFinalX = this.width/(this.spreadX-1);

    /*We loop through all of the x labels and actually draw thes lines and add the actual text for
    each tick mark.*/
    for (int i = 0; i < this.spreadX; i++){

      double rawXCalculation = 0;

      if (this.chartType != "line" && this.chartType != "bar")
        rawXCalculation = this.labelXList.get(i) * (this.width/this.labelXList.get(this.labelXList.size-1));
      else
        rawXCalculation = this.spreadFinalX * i;

      double x = this.chartPadding + rawXCalculation + (this.widthPadding / 3);

      //line drawing
      cr.move_to(
        x,
        height + this.xTickStart
      );

      cr.line_to(
        x,
        height + this.xTickEnd
      );

      //moves the current drawing area back and lists the x axis value below the x tick
      cr.move_to(
        xTextStart + rawXCalculation + (this.widthPadding / 3),
        height + this.xTextEnd
      );

      var roundedX = snipLongDouble(this.labelXList.get(i));
      cr.show_text(roundedX);

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

  /**
  * Generates random colors for any of the charts
  *
  * In this function function we use the ChartColor struct to add a random double form 0-1 for a simple
  * rgb color.then it is added to an array to be access else where.
  *
  * @param type none
  * @return return void
  */
  private void generateColors(){

    for (int i = 0; i < this.pointsArray.size; i++){

      //Create color struct
      ChartColor chartColor = {
        Random.double_range(0,1),
        Random.double_range(0,1),
        Random.double_range(0,1)
      };

      this.chartColorArray.insert(i,chartColor);

    }

  }

  /**
  * Sort an array list
  *
  * Within this function we sort the array list by the x axis. Why? Well we need to know in what order to create
  * bar and line charts. However in pie charts, we don't need to know the order, hence we exlude this
  * sorting since its the main performance bottle neck within the system.
  *
  * @param type none
  * @return return void
  */
  public void arrayListSort(){

    bool swapped = true;
    int j = 0;
    double tmpX,tmpY;
    Caroline.Point point = {0,0};

    while (swapped) {

      swapped = false;
      j++;

      for (int i = 0; i < this.pointsArray.size - j; i++) {

        /*if current x is bigger than the next x, we move it a position forward, along with its y counter
        part (y coordinate).*/
        if (this.pointsArray[i].x > this.pointsArray[i+1].x) {

          tmpX = this.pointsArray[i].x;
          tmpY = this.pointsArray[i].y;

          point = {this.pointsArray[i+1].x, this.pointsArray[i+1].y};
          this.pointsArray.set(i,point);

          point = {tmpX,tmpY};
          this.pointsArray.set(i+1,point);

          swapped = true;

        }

      }

    }

  }

  /**
  * Cuts decimals off a float number
  *
  * In several areas within our system we need to remove some decimals within a number so they we can display
  * readable numbers for the chart and developer.
  *
  * @param type number | double
  * @return return string
  */
  public string snipLongDouble(double number){

    return "%0.1f".printf(number);

  }

}
