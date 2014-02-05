//  ACEAutocompleteBar.h
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

@class ACEAutocompleteInputView;

@protocol ACEAutocompleteItem <NSObject>

// used to display text on the autocomplete bar
- (NSString *)autocompleteString;

@end

#pragma mark -

@protocol ACEAutocompleteDelegate <UITextFieldDelegate>

// called when the user tap on one of the suggestions
- (void)textField:(UITextField *)textField didSelectObject:(id)object inInputView:(ACEAutocompleteInputView *)inputView;

@end

#pragma mark -

@protocol ACEAutocompleteDataSource <NSObject>

// number of characters required to trigger the search on possible suggestions
- (NSUInteger)minimumCharactersToTrigger:(ACEAutocompleteInputView *)inputView;

// use the block to return the array of items asynchronously based on the query string 
- (void)inputView:(ACEAutocompleteInputView *)inputView itemsFor:(NSString *)query result:(void (^)(NSArray *items))resultBlock;

@optional

- (NSString*)inputView:(ACEAutocompleteInputView *)inputView stringForObject:(id)object atIndex:(NSUInteger)index;

// calculate the width of the view for the object (NSString or ACEAutocompleteItem)
- (CGFloat)inputView:(ACEAutocompleteInputView *)inputView widthForObject:(id)object;

// called when after the cell is created, to add custom subviews
- (void)inputView:(ACEAutocompleteInputView *)inputView customizeView:(UIView *)view;

// called to set the object properties in the custom view
- (void)inputView:(ACEAutocompleteInputView *)inputView setObject:(id)object forView:(UIView *)view;

@end

#import "ACEAutocompleteInputView.h"
#import "UITextField+ACEAutocompleteBar.h"


