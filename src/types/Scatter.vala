public class Scatter{

  public Scatter(Cairo.Context cr){

    drawScatterChart(cr);

  }

  public void drawScatterChart(Cairo.Context cr){

    //Setting up values
    double maxX = 0, xAxisCalculation = 0, yAxisCalculation = 0;

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(this.lineThicknessData);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    //Find the max X value for the scaling calculations below
    for (int i = 0; i < this.pointsArray.size; i++)
      if (this.pointsArray.get(i).x > maxX)
        maxX = this.pointsArray.get(i).x;

    //Looping through the points array
    for (int i = 0; i < this.pointsArray.size; i++){

      //Calculating both axis points for the point
      xAxisCalculation = this.pointsArray[i].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 3);
      yAxisCalculation = (this.height + this.chartPadding) - ((this.spreadFinalY * ((this.pointsArray.get(i).y -
      this.min) / (this.max - this.min)) * this.spreadY));

      //Drawing point
      cr.arc(
        xAxisCalculation,
        yAxisCalculation,
        3,
        0,
        this.PIX
      );

      cr.fill();

      //If the developer wants to show labels, we continue
      if (scatterLabels){

        int yCount = 0, y = (int)this.pointsArray.get(i).y;

        /*Figuring out how many decimal places there are in each number so we know how much
        to offset the text to ensure the 'comma' is center on the dot.*/
        while(y > 0){

          y = y / 10;
          yCount++;

        }

        yCount++;

        int xCount = 0, x = (int)this.pointsArray.get(i).x;

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
          xAxisCalculation - (spacingY + spacingX),
          yAxisCalculation - 5
        );

        //writing coordinates
        cr.show_text(
          snipLongDouble(this.pointsArray.get(i).x).concat(
          ",",snipLongDouble(this.pointsArray.get(i).y))
        );

      }

    }

    /*Drawing operator that strokes the current path using the current settings that were
    implemented eariler in this file.*/
    cr.stroke();

  }

}
