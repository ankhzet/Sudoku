//
//  Sudoku.m
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Sudoku.h"
#import "SudokuCell.h"
#import "SudokuGroup.h"

@implementation Sudoku

+ (instancetype) sudoku {
	return [[self alloc] initWithGroupSize:SUDOKU_DEFAULT_SIZE];
}

+ (instancetype) sudokuWithSize:(NSUInteger)size {
	return [[self alloc] initWithGroupSize:size];
}

- (id) initWithGroupSize:(NSUInteger)initSize {
	if (!(self = [super init]))
		return self;

	[self setGroupsCount:initSize];
	return self;
}

- (void) setGroupsCount:(NSUInteger)groupsCount {
	if (_groupsCount == groupsCount) {
		return;
	}
	_groupsCount = groupsCount;

	_cells = [NSMutableArray array];
	_rows = [NSMutableArray array];
	_collumns = [NSMutableArray array];
	_squares = [NSMutableArray array];
	_groups = @{
							@(SudokuGroupTypeRow): _rows,
							@(SudokuGroupTypeCollumn): _collumns,
							@(SudokuGroupTypeSquare): _squares,
							};

	// init cells
	NSMutableArray *cells = (id)_cells;
	for (int y = 0; y < groupsCount; y++) {
		for (int x = 0; x < groupsCount; x++) {
			SudokuCell *cell = [SudokuCell cellForSudoku:self atX:x andY:y];
			[cells addObject:cell];
		}
	}

	[self buildGroups];
}

- (void) buildGroups {
	NSMutableArray *rows = (id)_rows;
	NSMutableArray *collumns = (id)_collumns;
	NSMutableArray *squares = (id)_squares;

	int sqrtSize = (int)sqrt(_groupsCount);
	for (int i = 0; i < _groupsCount; i++) {
		// make row groups
		SudokuGroup *row = [SudokuGroup group:i forSudoku:self];
		SudokuGroup *coll = [SudokuGroup group:i forSudoku:self];
		SudokuGroup *square = [SudokuGroup group:i forSudoku:self];
		row.type = SudokuGroupTypeRow;
		coll.type = SudokuGroupTypeCollumn;
		square.type = SudokuGroupTypeSquare;
		for (int j = 0; j < _groupsCount; j++) {
			[row setCell:[self cellAtX:j andY:i] atIndex:j];
			[coll setCell:[self cellAtX:i andY:j] atIndex:j];

			int dx = (i % sqrtSize) * sqrtSize + j % sqrtSize;
			int dy = (i / sqrtSize) * sqrtSize + j / sqrtSize;

			[square setCell:[self cellAtX:dx andY:dy] atIndex:j];
		}
		[rows addObject:row];
		[collumns addObject:coll];
		[squares addObject:square];
	}
}

- (SudokuCell *) cellAtX:(NSUInteger)x andY:(NSUInteger)y {
	return _cells[y * _groupsCount + x];
}

- (NSString *) description {
	NSString *result;
	for (int y = 0; y < _groupsCount; y++) {
		NSString *row = @"";
		for (int x = 0; x < _groupsCount; x++) {
			row = [NSString stringWithFormat:@"%@, %lu", row, [self cellAtX:x andY:y].number];
		}
		result = [NSString stringWithFormat:@"%@\n%@", result, row];
	}
	return result;
}

- (id)copyWithZone:(NSZone *)zone {
	Sudoku *copy = [Sudoku sudoku];
	[copy setGroupsCount:self.groupsCount];

	for (SudokuCell *cell in _cells) {
    [[copy cellAtX:cell.x andY:cell.y] setNumber:cell.number];
	}

	return copy;
}

@end
