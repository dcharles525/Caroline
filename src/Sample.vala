using Gtk;
using Gee;
using Cairo;

/*
* 197ms - UI Lag (1,000,000)
* 40ms - Minimal Lag (100,000)
* 25ms - Minimal Lag (10,000)
* 24ms - Minimal Lag (1000)
* 24ms - Minimal Lag (100)
* 24ms - Minimal Lag (10)
*
*/

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
  GenericArray<double?> x = new GenericArray<double?> ();

  y.add (0);

  for (int i = 0; i < 9; ++i)
    y.add (Random.int_range (0, 100));

  for (int i = 0; i < 10; ++i)
    x.add (i);

  Array<GenericArray<double?>> xArray = new Array<GenericArray<double?>> ();
  Array<GenericArray<double?>> yArray = new Array<GenericArray<double?>> ();
  Array<string> sArray = new Array<string> ();

  xArray.append_val (x);
  xArray.append_val (x);

  yArray.append_val (y);
  yArray.append_val (y);

  sArray.append_val ("scatter");
  sArray.append_val ("smooth-line");

  //Simply set Caroline to a variable
  var carolineWidget = new Caroline (
    xArray, //dataX
    yArray, //dataY
    sArray, //chart type
    true, //yes or no for generateColors function (needed in the case of the pie chart),
    false // yes or no for scatter plot labels
  );

  //Add the Caroline widget tp the grid
  mainGrid.attach (carolineWidget, 0, 0, 1, 1);
  mainGrid.set_row_homogeneous (true);
  mainGrid.set_column_homogeneous (true);

  window.add (mainGrid);
  window.destroy.connect (Gtk.main_quit);
  window.show_all ();

  Gtk.main ();

}
