

function    ALGORITHMsignificanceANALYSIS_P_XLSX                                                                                                                                                                                                                                                                                                                                                                                                                                                              
%%  Description                                                                                                                                                                                            



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       A program that calculates a scalar, the location of a folder containing input files, and a location
%       for the output .xlsx template file (each of these are set in the first section below).

%       A scalar range for each sample type, such that the program can identify the sample based on the
%       evaluated scalar.


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       The program calculates the scalar for each sample and then identifies the sample based on the set
%       ranges.  It counts how many were correctly and incorrectly identified, computes the statistical 
%       significance of this in comparison to sorting at

%       - random
%       - 70% accuracy
%       - 75% accuracy
%       - 80% accuracy
%       - 85% accuracy
%       - 00% accuracy

%       and outputs the results to the designated .xlsx file template.


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


scalar='AVERAGE_ROWvariance_M_S';

input_folder=INTERFEROGRAMS_ST;

output=ALGORITHMsignificanceANALYSIStemplate_ST;

input_dir=dir([input_folder '\*.csv']);


%%  Define the scalar ranges associated with successful identification of each sample type and prepare counters                                                                                            


H_min=2.17*10^(-6);
H_max=2.2*10^(-6);

HeNe_min=0.00215;
HeNe_max=0.0036;

Hg_min=0.0039;
Hg_max=0.0193;

Lb_min=0.000113;
Lb_max=0.00029;

Na_min=2.66*10^(-6);
Na_max=2.79*10^(-5);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Incorporte these ranges into a cell, setting up the first row to count successful identifications                                                                                         %
%    and the second to count incorrect identifications.                                                                                                                                        %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

sample_types={'H ' 'He' 'Hg' 'LB' 'Na'};

sample_types(2,:)=num2cell(zeros(1,length(sample_types(1,:))));
sample_types(3,:)=num2cell(zeros(1,length(sample_types(1,:))));


sample_types(4,:)=num2cell([H_min HeNe_min Hg_min Lb_min Na_min]);
sample_types(5,:)=num2cell([H_max HeNe_max Hg_max Lb_max Na_max]);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Create a cell array to collect cumulative results for exporting                                                                                                                           %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

results={};                                                                                                     


%%  For each input: find its categories, evaluate its scalar, and assign the result accordingly                                                                                                            


for i=1:length(input_dir(:,1))


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Get the file's name and split it (so that useful aspects can be identified)                                                                                                               %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_name=input_dir(i,1).name;
    
    input_split_name=split(input_name,'.');
    
 
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    If this is a background measurement, skip it and proceed to the next file                                                                                                                 %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
       
    if strcmp(input_split_name{7,1},'background')
        
        continue
        
    end
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Get the portion of the sample's name (the serial number and sample type only, no descriptions) to be                                                                                      %
%    output with the results to the .xlsx file.  If there was no description for the .csv file type to be                                                                                      %
%    removed with, remove it now.                                                                                                                                                              %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
    
    [input_sample_name,~]=strtok(input_name,' ');
    
     
    if strcmp(input_sample_name(end-3:end),'.csv')
        
        input_sample_name=input_sample_name(1:end-4);
        
    end
    
   
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Identify the input's sample type                                                                                                                                                          %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_sample_type=input_split_name{7,1}(1:2);  


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Evaluate the scalar program                                                                                                                                                               %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    input_data=readmatrix(strcat(input_folder,input_name),'Range',[2 2]);
    
    input_scalar=feval(scalar,input_data);
    
    clear input_data
    

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Record whether or not the sample was correctly categorized by the ranges, the scalar evaluated                                                                                            %
%    for the sample, and keep tally of how many of each sample type have been correctly and incorrectly                                                                                        %
%    identified.                                                                                                                                                                               %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    [~,index]=find(strcmp(sample_types,input_sample_type));
    
    
    if sample_types{4,index}<=input_scalar && sample_types{5,index}>=input_scalar
        
        results{23+sample_types{2,index},1+3*index}=input_sample_name;
        results{23+sample_types{2,index},3*index}=input_scalar;
        
        sample_types{2,index}=sample_types{2,index}+1;
        
    else
        
        results{58+sample_types{3,index},1+3*index}=input_sample_name;
        results{58+sample_types{3,index},3*index}=input_scalar;
        
        sample_types{3,index}=sample_types{3,index}+1;
        
    end  


clear input_name input_sample_name input_sample_type input_split_name input_scalar index 
    

end


%%  Calculate the cumulative results                                                                                                                                                                       


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Calculate the total samples correctly and incorrectly identified                                                                                                                          %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

results{9,3}=sum(cell2mat(sample_types(2,:)));
results{10,3}=sum(cell2mat(sample_types(3,:)));


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Calculate the p-values assuming the probability of correct idenfitication is:                                                                                                             %
%                                                                                                                                                                                              %
%       - 1/(# of options) [random choice]                                                                                                                                                     %
%       - 70%                                                                                                                                                                                  %
%       - 75%                                                                                                                                                                                  %
%       - 80%                                                                                                                                                                                  %
%       - 85%                                                                                                                                                                                  %
%       - 90%                                                                                                                                                                                  %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

results{8,7}=binocdf(results{10,3},results{9,3}+results{10,3},(1-1/length(sample_types(1,:))));
results{9,7}=binocdf(results{10,3},results{9,3}+results{10,3},.3);
results{10,7}=binocdf(results{10,3},results{9,3}+results{10,3},.25);
results{11,7}=binocdf(results{10,3},results{9,3}+results{10,3},.2);
results{12,7}=binocdf(results{10,3},results{9,3}+results{10,3},.15);
results{13,7}=binocdf(results{10,3},results{9,3}+results{10,3},.1);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Include the correct/incorrect identification totals for each sample type with the results                                                                                                 %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

for i=1:length(sample_types(1,:))
    
    results{17,3*i}=sample_types{2,i};
    results{18,3*i}=sample_types{3,i};
    
end
    

%%  Write the results to the template .xlsx file                                                                                                                                                           

writecell(results(9:10,3),output,'Sheet','Output','Range','C9')
writecell(results(8:13,7),output,'Sheet','Output','Range','G8')
writecell(results(17:18,3:end),output,'Sheet','Output','Range','C17')
writecell(results(23:53,3:end),output,'Sheet','Output','Range','C23')

if length(results(:,1))>=58
    
    writecell(results(58:end,3:end),output,'Sheet','Output','Range','C58')
    
end



end
