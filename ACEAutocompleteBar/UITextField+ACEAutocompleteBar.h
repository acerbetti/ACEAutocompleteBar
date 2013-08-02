//  UITextField+ACEAutocompleteBar.h
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


#import <UIKit/UIKit.h>

@interface UITextField (ACEAutocompleteBar)

- (void)setAutocompleteWithDataSource:(id<ACEAutocompleteDataSource>)dataSource
                             delegate:(id<ACEAutocompleteDelegate>)delegate
                            customize:(void (^)(ACEAutocompleteInputView *inputView))customizeView
                           ignoreCase:(BOOL)ignoreCase
                    dataSourceContent:(NSArray *)dataSourceContent
                     clearButtonImage:(UIImage *)clearButtonImage
             andShouldShowClearButton:(BOOL)shouldShowClearButton;

@end
