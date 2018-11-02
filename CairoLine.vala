using Gtk;
using Cairo;

public class CairoLine{

  int[] DATA = {1,2,3,4,5,6,7,8,9,10,4,3,2,7,8,3,6,4,5,6,1,2,3,4};
  int width = 300;
  int height = 200;
  double lineThicknessTicks = 0.5;
  double lineThicknessPlane = 1;
  double lineThicknessData = 2;
  int spreadY = 10;
  string dataTypeY = "";
  string dataTypeX = "";
  
  public CairoLine(){

  }

  public int getWidth(){
  
    return this.width;
  
  }

  public void setWidth(int width){
  
    this.width = width;

  } 

  public int getHeight(){
    
    return this.height;

  }

  public void setHeight(int height){

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

  public int getSpreadY(){
    
    return spreadY;

  }

  public void setSpreadY(int spreadY){

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

  public void setData(int[] DATA){

    this.DATA = DATA;

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
    
    int spreadFinal = this.height/this.spreadY;

    for (int i = 0; i < this.spreadY+1; i++){
  
      ctx.move_to (-10, this.height+15-(spreadFinal*i));
      ctx.line_to (25, this.height+15-(spreadFinal*i));

      ctx.move_to (0, this.height+15-(20*i));
      ctx.show_text(this.dataTypeY.concat(i.to_string()));

    }

  }

  public void drawTicksX(Context ctx){
    
    int spreadFinal = this.width/this.DATA.length;

    for (int i = 0; i < this.DATA.length+1; i++){
  
      ctx.move_to (15+spreadFinal*i, this.height+20);
      ctx.line_to (15+spreadFinal*i, this.height+5);

      ctx.move_to (11+spreadFinal*i, this.height+30);
      ctx.show_text(this.dataTypeX.concat(i.to_string()));

    }

  }

  public void drawLine(Context ctx){
    
    int spreadFinalX = this.width/this.DATA.length;
    int spreadFinalY = this.height/this.spreadY;
    ctx.move_to (15,this.height+15);

    for (int i = 0; i < this.DATA.length; i++){
  
      ctx.line_to ((15+spreadFinalX*(i+1)),this.height+15-(spreadFinalY*(this.DATA[i])));

    }

  }

}
