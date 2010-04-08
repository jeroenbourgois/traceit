//
//  LogItem.m
//  traceit
//
//  Created by Jeroen Bourgois on 28/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LogItem.h"

@implementation LogItem
- (id) init
{
	[super init];
	line = @"New Line";
	timestamp = @"00:00:00";
	return self;
}

- (id) initWithLogline: (NSString* ) logline
{
	self = [super init];
	line = logline;
	timestamp = @"00:00:00";
	return self;
}

- (void) dealloc
{
	[line release];
	[timestamp release];
	[super dealloc];
}

@synthesize line;
@synthesize timestamp;
@end
