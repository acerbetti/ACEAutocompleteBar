//  ACEAutocompleteInputView.h
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

@interface ACEAutocompleteInputView : UIView<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, assign) UITextField *textField;
@property (nonatomic, assign) UITextView *textView;
@property (nonatomic, assign) BOOL ignoreCase;
@property (nonatomic, assign) NSArray *dataSourceContent;

// delegate
@property (nonatomic, assign) id<ACEAutocompleteDelegate> delegate;
@property (nonatomic, assign) id<ACEAutocompleteDataSource> dataSource;

// customization (ignored when the optional methods of the data source are implemeted)
@property (nonatomic, strong) UIFont  * font;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * separatorColor;

- (id)initWithHeight:(CGFloat)height;
-(id)initWithClearButtonImage:(UIImage *)clearButtonImage andShouldShowClearButton:(BOOL)shouldShowClearButton;

- (void)show:(BOOL)show withAnimation:(BOOL)animated;

@end
