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

A sample application called "sample.vala" is included in this repo, it contains a simple application to show off
how Caroline works. Below is a bare-bones example of how to interface with Caroline.
```

```

#### Caroline Attributes

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
