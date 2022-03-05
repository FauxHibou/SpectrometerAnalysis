

function     SCATTERofROWaverages_AXESofSYMMETRY_CSVs_Is                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
%%  Description                                                                                                                                                                                            


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       A folder of CSVs and an output folder for the graphs resulting from the analysis (the 
%       locations are entered below)


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       Input to the program

%       SCATTERofROWaverages_AXESofSYMMETRY_I_G


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Description                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       For each .csv the program takes the average intensities and performs a background correction 
%       (unless the intensities are background themselves).  Five estimated axes of symmetry are then
%       made with subprograms, and all of this information is sent to the program

%       SCATTERofROWaverages_AXESofSYMMETRY_I_G

%       where the average intensities are plotted and estimated axes indicated.  

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

output_folder=SCATTERofROWaverages_AXESofSYMMETRY_OUTPUTfolder_ST;



%%  Import each input file, take the average intensities and make background corrections, estimate the...                                                                                                  
%   axes of symmetry and output the results to the graphing program.


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Make the output folder and get the .csv directory of the input                                                                                                                            %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

input_directory=dir([folder_of_CSVs '\*.csv']);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Set the background initially to zero                                                                                                                                                      %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

background=0;


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    For each .csv file of the input folder:                                                                                                                                                   %
%                                                                                                                                                                                              %
%       - Take the average values of its rows                                                                                                                                                  %
%       - Estimate the locations of the axes of symmetry                                                                                                                                       %
%       - Graph these results                                                                                                                                                                  %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

for i=1:length(input_directory(:,1))
    
    input_name=input_directory(i,1).name;
    
    average_intensities=readmatrix([folder_of_CSVs input_name],'Range',[2 2]);
    
    average_intensities=mean(average_intensities,2);
    

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    If this is a background measurement, set it as such until a new background measurement takes its                                                                                          %
%    place and move on to the next sample.                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
    
    split_name=split(input_name,'.');
    
    
    if strcmp(split_name{7,1},'background')
        
        background=average_intensities;
        
        continue
    
    end
    
    clear split_name


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Otherwise make a background correction, setting negative values to zero                                                                                                                   %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
        
    average_intensities=average_intensities-background;
    
    average_intensities(average_intensities<=0)=0;
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Estimate the input's axes of symmetry and graph the results.                                                                                                                              %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
       
    AXISofSYMMETRY_correspondence_1=AXISofSYMMETRY_correspondenceLOSS_1_CV_S(average_intensities);
    
    AXISofSYMMETRY_correspondence_2=AXISofSYMMETRY_correspondenceLOSS_2_CV_S(average_intensities);
    
    AXISofSYMMETRY_distance_1=AXISofSYMMETRY_distanceLOSS_1_CV_S(average_intensities);
    
    AXISofSYMMETRY_distance_2=AXISofSYMMETRY_distanceLOSS_2_CV_S(average_intensities);
    
    AXISofSYMMETRY_distance_3=AXISofSYMMETRY_distanceLOSS_3_CV_S(average_intensities);
    
    SCATTERofROWaverages_AXESofSYMMETRY_I_G([1:length(average_intensities)]',average_intensities,...
        AXISofSYMMETRY_correspondence_1,AXISofSYMMETRY_correspondence_2,AXISofSYMMETRY_distance_1,AXISofSYMMETRY_distance_2,...
        AXISofSYMMETRY_distance_3,[output_folder input_directory(i,1).name(1:end-4)]); 
   
    
end



end