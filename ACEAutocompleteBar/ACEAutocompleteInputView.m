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

#define kDefaultHeight      44.0f
#define kDefaultMargin      5.0f

#define kTagRotatedView     101
#define kTagLabelView       102

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@interface ACECell : UITableViewCell
@property (nonatomic, retain) UIView *separatorView;
@end

@implementation ACECell

@end

@interface ACEAutocompleteInputView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *suggestionList;
@property (nonatomic, strong) UITableView *suggestionListView;
@end

#pragma mark -

@implementation ACEAutocompleteInputView

- (id)init
{
    return [self initWithHeight:kDefaultHeight];
}

- (id)initWithHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, height)];
    if (self) {
        // create the table view with the suggestions
        _suggestionListView	= [[UITableView alloc] initWithFrame:CGRectMake((self.bounds.size.width - self.bounds.size.height) / 2,
                                                                            (self.bounds.size.height - self.bounds.size.width) / 2,
                                                                            self.bounds.size.height, self.bounds.size.width)];
        
        // init the bar the hidden state
        self.hidden = YES;
        
        _suggestionListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _suggestionListView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        
        _suggestionListView.showsVerticalScrollIndicator = NO;
        _suggestionListView.showsHorizontalScrollIndicator = NO;
        _suggestionListView.backgroundColor = [UIColor clearColor];
        _suggestionListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _suggestionListView.dataSource = self;
        _suggestionListView.delegate = self;
        
        // clean the rest of separators
        _suggestionListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
        
        // add the table as subview
        [self addSubview:_suggestionListView];
    }
    return self;
}

- (void)show:(BOOL)show withAnimation:(BOOL)animated
{
    if (show && self.hidden) {
        // this is to remove the frst animation when the virtual keyboard will appear
        // use the hidden property to hide the bar wihout animations
        self.hidden = NO;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self show:show withAnimation:NO];
							 self.hidden = !show;
                         } completion:nil];
        
    } else {
        self.alpha = (show) ? 1.0f : 0.0f;
		self.hidden = !show;
    }
}


#pragma mark - Properties

- (UIFont *)font
{
    if (_font == nil) {
        _font = [UIFont boldSystemFontOfSize:18.0f];
    }
    return _font;
}

- (UIColor *)textColor
{
    if (_textColor == nil) {
        _textColor = [UIColor darkTextColor];
    }
    return _textColor;
}

#pragma makr - Helpers

- (NSString *)stringForObjectAtIndex:(NSUInteger)index
{
    
    id object = [self.suggestionList objectAtIndex:index];
    if ([_dataSource respondsToSelector:@selector(inputView:stringForObject:atIndex:)]) {
        return [_dataSource inputView:self stringForObject:object atIndex:index];
    } else if ([object conformsToProtocol:@protocol(ACEAutocompleteItem)]) {
        return [object autocompleteString];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    
    } else {
        return nil;
    }
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[self show: NO withAnimation: NO];
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * query = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (query.length >= [self.dataSource minimumCharactersToTrigger:self]) {
        [self.dataSource inputView:self itemsFor:query result:^(NSArray *items) {
            self.suggestionList = items;
            [self.suggestionListView reloadData];
        }];
        
    } else {
        self.suggestionList = nil;
        [self.suggestionListView reloadData];
    }
    
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textFieldShouldClear:textField];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return NO;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(inputView:widthForObject:)]) {
        return [self.dataSource inputView:self widthForObject:[self.suggestionList objectAtIndex:indexPath.row]];
        
    } else {
        NSString * string = [self stringForObjectAtIndex:indexPath.row];
        CGFloat width;
        
        if (DeviceSystemMajorVersion() >= 7) {
            width = [string boundingRectWithSize: self.frame.size
                                         options: NSStringDrawingUsesLineFragmentOrigin
                                      attributes: @{NSFontAttributeName : self.font}
                                         context: nil].size.width;
            width = ceilf(width);
            width+=1;
        } else{
            width = [string sizeWithFont:self.font constrainedToSize:self.frame.size].width;
        }
        
        if (width == 0) {
            // bigger than the screen
            return self.frame.size.width;
        }
        
        // add some margins
        return width + (kDefaultMargin * 2) + 1.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate textField:self.textField didSelectObject:[self.suggestionList objectAtIndex:indexPath.row] inInputView:self];
    
    // hide the bar
    [self show:NO withAnimation:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger suggestions = self.suggestionList.count;
    [self show:suggestions > 0 withAnimation:YES];
    return suggestions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * cellId = @"cell";
    
    UIView *rotatedView = nil;
    
    ACECell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ACECell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
		cell.bounds	= CGRectMake(0, 0, self.bounds.size.height, self.frame.size.height);
		cell.contentView.frame = cell.bounds;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        
        
		
        CGRect frame = CGRectInset(CGRectMake(0.0f, 0.0f, cell.bounds.size.height, cell.bounds.size.width), kDefaultMargin, kDefaultMargin);
		rotatedView = [[UIView alloc] initWithFrame:frame];
        rotatedView.tag = kTagRotatedView;
		rotatedView.center = cell.contentView.center;
		rotatedView.clipsToBounds = YES;
        
        rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        rotatedView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
		[cell.contentView addSubview:rotatedView];
        
        // customization
        [self customizeView:rotatedView];
	
    } else {
        rotatedView = [cell.contentView viewWithTag:kTagRotatedView];
    }
    if (cell.separatorView) {
        [cell.separatorView removeFromSuperview];
    }
    cell.separatorView = [[UIView alloc] init];
    
    CGFloat cellHeight = [self tableView:_suggestionListView heightForRowAtIndexPath:indexPath];
    cell.separatorView.frame = CGRectMake(cell.contentView.frame.origin.x, cellHeight-1, cell.contentView.frame.size.width, 1);
    cell.separatorView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:cell.separatorView];
    
    // customize the cell view if the data source support it, just use the text otherwise
    if ([self.dataSource respondsToSelector:@selector(inputView:setObject:forView:)]) {
        [self.dataSource inputView:self setObject:[self.suggestionList objectAtIndex:indexPath.row] forView:rotatedView];
        
    } else {
        UILabel * textLabel = (UILabel *)[rotatedView viewWithTag:kTagLabelView];
        
        // set the default properties
        textLabel.font = self.font;
        textLabel.textColor = self.textColor;
        textLabel.text = [self stringForObjectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)customizeView:(UIView *)rotatedView
{
    // customization
    if ([self.dataSource respondsToSelector:@selector(inputView:customizeView:)]) {
        [self.dataSource inputView:self customizeView:rotatedView];
        
    } else {
        // create the label
        UILabel * textLabel = [[UILabel alloc] initWithFrame:rotatedView.bounds];
        textLabel.tag = kTagLabelView;
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textLabel.backgroundColor = [UIColor clearColor];
        [rotatedView addSubview:textLabel];
    }
}

@end
