//
//  DDView.h
//  Drag & Drop
//
//  Created by Xu Jun on 8/31/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DDViewProtocol;

@interface DDView : NSView {
    id <DDViewProtocol> delegate;
@private
    BOOL    _init;
}

@property (nonatomic, assign) IBOutlet id <DDViewProtocol> delegate;

@end

@protocol DDViewProtocol <NSObject>
@required

- (NSArray*)fileTypeOfDragging:(id)sender;
- (BOOL)performDragging:(NSArray*)validfilePaths inView:(id)sender;

@optional

- (void)draggingWillBegin:(id)sender;
- (void)draggingDidFinished:(id)sender;

@end
