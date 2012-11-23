//
//  DNLinkButton.m
//  NiceButton
//
//  Created by Xu Jun on 11/20/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNLinkButton.h"

@implementation DNLinkButton

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self) {
        [self setupTitleLinkStyleState];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        [self setupTitleLinkStyleState];
    }
    return self;
}


- (void)setupTitleLinkStyleState
{
    NSString *title = [[self cell] title];
    
    NSMutableAttributedString *attString = [[[NSMutableAttributedString alloc]initWithString:title] autorelease];
    
    NSRange attRange = NSMakeRange(0, [attString length]);
    
    [attString beginEditing];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:[NSColor colorWithCalibratedRed:0.01 green:0.1 blue:0.8086 alpha:1.0]
                      range:attRange];
    [attString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:NSSingleUnderlineStyle]
                      range:attRange];
    [attString endEditing];
    
    [self setAttributedTitle:attString];
    [self setBordered:NO];
    [self setButtonType:NSMomentaryChangeButton];
    [self sizeToFit];
}

- (void)resetCursorRects
{
    NSCursor *aCursor = [NSCursor pointingHandCursor];
    NSRect bounds = NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame));
    [self addCursorRect:bounds cursor:aCursor];
    [aCursor setOnMouseEntered:YES];;
}

- (void) setTitle:(NSString *)aString{
    [super setTitle:aString];
    [self setupTitleLinkStyleState];
}


@end
