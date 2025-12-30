//
//  WY_YNTextField.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/11/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_YNTextField.h"

@implementation WY_YNTextField

- (void)deleteBackward {
    //    ！！！这里要调用super方法，要不然删不了东西
    
    [super deleteBackward];
    
    if ([self.yn_delegate respondsToSelector:@selector(WY_YNTextFieldDeleteBackward:)]) {
        [self.yn_delegate WY_YNTextFieldDeleteBackward:self];
        
    }
    
}

- (NSRange) selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);    
}
@end
