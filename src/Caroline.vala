//============================================================+
// File name   : Caroline.vala
// Last Update : 2021-4-16
//
// Version: 0.3.0
//
// Description : This is an extension of a GTK Drawing Area. Its purpose is to make it easy for any level
// of developer to use charts in their application. More in depth documentation is found in below and in the
// README, if you have any critiques or questions, go ahead and open an issue in this repo.
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

  private ArrayList<string> labelYList = new ArrayList<string>();

  private int replaceIndex { get; set; }

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
  public Array<string> chartTypes { get; set; }

  public double gap { get; set; }
  public double max { get; set; }
  public double min { get; set; }
  
  public double gapPoint { get; set; }
  public double maxPoint { get; set; }
  public double minPoint { get; set; }

  public int chartPadding { get; set; }

  public double lineThicknessTicks { get; set; }
  public double lineThicknessPlane { get; set; }
  public double lineThicknessData { get; set; }
  public double spreadY { get; set; }
  public double spreadX { get; set; }

  public string dataTypeY { get; set; }
  public string dataTypeX { get; set; }

  public ArrayList<double?> labelXList = new ArrayList<double?>();

  public int pieChartXStart { get; set; }
  public int pieChartYStart { get; set; }
  public int pieChartRadius { get; set; }
  public int pieChartYLabelBStart { get; set; }
  public int pieChartYLabelBSpacing { get; set; }
  public int pieChartLabelBSize { get; set; }
  public int pieChartLabelOffsetX { get; set; }
  public int pieChartLabelOffsetY { get; set; }

  public ArrayList<ChartColor?> chartColorArray = new ArrayList<ChartColor?> ();
  public ArrayList<ArrayList<Point?>> pointsArray = new ArrayList<ArrayList<Point?>> ();
  public ArrayList<ArrayList<Point?>> pointsCalculatedArray = new ArrayList<ArrayList<Point?>> ();

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
    this.spreadY = 4;
    this.lineThicknessTicks = 0.5;
    this.lineThicknessData = 1;
    this.lineThicknessTicks = 2;
    this.dataTypeY = "";
    this.dataTypeX = "";
    this.gap = 0;
    this.minPoint = 0;
    this.maxPoint = 0;

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
  * dataX - x axis data for the charts
  * dataY - y axis data for the charts - note we can have multiple sets of y data
  * chartType - this can either be line, bar, or pie
  * generateColors - array for ChartColor structs
  * scatterPlotLabels - show labels on the scatter plot
  */
  public Caroline (
    GenericArray<double?> dataX, 
    Array<GenericArray<double?>> dataY, 
    Array<string> chartTypes, 
    ArrayList<ChartColor?> chartColorArray,
    bool generateColorsRandom,
    bool generateColorsHue,
    bool scatterPlotLabels
  ) {

    /*Since our widget will already be "realized" we want to use add_events, this
    function allows us to set the window event bit flags, which I document directly below.
    For more info on this start here: https://valadoc.org/gtk+-3.0/Gtk.Widget.add_events.html*/
    add_events (
      /*Gdk.EventMast are a set of bit flags used to decide which events a window is to recieve.
      In our case we want to be able to track press, release, and motion. Eventually as this
      "library" grows we will take advantage of all of these.*/
      Gdk.EventMask.BUTTON_PRESS_MASK |
      Gdk.EventMask.BUTTON_RELEASE_MASK |
      Gdk.EventMask.POINTER_MOTION_MASK |
      Gdk.EventMask.POINTER_MOTION_MASK |
      Gdk.EventMask.LEAVE_NOTIFY_MASK |
      Gdk.EventMask.BUTTON_PRESS_MASK |
      Gdk.EventMask.BUTTON_RELEASE_MASK
    );

    /*We want to allow the developer to set a minimum size of the widget so their parent
    application knows approx what the size will be.
    For more info on this start here: https://valadoc.org/gtk+-3.0/Gtk.Widget.set_size_request.html*/
    set_size_request (
      this.width,
      this.height
    );

    //Boolean for auto generated scatter labels
    this.scatterLabels = scatterPlotLabels;
    this.chartTypes = chartTypes;
    this.chartColorArray = chartColorArray;

    //Clearing out points array for the next draw
    this.pointsArray.clear ();

    for (int i = 0; i < chartTypes.length; i++)
      this.updateData (dataX, dataY.index (i), chartTypes.index (i), generateColorsRandom, generateColorsHue, -1);

  }

  public Caroline.with_colors (
    GenericArray<double?> dataX, 
    Array<GenericArray<double?>> dataY, 
    Array<string> chartTypes, 
    ArrayList<ChartColor?> chartColorArray,
    bool generateColorsRandom,
    bool generateColorsHue,
    bool scatterPlotLabels
  ) {

    this (dataX, dataY, chartTypes, chartColorArray, generateColorsRandom, generateColorsHue, scatterPlotLabels);

  }
  
  public Caroline.without_colors (
    GenericArray<double?> dataX, 
    Array<GenericArray<double?>> dataY, 
    Array<string> chartTypes, 
    bool generateColorsRandom,
    bool generateColorsHue,
    bool scatterPlotLabels
  ) {

    this (
      dataX, 
      dataY, 
      chartTypes, 
      new ArrayList<ChartColor?> (), 
      generateColorsRandom, 
      generateColorsHue, 
      scatterPlotLabels
    );

  }

  /**
  * Draws the tick marks and calls sub chart type functions
  *
  * Within draw we do several things, first we confirm our height/width. Then we move our
  * pointer on the canvas and draw the x & y axis. After we draw all the ticks on each axis.
  * Lastly we point to the proper chart type function which will draw the chart itself.
  *
  * @param Cairo.Context cr
  * @return boolean
  */
  public override bool draw (Cairo.Context cr) {

    this.calculations ();

    /*Here we are grabbing the width and height assocaited with 'this'.
    We then subtract a settable padding around the entirety of the widget. We can also
    observe that 'this' should have the width and height we requested in the set_size_request
    function.*/
    this.width = get_allocated_width () - this.widthPadding;
    this.height = get_allocated_height () - this.heightPadding;

    if (this.replaceIndex == -1)
      this.pointsCalculatedArray.clear ();
    
    if (this.chartTypes.index (0) != "pie"){

      //As the function illudes too, this sets the width of the lines for the x & y ticks.
      cr.set_line_width (this.lineThicknessTicks);

      //setting the color of the lines.
      cr.set_source_rgba (255, 255, 255, 0.2);
      this.drawOutline (cr);
      this.drawYTicks (cr);
      this.drawXTicks (cr);

      /*Sets the drawing area and its attributes back to their defaults, which are set on
      previous save() or the initial value*/
      cr.restore ();

      //Saves the drawing area context and the attributes set before this save
      cr.save ();

    }

    //Looping over our multiple data sets
    for (int i = 0; i < this.chartTypes.length; i++) {

      string chartType = chartTypes.index (i);
      
      //Setting thickness of the line using set_line_width which can take any double.
      cr.set_line_width(1);

      //Set the color of the line (this default color is blue)
      cr.set_source_rgba(0, 174, 174,0.8);

      if (this.replaceIndex == -1) {

        bool barOrNot = (chartType != "bar") ? false : true;
        this.pointCalculations (barOrNot, i, this.replaceIndex);

      }

      /*This switch-case will execute the proper chart depending on what the
      developer has choosen.*/
      switch (chartType) {
        case "line":
          Line line = new Line ();
          line.drawLineChart (
            cr, 
            this.pointsCalculatedArray[i], 
            this.chartPadding + (this.widthPadding / 3),
            this.chartColorArray[i]
          );
          break;
        case "smooth-line":
          if (this.pointsCalculatedArray[i].size == 1) {

            Scatter scatter = new Scatter ();
            scatter.drawScatterChart (
              cr, 
              this.pointsCalculatedArray[i], 
              this.pointsArray[i],
              this.scatterLabels,
              this.chartColorArray[i]
            );

          } else {
          
            LineSmooth lineSmooth = new LineSmooth ();
            lineSmooth.drawLineSmoothChart (
              cr, 
              this.pointsCalculatedArray[i], 
              this.chartPadding + (this.widthPadding / 3),
              this.chartColorArray[i]
            );
          
          }
          break;
        case "bar":
          Bar bar = new Bar ();
          bar.drawBarChart (
            cr, 
            this.pointsCalculatedArray[i], 
            this.height + this.chartPadding,
            this.chartColorArray[i]
          );
          break;
        case "pie":
          Pie pie = new Pie ();
          pie.drawPieChart (
            cr,
            this.pointsArray[i],
            this.chartColorArray[i],
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
          Scatter scatter = new Scatter ();
          scatter.drawScatterChart (
            cr, 
            this.pointsCalculatedArray[i], 
            this.pointsArray[i], 
            this.scatterLabels,
            this.chartColorArray[i]
          );
          break;
        default:
          LineSmooth lineSmooth = new LineSmooth ();
          lineSmooth.drawLineSmoothChart (
            cr, 
            this.pointsCalculatedArray[i], 
            this.chartPadding + (this.widthPadding / 3),
            this.chartColorArray[i]
          );
          break;
      }


    }

    return true;

  }

  /**
  * Finds the correct positioning for the x & y labels.
  *
  * Below we first attempt to find the max and min values of the data array. After that we use those values to
  * calculate the gap between each of the labels. This gap value will also be used elsewhere for the chart lines.
  * Finally we dynamically write the y labels to our list to be used in the drawing stage, this allows us to
  * not have to manually input values for the y axis.
  *
  * @param none
  * @return void
  */
  private void calculations () {

    for (int i = 0; i < this.pointsArray.size; i++) {

      /*This next sector of arithmetic is to find the max value of the data array*/
      if (this.maxPoint == 0)
        this.maxPoint = this.pointsArray[i][0].y;
      

      //Loop and compare each value to our initial value to see if it becomes the max
      for (int f = 0; f < this.pointsArray[i].size; f++)
        if (this.pointsArray[i][f].y > this.maxPoint)
          this.maxPoint = this.pointsArray[i][f].y;

      //Loop and compare each scatterArray to our initial value to see if it becomes the min
      for (int f = 0; f < this.pointsArray[i].size; f++)
        if (this.pointsArray[i][f].y < this.minPoint)
          this.minPoint = this.pointsArray[i][f].y;

      /*Finds the gap between each y axis label to be displayed. spreadY is set on the
      developers side, it is meant to tell Caroline how many y axis ticks needed.*/
      this.gap = (this.maxPoint - this.minPoint) / this.spreadY;

      //Initial y axis value
      double yLabel = this.minPoint;

      for (int f = 0; f < this.spreadY + 1; f++){

        if (f > 0)
          yLabel = yLabel + gap;

        //Depending on double length we clean it up a bit for display if its over 8 digits
        if (yLabel.to_string ().length >= 8)
          this.labelYList.add (yLabel.to_string ().slice (0, 8));
        else
          this.labelYList.add (yLabel.to_string ());

      }

    }

  }

  /**
  * Calculate Absolute Points
  *
  * Takes a boolean to check which types of calculations to run (bar chart or any other) then stores the points within
  * a point and then into an array of calculated points. We also take the current index of the y data as this is called
  * from a loop. 
  *
  * @param bool barOrNot
  * @param int index
  * @return void
  */
  private void pointCalculations (bool barOrNot, int index, int replaceIndex) {

    double maxX = 0;
    double divisor = 0;
    double y = 0;
    ArrayList<Point?> points = new ArrayList<Point?> ();

    for (int i = 0; i < this.pointsArray[index].size; i++)
      if (this.pointsArray[index][i].x > maxX)
        maxX = this.pointsArray[index][i].x;

    for (int i = 0; i < this.pointsArray[index].size; i++) {

      double scaler = ((this.pointsArray[index][i].y - this.minPoint) / (this.maxPoint - this.minPoint)) * this.spreadY;

      if (!barOrNot)
        divisor = 3;
      else
        divisor = 4.35;
     
      double x = 0;

      if (maxX > 0)
        x = this.pointsArray[index][i].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / divisor);
      else 
        x = this.chartPadding + (this.widthPadding / divisor);

      if (!barOrNot)
        y = (this.height + this.chartPadding) - ((this.spreadFinalY * scaler));
      else
        y = -(this.spreadFinalY * scaler);

      Caroline.Point point = {x, y};
      points.add (point);

    }
    
    if (this.replaceIndex == -1)
      this.pointsCalculatedArray.add (points);
    else 
      this.pointsCalculatedArray[replaceIndex] = points;

  }

  /**
  * Draw Chart Outline
  *
  * Draws the x and y axis lines that frame the chart using just move_to and line_to. This function is run in the
  * draw function.
  *
  * @param Cairo.Context cr
  * @return void
  */
  private void drawOutline (Cairo.Context cr){

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

  /**
  * Draw Y Axis Ticks
  *
  * Draws y axis ticks on the y axis line by using the spreadFinalY spacing between each tick then it shows the
  * value of the y axis above the tick using show_text, move_to, and line_to.
  *
  * @param Cairo.Context cr
  * @return void
  */
  private void drawYTicks (Cairo.Context cr){

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

  /**
  * Draw X Axis Ticks
  *
  * Draws x axis ticks on the x axis line by using the spreadFinalX spacing between each tick then it shows the
  * value of the x axis above the tick using show_text, move_to, and line_to.
  *
  * @param Cairo.Context cr
  * @return void
  */
  private void drawXTicks(Cairo.Context cr){

    /*Figure out the spread of each of the x coordinates, notice this is differnt from the y
    plane, we want to display each data point on the x axis here.*/
    this.spreadFinalX = this.width/(this.spreadX-1);

    /*We loop through all of the x labels and actually draw thes lines and add the actual text for
    each tick mark.*/
    for (int i = 0; i < this.spreadX; i++){

      double rawXCalculation = this.spreadFinalX * i;
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

      var roundedX = "%0.1f".printf(this.labelXList.get(i));
      cr.show_text(roundedX);

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

  /**
  * Generates colors based off of hue
  *
  * If we want to ensure that the colors will be different enough to see close to each other we will just shift the hue
  * slightly each interation for each type of chart. This function shouldn't be used for more than ~30 chart types since
  * the hues will become to close together.
  *
  * @return void
  */
  private void generateColorsHue () {

    double oneThird = 1f / 3f;;
    double hueSpacing = 1000 / this.chartTypes.length;

    for (int i = 0; i < this.chartTypes.length; i++) {
      
      double hue = ((i + 1) * hueSpacing) / 1000;
      double saturation = Random.double_range (0.5, 1);
      double lightness = Random.double_range (0, 0.40);

      /*converting hsl to rgb, most of this isn't original, checkout this gist for some smart cookie who figured
      this out. https://gist.github.com/matzipan/d0199db1706426a8f4436d707b3288fd */
      var q = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation;
      var p = 2 * lightness - q;
    
      ChartColor chartColor = {
        (this.hueRgb (p, q, hue + (oneThird)) * 255f) / 100f,
        (this.hueRgb (p, q, hue) * 255f) / 100f,
        (this.hueRgb (p, q, hue - (oneThird)) * 255f) / 100f
      };
     
      this.chartColorArray.insert (i, chartColor);

    }

  }

  /**
  * Convert from hls to rgb
  *
  * This function is a utility for generateColorsHue which converts hsl to rgb by using some division logic.
  *
  * @param double p
  * @param double q
  * @param double t
  *
  * @return double
  */
  private double hueRgb (double p, double q, double t) {
    
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1f / 6f) return p + (q - p) * 6f * t;
    if (t < 1f / 2f) return q;
    if (t < 2f / 3f) return p + (q - p) * (2f / 3f - t) * 6f;

    return p;
  
  }

  /**
  * Generates truly random numbers
  *
  * Simply loops over the length of the chartTypes array and generates a number from 0 to 1.
  *
  * @return void
  */
  private void generateColorsRandom () {
 
    for (int i = 0; i < this.chartTypes.length; i++){

      //Create color struct
      ChartColor chartColor = {
        Random.double_range(0,1),
        Random.double_range(0,1),
        Random.double_range(0,1)
      };

      this.chartColorArray.insert (i, chartColor);

    }

  }

  /**
  * Takes update data and refreshes caroline
  *
  * Takes x, y, and generate colors data and recalculates with the new data. Then the labels are reloaded since some of
  * the data ranges may change. 
  *
  * @param GenericArray<double?> dataX
  * @param GenericArray<double?>  dataY
  * @param string chartType
  * @param bool generateColors
  *
  * @return void
  */
  public void updateData (
    GenericArray<double?> dataX, 
    GenericArray<double?> dataY, 
    string chartType, 
    bool generateColorsRandom,
    bool generateColorsHue,
    int replaceIndex
  ) {

    this.replaceIndex = replaceIndex;
    this.labelXList.clear ();
    this.labelYList.clear ();

    ArrayList<Point?> points = new ArrayList<Point?> ();
    
    //Creating array of points structs 
    for (int i = 0; i < dataX.length; i++) {

      Caroline.Point point = {dataX[i], dataY[i]};
      points.add (point);

    }

    if (replaceIndex == -1)
      this.pointsArray.add (points);
    else
      this.pointsArray[replaceIndex] = points;
    
    if (replaceIndex != -1) {

      bool barOrNot = (chartType != "bar") ? false : true;
      this.pointCalculations (barOrNot, replaceIndex, replaceIndex);

    }

    this.labelXList.add (0);

    if (dataX.length < 15) {

      this.spreadX = dataX.length;
      this.spreadY = dataY.length;

    }
    
    //If we don't have a pie chart we sort, if we do we don't since we don't want to waste cpu cycles on it
    if (chartType != "pie")
      this.arrayListSort ();

    if (this.chartColorArray.size < 1) {

      if (generateColorsRandom)
        this.generateColorsRandom ();

      if (generateColorsHue && !generateColorsRandom)
        this.generateColorsHue ();

    }

    double tick = this.pointsArray[this.pointsArray.size-1][dataY.length-1].x / spreadX;

    for (double f = 0; f < this.spreadX; f++){
      if (f == 0)
        this.labelXList.add (tick + (tick * f));
      else
        this.labelXList.add ( (tick + (tick * f)) + (tick));
    }

  }

  /**
  * Sort an array list
  *
  * Within this function we sort the array list by the x axis. Why? Well we need to know in what order to create
  * bar and line charts. However in pie charts, we don't need to know the order, hence we exlude this
  * sorting since its the main performance bottle neck within the system.
  *
  * @return void
  */
  private void arrayListSort () {

    bool swapped = true;
    int j = 0;
    double tmpX,tmpY;
    Caroline.Point point = {0,0};
    int arrayListSize = this.pointsArray.size - 1;

    while (swapped) {

      swapped = false;
      j++;

      for (int i = 0; i < this.pointsArray[arrayListSize].size - j; i++) {

        /*if current x is bigger than the next x, we move it a position forward, along with its y counter
        part (y coordinate).*/
        if (this.pointsArray[arrayListSize][i].x > this.pointsArray[arrayListSize][i+1].x) {

          tmpX = this.pointsArray[arrayListSize][i].x;
          tmpY = this.pointsArray[arrayListSize][i].y;

          point = {this.pointsArray[arrayListSize][i+1].x, this.pointsArray[arrayListSize][i+1].y};
          this.pointsArray[arrayListSize].set(i,point);

          point = {tmpX,tmpY};
          this.pointsArray[arrayListSize].set(i+1,point);

          swapped = true;

        }

      }

    }

  }

}
