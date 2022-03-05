

function    FOURIERtransform_CSVs_Is                                                                                                                                                                                                                             
                                                                                                                                                                                                                               
                                                                                                                                                                                                                                          
%%  Description                                                                                                                                                                                            



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       The locations of the interferograms to be transformed, an Excel file containing:

%           - their file names
%           - the locations of their centers
%           - the distance from the center for which a good signal was measured
%
%       and an output location for graphs to be saved (these locations are set manually below).


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       Input to the program

%       FOURIERtransform_I_I


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Description                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       This program imports the interferogram, performs background correction, and collects the data
%       pertaining to the estimated axes of symmetry and the distance from this that a good signal was
%       measured.  This information is then input into the program

%       FOURIERtransform_I_I

%       which performs the transform numerically (all the options for transform processing are set inside
%       this intermediate program).  The results are then sent to

%       FOURIERtransform_amplitudes_I_G          or            FOURIERtransform_COMPLEXvalues_I_G

%       to produce the graphing of the calculated spectra.

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





%%  Set the locations for input and output                                                                                                                                                                 


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Set the location of the measured interferograms and the output folder                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

interferogram_folder=INTERFEROGRAMS_ST;

output_folder=FOURIERtransform_OUTPUTfolder_ST;

input_directory=dir([interferogram_folder '*.csv']);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Set the location of the Excel file containing the interferogram files names, their center, and                                                                                            %
%    the distances from the center where a good signal was measured.                                                                                                                           %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

selected_interferogram_info_XLSX=INTERFEROGRAMS_SELECTEDforFOURIERtransform_ST;


%%  Fourier Transform each file indicated                                                                                                                                                                  



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Get the list of files selected for Fourier Transform along with the information on their centers                                                                                          %
%    and distances from which a good signal was measured.                                                                                                                                      %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

selected_interferogram_info=readcell(selected_interferogram_info_XLSX,'Range','A6:C56');

selected_centers_and_distances=cell2mat(selected_interferogram_info(:,2:3));

selected_filenames=selected_interferogram_info(:,1);

clear selected_interferogram_info


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Set the background initially to zero                                                                                                                                                      %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

background=0;



for i=1:length(input_directory(:,1))    
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    If this is a background measurement, set it as such until a new background measurement takes its                                                                                          %
%    place and move on to the next sample.                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
    
    input_name=input_directory(i,1).name;

    
    split_name=split(input_name,'.');
    
    
    if strcmp(split_name{7,1},'background')
        
        average_intensities=readmatrix(strcat(interferogram_folder,input_name),'Range',[2 2]);
        
        background=mean(average_intensities,2);
        
        continue
    
    end

    clear split_name


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    If this input wasn't selected for Fourier Transform, skip it and move on                                                                                                                  %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
     
    if ~ismember(input_name(1:end-4),selected_filenames)
        
        continue
    
    end
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Otherwise, find its index in the slected list                                                                                                                                             %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
    [~,selected_index]=ismember(input_name(1:end-4),selected_filenames);
    
    
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Make a background correction, setting negative values to zero, and proceed with the transform                                                                                             %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

    average_intensities=readmatrix(strcat(interferogram_folder,input_name),'Range',[2 2]);
    
    average_intensities=mean(average_intensities,2);
    
    average_intensities=average_intensities-background;
    
    
    FOURIERtransform_I_I(average_intensities,selected_centers_and_distances(selected_index,1),...
        selected_centers_and_distances(selected_index,2),...
        [output_folder selected_filenames{selected_index,1}]);

    
end



end