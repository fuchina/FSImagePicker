//
//  FSAsset.h
//  FSImagePicker
//
//  Created by FudonFuchina on 2020/3/29.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSAsset : NSProxy

@property (nonatomic,strong) PHAsset        *asset;
@property (nonatomic,strong) UIImage        *image;
@property (nonatomic,strong) NSDictionary   *info;
//@property (nonatomic,assign) BOOL           isMoreClear;
@property (nonatomic,assign) NSInteger      length;

@end

NS_ASSUME_NONNULL_END
