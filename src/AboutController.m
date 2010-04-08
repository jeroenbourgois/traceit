//
//  AboutController.m
//  Trace It!
//
//  Created by Jeroen Bourgois on 13/10/09.
//  Copyright 2009 Jeroen Bourgois. All rights reserved.
//

#import "AboutController.h"


@implementation AboutController
- (id) init
{
	/*
	 if(![super initWithWindowNibName:@"About"])
		return nil;
	*/
	return self;
}

- (void) windowDidLoad
{
	/*
	NSLog(@"About box loaded");
	NSMutableString* bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSMutableString* buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildVersion"];
	NSMutableString* version =  [[NSMutableString alloc] initWithString:@"Version "];
	[version appendString:[NSString stringWithFormat:@"%@", buildVersion]];
	[version appendString:@" ("];
	[version appendString:[NSString stringWithFormat:@"%@", bundleVersion]];
	[version appendString:@")"];
	[versionLabel setStringValue: version];
	 */
}
@end
