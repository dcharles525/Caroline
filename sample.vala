using Gtk;
using Gee;
using Cairo;

//To run this program: valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vala sample.vala -o demo

public void main (string[] args) {

  GLib.DateTime now = new GLib.DateTime.now_local();
  var sec = now.to_unix();
  var msecStart = (sec * 1000) + (now.get_microsecond () / 1000);

  //Setting up the GTK window
  Gtk.init (ref args);
  var window = new Gtk.Window ();
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size(500,500);

  //Building grid to put the widget into
  Gtk.Grid mainGrid = new Gtk.Grid ();
  mainGrid.orientation = Gtk.Orientation.VERTICAL;

  int benchNumber = 10000;
  double[] x = new double[benchNumber];
  double[] y = new double[benchNumber];

  for (int i = 0; i < benchNumber; ++i){

    x[i] = Random.double_range(0,10);
    y[i] = Random.double_range(0,10);

  }

  //Simply set Caroline to a variable
  var carolineWidget = new Caroline (
    x, //dataX
    y, //dataY
    "line", //chart type
    true, //yes or no for generateColors function (needed in the case of the pie chart),
    false // yes or no for scatter plot labels
  );

  now = new GLib.DateTime.now_local();
  sec = now.to_unix();
  var msecEnd = (sec * 1000) + (now.get_microsecond () / 1000);
  stdout.printf("Time Taken: %f\n",msecEnd - msecStart);

  //Add the Caroline widget tp the grid
  mainGrid.attach(carolineWidget, 0, 0, 1, 1);
  mainGrid.set_row_homogeneous(true);
  mainGrid.set_column_homogeneous(true);

  window.add(mainGrid);
  window.destroy.connect (Gtk.main_quit);
  window.show_all ();

  Gtk.main ();

}
