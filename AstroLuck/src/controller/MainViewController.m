//
//  MainViewController.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "MainViewController.h"
#import "AstroDayView.h"

@interface MainViewController ()
{
    SwipeView *_swipeView;
    UIPageControl *_pageControl;
}

@property (nonatomic, retain) SwipeView *swipeView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *colors;

@end

@implementation MainViewController
@synthesize swipeView = _swipeView;
@synthesize pageControl = _pageControl;
@synthesize colors = _colors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.colors = [NSMutableArray array];
        for (int i = 0; i < 12; i++)
        {
            [self.colors addObject:[UIColor colorWithRed:rand()/(float)RAND_MAX
                                                   green:rand()/(float)RAND_MAX
                                                    blue:rand()/(float)RAND_MAX
                                                   alpha:1.0f]];
        }
    }
    return self;
}


-(void)dealloc
{
    self.pageControl = nil;
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
    self.swipeView = nil;
    self.colors = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _swipeView = [[SwipeView alloc]initWithFrame:self.view.bounds];
    //configure swipe view
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.pagingEnabled = YES;
    _swipeView.wrapEnabled = NO;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
    [self.view addSubview:_swipeView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-68, 320, 36)];
    //configure page control
    _pageControl.numberOfPages = _swipeView.numberOfPages;
    _pageControl.defersCurrentPageDisplay = YES;
    [self.view addSubview:_pageControl];
}

-(void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.colors count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    AstroDayView *dayView = (AstroDayView *)view;
    //create or reuse view
    if (dayView == nil)
    {
        //        label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)] autorelease];
        dayView = [[[AstroDayView alloc]initWithFrame:self.view.bounds]autorelease];
        view = dayView;
    }
    
    //configure view
    dayView.label.backgroundColor = [self.colors objectAtIndex:index];
    dayView.label.text = [NSString stringWithFormat:@"%i", index];
    
    //return view
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    //update page control page
    _pageControl.currentPage = swipeView.currentPage;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected item at index %i", index);
}


@end
