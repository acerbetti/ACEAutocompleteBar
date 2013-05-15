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
    [self.textField setAutocompleteWithBlock:^NSArray *(NSString *string) {
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
