//
//  TLIncompleteViewController.m
//  600EST
//
//  Created by NguyenThanhLuan on 15/02/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import "TLIncompleteViewController.h"
#import "TLQuestionHeaderCell.h"
#import "TLQuestionTableViewCell.h"

@interface TLIncompleteViewController ()

@end

@implementation TLIncompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"Text Completion"];
    
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview setAllowsSelection:YES];
    [_tableview setAllowsMultipleSelection:YES];
    [_tableview setAllowsSelectionDuringEditing:NO];
    [_tableview setAllowsMultipleSelectionDuringEditing:NO];
    
    [_tableview registerNib:[UINib nibWithNibName:@"TLQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"idcellquestion"];
    [_tableview registerNib:[UINib nibWithNibName:@"TLQuestionHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"idheaderquestion"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"score"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showAnwser_Action:)];
    
    uDic = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setIncompleteArray:(NSArray *)arr{
    _incompleteArr = arr;
}

-(void)reloadView{
    
}

-(void)showAnwser{
    
    NSArray *answers = [_tableview indexPathsForSelectedRows];
    
    rAnwser = 0;
    tAnwser = [_incompleteArr count];
    
    for (NSIndexPath *answer in answers) {
        
        NSDictionary *question;
        
        NSLog(@"question number %ld",(long)answer.section);
        question = [_incompleteArr objectAtIndex:answer.section];
        
        NSString *dapan = [question valueForKey:@"answer"];
        
        rAnwser = rAnwser + [self checkAnswer:answer anwser:dapan];
    }
    
    NSDictionary *lessonDic = [[NSUserDefaults standardUserDefaults] objectForKey:lessonName];
    NSMutableDictionary *lessonMutableDic = [[NSMutableDictionary alloc] initWithDictionary:lessonDic];
    [lessonMutableDic setValue:[NSNumber numberWithInteger:rAnwser] forKey:@"incomplete"];
    
    [[NSUserDefaults standardUserDefaults] setObject:lessonMutableDic forKey:lessonName];
    
    [super showAnwser];
}

-(int)checkAnswer:(NSIndexPath*)selection anwser:(NSString*)anwser{
    
    int dapan = -1;
    
    if ([anwser isEqualToString:@"A"]) {
        dapan = 0;
    }
    else if ([anwser isEqualToString:@"B"]){
        dapan = 1;
    }
    else if ([anwser isEqualToString:@"C"]){
        dapan = 2;
    }
    else if ([anwser isEqualToString:@"D"]){
        dapan = 3;
    }
    
    if (dapan == selection.row) {
        return 1;
    }
    
    return 0;
}

-(BOOL)checkAnwser:(AnwserState)uAnwser valid:(NSString*)vAnwser{
    
    AnwserState validAnwserSt = kUnknow;
    
    if ([[vAnwser uppercaseString] isEqualToString:@"A"]) {
        validAnwserSt = kAnwserA;
    }
    else if ([[vAnwser uppercaseString] isEqualToString:@"B"]){
        validAnwserSt = kAnwserB;
    }
    else if ([[vAnwser uppercaseString] isEqualToString:@"C"]){
        validAnwserSt = kAnwserC;
    }
    else if ([[vAnwser uppercaseString] isEqualToString:@"D"]){
        validAnwserSt = kAnwserD;
    }
    
    if (uAnwser != validAnwserSt) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_incompleteArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TLQuestionHeaderCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"idheaderquestion"];
    
    /* Section header is in 0th index... */
    NSDictionary *qDic = [_incompleteArr objectAtIndex:section];
    
    [cell.label setText:[qDic valueForKey:@"question"]];
    [cell.label setTextColor:[UIColor grayColor]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TLQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idcellquestion"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.label setFont:[UIFont systemFontOfSize:12]];
    [cell.label setTextColor:[UIColor grayColor]];
    
    if([[tableView indexPathsForSelectedRows] containsObject:indexPath]){
        cell.label.textColor = [UIColor orangeColor];
    }
    
    NSDictionary *qDic = [_incompleteArr objectAtIndex:indexPath.section];
    NSString    *qNum = @"";
    
    switch (indexPath.row) {
        case 0:
            qNum = [NSString stringWithFormat:@"A. %@",[qDic valueForKey:@"A"]];
            break;
        case 1:
            qNum = [NSString stringWithFormat:@"B. %@",[qDic valueForKey:@"B"]];
            break;
        case 2:
            qNum = [NSString stringWithFormat:@"C. %@",[qDic valueForKey:@"C"]];
            break;
        case 3:
            qNum = [NSString stringWithFormat:@"D. %@",[qDic valueForKey:@"D"]];
            break;
        default:
            break;
    }
    
    cell.label.text = qNum;
    
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *indexpaths = [tableView indexPathsForSelectedRows];
    for (NSIndexPath* path in indexpaths) {
        
        if (path.section == indexPath.section)
        {
            [tableView deselectRowAtIndexPath:path animated:NO];
            
            [(TLQuestionTableViewCell*)[tableView cellForRowAtIndexPath:path] label].textColor = [UIColor grayColor];
        }
    }
    
    TLQuestionTableViewCell *cell = (TLQuestionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.label.textColor = [UIColor orangeColor];
    
    return indexPath;
}

#pragma mark -
#pragma mark - UITableCellView Delegate
-(void)didSelectAnwser:(AnwserState)anwser forCell:(TLTableViewCellBase *)cell{
    
    NSIndexPath *indexpath = [cell index];
    
    [uDic setObject:[NSNumber numberWithInteger:anwser] forKey:indexpath];
}

- (IBAction)showAnwser_Action:(id)sender {
    [self showAnwser];
}
@end
