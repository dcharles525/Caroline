using Gee;

public class Pie{

  double PIX = 6.28;

  /**
  * Draws a pie chart based on the pointsArray
  *
  * Uses the Cairo.Context to draw the pie chart by first, figuring out the radians for each piece
  * of data. You can see that we need to find the total of the set of data. Then we loop over it
  * creating the arc, lines, fill, and labels all in one swoop.
  *
  * @param Cairo.Context cr
  * @return return void
  */
  public void drawPieChart(
    Cairo.Context cr,
    ArrayList<Caroline.Point?> pointsArray,
    ArrayList<Caroline.ChartColor?> chartColorArray,
    int pieChartXStart,
    int pieChartYStart,
    int pieChartRadius ,
    int pieChartYLabelBStart,
    int pieChartYLabelBSpacing,
    int pieChartLabelOffsetX,
    int pieChartLabelOffsetY,
    int pieChartLabelBSize,
    double width
  ){

    double total = 0;
    double startAngle = 0;

    /*This for loop gets the total of all the data so we can scale the pie
    chart later on.*/
    for (int i = 0; i < pointsArray.size; i++)
      total += pointsArray[i].x;

    for (int i = 0; i < pointsArray.size; i++){

      //Uses the chart color arrya with the structs within it to set the color
      cr.set_source_rgb(
        chartColorArray[i].r,
        chartColorArray[i].g,
        chartColorArray[i].b
      );

      //Draws an arc based on the angle that is calculated.
      cr.arc (
        pieChartXStart,
        pieChartYStart,
        pieChartRadius,
        startAngle,
        startAngle + (pointsArray[i].x / total) * this.PIX
      );

      /*Adds angle to startAngle to keep track of where to draw the next arc and then the code
      draws the straight lines to the middle of the circle, then fills the colors in, using
      cr.fill()*/
      startAngle += (pointsArray[i].x / total) * this.PIX;
      cr.line_to(pieChartXStart, pieChartYStart);
      cr.fill();

      //Draws the rectangles for the labels
      int yOffset = pieChartYLabelBStart + (pieChartYLabelBSpacing * i);
      cr.move_to(width - pieChartYLabelBStart, yOffset);
      cr.rectangle(
        width - pieChartYLabelBStart,
        yOffset,
        pieChartLabelBSize,
        pieChartLabelBSize
      );

      //fill the rectangles
      cr.fill();

      //set the color back to white for the text and write the amount next to the label
      cr.set_source_rgb(1, 1, 1);
      cr.move_to(width - pieChartLabelOffsetX, yOffset + pieChartLabelOffsetY);
      cr.show_text("%0.1f".printf(pointsArray[i].x));

      /*Drawing operator that strokes the current path using the current settings that were
      implemented eariler in this file.*/
      cr.stroke();

    }

  }

}
