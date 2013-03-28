//
//  HUImagePickerController.h
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HUPhotoCell.h"


/// define
@class HUImagePickerController;
@class HUPhotoThumb;
typedef NS_ENUM(NSInteger, HUIPC_LIST)
{
    HUIPC_LIST_ALBUM,
    HUIPC_LIST_PHOTOS
};
typedef void (^HUIPC_CompleteCallback)(HUImagePickerController *navController, NSArray *assets);
typedef void (^HUIPC_ThumbTapCallback)(HUImagePickerController *navController, HUPhotoThumb *thumb, ALAsset *selectedAsset);


/// interface
@interface HUImagePicker : UITableViewController <HUPhotoCellDelegate>

@property (nonatomic, strong) NSArray                *data;
@property (nonatomic, strong) NSArray                *photos;
@property (nonatomic, strong) NSMutableArray         *selectedIndexes;
@property (nonatomic, strong) ALAssetsLibrary        *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup          *albumGroup;
@property (nonatomic, weak  ) HUIPC_CompleteCallback  completeCallback;
@property (nonatomic, assign) HUIPC_ThumbTapCallback  thumbTapCallback;
@property (nonatomic, assign) int                     maxSelectCount;

@end

