//
//  MainViewController.m
//  calc
//
//  Created by Nachi Mehta on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "CalculatorBrain.h"

@interface MainViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasPressedDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSDictionary *variables;
@end

@implementation MainViewController

@synthesize display = _display;
@synthesize commandHistory = _commandHistory;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize variables = _variables;
@synthesize userHasPressedDecimal = _userHasPressedDecimal;

- (NSDictionary *)variables{
    if (!_variables) _variables = [[NSDictionary alloc] initWithObjectsAndKeys:@"x", 1, @"y", 2, nil];
    return _variables;
}

- (CalculatorBrain *)brain{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
- (IBAction)variablePressed:(UIButton *)sender {
    
    
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if(_userIsInTheMiddleOfEnteringANumber)
        self.display.text = [self.display.text stringByAppendingString:digit];
    
    else {
        self.display.text = digit;
        _userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    self.commandHistory.text = [self.commandHistory.text stringByAppendingString:digit];
    
    if(!_userIsInTheMiddleOfEnteringANumber){
        self.commandHistory.text = [self.commandHistory.text stringByAppendingString:@" "];
    }
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = [sender currentTitle];
    
    if(!_userHasPressedDecimal) {
        if(_userIsInTheMiddleOfEnteringANumber)
            self.display.text = [self.display.text stringByAppendingString:decimal];
        
        else {
            self.display.text = [[NSString stringWithFormat:@"%d", 0] stringByAppendingString:decimal];
            _userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    
    self.commandHistory.text = [self.commandHistory.text stringByAppendingString:decimal];
    
    _userHasPressedDecimal = YES;
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text = @"0";
    self.commandHistory.text = @"";
    [self.brain performOperation:sender.currentTitle];
    _userIsInTheMiddleOfEnteringANumber = NO;
    _userHasPressedDecimal = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    
    self.commandHistory.text = [self.commandHistory.text stringByAppendingString:sender.currentTitle];
    self.commandHistory.text = [self.commandHistory.text stringByAppendingString:@" "];
    _userHasPressedDecimal = NO;
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.commandHistory.text = [self.commandHistory.text stringByAppendingString:@" "];
}



@end
