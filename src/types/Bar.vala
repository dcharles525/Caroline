using Gee;

public class Bar{

  private double rectangleXOffset { get; set; }

  /**
  * Draws a set of rectangles based on the pointsArray
  *
  * Uses the Cairo.Context to draw a set of rectanges that will be positioned in a bar
  * chart format. The most important function used is rectangle, which allows us to quickly
  * form objects without having to use line_to.
  *
  * @param Cairo.Context cr
  * @param ArrayList<Caroline.Point?> pointsArray
  * @param double baseline
  * @return void
  */
  public void drawBarChart (
    Cairo.Context cr, 
    ArrayList<Caroline.Point?> pointsArray, 
    double baseline,
    Caroline.ChartColor color
  ) {

    this.rectangleXOffset = 10;
    
    cr.set_source_rgb(
      color.r,
      color.g,
      color.b
    );

    for (int i = 0; i < pointsArray.size; i++){
     
      cr.rectangle(
        pointsArray[i].x,
        baseline,
        this.rectangleXOffset,
        pointsArray[i].y
      );

      cr.fill();

    }

  }

}
