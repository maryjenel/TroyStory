//
//  ViewController.m
//  TroyStory4
//
//  Created by Mary Jenel Myers on 1/27/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "WarriorListViewController.h"
#import "AppDelegate.h"

@interface WarriorListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *warriors;
@end

@implementation WarriorListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate]; //create instances of app delegate
    self.context = delegate.managedObjectContext;   //grab access to managedObjectContext from AppDelegate
    [self load]; //load data from core data
}

- (IBAction)addWarriorOnTap:(UITextField *)sender

{
    NSManagedObject*warrior = [NSEntityDescription insertNewObjectForEntityForName:@"Warrior" inManagedObjectContext:self.context]; //create instances of warrior entity

    [warrior setValue:sender.text forKey:@"name"]; // set name value with entered text from textfield
    int prowess = arc4random_uniform(10); //get random number to set to prowess level
    NSNumber *randProwess = [NSNumber numberWithInt:prowess]; //convert random prowess into to NSNumber
    [warrior setValue:randProwess forKey:@"prowess"]; //set new randomized prowess to entity


    [self.context save:nil];// save new object

    [self load];

    sender.placeholder = [NSString stringWithFormat:@"The Conquest of %@", sender.text]; // change place holder text to reference last entered warrior name
    sender.text = @""; //clear textField
    
    [sender resignFirstResponder]; // achilles dismissing the keyboard... can press return
}

- (void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Warrior"]; //create request for created entity
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES]; //create sort descriptor sorting by name in ascending order
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"prowess" ascending:YES]; //create sort descriptor sort by name in ascending order

    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]; //create array of new sortdescriptors and set to requests sort descriptors
    request.predicate = [NSPredicate predicateWithFormat:@"prowess >= 5 && prowess < 9"];
    self.warriors = [self.context executeFetchRequest:request error:nil]; //request entity and set to warriors array

    [self.tableView reloadData]; //load new data into tableview
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *warrior = self.warriors[indexPath.row]; //create instance of warrior object to pull properties from
    cell.textLabel.text = [warrior valueForKey:@"name"]; // set cell label to warrior's name
    cell.detailTextLabel.text = [[warrior valueForKey:@"prowess"]description];
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.warriors.count;
}

@end
