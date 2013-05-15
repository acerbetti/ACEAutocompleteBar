//
//  UITextField+ACEAutocompleteBar.h
//  ACEAutocompleteBarDemo
//
//  Created by Stefano Acerbetti on 5/15/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ACEAutocompleteBar)

- (void)setAutocompleteWithBlock:(AutocompleteBlock)autocompleteBlock;

@end
