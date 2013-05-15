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


#import "ACEAutocompleteInputView.h"

@interface ACEAutocompleteInputView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *suggestionListView;
@end

#pragma mark -

@implementation ACEAutocompleteInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
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


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[self stringForObjectAtIndex:indexPath.row] sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
                                                          constrainedToSize:CGSizeMake(320.0f, 40.0f)];
    return size.width + 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
