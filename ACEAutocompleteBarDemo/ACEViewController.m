//
//  ACEViewController.m
//  ACEAutocompleteBarDemo
//
//  Created by Stefano Acerbetti on 5/14/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEViewController.h"
#import "ACEAutocompleteBar.h"

@interface ACEViewController ()

@end

@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the autocomplete data
    [self.textField setAutocompleteWithBlock:^NSArray *(ACEAutocompleteInputView *inputView, NSString *string) {
        
        // customize the view (optional)
        inputView.font = [UIFont systemFontOfSize:20];
        inputView.textColor = [UIColor whiteColor];
        inputView.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:0.8];
        
        // return the data
        NSMutableArray *data = [NSMutableArray array];
        for (NSString *s in @[@"one", @"two", @"three", @"four"]) {
            if ([s hasPrefix:string]) {
                [data addObject:s];
            }
        }
        return data;
    }];
    
    // show the keyboard
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
