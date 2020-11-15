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

  int benchNumber = 20;

  double[] y = new double[benchNumber+1];
  double[] x = new double[benchNumber+1];

  y[0] = 0;

  for (int i = 0; i < y.length; ++i)
    y[i] = Random.int_range(0,100);

  for (int i = 0; i < y.length; ++i)
    x[i] = i;

  //Simply set Caroline to a variable
  var carolineWidget = new Caroline(
    x, //dataX
    y, //dataY
    "smooth-line", //chart type
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

  Timeout.add (3000, () => {

    benchNumber = 20;

    double[] y2 = new double[benchNumber+1];
    double[] x2 = new double[benchNumber+1];

    y2[0] = 0;

    for (int i = 0; i < y2.length; ++i)
      y2[i] = Random.int_range(0,100);

    for (int i = 0; i < y2.length; ++i)
      x2[i] = i;

    carolineWidget.updateData (x2, y2, false);
    carolineWidget.queue_draw ();
    window.show_all ();
    return true; 

  });

  Gtk.main ();

}
