//
//  SudokuCellSpec.m
//  Sudoku
//  Spec for SudokuCell
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "SudokuCell.h"
#import "Sudoku.h"

SPEC_BEGIN(SudokuCellSpec)

describe(@"SudokuCell", ^{
	it(@"should properly initialize", ^{
		Sudoku *sudokuMock = [Sudoku mock];
		NSUInteger x = 3, y = 5;
		SudokuCell *instance = [SudokuCell cellForSudoku:sudokuMock atX:x andY:y];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[SudokuCell class]];

		[[instance.sudoku should] equal:sudokuMock];

		[[theValue(instance.x) should] equal:theValue(x)];
		[[theValue(instance.y) should] equal:theValue(y)];
	});

});

SPEC_END
