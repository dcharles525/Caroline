![CI](https://github.com/dcharles525/Caroline/workflows/CI/badge.svg?branch=master)

![alt text](data/logo.png "Caroline")
<br>
Logo Created By @stsdc
<br>
A simple Cairo Chart Library for GTK and Vala

Caroline is a simple and light interface into Cairo allowing a developer to create a chart in just a few lines of
code! Below is some screenshots of what you can do with it currently. Also below is a road map, documentation, and
some ramblings about the development process and inner-workings of Cairo and Caroline!

<img src="data/6.png">
<img src="data/4.png">
<img src="data/1.png">
<img src="data/2.png">
<img src="data/3.png">
<img src="data/5.png">

### Getting Started

#### Compiling & Installing

```
mkdir build
cd build
meson ..
ninja

You now have a linked library that can be accessed by your app!
```

#### Simple Usage

A sample application called "Sample.vala" is included in this repo, it contains a simple application to show off how Caroline works. Below is a bare-bones example of how to interface with Caroline.
```
var carolineWidget = new Caroline (
  x, //dataX
  yArray, //dataY
  "scatter", //chart type
  true, //yes or no for generateColors function (needed in the case of the pie chart),
  true, //true for generating hue based colors, and false for random colors
  false // yes or no for scatter plot labels
);

or generate your own colors:

ArrayList<Caroline.ChartColor?> chartColorArray = new ArrayList<Caroline.ChartColor?> ();

for (int i = 0; i < cArray.length; i++){

  //Create color struct
  Caroline.ChartColor chartColor = {
    Random.double_range(0,1),
    Random.double_range(0,1),
    Random.double_range(0,1)
  };

  chartColorArray.insert (i, chartColor);

}

var carolineWidget = new Caroline (
  x, //dataX
  yArray, //dataY
  "scatter", //chart type
  chartColorArray,
  false, //yes or no for generateColors function (needed in the case of the pie chart),
  false, //true for generating hue based colors, and false for random colors
  false // yes or no for scatter plot labels
);
```

This is how we generate a simple line chart. See the full sample application to learn more.

### Caroline Documentation

Check out the code! It has lots of detailed documentation and try using the Sample.vala file. Chart types are now bar, line, smooth-line, scatter, and pie.
