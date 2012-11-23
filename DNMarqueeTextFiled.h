//
//  DNMarqueeTextFiled.h
//  MarqueeTextFiled
//
//  Created by Xu Jun on 11/22/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DNMarqueeLabel : NSTextField {
@private
    NSTextField *labels[2];
    NSTimer     *timer;
    int         flag;
}

@end
