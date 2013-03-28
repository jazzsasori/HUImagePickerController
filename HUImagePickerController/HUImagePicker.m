//
//  HUImagePickerController.m
//  HUImagePickerControllerDemo
//
//  Created by jazzsasori on 2013/03/26.
//  Copyright (c) 2013年 jazzsasori. All rights reserved.
//

#import "HUImagePicker.h"
#import "HUImagePickerController.h"

@interface HUImagePicker ()

@end

@implementation HUImagePicker


#pragma mark - asset process

- (UIImage *)imageFromAsset:(ALAsset *)asset
{
    if (asset == nil) return nil;
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    return [UIImage imageWithCGImage:[representation fullResolutionImage]];
}


#pragma mark - initialize methods

- (void)complete
{
    // get selected images
    NSMutableArray *images = [NSMutableArray array];
    for (NSNumber *index in self.selectedIndexes)
    {
        UIImage *img = [self imageFromAsset:[self.photos objectAtIndex:[index intValue]]];
        if (img == nil) continue;
        [images addObject:img];
    }
    
    // callback
    HUImagePickerController *ipc = (HUImagePickerController *)self.navigationController;
    ipc.completeCallback(ipc, images);
}

- (void)addCompleteButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"complete"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(complete)];
    [self.navigationItem setRightBarButtonItem:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize
    [self setSelectedIndexes:[NSMutableArray array]];
    
    // View List
    if ([self listMode] == HUIPC_LIST_ALBUM)
    {
        [self viewAlbumList];
    }
    else
    {
        [self addCompleteButton];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self viewPhotoList:self.albumGroup];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Album list, Image list process

- (ALAssetsLibrary *)sharedAssetsLibrary
{
    if (self.assetsLibrary == nil)
    {
        [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];
    }
    
    return self.assetsLibrary;
}

- (HUIPC_LIST)listMode
{
    return (self.albumGroup == nil) ? HUIPC_LIST_ALBUM : HUIPC_LIST_PHOTOS;
}

- (void)viewAlbumList
{
    // return list
    NSMutableArray  *albums = [NSMutableArray array];
    // get album list
    [[self sharedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // アルバムが無い場合はgroupがNULL
        if (!group) return ;
        // 写真のみ取得するフィルター
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [albums addObject:group];
        [self setData:albums];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewPhotoList:(ALAssetsGroup *)group
{
    // initialize
    NSMutableArray *photos   = [NSMutableArray array];
    // get ALAssets from selected album
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (!result) return ;
        // add result
        [photos addObject:result];
        [self setPhotos:photos];
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self listMode] == HUIPC_LIST_ALBUM) ? [self.data count] : ceil((CGFloat)[self.photos count] / TILED_PHOTO_COUNT);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self listMode] == HUIPC_LIST_ALBUM)
    {
        // album
        static NSString *CellIdentifier = @"AlbumCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // show album info
        ALAssetsGroup *group = [self.data objectAtIndex:indexPath.row];
        // album name
        [cell.textLabel setText:[group valueForProperty:ALAssetsGroupPropertyName]];
        // album poster image
        [cell.imageView setImage:[UIImage imageWithCGImage:group.posterImage]];
        
        return cell;
    }
    else
    {
        // photos
        static NSString *CellIdentifier = @"PhotoCell";
        HUPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[HUPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // get photos
        NSMutableArray *photos = [NSMutableArray array];
        int start = indexPath.row * TILED_PHOTO_COUNT;
        int end   = start         + TILED_PHOTO_COUNT;
        for (int i=start; i<end; i++)
        {
            if (i >= [self.photos count]) continue;
            // index number
            NSNumber *index = [NSNumber numberWithInt:i];
            // addPhotos
            ALAsset *asset = [self.photos objectAtIndex:i];
            [photos addObject:@{
             @"thumbnail": [UIImage imageWithCGImage:[asset thumbnail]],
             @"url"      : (NSURL *)[asset valueForProperty:ALAssetPropertyAssetURL],
             @"indexPath": [NSIndexPath indexPathForRow:indexPath.row inSection:i],
             @"index"    : index,
             @"selected" : [NSNumber numberWithBool:([self.selectedIndexes containsObject:index]) ? YES : NO],
             }];
        }
        // show photos
        [cell setDelegate:self];
        [cell viewPhotos:photos];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return THUMB_SIZE + THUMB_MARGIN;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self listMode] == HUIPC_LIST_ALBUM)
    {
        // show photo list
        HUImagePicker *ipc = [[HUImagePicker alloc] initWithNibName:@"HUImagePicker" bundle:nil];
        [ipc     setAlbumGroup:[self.data objectAtIndex:indexPath.row]];
        [ipc setMaxSelectCount:self.maxSelectCount];
        [self.navigationController pushViewController:ipc animated:YES];
    }
}


#pragma mark - HUPhotoCellDelegateMethods

- (void)photoTapped:(NSDictionary *)photoInfo withThumb:(HUPhotoThumb *)thumb
{
    // selected image
    ALAsset *asset = [self.photos objectAtIndex:[[photoInfo objectForKey:@"index"] intValue]];
    UIImage *image = [self imageFromAsset:asset];
    // callback
    HUImagePickerController *ipc = (HUImagePickerController *)self.navigationController;
    ipc.thumbTapCallback((HUImagePickerController *)self.navigationController, thumb, image);
}

- (void)selectThumb:(NSDictionary *)photoInfo
{
    [self.selectedIndexes addObject:[photoInfo objectForKey:@"index"]];
}

- (void)deselectThumb:(NSDictionary *)photoInfo
{
    [self.selectedIndexes removeObject:[photoInfo objectForKey:@"index"]];
}


#pragma mark - memory management

- (void)dealloc
{
    [self             setData:nil];
    [self           setPhotos:nil];
    [self    setAssetsLibrary:nil];
    [self       setAlbumGroup:nil];
    [self setCompleteCallback:nil];
    [self setThumbTapCallback:nil];
}

@end
