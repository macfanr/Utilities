//
//  DNTrackButton.m
//  NiceButton
//
//  Created by Xu Jun on 11/20/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNTrackButton.h"

@implementation DNTrackButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setButtonType:NSMomentaryChangeButton];
        
        if(! self.normalImage) self.normalImage = self.image;
        
        [self setupTrackArea];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
		[self setButtonType:NSMomentaryChangeButton];
        [self setupTrackArea];
    }
    return self;
}

- (void)setNormalImage:(NSImage *)anImage
{
    id temp = [anImage retain];
    [_normalImage release];
    _normalImage = temp;
    
    [self setImage:anImage];
}

- (void)setMousedownImage:(NSImage *)anImage
{
    id temp = [anImage retain];
    [_mousedownImage release];
    _mousedownImage = temp;
    
    [self setAlternateImage:anImage];
}

- (void)dealloc {
    for(NSTrackingArea *area in [self trackingAreas]) [self removeTrackingArea:area];
    
    self.mouseInImage = nil;
    self.normalImage = nil;
    [super dealloc];
}

- (void)setupTrackArea
{
    for(NSTrackingArea *area in [self trackingAreas]) [self removeTrackingArea:area];
    
	NSTrackingArea *trackArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                             options:NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways
                                               owner:self
                                            userInfo:nil];
	[self addTrackingArea:trackArea];
    
	[trackArea release];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	if(self.mouseInImage) {
		[self setImage:self.mouseInImage];
	}
}

- (void)mouseExited:(NSEvent *)theEvent
{
	if(self.normalImage) {
		[self setImage:self.normalImage];
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[self target] performSelector:[self action] withObject:self];
    [super mouseDown:theEvent];
}


@end
