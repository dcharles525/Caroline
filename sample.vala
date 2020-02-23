using Gtk;
using Gee;
using Cairo;

//To run this program: valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vala sample.vala -o demo

public void main (string[] args) {

  //Setting up the GTK window
  Gtk.init (ref args);
  var window = new Gtk.Window ();
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size(500,500);

  //Building grid to put the widget into
  Gtk.Grid mainGrid = new Gtk.Grid ();
  mainGrid.orientation = Gtk.Orientation.VERTICAL;

  //Simply set Caroline to a variable
  var widget = new Caroline (
    {10,20,30,40,50,60,70,80,90,23,65,32,12,89,21}, //dataX
    {1,35,68,20,30,40,4,12,60,90,83,36,34,56,78}, //dataY
    "scatter", //chart type
    true //yes or no for generateColors function (needed in the case of the pie chart)
  );

  //Add the Caroline widget tp the grid
  mainGrid.attach (widget, 0, 0, 1, 1);
  mainGrid.set_row_homogeneous(true);
  mainGrid.set_column_homogeneous(true);

  window.add(mainGrid);
  window.destroy.connect (Gtk.main_quit);
  window.show_all ();

  Gtk.main ();

}
