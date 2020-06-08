public class Pie{

  construct{}

  public Pie(Cairo.Context cr){

    drawPieChart(cr);

  }

  public void drawPieChart(Cairo.Context cr){


  double total = 0;
  double startAngle = 0;

  /*This for loop gets the total of all the data so we can scale the pie
  chart later on.*/
  for (int i = 0; i < this.pointsArray.size; i++)
    total += this.pointsArray[i].x;

  for (int i = 0; i < this.pointsArray.size; i++){

    //Uses the chart color arrya with the structs within it to set the color
    cr.set_source_rgb(
      this.chartColorArray[i].r,
      this.chartColorArray[i].g,
      this.chartColorArray[i].b
    );

    //Draws an arc based on the angle that is calculated.
    cr.arc (
      this.pieChartXStart,
      this.pieChartYStart,
      this.pieChartRadius,
      startAngle,
      startAngle + (this.pointsArray[i].x / total) * this.PIX
    );

    /*Adds angle to startAngle to keep track of where to draw the next arc and then the code
    draws the straight lines to the middle of the circle, then fills the colors in, using
    cr.fill()*/
    startAngle += (this.pointsArray[i].x / total) * this.PIX;
    cr.line_to(this.pieChartXStart, this.pieChartYStart);
    cr.fill();

    //Draws the rectangles for the labels
    int yOffset = this.pieChartYLabelBStart + (this.pieChartYLabelBSpacing * i);
    cr.move_to(this.width - this.pieChartYLabelBStart, yOffset);
    cr.rectangle(
      this.width - this.pieChartYLabelBStart,
      yOffset,
      this.pieChartLabelBSize,
      this.pieChartLabelBSize
    );

    //fill the rectangles
    cr.fill();

    //set the color back to white for the text and write the amount next to the label
    cr.set_source_rgb(1, 1, 1);
    cr.move_to(this.width - this.pieChartLabelOffsetX, yOffset + this.pieChartLabelOffsetY);
    cr.show_text(snipLongDouble(this.pointsArray[i].x));

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

}
