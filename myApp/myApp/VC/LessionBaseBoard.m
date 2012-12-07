//
//  LessionBaseBoard.m
//  myApp
//
//  Created by again on 12/7/12.
//  Copyright (c) 2012 again. All rights reserved.
//

#import "LessionBaseBoard.h"

@interface LessionBaseBoard ()

@end

@implementation LessionBaseBoard

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

DEF_SINGLETON( LessionBaseBoard );

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
			_textView = [[BeeUITextView alloc] initWithFrame:CGRectInset(self.viewBound, 5.0f, 5.0f)];
			_textView.font = [UIFont boldSystemFontOfSize:12.0f];
			_textView.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
			_textView.editable = NO;
			[self.view addSubview:_textView];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
			SAFE_RELEASE_SUBVIEW( _textView );
		}
	}
	
	[self updateText];
}

- (void)updateText
{
#if __BEE_DEVELOPMENT__
	NSMutableString * text = [NSMutableString string];
	for ( NSUInteger i = 0; i < self.signals.count; ++i )
	{
		BeeUISignal * signal = [self.signals objectAtIndex:i];
		[text appendFormat:@"[%d] %@\n", self.signalSeq, signal.name];
	}
    
	_textView.text = text;
	_textView.scrollEnabled = YES;
	_textView.showsVerticalScrollIndicator = YES;
	[_textView flashScrollIndicators];
#endif	// #ifdef __BEE_DEVELOPMENT__
}


@end
