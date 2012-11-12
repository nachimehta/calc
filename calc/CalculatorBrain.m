//
//  CalculatorBrain.m
//  calc
//
//  Created by Nachi Mehta on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;
@synthesize variableValues = _variableValues;

- (NSDictionary *) variableValues{
    if (_variableValues == nil) _variableValues = [[NSDictionary alloc] init];
    return _variableValues;
}

- (NSMutableArray *) programStack{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void) pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *)operation{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id) program{
    return [self.programStack copy];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]])
        result = [topOfStack doubleValue];
    
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString * operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"/"]){
            result = 1 / [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]){
            result = [self popOperandOffStack:stack] - [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"pi"]){
            result = 3.1415926535;
        } else if([operation isEqualToString:@"c"]){
            [stack removeAllObjects];
        } 
    }
            
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program{
    return @"Implement this in assignment 2";
}

+ (double)runProgram:(id)program{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    id topOfStack = [stack lastObject];
    if([topOfStack isKindOfClass:[NSString class]] && ([variableValues objectForKey:topOfStack] != nil)){
        [stack replaceObjectAtIndex:[stack count] withObject:[variableValues objectForKey:topOfStack]];
    }
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet *variables = [NSSet set];
    for(id obj in program){
        if ([obj isKindOfClass:[NSString class]] && ![self isAnOperation:obj]) {
            [variables addObject:obj];
        }
        
    }
    
    return [variables copy];
}

+ (BOOL)isAnOperation:(NSString *)operand{
    NSSet *operations = [NSSet setWithObjects:@"+", @"-", @"/", @"*", @"sqrt", @"sin", @"cos", @"pi", nil];
    
    return [operations containsObject:operand];
}


/*
    double result = 0;
    
    if ([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]){
        result = 1 / [self popOperand] * [self popOperand];
    } else if([operation isEqualToString:@"-"]){
        result = [self popOperand] - [self popOperand];
    } else if([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    } else if([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    } else if([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } else if([operation isEqualToString:@"pi"]){
        result = 3.1415926535;
    } else if([operation isEqualToString:@"c"]){
        [self.operandStack removeAllObjects];
    }
    
    [self pushOperand:result];

    return result;
}
 */

@end
