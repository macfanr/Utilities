//
//  DNPopupView.m
//  PopupWindow
//
//  Created by Xu Jun on 11/1/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNPopupView.h"
#import <QuartzCore/QuartzCore.h>

@interface PopupViewCloseButton : NSButton

@end

@implementation PopupViewCloseButton

- (void)drawRect:(CGRect)rect
{
#define kCloseBtnDiameter 25
#define kDefaultMargin 18
    CGContextRef ctx = [[NSGraphicsContext currentContext]graphicsPort];
    
    CGColorRef (^CGColorMake)(float,float,float,float) = ^CGColorRef(float r, float g, float b, float alpha) {
        CGColorRef color = CGColorCreateGenericRGB(r, g, b, alpha);
        return color;
    };
    
    CGContextAddEllipseInRect(ctx, CGRectOffset(rect, 0, 0));
    CGFloat colorFill1[] = {0.66,0.66,0.66,1};
    CGContextSetFillColor(ctx, colorFill1);
    CGContextFillPath(ctx);
    
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 1, 1));
    CGFloat colorFill2[] = {0.3,0.3,0.3,1};
    CGContextSetFillColor(ctx, colorFill2);
    CGContextFillPath(ctx);
    
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, 4, 4));
    CGFloat colorFill3[] = {1,1,1,1};
    CGContextSetFillColor(ctx, colorFill3);
    CGContextFillPath(ctx);
    
    CGColorRef colorFill4 = CGColorMake(0.2,0.2,0.2,1);
    CGContextSetStrokeColorWithColor(ctx, colorFill4); CGColorRelease(colorFill4);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4+1); //start at this point
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4*3+1); //draw to this point
    CGContextStrokePath(ctx);
    
    CGColorRef colorFill5 = CGColorMake(0.2,0.2,0.2,1);
    CGContextSetStrokeColorWithColor(ctx, colorFill5); CGColorRelease(colorFill5);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextMoveToPoint(ctx, kCloseBtnDiameter/4*3+1,kCloseBtnDiameter/4+1); //start at this point
    CGContextAddLineToPoint(ctx, kCloseBtnDiameter/4+1,kCloseBtnDiameter/4*3+1); //draw to this point
    CGContextStrokePath(ctx);
}

@end

@implementation DNPopupView

@synthesize contentSize;

#define kShowAnimation  1
#define kHideAnimation  2

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _setup];
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    
    return self;
}

- (CGPathRef)_newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}

- (void)_createContentLayer
{
    CALayer *rootLayer = [CALayer layer];
    CGColorRef color = NULL;
    
    rootLayer.cornerRadius = 6;
    rootLayer.frame = CGRectMake((NSWidth(self.frame) - contentSize.width)/2.0,
                                 (NSHeight(self.frame) - contentSize.height)/2.0,
                                 contentSize.width, contentSize.height);
    
    color = CGColorCreateGenericGray(0.7, 0.3);
    rootLayer.backgroundColor = color; CGColorRelease(color);
    
    color = CGColorCreateGenericGray(0.7, 0.2);
    rootLayer.borderColor = color; CGColorRelease(color);
    rootLayer.borderWidth = 2;
    
    CGPathRef path = [self _newPathForRoundedRect:rootLayer.bounds radius:rootLayer.cornerRadius];
    color = CGColorCreateGenericRGB(0.1, 0.1, 0.1, 0.2);
    rootLayer.shadowRadius = 3;
    rootLayer.shadowOpacity = 0.5;
    rootLayer.shadowOffset = CGSizeMake(2, 2);
    rootLayer.shadowPath = path; CGPathRelease(path);
    rootLayer.shadowColor = color; CGColorRelease(color);
    
    //color = CGColorCreateGenericGray(0.01, 0.05);
    //self.layer.backgroundColor = color; CGColorRelease(color);
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.layer.position = self.layer.superlayer.position;
    
    [self.layer addSublayer:rootLayer];
    
}

- (void)_setup
{
    dispatch_once(&onceToken, ^{
        [self setWantsLayer:YES];
        contentSize = NSInsetRect(self.bounds, 10, 10).size;
    });
}

- (void)_showAnimation:(CALayer*)aLayer
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(aLayer.transform, 0.01, 0.01, 0.01)];
    animation1.toValue = [NSValue valueWithCATransform3D:aLayer.transform];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"hidden"];
    animation2.fromValue = [NSNumber numberWithFloat:1];
    animation2.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animation1, animation2, nil];
    group.removedOnCompletion = YES;
    group.delegate = self;
    group.duration = .25f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animationTag = kShowAnimation;
    
    [aLayer addAnimation:group forKey:@"show"];
}

- (void)_hideAnimation:(CALayer*)aLayer
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.fromValue = [NSValue valueWithCATransform3D:aLayer.transform];
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(aLayer.transform, 0.01, 0.01, 0.01)];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"hidden"];
    animation2.fromValue = [NSNumber numberWithFloat:0];
    animation2.toValue = [NSNumber numberWithFloat:0.8];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.animations = [NSArray arrayWithObjects:animation1, animation2, nil];
    group.duration = .25f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animationTag = kHideAnimation;
    
    [aLayer addAnimation:group forKey:@"hide"];
}

- (void)_createCloseButton
{
    PopupViewCloseButton *closeButton = [[PopupViewCloseButton alloc]initWithFrame:NSMakeRect(0, 0, 25, 25)];
    [closeButton setFrameOrigin:NSMakePoint(contentSize.width- NSWidth(closeButton.frame) - 3 + (NSWidth(self.frame) - contentSize.width)/2.0,
                                            contentSize.height - NSHeight(closeButton.frame) - 3 + (NSHeight(self.frame) - contentSize.height)/2.0)];
    [self addSubview:closeButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(dismiss)];
    [closeButton release];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (animationTag == kShowAnimation) {
        [[self window] makeFirstResponder:self];
    }
    else if (animationTag == kHideAnimation) {
        [self removeFromSuperview];
    }
}

- (void)showInView:(NSView*)aView
{
    [self _createContentLayer];
    [self _createCloseButton];
    [aView addSubview:self];
    //[self _showAnimation:self.layer];
}

- (void)dismiss
{
    [self.layer removeAllAnimations];
    [self _hideAnimation:self.layer];
}


#pragma mark - mouse event
- (void)mouseDown:(NSEvent *)theEvent {}
- (void)mouseUp:(NSEvent *)theEvent {}

- (void)keyDown:(NSEvent *)theEvent
{
    if([theEvent keyCode] == 53) {
        [self dismiss];
    }
}

- (BOOL)acceptsFirstResponder {return YES;}

@end
