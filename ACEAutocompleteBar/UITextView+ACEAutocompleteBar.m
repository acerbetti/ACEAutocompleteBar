//
//  UITextView+ACEAutocompleteBar.m
//  ACEAutocompleteBarDemo
//
//  Created by Jimmy on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import "ACEAutocompleteBar.h"
@interface UITextView (private)<ACEAutocompleteDelegate>
@end


@implementation UITextView (ACEAutocompleteBar)

- (void)setAutocompleteWithDataSource:(id<ACEAutocompleteDataSource>)dataSource
                             delegate:(id<ACEAutocompleteDelegate>)delegate
                            customize:(void (^)(ACEAutocompleteInputView *inputView))customizeView
                           ignoreCase:(BOOL)ignoreCase
                    dataSourceContent:(NSArray *)dataSourceContent
                     clearButtonImage:(UIImage *)clearButtonImage
             andShouldShowClearButton:(BOOL)shouldShowClearButton
{
    ACEAutocompleteInputView * autocompleteBarView = [[ACEAutocompleteInputView alloc] initWithClearButtonImage:clearButtonImage andShouldShowClearButton:shouldShowClearButton];
    self.inputAccessoryView = autocompleteBarView;
    self.delegate = autocompleteBarView;
    
    // pass the view to the caller to customize it
    if (customizeView) {
        customizeView(autocompleteBarView);
    }
    
    // set the protocols
    autocompleteBarView.textView = self;
    autocompleteBarView.delegate = delegate;
    autocompleteBarView.dataSource = dataSource;
    autocompleteBarView.ignoreCase = ignoreCase;
    autocompleteBarView.dataSourceContent = dataSourceContent;
    
    // init state is not visible
    [autocompleteBarView show:NO withAnimation:NO];
}
@end
