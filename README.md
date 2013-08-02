ACEAutocompleteBar
==================

![](https://github.com/acerbetti/ACEAutocompleteBar/blob/master/Example.png?raw=true)

Purpose
--------------
Forked from ACEAutocompleteBar and extended category for UITextView and added other misc features.(See change log)
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
06/24/2013 - v1.1.0
 - Extended support for UITextView
 - Extended support for every word in the sentence
 - Retain cursor position after selecting suggestion
 - Removed the need for implementing delegates for input field
 - Added ignoreCase option to ignore case of the input and suggestion list
 - Added property separatorColor to customizeView
 - Added dataSourceContent to do the matching internally [can be made smooth, probably in next update]
 - Added support to hide suggestion list on single tap or if selection changed
 - Added clearButton to dismiss the suggestion list
 - a) Set custom image for clear button
 - b) Disable clear button
 - Added 'text' NSString object in textfield delegate for result manipulation
 - Added 'range' UITextRange object in textfield delegate for cursor manipulation
 - Added 'text' NSString object in textview delegate for result manipulation
 - Added 'range' NSRange type in textview delegate for cursor manipulation


License
------------------
Copyright (c) 2013 Varshyl Mobile Pvt. Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
