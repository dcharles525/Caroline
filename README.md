# Caroline
A simple Cairo Chart Library for GTK and Vala (Lines and Bars)

<img src="Screenshot from 2018-11-02 17.08.37.png">
<img src="Screenshot from 2018-11-16 15.47.29.png">
<img src="Screenshot from 2018-11-16 20.35.08.png">
      

### Documentation 
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

