ACEAutocompleteBar
==================

![](https://github.com/acerbetti/ACEAutocompleteBar/blob/master/Example.png?raw=true)

Purpose
--------------
ACEAutocompleteBar is a simple category of the UITextField. 
It automatically displays text suggestions in real-time on the top of the virtual keyboard. It uses a block to create the data source and can work well will an asynchronous API request. 

How-To
------------------
- Import the files from the folder "ACEAutocompleteBar" to your project
- Add #import "ACEAutocompleteBar.h" in you source file
- Call setAutocompleteWithDataSource on the UITextField
- Set the data source instance to display the suggested words
- Set the delegate instance to handle the actions on the text field


Features
------------------
- Asynchronous data source. It can be local or from an API
- Customizable toolbar (font and colors)


ARC Compatibility
------------------
This component requires ARC


Change Log
------------------
12/02/2013 - v1.1.0
- Support for iOS6 & iOS7

05/20/2013 - v1.0.0
- Support for custom height
- Fixed change orientation bug

05/18/2013 - v0.1.2
- Extend the UITextField delegate to support more customization

05/17/2013 - v0.1.1
- Better implementation of the asynchronous data source

05/16/2013 - v0.1
- Initial release


License
------------------
Copyright (c) 2013 Stefano Acerbetti

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
