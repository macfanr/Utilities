//
//  DNPopupView.h
//  PopupWindow
//
//  Created by Xu Jun on 11/1/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DNPopupView : NSView {
    dispatch_once_t onceToken;
    NSUInteger      animationTag;
}

- (void)showInView:(NSView*)aView;

@end
