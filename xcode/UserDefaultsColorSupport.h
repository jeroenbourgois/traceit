//
//  UserDefaultsColorSupport.h
//  traceit
//
//  Created by Jeroen Bourgois on 29/01/10.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults(UserDefaultsColorSupport)
	- (void) setColor:(NSColor *)color forKey:(NSString *) key;
	- (NSColor *) colorForKey:(NSString *) key;
@end
