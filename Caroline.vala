using Gtk;
using Cairo;
using Gee;

public class Caroline : Gtk.DrawingArea {

  private Pango.Layout layout;
  private bool drawLabel { get; set; }
  private double labelPositionX { get; set; }
  private double labelPositionY { get; set;}

  public double[] DATA { get; set; }
  public double[] HIGH { get; set; }
  public double[] LOW { get; set; }
  public int width { get; set; }
  public int height { get; set; }
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
    this.layout = create_pango_layout ("");
    this.drawLabel = false;
  }

  public Caroline(){

    add_events (Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.POINTER_MOTION_MASK);
    set_size_request (this.width, this.height);

  }

  public void calculations(){

    double[] tempDATA = this.DATA;
    tempDATA = arraySortInt(tempDATA);
    double label;

    double temp = tempDATA[tempDATA.length-1];
    this.max = temp + 1;
    temp = tempDATA[0];
    this.min = temp - 1;
    double difference = this.max - this.min;
    this.gap = difference / this.spreadY;
    label = this.min;

    if (label.to_string().length >= 8){

      this.labelList.add(label.to_string().slice (0, 8));

    }else{

      this.labelList.add(label.to_string());

    }

    for (int i = 1; i < this.spreadY+1; i++){

      label = label+gap;

      if (label.to_string().length >= 8){

        this.labelList.add(label.to_string().slice (0, 8));

      }else{

        this.labelList.add(label.to_string());

      }

    }

  }

  public double[] arraySortInt(double[] array){

    bool swapped = true;
    int j = 0;
    double tmp;

    while (swapped) {

      swapped = false;
      j++;

      for (int i = 0; i < array.length - j; i++) {

        if (array[i] > array[i + 1]) {
          tmp = array[i];
          array[i] = array[i + 1];
          array[i + 1] = tmp;
          swapped = true;
        }

      }

    }

    return array;

  }

  public override bool draw (Cairo.Context cr) {

    int width = get_allocated_width () - 50;
    int height = get_allocated_height () - 50;

    cr.set_line_width (this.lineThicknessTicks);
    cr.set_source_rgba (255, 255, 255,0.2);
    cr.move_to (15, 15);
    cr.line_to (15, height + 15);

    cr.move_to (width + 15, height + 15);
    cr.line_to (15, height + 15);
    cr.stroke ();

    cr.new_path ();
    cr.set_line_width (this.lineThicknessTicks);

    double spreadFinal = height/this.spreadY;

    for (int i = 0; i < this.spreadY + 1; i++){

      cr.move_to (-10, height+15-(spreadFinal*i));
      cr.line_to (25, height+15-(spreadFinal*i));

      cr.move_to (0, height+15-(spreadFinal*i));
      cr.show_text(this.dataTypeY.concat(this.labelYList.get(i)));

    };

    spreadFinal = width/this.DATA.length;

    for (int i = 1; i < this.DATA.length+1; i++){

      cr.move_to (15+spreadFinal*i, height+20);
      cr.line_to (15+spreadFinal*i, height+5);

      cr.move_to (11+spreadFinal*i, height+30);
      cr.show_text(this.labelXList.get(i));

    }

    cr.stroke ();
    cr.restore ();
    cr.save();

    if (this.chartType == "line"){

      double spreadFinalX = width/this.DATA.length;
      double spreadFinalY = height/this.spreadY;
      cr.set_line_width (this.lineThicknessData);
      cr.set_source_rgba (0, 174, 174,0.8);

      double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;
      double startingHeight = (height+15)-((spreadFinalY*scaler));
      cr.move_to (15,startingHeight);

      for (int i = 1; i < this.DATA.length; i++){

        scaler = (this.DATA[i] - this.min) / (this.max - this.min);
        scaler = scaler * this.spreadY;

        cr.line_to ((15+spreadFinalX*(i+1)),((height+15)-((spreadFinalY*scaler))));

      }

      cr.stroke ();

    }

    if (this.chartType == "bar"){

      double spreadFinalX = this.width/this.DATA.length;
      double spreadFinalY = this.height/this.spreadY;

      double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      for (int i = 0; i < this.DATA.length; i++){

        scaler = (this.DATA[i] - this.min) / (this.max - this.min);
        scaler = scaler * this.spreadY;

        ctx.rectangle ((17.5+spreadFinalX*(i+1))-7.5, this.height+15, 10, -((this.height)-((spreadFinalY*scaler))));

        ctx.stroke  ();

      }

    }

    return true;

  }

  public override void size_allocate (Gtk.Allocation allocation) {

    this.drawLabel = false;
    this.layout = create_pango_layout ("");
    base.size_allocate (allocation);

  }

}
