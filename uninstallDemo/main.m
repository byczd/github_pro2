//
//  main.m
//  uninstallDemo
//
//  Created by 陈志东 on 16/10/20.
//  Copyright © 2016年 Long5.self. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <spawn.h>
#import <sys/wait.h>



/*!
 *  @brief  Mobile Installation 的回调定义
 */

typedef void (*MobileInstallationCallback)(CFDictionaryRef information);

/*!
 *  @brief  Mobile Installation 卸载App (8.0)
 *  @param  bundleIdentifier    App的Bundle ID
 *  @param  parameters          unknown
 *  @param  callback            Mobile Installation 的回调
 *  @param  unknown             unknown
 */
extern int MobileInstallationUninstallForLaunchServices(CFStringRef bundleIdentifier, CFDictionaryRef parameters, MobileInstallationCallback callback, void *unknown) NS_AVAILABLE_IOS(8_0);
//需要添加私有的：MobileInstallation.framwork
//MobileInstallation.framwork需要自己从PrivateFrameworks复制出来(注意要复制到本工程目录下再引用，而不是直接从PrivateFrameworks里引用)，然后在Build Phase里手动link一下。
//这个安装和卸载的方法是iOS的私有方法，在MobileInstallation里实现的，你还需要签上MobileInstallation的entitlements。
extern char **environ;

void uicache(void);
void uicache(void){
    posix_spawnattr_t attr;
    posix_spawn_file_actions_t fact;
    pid_t pid;
    char cmd[]="uicache";
    char *args[2];
    args[0]=cmd;
    args[1]=NULL;
    posix_spawnattr_init(&attr);
    posix_spawn_file_actions_init(&fact);
    posix_spawn(&pid,"/usr/bin/uicache",&fact,&attr,args,environ);
    int stat=0;
    waitpid(pid,&stat,0);
    
}


int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        NSString *datPath=@"/var/touchelf/res/theUninsPack.dat";
        NSString *spackName = [NSString stringWithContentsOfFile:datPath encoding:NSUTF8StringEncoding error:nil]; //NSASCIIStringEncoding
        NSLog(@"--------spackName=%@",spackName);
        if ([spackName length]>0){
            //char*-->CFStringRef
        //CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, "www.fahuidai.com", kCFStringEncodingUTF8);
            //NSString*-->CFStringRef
            #pragma mark - Uninstall
            CFStringRef identifier =(__bridge CFStringRef)spackName;
            if (identifier != NULL) {
                //int ibk=
                MobileInstallationUninstallForLaunchServices(identifier, NULL, NULL, NULL);
                NSLog(@"-----MobileInstallationUninstallForLaunchServices-over");
                //CFRelease(identifier);//不要加此句，否则自动退出会出现崩溃
            }
            
            #pragma mark - UICache
            uicache();
            NSLog(@"-----MobileInstallationUninstallForLaunchServices--uicache-over");
            //成功后将状态写入以便lua判断是否完毕(后面实测，其实不需要，只要执行了此app功能后适当延时即可)
//            NSString *OKData=@"OK";
//            BOOL saveSuccess=[OKData writeToFile:datPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            NSLog(@"-----MobileInstallationUninstallForLaunchServices--saveOver=%@",saveSuccess?@"OK":@"FAIL");
        }
        //return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
   return 0;
    
}
