//  ACEAutocompleteInputView.m
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


#import "ACEAutocompleteBar.h"

@interface ACEAutocompleteInputView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *suggestionListView;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, copy) AutocompleteBlock autocompleteBlock;
@end

#pragma mark -

@implementation ACEAutocompleteInputView

- (id)initWithBlock:(AutocompleteBlock)autocompleteBlock
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    if (self) {
        // save the autocomplete block
        self.autocompleteBlock = autocompleteBlock;
        
        // create the table view with the suggestions
        _suggestionListView	= [[UITableView alloc] initWithFrame:CGRectMake((self.bounds.size.width - self.bounds.size.height) / 2,
                                                                            (self.bounds.size.height - self.bounds.size.width) / 2,
                                                                            self.bounds.size.height, self.bounds.size.width)];
        
        _suggestionListView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _suggestionListView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        
        _suggestionListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _suggestionListView.showsVerticalScrollIndicator = NO;
        _suggestionListView.showsHorizontalScrollIndicator = NO;
        
        _suggestionListView.dataSource = self;
        _suggestionListView.delegate = self;
        
        // add the table as subview
        [self addSubview:_suggestionListView];
    }
    return self;
}

- (void)show:(BOOL)show withAnimation:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self show:show withAnimation:NO];
                         } completion:nil];
        
    } else {
        self.alpha = (show) ? 1.0f : 0.0f;
    }
}


#pragma makr - Helpers

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.suggestionListView reloadData];
}

- (NSString *)stringForObjectAtIndex:(NSUInteger)index
{
    id object = [self.dataSource objectAtIndex:index];
    if ([object conformsToProtocol:@protocol(ACEAutocompleteItem)]) {
        return [object autocompleteString];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    
    } else {
        return nil;
    }
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.dataSource = self.autocompleteBlock(newText);
    return YES;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[self stringForObjectAtIndex:indexPath.row] sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
                                                          constrainedToSize:CGSizeMake(320.0f, 40.0f)];
    return size.width + 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate inputView:self didSelectString:[self stringForObjectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger suggestions = self.dataSource.count;
    [self show:suggestions > 0 withAnimation:YES];
    return suggestions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * cellId = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    cell.textLabel.text = [self stringForObjectAtIndex:indexPath.row];
    return cell;
}

@end
