using Gee;

public class Bar{

  private double rectangleXOffset { get; set; }

  public void drawBarChart(Cairo.Context cr, ArrayList<Caroline.Point?> pointsArray, double baseline ){

    this.rectangleXOffset = 10;

    for (int i = 0; i < pointsArray.size; i++){

      cr.rectangle(
        pointsArray[i].x,
        baseline,
        this.rectangleXOffset,
        pointsArray[i].y
      );

      //Fills the rectangle with the current color
      cr.set_source_rgba(0, 174, 174, 0.2);

      cr.fill();

    }

  }

}
