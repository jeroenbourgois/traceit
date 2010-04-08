//
//  LogItem.h
//  traceit
//
//  Created by Jeroen Bourgois on 28/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogItem : NSObject {
	NSString *line;
	NSString *timestamp;
}

- (id) initWithLogline: (NSString *) logline;

@property (readwrite, copy) NSString *line;
@property (readwrite, copy)	NSString *timestamp;

@end
