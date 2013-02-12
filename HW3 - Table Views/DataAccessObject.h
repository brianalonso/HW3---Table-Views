//
//  DataAccessObject.h
//  HW3 - Table Views
//
//  Created by Brian Alonso on 2/8/13.
//  Copyright (c) 2013 Brian Alonso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessObject : NSObject

// Public methods
- (id)initWithLibraryName:(NSString *)libraryName;
- (NSDictionary *)libraryItemAtIndex:(int)index;
- (int)libraryCount;
- (NSArray *)libraryKeys;
- (NSArray *)libraryNames;
- (NSDictionary *)libraryItemForKey:(NSString *)key;
@end
