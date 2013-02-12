//
//  DataAccessObject.m
//  HW3 - Table Views
//
//  Created by Brian Alonso on 2/8/13.
//  Copyright (c) 2013 Brian Alonso. All rights reserved.
//

#import "DataAccessObject.h"

@interface DataAccessObject()

// Private Outlets/Properties
@property (nonatomic, strong) NSString *libraryPlist;
@property (nonatomic, strong) NSArray *libraryContent;

@property (copy, nonatomic) NSDictionary *stateDict;
@property (copy, nonatomic) NSArray *keys;

@end

@implementation DataAccessObject{
    
}

- (id)initWithLibraryName:(NSString *)libraryName {
    if (self = [super init]) {
        self.libraryPlist = libraryName;
        
        NSArray *contentArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                                      pathForResource:self.libraryPlist ofType:@"plist"]];
        
        // Sort the array
        NSSortDescriptor* nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.libraryContent = [contentArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];
        
        // Configure the Dictionary to access object via State Name
        self.stateDict = [self configureSectionData];
    }
    return self;
}

- (NSDictionary *)configureSectionData {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:50];

    for (NSUInteger index = 0; index < self.libraryCount; index++) {
        NSString *stateName = [[self.libraryContent objectAtIndex:index] valueForKey:@"name"];
            [dictionary setObject:[self.libraryContent objectAtIndex:index] forKey:stateName];
    }
    
    return [dictionary copy];
}

- (NSArray *)libraryNames
{
    NSMutableArray *mutableArray =[[NSMutableArray alloc] initWithObjects: nil];
    for (NSUInteger index = 0; index < self.libraryCount; index++) {
        [mutableArray addObject:[self.libraryContent valueForKey:@"name"]];
    }
   
    return [mutableArray copy];
}

- (NSArray *)libraryKeys
{
    // Unicode for a search magnifying glass
    NSString *mag = [[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"];
    
    //UIKIT_EXTERN NSString *const UITableViewIndexSearch;
    
    NSString *letters = [mag stringByAppendingString:@" A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"];
    return [letters componentsSeparatedByString:@" "];
}


- (NSDictionary *)libraryItemAtIndex:(int)index {
    return (self.libraryContent != nil && [self.libraryContent count] > 0 && index < [self.libraryContent count])
	? [self.libraryContent objectAtIndex:index]
	: nil;
}

- (NSDictionary *)libraryItemForKey:(NSString *)key {
    return (self.libraryContent != nil && [self.libraryContent count] > 0)
	? [self.stateDict objectForKey:key]
	: nil;
}

- (int)libraryCount {
    return (self.libraryContent != nil) ? [self.libraryContent count] : 0;
}

@end
