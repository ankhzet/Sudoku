//
//  SudokuSolver.m
//  Sudoku
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "SudokuSolver.h"
#import "Sudoku.h"
#import "SudokuGroup.h"
#import "SudokuCell.h"

typedef NS_ENUM(NSUInteger, SudokuGroupSolverResult) {
	SudokuGroupSolved             = 1 << 0,
	SudokuGroupSolverNoOp         = 1 << 1,
	SudokuGroupSolverHasConflicts = 1 << 2,
};

@implementation SudokuSolver

+ (instancetype) solverForSudoku:(Sudoku *)sudoku {
	return [[self alloc] initWithSudoku:sudoku];
}

- (id)initWithSudoku:(Sudoku *)sudoku {
	if (!(self = [super init]))
		return self;

	_sudoku = sudoku;
	return self;
}

- (void) solve {
	BOOL madeChanges = YES;
	while ((![self isSolved]) && madeChanges) {
		madeChanges = NO;
		if ([self solve:NO] == SudokuGroupSolved) madeChanges = YES;
		if ([self solve:YES] == SudokuGroupSolved) madeChanges = YES;
	}
}

- (SudokuGroupSolverResult)solve:(BOOL)intensively {
	SudokuGroupSolverResult result = SudokuGroupSolverNoOp;
	NSArray *groups = @[@(SudokuGroupTypeRow), @(SudokuGroupTypeCollumn), @(SudokuGroupTypeSquare)];
	BOOL madeChanges = YES;
	NSUInteger conflicts = 0;
	while ((![self isSolved]) && madeChanges) {
		madeChanges = NO;
		for (NSNumber *groupType in groups) {
			NSArray *grouped;
			switch ([groupType unsignedIntegerValue]) {
				case SudokuGroupTypeRow: {
					grouped = [[self sudoku] rows];
					break;
				}
				case SudokuGroupTypeCollumn: {
					grouped = [[self sudoku] collumns];
					break;
				}
				case SudokuGroupTypeSquare: {
					grouped = [[self sudoku] squares];
					break;
				}
			}
			NSArray *lessUnused = [grouped sortedArrayUsingComparator:^NSComparisonResult(SudokuGroup *group1, SudokuGroup *group2) {
				NSInteger delta = [[group1 unusedCells] count] - [[group2 unusedCells] count];
				return (delta > 0) ? NSOrderedAscending : ((delta < 0) ? NSOrderedDescending : NSOrderedSame);
			}];

			for (SudokuGroup *group in lessUnused) {
				NSSet *unused = [group unusedCells];

				if ([unused count] > 0) {
					if (intensively) {
						Sudoku *tryCopy = [self.sudoku copy];
						SudokuGroup *tryGroup = tryCopy.groups[@(group.type)][group.index];
						SudokuSolver *trySolver = [SudokuSolver solverForSudoku:tryCopy];
						SudokuGroupSolverResult groupSolveResult = [trySolver solveGroup:tryGroup intensively:NO];
						switch (groupSolveResult) {
							case SudokuGroupSolverNoOp: break;
							case SudokuGroupSolved:
								[self solveGroup:group intensively:NO];
								result = groupSolveResult;
								madeChanges = YES;
								break;

							case SudokuGroupSolverHasConflicts:
							default:
								NSLog(@"-[SudokuSolver solve] caused conflicts in sudoku with solve version\n%@", self.sudoku);
								conflicts++;
								break;
						}
					} else {
						SudokuGroupSolverResult groupSolveResult = [self solveGroup:group intensively:NO];
						switch (groupSolveResult) {
							case SudokuGroupSolverNoOp: break;
							case SudokuGroupSolved:
								madeChanges = YES;
								result = groupSolveResult;
								break;
							case SudokuGroupSolverHasConflicts:
							default:
								NSLog(@"-[SudokuSolver solve] caused conflicts in sudoku with solve version\n%@", self.sudoku);
								conflicts++;
								break;
						};
					}

				}
			}

		}
	}
	NSLog(@"Solve process tried %lu conflicted solving versions", conflicts);
	return result;
}

