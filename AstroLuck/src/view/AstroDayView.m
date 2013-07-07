//
//  AstroDayView.m
//  AstroLuck
//
//  Created by LiZujian on 13-6-22.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "AstroDayView.h"

@implementation AstroDayView
@synthesize label;


-(void)dealloc
{
    self.label = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    label.frame = self.bounds;
}

@end
