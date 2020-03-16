using Gtk;
using Gee;
using Cairo;

//To Run Tests: valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vala UnitTests.vala

void lineTest(){
  Test.add_func ("/vala/test", () => {

    int benchNumber = 10;
    double[] x = new double[benchNumber];
    double[] y = new double[benchNumber];

    for (int i = 0; i < benchNumber; ++i){

      x[i] = Random.double_range(0,10);
      y[i] = Random.double_range(0,10);

    }

    //Simply set Caroline to a variable
    var carolineWidget = new Caroline(x,y,"scatter",true,true);

    assert (carolineWidget is Gtk.Widget);

  });
}

void main (string[] args){

  Gtk.init (ref args);
  Test.init (ref args);

  lineTest();

  Idle.add (() => {
    Test.run ();
    Gtk.main_quit ();
    return false;
  });

  Gtk.main ();

}
