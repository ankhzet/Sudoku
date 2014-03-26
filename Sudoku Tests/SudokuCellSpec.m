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

SPEC_BEGIN(SudokuCellSpec)

describe(@"SudokuCell", ^{
	it(@"should properly initialize", ^{
		SudokuCell *instance = [SudokuCell new];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[SudokuCell class]];
	});

	it(@"should ", ^{

	});
});

SPEC_END
