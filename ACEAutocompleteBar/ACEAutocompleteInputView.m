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

@interface ACEAutocompleteInputView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *suggestionList;
@property (nonatomic, strong) UITableView *suggestionListView;
@property (nonatomic, retain) NSString *leftString;
@property (nonatomic, retain) NSString *rightString;
@property (nonatomic, assign) NSRange range;
@property (nonatomic ,strong) UIView *clearListView;
@property (nonatomic, retain) UIImage *clearButtonImage;
@property (nonatomic, assign) BOOL shouldShowClearButton;
@property (nonatomic, assign) int paddingForClearButton;

@end

#pragma mark -

@implementation ACEAutocompleteInputView

- (id)init
{
    return [self initWithHeight:kDefaultHeight];
}

-(id)initWithClearButtonImage:(UIImage *)clearButtonImage andShouldShowClearButton:(BOOL)shouldShowClearButton{

    _shouldShowClearButton = shouldShowClearButton;
    _clearButtonImage = clearButtonImage;
    
    _paddingForClearButton = 0;
    
    if (_shouldShowClearButton) {
        
        _paddingForClearButton = kDefaultHeight * 2;
        self = [self initWithHeight:kDefaultHeight];
        [self addHideViewButton];
    }
    else
         self = [self initWithHeight:kDefaultHeight];
    
    return self;
}

- (id)initWithHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, height)];
    if (self) {
        // create the table view with the suggestions
        
        CGFloat xCord = (self.bounds.size.width - self.bounds.size.height + _paddingForClearButton) / 2;
        
        CGFloat yCord = (self.bounds.size.height - self.bounds.size.width) / 2;
        
        CGFloat width = self.bounds.size.height;
        
        CGFloat height = self.bounds.size.width;
        
        CGRect frame = CGRectMake(xCord, yCord, width, height);
        _suggestionListView	= [[UITableView alloc] initWithFrame:frame];
        
        // init the bar the hidden state
        self.hidden = YES;
        
        _suggestionListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _suggestionListView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        
        _suggestionListView.showsVerticalScrollIndicator = NO;
        _suggestionListView.showsHorizontalScrollIndicator = NO;
        _suggestionListView.backgroundColor = [UIColor clearColor];
        
        _suggestionListView.dataSource = self;
        _suggestionListView.delegate = self;
        
        // clean the rest of separators
        _suggestionListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f+_paddingForClearButton/2)];
        
        // add the table as subview
        
        [self addSubview:_suggestionListView];
        
    }
    return self;
}

