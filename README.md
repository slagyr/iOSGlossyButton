<img src="https://raw.github.com/slagyr/iOSGlossyButton/master/preview.png" alt="Hyperion logo" title="Glossy Buttons" align="right"/>
# iOS Glossy Buttons

Glossy buttons seems to be used all the time in iOS designs.  Yet there doesn't seem to be any elegant solution to implement them.
So here's some code that'll do it.

## Installation

Copy the code and put it your project.

## Usage

### Interface Builder

Add a UIButton to your view and set the class to GlossyButton

### Code

[GlossyButton instance]

### Customizable Properties

    @property(nonatomic, strong) UIColor* rootColor;
    @property(nonatomic, retain) UIColor* borderColor;
    @property(nonatomic) float cornerRadius;
    @property(nonatomic) bool topLeftRounded;
    @property(nonatomic) bool topRightRounded;
    @property(nonatomic) bool bottomRightRounded;
    @property(nonatomic) bool bottomLeftRounded;
    @property(nonatomic) float topBorderWidth;
    @property(nonatomic) float rightBorderWidth;
    @property(nonatomic) float bottomBorderWidth;
    @property(nonatomic) float leftBorderWidth;

## License

Copyright (c) 2012 Micah Martin

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

