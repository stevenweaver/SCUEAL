_Genetic_Code   = 0;

ExecuteAFile(HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "simpleBootstrap.bf");

SetDialogPrompt ("Please specify a nucleotide or amino-acid data file:");

DataSet 	  ds 		   = ReadDataFile (PROMPT_FOR_FILE);
DataSetFilter filteredData2 = CreateFilter (ds,1);

fprintf (stdout,"\n______________READ THE FOLLOWING DATA______________\n",ds);

SelectTemplateModel(filteredData2);
_DO_TREE_REBALANCE_ = 1;

ExecuteAFile            (HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR +"queryTree.bf");

LikelihoodFunction lf = (filteredData2,givenTree);
timer                 = Time(0);
Optimize                (res,lf);
timer                 = Time(0)-timer;

fprintf (stdout, "\n______________RESULTS______________\nTime taken = ", timer, " seconds\nAIC Score = ", 
				  2(res[1][1]-res[1][0]),"\n",lf);

ExecuteAFile (HYPHY_LIB_DIRECTORY + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "categoryEcho.bf");
GetString	 (lfInfo, lf, -1);

return {"Log(L)": res[1][0], "DF": res[1][1], "Tree": Format (givenTree,1,1)}
