function transform_stl(input_stl, output_stl, T)
%% moving an STL based on a matrix

STL_to_be_moved = stlread(input_stl);

[total_rows, total_columns] = size(STL_to_be_moved.Points);

New_points = [];
for (c = 1:total_rows)
    Moved_point = (T*[STL_to_be_moved.Points(c,:),1]')';
    New_points = [New_points; Moved_point(1:3)];
end
    
TR = triangulation(STL_to_be_moved.ConnectivityList(:,:), New_points);
stlwrite(TR, output_stl);

end
