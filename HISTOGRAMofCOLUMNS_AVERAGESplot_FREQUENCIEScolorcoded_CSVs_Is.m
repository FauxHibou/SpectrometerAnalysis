

function    HISTOGRAMofCOLUMNS_AVERAGESplot_FREQUENCIEScolorcoded_CSVs_Is                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%%  Description                                                                                                                                                                                            


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       A folder location containing .csv's (entered below)


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       Input to the program

%       HISTOGRAMofCOLUMNS_AVERAGESplot_FREQUENCIEScolorcoded_I_G


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Description                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       The program: 
%
%       HISTOGRAMofCOLUMNS_AVERAGESplot_FREQUENCIEScolorcoded_I_G
%
%       is run on each .csv file of the input folder.  The resulting graphs are then saved as image
%       files in the output folder.

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





%%  Set the locations for the folder of .csv's and the folder to output graphs to                                                                                                                          


folder_of_CSVs=INTERFEROGRAMS_ST;

output_folder=HISTOGRAMcolumn_OUTPUTfolder_ST;


%%  Create and save a histogram for each .csv file of the input folder                                                                                                                                     


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Get the directory of the .csv folder                                                                                                                                                      %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

directory_of_CSVs=dir([folder_of_CSVs '*.csv']);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Create and save a histogram for each one, then clear the memory                                                                                                                           %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

for i=1:length(directory_of_CSVs(:,1))
    
    
    matrix_of_CSV=readmatrix([folder_of_CSVs directory_of_CSVs(i,1).name],'Range',[2 2]);
    
    
    HISTOGRAMofCOLUMNS_AVERAGESplot_FREQUENCIEScolorcoded_I_G...
        (matrix_of_CSV,[output_folder directory_of_CSVs(i,1).name(1:end-4)]);
    
    
    clear matrix_of_CSV
    
    
end



end
