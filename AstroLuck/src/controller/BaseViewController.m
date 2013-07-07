//
//  BaseViewController.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#ifdef simulate_memory_warn
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }else {
        NSLog(@"%@",@"Whoops UIApplication no loger responds to -_performMemoryWarning");
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    float sysVersion =[[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVersion < 6.0f) return;
    // 是否是正在使用的视图
    if ([self.view window] == nil){
        // Add code to preserve data stored in the views that might be
        // needed later.
        [self viewDidUnload];
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

-(void)viewDidUnload
{
    NSLog(@"%@ 开始释放",NSStringFromClass([self class]));
    [super viewDidUnload];
}

-(void)dealloc
{
    NSLog(@"%@ 完全释放",NSStringFromClass([self class]));
    [super dealloc];
}

@end
