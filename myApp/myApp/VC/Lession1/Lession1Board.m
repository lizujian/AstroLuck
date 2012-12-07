//
//  Lession1Board.m
//  myApp
//
//  Created by again on 12/7/12.
//  Copyright (c) 2012 again. All rights reserved.
//

#import "Lession1Board.h"
#import "LeveyTabBarController.h"

@interface Lession1Board ()

@end

@implementation Lession1Board

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)load
{
    [super load];
    _viewControllers = [[NSMutableArray alloc] init];
	[_viewControllers addObject:[NSArray arrayWithObjects:@"weibo_homeBoard", @"home", nil]];
	[_viewControllers addObject:[NSArray arrayWithObjects:@"weibo_mentionBoard", @"Mention", nil]];
	[_viewControllers addObject:[NSArray arrayWithObjects:@"weibo_discoverBoard", @"Discover", nil]];
	[_viewControllers addObject:[NSArray arrayWithObjects:@"weibo_MeBoard", @"Me", nil]];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic setObject:[UIImage imageNamed:@"ic_tab_home_default.png"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"ic_tab_home_selected.png"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic2 setObject:[UIImage imageNamed:@"ic_tab_at_default.png"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"ic_tab_at_selected.png"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:2];
    [imgDic3 setObject:[UIImage imageNamed:@"ic_tab_hash_default.png"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"ic_tab_hash_selected.png"] forKey:@"Seleted"];
    _images = [[NSMutableArray alloc] init];
    [_images addObject:imgDic];
    [_images addObject:imgDic2];
    [_images addObject:imgDic3];
}

-(void)unload
{
    [_images removeAllObjects];
    [_images release];
    [_viewControllers removeAllObjects];
    [_viewControllers release];
    [super unload];
}

// Other signal goes here
- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

// BeeUIBoard signal goes here
- (void)handleBeeUIBoard:(BeeUISignal *)signal
{
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		// 界面创建
//        LeveyTabBarController *tabbarVC = [[LeveyTabBarController alloc]initWithViewControllers:_viewControllers imageArray:_images];
		[self setTitleString:@"Lession 1"];
		[self showNavigationBarAnimated:NO];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		// 界面删除
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		// 界面重新布局
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		// 数据加载
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
		// 数据释放
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		// 将要显示
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		// 已经显示
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		// 将要隐藏
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
		// 已经隐藏
	}
}

@end
