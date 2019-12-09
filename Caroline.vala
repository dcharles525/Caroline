//============================================================+
// File name   : Caroline.vala
// Last Update : 2019-12-05
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
  * Items that are used internally and are not exposed to the developer
  *
  */

  /*A Pango.Layout is used to store the font map, font description, and base direction
  for drawing text for the widget. We can use this to display text items on our chart.
  For more info on this start here: https://valadoc.org/gtk+-3.0/Gtk.Widget.create_pango_layout.html*/
  private Pango.Layout layout;

  //Guard
  private bool drawLabel { get; set; }
  private double labelPositionX { get; set; }
  private double labelPositionY { get; set;}

  public double[] DATA { get; set; }
  public double[] HIGH { get; set; }
  public double[] LOW { get; set; }

  public int width { get; set; }
  public int height { get; set; }
  public int widthPadding { get; set; }
  public int heightPadding { get; set; }

  public double lineThicknessTicks { get; set; }
  public double lineThicknessPlane { get; set; }
  public double lineThicknessData { get; set; }

  public double spreadY { get; set; }
  public string dataTypeY{ get; set; }
  public string dataTypeX { get; set; }

  public ArrayList<string> labelYList = new ArrayList<string>();
  public ArrayList<string> labelXList = new ArrayList<string>();

  public double gap { get; set; }
  public double max { get; set; }
  public double min { get; set; }

  public string chartType;
  public Context ctx;
  public DrawingArea drawingArea = new DrawingArea();

  construct{

    //Initializes the text layout widget
    this.layout = create_pango_layout ("");
    this.drawLabel = false;

    //Initializing default values
    this.widthPadding = 50;
    this.heightPadding = 50;

  }

  public Caroline(){

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
  public void calculations(){

    /*This next sector of arithmetic is to find the max value of the data array*/
    this.max = this.DATA[0];

    //Loop and compare each value to our initial value to see if it becomes the max
    for (int i = 0; i < this.DATA.length; i++)
      if (this.DATA[i] > this.max)
        this.max = this.DATA[i];

    stdout.printf("MAX: %f\n",this.max);

    /*This next sector of arithmetic is to find the min value of the data array*/
    this.min = 0;

    //Loop and compare each value to our initial value to see if it becomes the min
    for (int i = 0; i < this.DATA.length; i++)
      if (this.DATA[i] < this.min)
        this.min = this.DATA[i];

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
  * Draws the
  *
  * Undocumented function long description
  *
  * @param type var Description
  * @return return type
  */
  public override bool draw (Cairo.Context cr) {

    /*Here we are grabbing the width and height assocaited with 'this'.
    We then subtract a settable padding around the entirety of the widget. We can also
    observe that 'this' should have the width and height we requested in the set_size_request
    function.*/
    int width = get_allocated_width() - this.widthPadding;
    int height = get_allocated_height() - this.heightPadding;

    //As the function illudes too, this sets the width of the lines for the x & y ticks.
    cr.set_line_width(this.lineThicknessTicks);

    //As the function illudes too, this sets the color of the lines.
    cr.set_source_rgba(255, 255, 255, 0.2);

    cr.move_to(15, 15);
    cr.line_to(15, height + 15);

    cr.move_to(width + 15, height + 15);
    cr.line_to(15, height + 15);

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

    //Reset the path so when we execute move_to again we are starting from 0,0 on the cario canvas
    cr.new_path();
    cr.set_line_width(this.lineThicknessTicks);

    //Figure out the spread of each of the y coordinates.
    double spreadFinalY = height/this.spreadY;

    /*We loop through all of the y labels and actually draw thes lines and add the actual text for
    each tick mark.*/
    for (int i = 0; i < this.spreadY + 1; i++){

      //line drawing
      cr.move_to(-10, height + 15 - (spreadFinalY*i));
      cr.line_to(25, height + 15 - (spreadFinalY*i));

      //moves the current drawing area so the text will display properly
      cr.move_to(0, height+15-(spreadFinalY*i));
      cr.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

    };

    /*Figure out the spread of each of the x coordinates, notice this is differnt from the y
    plane, we want to display each data point on the x axis here.*/
    double spreadFinalX = width/this.DATA.length;

    /*We loop through all of the x labels and actually draw thes lines and add the actual text for
    each tick mark.*/
    for (int i = 1; i < this.DATA.length+1; i++){

      //line drawing
      cr.move_to(15 + spreadFinalX * i, height + 20);
      cr.line_to(15 + spreadFinalX * i, height + 5);

      //moves the current drawing area back and lists the x axis value below the x tick
      cr.move_to(11 + spreadFinalX * i, height + 30);
      cr.show_text(this.labelXList.get(i));

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

    /*Sets the drawing area and its attributes back to their defaults, which are set on
    previous save() or the initial value*/
    cr.restore();

    //Saves the drawing area context and the attributes set before this save
    cr.save();

    /*The next two sectors of code are for either line or bar charts. The developer can
    decide which chart they want. Eventually more chart types will be added...*/

    //Code for line charts
    if (this.chartType == "line"){

      lineChart(cr);

    }else if(this.chartType == "bar"){

      barChart(cr);

    }else{

      lineChart(cr);

    }

    return true;

  }

  public void lineChart(Cairo.Context cr){

    cr.set_line_width(this.lineThicknessData);
    cr.set_source_rgba(0, 174, 174,0.8);

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * this.spreadY;

    double startingHeight = (height+15)-((spreadFinalY*scaler));
    cr.move_to(15,startingHeight);

    for (int i = 1; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      cr.line_to((15+spreadFinalX*(i+1)),((height+15)-((spreadFinalY*scaler))));

    }

    cr.stroke();

  }

  public void barChart(Cairo.Context cr){

    cr.set_source_rgba(0, 174, 174,0.8);

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * this.spreadY;

    for (int i = 0; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      cr.rectangle(
        (17.5 + spreadFinalX * (i + 1)) - 7.5,
        height+15,
        10,
        -(((spreadFinalY * scaler)))
      );

    }

    cr.stroke();

  }

  public override void size_allocate (Gtk.Allocation allocation) {

    this.drawLabel = false;
    this.layout = create_pango_layout("");
    base.size_allocate(allocation);

  }

}
