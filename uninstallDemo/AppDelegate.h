//
//  AppDelegate.h
//  uninstallDemo
//
//  Created by 陈志东 on 16/10/20.
//  Copyright © 2016年 Long5.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

