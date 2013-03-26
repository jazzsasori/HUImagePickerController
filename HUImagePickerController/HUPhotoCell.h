//
//  PhotoCell.h
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HUPhotoThumb.h"

/// define
#define TILED_PHOTO_COUNT  4
#define THUMB_MARGIN       4.0f
#define THUMB_SIZE        75.0f

/// delegate
@protocol HUPhotoCellDelegate <NSObject>
- (void)  photoTapped:(NSDictionary *)photoInfo withThumb:(HUPhotoThumb *)thumb;
- (void)  selectThumb:(NSDictionary *)photoInfo;
- (void)deselectThumb:(NSDictionary *)photoInfo;
@end

/// interface
@interface HUPhotoCell : UITableViewCell <HUPhotoThumbDelegate>
@property (nonatomic, assign) id <HUPhotoCellDelegate> delegate;
- (void)viewPhotos:(NSArray *)photos;
@end

