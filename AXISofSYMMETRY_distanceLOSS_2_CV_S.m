

function    output                                                                                                                                                                                                                          =...
            AXISofSYMMETRY_distanceLOSS_2_CV_S                                                                                                                                                                                                                   (...
            input                                                                                                                                                                                                                               )
%%  Description                                                                                                                                                                                            



%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%   
%   Inputs                                                                                                                                                                                     %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       A column vector


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%   Outputs                                                                                                                                                                                    %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       An integer (the index of the estimated axis of symmetry)


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%   Description                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

%       Distance loss is used to estimate the axis of symmetry on the input interferogram:

%           - Choices are limited, from both sides until after intensity has risen 3/4 of the way to its
%             maximum value (to counter pathologies).

%           - For each location considered, points are mirrored across the axis and the minimum weighted
%             distance to the nearest point, within a neighborhood of chosen size, is considered loss.
%
%           - The axis location is estimated as minimizing this loss, and when not unique the greatest 
%             intensity is favored.

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





%%  Options for the algorithm and loss calculation                                                                                                                                                         


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Bound choices, from both sides, until after intensity has risen this fraction of the way to its                                                                                           %
%    maximum value (to avoid pathologies).                                                                                                                                                     %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

intensity_bound=0.75;


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Allow mirror points to be considered as mirror candidates within a ball of this radius of the                                                                                             %
%    theoretical mirrored point                                                                                                                                                                %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

neighborhood_radius=50;


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Of points involved in calculating the loss for a particular location, only consider those                                                                                                 %
%    residing in this percentage of the outskirts                                                                                                                                              %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

window_constant=1;


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Weight the contributions to the loss function                                                                                                                                             %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

position_weight=1;

intensity_weight=1;


%%  Select an axis of symmetry                                                                                                                                                                             


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Bound choices, from both sides, according to the parameter set above.                                                                                                                     %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%

bound  =  intensity_bound*(max(input)-min(input))+min(input);

lower_bound  =  max([100,find(input>bound,1)]);

upper_bound  =  min([1948,length(input)-find(flipud(input)>bound,1)+1]);


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Fix a possible location, i, for an axis of symmetry.  For each point (i+j) where the theoretical                                                                                          %
%    mirror (i-j) exists                                                                                                                                                                       %
%                                                                                                                                                                                              %
%       - Consider (i+j) mirrored across an axis at i                                                                                                                                          %
%       - Calculate the weighted Euclidean distances between this hypothetical mirror and the measured                                                                                         %
%         points in a neighborhood of (i-j) [this radius is chosen above]                                                                                                                      %
%       - Consider the minimum of these distances as point (i+j)'s contribution to axis i's loss                                                                                               %
%                                                                                                                                                                                              %
%    The average of these losses over all such (i+j), hense to the right of i, will then be                                                                                                    %
%    considered as the loss for this axis location.                                                                                                                                            %
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%        
       

for i=lower_bound:upper_bound    
    
    
    distance_i_to_exterior=min(i-1,length(input)-i);
    
    axis_i_loss=0;
    
        
        for j=max([1,ceil((1-window_constant)*distance_i_to_exterior)]):distance_i_to_exterior
           
            
            mirror_theoretical=i-j;
            
            lower_neighborhood_bound=max([mirror_theoretical-neighborhood_radius,1]);
            
            upper_neighborhood_bound=min([mirror_theoretical+neighborhood_radius,i]);
            
            
                        
            position_differences=...
                ([lower_neighborhood_bound:upper_neighborhood_bound]-mirror_theoretical)';
                
            intensity_differences=...
                input(lower_neighborhood_bound:upper_neighborhood_bound,1)-input(i+j,1);
                
            
            losses_in_mirroring_j=(position_weight*position_differences.^2+...
                                   intensity_weight*intensity_differences.^2).^.5;
            
            axis_i_loss=axis_i_loss+min(losses_in_mirroring_j);
        
            
        end
    
    axes_losses(i,1)=axis_i_loss/distance_i_to_exterior;
    
end


%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 
%    Find where the loss is minimized.  If the locations not unique, choose based on the greatest                                                                                              %
%    intensity.                                                                                                                                                                                %  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------% 

axes_losses(axes_losses<=0)=inf;

[indices,~]=find(axes_losses==min(axes_losses));


if length(indices)==1
    
    output=indices;
    
else
    
    for i=1:length(indices(:,1))
        
        indices(i,2)=input(i,1);
    
    end
        
    [index,~]=find(indices(:,2)==max(indices(:,2)));
    
    output=indices(index,1);

end
    


end
