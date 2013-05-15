//
//  UITextField+ACEAutocompleteBar.m
//  ACEAutocompleteBarDemo
//
//  Created by Stefano Acerbetti on 5/15/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEAutocompleteBar.h"

@interface UITextField (Private)<ACEAutocompleteInputDelegate>

@end

#pragma mark -

@implementation UITextField (ACEAutocompleteBar)

- (void)setAutocompleteWithBlock:(AutocompleteBlock)autocompleteBlock
{
    ACEAutocompleteInputView * autocompleteBarView = [[ACEAutocompleteInputView alloc] initWithBlock:autocompleteBlock];
    self.inputAccessoryView = autocompleteBarView;
    
    autocompleteBarView.delegate = self;
    self.delegate = autocompleteBarView;
}

- (void)inputView:(ACEAutocompleteInputView *)inputView didSelectString:(NSString *)string
{
    self.text = string;
}

@end
