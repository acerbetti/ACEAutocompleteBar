//  UITextField+ACEAutocompleteBar.m
//
// Copyright (c) 2013 Stefano Acerbetti
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "ACEAutocompleteBar.h"

@interface UITextField (Private)<ACEAutocompleteDelegate>

@end

#pragma mark -

@implementation UITextField (ACEAutocompleteBar)

- (void)setAutocompleteWithDataSource:(id<ACEAutocompleteDataSource>)dataSource
                             delegate:(id<ACEAutocompleteDelegate>)delegate
                            customize:(void (^)(ACEAutocompleteInputView *inputView))customizeView
{
    ACEAutocompleteInputView * autocompleteBarView = [ACEAutocompleteInputView new];
    self.inputAccessoryView = autocompleteBarView;
    self.delegate = autocompleteBarView;
    
    // pass the view to the caller to customize it
    if (customizeView) {
        customizeView(autocompleteBarView);
    }
    
    // set the protocols
    autocompleteBarView.textField = self;
    autocompleteBarView.delegate = delegate;
    autocompleteBarView.dataSource = dataSource;
    
    // init state is not visible
    [autocompleteBarView show:NO withAnimation:NO];
}

@end
