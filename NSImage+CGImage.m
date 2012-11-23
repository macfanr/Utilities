//
//  NSImage+CGImage.m
//  DragLayer
//
//  Created by Danny on 11/18/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "NSImage+CGImage.h"

@implementation NSImage (CGImage)

- (CGImageRef)CGImage
{
    NSSize imageSize = [self size];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [self drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    return cgImage;
}

- (CGImageRef)CGGlassImage
{
    NSSize imageSize = [self size];
    CGContextRef context = CGBitmapContextCreate(NULL/*data - pass NULL to let CG allocate the memory*/,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 8,
                                                 0,
                                                 [[NSColorSpace genericRGBColorSpace] CGColorSpace],
                                                 kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO]];
	[NSGraphicsContext restoreGraphicsState];
    
    CGImageRef _CGImage = [self CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), _CGImage);
    CGImageRelease(_CGImage);
    
	CGContextMoveToPoint(context, 0.0, imageSize.height * 0.2);
    CGContextAddLineToPoint(context, 0.0, imageSize.height);
    CGContextAddLineToPoint(context, imageSize.width, imageSize.height);
    CGContextAddLineToPoint(context, imageSize.width, imageSize.height * 0.9);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGFloat grad_color[]={
        1.0,1.0,1.0,0.2,//start
        1.0,1.0,1.0,0.0//end
    };
    CGFloat location[] = {0.0,1.0};
    
    CGColorSpaceRef color_spc = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad = CGGradientCreateWithColorComponents(color_spc, grad_color, location, 2);
    CGContextDrawLinearGradient(context,
                                grad,
                                CGPointMake(0.0, imageSize.height),
                                CGPointMake(imageSize.width * 0.3, 0.0),
                                0);
    CGGradientRelease(grad);
    CGColorSpaceRelease(color_spc);
    
	CGImageRef rslt = CGBitmapContextCreateImage(context);
    
	CGContextRelease(context);
    
	return rslt;
}

@end
