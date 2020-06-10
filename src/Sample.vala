using Gtk;
using Gee;
using Cairo;

/*
* To run this program:
* valac --pkg gtk+-3.0 --pkg gee-0.8 -X -I. -X -L. -X -caroline -o sample Sample.vala caroline.vapi
* valac  Caroline.vapi Sample.vala -X Caroline.so -X -I. -o demo
*/

public void main (string[] args) {

  //Setting up the GTK window
  Gtk.init (ref args);
  var window = new Gtk.Window ();
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size(500,500);

  //Building grid to put the widget into
  Gtk.Grid mainGrid = new Gtk.Grid ();
  mainGrid.orientation = Gtk.Orientation.VERTICAL;

  //int benchNumber = 10;

  //CDC 4/19 Data
  double[] y = {8,6,23,25,20,66,47,64,147,
  225,290,278,267,338,1237,775,2797,3419,4777,3528,8821,10934,10115,13987,16916,17965,19332,18251,22635,22562,27043,
  26135,18819,9338,63455,43348,21597,31534,31705,33251,33288,29145,24156,26385,27158,29164,29002,29916,25995};

  double[] x = new double[y.length];

  for (int i = 0; i < y.length; ++i)
    x[i] = i;

  //Simply set Caroline to a variable
  var carolineWidget = new Caroline(
    x, //dataX
    y, //dataY
    {"line"}, //chart type
    true, //yes or no for generateColors function (needed in the case of the pie chart),
    false // yes or no for scatter plot labels
  );

  //Add the Caroline widget tp the grid
  mainGrid.attach(carolineWidget, 0, 0, 1, 1);
  mainGrid.set_row_homogeneous(true);
  mainGrid.set_column_homogeneous(true);

  window.add(mainGrid);
  window.destroy.connect (Gtk.main_quit);
  window.show_all ();

  Gtk.main ();

}
