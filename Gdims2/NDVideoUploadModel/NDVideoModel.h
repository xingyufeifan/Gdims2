//
//  ZXVideoModel.h
//  QCQF
//
//  Created by JuanFelix on 02/12/2017.
//  Copyright © 2017 screson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NDVideoModel : NSObject
@property (nonatomic,assign) BOOL zx_checked;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong,readonly) NSURL * zx_videoUrl;

+ (NSMutableArray <NDVideoModel *> *)cacheList;
- (void)save;
- (void)clearCache;

@end
