//
//  AppDelegate.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/1.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

