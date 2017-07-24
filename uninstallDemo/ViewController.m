//
//  ViewController.m
//  uninstallDemo
//
//  Created by 陈志东 on 16/10/20.
//  Copyright © 2016年 Long5.self. All rights reserved.
//

#import "ViewController.h"
//#import <LSApplicationWorkspace.h>
#import <spawn.h>
#import <sys/wait.h>
#import <UIKit/UIKit.h>



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
//MobileInstallation.framwork需要自己从PrivateFrameworks复制出来，然后在Build Phase里手动link一下。
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


@interface ViewController ()

@property(nonatomic,strong)UIButton *uninsBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.uninsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.uninsBtn setFrame:CGRectMake(20, 50, 150, 50)];
    [self.uninsBtn setTitle:@"卸载" forState:UIControlStateNormal];
    self.uninsBtn.layer.borderColor = UIColor.greenColor.CGColor;
    self.uninsBtn.layer.borderWidth = 2;
    self.uninsBtn.backgroundColor = [UIColor redColor];
    [self.uninsBtn addTarget:self action:@selector(bgnUnIns) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.uninsBtn];
}


-(void)bgnUnIns{
    
//    Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
//    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *appList = [workspace performSelector:@selector(allApplications)];
//    NSLog(@"appList=%@",appList);
//
//    //- (_Bool)uninstallApplication:(id)arg1 withOptions:(id)arg2;
//    BOOL okflag=[workspace performSelector:@selector(uninstallApplication:withOptions:) withObject:@"www.fahuidai.com" withObject:nil];
//    NSLog(@"unintall>%@",okflag?@"Successful":@"Fail");
//    //以上利用LSApplicationWorkspace的uninstallApplication方法可以实卸载，但卸载后即使刷新的缓存，图标也消失不了，必须重启才能除去图标显示

  
    //用下面的方法，可以成功卸载并使图标也清除掉
    //只不过需从对应的armv7s.dyldb中导出MobileInstallation.framwork，然后再加入工程即可
    //此段代码执行完毕后，还需要等待10s左右，图标才会消失
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, "www.fahuidai.com", kCFStringEncodingUTF8);
    if (identifier != NULL) {
        MobileInstallationUninstallForLaunchServices(identifier, NULL, NULL, NULL);
        CFRelease(identifier);
    }
    
    uicache();
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
