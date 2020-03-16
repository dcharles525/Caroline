using Gtk;
using Gee;
using Cairo;

//To Run Tests: valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vapi UnitTests.vala -X Caroline.so -X -I.

void chartTest(){
  Test.add_func ("/caroline-vala/chart-test", () => {

    string[] chartTypeArray = {"line","bar","scatter","pie"};
    int[] benchNumbers = {10,100,1000};

    for (int i = 0; i < chartTypeArray.length; ++i){

      for (int f = 0; f < benchNumbers.length; ++f){

        double[] x = new double[benchNumbers[f]];
        double[] y = new double[benchNumbers[f]];

        for (int g = 0; g < benchNumbers[f]; ++g){

          x[g] = Random.double_range(0,10);
          y[g] = Random.double_range(0,10);

        }

        //Simply set Caroline to a variable
        var carolineWidget = new Caroline(x,y,chartTypeArray[i],true,true);

        assert (carolineWidget is Gtk.DrawingArea);

      }

    }

  });

}

void main (string[] args){

  Gtk.init (ref args);
  Test.init (ref args);

  chartTest();

  Idle.add (() => {
    Test.run ();
    Gtk.main_quit ();
    return false;
  });

  Gtk.main ();

}
