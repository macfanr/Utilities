//
//  NSImage+CGImage.h
//  DragLayer
//
//  Created by Danny on 11/18/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (CGImage)

//should release the return value
- (CGImageRef)CGImage;

//should release the return value
- (CGImageRef)CGGlassImage;

@end
