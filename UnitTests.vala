//============================================================+
// File name   : UnitTests.vala
// Last Update : 2020-3-21
//
// Description : This unit test file is meant to run an assortment of basic (for now) tests
// to ensure the library will run.
//
// To Run Tests: valac --pkg gtk+-3.0 --pkg gee-0.8 Caroline.vapi UnitTests.vala -X Caroline.so -X -I.
//
// Author: David
//============================================================+
using Gtk;
using Gee;
using Cairo;

void typeAssignmentsTest(){

  Test.add_func ("/caroline-vala/chart-type-test", () => {

    var carolineWidget = new Caroline({1,2,3,4},{1,2,3,4},"scatter",true,true);

    assert (carolineWidget.chartType == "scatter");

  });

}

void orderingTest(){

  Test.add_func ("/caroline-vala/chart-sort-test", () => {

    var carolineWidget = new Caroline({1,10,100,30,40,50},{1,2,3,4,5,6},"line",true,true);

    assert (carolineWidget.pointsArray[0].x == 1);
    assert (carolineWidget.pointsArray[carolineWidget.pointsArray.size-1].x == 100);

  });

}

void benchMarkTest(){

  Test.add_func ("/caroline-vala/chart-bench-test", () => {

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

  orderingTest();
  typeAssignmentsTest();
  //benchMarkTest();

  Idle.add (() => {
    Test.run ();
    Gtk.main_quit ();
    return false;
  });

  Gtk.main ();

}
