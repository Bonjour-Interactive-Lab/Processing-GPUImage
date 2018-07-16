# Float to RGBA encoding/Decoding methods test
_This document show thes results of various tested methods to encoding/decoding float to RGBA value_

```
ENTRY VALUE : 
double PID = 3.1415926535897932384626433832795028841971693993751058209749445923078164062;
```

## Gary Ruddock (Skytiger) approach
[Link](https://skytiger.wordpress.com/2010/12/01/packing-depth-into-color/)

### ARGB32
```
entry 			:3.1415927410125732
retreived 		:3.1415927409952498
norm entry 		:0.5
norm retreived 	:0.49999999999724287
ARGB value 		:2139062143
```

### ARGB24
```
entry 			:3.1415927410125732
retreived 		:3.1415925522730985
norm entry 		:0.5
norm retreived 	:0.49999996996118046
ARGB value 		:-8421505
```

### ARGB24 Methods2
```
entry 			:3.1415927410125732
retreived 		:3.141592554493359
norm entry 		:0.5
norm retreived 	:0.4999999703145459
ARGB value 		:-8388609
```

## Aras Pranckevičius approach
[Link](https://aras-p.info/blog/2009/07/30/encoding-floats-to-rgba-the-final/)

### ARGB32
```
entry 			:3.1415927410125732
retreived 		:3.1168557902787515
norm entry 		:0.5
norm retreived 	:0.4960629921232488
ARGB value 		:2122219134
```


## Chris Wellons approach
**This approach is useful when you need to encode an 2D x,y position into en RGBA texture where x >> RG et y >> BA**
[Link](https://nullprogram.com/blog/2014/06/29/)

## ARGB16 (two value encoded int two channels)
```
entry 			:3.1415927410125732
retreived 		:3.129224825983652
norm entry 		:0.5
norm retreived 	:0.4980315852421828
ARGB value 		:-16744449
```

## Conclusion
1. Gary Ruddock's methods seems to be the more accurate by encoding into the 32 bits (8bits per channel) and using a factor and mask approach.
2. Aras Pranckevičius' approach seems quite inefficient fo JAVA by losing values at its first digit
3. Chris Wellons' approach seems also inefficient but quite usefull if we want to store 1 value per 2 channel such as x >> RG and y >> BA

| NAME   					| VALUES 			    	|
|:---						|:---						|
| ENTRY VALUE (double) 		| **3.1415927410125732**	|
| Gary Ruddock ARGB32 		| **3.14159274**09952498	|
| Gary Ruddock ARGB24-1		| **3.141592**5522730985	|
| Gary Ruddock ARGB24-2 	| **3.141592**554493359		|
| Aras Pranckevičiu ARGB32 	| **3.1**168557902787515	|
| Chris Wellons ARGB16 		| **3.1**29224825983652		|

