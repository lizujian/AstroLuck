//
//  CatelogBoard.h
//  myApp
//
//  Created by again on 12/7/12.
//  Copyright (c) 2012 again. All rights reserved.
//

#import "Bee_UITableBoard.h"
#import "Bee.h"

#pragma mark -

@interface CatelogCell : BeeUIGridCell
{
	BeeUILabel *		_title;
	BeeUILabel *		_intro;
}
@end

@interface CatelogBoard : BeeUITableBoard
{
    NSMutableArray * _lessions;
}

@end
