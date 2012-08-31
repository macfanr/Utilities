//
//  DDView.m
//  Drag & Drop
//
//  Created by Xu Jun on 8/31/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DDView.h"

@implementation DDView

@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self initPrivateOnce];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initPrivateOnce];
    }
    
    return self;
}

- (void)initPrivateOnce
{
    if(!_init) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        _init = YES;
    }
}

#pragma mark NSDraggingDestination

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if(! [[self window]attachedSheet])
    {
        NSPasteboard *pasteBoard = [sender draggingPasteboard];
        
        if([[pasteBoard types]containsObject:NSFilenamesPboardType]) {
            if(delegate && [delegate respondsToSelector:@selector(draggingWillBegin:)])[delegate draggingWillBegin:self];
            return NSDragOperationCopy;
        }
    }

    return NSDragOperationNone;
}

//- (void)draggingExited:(id <NSDraggingInfo>)sender
//{
//    if(delegate && [delegate respondsToSelector:@selector(draggingDidFinished:)]) [delegate draggingDidFinished:self];
//}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    if(delegate && [delegate respondsToSelector:@selector(draggingDidFinished:)]) [delegate draggingDidFinished:self];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    NSArray *filePaths = [pasteBoard propertyListForType:NSFilenamesPboardType];
    NSArray *supportFileType = [delegate fileTypeOfDragging:self];
    
    if(!supportFileType) return NO;
    
    for(NSString *filePath in filePaths) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", [[filePath pathExtension]lowercaseString]];
        if([[supportFileType filteredArrayUsingPredicate:predicate] count] > 0) {

            return YES;
        }
    }

    return NO;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSMutableArray *validfilePaths = [NSMutableArray array];
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    NSArray *filePaths = [pasteBoard propertyListForType:NSFilenamesPboardType];
    NSArray *supportFileType = [delegate fileTypeOfDragging:self];
    
    if(!supportFileType) return NO;
    
    for(NSString *filePath in filePaths) {
        if([supportFileType containsObject:[filePath pathExtension]]) {
            [validfilePaths addObject:filePath];
        }
    }
    if([validfilePaths count])
        return [delegate performDragging:validfilePaths inView:self];
    
    return NO;
}

@end
