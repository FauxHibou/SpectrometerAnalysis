

function    SCALARanalysis_P_XLSX                                                                                                                                                                                                                                                                                                                                                                                                                                                              
%%  Description                                                                                                                                                                                            



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       A program that calculates a scalar, the location of a folder containing input files, and a location
%       for the output .xlsx template file (each of these are set in the first section below).


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       For each category that an input file falls into, its scalar evaluation is added to the results
%       in the accompanying .xlsx file.  


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Description                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       <>

%%  Common Scripts                                                                                                                                                                                         


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Calculations                                                                                                                                                                              %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Average Value (of matrix):              mean(mean(M))

%   Average Value (of matrix's columns):    mean(M)

%   Average Value (of matrix's rows):       mean(M')'

%   Average Value                           mean(M,n)
%   (of matrix along dimension n):



%   Max Value (of matrix):                  max(max(M))

%   Max Value (of matrix's columns):        max(M)

%   Max Value (of matrix's rows):           max(M')'



%   Min Value (of matrix):                  min(min(M))

%   Min Value (of matrix's columns):        min(M)

%   Min Value (of matrix's rows):           min(M')'


%   Norm (of vector):                       norm(v)


%   Pointwise calculations:                 v.*v', v.^2, ...


%   Variance (of matrix's columns):         var(M)



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Colors                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Color to vector converter:              uisetcolor


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Conversions                                                                                                                                                                               %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Cell to Matrix:                         cell2mat(C)


%   Number to String:                       num2str(5) 


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Evaluating                                                                                                                                                                                 %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Program as Argument                     feval(<program>,<program inputs>)


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Exporting                                                                                                                                                                                  %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Matrix to .CSV:                         dlmwrite(filename,input,'precision',15);


%   Table to .TXT (comma separated)         writetable(input_table,'output location');


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Importing                                                                                                                                                                                  %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   To Cell:                                readcell(<file location>,'Range','A4:C10');
%   To Matrix:                              readmatrix(<file location>,'Range',[<starting row> <starting column>]);
%   To Table:                               readcell(<file location>,'Range','B4');


%   Directory to Structure:                 dir(['directory location\' '*.txt']);


%   Excel File to Cell Array:               [~,~,output]=xlsread(input);


%   .TXT to Table:                          readtable(input)  


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Searching                                                                                                                                                                                  %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Condition as an index:                  x(x<=0)=inf     


%   Indices and values satisfying           [row,column,value_when_evaluated]=find(losses==min(losses))
%   a condition


%   Is an element a member:                 ismember(<element>,<set>)


%   Unique Elements of Matrix:              [unique_elements, lowest_index_of_occurence,unique_indices]=unique(M)


%   Unique Elements, Number of Occurences:  accumarray(unique_indices,1)    


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Strings                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Does it Contain:                        contains(<string>,<substring>)


%   Divide in Two:                          [before,remainder] = strtok(<string>,<delimater>)


%   Divide into Portions:                   split(<string>,<delimiter>)   


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   System commands                                                                                                                                                                            %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%   Copyfile:                               copyfile('original location','new location','f')


%   Make directory:                         mkdir([output '\<folder name>']);


%   Movefile:                               movefile('original location','new location','f')


%   Shut down:                              system('shutdown -s')





%%  Set the scalar program to be evaluated, the locations of folder containing input files, and a location                                                                                                 
%   for the output template .xlsx.  Get the .csv directory of the input folder.  


scalar='RELATIVEfrequencies_Xtreme_M_S';

input_folder=INTERFEROGRAMS_ST;

output=SCALARanalysisTEMPLATE_ST;

input_dir=dir([input_folder '\*.csv']);


%%  Define categories to perform the analysis on and create cells to collect the cumulative results                                                                                                        


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Create groups and categories, and prepare counters "behind" them                                                                                                                          % 
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

group_1_categories={'ba' 'H ' 'He' 'Hg' 'LB' 'Na'};
group_1_categories(1,:,2)=num2cell(ones(1,length(group_1_categories(1,:,1))),1);


group_2_categories={'01.1' '22.1' '22.2' '22.3' '30.1' '30.2' '30.3' '31.1'};
group_2_categories(1,:,2)=num2cell(ones(1,length(group_2_categories(1,:,1))),1);


group_3_categories={'near zero path length' 'far from zero path length'...
                    'off center, far from zero path length' 'centered' 'horizontal, greater'...
                    'horizontal, less' 'vertical, greater' 'vertical, less'};                
group_3_categories(1,:,2)=num2cell(ones(1,length(group_3_categories(1,:,1))),1);
                

group_4_categories={'30.2' '30.3' '31.1'};
group_4_categories(1,:,2)=num2cell(ones(1,length(group_4_categories(1,:,1))),1);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Create cell arrays to collect cumulative results for exporting                                                                                                                            %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

results_by_sample={};
results_by_build={};
results_by_alignment={};
results_by_fixed_alignment={};


%%  For each input: find its categories, evaluate its scalar, and assign the result accordingly                                                                                                            


for i=1:length(input_dir(:,1))


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Create a cell array to store the input's categories and split the input's filename to allow this                                                                                          %
%    information to be obtained.  Then collect the input's serial number and sample type so that it                                                                                            %
%    can be recorded with the final results.                                                                                                                                                   %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_categories={};
    
    input_name=input_dir(i,1).name;
    
    
    input_split_name=split(input_name,'.');
    
    
    [input_sample_name,~]=strtok(input_name,' ');
    
    if strcmp(input_sample_name(end-3:end),'.csv')
        
        input_sample_name=input_sample_name(1:end-4);
        
    end
    
   
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Identify the input's group 1 category (sample type)                                                                                                                                       %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_categories{1,1}=input_split_name{7,1}(1:2);  


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Identify the input's group 2 category (build number)                                                                                                                                      %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_categories{2,1}=strcat(input_split_name{3,1},'.',input_split_name{4,1});


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Identify the input's group 3 category (alignment description)                                                                                                                             %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    if contains(input_split_name{7,1},' ')
        
        [~,remainder] = strtok(input_split_name{7,1},'(');
    
        input_categories{3,1}=remainder(2:end-1); 
    
    else
    
        input_categories{3,1}=[];

    end


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Evaluate the scalar program                                                                                                                                                               %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_data=readmatrix(strcat(input_folder,input_name),'Range',[2 2]);
    
    input_scalar=feval(scalar,input_data);
    
    clear input_data
    

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Assign this and the input's name to the corresponding group 1 category's results                                                                                                          %
%    and increase the count accordingly                                                                                                                                                        %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    [~,index]=find(strcmp(group_1_categories,input_categories{1,1}));
    
    results_by_sample{group_1_categories{1,index,2},3*index-1}=input_scalar;
    results_by_sample{group_1_categories{1,index,2},3*index}=input_sample_name;
    
    group_1_categories{1,index,2}=group_1_categories{1,index,2}+1;

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Do the same regarding group 2                                                                                                                                                             %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    [~,index]=find(strcmp(group_2_categories,input_categories{2,1}));
    
    results_by_build{group_2_categories{1,index,2},3*index-1}=input_scalar;
    results_by_build{group_2_categories{1,index,2},3*index}=input_sample_name;
    
    group_2_categories{1,index,2}=group_2_categories{1,index,2}+1;
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Ditto for group 3, if the input has an alignment description other than 'fixed alignment'                                                                                                 %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    if ~isempty(input_categories{3,1}) && ~strcmp(input_categories{3,1},'fixed alignment')

        [~,index]=find(strcmp(group_3_categories,input_categories{3,1}));

        results_by_alignment{group_3_categories{1,index,2},3*index-1}=input_scalar;
        results_by_alignment{group_3_categories{1,index,2},3*index}=input_sample_name;

        group_3_categories{1,index,2}=group_3_categories{1,index,2}+1;
    
    end
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    And finally group 4, if the input had fixed alignment                                                                                                                                     %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
    
    if strcmp(input_categories{3,1},'fixed alignment')
    
        [~,index]=find(strcmp(group_4_categories,input_categories{2,1}));

        results_by_fixed_alignment{group_4_categories{1,index,2},3*index-1}=input_scalar;
        results_by_fixed_alignment{group_4_categories{1,index,2},3*index}=input_sample_name;

        group_4_categories{1,index,2}=group_4_categories{1,index,2}+1;
        
    end
    

clear input_name input_sample_name input_split_name input_categories input_scalar
    

end


%%  Write the cumulative results to the template .xlsx file                                                                                                                                                

writecell(results_by_sample,output,'Sheet','Output','Range','A18')
writecell(results_by_build,output,'Sheet','Output','Range','A58')
writecell(results_by_alignment,output,'Sheet','Output','Range','A111')
writecell(results_by_fixed_alignment,output,'Sheet','Output','Range','A141')



end
