//
//  SudokuCell.m
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "SudokuCell.h"

@implementation SudokuCell

+ (instancetype) cellForSudoku:(Sudoku *)sudoku atX:(NSUInteger)x andY:(NSUInteger)y {
	return [[self alloc] initForSudoku:sudoku atX:x andY:y];
}

- (id)initForSudoku:(Sudoku *)sudoku atX:(NSUInteger)x andY:(NSUInteger)y {
	if (!(self = [super init]))
		return self;

	_sudoku = sudoku;
	_x = x;
	_y = y;

	return self;
}

@end
