using Gee;

public class Line{

  /**
  * Draws a line based on the pointsArray
  *
  * Uses the Cairo.Context to draw the line chart via the .move_to function
  * which allows you to move the current point to the necessary area and
  * line_to() which goes from one point to another while leaving a line behind.
  *
  * @param Cairo.Context cr
  * @param ArrayList<Caroline.Point?> pointsArray
  * @param double baseline
  * @return void
  */
  public void drawLineChart (
    Cairo.Context cr, 
    ArrayList<Caroline.Point?> pointsArray, 
    double baseline,
    Caroline.ChartColor color
  ) {

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(1);

    //We want to move the pointer on the canvas to where we want the line graph to start.
    cr.move_to(
      //x axis set to "0", as 15 is the buffer in the widget
      baseline,
      pointsArray[0].y
    );
    
    cr.set_source_rgb(
      color.r,
      color.g,
      color.b
    );

    for (int i = 0; i < pointsArray.size; i++){

      /*line_to (https://valadoc.org/cairo/Cairo.Context.line_to.html) is a simple
      cario function that allows us to draw a line from the previous canvas pointer.*/
      cr.line_to(
        /*axis, similar to move_to above, we just move the the line to the
        next x axis tick.*/
        pointsArray[i].x,
        /*y axis using our scaler value multiplied by how many y axis values we have,
        then subtracted from the height*/
        pointsArray[i].y
      );

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();


  }

}
