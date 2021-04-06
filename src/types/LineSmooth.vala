using Gee;

public class LineSmooth{

  /**
  * Draws a smooth line based on teh pointsArray
  *
  * Uses the Cario.Context to draw a smooth line using the curve_to function in the
  * Cairo library. Additionally we draw the points (similar to scatter plot) so we can
  * see the exact points on the curved line.
  *
  * @param Cairo.Context cr
  * @param ArrayList<Caroline.Point?> pointsArray
  * @param double baseline
  * @param ArrayList<ChartColor?> chartColorArray
  * @return void
  */
  public void drawLineSmoothChart (
    Cairo.Context cr, 
    ArrayList<Caroline.Point?> pointsArray, 
    double baseline,
    Caroline.ChartColor color
  ) {

    //We want to move the pointer on the canvas to where we want the line graph to start.
    cr.move_to(
      //x axis set to "0", as 15 is the buffer in the widget
      baseline,
      pointsArray[0].y
    );

    for (int i = 0; i < pointsArray.size - 1; i++){
     
      //Uses the chart color arrya with the structs within it to set the color
      cr.set_source_rgb(
        color.r,
        color.g,
        color.b
      );

      //Calculating the "before values", with bezier curves you need to think of this as your starting point
      double beforeX = pointsArray[i].x;
      double beforeY = pointsArray[i].y;

      //Calculating the "current point" which is one ahead of before in the array of data.
      double currentX =  pointsArray[i+1].x;
      double currentY = ((i + 1) >= pointsArray.size) ? pointsArray[i].y : pointsArray[i+1].y;

      //This will choose the "smoothness" of the line
      double force = (currentX - beforeX) / 2.0;

      //Draw the curved line
      cr.curve_to(
        beforeX + force,
        beforeY,
        currentX - force,
        currentY,
        currentX,
        currentY
      );

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

}
