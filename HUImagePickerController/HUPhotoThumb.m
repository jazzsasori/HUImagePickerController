//
//  HUPhotoThumb.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "HUPhotoThumb.h"

@implementation HUPhotoThumb
{
    BOOL          selected;
    NSDictionary *infoDict;
    UIImage      *img;
}


#pragma mark - initialize

- (id)init
{
    self = [super init];
    if (self)
    {
        // background color
        [self setBackgroundColor:[UIColor whiteColor]];
        // tap event listen
        [self setUserInteractionEnabled:YES];
    }
    return self;
}


#pragma mark - thumb view control

- (void)reset
{
    [self setAlpha:0.0f];
}

- (void)selectThumb
{
    selected = YES;
    [self setNeedsDisplay];
    [self.delegate selectThumb:infoDict];
}

- (void)deselectThumb
{
    selected = NO;
    [self setNeedsDisplay];
    [self.delegate deselectThumb:infoDict];
}

- (BOOL)isSelected
{
    return selected;
}


#pragma mark - draw methods

- (void)drawWithPhotoInfo:(NSDictionary *)photoInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        infoDict = photoInfo;
        img      = [photoInfo objectForKey:@"thumbnail"];
        selected = [(NSNumber *)[photoInfo objectForKey:@"selected"] boolValue];
        // draw
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAlpha:1.0f];
            [self setNeedsDisplay];
        });
    });
}

- (void)drawRect:(CGRect)rect
{
    [img drawInRect:rect];
    // selected Image
    if (selected)
    {
        [[UIImage imageNamed:@"Overlay"] drawInRect:rect];
    }
}


#pragma mark - tap event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate photoThumbTapped:infoDict withThumb:self];
}


#pragma mark - memory management

- (void)dealloc
{
    [self setDelegate:nil];
    infoDict = nil;
    img      = nil;
}

@end
