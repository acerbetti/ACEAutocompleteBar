//
//  ACEViewController.m
//  ACEAutocompleteBarDemo
//
//  Created by Jimmy on 24/07/13.
//  Copyright (c) 2013 Varshyl Mobile Pvt. Ltd. All rights reserved.
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
    
    self.sampleStrings = @[@"One", @"two", @"three", @"Four", @"five", @"six", @"Seven", @"eight", @"nine", @"Ten", @"oone"];
    
    // set the autocomplete data
    [self.textField setAutocompleteWithDataSource:self
                                         delegate:self
                                        customize:^(ACEAutocompleteInputView *inputView) {
                                            
                                            // customize the view (optional)
                                            inputView.font = [UIFont systemFontOfSize:20];
                                            inputView.textColor = [UIColor whiteColor];
                                            inputView.backgroundColor = [UIColor grayColor];
                                            inputView.alpha = 0.8;
                                            inputView.separatorColor = [UIColor redColor];
                                            
                                        }
                                       ignoreCase:YES dataSourceContent:self.sampleStrings
                                 clearButtonImage:[UIImage imageNamed:@"btn_clear_black"]
                         andShouldShowClearButton:YES
     ];
    
    
    [self.textField2 setAutocompleteWithDataSource:self
                                          delegate:self
                                         customize:^(ACEAutocompleteInputView *inputView) {
                                             
                                             // customize the view (optional)
                                             inputView.font = [UIFont systemFontOfSize:20];
                                             inputView.textColor = [UIColor whiteColor];
                                             inputView.backgroundColor = [UIColor greenColor];
                                             inputView.alpha = 0.8;
                                             
                                         }
                                        ignoreCase:YES dataSourceContent:self.sampleStrings
                                  clearButtonImage:[UIImage imageNamed:@"btn_clear_white"]
                          andShouldShowClearButton:YES];
    
    
    [self.textView setAutocompleteWithDataSource:self
                                        delegate:self
                                       customize:^(ACEAutocompleteInputView *inputView) {
                                           
                                           // customize the view (optional)
                                           inputView.font = [UIFont systemFontOfSize:20];
                                           inputView.textColor = [UIColor whiteColor];
                                           inputView.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:0.8];
                                           inputView.separatorColor = [UIColor brownColor];
                                           
                                       }
                                      ignoreCase:YES dataSourceContent:self.sampleStrings
                                clearButtonImage:nil
                        andShouldShowClearButton:YES];
    
    
    // show the keyboard
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Autocomplete Data Source

- (NSUInteger)minimumCharactersToTrigger:(ACEAutocompleteInputView *)inputView
{
    return 1;
}

-(void)inputView:(ACEAutocompleteInputView *)inputView itemsFor:(NSString *)query ignoreCase:(BOOL)ignoreCase withResult:(NSArray *)resultArray result:(void (^)(NSArray *))resultBlock{
    
    if (resultBlock != nil) {
        
        resultBlock(resultArray);
    }
}

@end
