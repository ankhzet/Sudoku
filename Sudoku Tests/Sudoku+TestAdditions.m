//
//  Sudoku+TestAdditions.m
//  Sudoku
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Sudoku+TestAdditions.h"
#import "SudokuCell.h"
#import "SudokuGroup.h"

@implementation Sudoku (TestAdditions)

- (void) initWithStringContents:(NSString *)contents {
	NSUInteger size = (int)sqrt([contents length]);
	[self setGroupsCount:size];

	for (int y = 0; y < size; y ++) {
		NSString *row = [contents substringWithRange:NSMakeRange(size * y, size)];
		for (int x = 0; x < size; x ++) {
			[[self cellAtX:x andY:y] setNumber:[[row substringWithRange:NSMakeRange(x, 1)] integerValue]];
		}
	}
}

- (BOOL) group:(SudokuGroup *)group equalsTo:(NSArray *)numbers {
	for (int i = 0; i < [numbers count]; i++)
		if ([numbers[i] unsignedIntegerValue] != [[group cellAt:i] number])
			return NO;

	return YES;
}

@end
