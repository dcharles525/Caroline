//============================================================+
// File name   : Caroline.vala
// Last Update : 2020-3-15
//
// Version: 0.1.1
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

  private double spreadFinalY { get; set; }
  private double spreadFinalX { get; set; }

  private int yTickStart { get; set; }
  private int yTickEnd { get; set; }
  private int yTextStart { get; set; }

  private int xTickStart { get; set; }
  private int xTickEnd { get; set; }
  private int xTextStart { get; set; }
  private int xTextEnd { get; set; }

  private int widthPadding { get; set; }
  private int heightPadding { get; set; }

  private double gap { get; set; }
  private double max { get; set; }
  private double min { get; set; }

  private int rectangleXOffset { get; set; }

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
    this.min = 0;
    this.max = 0;
    this.chartType = "line";

    this.rectangleXOffset = 10;

    this.pieChartXStart = 175;
    this.pieChartYStart = 175;
    this.pieChartRadius = 150;
    this.pieChartYLabelBStart = 50;
    this.pieChartYLabelBSpacing = 25;
    this.pieChartLabelBSize = 15;
    this.pieChartLabelOffsetX = 20;
    this.pieChartLabelOffsetY = 10;
    this.PIX = 6.28;

    this.scatterLabels = true;

  }

  /**
  * data - the actual data for that charts
  * chartType - this can either be line, bar, or pie
  * generateColors - array for ChartColor structs
  * scatterPlotLabels - show labels on the scatter plot
  */
  public Caroline(double[] dataX, double[] dataY, string chartType, bool generateColors, bool scatterPlotLabels){

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
    this.chartType = chartType;
    this.labelXList.add(0);

    if (dataX.length < 15 || this.chartType == "bar"){

      this.spreadX = dataX.length;
      this.spreadY = dataY.length;

    }

    for (int i = 0; i < dataX.length; i++) {

      Caroline.Point point = {dataX[i], dataY[i]};
      this.pointsArray.add(point);

    }

    if (chartType != "pie")
      this.arrayListSort();

    if (chartType == "pie" && generateColors)
      this.generateColors();

    if (chartType != "bar"){

      double tick = this.pointsArray[dataX.length-1].x / spreadX;

      for (int f = 0; f < this.spreadX; f++)
        this.labelXList.add(tick+(tick*f));

    }else
      for (int i = 0; i < pointsArray.size; i++)
        this.labelXList.add(pointsArray[i].x);

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

      //As the function illudes too, this sets the color of the lines.
      cr.set_source_rgba(255, 255, 255, 0.2);

      /*We want to move the pointer on the canvas to where we want the axis's to be, to
      learn more about move_to: https://valadoc.org/cairo/Cairo.Context.move_to.html*/
      cr.move_to(
        this.chartPadding + (this.widthPadding / 3),
        this.chartPadding
      );

      //We draw a line from x axis 15 to the height plus 15
      cr.line_to(
        this.chartPadding + (this.widthPadding / 3),
        this.height + this.chartPadding
      );

      //Now we draw the x axis using the same methodolgy as the y axis directly above.
      cr.move_to(
        this.width + this.chartPadding + (this.widthPadding / 3),
        this.height + this.chartPadding
      );
      cr.line_to(
        this.chartPadding + (this.widthPadding / 3),
        this.height + this.chartPadding
      );

      /*Drawing operator that strokes the current path using the current settings that were
      implemented eariler in this file.*/
      cr.stroke();

      //Reset the path so when we execute move_to again we are starting from 0,0 on the cario canvas
      cr.new_path();
      cr.set_line_width(this.lineThicknessTicks);

      //Figure out the spread of each of the y coordinates.
      this.spreadFinalY = this.height/this.spreadY;

      /*We loop through all of the y labels and actually draw thes lines and add the actual text for
      each tick mark.*/
      for (int i = 0; i < this.spreadY + 1; i++){

        //line drawing
        cr.move_to(
          this.yTickStart,
          height + this.chartPadding - (this.spreadFinalY * i)
        );
        cr.line_to(
          this.yTickEnd,
          height + this.chartPadding - (this.spreadFinalY * i)
        );

        //moves the current drawing area so the text will display properly
        cr.move_to(
          this.yTextStart + (this.widthPadding / 3),
          height + this.chartPadding - (this.spreadFinalY * i)
        );
        cr.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

      };

      /*Figure out the spread of each of the x coordinates, notice this is differnt from the y
      plane, we want to display each data point on the x axis here.*/
      this.spreadFinalX = this.width/(this.spreadX-1);

      /*We loop through all of the x labels and actually draw thes lines and add the actual text for
      each tick mark.*/
      for (int i = 0; i < this.labelXList.size; i++){

        double rawXCalculation = 0;

        if (this.chartType != "line" && this.chartType != "bar")
          rawXCalculation = this.labelXList.get(i) * (this.width/this.labelXList.get(this.labelXList.size-1));
        else
          rawXCalculation = this.spreadFinalX * i;

        //line drawing
        cr.move_to(
          this.chartPadding + rawXCalculation + (this.widthPadding / 3),
          height + this.xTickStart
        );

        cr.line_to(
          this.chartPadding + rawXCalculation + (this.widthPadding / 3),
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

      /*Sets the drawing area and its attributes back to their defaults, which are set on
      previous save() or the initial value*/
      cr.restore();

      //Saves the drawing area context and the attributes set before this save
      cr.save();

    }

    /*This switch-case will execute the proper chart depending on what the
    developer has choosen.*/
    switch (this.chartType) {
      case "line":
        lineChart(cr);
        break;
      case "smooth-line":
        smoothLineChart(cr);
        break;
      case "bar":
        barChart(cr);
        break;
      case "pie":
        pieChart(cr);
        break;
      case "scatter":
        scatterChart(cr);
        break;
      default:
        lineChart(cr);
        break;
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
  * @return return void
  */
  private void calculations(){

    /*This next sector of arithmetic is to find the max value of the data array*/
    this.max = this.pointsArray[0].y;

    //Loop and compare each value to our initial value to see if it becomes the max
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray[i].y > this.max)
        this.max = this.pointsArray[i].y;

    /*This next sector of arithmetic is to find the min value of the data array*/
    this.min = 0;

    //Loop and compare each scatterArray to our initial value to see if it becomes the min
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray[i].y < this.min)
        this.min = this.pointsArray[i].y;

    /*Finds the gap between each y axis label to be displayed. spreadY is set on the
    developers side, it is meant to tell Caroline how many y axis ticks needed.*/
    this.gap = (this.max - this.min) / this.spreadY;

    //Initial y axis value
    double yLabel = this.min;

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

  /**
  * Draws a line based on the pointsArray
  *
  * Uses the Cairo.Context to draw the line chart via the .move_to function
  * which allows you to move the current point to the necessary area and
  * line_to() which goes from one point to another while leaving a line behind.
  *
  * @param type cr | Cairo.Context
  * @return return void
  */
  private void lineChart(Cairo.Context cr){

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(this.lineThicknessData);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    //Getting a scaler, which will help put the line in the right spot
    double scaler = ((this.pointsArray[0].y - this.min) / (this.max - this.min)) * this.spreadY;

    //We want to move the pointer on the canvas to where we want the line graph to start.
    cr.move_to(
      //x axis set to "0", as 15 is the buffer in the widget
      this.chartPadding + (this.widthPadding / 3),
      /*y axis using our scaler value multiplied by how many y axis values we have,
      then subtracted from the height*/
      (this.height + this.chartPadding) - ((this.spreadFinalY * scaler))
    );

    for (int i = 1; i < this.pointsArray.size; i++){

      //Recalculating the scaler to our current value
      scaler = ((this.pointsArray[i].y - this.min) / (this.max - this.min)) * this.spreadY;

      /*line_to (https://valadoc.org/cairo/Cairo.Context.line_to.html) is a simple
      cario function that allows us to draw a line from the previous canvas pointer.*/
      cr.line_to(
        /*axis, similar to move_to above, we just move the the line to the
        next x axis tick.*/
        (this.chartPadding + this.spreadFinalX * (i)) + (this.widthPadding / 3),
        /*y axis using our scaler value multiplied by how many y axis values we have,
        then subtracted from the height*/
        ((this.height + this.chartPadding) - ((this.spreadFinalY * scaler)))
      );

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

  private void smoothLineChart(Cairo.Context cr){

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(this.lineThicknessData);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    //Getting a scaler, which will help put the line in the right spot
    double scaler = ((this.pointsArray[0].y - this.min) / (this.max - this.min)) * this.spreadY;

    //We want to move the pointer on the canvas to where we want the line graph to start.
    cr.move_to(
      //x axis set to "0", as 15 is the buffer in the widget
      this.chartPadding + (this.widthPadding / 3),
      /*y axis using our scaler value multiplied by how many y axis values we have,
      then subtracted from the height*/
      (this.height + this.chartPadding) - ((this.spreadFinalY * scaler))
    );

    for (int i = 0; i < this.pointsArray.size - 1; i++){

      double beforeX = (this.chartPadding + this.spreadFinalX * (i)) + (this.widthPadding / 3);
      double beforeY = this.pointsArray[i].y;
      scaler = ((beforeY - this.min) / (this.max - this.min)) * this.spreadY;
      beforeY = ((this.height + this.chartPadding) - ((this.spreadFinalY * scaler)));

      double currentX = (this.chartPadding + this.spreadFinalX * (i+1)) + (this.widthPadding / 3);
      double currentY = ((i + 1) >= this.pointsArray.size) ? this.pointsArray[i].y : this.pointsArray[i+1].y;

      scaler = ((currentY - this.min) / (this.max - this.min)) * this.spreadY;
      currentY = ((this.height + this.chartPadding) - ((this.spreadFinalY * scaler)));

      double force = (currentX - beforeX) / 2.0;

      /*cr.arc(
        beforeX,
        beforeY,
        3,
        0,
        this.PIX
      );*/

      cr.curve_to(
        beforeX + force,
        beforeY,
        currentX - force,
        currentY,
        currentX,
        currentY
      );

      stdout.printf("%f | %f \n",this.pointsArray[i].x,this.pointsArray[i].y);

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

  /**
  * Draws a set of rectangles based on the pointsArray
  *
  * Uses the Cairo.Context to draw a set of rectanges that will be positioned in a bar
  * chart format. The most important function used is rectangle, which allows us to quickly
  * form objects without having to use line_to.
  *
  * @param type cr | Cairo.Context
  * @return return void
  */
  private void barChart(Cairo.Context cr){

    //Getting a scaler, which will help put the line in the right spot
    double scaler = ((this.pointsArray[0].y - this.min) / (this.max - this.min)) * this.spreadY;
    double maxX = 0;

    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray.get(i).x > maxX)
        maxX = this.pointsArray.get(i).x;

    for (int i = 0; i < this.pointsArray.size; i++){

      //Recalculating the scaler to our current value
      scaler = ((this.pointsArray[i].y - this.min) / (this.max - this.min)) * this.spreadY;

      /*Rectangle takes x,y,width,height as doubles, which will position the rectangle
      at the pointer on the canvas*/
      cr.rectangle(
        //We have a bit of a smaller buffer (10) since the rectangles should be centered on tick marks
        (this.rectangleXOffset + this.spreadFinalX * (i + 1)) + (this.widthPadding / 3.35),
        this.height+this.chartPadding,
        this.rectangleXOffset,
        /*We want to draw our height "upwards" on the 2d plane, since 0,0 on this canvas is in the
        top left corner of the widget, hence the negative number.*/
        -(((this.spreadFinalY * scaler)))
      );

      //Fills the rectangle with the current color
      cr.set_source_rgba(0, 174, 174, 0.2);

      cr.fill();

    }

  }

  /**
  * Draws a pie chart based on the pointsArray
  *
  * Uses the Cairo.Context to draw the pie chart by first, figuring out the radians for each piece
  * of data. You can see that we need to find the total of the set of data. Then we loop over it
  * creating the arc, lines, fill, and labels all in one swoop.
  *
  * @param type cr | Cairo.Context
  * @return return void
  */
  private void pieChart(Cairo.Context cr){

    double total = 0;
    double startAngle = 0;

    /*This for loop gets the total of all the data so we can scale the pie
    chart later on.*/
    for (int i = 0; i < this.pointsArray.size; i++)
      total += this.pointsArray[i].x;

    for (int i = 0; i < this.pointsArray.size; i++){

      //Uses the chart color arrya with the structs within it to set the color
      cr.set_source_rgb(
        this.chartColorArray.get(i).r,
        this.chartColorArray.get(i).g,
        this.chartColorArray.get(i).b
      );

      //Draws an arc based on the angle that is calculated.
      cr.arc (
        this.pieChartXStart,
        this.pieChartYStart,
        this.pieChartRadius,
        startAngle,
        startAngle + (this.pointsArray[i].x / total) * this.PIX
      );

      /*Adds angle to startAngle to keep track of where to draw the next arc and then the code
      draws the straight lines to the middle of the circle, then fills the colors in, using
      cr.fill()*/
      startAngle += (this.pointsArray[i].x / total) * this.PIX;
      cr.line_to(this.pieChartXStart, this.pieChartYStart);
      cr.fill();

      //Draws the rectangles for the labels
      int yOffset = this.pieChartYLabelBStart + (this.pieChartYLabelBSpacing * i);
      cr.move_to(this.width - this.pieChartYLabelBStart, yOffset);
      cr.rectangle(
        this.width - this.pieChartYLabelBStart,
        yOffset,
        this.pieChartLabelBSize,
        this.pieChartLabelBSize
      );

      //fill the rectangles
      cr.fill();

      //set the color back to white for the text and write the amount next to the label
      cr.set_source_rgb(1, 1, 1);
      cr.move_to(this.width - this.pieChartLabelOffsetX, yOffset + this.pieChartLabelOffsetY);
      cr.show_text(snipLongDouble(this.pointsArray[i].x));

      /*Drawing operator that strokes the current path using the current settings that were
      implemented eariler in this file.*/
      cr.stroke();

    }

  }

  /**
  * Draws a scatter plot based on the pointsArray
  *
  * Uses the Cairo.Context to draw each points (as an arc) based on its scaled x & y values. After
  * the placement of the points, we have the option (based on scatterLabels) that if true will draw
  * the points x and y numbers with an comma for aesthetic. If (scatterLabels) false the x & y values
  * will now show as text (for larger data sets).
  *
  * @param type cr | Cairo.Context
  * @return return void
  */
  private void scatterChart(Cairo.Context cr){

    //Setting up values
    double maxX = 0, xAxisCalculation = 0, yAxisCalculation = 0;

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(this.lineThicknessData);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    //Find the max X value for the scaling calculations below
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray.get(i).x > maxX)
        maxX = this.pointsArray.get(i).x;

    //Looping through the points array
    for (int i = 0; i < this.pointsArray.size; i++){

      //Calculating both axis points for the point
      xAxisCalculation = this.pointsArray.get(i).x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 3);
      yAxisCalculation = (this.height + this.chartPadding) - ((this.spreadFinalY * ((this.pointsArray.get(i).y -
      this.min) / (this.max - this.min)) * this.spreadY));

      //Drawing point
      cr.arc(
        xAxisCalculation,
        yAxisCalculation,
        3,
        0,
        this.PIX
      );

      cr.fill();

      //If the developer wants to show labels, we continue
      if (scatterLabels){

        int yCount = 0, y = (int)this.pointsArray.get(i).y;

        /*Figuring out how many decimal places there are in each number so we know how much
        to offset the text to ensure the 'comma' is center on the dot.*/
        while(y > 0){

          y = y / 10;
          yCount++;

        }

        yCount++;

        int xCount = 0, x = (int)this.pointsArray.get(i).x;

        while(x > 0){

          x = x / 10;
          xCount++;

        }

        xCount++;

        //Creating literal spacing of the text needed.
        double spacingY = 3.8 * yCount;
        double spacingX = 3.8 * xCount;

        //moving to direct point to write text
        cr.move_to(
          xAxisCalculation - (spacingY + spacingX),
          yAxisCalculation - 5
        );

        //writing coordinates
        cr.show_text(
          snipLongDouble(this.pointsArray.get(i).x).concat(
          ",",snipLongDouble(this.pointsArray.get(i).y))
        );

      }

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
