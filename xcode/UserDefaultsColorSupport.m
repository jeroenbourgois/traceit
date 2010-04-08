//
//  UserDefaultsColorSupport.m
//  traceit
//
//  Created by Jeroen Bourgois on 29/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserDefaultsColorSupport.h"

@implementation NSUserDefaults(UserDefaultsColorSupport)

- (void)setColor:(NSColor *)color forKey:(NSString *)key
{
    NSData *theData=[NSArchiver archivedDataWithRootObject:color];
    [self setObject:theData forKey:key];
}

- (NSColor *)colorForKey:(NSString *)key
{
    NSColor *theColor=nil;
    NSData *theData=[self dataForKey:key];
    if (theData != nil)
        theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
    return theColor;
}

@end
