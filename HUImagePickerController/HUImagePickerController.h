//
//  HUImagePickerController.h
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUImagePicker.h"

@interface HUImagePickerController : UINavigationController

@property (nonatomic, strong) HUIPC_CompleteCallback completeCallback;
@property (nonatomic, strong) HUIPC_ThumbTapCallback thumbTapCallback;
@property (nonatomic, assign) int                    maxSelectCount;

- (id)init;

@end
