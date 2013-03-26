//
//  HUImagePickerController.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "HUImagePickerController.h"

@interface HUImagePickerController ()

@end

@implementation HUImagePickerController
{
    HUImagePicker *rootViewController;
}

- (id)init
{
    // create HUImagePicker
    rootViewController = [[HUImagePicker alloc] initWithNibName:@"HUImagePicker" bundle:nil];
    // init
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
    }
    
    return self;
}

@end
