using Gee;

public class Scatter{

  double PIX = 6.28;

  /**
  * Draws a scatter plot based on the pointsArray
  *
  * Uses the Cairo.Context to draw each points (as an arc) based on its scaled x & y values. After
  * the placement of the points, we have the option (based on scatterLabels) that if true will draw
  * the points x and y numbers with an comma for aesthetic. If (scatterLabels) false the x & y values
  * will now show as text (for larger data sets).
  *
  * @param Cairo.Context cr
  * @param ArrayList<Caroline.Point?> pointsArrayCalculated
  * @param ArrayList<Caroline.Point?> pointsArray
  * @param double baseline
  * @return void
  */
  public void drawScatterChart(
    Cairo.Context cr,
    ArrayList<Caroline.Point?> pointsArrayCalculated,
    ArrayList<Caroline.Point?> pointsArray,
    bool scatterLabels,
    ArrayList<Caroline.ChartColor?> chartColorArray
  ){

    //Looping through the points array
    for (int i = 0; i < pointsArrayCalculated.size; i++){
      
      //Uses the chart color arrya with the structs within it to set the color
      cr.set_source_rgb(
        chartColorArray[i].r,
        chartColorArray[i].g,
        chartColorArray[i].b
      );

      //Drawing point
      cr.arc(
        pointsArrayCalculated[i].x,
        pointsArrayCalculated[i].y,
        3,
        0,
        this.PIX
      );

      cr.fill();

      //If the developer wants to show labels, we continue
      if (scatterLabels){

        int yCount = 0, y = (int)pointsArray[i].y;

        /*Figuring out how many decimal places there are in each number so we know how much
        to offset the text to ensure the 'comma' is center on the dot.*/
        while(y > 0){

          y = y / 10;
          yCount++;

        }

        yCount++;

        int xCount = 0, x = (int)pointsArray[i].x;

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
          pointsArrayCalculated[i].x - (spacingY + spacingX),
          pointsArrayCalculated[i].y - 5
        );

        //writing coordinates
        cr.show_text("%0.1f".printf(pointsArray[i].x).concat(",","%0.1f".printf(pointsArray[i].y)));

      }

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

}
