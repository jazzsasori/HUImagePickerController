//
//  HUPhotoThumb.h
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

/// delegate
@class HUPhotoThumb;
@protocol HUPhotoThumbDelegate <NSObject>
- (void)photoThumbTapped:(NSDictionary *)photoInfo withThumb:(HUPhotoThumb *)thumb;
- (void)     selectThumb:(NSDictionary *)photoInfo;
- (void)   deselectThumb:(NSDictionary *)photoInfo;
@end

/// define

/// interface
@interface HUPhotoThumb : UIView
@property (nonatomic, assign) id <HUPhotoThumbDelegate> delegate;
- (id)init;
- (void)drawWithPhotoInfo:(NSDictionary *)photoInfo;
- (void)reset;
- (void)selectThumb;
- (void)deselectThumb;
- (BOOL)isSelected;
@end
