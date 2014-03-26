//
//  SudokuGroupSpec.m
//  Sudoku
//  Spec for SudokuGroup
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "SudokuGroup.h"
#import "Sudoku.h"

SPEC_BEGIN(SudokuGroupSpec)

describe(@"SudokuGroup", ^{
	it(@"should properly initialize", ^{
		Sudoku *sudoku = [Sudoku mock];
		[[sudoku should] receive:@selector(groupsCount) andReturn:@(1) withCountAtLeast:0];
		SudokuGroup *instance = [SudokuGroup group:0 forSudoku:sudoku];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[SudokuGroup class]];
	});

	it(@"should ", ^{

	});
});

SPEC_END
