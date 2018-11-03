using Gtk;
using Cairo;
using Gee;

public class CairoLine{

  public double[] DATA;
  public int width = 300;
  public double height = 200;
  public double lineThicknessTicks = 0.5;
  public double lineThicknessPlane = 1;
  public double lineThicknessData = 2;
  public double spreadY = 10;
  public string dataTypeY = "";
  public string dataTypeX = "";
  public ArrayList<string> labelList = new ArrayList<string>();
  public double gap;
  public double max;
  public double min;
  
  public CairoLine(){

  }

  public int getWidth(){
  
    return this.width;
  
  }

  public void setWidth(int width){
  
    this.width = width;

  } 

  public double getHeight(){
    
    return this.height;

  }

  public void setHeight(double height){

    this.height = height;

  } 

  public double getLineThicknessTicks(){
    
    return this.lineThicknessTicks;

  }

  public void setLineThicknessTicks(double lineThicknessTicks){
  
    this.lineThicknessTicks = lineThicknessTicks;

  }

  public double getLineThicknessPlane(){
    
    return this.lineThicknessPlane;

  }

  public void setLineThicknessPlane(double lineThicknessPlane){
    
    this.lineThicknessPlane = lineThicknessPlane;

  } 

  public double getLineThicknessData(){
  
    return this.lineThicknessData;

  }

  public void setLineThicknessData(double lineThicknessData){

    this.lineThicknessData = lineThicknessData;

  }

  public double getSpreadY(){
    
    return spreadY;

  }

  public void setSpreadY(double spreadY){

    this.spreadY = spreadY;

  }

  public string getDataTypeY(){
    
    return this.dataTypeY;

  }

  public void setDataTypeY(string dataTypeY){
    
    this.dataTypeY = dataTypeY;

  }

  public string getDataTypeX(){

    return this.dataTypeX;
  
  }

  public void setDataTypeX(string dataTypeX){
    
    this.dataTypeX = dataTypeX;

  }

  public void setData(double[] DATA){
    
    this.DATA = DATA;
  
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

    for (int i = 0; i < this.spreadY+1; i++){
      
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

  public DrawingArea createGraph () {

    var drawingArea = new DrawingArea ();
    drawingArea.draw.connect (onDraw);
    
    return drawingArea;

  }

  public delegate void DrawMethod ();

  public bool onDraw (Widget da, Context ctx) {
    
    //Line thickness for the plane (along with tolerance and color)
    ctx.set_line_width (this.lineThicknessPlane);
    ctx.set_tolerance (0.1);
    ctx.set_source_rgba (255, 255, 255,0.2);

    ctx.save ();
    ctx.new_path ();
    ctx.translate (1, 0);

    //draw plane
    drawPlane (ctx);

    //line thickness for ticks is set here
    ctx.set_line_width (this.lineThicknessTicks);

    //draw ticks
    drawTicksY (ctx);
    drawTicksX (ctx);

    ctx.stroke  ();
    ctx.restore ();
    
    //Line thickness for the data line (along with tolerance and color)
    ctx.set_line_width (this.lineThicknessData);
    ctx.set_tolerance (0.1);
    ctx.set_source_rgba (0, 174, 174,0.8);

    ctx.save ();
    ctx.new_path ();
    ctx.translate (1, 0);
    //drawing the line with the data
    drawLine (ctx);
    ctx.stroke ();
    ctx.restore();

    return true;

  }

  public void drawPlane (Context ctx) {

    ctx.move_to (15, 15);
    ctx.line_to (15, this.height+15);

    ctx.move_to (this.width+15, this.height+15);
    ctx.line_to (15, this.height+15);
    
  }

  public void drawTicksY(Context ctx){
    
    double spreadFinal = this.height/this.spreadY;

    for (int i = 0; i < this.spreadY+1; i++){

      ctx.move_to (-10, this.height+15-(spreadFinal*i));
      ctx.line_to (25, this.height+15-(spreadFinal*i));

      ctx.move_to (0, this.height+15-(spreadFinal*i));
      ctx.show_text(this.dataTypeY.concat(this.labelList.get(i)));

    }

  }

  public void drawTicksX(Context ctx){
  
    double spreadFinal = this.width/this.DATA.length;

    for (int i = 0; i < this.DATA.length+1; i++){
      
      ctx.move_to (15+spreadFinal*i, this.height+20);
      ctx.line_to (15+spreadFinal*i, this.height+5);

      ctx.move_to (11+spreadFinal*i, this.height+30);
      ctx.show_text(this.dataTypeX.concat(i.to_string()));

    }

  }

  public void drawLine(Context ctx){
    
    int spreadFinalX = this.width/this.DATA.length;
    double spreadFinalY = this.height/this.spreadY;

    double scaler = (this.DATA[0] - this.min) / (this.max - this.min);
    scaler = scaler * 10;
    double startingHeight = (this.height+15)-((spreadFinalY*scaler)-20);
    ctx.move_to (15,startingHeight);

    for (int i = 1; i < this.DATA.length; i++){

      scaler = (this.DATA[i] - this.min) / (this.max - this.min);
      scaler = scaler * this.spreadY;

      ctx.line_to ((15+spreadFinalX*(i+1)),((this.height+15)-((spreadFinalY*scaler)))+20);

    }

  }

}
