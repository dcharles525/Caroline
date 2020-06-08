public class LineSmooth{

  construct{}

  public LineSmooth(Cairo.Context cr){

    drawBarChart(cr);

  }

  public void drawLineSmoothChart(Cairo.Context cr){

    //Setting thickness of the line using set_line_width which can take any double.
    cr.set_line_width(this.lineThicknessData);

    //Set the color of the line (this default color is blue)
    cr.set_source_rgba(0, 174, 174,0.8);

    //Getting a scaler, which will help put the line in the right spot
    double scaler = ((this.pointsArray[0].y - this.min) / (this.max - this.min)) * this.spreadY;

    double maxX = 0;

    /*finding the max X value so we can calculate where to place the arcs for point indentification on the
    curved line*/
    for (int f = 0; f < this.pointsArray.size; f++)
      if (this.pointsArray[f].x > maxX)
        maxX = this.pointsArray[f].x;

    //We want to move the pointer on the canvas to where we want the line graph to start.
    cr.move_to(
      //x axis set to "0", as 15 is the buffer in the widget
      this.chartPadding + (this.widthPadding / 3),
      /*y axis using our scaler value multiplied by how many y axis values we have,
      then subtracted from the height*/
      (this.height + this.chartPadding) - ((this.spreadFinalY * scaler))
    );

    for (int i = 0; i < this.pointsArray.size - 1; i++){

      //Calculating the "before values", with bezier curves you need to think of this as your starting point
      double beforeX = this.pointsArray[i].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 3);
      double beforeY = this.pointsArray[i].y;

      //Getting a scaler, which will help put the line in the right spot
      scaler = ((beforeY - this.min) / (this.max - this.min)) * this.spreadY;
      beforeY = ((this.height + this.chartPadding) - ((this.spreadFinalY * scaler)));

      //Calculating the "current point" which is one ahead of before in the array of data.
      double currentX =  this.pointsArray[i+1].x * (this.width/maxX) + this.chartPadding + (this.widthPadding / 3);
      double currentY = ((i + 1) >= this.pointsArray.size) ? this.pointsArray[i].y : this.pointsArray[i+1].y;

      //Getting a scaler, which will help put the line in the right spot
      scaler = ((currentY - this.min) / (this.max - this.min)) * this.spreadY;
      currentY = ((this.height + this.chartPadding) - ((this.spreadFinalY * scaler)));

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
