//
//  SudokuGroup.m
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "SudokuGroup.h"
#import "Sudoku.h"
#import "SudokuCell.h"

@interface SudokuGroup () {
	NSMutableArray *cells;
}

@end
@implementation SudokuGroup

+ (instancetype) group:(NSUInteger)index forSudoku:(Sudoku *)sudoku {
	return [[self alloc] initForSudoku:sudoku withIndex:index];
}

- (id)initForSudoku:(Sudoku *)sudoku withIndex:(NSUInteger)index {
	if (!(self = [super init]))
		return self;

	_sudoku = sudoku;
	_index = index;
	cells = [NSMutableArray array];
	for (int i = 0; i < [sudoku groupsCount]; i++) {
		[cells addObject:[NSNull null]];
	}
	return self;
}

- (SudokuCell *) setCell:(SudokuCell *)cell atIndex:(NSUInteger)index {
	SudokuCell *prev = [self cellAt:index];
	cells[index] = cell;
	return prev;
}

- (SudokuCell *) cellAt:(NSUInteger)index {
	SudokuCell *cell = cells[index];
	return ((id)cell != [NSNull null]) ? cell : nil;
}

- (NSInteger) cellIndex:(SudokuCell *)cell {
	switch (self.type) {
		case SudokuGroupTypeRow:
			return cell.x;
		case SudokuGroupTypeCollumn:
			return cell.y;
		case SudokuGroupTypeSquare: {
			int sqr = (int) sqrt(self.sudoku.groupsCount);
			return sqr * (cell.y % sqr) + cell.x % sqr;
		}
	}

	return -1;
}

- (NSSet *) numbers {
	NSMutableSet *numbers = [NSMutableSet set];
	for (NSUInteger candidate = 1; candidate <= [_sudoku groupsCount]; candidate++) {
		[numbers addObject:@(candidate)];
	}
	return numbers;
}

- (NSSet *) unusedNumbers {
	NSSet *used = [self usedNumbers];
	NSMutableSet *unused = [NSMutableSet set];
	for (NSUInteger candidate = 1; candidate <= [_sudoku groupsCount]; candidate++) {
		if (![used member:@(candidate)]) {
			[unused addObject:@(candidate)];
		}
	}
	return unused;
}

- (NSSet *) usedNumbers {
	NSMutableSet *numbers = [NSMutableSet set];
	for (SudokuCell *cell in [self usedCells]) {
    [numbers addObject:@(cell.number)];
	}
	return numbers;
}

- (NSSet *) unusedCells {
	NSMutableSet *unused = [NSMutableSet set];
	for (SudokuCell *cell in cells) {
    if (cell.number == UNUSED_CELL) {
			[unused addObject:cell];
		}
	}
	return unused;
}

- (NSSet *) usedCells {
	NSMutableSet *set = [NSMutableSet setWithArray:cells];
	[set minusSet:[self unusedCells]];
	return set;
}


- (NSString *) description {
	NSString *result = @"";
	for (SudokuCell *cell in cells) {
		result = [NSString stringWithFormat:@"%@, %@", result, ((id)cell != [NSNull null]) ? [NSNumber numberWithUnsignedInteger:cell.number] : @"?"];
	}
	return [NSString stringWithFormat:@"[%@ ,]", result];
}

@end
