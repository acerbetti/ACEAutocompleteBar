//
//  UITextView+ACEAutocompleteBar.h
//  ACEAutocompleteBarDemo
//
//  Created by Jimmy on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ACEAutocompleteBar)

- (void)setAutocompleteWithDataSource:(id<ACEAutocompleteDataSource>)dataSource
                             delegate:(id<ACEAutocompleteDelegate>)delegate
                            customize:(void (^)(ACEAutocompleteInputView *inputView))customizeView
                           ignoreCase:(BOOL)ignoreCase
                    dataSourceContent:(NSArray *)dataSourceContent
                     clearButtonImage:(UIImage *)clearButtonImage
             andShouldShowClearButton:(BOOL)shouldShowClearButton;

@end