-(void)addHideViewButton{

    CGRect frame = CGRectMake(0.0f, 0.0f, kDefaultHeight, kDefaultHeight);
    _clearListView = [[UIView alloc] initWithFrame:frame];
    [_clearListView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_clearListView];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if (_clearButtonImage) {
        [clearButton setBackgroundImage:_clearButtonImage forState:UIControlStateNormal];
    }else{
    
        UIImage *buttonImage = [UIImage imageNamed:@"btn_clear_white"];
       [clearButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    }
    
    [clearButton addTarget:self action:@selector(hideBar) forControlEvents:UIControlEventTouchUpInside];
    
    [clearButton setFrame:frame];
    [clearButton setBackgroundColor:[UIColor clearColor]];
    
    [_clearListView addSubview:clearButton];
    


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

- (UIColor *)separatorColor
{
    if (_separatorColor == nil) {
        _separatorColor = [UIColor whiteColor];
    }
    return _separatorColor;
}



#pragma makr - Helpers

- (NSString *)stringForObjectAtIndex:(NSUInteger)index
{
    id object = [self.suggestionList objectAtIndex:index];
    if ([object conformsToProtocol:@protocol(ACEAutocompleteItem)]) {
        return [object autocompleteString];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
        
    } else {
        return nil;
    }
}


#pragma mark - Text Field Delegate

- (BOOL)canBecomeFirstResponder
{
    [self hideBar];
    
    return NO;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideBar];
    [textField addTarget:self
                  action:@selector(hideBar)
        forControlEvents:UIControlEventTouchDown];
    
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
    
    NSString *inputFieldText = textField.text;
    
    if ([self shouldShowBarForText:string]) [self showAutocompleteBarForInputFieldText:inputFieldText changeText:string andRange:range];
    else [self show:NO withAnimation:YES];
    
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self hideBar];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textViewShouldBeginEditing:textView];
    }
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *inputFieldText = textView.text;
    if ([self shouldShowBarForText:text]) [self showAutocompleteBarForInputFieldText:inputFieldText changeText:text andRange:range];
    else [self show:NO withAnimation:YES];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textViewDidChange:textView];
    }
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    [self hideBar];
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate textViewDidChangeSelection:textView];
    }
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row == 0) return 35 + (kDefaultMargin * 2) + 1.0f;
    //int idx = indexPath.row - 1;
    int idx = indexPath.row;
    if ([self.dataSource respondsToSelector:@selector(inputView:widthForObject:)]) {
        return [self.dataSource inputView:self widthForObject:[self.suggestionList objectAtIndex:idx]];
        
    } else {
        NSString * string = [self stringForObjectAtIndex:idx];
        CGFloat width = [string sizeWithFont:self.font constrainedToSize:self.frame.size].width;
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
    /*
    if (indexPath.row == 0) {
        [self hideBar];
        return;
    }
    
    
    NSString *selectedWord = [self.suggestionList objectAtIndex:indexPath.row-1];
    */
    NSString *selectedWord = [self.suggestionList objectAtIndex:indexPath.row];
    NSString *text = nil;
    if (_leftString) text = _leftString;
    
    if (_rightString)
        text = [[text stringByAppendingFormat:@" %@%@",selectedWord,_rightString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    else
        text = selectedWord;
    
    //Retain the cursor position
    _range = NSMakeRange(_range.location+selectedWord.length, 0);
    
    UITextRange *textRange = [self calculateSelectionRangeForTextFieldWithText:text];
    if ([self.delegate respondsToSelector:@selector(textField:didSelectObject:inInputView:newTextForInputField:withRange:)]) {
    
        [self.delegate textField:self.textField didSelectObject:selectedWord inInputView:self newTextForInputField:text withRange:textRange];
        
    }
    
    self.textView.text = text;
    [self.textView setSelectedRange:_range];
    
    if ([self.delegate respondsToSelector:@selector(textView:didSelectObject:inInputView:newTextForInputField:withRange:)]) {

//        self.textView.text = text;
//        [self.textView setSelectedRange:_range];
        [self.delegate textView:self.textView didSelectObject:selectedWord inInputView:self newTextForInputField:text withRange:_range];
    
    }
    
    
    
    // hide the bar
    [self show:NO withAnimation:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    NSInteger suggestions = self.suggestionList.count+1;// plus one for clear button
    [self show:suggestions > 1 withAnimation:YES];
    */
    
    NSInteger suggestions = self.suggestionList.count;// plus one for clear button
    [self show:suggestions > 0 withAnimation:YES];
    
    return suggestions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString * cellId = [NSString stringWithFormat:@"cell_%d_%d",indexPath.row,indexPath.section];
    
    UIView *rotatedView = nil;
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
		cell.bounds	= CGRectMake(0, 0, self.bounds.size.height, self.frame.size.height);
		cell.contentView.frame = cell.bounds;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        CGRect frame = CGRectInset(CGRectMake(0.0f, 0.0f, cell.bounds.size.height, cell.bounds.size.width), kDefaultMargin, kDefaultMargin);
		rotatedView = [[UIView alloc] initWithFrame:frame];
        rotatedView.tag = kTagRotatedView;
		rotatedView.center = cell.contentView.center;
		rotatedView.clipsToBounds = YES;
        
        rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        rotatedView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
		[cell.contentView addSubview:rotatedView];
		
        [tableView setSeparatorColor:self.separatorColor];
        // customization
        [self customizeView:rotatedView];
        
    } else {
        rotatedView = [cell.contentView viewWithTag:kTagRotatedView];
    }
    
    // customize the cell view if the data source support it, just use the text otherwise
   /*
    if (indexPath.row == 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(hideBar) forControlEvents:UIControlEventTouchUpInside];
        
        if (_clearButtonImage) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:_clearButtonImage];
        }
        else
            cell.accessoryView = button;
        return cell;
    }
    
    int idx = indexPath.row - 1;
    */
    
    int idx = indexPath.row;
    
    if ([self.dataSource respondsToSelector:@selector(inputView:setObject:forView:)]) {
        [self.dataSource inputView:self setObject:[self.suggestionList objectAtIndex:idx] forView:rotatedView];
        
    } else {
        UILabel * textLabel = (UILabel *)[rotatedView viewWithTag:kTagLabelView];
        
        // set the default properties
        textLabel.font = self.font;
        textLabel.textColor = self.textColor;
        textLabel.text = [self stringForObjectAtIndex:idx];
    }
    
    
    
    return cell;
}

-(void)hideBar{
    
    [self initiVars];
    [self show:NO withAnimation:YES];
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

-(void)showAutocompleteBarForInputFieldText:(NSString *)inputFieldText changeText:(NSString *)text andRange:(NSRange)range{
    
    [self initiVars];
    
    NSString * query = [inputFieldText stringByReplacingCharactersInRange:range withString:text];
    
    //NSLog(@"query %@ text %@ loc %d len %d",query,text,range.location,range.length);
    
    if (range.location < UINT32_MAX) {
        
        NSArray *words = [[query substringToIndex:range.location+1] componentsSeparatedByString:@" "];
        NSString *word = [words lastObject];
        
        NSMutableArray *wordsMut = [[[query substringToIndex:range.location+1] componentsSeparatedByString:@" "] mutableCopy];
        [wordsMut removeLastObject];
        _leftString = [wordsMut componentsJoinedByString:@" "];
        _rightString = [query substringFromIndex:range.location+1];
        //NSLog(@"_leftString %@  word %@ _rightString %@",_leftString,word,_rightString);
        query= word;
        
        NSString *next = [_rightString substringFromIndex:0];
        if (![next isEqualToString:@" "]) {
            
            NSString *appendString = [[_rightString componentsSeparatedByString:@" "] objectAtIndex:0];
            query = [query stringByAppendingString:appendString];
        }
        
        _range = NSMakeRange(range.location-query.length+1, 0);
        //NSLog(@"query %@ loc %d",query,range.location);
        
    }
    
    
    if (query.length >= [self.dataSource minimumCharactersToTrigger:self]) {
        
        NSArray *resultArray = [self resultArrayForQuery:query ignoreCase:self.ignoreCase];
        
        [self.dataSource inputView:self itemsFor:query ignoreCase:self.ignoreCase withResult:resultArray result:^(NSArray *items) {
            self.suggestionList = [items sortedArrayUsingSelector:@selector(compare:options:)];

            [self.suggestionListView reloadData];
        }];
        
    } else {
        self.suggestionList = nil;
        [self.suggestionListView reloadData];
    }
    
}

-(BOOL)shouldShowBarForText:(NSString *)text{
    
    BOOL shouldShow = NO;
    [self initiVars];
    if (text.length && ![text isEqualToString:@" "]) shouldShow = YES;
    
    return shouldShow;
    
}

-(void)initiVars{
    
    _leftString = nil;
    _rightString = nil;
    _range = NSMakeRange(0, 0);
    
}

-(UITextRange *)calculateSelectionRangeForTextFieldWithText:(NSString *)text{
    
    //UITextField *textField = [[UITextField alloc] initWithFrame:self.textField.frame];
    
    self.textField.text = text;
    
    UITextPosition *beginning = self.textField.beginningOfDocument;
    UITextPosition *start = [self.textField positionFromPosition:beginning offset:_range.location];
    UITextPosition *end = [self.textField positionFromPosition:start offset:_range.length];
    UITextRange *textRange = [self.textField textRangeFromPosition:start toPosition:end];
    
    //NSLog(@"range %d %d %@ %@ %@ %@",_range.length,_range.location, beginning.description,start.description,end.description,textRange.start.description);
    [self.textField setSelectedTextRange:textRange];
    return textRange;
    
    
}

-(NSArray *)resultArrayForQuery:(NSString *)query ignoreCase:(BOOL)ignoreCase{
    
    __block NSMutableArray *data = [NSMutableArray array];
    
    ^{
        NSArray *words = [query componentsSeparatedByString:@" "];
        
        for (NSString *s in self.dataSourceContent) {
            NSString *word = nil;
            if ([words count]>1) {
                word = words.lastObject;
                
            }
            else{
                word = query;
            }
            
            if (ignoreCase) {
                if ([s.lowercaseString hasPrefix:word.lowercaseString]) {
                    [data addObject:s];
                    
                }
            }
            else{
                
                if ([s hasPrefix:word]) {
                    [data addObject:s];
                    
                }
            }
            
        }
    }();
    
    
    return data;
    
}

@end
