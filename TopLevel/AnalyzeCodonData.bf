NICETY_LEVEL = 3;

#include HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "TemplateModels/chooseGeneticCode.def";
#include HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR +"simpleBootstrap.bf";

SetDialogPrompt ("Please specify a codon data file:");


DataSet 	  ds 		   = ReadDataFile (PROMPT_FOR_FILE);
DataSetFilter filteredData2 = CreateFilter (ds,3,"","",GeneticCodeExclusions);

fprintf (stdout,"\n______________READ THE FOLLOWING DATA______________\n",ds);

SelectTemplateModel(filteredData2);

_DO_TREE_REBALANCE_ = 1;
#include HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "queryTree.bf";

if (modelType)
{
	ChoiceList (branchLengths, "Branch Lengths", 1, SKIP_NONE,
							   "Estimate", "Estimate branch lengths by ML",
							   "Proportional to input tree", "Branch lengths are proportional to those in input tree");
				 				  
	if (branchLengths < 0)
	{
		return;
	}
	
	if (branchLengths == 1)
	{
		global treeScaler = 1;
		ReplicateConstraint ("this1.?.?:=treeScaler*this2.?.?__", givenTree, givenTree);
	}
}

LikelihoodFunction lf = (filteredData2,givenTree);

Optimize	(res,lf);

fprintf (stdout, "\n______________RESULTS______________\n",lf);

/* compute syn and non-syn stencils for current genetic code */

#include HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "categoryEcho.bf";

GetString 				(sendMeBack,lf,-1);
sendMeBack["LogL"] 		= res[1][0];
sendMeBack["NP"] 		= res[1][1];

return sendMeBack;
