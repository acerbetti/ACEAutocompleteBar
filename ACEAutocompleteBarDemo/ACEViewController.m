//
//  ACEViewController.m
//  ACEAutocompleteBarDemo
//
//  Created by Stefano Acerbetti on 5/14/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEViewController.h"
#import "ACEAutocompleteBar.h"

@interface ACEViewController ()<ACEAutocompleteDataSource, ACEAutocompleteDelegate>
@property (nonatomic, strong) NSArray *sampleStrings;
@end

@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sampleStrings = @[@"one", @"two", @"three", @"four"];
    
    // set the autocomplete data
    [self.textField setAutocompleteWithDataSource:self
                                         delegate:self
                                        customize:^(ACEAutocompleteInputView *inputView) {
                                            
                                            // customize the view (optional)
                                            inputView.font = [UIFont systemFontOfSize:20];
                                            inputView.textColor = [UIColor whiteColor];
                                            inputView.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:0.8];
                                            
                                        }];
    
    // show the keyboard
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Autocomplete Delegate

- (void)inputView:(ACEAutocompleteInputView *)inputView didSelectObject:(id)object forField:(UITextField *)textField
{
    textField.text = object; // nssstring
}


#pragma mark - Autocomplete Data Source

- (NSUInteger)minimumCharactersToTrigger:(ACEAutocompleteInputView *)inputView
{
    return 1;
}

- (void)inputView:(ACEAutocompleteInputView *)inputView itemsFor:(NSString *)query result:(void (^)(NSArray *items))resultBlock;
{
    if (resultBlock != nil) {
        // execute the filter on a background thread to demo the asynchronous capability
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            // execute the filter
            NSMutableArray *data = [NSMutableArray array];
            for (NSString *s in self.sampleStrings) {
                if ([s hasPrefix:query]) {
                    [data addObject:s];
                }
            }
            
            // return the filtered array in the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(data);
            });
        });
    }
}

@end
