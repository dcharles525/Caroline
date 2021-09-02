using Gtk;
using Gee;
using Cairo;

public void main (string[] args) {

  //Setting up the GTK window
  Gtk.init (ref args);
  var window = new Gtk.Window ();
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size (500, 500);

  //Building grid to put the widget into
  Gtk.Grid mainGrid = new Gtk.Grid ();
  mainGrid.orientation = Gtk.Orientation.VERTICAL;

  GenericArray<double?> y = new GenericArray<double?> ();
  GenericArray<double?> y2 = new GenericArray<double?> ();
  GenericArray<double?> y3 = new GenericArray<double?> ();
  GenericArray<double?> y4 = new GenericArray<double?> ();
  GenericArray<double?> y5 = new GenericArray<double?> ();
  GenericArray<double?> x = new GenericArray<double?> ();
  ArrayList<Caroline.ChartColor?> chartColorArray = new ArrayList<Caroline.ChartColor?> ();

  y.add (1);
  y2.add (1);
  y3.add (1);
  y4.add (1);
  y5.add (1);

  for (int i = 0; i < 9; ++i) {

    y.add (Random.int_range (0, 100));
    y2.add (Random.int_range (0, 100));
    y3.add (Random.int_range (0, 100));
    y4.add (Random.int_range (0, 100));
    y5.add (Random.int_range (0, 100));

  }

  for (int i = 0; i < 10; ++i)
    x.add (i);
  
  Array<GenericArray<double?>> yArray = new Array<GenericArray<double?>> ();
  Array<string> cArray = new Array<string> ();

  yArray.append_val (y);
  yArray.append_val (y2);
  yArray.append_val (y3);
  yArray.append_val (y4);
  yArray.append_val (y5);
  
  cArray.append_val ("smooth-line");
  cArray.append_val ("line");
  cArray.append_val ("scatter");
  cArray.append_val ("bar");

  for (int i = 0; i < cArray.length; i++){

    //Create color struct
    Caroline.ChartColor chartColor = {
      Random.double_range(0,1),
      Random.double_range(0,1),
      Random.double_range(0,1)
    };

    chartColorArray.insert (i, chartColor);

  }

  //Simply set Caroline to a variable
  var carolineWidget = new Caroline.without_colors (
    x, //dataX
    yArray, //dataY
    cArray, //chart type,
    true, //yes or no for generateColors function (needed in the case of the pie chart),
    true,
    false // yes or no for scatter plot labels
  );

  //Add the Caroline widget tp the grid
  mainGrid.attach (carolineWidget, 0, 0, 1, 1);
  mainGrid.set_row_homogeneous (true);
  mainGrid.set_column_homogeneous (true);

  window.add (mainGrid);
  window.destroy.connect (Gtk.main_quit);
  window.show_all ();
 
  //This is how you'd update data!
  Timeout.add (5000, () => {

    GenericArray<double?> yy = new GenericArray<double?> ();
    
    for (int i = 0; i < 10; ++i) {

      yy.add (Random.int_range (0, 100));

    }

    carolineWidget.updateData (
      x, //keep x the same
      yy, //updated y data
      "smooth-line", //chart type
      true, //random color gen?
      true, //hue based color gen?
      0 //which index is the data in, this should be 1 if its the 2nd data set, 2 if its the 3rd, etc.
    );

    carolineWidget.queue_draw ();
    window.show_all ();

    return true;

  });

  Gtk.main ();

}