- (SudokuGroupSolverResult) solveGroup:(SudokuGroup *)group intensively:(BOOL)intensively {
	SudokuGroupSolverResult result = SudokuGroupSolverNoOp;

	NSMutableSet *unused = [[group unusedCells] mutableCopy];
	NSMutableSet *candidates = [[group unusedNumbers] mutableCopy];

	// how to solve group?

	do {
		result = SudokuGroupSolverNoOp;
		// 1. Find conflicts for each unused number
		NSMutableDictionary *conflicts = [NSMutableDictionary dictionary];
		for (NSNumber *c in candidates) {
			NSUInteger candidate = [c unsignedIntegerValue];
			NSSet *_conflicts = [self findConflictsFor:candidate inGroup:group];
			conflicts[c] = _conflicts;
		}

		// 3. Else pick number with less non-conflicts
		NSArray *moreConflicted = [[conflicts allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2) {
			NSInteger delta = [conflicts[n1] count] - [conflicts[n2] count];
			return (delta > 0) ? NSOrderedAscending : ((delta < 0) ? NSOrderedDescending : NSOrderedSame);
		}];

		for (NSNumber *c in moreConflicted) {
			NSUInteger candidate = [c unsignedIntegerValue];
			NSSet *conflicted = conflicts[c];

			NSInteger nonConflicts = [unused count] - [conflicted count];

			if (nonConflicts == 0) {
				// no available unused cells - all of them are conflicting with already filled rows & colls
				return SudokuGroupSolverHasConflicts;
			} else if (nonConflicts == 1) {
				// 2. If number has only one non-conflict position - use it

				// single available substitution
				NSMutableSet *left = [unused mutableCopy];
				[left minusSet:conflicted];
				SudokuCell *leftCell = [left anyObject];
				[leftCell setNumber:candidate];
				[unused removeObject:leftCell];
				[candidates removeObject:@(candidate)];
				result = SudokuGroupSolved;
				break;
			} else {
				if (!intensively)
					continue;

				// 4. For each non-conflict position try to substitute and proceed recursively (but with duplicated sudoku)
				// 5. If there only one non-conflictable substitution - use it, else leave untouched.

				NSMutableSet *left = [unused mutableCopy];
				[left minusSet:conflicted];

				NSMutableDictionary *solves = [NSMutableDictionary dictionary];

				NSUInteger unsolvedNow = [self unusedCells];
				for (SudokuCell *tryCell in left) {
					NSInteger tryIndex = [group cellIndex:tryCell];

					Sudoku *clone = [group.sudoku copy];
					SudokuSolver *trySolver = [SudokuSolver solverForSudoku:clone];
					SudokuGroup *clonedGroup = clone.groups[@(group.type)][group.index];
					SudokuCell *clonedTryCell = [clonedGroup cellAt:tryIndex];

					clonedTryCell.number = candidate;

					SudokuGroupSolverResult solve = [trySolver solveGroup:clonedGroup intensively:NO];
					if (solve == SudokuGroupSolved) {
						NSUInteger unsolvedCells = [trySolver unusedCells];
						if (unsolvedNow > unsolvedCells) {
							solves[@(tryIndex)] = @(unsolvedCells);
							break;
						}
						solves[@(tryIndex)] = @(unsolvedCells);
					}
				}

				if ([solves count]) {
					NSArray *moreSolved = [solves count] > 1 ? [[solves allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2) {
						NSInteger delta = [solves[n1] unsignedIntegerValue] - [solves[n2] unsignedIntegerValue];
						return (delta > 0) ? NSOrderedAscending : ((delta < 0) ? NSOrderedDescending : NSOrderedSame);
					}] : [solves allKeys];

					NSNumber *mostUsefulSubstitution = moreSolved[0];
					SudokuCell *mostUsefulCell = [group cellAt:[mostUsefulSubstitution unsignedIntegerValue]];
					[mostUsefulCell setNumber:candidate];
					[unused removeObject:mostUsefulCell];
					[candidates removeObject:@(candidate)];
					result = SudokuGroupSolved;
					break;
				}
			}
		}
	} while (result == SudokuGroupSolved && [unused count]);

	return result;
}

- (NSSet *) findConflictsFor:(NSUInteger)candidate inGroup:(SudokuGroup *)group {
	Sudoku *sudoku = group.sudoku;
	NSSet *unused = [group unusedCells];
	NSMutableSet *conflicts = [NSMutableSet set];

	// check all unused positions, where we can place specified candidate
	for (SudokuCell *cell in unused) {
		// for each group of same type except for sqares
		for (NSNumber *type in @[@(SudokuGroupTypeRow), @(SudokuGroupTypeCollumn)])
			for (SudokuGroup *groupToCheck in sudoku.groups[type]) {
				// index in group
				NSInteger index = [groupToCheck cellIndex:cell];

				// cell at same index in checked group, for ex: cell at same x position in other lines, or at same y pos for other rows
				SudokuCell *cellInSamePos = [groupToCheck cellAt:index];
				if (cellInSamePos.number == candidate) {
					[conflicts addObject:cell];
					break;
				}
			}

	}

	return conflicts;
}

- (NSUInteger) unusedCells {
	NSUInteger result = 0;
	for (SudokuGroup *group in self.sudoku.rows) {
    result += [[group unusedCells] count];
	}

	return result;
}

- (BOOL) isSolved {
	for (SudokuGroup *group in self.sudoku.rows) {
    if ([[group unusedCells] count])
			return NO;
	}
	return YES;
}

@end
