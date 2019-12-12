# Caroline
A simple Cairo Chart Library for GTK and Vala

Caroline is a simple and light interface into Cairo allowing a developer to create a chart in just a few lines of
code! Below is some screenshots of what you can do with it currently. Also below is a road map, documentation, and
some ramblings about the development process and inner-workings of Cairo and Caroline!

<img src="Screenshot from 2018-11-02 17.08.37.png">
<img src="Screenshot from 2018-11-16 15.47.29.png">


### Documentation

The documentation is broken up into several sections: Getting Started, Caroline Attributes, Caroline Functions, and Ramblings.

#### Getting Started

A sample application called "sample.vala" is included in this repo, it contains a simple application to show off how Caroline works. Below is a bare-bones example of how to interface with Caroline.
```
var widget = new Caroline ();
widget.DATA = {59,78,43,42,71,41,12,55,26,40,18,57,32,42,85,19,83,100,89,3};

widget.labelXList.add(0.to_string().concat(widget.dataTypeX));

for (int i = 1; i < widget.DATA.length+1; i++){

  widget.labelXList.add(i.to_string().concat(widget.dataTypeX));

}
```

This is how we generate a simple line chart. See the full sample application to learn more.

#### Caroline Attributes

Here we have all the attributes that will be changed regularly by the developer, I will go
in depth here on which one means and how it works.

##### Public Attributes

**DATA**
An array of data that is used to graph any of the chart types. You should put information into
it as an array of the double type. A simple example is right here:
`widget.DATA = {1,2,3,4,5,6,7,8,9,10};`

**width (int) DEFAULT: 500**
This attribute can be deceiving, but if you want your widget to start at a certain width then
you can set this attribute as a static number or use get_allocated_width() to set the widget
width. It can be deceiving because the parent width may not be large enough so it inherits that.

**height (int) DEFAULT: 500**
This attribute can be deceiving, but if you want your widget to start at a certain height then
you can set this attribute as a static number or use get_allocated_height() to set the widget
height. It can be deceiving because the parent height may not be large enough so it inherits that.

**chartPadding (int) DEFAULT: 14**
Chart padding is a little different from the private widthPadding and heightPadding attributes.
This attribute is meant to tell the system where you want to start plotting the lines on the canvas.
So even with 0 padding in widthPadding and heightPadding the ticks will still be visible fully.

**lineThicknessTicks DEFAULT: 0.5 (double)**
The thickness of the line ticks. Adjusting this attribute to much can have consequences on how other
parts of the system adjust to the thickness of the ticks.

**lineThicknessPlane DEFAULT: 1 (double)**
The thickness of the x and y axis lines. Adjusting this attribute to much can have consequences on how other parts of the system adjust to the thickness of the ticks.

**lineThicknessData DEFAULT: 2 (double)**
This adjusts the thickness of the lines for the "line" and "bar" chart. Adjusting this attribute to much can have consequences on how other parts of the system adjust to the thickness of the ticks.

**spreadY DEFAULT: 10 (double)**
The amount of y ticks you want in your chart. Since the default is 10, the internal calculations()
function will displays all of the DATA values over 10 ticks.

**dataTypeY DEFAULT: "" (string)**
If you want your data to units or types on the y axis you can put a string value in such as m for meters.

**dataTypeX (string)**
If you want your data to units or types on the x axis you can put a string value in such as m for meters.

**labelXList (ArrayList<string>)**
This list is meant to label the x ticks. This originally was a private attribute, but I wanted the
developer to be able to only put customized numbers rather then dynamically generated ones. In the
future this will be an option.

##### Private Attributes

**gap (double)**

**max (double)**

**min (double)**

**widthPadding (int)**
This attribute allows you to have some padding around the widget and the width limit. This will make
your

**heightPadding (int)**

**labelYList (ArrayList<string>)**
The y axis labels for the tick marks are generated dynamically via the calculations() function
they should not be manually set!

#### Caroline Functions

#### Ramblings

All attributes must be set for the graph to work!

| Attribute        | Description         
| ------------- |:-------------:|
| double[] DATA | Will be the data used in the chart |
| double width  | Is the width of the chart |
| double height | Is the height of the chart |  
| double lineThicknessTicks | thickness of the line for ticks |  
| double lineThicknessPlane | thickness for the x & y graph line |  
| double lineThicknessData | thickness for the line or bar |  
| double spreadY | How many ticks do you want on the y axis? |  
| string dataTypeY | What kinda of data type is the y label (Ex. $,%...) |  
| string dataTypeX | What kinda of data type is the x label (Ex. $,%...) |  
| ArrayList<string> labelList | The labels for the x axis |  
| double gap | Just set this to 0, my code should take care of setting this. (modify if you know what you are doing) |
| double max | Just set this to 0, my code should take care of setting this. (modify if you know what you are doing) |
| double min | Just set this to 0, my code should take care of setting this. (modify if you know what you are doing) |
| string chartType | Is it "line" or "bar" chart? |
