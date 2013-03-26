//
//  PhotoCell.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "HUPhotoCell.h"

@implementation HUPhotoCell
{
    NSArray *thumbViews;
}


#pragma mark - thumb view process

- (NSArray *)sharedThumbViewArray
{
    if ([thumbViews count] == 0)
    {
        NSMutableArray *thumbArray = [NSMutableArray array];
        for (int i=0; i<TILED_PHOTO_COUNT; i++)
        {
            // create thumb view
            HUPhotoThumb *thumb = [[HUPhotoThumb alloc] init];
            [thumb setDelegate:self];
            // frame set
            [thumb setFrame:CGRectMake((THUMB_MARGIN * (i+1)) + (THUMB_SIZE * i),
                                        THUMB_MARGIN,
                                        THUMB_SIZE,
                                        THUMB_SIZE)];
            [self addSubview:thumb];
            // add
            [thumbArray addObject:thumb];
        }
        thumbViews = thumbArray;
    }
    
    // reset thumb views
    for (HUPhotoThumb *t in thumbViews)
    {
        [t reset];
    }

    return thumbViews;
}


#pragma mark - initialize

- (void)viewPhotos:(NSArray *)photos
{
    // set cell selection style
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // thumb views
    thumbViews = [self sharedThumbViewArray];
    // init photos
    for (int i=0; i<[photos count]; i++)
    {
        HUPhotoThumb *thumb = [thumbViews objectAtIndex:i];
        [thumb drawWithPhotoInfo:[photos objectAtIndex:i]];
    }
}


#pragma mark - HUPhotoThumbDelegate methods

- (void)photoThumbTapped:(NSDictionary *)photoInfo withThumb:(HUPhotoThumb *)thumb
{
    [self.delegate photoTapped:photoInfo withThumb:thumb];
}

- (void)selectThumb:(NSDictionary *)photoInfo
{
    [self.delegate selectThumb:photoInfo];
}

- (void)deselectThumb:(NSDictionary *)photoInfo
{
    [self.delegate deselectThumb:photoInfo];
}


#pragma mark - memory management

- (void)dealloc
{
    [self setDelegate:nil];
}

@end
