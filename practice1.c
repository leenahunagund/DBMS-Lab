#include<stdio.h>
#include<stdlib.h>
#define max 2

struct student{
	int SID,SEM;
	char NAME[20],BRANCH[20],ADDRESS[20];
};

struct student a[max];

struct student insert(struct student *a)
{
	for(int i=0;i<max;i++)
	{
		printf("enter name:\n");
		scanf("%s",&(a[i].NAME));
		printf("SID:\n");
		scanf("%d",&(a[i].SID));
		printf("enter sem:\n");
		scanf("%d",&(a[i].SEM));
		printf("enter branch:\n");
		scanf("%s",&(a[i].BRANCH));
		printf("enter ADDRESS\n");
		scanf("%s",&(a[i].ADDRESS));
	}
	return *a;
}
void display(struct student *a)
{
	printf("\nNAME\tSID\tSEM\tBRANCH\tADDRESS\n");
	for(int i=0;i<max;i++)
	{
		
		printf("%s\t%d\t%d\t%s\t%s\n",a[i].NAME,a[i].SID,a[i].SEM,a[i].BRANCH,a[i].ADDRESS);
	}
}

struct student addupdate(int up)
{
	
	for(int i=0;i<max;i++)
	{
		if(up==a[i].SID)
		{
			printf("enter new address:");
			scanf("%s",&(a[i].ADDRESS));
		}
	}
	return *a;
}

struct student delete(int sdit)
{
	for(int i=0;i<max;i++)
	{
		if (sdit==a[i].SID)
		{
			a[i]=a[i+1];
		}
	}
	return *a;
}
void csestudents(struct student *a)
{
	printf("\nNAME\tSID\tSEM\tBRANCH\tADDRESS\n");
	for(int i=0;i<max;i++)
	{
		if(a[i].BRANCH=='cse'|| a[i].BRANCH=='CSE' )
		{
		printf("%s\t%d\t%d\t%s\t%s\n",a[i].NAME,a[i].SID,a[i].SEM,a[i].BRANCH,a[i].ADDRESS);
		}
	}
}
void main()
{
	
	int up,sdit,choice;
	//a=(int*)malloc(n*sizeof(int));
	printf("enter your choice:");
	scanf("%d",&choice);
	while(1){
	
	switch(choice)
	{
		case 1: insert(a); 
					break;
		case 2: printf("\nenter the sid of the student whose address needs to be modified:");
				scanf("%d",&up);
				addupdate(up);
				display(a);
		case 3: printf("enter the SID of the student you want to delete:");
	scanf("%d",&sdit);
	delete(sdit);
	display(a);
		case 4: display(a);
					break;
		case 5: 
	csestudents(a);
	}
}
